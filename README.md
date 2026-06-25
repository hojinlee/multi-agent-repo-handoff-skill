# Multi-Agent Repo Handoff Skill

A Codex skill for setting up GitHub-based handoff workflows in repositories shared by multiple coding agents, such as Codex, Claude Code, local workers, cloud workers, or temporary review agents.

The goal is simple: a new worker should be able to continue from GitHub and repo documents without needing chat history or local uncommitted state.

## What It Adds

- A stable branch model: `main` plus `<worker-name>-wip` branches.
- Worker onboarding docs for Codex, Claude Code, and temporary workers.
- Safe session scripts:
  - `scripts/handoff_check.sh`
  - `scripts/start_worker.sh`
  - `scripts/end_session.sh`
- GitHub PR and issue templates.
- GitHub Actions CI template.
- Starter docs for operating model, handoff, and worker onboarding.

## Install

Copy the skill folder into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills
cp -R multi-agent-repo-handoff ~/.codex/skills/
```

Restart Codex so the skill is discovered.

## Use

Ask Codex:

```text
Use the multi-agent-repo-handoff skill to set up this repository for multiple coding agents working through GitHub.
```

Codex should inspect the repository, merge the templates with existing project-specific instructions, and avoid overwriting domain docs.

## Public Safety Defaults

The generated workflow is intentionally conservative:

- `main` is stable and should not receive direct feature work.
- Each worker gets a dedicated `<worker-name>-wip` branch.
- Commit and push are explicit, not automatic.
- The scripts block `.env`, raw data, processed data, and reports from being tracked or staged.
- Live/production actions are not assumed and must be explicitly requested in the target project.

## Repository Layout

```text
multi-agent-repo-handoff/
├── SKILL.md
├── agents/openai.yaml
├── references/
│   ├── branch-model.md
│   └── worker-onboarding.md
└── assets/
    ├── CLAUDE.md
    ├── docs/
    ├── github/
    └── scripts/
```

## Relationship To Existing GitHub Skills

This skill is complementary to GitHub-oriented skills that publish a PR or handle CI failures. It focuses on scaffolding the operating model that makes multiple agent workers safe over time.

## License

MIT. See `LICENSE`.
