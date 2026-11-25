---
name: audit-structure
description: Read-only structural audit of one area of a codebase. Lists every place where pieces that change together are not together, or are tied without reason (hidden links, needless links, surplus, special cases), works out the few fixes behind them, and writes a decision log. Changes no code. Use when asked to untangle, restructure or assess the design of part of a codebase, before any refactor.
argument-hint: [area to audit — a package, folder or subsystem]
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git show:*), Bash(git ls-files:*), Bash(wc:*), Bash(python3 -I -c:*), mcp__codebase-memory-mcp__search_graph, mcp__codebase-memory-mcp__trace_path, mcp__codebase-memory-mcp__get_code_snippet, mcp__codebase-memory-mcp__query_graph, mcp__codebase-memory-mcp__get_architecture, mcp__codebase-memory-mcp__search_code, mcp__codebase-memory-mcp__index_status, mcp__codebase-memory-mcp__detect_changes
---

# Audit structure

Area: **$ARGUMENTS**

**This skill changes no code.** It reads, and writes one file: the decision log. No edits to source,
tests or configuration, no deletions, no commits of code. The tools listed in its front matter are
pre-approved read-only ones; anything else still asks for permission, and should not be needed.

Why read-only: a one-pass restructure of a large codebase cannot be reviewed, and its check comes at
the end, when every change is already tangled with every other. For scientific code it is worse: a
green test suite after a restructure is exactly the signal that cannot be trusted, because a changed
number passes any test that did not pin it. The diagnosis is worth having on its own. Each fix the
user accepts then goes through `/lad:feature-kickoff` as its own feature, in its own worktree.

## 0. Scope to one area

If no area was given, ask for one. A whole large codebase in one pass is not the goal; an area is a
package, a folder or a subsystem that a person could hold in mind. Note its size
(`git ls-files <area> | grep '\.py$' | xargs wc -l | tail -n 1`) and what lies just outside it that
it talks to. Problems at the boundary count; problems wholly outside it are noted in one line and
left.

## 1. Collect the evidence

Use what fits the area's size (`lad-standards`, "When the code graph is worth it"):

- **A skeleton.** Every module's classes and function signatures with the bodies stripped, so the
  whole area fits in context at once:

  ```bash
  python3 -I -c 'import ast,sys
  for p in sys.argv[1:]:
      t=ast.parse(open(p).read()); print("##",p)
      for n in ast.walk(t):
          if isinstance(n,(ast.FunctionDef,ast.AsyncFunctionDef,ast.ClassDef)):
              print(" "*n.col_offset+("class " if isinstance(n,ast.ClassDef) else "def ")+n.name, n.lineno)' $(git ls-files '<area>/*.py')
  ```

- **The code graph**, when the project is indexed and large enough: callers and callees across the
  area's boundary, functions nothing calls (dead-code candidates), and fan-out (functions that call
  many others). Check the index is fresh first. Confirm every "nothing uses this" with a grep for
  the name; the graph misses `getattr`, registries and string-built imports.
- **What imports what.** From the graph, or from the skeleton's imports. Note any stable module that
  imports a more volatile one.
- **Git co-change.** Files that change in the same commits are linked, whether the code shows it or
  not:

  ```bash
  git log --since=2.years --name-only --pretty=format:'--' \
    | python3 -I -c 'import sys,itertools,collections
  area=sys.argv[1]; c=collections.Counter()
  for l in sys.stdin.read().split("--"):
      fs=sorted({x for x in l.split() if x.endswith(".py")})
      if 1<len(fs)<15 and any(f.startswith(area) for f in fs):
          c.update(p for p in itertools.combinations(fs,2) if any(f.startswith(area) for f in p))
  [print(n,a,b) for (a,b),n in c.most_common(30)]' '<area>/'
  ```

  The log is not limited to the area on purpose: a partner outside it is a boundary link, the kind
  most likely to be hidden. Commits touching more than ~15 files are left out: they are sweeps (formatting, renames), not
  evidence of a link. Also note how often each file changes: a file that changes often is volatile.
- **Shared-state keys.** Where components pass a dict, a context or a settings object between
  them, list per file which keys it reads and which it writes (a grep for the subscript and `.get`
  forms). A key read and never written is a hidden link, and often a live bug: the reader gets its
  default every time, silently.
- **Subagent summaries**, for an area too large to read: have read-only agents summarise parts of it
  (what each module is for, what it reads from and writes to outside itself), then reason across
  the summaries.

## 2. List every problem

Ask one thing of every pair of pieces: **should these change together?** Write down every place the
code gets the answer wrong, each as `path:line` and one sentence. There are three ways to get it
wrong.

**Hidden links:** pieces that must change together, where the code does not show it.

- Copies of logic or values: change one and the others must change too, but nothing says so.
- A module that reads a global or a file set by another module.
- A feature split across folders by layer, or related code in different folders.
- A call order or convention callers just have to know.

**Needless links:** pieces tied together that change for different reasons.

- Callers that depend on internals.
- Stable code that imports something more volatile.
- A general function with a parameter only one workflow understands.
- A shallow module: its interface changes whenever its internals do.

