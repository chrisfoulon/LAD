---
name: feature-kickoff
description: First stage of the LAD feature workflow. Clarifies the request, searches the codebase for work that already does the job, decides whether to integrate/enhance/rebuild, locates the relevant code and documentation as concrete references, and records a quality baseline before any code is written. Use at the start of any non-trivial feature, or when asked to add functionality to an existing Python project.
argument-hint: [feature description]
---

# Feature kickoff

Feature request: **$ARGUMENTS**

The goal of this stage is to *not* start building yet. Its value is entirely in what it prevents:
building a second implementation of something that already exists, starting from an unknown baseline
so regressions cannot be told apart from pre-existing failures, and handing the next stage a prose
summary it has to re-derive from scratch.

**The output of this stage is references, not description.** "The tool does X and we want to add Y"
is worth very little. `src/cli/commands.py:142 build_parser()` is worth a great deal. Every claim
you record should be something the next stage can open.

## 1. State the requirement, in writing, before looking at any code

This comes first for a reason. If you explore the codebase before the requirement is pinned down,
the requirement quietly reshapes itself around what is convenient to build: you extend the existing
writer, it only handles the single-target case, and single-target ships as "done". Nobody decided
that. It happened because there was no written statement to check against.

Answer all of these. **Stop and ask if you cannot.**

- **Behaviour** — what specifically should be true when this is done?
- **Inputs / outputs** — what goes in, what comes out?
- **Constraints** — what must it not break, exceed, or assume?
- **Acceptance criteria** — what would make it *not* complete?

Vague requests ("add an API", "make it faster") produce plans that look complete and satisfy nobody.
One round of questions is cheaper than a wrong implementation.

**Keep this technology-free.** This is the *what* and *why*, not the *how*. No module names, no
libraries, no file paths — those are decisions for later, and mixing them in here is how an
implementation detail gets promoted to a requirement without anyone noticing.

Derive a short kebab-case `<slug>`, then **write the requirement to `<docs>/<slug>/context.md`
now**, before step 2. See the template in step 6; fill in the Request section and leave the rest.

> Discovery in the next step may change the **approach**. It must not change the **goal**. If what
> you find genuinely means the requirement was wrong, say so explicitly and re-agree it with the
> user — never silently narrow it to fit what already exists.

## 2. Find what already exists — as resolvable references

**If the project is indexed in a code-graph tool** (for example `codebase-memory-mcp`), use it
first. It gives qualified names, call chains and dependents directly, which is exactly what the next
stage needs and what grep only approximates:

- search for symbols matching the feature's vocabulary
- trace callers and callees of anything that looks like an existing implementation
- pull the architecture overview for the subsystem you are touching

Check whether the project is indexed before assuming either way; if it is not, indexing it may be
worth doing once, but do not block on it.

**Otherwise, or to fill gaps**, use Grep/Glob over: the feature's keywords plus the domain
vocabulary the codebase actually uses (which is often not the vocabulary in the request), existing
endpoints/services/models/utilities in the area, and test files — which frequently reveal
functionality the source layout hides.

Record every finding as `path:line` or a qualified name. **Verify each one resolves** before writing
it down — a reference that does not open is worse than no reference, because the next stage will
trust it.

"Nothing exists" is a valid finding, but it must be the conclusion of a search. Say what you searched
for, so the negative result can be judged.

## 3. Locate the documentation surface

If the feature touches something documented — a CLI, a public API, a config format, a user-facing
workflow — find where that documentation lives and record the paths.

This is cheap here and expensive later. A later stage that knows the CLI reference is at
`docs/cli/commands.md` and generated from `src/cli/` can read the full contract in one go; one that
does not will fall back to running `--help` and get a partial, differently-worded view of it.

Look for: `docs/` pages covering the area, README sections, docstrings that are the real reference
for a public API, generated-docs config (`mkdocs.yml`, Sphinx `conf.py`) that reveals what is
published and from where, and any changelog that records how the area evolved.

Note where documentation will need *updating* too — that becomes a task in the plan rather than an
afterthought at the end.

## 4. Decide the integration strategy

| Existing implementation | Covers the requirement | Do this |
|---|---|---|
| Production-ready, tested | 80%+ | **Integrate** — build on it |
| Production-ready, tested | 50–80% | **Enhance** — extend it |
| Production-ready, tested | <50% | **Assess** — extension vs new, on cost |
| Prototype / incomplete | 50%+ | **Enhance** — finish it |
| Prototype / incomplete | <50% | **Build new** — carry over the lessons |
| Poor quality, untested | any | **Rebuild** — do not build on unstable ground |
| Conflicts with the requirement | any | **Build new + deprecation plan** |
| Nothing found | — | **Build new** |

State the decision and the reason in one or two sentences. If it is *Build new* while something
related exists, say explicitly how the two will coexist and which one callers should use — otherwise
the codebase acquires two ways to do one thing and no record of why.

## 5. Establish the baseline

Without this, any later failure is ambiguous. Record actual numbers:

```bash
pytest -q --tb=no 2>&1 | tail -n 5     # test count, and what already fails
flake8 --statistics 2>&1 | tail -n 20  # existing violations
git status --short && git branch --show-current
```

Note pre-existing failures explicitly. They are not yours, and you need to be able to prove that
later. If the working tree is dirty or you are on the default branch, say so — feature work belongs
on `feat/<slug>`.

If `.flake8` or `.coveragerc` is missing, mention it, but do not scaffold project-wide config as a
side effect of starting a feature unless asked.

## 6. Complete the context file

**Use the project's existing convention for development docs.** Many projects already have one —
`dev-docs/`, `doc/`, `notes/`. Check before creating anything, and follow what is there; only fall
back to `docs/<slug>/` when the project has no convention. Below, `<docs>` means whichever applies.

The Request section was written in step 1. Fill in the rest now — and if anything in discovery
changed the Request, flag the change rather than editing it silently.

`<docs>/<slug>/context.md`:

```markdown
# Context — <slug>

## Request
**Behaviour**: <what should be true when this is done>
**Inputs / outputs**: <what goes in, what comes out>
**Constraints**: <what it must not break, exceed, or assume>
**Acceptance criteria**: <what would make this not complete>

<written before discovery; technology-free. Changes after this point are re-agreed, not assumed.>

## Strategy
<Integrate|Enhance|Build new|Rebuild> — <why, in one or two sentences>

## Relevant code
| Symbol | Location | What it does | Relevance to this feature |
|---|---|---|---|
| `build_parser()` | `src/cli/commands.py:142` | Constructs the argparse tree | New subcommand registers here |

## Relevant documentation
| Document | Location | Covers | Needs updating |
|---|---|---|---|
| CLI reference | `docs/cli/commands.md` | All subcommands, generated from `src/cli/` | Yes — new subcommand |

## Searched but not found
<what you looked for that turned up nothing — so the negative result is reviewable>

## Baseline
Tests: <N passing, M failing (pre-existing)> · flake8: <N violations> · Branch: <name>
```

Keep it to what the next stage needs. This file is working state, not a deliverable — it gets
condensed into `docs/decisions/<slug>.md` at the end and pruned.

## Next

Report the strategy decision and baseline, then hand off to `/lad:plan-feature`. Do not begin
implementing. If discovery changed what the feature should be, raise that now — redirecting here is
far cheaper than after a plan exists.
