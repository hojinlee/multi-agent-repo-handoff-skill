# Worker Agent Onboarding

## Branches

- Use `main` only for stable integrated results.
- Use `<worker-name>-wip` for each worker.
- Do not let two workers share a WIP branch concurrently.

## Start A Worker

```bash
git status --short --branch
git pull --ff-only
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
2. WORKLOG.md
3. TODO.md
4. docs/OPERATING_MODEL.md
5. docs/HANDOFF.md
6. docs/WORKER_ONBOARDING.md
7. Project-specific architecture/data/test docs

Rules:
- Do not work directly on main.
- Do not commit secrets, raw data, generated reports, or large generated artifacts.
- Update WORKLOG.md and TODO.md after meaningful work.
- End with scripts/end_session.sh --commit -m "message" --push.
```
