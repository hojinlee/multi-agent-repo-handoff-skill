# Claude Code Instructions

This repository can be worked on by Claude Code, Codex, and other coding agents. GitHub and the repo documents are the source of truth; chat history is not.

## First Read

Read these files before changing code:

1. `AGENTS.md`
2. `WORKLOG.md`
3. `TODO.md`
4. `docs/OPERATING_MODEL.md`
5. `docs/HANDOFF.md`
6. `docs/WORKER_ONBOARDING.md`
7. Project-specific architecture, data, and test documentation.

## Claude Code Branch

Use a dedicated worker branch unless the user explicitly says otherwise.

Recommended branch:

```bash
claude-code-wip
```

Start with:

```bash
git status --short --branch
git pull --ff-only
scripts/start_worker.sh --branch claude-code-wip
```

End with:

```bash
scripts/end_session.sh --commit -m "Describe completed work" --push
```

If no files changed, run:

```bash
scripts/end_session.sh
```

## Safety

- Do not work directly on `main`.
- Do not commit `.env`, API keys, account numbers, tokens, private certificates, raw data, generated reports, or large generated artifacts.
- Do not run network/data download/live commands unless secrets are configured and the user expects it.
- Do not enable production or live operation modes without explicit user instruction.
- Respect project-specific architecture boundaries.

## Validation

Use the repository's test command and:

```bash
scripts/handoff_check.sh
```

For normal session closure, prefer `scripts/end_session.sh`.
