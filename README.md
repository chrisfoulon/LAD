# LAD — LLM-Assisted Development

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Claude Code plugin for building Python features without the usual failure modes: rebuilding
something that already exists, starting from an unknown baseline, or reaching a green test suite by
weakening the tests.

LAD is a set of skills, one per stage of the work. Claude loads them when relevant, or you invoke
them directly with `/lad:<name>`.

## Install

```bash
/plugin marketplace add chrisfoulon/LAD
/plugin install lad@lad
```

Update with `/plugin marketplace update lad`.

Nothing is copied into your project — no `.lad/` directory, no subtree to keep in sync. Skills come
from the installed plugin, so every project gets the same version and updates arrive in one place.

## The workflow

```
/lad:feature-kickoff → /lad:plan-feature → /lad:implement-feature → /lad:finalize-feature
                                                                          ↓  (after merge)
                                                                  /lad:consolidate-feature
```

| Skill | What it does |
|---|---|
| **`feature-kickoff`** | Clarifies the request, searches for work that already does the job, decides integrate/enhance/rebuild, locates the relevant code and docs as concrete references, records a quality baseline |
| **`plan-feature`** | Test-driven task breakdown, a real critical review of that plan, and a split into sub-plans when it is too large |
| **`implement-feature`** | The TDD loop, with quality gates, regression checks and periodic approval checkpoints. Resumable across sessions |
| **`finalize-feature`** | Final validation, delivered-versus-planned check, documentation, commit or PR |
| **`consolidate-feature`** | After merge: condenses the working files into one durable decision record and prunes the rest |

### A feature, start to finish

```
git checkout -b feat/export-csv

> /lad:feature-kickoff export analysis results to CSV
    first pins the requirement in writing — behaviour, inputs/outputs, constraints,
    acceptance criteria — with no technology in it, and stops to ask if any of that
    is unanswerable. Only then looks at code: finds `ResultWriter` at
    src/io/writers.py:88 already does half of it; recommends Enhance over Build new;
    records the test baseline. Writes dev-docs/export-csv/context.md

> /lad:plan-feature
    six tasks, each naming its test file; flags that no realistic sample of the
    result structure is available, as a question for you rather than an invented
    fixture. Writes plan.md

> /lad:implement-feature
    TDD loop, one task at a time. Stops every 2–3 tasks to show you the diff,
    test numbers and what is next, and waits

> /lad:finalize-feature
    full validation, checks delivered against planned, updates the docs the
    kickoff stage identified, prepares the commit

# ... review, merge ...

> /lad:consolidate-feature export-csv
    writes dev-docs/decisions/export-csv.md, indexes it, offers to prune the
    working files
```

You can also just describe what you want — Claude loads the right skill from context. Invoking
explicitly is for when you want to be sure which stage you are in.

**Resuming** is the normal case, not the exception. `/lad:implement-feature` reconstructs where it
is from the task list, the plan file and the actual state of the test suite, and treats the code as
the tiebreaker when those disagree.

Two more, used on their own:

| Skill | What it does |
|---|---|
| **`test-quality`** | Repairs a failing or unreliable suite: real baseline, root-cause classification, prioritised batches of fixes |
| **`maintenance-session`** | Technical debt triaged by actual impact, not by violation count |
| **`converge`** | Whole-codebase drift check: does the code still match what the decision records, ADRs and docs claim? Reports, does not fix |

`lad-standards` runs in the background — Claude loads it when writing Python. It holds the project's
conventions and the guardrail registry.

## What it leaves behind

During a feature: `docs/<slug>/plan.md` and `context.md`. Working state, deliberately thin.

After merge, `consolidate-feature` replaces both with `docs/decisions/<slug>.md` — what was built,
the choices and why, **the alternatives that were rejected**, deviations from plan, known
limitations — indexed in `docs/DECISIONS.md`.

That last part matters more than it looks. A future session that cannot see what was already ruled
out will propose it again, confidently. It is also what lets a `STATUS.md` stay a short statement of
the current state instead of growing into a changelog.

## The guardrail registry

`skills/lad-standards/references/guardrails.md` lists failure modes actually observed in this work —
imports moved inside functions to dodge a circular import, tests edited to match broken code, failing
tests skipped to reach green, fixtures built from invented data.

It is built to be maintained. Entries carry sighting dates and a status; `consolidate-feature`
prompts you to add new ones while the work is fresh, and there is an explicit retirement process so
the list does not grow forever. One model improving is not grounds for retirement — retire on
absence of sightings.

Add to it when you catch a mistake twice, or once with real consequences. That bar is deliberate: a
registry that grows without pruning stops being read, which is exactly how the previous version of
this framework reached 8,500 lines.

## Conventions it applies

NumPy docstrings · flake8 with `max-complexity 10` · 90% coverage on new code · Conventional Commits
· integration tests for APIs, unit tests for logic · three-level documentation (summary → API table →
walk-through).

Full detail in `skills/lad-standards/SKILL.md`.

## Requirements

Claude Code, Python 3.11+, a git repository. For the quality gates:

```bash
pip install flake8 pytest coverage
```

## Extending it

Skills are plain Markdown with YAML frontmatter, following the
[Agent Skills](https://agentskills.io) open standard. Edit them, add your own under `skills/`, or
fork the repo for project-specific variants. Keep each `SKILL.md` under ~500 lines and push detail
into `references/` — content loads only when the skill is used, so reference files cost nothing
until needed.

## License

[MIT](LICENSE.md).
