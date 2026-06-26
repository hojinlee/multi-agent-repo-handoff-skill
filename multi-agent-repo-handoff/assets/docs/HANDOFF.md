# Handoff

## Session Start

```bash
git status --short --branch
scripts/start_worker.sh --branch <worker-branch>
sed -n '1,220p' WORKLOG.md
sed -n '1,220p' TODO.md
sed -n '1,220p' docs/WORKERS.md
sed -n '1,220p' docs/OPERATING_MODEL.md
scripts/handoff_check.sh
```

`scripts/start_worker.sh` fetches remotes, fast-forwards the worker branch, runs handoff checks, and prints worker status by default. Use `--no-fetch` only for intentional offline work and record that limitation in `WORKLOG.md`.

## Session End

```bash
scripts/end_session.sh
scripts/end_session.sh --commit -m "Describe completed work" --push
```

Record completed work, failed attempts, decisions, blockers, next steps, and worker status in `WORKLOG.md` and `docs/WORKERS.md` before publishing.
