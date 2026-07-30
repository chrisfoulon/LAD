---
name: consolidate-feature
description: Final stage of the LAD feature workflow, run after a feature is merged. Condenses the working plan and context files into one durable decision record, updates the decisions index, harvests any new guardrails, and prunes the working files. Use after merging a feature, or when asked to write up what was done and why.
argument-hint: [feature slug]
---

# Consolidate feature

Run this **after the feature is merged**, not before.

Working files (`<docs>/<slug>/plan.md`, `context.md`, sub-plans) are scaffolding: detailed, quickly
stale, and worth little once the work is done. What stays valuable is much smaller — the decisions
and the reasons behind them. This stage keeps that and discards the rest.

This is what allows `STATUS.md` to remain a short statement of the *current* state rather than
accumulating history: superseded detail is retained here instead of being either lost or left to
clutter the status file.

## 1. Gather what actually happened

Do not write this from the plan alone — the plan says what was intended.

- `git log --oneline <base>..HEAD` and `git diff --stat <base>..HEAD` for the real shape of the work
- `<docs>/<slug>/plan.md` — including tasks that were dropped or added mid-flight
- `<docs>/<slug>/context.md` — particularly the deviations recorded during implementation
- Review comments, if the feature went through a PR

Where intent and outcome differ, the outcome is the record. Note the difference; it is often the
most useful line in the document.

## 2. Write `<docs>/decisions/<slug>.md`

Aim for one page. If it runs much longer, it is holding detail that belongs in the code.

```markdown
# <slug>

_Merged YYYY-MM-DD · <commit range or PR number>_

## What was built
<two or three sentences, plus the entry points a reader should open first — path:line>

## Choices made, and why
- **<decision>** — <why this and not the obvious alternative>

## Rejected alternatives
- **<option>** — <why not; what would make it right later>

## Deviations from plan
<what changed during implementation and what caused the change; "none" is a valid answer>

## Known limitations
<what it does not do, what is untested, what will need attention>
```

The **Rejected alternatives** section carries most of the long-term value. A future session that
cannot see what was already ruled out will propose it again, confidently.

Write for someone with no memory of the work — which in practice means every future session, and
you in six months.

## 3. Update the index

Add one line to `<docs>/DECISIONS.md`, newest first (create it if absent):

```markdown
# Decisions

- [<slug>](decisions/<slug>.md) — <one-line hook: what changed and why it mattered> (YYYY-MM-DD)
```

One line per feature. The index is for finding the record, not for summarising it.

## 4. Harvest guardrails

This is the natural moment to notice recurring mistakes, while the work is still fresh.

If a mistake was made and corrected during this feature — by you or caught by the user — check
whether it is worth adding to the guardrail registry in `lad-standards/references/guardrails.md`.
The bar is deliberately high: a lapse qualifies on the **second** sighting, or the first if it had
real consequences. One-off slips are noise, and a registry that grows without pruning stops being
read.

If an existing entry was observed again, update its sighting date. If entries have not been seen in
a long time, propose retiring them.

## 5. Prune

Once the record is written, propose removing the working files:

- `<docs>/<slug>/plan.md`, `context.md`, `plan_*.md`, `split.md`

**Ask before deleting.** They are recoverable from git, but the user may still want them, and
deletion is not yours to assume. If in doubt, leave them.

Also update `STATUS.md` if the project keeps one: the feature moves from in-progress to done, and
anything it settled should supersede the older lines rather than being appended below them.

## Report

Say where the record was written, what you added to the index, any guardrail changes proposed, and
what you are suggesting be pruned.
