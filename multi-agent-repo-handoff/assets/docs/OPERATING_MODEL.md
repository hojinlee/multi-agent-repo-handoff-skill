# Operating Model

## Purpose

This repository can be worked on by multiple coding workers. The goal is to make every handoff reproducible from GitHub and repository documents, without relying on chat history or local uncommitted state.

## Roles

| Role | Branch |
| --- | --- |
| Stable integrated result | `main` |
| Primary worker | `<primary-worker>-wip` |
| Secondary worker | `<secondary-worker>-wip` |
| Claude Code worker | `claude-code-wip` |
| Temporary worker | `<worker-name>-wip` |

## Source Of Truth

- GitHub is the source of truth for code and task state.
- Local chat history is not source of truth.
- Local uncommitted changes are not a handoff state.
- `docs/WORKERS.md` records worker ownership, active tasks, issue/PR links, last published state, and next safe steps.
- `WORKLOG.md` records current context, decisions, failures, and next steps.
- `TODO.md` records priority and completion state.

## Start

```bash
git status --short --branch
git pull --ff-only
scripts/worker_status.sh --fetch
scripts/handoff_check.sh
```

## End

```bash
scripts/end_session.sh
scripts/end_session.sh --commit -m "Describe completed work" --push
```

Before publishing, update `docs/WORKERS.md`, `WORKLOG.md`, and `TODO.md` so another worker can continue without chat history.

## Safety

- Do not work directly on `main`.
- Do not commit `.env`, secrets, raw data, generated reports, or large generated artifacts.
- Do not edit files owned by another active worker without explicit coordination.
- Use PRs to merge completed WIP branch work into `main`.
- Sync WIP branches from `main` after merge.
