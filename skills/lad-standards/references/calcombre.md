---
title: "Working files in a calcombre project"
---

# Working files in a calcombre project

calcombre is a review layer some projects use: their Markdown pages are served as a site where the
user reads, comments and decides. When a project uses it, LAD writes its working files so calcombre
can take them in unchanged. When it does not, LAD follows the project's own convention, as
everywhere else. The files are the same Markdown either way, so they read on GitHub and render with
`quarto preview`.

## Detect, don't depend

A project uses calcombre when its root has **`STATUS.md` and `WORKLOG.md`**, and a page folder: the
folder holding `_pages.yml`, or else `docs/` with a `_quarto.yml`.

```bash
ls STATUS.md WORKLOG.md 2>/dev/null; find . -maxdepth 3 -name _pages.yml -not -path './.git/*'
ls docs/_quarto.yml 2>/dev/null
```

All three present: apply this page, and `<docs>` in the LAD skills means that page folder. Anything
missing: ignore this page. Never create these files to make a project fit; joining calcombre is the
user's decision.

## What changes when it is there

| LAD file or habit | In a calcombre project |
|---|---|
| `<docs>/<slug>/context.md`, `plan.md`, sub-plans | Pages in the page folder. Markdown with YAML front matter: `title:` (LAD's templates already have one) and `status: current`, which calcombre's page checker requires. |
| The feature as open work | One task in `WORKLOG.md`, headed with the feature and the date it was opened, its boxes the LAD stages still to run, and a pointer to `plan.md`. The plan's own boxes stay in `plan.md`; they are not copied. The task stays whole until every box is ticked, then leaves for the done page. If a task for the work already exists, LAD adds its boxes to that task rather than opening another. |
| `STATUS.md` | Milestones and where things stand only, with pointers. No task checklists in it. |
| A question for the user that needs more than yes or no (`[USER_INPUT]`, a technical fork) | A decision block on the page it belongs to, usually `plan.md`. The options, your recommendation, and why. |
| A settled question | The block's opening line becomes `.decided`, folded, with the answer written in. The options stay visible. |
| Anything that deletes, or that the user alone can validate | An approve block. Act only once the user has approved it in calcombre; a general "ok" or a comment does not count. |
| Finished work | One or two dated lines on the done page (`done.md` in the page folder; create it with a `title:` if missing), pointing to the record rather than restating it. |
| Pruning working files after a merge | They are kept and marked superseded by the record; see "Pruning" below. |

The blocks are Pandoc fenced divs. Quarto renders them as callouts; any other Markdown viewer shows
the text plainly, so they cost nothing outside calcombre:

```markdown
::: {.callout-important .decision title="Decide: <the question, short>"}
<the question, the options, your recommendation and why>
:::

::: {.callout-note .decided collapse="true" title="Decided: <the question, short>"}
**<the option chosen>** (<date>). <the answer, and why>. <the options, as they were>
:::

::: {.callout-warning .approve title="Approve: <what, short>"}
<exactly what will be done>
:::
```

## Rules calcombre holds that LAD relies on

- **One place per fact.** A page points to another instead of restating it. A paraphrase is a second
  copy that drifts.
- **The record is added to, never rewritten.** A decision record or ADR gains entries; earlier ones
  keep their text. A correction is a new dated entry.
- **Nothing is just deleted.** Finished work leaves a dated line on the done page pointing to where
  its record is.
- **When two sources disagree, the higher one wins:** the code and its tests, then living pages,
  then `STATUS.md`, then `WORKLOG.md`, then done pages and archives.

## Pruning

In a calcombre project, `consolidate-feature` does not delete the working files (decided
2026-11-12). It keeps them where they are, so links into them and their comments still work, and
marks them finished:

- **The record is a page in the page folder** (a decision record, or an ADR page there): set
  `status: superseded` and `superseded_by: <the record's path, relative to the page folder>` in each
  working file's front matter. calcombre checks that the target exists and treats the file as
  retired.
- **The record is outside the page folder** (an ADR file such as `.codebase-memory/adr.md`):
  `superseded_by` cannot point there, so keep `status: current` and make the first line under the
  title `**Finished <YYYY-MM-DD>.** Its decisions are recorded in <path>.`
- Either way, repoint `STATUS.md` and `WORKLOG.md` to the record rather than the plan: calcombre
  flags a watched file that names a superseded page.

## Without calcombre

Nothing on this page applies: LAD follows the project's own development-docs convention. Keep the
`title:` front matter in LAD's templates, which costs nothing and lets the files render with Quarto
if the project ever adds it. Do not add a Quarto project to a project that has none.
