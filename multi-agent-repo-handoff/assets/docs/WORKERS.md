# Worker Board

## Purpose

Track the current work owned by each coding worker and the next safe step for switching or continuing work.

This file is the human-readable work board. Use `scripts/worker_status.sh` to compare it with real Git branch state.

## Active Workers

| Worker | Branch | Status | Current Task | Issue/PR | Last Published | Next Safe Step |
| --- | --- | --- | --- | --- | --- | --- |
| primary worker | `<primary-worker>-wip` | active | Current assigned work | - | - | Run `scripts/worker_status.sh --fetch`, then continue. |
| secondary worker | `<secondary-worker>-wip` | idle | No assigned work | - | - | Assign work before creating or changing branch. |
| Claude Code | `claude-code-wip` | not-created | No assigned work | - | - | Create only when Claude Code is assigned work. |
| review worker | `review-worker-wip` | not-created | No assigned work | - | - | Create only for review-only or audit work. |

## Status Values

- `active`: worker is expected to continue work on the branch.
- `idle`: branch exists but no active work is assigned.
- `blocked`: worker cannot proceed without user input, CI, secrets, or external state.
- `review`: branch is waiting for PR review or merge.
- `not-created`: branch is planned but should not be created until assigned.

## Start-Of-Session Check

```bash
git pull --ff-only
scripts/worker_status.sh --fetch
scripts/start_worker.sh --branch <worker-branch>
```

If network access is not available, omit `--fetch` and record that branch state may be stale.

## Update Rules

Update this file when:

- assigning a worker to a branch,
- changing a worker status,
- opening or merging a PR,
- handing work from one worker to another,
- marking a branch blocked or idle.
