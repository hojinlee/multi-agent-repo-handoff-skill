# Codex Continuity Prompt

```text
This repo is shared by multiple coding workers. GitHub and repo docs are the source of truth.

Repo: [GitHub repo URL]
Branch: [worker-wip branch]
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

Start:
- git status --short --branch
- git pull --ff-only
- scripts/start_worker.sh --branch [worker-wip branch]

End:
- scripts/end_session.sh --commit -m "message" --push
```
