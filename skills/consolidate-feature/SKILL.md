---
name: consolidate-feature
description: Final stage of the LAD feature workflow, run after a feature is merged. Condenses the working plan and context files into a durable record — appended to the project's existing ADR where one exists, or a new decision record where none does — harvests any new guardrails, and prunes the working files. Use after merging a feature, or when asked to write up what was done and why.
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

## 2. Find where decisions already live

**Do not create a second home for decision rationale.** Many projects already have one, and adding
a parallel tree beside it means future sessions read whichever they happen to find. Check, in order:

```bash
ls .codebase-memory/adr.md ADR.md ARCHITECTURE_DECISIONS.md 2>/dev/null
ls -d docs/adr doc/adr docs/decisions 2>/dev/null
```

Three cases, and they are handled differently:

| Found | Do |
|---|---|
| **A single ADR file** (e.g. `.codebase-memory/adr.md`) | Append a section, in that file's existing format |
| **A directory of numbered records** (`doc/adr/0004-*.md`) | Add the next numbered file, following the local naming and template |
| **Nothing** | Create `<docs>/decisions/<slug>.md` and its index, as in step 3b |

Read what is already there before writing. Match its structure and heading style rather than
imposing LAD's — a record nobody can scan alongside its neighbours is worth less than a slightly
imperfect one that reads consistently.

If `codebase-memory-mcp` is available and the project uses `.codebase-memory/adr.md`, prefer
`manage_adr` over editing the file directly, and call it with `mode: get` first to see the existing
structure. The file is tracked in git either way, so a direct edit is not wrong — it just risks
diverging from whatever shape the tool maintains.

## 3a. When an ADR exists

An ADR is organised **by decision, not by feature**. This matters: some features produce no
architecturally significant decision at all, and forcing an entry for every one is how an ADR turns
into a changelog nobody reads.

Record only what is durable and would not be obvious to someone reading the code later:

- **The choices and why** — including the constraint or trade-off that drove each
- **Alternatives rejected**, and what would make them right in future
- **Limitations and open issues** the feature introduces or leaves behind

Deliberately skip the transient parts. "What was built" is recoverable from the code and the graph;
"deviations from plan" stops mattering once the plan is gone. If nothing survives that filter, say
so and add nothing — that is a correct outcome, not a failure.

## 3b. When there is no ADR

Write `<docs>/decisions/<slug>.md`. Aim for one page. If it runs much longer, it is holding detail
that belongs in the code.

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

Then add one line to `<docs>/DECISIONS.md`, newest first (create it if absent):

```markdown
# Decisions

- [<slug>](decisions/<slug>.md) — <one-line hook: what changed and why it mattered> (YYYY-MM-DD)
```

One line per feature. The index is for finding the record, not for summarising it. An index is only
needed for the one-file-per-feature layout — a single ADR file is already its own index, and a
numbered-record directory usually has a convention of its own.

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

Say **which decision home you found and why** — an existing ADR, a numbered-record directory, or
nothing — then what you wrote there, any guardrail changes proposed, and what you suggest pruning.
If you concluded the feature warranted no ADR entry, say that explicitly; silence reads as an
oversight rather than a judgement.