**Surplus:** pieces with no reason of their own to change.

- Pass-through wrappers.
- Extension points and config for things that never vary.
- Dead code (confirmed by grep, not only by the graph).

Also write down every **special case**: code that exists for one situation instead of following
from how the system works. Each is a requirement the design never accounted for, so they are clues
to what the system needs to be: an `if` for one value, a parameter for one caller, a swallowed
exception, a retry or a sleep, a disabled or skipped test.

Every entry must open. Verify each `path:line` before writing it down.

## 3. Work out the fixes

Work out the fixes as if the system had known today's requirements from the start. Look for **the
one fix behind several problems**; it often looks nothing like them. Do not fix special cases one by
one.

Ask the same of every fix: pieces that change together end up together, pieces that do not are not
tied, and everything depends on what changes less.

Write each fix **above the problems it solves**. Problems no fix covers stay listed under "Not
covered", with why.

For each fix, also state:

- **What it touches**: the files, and roughly how many callers (from the graph or grep).
- **Whether it touches a numerical path**: code whose change can change a number the work reports
  or rests on (an analysis result, a statistic, a model output, a saved figure's data). If it does,
  tests are not enough to accept it: it needs a comparison of outputs before and after, against
  reference outputs. Say how this project's reference outputs are found (a regression gate, stored
  expected results, a golden-file test, a documented reference run), or say plainly that there are
  none. Look for them; do not assume either way. Then say **what they can and cannot see**: read
  the project's notes on them (its `STATUS.md`, the gate's README). A baseline known to be blind to
  a path does not check a fix on that path; say so, and say what check the fix needs instead.
- **Risk**: what goes wrong if the fix is wrong, and whether it is visible when it does.

Rank the fixes: most problems resolved for least risk first.

## 4. Have it checked by a pass that did not write it

The author of a log is the worst judge of it. Before handing it over, have a fresh read-only agent
try to **refute** it, item by item: open every `path:line`, look for the writer of a key you say
nothing writes, and for each fix ask what contract it would break (public API, CLI, service
endpoints, files written to disk that other code reads back, tests that pin behaviour, modes of
running the code). Give it the swallowed-exception and special-case lists you did not finish, too.

Put its verdicts in the log as their own section (confirmed, refuted, unsure, with the evidence),
and correct the entries it refutes rather than deleting them: strike the claim and say why. A log
that has survived a refutation pass is worth acting on; one that has not is a hypothesis.

The pass can be wrong too. Re-open the cited lines yourself for every verdict that changes a bug, a
fix or a decision (each refutation, each "missed" item), and say in the log which ones you
re-checked. Checking one or two and trusting the rest makes the second reader the authority.

## 5. Write the decision log

One file, in the project's development-docs convention: `<docs>/audit-<area-slug>.md`. In a
calcombre project (`lad-standards`, "Where working files go"), that is the page folder, and the
question of which fixes to take is a decision block at the top of the page.

```markdown
---
title: "Structural audit — <area>"
status: current
date: <YYYY-MM-DD>
---

# Structural audit — <area>

_<commit audited> · <N files, M lines> · read-only; no code was changed_

## Found on the way: likely bugs
<each with `path:line`, why it looks wrong, and how to confirm it; "none" is a valid answer. A bug
is reported here and fixed as its own feature, never folded into a structural fix>

## Evidence used
<skeleton, graph (index date), co-change window, subagents; what was not available>

**"Numerical path", as used below:** <one or two sentences: code whose change can change a reported
number; fixes on it need an output comparison, not only tests>

## Reference outputs
<how this project's outputs are compared before and after a change, or "none found", with where
you looked; then what they can and cannot see>

## Verification
<the refutation pass's verdict per item: confirmed / refuted / unsure, with evidence>

## Fixes
- **<fix, one sentence: what changes and why it removes the problems below>**
  Touches: <files, callers>. Numerical path: <yes, compare against … / no>. Risk: <…>.
  - `path:line` <problem>
  - `path:line` <problem>

## Not covered
- `path:line` <problem> — <why no fix here>

## Outside the area
- <one line each>
```

Do not sort problems by kind in the log; the kinds are for finding them. The log is read fix by fix.

## Report

Give the path to the log, any likely bugs first, the number of fixes and problems, the top three
fixes in one line each, and whether reference outputs exist. Then stop. Each fix the user accepts is its own feature,
started with `/lad:feature-kickoff` in a worktree, with the log entry as its request. Do not begin
any of them here.

---

Adapted from `untangle-codebase` (https://github.com/caldoai/skills, `skills/untangle-codebase`,
file as of commit `442c299`), MIT licence, copyright (c) 2026 Maze; full notice in
[`LICENSE-untangle-codebase`](LICENSE-untangle-codebase). Kept: its problem kinds, special cases as
clues, fixes written above their problems, its tips and decision-log format. Left out: its options to
remove comments and tests, the fix-everything step and its loop. Added: read-only scope to one area,
the code graph, git co-change scripts, and the reference-output check for numerical code.
