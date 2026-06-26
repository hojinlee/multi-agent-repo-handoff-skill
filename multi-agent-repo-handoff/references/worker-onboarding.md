# Worker Onboarding Reference

## New Worker Flow

Use this when adding Claude Code, another local coding agent, a review worker, or a temporary cloud worker.

Start:

```bash
git status --short --branch
scripts/start_worker.sh --branch <worker-name>-wip
```

End:

```bash
scripts/end_session.sh --commit -m "Describe completed work" --push
```

## Required Reading List

Generic worker reading order:

1. `AGENTS.md`
2. Worker-specific entrypoint such as `CLAUDE.md`
3. `WORKLOG.md`
4. `TODO.md`
5. `docs/WORKERS.md`
6. `docs/OPERATING_MODEL.md`
7. `docs/HANDOFF.md`
8. `docs/WORKER_ONBOARDING.md`
9. Project-specific architecture/data/test docs

## Worker Prompt Template

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
9. project-specific architecture/data/test docs

Start:
- git status --short --branch
- scripts/start_worker.sh --branch [worker-wip branch]

Rules:
- Do not work directly on main.
- Do not commit secrets, raw data, generated reports, or large generated artifacts.
- `start_worker.sh` fetches remotes and fast-forwards the worker branch by default.
- Check `docs/WORKERS.md` before changing files owned by another active worker.
- Update WORKLOG.md, TODO.md, and docs/WORKERS.md after meaningful work.
- End with scripts/end_session.sh --commit -m "message" --push.

Current goal:
[current goal]

Next safe step:
[next command or task]
```

## Claude Code

Create `CLAUDE.md` at repo root. Keep it short and point it to repo docs. Claude Code-specific branch default: `claude-code-wip`.
