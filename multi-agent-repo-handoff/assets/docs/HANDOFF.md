# Handoff

## Session Start

```bash
git status --short --branch
git pull --ff-only
sed -n '1,220p' WORKLOG.md
sed -n '1,220p' TODO.md
sed -n '1,220p' docs/OPERATING_MODEL.md
scripts/handoff_check.sh
```

If network access is unavailable, skip `git pull --ff-only` and record that limitation in `WORKLOG.md`.

## Session End

```bash
scripts/end_session.sh
scripts/end_session.sh --commit -m "Describe completed work" --push
```

Record completed work, failed attempts, decisions, blockers, and next steps in `WORKLOG.md` before publishing.
