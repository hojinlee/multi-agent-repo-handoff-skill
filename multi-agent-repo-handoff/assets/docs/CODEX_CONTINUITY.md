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
4. docs/WORKERS.md
5. docs/OPERATING_MODEL.md
6. docs/HANDOFF.md
7. docs/WORKER_ONBOARDING.md
8. Project-specific architecture/data/test docs

Start:
- git status --short --branch
- scripts/start_worker.sh --branch [worker-wip branch]

`start_worker.sh` fetches remotes and fast-forwards the worker branch by default.

End:
- update docs/WORKERS.md, WORKLOG.md, and TODO.md
- scripts/end_session.sh --commit -m "message" --push
```
