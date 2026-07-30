---
name: finalize-feature
description: Fourth stage of the LAD feature workflow. Runs final quality validation, checks that what was delivered matches what was planned, updates documentation, and prepares the commit or pull request. Use when a feature's implementation is complete and ready to be reviewed or merged.
argument-hint: [feature slug]
---

# Finalize feature

The purpose of this stage is to find the gap between what you believe you built and what is actually
in the diff. Assume there is one.

## 1. Validate

```bash
pytest -q --tb=short 2>&1 | tail -n 100
pytest --cov=<module> --cov-report=term-missing 2>&1 | tail -n 40
flake8 --statistics
```

Against the kickoff baseline:

- All tests passing, or every remaining failure explained and pre-existing
- Coverage ≥90% on new code — and check *what* is uncovered, not just the number. A high percentage
  with the error paths untested is a poor result wearing a good number.
- flake8 clean; complexity within limit
- No new violations relative to baseline

## 2. Check delivery against plan

Walk the plan and verify each ticked box against the code, not against memory:

- Does every acceptance criterion have working behaviour behind it, and can you point at it?
- Any `TODO`, `pass`, `NotImplementedError` or placeholder left in the diff?
- Anything built that was *not* planned? That is fine, but it needs recording — unplanned work is
  invisible to everyone reading the plan afterwards.
- Anything planned that was quietly dropped? Say so explicitly. A silently abandoned task is the
  single most common way a feature ships incomplete.

Read the actual diff: `git diff --stat` then review the substantive files. Reviewing your own work
from memory finds nothing.

## 3. Review the code

- NumPy docstrings on new public functions and classes
- Naming that reflects what things do now, not what they did in an earlier draft
- Error handling that fails loudly rather than returning a plausible wrong value
- No debugging remnants — stray prints, commented-out blocks, temp files
- A last pass against the guardrail registry in `lad-standards`

## 4. Update documentation

Update what the kickoff stage identified as needing it — that list exists precisely so this step is
not guesswork:

- API tables and reference docs for new or changed public interfaces
- README, if usage or installation changed
- CHANGELOG, if the project keeps one
- Docstrings that are the real reference for a public API

Verify examples actually run. A documentation example that was never executed is usually wrong.

## 5. Note the maintenance you did not do

If implementation surfaced issues you deliberately left alone — pre-existing violations, adjacent
technical debt, refactors that were out of scope — record them rather than dropping them. Append to
`MAINTENANCE_REGISTRY.md` if the project has one, and mention them in your report so the user can
decide whether to spend time on them via `/lad:maintenance-session`.

## 6. Commit or open the PR

Conventional Commit, describing what changed and why:

```
feat(<slug>): <what it does now that it did not before>

- <change>
- <change>

Tests: <N> passing (<M> new). Coverage: <X>% on new code.
```

Do not put invented figures in commit messages. If you cannot measure something, leave it out.

Open the PR only if asked. Never merge without being asked.

## Report

State plainly: what was built, quality numbers, anything deferred or dropped, and known limitations.
If something is incomplete, say it here — a finalization report that claims completeness while the
diff disagrees is worse than no report.

After the feature is merged, run `/lad:consolidate-feature` to condense the working files into a
durable record.
