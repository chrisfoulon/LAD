---
name: maintenance-session
description: Focused technical-debt reduction — triage lint violations and code smells by actual impact, fix them in batched, tested increments, and record what was deliberately deferred. Use when asked to clean up code quality, reduce technical debt, address lint violations, or work through a maintenance backlog.
argument-hint: [path or area, optional]
---

# Maintenance session

Dedicated time for debt that feature work keeps stepping over. The failure mode to avoid is spending
it all on whitespace because whitespace is easy to fix and easy to count.

## 1. Triage by impact, not by count

```bash
flake8 --statistics 2>&1 | tail -n 30
```

Sort what comes back:

| Impact | Codes | Why it matters |
|---|---|---|
| **High** | F821 undefined name, F811 redefinition, syntax errors | These are usually live bugs, not style issues |
| **Medium** | E722 bare except, F841 unused variable, mutable defaults | Hide errors or signal a misunderstanding |
| **Low** | E501 line length, W293 whitespace, import order | Cosmetic. Real, but not why you are here |

Start at the top. An F821 is a `NameError` waiting for the right input; fixing two hundred long
lines while it sits there is motion, not progress.

Read `MAINTENANCE_REGISTRY.md` if the project keeps one — earlier sessions may already have
triaged and deferred things, with reasons worth respecting.

## 2. Know the impact before changing anything

**If the project is indexed in a code-graph tool** (for example `codebase-memory-mcp`) and is large
enough to need it (`lad-standards`, "When the code graph is worth it"), use it first. It gives the
impact of a change directly, which grep only approximates:

- trace the callers of anything you are about to change, so you know what a fix can break
- list dead code in the area: a function nothing calls is removed or deferred, not cleaned up
- look at fan-out: a function calling many others is where a small change spreads furthest

**Otherwise, or to fill gaps**, grep for the name across the repository, tests included.

The graph misses dynamic dispatch, `getattr`, plugin registries and string-built imports. Before
removing anything as dead, grep for its name; a hit in a registry or a config file means it is
live.

## 3. Work file by file

Complete one file before moving on. Batching by file rather than by violation type keeps each change
reviewable and each test run meaningful.

Per file:

```bash
flake8 <file>                      # what is actually there
# ... apply fixes ...
flake8 <file>                      # confirm cleared
pytest -q tests/<related> 2>&1 | tail -n 20
```

**Fix only what you understand.** An unused variable may be a leftover, or it may be a symptom of a
half-finished code path — those need different treatment. If a violation is not obviously safe to
fix, leave it and note why. Guessing at a fix in unfamiliar code is how a maintenance session
introduces the bug it was meant to remove.

Files without test coverage carry more risk: a maintenance change there is unverifiable. Either add
a test first or leave the file alone and record it.

Commit in logical groups (`fix: address bare excepts in <area>`), not one enormous sweep. If
something breaks, small commits make it obvious which change did it.

## 4. Know when to stop

Check in when the picture changes:

- The work turns out to be much larger than it looked
- A "cleanup" needs a behaviour change to do properly — that is a feature decision, not maintenance
- Something looks like a real bug rather than a smell. Report it; do not quietly fix it inside a
  cleanup commit where nobody will notice it
- A change touches a critical path with thin test coverage

## 5. Record what you did not do

Anything deliberately deferred goes in `MAINTENANCE_REGISTRY.md` with the reason:

```markdown
## Deferred
- `path/file.py:142` — F841 unused `result`; may be an unfinished code path, needs the author's
  intent. Deferred 2026-07-30.
```

A deferred item with a reason is a decision. An undocumented one just gets rediscovered and
re-triaged by the next session.

## Report

Before-and-after violation counts by impact tier, which files changed, what was deferred and why,
and anything found that looks like a genuine bug rather than a style issue. Report the tiers
separately — a headline number that mixes two hundred whitespace fixes with one F821 tells the user
nothing about what actually improved.
