# Branch Model Reference

## Default Model

Use GitHub as source of truth and keep `main` stable.

Recommended branches:

| Purpose | Branch |
| --- | --- |
| Stable integrated result | `main` |
| Primary local worker | `<primary-worker>-wip` |
| Secondary local worker | `<secondary-worker>-wip` |
| Claude Code | `claude-code-wip` |
| Temporary worker | `<worker-name>-wip` |

Rules:

- No direct feature work on `main`.
- Each worker uses one WIP branch.
- Two workers do not edit the same WIP branch concurrently.
- Incomplete transferable work is committed as WIP and pushed.
- Completed work opens a PR from WIP branch to `main`.
- After merge, WIP branches are resynced from `main`.

## Commit/Push Policy

For seamless handoff, the end state must exist on GitHub.

End-of-session default:

```bash
scripts/end_session.sh --commit -m "Describe completed work" --push
```

Use plain `scripts/end_session.sh` when only checking or when there are no changes.

## PR Policy

A PR should include:

- Summary.
- Scope and out-of-scope.
- Validation commands and results.
- Handoff notes.
- Confirmation that secrets/raw data/generated reports are not included.

## Branch Protection Recommendation

If the user can configure repository settings, recommend:

- Protect `main`.
- Require PR before merge.
- Require CI green before merge.
- Disallow force push to `main`.
