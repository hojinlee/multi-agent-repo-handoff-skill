# Worker Agent Onboarding

## Branches

- Use `main` only for stable integrated results.
- Use `<worker-name>-wip` for each worker.
- Do not let two workers share a WIP branch concurrently.
- Record every worker's status in `docs/WORKERS.md`.

## Start A Worker

```bash
git status --short --branch
git pull --ff-only
scripts/worker_status.sh --fetch
scripts/start_worker.sh --branch <worker-name>-wip
```

## Worker Prompt

```text
This repo is shared by multiple coding workers. GitHub and repo docs are the source of truth.

Repo: [GitHub repo URL]
Worker name: [worker name]
Worker branch: [worker-wip branch]
Issue/PR: [issue or PR URL]
Last commit: [commit SHA]

First read:
1. AGENTS.md
2. [worker entrypoint, e.g. CLAUDE.md]
3. WORKLOG.md
4. TODO.md
5. docs/WORKERS.md
6. docs/OPERATING_MODEL.md
7. docs/HANDOFF.md
8. docs/WORKER_ONBOARDING.md
9. Project-specific architecture/data/test docs

Start:
- git status --short --branch
- git pull --ff-only
- scripts/worker_status.sh --fetch
- scripts/start_worker.sh --branch [worker-wip branch]

Rules:
- Do not work directly on main.
- Do not commit secrets, raw data, generated reports, or large generated artifacts.
- Check `docs/WORKERS.md` before changing files owned by another active worker.
- Update WORKLOG.md, TODO.md, and docs/WORKERS.md after meaningful work.
- End with scripts/end_session.sh --commit -m "message" --push.
```
