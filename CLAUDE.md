# Claude Code Instructions

This repository may be worked on by multiple coding agents. GitHub and repository documents are the source of truth; chat history and local uncommitted changes are not.

## First Read

Before changing code, read:

1. `AGENTS.md`
2. `WORKLOG.md`
3. `TODO.md`
4. `docs/OPERATING_MODEL.md`
5. `docs/HANDOFF.md`
6. `docs/WORKER_ONBOARDING.md`
7. Project-specific architecture, data, and test documentation.

## Branch Rules

- Do not work directly on `main`.
- Use a dedicated `<worker-name>-wip` branch.
- Do not let two workers share a WIP branch concurrently.
- Completed work should go to `main` through a PR.

## Start

```bash
git status --short --branch
git pull --ff-only
scripts/start_worker.sh --branch <worker-name>-wip
```

## End

```bash
scripts/end_session.sh --commit -m "Describe completed work" --push
```

If there are no changes, run:

```bash
scripts/end_session.sh
```

## Safety

- Do not commit `.env`, API keys, account numbers, tokens, private certificates, raw data, generated reports, or large generated artifacts.
- Do not run network/data download/live/production commands unless secrets are configured and the user explicitly expects it.
- Update `WORKLOG.md` and `TODO.md` after meaningful work.
- If validation fails, record the exact command and failure before handoff.

## Claude Code Default

Recommended worker branch: `claude-code-wip`.
