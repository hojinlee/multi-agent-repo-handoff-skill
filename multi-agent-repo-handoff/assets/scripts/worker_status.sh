#!/usr/bin/env sh
set -eu

fetch_remote=false

usage() {
  cat <<'USAGE'
Usage: scripts/worker_status.sh [--fetch]

Shows the worker board from docs/WORKERS.md and compares main/*-wip branches.
Use --fetch when network access is available and fresh remote state is needed.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --fetch)
      fetch_remote=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

if [ "$fetch_remote" = true ]; then
  git fetch --all --prune
fi

echo "== Worker board =="
if [ -f docs/WORKERS.md ]; then
  awk '
    index($0, "| Worker |") == 1 { printing = 1 }
    printing && index($0, "|") == 1 { print }
    printing && index($0, "|") != 1 { exit }
  ' docs/WORKERS.md
else
  echo "WARN docs/WORKERS.md missing"
fi

echo
echo "== Branch status =="

if git show-ref --verify --quiet refs/remotes/origin/main; then
  main_ref=origin/main
elif git show-ref --verify --quiet refs/heads/main; then
  main_ref=main
else
  main_ref=""
fi

{
  git for-each-ref --format='%(refname:short)' refs/heads
  git for-each-ref --format='%(refname:short)' refs/remotes/origin | sed 's#^origin/##'
} | grep -E '^(main|.*-wip)$' | sort -u | while IFS= read -r branch_name; do
  [ -n "$branch_name" ] || continue

  if git show-ref --verify --quiet "refs/heads/$branch_name"; then
    ref=$branch_name
    local_marker="local"
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
    ref=origin/$branch_name
    local_marker="remote"
  else
    continue
  fi

  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name "$branch_name@{u}" 2>/dev/null || true)
  if [ -z "$upstream" ] && git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
    upstream=origin/$branch_name
  fi

  main_delta="main:n/a"
  if [ -n "$main_ref" ] && [ "$ref" != "$main_ref" ]; then
    counts=$(git rev-list --left-right --count "$main_ref...$ref" 2>/dev/null || echo "0 0")
    behind_main=$(printf "%s" "$counts" | awk '{print $1}')
    ahead_main=$(printf "%s" "$counts" | awk '{print $2}')
    main_delta="main:+$ahead_main/-$behind_main"
  fi

  upstream_delta="upstream:n/a"
  if [ -n "$upstream" ] && git rev-parse --verify --quiet "$upstream" >/dev/null; then
    counts=$(git rev-list --left-right --count "$upstream...$ref" 2>/dev/null || echo "0 0")
    behind_upstream=$(printf "%s" "$counts" | awk '{print $1}')
    ahead_upstream=$(printf "%s" "$counts" | awk '{print $2}')
    upstream_delta="upstream:+$ahead_upstream/-$behind_upstream"
  fi

  last_commit=$(git log -1 --format='%h %cr %s' "$ref" 2>/dev/null || echo "no commits")
  printf "%-24s %-8s %-18s %-18s %s\\n" "$branch_name" "$local_marker" "$main_delta" "$upstream_delta" "$last_commit"
done
