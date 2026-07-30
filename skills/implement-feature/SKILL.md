---
name: implement-feature
description: Third stage of the LAD feature workflow. Runs the test-driven implementation loop against the plan, with quality gates, regression checks, and periodic checkpoints for user approval. Resumable — detects where previous sessions stopped. Use when implementing a planned feature, or when asked to continue or resume implementation work.
argument-hint: [feature slug]
---

# Implement feature

Read [`lad-standards`](../lad-standards/SKILL.md) and its guardrail registry before writing code.
The lapses in it are the ones that look reasonable while you are making them.

## Resuming

This stage is designed to be interrupted. On entry, work out where you are before doing anything:

1. `TaskList` — what is pending, in progress, done?
2. `<docs>/<slug>/plan.md` (or the current `plan_<n>_<name>.md`) — which boxes are ticked?
3. `pytest -q --tb=no 2>&1 | tail -n 5` — what is the suite's actual state right now?

Where the task list and the plan file disagree, the code is the tiebreaker: check what exists before
trusting either. If the suite is red on entry, find out whether those failures are yours from a
previous session or pre-existing per the kickoff baseline — and say which, before continuing.

## Before touching anything: verify the context

The context file is a previous session's understanding, not ground truth. Before relying on a claim
in it, check it: open the `path:line` references, confirm the symbols exist, try the import. This
takes seconds and prevents building on something that moved or was never there.

If the context or the requirement turns out to be unclear, stop and ask rather than picking an
interpretation. State what you found, what is ambiguous, and what the candidate readings are.

## The loop

For each task, in order.

### 1. Write the failing test first

Pick the approach by component type (see `lad-standards`): integration for APIs, unit for logic.

Run it and **confirm it fails**, for the right reason. A test that passes before the implementation
exists is testing nothing.

**If you cannot write a meaningful test because you do not know what real input looks like, stop and
ask** for a sample to derive a fixture from. Do not invent plausible data, and do not silently
retreat into heavier mocking — a green suite built on a guessed fixture is worse than an absent
test, because it reads as verified. (Guardrail G009.)

### 2. Implement the minimum that passes

Only what the current failing test requires. Resist adjacent improvements — they belong in the plan
or in `/lad:maintenance-session`, not smuggled into this diff.

NumPy docstrings on new public functions and classes as you go, not afterwards.

If you hit a genuine technical fork — architecture, error-handling philosophy, sync vs async, an
interface that will be hard to change later — stop and put it to the user with the options, the
trade-offs, and your recommendation. Use `AskUserQuestion` when the options are discrete.

### 3. Validate

```bash
pytest -xvs <test_file>::<test_function>     # the new test now passes
pytest -q tests/<affected_area>              # nothing adjacent broke
flake8 <modified_files>
```

Then verify the thing actually works, which the tests alone do not prove: import the new component,
call it, look at the result. For a CLI, run it. For an endpoint, hit it.

### 4. Guard against regressions

Full suite: `pytest -q --tb=short 2>&1 | tail -n 100`, compared against the kickoff baseline.

**Before a change with broad reach** — shared utilities, core algorithms, anything with many callers
— commit the working state first as an explicit rollback point, and map the blast radius:

```bash
grep -rn "<symbol>" --include="*.py" . | head -20   # who calls this
grep -rn "<symbol>" docs/ README.md 2>/dev/null     # what documents it
```

If a code-graph tool is available, use it instead — dependents and call chains directly are more
reliable than grep. Risk scales with reach: a test fixture change needs the local tests; a change to
a core function needs the full suite plus a check that the documented behaviour still holds.

### 5. Record progress

- `TaskUpdate` the task to completed
- Tick the box in `plan.md`
- Update `<docs>/<slug>/context.md` with **what was actually built** — real signatures, working import
  paths, tested usage. Where it deviates from the plan, say so and why. The gap between planned and
  actual is exactly what the next session needs and the plan file will not tell it.

## Checkpoints

Every 2–3 tasks, at a sub-plan boundary, or before any breaking change, stop and check in.

Show, concretely:

- what got done, per task
- test status, lint status, coverage — real numbers, not adjectives
- `git diff --stat`
- what is next

Then ask how to proceed — approve and commit, pause for review, request changes, or move to the next
sub-plan. `AskUserQuestion` suits this well. **Wait for the answer.** The checkpoint exists because
an agent's judgement that things are going fine is precisely what needs external verification; a
checkpoint you answer yourself is not a checkpoint.

On approval, commit with a Conventional Commit message describing what changed. Never commit a red
suite.

## When something breaks

1. Classify: caused by this change, exposed by it, or unrelated?
2. Prefer keeping backward compatibility. Failing that, update callers comprehensively. Failing
   that, revert and reconsider the approach — reverting is cheap here and expensive later.
3. Fix one failure at a time. Batched fixes make it unclear which one worked.
4. Do not make a failing test pass by weakening it. See guardrails G002 and G003.

## Done

When every task is complete, the suite is green and quality gates pass, hand off to
`/lad:finalize-feature`.
