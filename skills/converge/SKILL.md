---
name: converge
description: Assess whether the codebase still matches what the project says about itself — decision records, ADRs, documentation and unfinished plans. Reports drift and leftover work without fixing it. Use when picking up a project after time away, when you suspect the docs no longer describe reality, or when asked what state a codebase is actually in.
argument-hint: [area or subsystem, optional]
---

# Converge

Every other LAD stage looks at one feature. This one looks at the whole thing and asks a single
question: **does the codebase still match what the project claims about itself?**

Drift is not a failure of discipline, it is what happens by default. Features get abandoned
halfway, decisions get quietly superseded, documentation describes the version before last. None of
that shows up as a failing test. It shows up as a session — human or agent — confidently acting on
something that stopped being true months ago.

This stage **reports**. It does not fix. Fixing without deciding what is worth fixing is how a
review turns into an unplanned refactor.

## 1. Collect what the project claims

Whichever of these exist:

- `<docs>/decisions/` records and `<docs>/DECISIONS.md`
- `.codebase-memory/adr.md` or any other ADR file
- `STATUS.md` — particularly anything it describes as current
- `README.md` and user-facing docs, for claimed behaviour and usage examples
- `<docs>/<slug>/plan.md` files still carrying unticked boxes
- `MAINTENANCE_REGISTRY.md` deferrals

If the project records nothing, say so and stop. There is no drift to measure against nothing, and
the useful output is "start recording decisions", not a fabricated audit.

## 2. Check each claim against the code

For each substantive claim, verify rather than assume. A code-graph tool is the right instrument
here if the project has one — but **check it is not stale first**. A graph indexed before a large
refactor reports deleted symbols with total confidence, which is worse than no graph. Re-index, or
fall back to Grep and Read.

Look for:

- **Decisions that no longer hold.** A record says the system does X; the code does Y. Either the
  decision was superseded without a record, or the implementation drifted from it. Both matter, and
  which one it is changes what you do about it.
- **Documented behaviour that is not real.** Usage examples that would fail if run, CLI flags that
  no longer exist, API signatures that changed. Run the examples where you can — an example nobody
  has executed since it was written is usually wrong.
- **Abandoned work.** Unticked plan boxes with no corresponding code; code with no corresponding
  plan; `TODO`, `FIXME`, `NotImplementedError`, `pass` in non-abstract methods.
- **Orphans.** Modules nothing imports, tests nothing runs, config for removed features, fixtures
  pointing at paths that no longer exist.
- **Claims in `STATUS.md` that have quietly become history** — the most common one, because a status
  file is only as current as the last person who remembered it.

## 3. Report, ranked by what it costs to leave alone

Rank by consequence, not by count:

- **Actively misleading** — a decision record or doc that would cause a future session to do the
  wrong thing confidently. This is the worst category and usually the smallest. Fix these first.
- **Unfinished** — real work started and abandoned. Say what state it is in and what finishing
  would take, so it can be scheduled or deliberately dropped.
- **Stale but harmless** — out-of-date detail nobody acts on. Note it; do not spend a session on it.

For each item: what the project claims, what the code does, and a one-line note on which is
probably right. Be honest when you cannot tell — "the record says X, the code does Y, I cannot tell
which was intended" is a genuinely useful finding and an invitation for the user to decide.

## 4. Hand back decisions, not edits

End with a short list of what is worth doing, and ask. Typical outcomes:

- Correct a decision record or ADR that has gone wrong — cheap and high value
- Finish, or formally drop, an abandoned piece of work
- Update `STATUS.md` so it describes the present again
- Feed a cluster of related problems into `/lad:maintenance-session` or `/lad:test-quality`
- Note something as a known limitation and move on — a legitimate answer

Do not start fixing during this stage. The point is to make the state of things visible; deciding
what to do about it is the user's, and it is usually a different session's work.
