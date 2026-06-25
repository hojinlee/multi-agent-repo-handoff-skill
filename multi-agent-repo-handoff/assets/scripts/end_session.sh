#!/usr/bin/env sh
set -eu

run_tests=true
commit_changes=false
push_changes=false
commit_message=""

usage() {
  cat <<'USAGE'
Usage: scripts/end_session.sh [--no-tests] [--commit -m "message"] [--push]

Runs the standard end-of-session checks. Commit and push are explicit.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-tests) run_tests=false; shift ;;
    --commit) commit_changes=true; shift ;;
    --push) push_changes=true; shift ;;
    -m|--message)
      [ "$#" -ge 2 ] || { echo "ERROR: $1 requires a commit message" >&2; exit 2; }
      commit_message=$2
      shift 2
      ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

branch_name=$(git branch --show-current 2>/dev/null || true)
if [ "$branch_name" = "main" ] && [ "$commit_changes" = true ]; then
  echo "ERROR: refusing to commit directly on main" >&2
  exit 1
fi
[ "$push_changes" != true ] || [ "$commit_changes" = true ] || { echo "ERROR: --push requires --commit" >&2; exit 2; }
[ "$commit_changes" != true ] || [ -n "$commit_message" ] || { echo "ERROR: --commit requires -m "message"" >&2; exit 2; }

echo "== End session =="
echo "Branch: ${branch_name:-detached}"

if [ "$run_tests" = true ]; then
  scripts/handoff_check.sh --run-tests
else
  scripts/handoff_check.sh
fi

sensitive_pattern='^(\.env$|data/raw/|data/processed/|reports/)'
tracked_sensitive=$(git ls-files | grep -E "$sensitive_pattern" || true)
if [ -n "$tracked_sensitive" ]; then
  echo "ERROR: sensitive or generated paths are tracked by Git:" >&2
  echo "$tracked_sensitive" >&2
  exit 1
fi

status_output=$(git status --short)
if [ -z "$status_output" ]; then
  echo "Working tree clean. Nothing to commit."
  exit 0
fi

echo "Working tree changes:"
echo "$status_output"

if [ "$commit_changes" != true ]; then
  echo "Checks complete. Re-run with --commit -m "message" --push to publish."
  exit 0
fi

git add -A
staged_sensitive=$(git diff --cached --name-only | grep -E "$sensitive_pattern" || true)
if [ -n "$staged_sensitive" ]; then
  git reset -- $staged_sensitive >/dev/null 2>&1 || true
  echo "ERROR: refused to stage sensitive or generated paths:" >&2
  echo "$staged_sensitive" >&2
  exit 1
fi

git commit -m "$commit_message"
if [ "$push_changes" = true ]; then
  git push
fi

echo "End session complete."
