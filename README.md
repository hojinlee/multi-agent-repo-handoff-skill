# Multi-Agent Repo Handoff

A multi-agent handoff toolkit for GitHub-based repository continuity across Codex, Claude Code, GitHub Copilot, Cursor, Windsurf, Cline, OpenCode, and other coding agents.

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
- Agent-specific entrypoints for several coding tools.

## Supported Entrypoints

| Agent/tool | Entrypoint in this repo |
| --- | --- |
| Codex skill | `multi-agent-repo-handoff/SKILL.md` |
| Codex project instructions | `AGENTS.md` |
| Codex plugin metadata | `.codex-plugin/plugin.json` |
| Claude Code | `CLAUDE.md` |
| Claude plugin metadata | `.claude-plugin/plugin.json` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Cursor | `.cursor/rules/multi-agent-repo-handoff.mdc` |
| Windsurf | `.windsurf/rules/multi-agent-repo-handoff.md` |
| Cline | `.clinerules` |
| OpenCode | `.opencode/AGENTS.md` |
| Generic agent rules | `.agents/rules/multi-agent-repo-handoff.md` |

## Install For Codex

Copy the skill folder into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills
cp -R multi-agent-repo-handoff ~/.codex/skills/
```

Restart Codex so the skill is discovered.

Then ask Codex:

```text
Use the multi-agent-repo-handoff skill to set up this repository for multiple coding agents working through GitHub.
```

## Use Without Installing A Skill

Copy the relevant entrypoint and assets into a target repository:

```bash
cp AGENTS.md /path/to/repo/AGENTS.md
cp CLAUDE.md /path/to/repo/CLAUDE.md
cp -R multi-agent-repo-handoff/assets/scripts /path/to/repo/scripts
cp -R multi-agent-repo-handoff/assets/docs/* /path/to/repo/docs/
cp -R multi-agent-repo-handoff/assets/github/* /path/to/repo/.github/
```

Then adapt project-specific test commands, data paths, and safety constraints.

## Public Safety Defaults

The generated workflow is intentionally conservative:

- `main` is stable and should not receive direct feature work.
- Each worker gets a dedicated `<worker-name>-wip` branch.
- Commit and push are explicit, not automatic.
- The scripts block `.env`, raw data, processed data, and reports from being tracked or staged.
- Live/production actions are not assumed and must be explicitly requested in the target project.

## Repository Layout

```text
.
├── AGENTS.md
├── CLAUDE.md
├── .agents/rules/
├── .claude-plugin/
├── .codex-plugin/
├── .cursor/rules/
├── .github/
├── .opencode/
├── .windsurf/rules/
├── .clinerules
└── multi-agent-repo-handoff/
    ├── SKILL.md
    ├── agents/openai.yaml
    ├── references/
    └── assets/
```

## Relationship To GitHub Publishing Skills

This toolkit is complementary to GitHub-oriented skills that publish a PR or handle CI failures. It focuses on scaffolding the operating model that makes multiple agent workers safe over time.

## License

MIT. See `LICENSE`.
