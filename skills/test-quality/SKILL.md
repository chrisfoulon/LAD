---
name: test-quality
description: Systematically improve a failing or unreliable test suite. Runs the suite in chunks to get a real baseline, classifies failures by root cause, finds the shared causes behind clusters of failures, and fixes them in prioritised batches with regression checks between rounds. Use when many tests fail, when a suite is flaky or slow, or when asked to improve test quality or coverage.
argument-hint: [test path or area, optional]
---

# Test quality

Read the guardrail registry in [`lad-standards`](../lad-standards/SKILL.md) before starting. Three
entries govern this work and are easy to violate while believing you are making progress: **G002**
(never edit a test to match broken code), **G003** (never skip or delete a failing test to reach
green), **G009** (never invent what real data looks like).

The measure of success here is *meaningful* passes. A suite driven to green by weakening assertions
is worse than the failing suite it replaced, because it no longer tells anyone anything.

## 1. Get a real baseline

Large suites time out or flood the context. Run in chunks and keep the detail on disk:

```bash
pytest tests/<area>/ -q --tb=short 2>&1 | tee -a baseline.txt | tail -n 20
```

Work directory by directory or marker by marker. Record, per area: passed, failed, errored, skipped,
and how long it took. Note tests that fail *intermittently* — a flaky test is a different problem
from a broken one and mixing them wastes a cycle.

Report the real numbers before proposing anything. If the suite cannot even be collected
(`pytest --collect-only` errors), that is the first thing to fix — everything else is unmeasurable
until it is.

## 2. Classify every failure by root cause

Aggregate first, diagnose second. Looking at failures one at a time hides the fact that thirty of
them share one cause.

| Class | Looks like | Usually fixed by |
|---|---|---|
| **Infrastructure** | Import errors, missing deps, environment | One config or packaging fix, often clearing many failures |
| **API compatibility** | Signature/interface mismatch after a refactor | Updating callers, or the test's expectations if the interface change was intended |
| **Test design** | Brittle assertions, order dependence, over-mocking | Rewriting the test to assert on behaviour |
| **Configuration** | Paths, fixtures, services, settings | Fixture or conftest correction |
| **Coverage gap** | Passes, but the real path is untested | New tests, not fixes |

For each failure, record the class and the specific cause. Then look across them: which modules,
fixtures or imports recur? **A single fix that clears a cluster is worth more than several that each
clear one**, and that is only visible after aggregating.

## 3. Prioritise

Rank by consequence, then by effort:

- **P1** — wrong results, silent data corruption, security. Anything where a passing test would hide
  a real defect. Fix regardless of effort.
- **P2** — broken functionality users hit, plus quick wins that unblock other failures.
- **P3** — real but contained; genuine coverage gaps.
- **P4** — cosmetic, or tests whose value does not justify the work.

For research and analysis code, correctness of results outranks everything. A failing test in a
statistical path is not the same kind of problem as a failing test in a log formatter, and treating
them as one queue is how the wrong thing gets fixed first.

## 4. Fix in cycles

Work in small rounds — plan a batch, implement, verify, then decide with the user. Register the
batch with `TaskCreate` so an interrupted session can resume.

**Per round:**

1. **Plan** — pick a batch: one shared root cause, or several genuinely independent fixes. State the
   expected effect ("should clear ~12 failures in `tests/io/`"). Batch things that interact; keep
   risky changes alone.
2. **Implement** — commit a rollback point before anything with reach. For each fix, establish
   whether the *test* or the *code* is wrong before touching either. If the code is wrong, fix the
   code — the failing test was correct and is doing its job.
3. **Check** — rerun the affected area, then the full suite. Confirm the expected failures cleared
   *and* nothing else broke. Compare against the baseline, not against the last run.
4. **Decide** — report honestly (what cleared, what did not, what surfaced) and ask how to proceed:
   continue with the next batch, change approach, shift to coverage, or stop here. Use
   `AskUserQuestion`. Do not answer this yourself.

If a round makes things worse, revert to the rollback point rather than patching forward.

## 5. When a test is genuinely not worth fixing

Sometimes the right answer is to skip or delete a test. That is a decision to be argued, not a way
to make a number look better. Before proposing it, answer:

- What did this test protect against, and is that risk now covered elsewhere?
- Is it failing because the behaviour it asserts is genuinely obsolete, or because the current code
  disagrees with it? (Only the first justifies removal.)
- If it is flaky: is the flakiness in the test, or is it revealing a real race in the code?

A skip needs a reason and a date in the code (`@pytest.mark.skip(reason="...")`). Record the
decision in your report so it is visible rather than buried in a diff.

Do not benchmark the suite against invented industry pass rates. The question is not "does 87% match
a standard" but "is anything still failing that would let a real defect through". A suite with three
known, documented, accepted failures is in better shape than one at 100% with the hard tests deleted.

## 6. Coverage, if asked

Coverage is a separate exercise from fixing failures — do it after the suite is trustworthy, not
alongside. Target the uncovered paths that matter: error handling, boundaries, the branches where
being wrong is expensive. Chasing a percentage produces tests that execute lines without asserting
anything useful.

## Report

Baseline versus current, per area. What was fixed and what the root causes were. What remains, with
the reason. Anything skipped or deleted, with justification. Do not present a percentage as an
achievement without saying what is behind it.
