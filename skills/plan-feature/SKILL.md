---
name: plan-feature
description: Second stage of the LAD feature workflow. Turns the kickoff context into a test-driven task plan, reviews that plan critically for gaps and risks, and splits it into sub-plans when it is too large to hold in one pass. Use after feature-kickoff, or when asked to plan an implementation before writing code.
argument-hint: [feature slug]
---

# Plan feature

Read `<docs>/<slug>/context.md` first. If it does not exist, run `/lad:feature-kickoff` instead —
planning without knowing what already exists is how duplicate implementations get built.

Three things happen here, in order: draft the plan, review it critically, then decide whether it is
too big. Do not skip the review because you wrote the plan yourself; the point is to catch what the
drafting pass assumed.

## 1. Draft the task breakdown

**Every task names the test that proves it.** A task without a test is a task without a definition
of done.

Structure tasks so each one is independently completable and verifiable:

```markdown
- [ ] 1. <task> ║ `tests/<slug>/test_<n>.py` ║ <what it delivers> ║ S/M/L
  - [ ] 1.1 <specific implementation step>
  - [ ] 1.2 <specific implementation step>
```

Sizing: **S** = under an hour, **M** = a focused session, **L** = should probably be two tasks.

Carry forward from context:

- **Integration strategy** — if kickoff decided *Enhance*, the tasks extend named existing
  components (by `path:line`); if *Build new*, there is a task for coexistence and one for the
  deprecation path.
- **Documentation** — the doc surface kickoff located becomes real tasks: setup/install changes,
  user-facing behaviour, breaking changes, new public APIs. Documentation written at the end is
  documentation that does not get written.
- **References** — tasks point at `path:line` or qualified names, not descriptions. The
  implementation stage should never have to re-find what kickoff already found.

Mark tasks needing a decision from the user with `[USER_INPUT]` and say what the decision is.

Register the tasks with `TaskCreate` so progress survives across sessions, and write the same
breakdown to `<docs>/<slug>/plan.md` — the file is what you check off and read later; the task list is
what keeps the current session honest.

## 2. Review the plan critically

Answer these plainly. "Yes" to everything on a first draft usually means the review was not real.

- **Completeness** — does every acceptance criterion map to at least one task? What behaviour is
  described in the request but not covered by any task?
- **Sequencing** — does anything depend on something scheduled after it?
- **Testing strategy** — is each component tested the right way (integration for APIs, unit for
  logic — see `lad-standards`)? Which tests would still pass if the implementation were wrong?
- **Test data** — for each test, do you actually know what realistic input looks like? Where you do
  not, that is a `[USER_INPUT]` task asking for a sample, **not** a licence to invent a fixture.
- **Risk** — concurrency, security, performance, data loss. What is the worst outcome of each task
  and is it reversible?
- **Feasibility** — are the resources, dependencies and interfaces the plan assumes actually
  present? Verify the ones you are unsure of rather than assuming.

Record what the review changed in the plan itself, under a `## Review notes` heading — including
issues you considered and deliberately accepted, with the reason. A reviewed plan that looks
identical to the draft is indistinguishable from an unreviewed one.

## 3. Decide whether to split

Split when **more than ~6–8 tasks**, **more than ~25–30 sub-tasks**, or the work **spans clearly
separate domains**. Below that, splitting adds ceremony without benefit.

Split along architectural boundaries, not by counting to six:

- Foundation (models, schema, core services) → Domain logic → Interface (API, CLI, UI) → Hardening
  (security, performance, deployment)
- Each sub-plan should produce something the next one consumes
- Cross-dependencies between sub-plans should be few and one-directional

When splitting, create `<docs>/<slug>/plan_<n>_<name>.md` per sub-plan plus
`<docs>/<slug>/split.md` recording the sequence, the rationale, and what each phase hands the next.

**Context evolution matters more than the split itself.** As each sub-plan completes, the next one's
context is updated with what was *actually built* — real interfaces, working import paths, tested
usage — not what was planned. That update is what makes a later sub-plan able to build on an earlier
one instead of guessing at it.

## Output

Report: the task count, the split decision and why, any `[USER_INPUT]` items needing an answer
before implementation starts, and anything the review changed.

Then hand off to `/lad:implement-feature`. If there are unresolved `[USER_INPUT]` items, raise them
now — a decision made mid-implementation costs more than one made here.
