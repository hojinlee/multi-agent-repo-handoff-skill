---
name: multi-agent-repo-handoff
description: Set up or update a GitHub-based operating model for repositories shared by multiple coding agents such as Codex, Claude Code, local workers, cloud workers, or temporary review agents. Use when the user wants seamless handoff across machines or agents, WIP branch conventions, agent onboarding docs, CLAUDE.md/AGENTS.md guidance, commit/push end-of-session workflows, GitHub PR/Issue templates, CI checks, or safe worker branch automation.
---

# Multi-Agent Repo Handoff

Use this skill to make a repository safe for multiple coding agents to share through GitHub without relying on chat history or local uncommitted state.

## Core Workflow

1. Inspect the repo state:
   - `git status --short --branch`
   - `git remote -v`
   - existing docs such as `AGENTS.md`, `CLAUDE.md`, `WORKLOG.md`, `TODO.md`, `.github/`, and `docs/`.
2. Choose the branch model from `references/branch-model.md`.
3. Add or update worker onboarding docs using `references/worker-onboarding.md`.
4. Copy scripts from `assets/scripts/` if equivalent scripts do not already exist.
5. Copy GitHub templates and CI from `assets/github/` when the repo uses GitHub.
6. Copy starter docs from `assets/docs/` only when the repo lacks equivalent docs; otherwise merge the relevant sections.
7. Update existing agent entrypoints instead of replacing project-specific instructions.
8. Validate with the repo test command and the generated handoff scripts.
9. Commit and push on the appropriate WIP branch when cross-agent continuity is required.

## Files To Prefer

For a generic repo, create or update these files:

- `AGENTS.md`: primary Codex/agent instructions.
- `CLAUDE.md`: Claude Code entrypoint when Claude Code may work on the repo.
- `WORKLOG.md`: current context, decisions, failures, next steps.
- `TODO.md`: task queue and completion state.
- `docs/OPERATING_MODEL.md`: branch, commit, push, PR, CI, and safety rules.
- `docs/HANDOFF.md`: start/end session commands.
- `docs/WORKER_ONBOARDING.md`: instructions for new workers.
- `docs/CODEX_CONTINUITY.md`: copy-paste prompt for Codex-like workers.
- `scripts/handoff_check.sh`: safe local state inspection.
- `scripts/start_worker.sh`: switch/create worker branch.
- `scripts/end_session.sh`: test/check/optional commit/push session closure.
- `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/task.yml`, `.github/workflows/ci.yml`.

Do not overwrite repo-specific architecture, data, security, or test instructions. Merge this operating model into existing docs.

## Safety Rules

- Do not commit `.env`, API keys, account numbers, tokens, private certificates, raw data, generated reports, or large generated artifacts.
- Do not work directly on `main` unless the user explicitly requests release/merge maintenance.
- Do not run network/data download/live trading commands unless the user expects it and secrets are configured.
- Keep local uncommitted changes out of handoff. Handoff requires commit + push or a clearly documented reason not to publish.
- If tests fail, record the exact command and failure in `WORKLOG.md` before handing off.

## Resource Map

- Read `references/branch-model.md` when deciding branch names and PR flow.
- Read `references/worker-onboarding.md` when adding Claude Code or another new worker.
- Copy from `assets/scripts/` for shell automation.
- Copy from `assets/github/` for GitHub templates and CI.
- Copy from `assets/docs/` for starter docs.

## Validation

After edits, run the repo's test command and:

```bash
scripts/handoff_check.sh --run-tests
scripts/end_session.sh
```

If publishing the setup:

```bash
scripts/end_session.sh --commit -m "Add multi-agent handoff workflow" --push
```
