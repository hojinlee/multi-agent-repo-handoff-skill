#!/usr/bin/env sh
set -eu

run_tests=false

for argument in "$@"; do
  case "$argument" in
    --run-tests)
      run_tests=true
      ;;
    --help|-h)
      cat <<'USAGE'
Usage: scripts/handoff_check.sh [--run-tests]

Checks whether the repository has enough local state for another worker to continue.
It does not fetch from the network and never prints secret values.
USAGE
      exit 0
      ;;
    *)
      echo "Unknown argument: $argument" >&2
      exit 2
      ;;
  esac
done

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

echo "== Multi-agent handoff check =="
echo "Repo: $repo_root"

missing_required_file=false
for required_path in   AGENTS.md   WORKLOG.md   TODO.md   docs/HANDOFF.md   docs/OPERATING_MODEL.md   docs/WORKER_ONBOARDING.md
do
  if [ -f "$required_path" ]; then
    echo "OK required file: $required_path"
  else
    echo "ERROR missing required file: $required_path" >&2
    missing_required_file=true
  fi
done

for optional_path in CLAUDE.md docs/CODEX_CONTINUITY.md; do
  if [ -f "$optional_path" ]; then
    echo "OK optional file: $optional_path"
  else
    echo "INFO optional file missing: $optional_path"
  fi
done

branch_name=$(git branch --show-current 2>/dev/null || true)
if [ -n "$branch_name" ]; then
  echo "Branch: $branch_name"
else
  echo "WARN detached HEAD or non-branch checkout"
fi

upstream_name=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
if [ -n "$upstream_name" ]; then
  echo "Upstream: $upstream_name"
else
  echo "WARN current branch has no upstream configured"
fi

status_output=$(git status --short)
if [ -n "$status_output" ]; then
  echo "WARN working tree has local changes:"
  echo "$status_output"
else
  echo "OK working tree clean"
fi

if [ -f .env ]; then
  echo "OK local .env exists; values are not printed"
else
  echo "INFO .env missing or not used"
fi

tracked_sensitive=$(git ls-files | grep -E '^(\.env$|data/raw/|data/processed/|reports/)' || true)
if [ -n "$tracked_sensitive" ]; then
  echo "ERROR sensitive or generated paths are tracked by Git:" >&2
  echo "$tracked_sensitive" >&2
  exit 1
fi

if [ "$run_tests" = true ]; then
  if [ -f pyproject.toml ] || [ -d tests ]; then
    echo "Running default Python tests..."
    PYTHONPATH=src python3 -m unittest discover -s tests
  else
    echo "No default test command configured in handoff_check.sh; add project-specific tests."
  fi
else
  echo "Tests not run. Use: scripts/handoff_check.sh --run-tests"
fi

if [ "$missing_required_file" = true ]; then
  exit 1
fi

echo "Handoff check complete."
