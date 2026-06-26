# Handoff

## Session Start

```bash
git status --short --branch
git pull --ff-only
scripts/worker_status.sh --fetch
sed -n '1,220p' WORKLOG.md
sed -n '1,220p' TODO.md
sed -n '1,220p' docs/WORKERS.md
sed -n '1,220p' docs/OPERATING_MODEL.md
scripts/handoff_check.sh
```

If network access is unavailable, skip `git pull --ff-only` and `scripts/worker_status.sh --fetch`, then record that limitation in `WORKLOG.md`.

## Session End

```bash
scripts/end_session.sh
scripts/end_session.sh --commit -m "Describe completed work" --push
```

Record completed work, failed attempts, decisions, blockers, next steps, and worker status in `WORKLOG.md` and `docs/WORKERS.md` before publishing.
