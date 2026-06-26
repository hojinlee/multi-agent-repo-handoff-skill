#!/usr/bin/env sh
set -eu

worker_branch=""
base_ref="HEAD"
run_tests=false
sync_remote=true

usage() {
  cat <<'USAGE'
Usage: scripts/start_worker.sh --branch <worker-branch> [--base <ref>] [--run-tests] [--no-fetch]

Switches to an existing worker branch or creates it from the selected base.
By default, the script fetches all remotes and fast-forwards the worker branch
from its upstream before running handoff checks. Use --no-fetch only when
network access is unavailable or intentionally disabled.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --branch)
      [ "$#" -ge 2 ] || { echo "ERROR: --branch requires a branch name" >&2; exit 2; }
      worker_branch=$2
      shift 2
      ;;
    --base)
      [ "$#" -ge 2 ] || { echo "ERROR: --base requires a ref" >&2; exit 2; }
      base_ref=$2
      shift 2
      ;;
    --run-tests)
      run_tests=true
      shift
      ;;
    --no-fetch|--offline)
      sync_remote=false
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

[ -n "$worker_branch" ] || { echo "ERROR: --branch is required" >&2; usage >&2; exit 2; }
[ "$worker_branch" != "main" ] || { echo "ERROR: refusing to start worker directly on main" >&2; exit 1; }
case "$worker_branch" in *" "*) echo "ERROR: branch name must not contain spaces: $worker_branch" >&2; exit 2;; esac

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

current_branch=$(git branch --show-current 2>/dev/null || true)
status_output=$(git status --short)
if [ -n "$status_output" ] && [ "$current_branch" != "$worker_branch" ]; then
  echo "ERROR: working tree must be clean before switching worker branches" >&2
  echo "$status_output" >&2
  exit 1
fi

if [ "$sync_remote" = true ]; then
  echo "Fetching latest remote state..."
  git fetch --all --prune
fi

if [ "$current_branch" = "$worker_branch" ]; then
  echo "Already on worker branch: $worker_branch"
elif git show-ref --verify --quiet "refs/heads/$worker_branch"; then
  git switch "$worker_branch"
elif git show-ref --verify --quiet "refs/remotes/origin/$worker_branch"; then
  git switch --track "origin/$worker_branch"
else
  git switch -c "$worker_branch" "$base_ref"
fi

if [ "$sync_remote" = true ]; then
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
  if [ -z "$upstream" ] && git show-ref --verify --quiet "refs/remotes/origin/$worker_branch"; then
    git branch --set-upstream-to="origin/$worker_branch" "$worker_branch"
    upstream="origin/$worker_branch"
  fi

  if [ -n "$upstream" ]; then
    echo "Fast-forwarding $worker_branch from $upstream..."
    git merge --ff-only "$upstream"
  else
    echo "WARN no upstream configured for $worker_branch; fetched remotes but cannot auto fast-forward"
  fi
fi

if [ "$run_tests" = true ]; then
  scripts/handoff_check.sh --run-tests
else
  scripts/handoff_check.sh
fi

if [ -x scripts/worker_status.sh ]; then
  scripts/worker_status.sh
fi

echo "Worker branch ready: $worker_branch"
echo "Next: read docs/WORKERS.md, do focused work, then run scripts/end_session.sh --commit -m "message" --push"
