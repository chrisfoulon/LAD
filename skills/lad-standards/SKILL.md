---
name: lad-standards
description: Code quality standards and known-lapse guardrails for Python work — docstring style, lint and coverage targets, component-appropriate testing strategy, test-data honesty, commit conventions, documentation structure, and token-efficient command patterns. Use when writing or reviewing Python code, choosing a testing approach, structuring documentation, or running long-output commands.
user-invocable: false
---

# LAD standards

Standing conventions for Python work. These apply throughout a task, not once at the start.

## Code style

- **Docstrings**: NumPy style on every public function and class — Parameters / Returns / Raises.
  Private helpers need one line, not a full block.
- **Lint**: flake8 clean, `max-complexity = 10`. A function that trips the complexity limit wants
  splitting, not a `# noqa`.
- **Coverage**: 90% for new code. A target for code you add, not a gate to retrofit onto the repo.

## Testing strategy — match the approach to the component

Most likely to be got wrong by defaulting to "mock everything":

| Component | Approach | What gets mocked |
|---|---|---|
| API endpoints, web services | **Integration** — import the real app | Only external deps: DB, network, filesystem |
| Business logic, algorithms | **Unit** — full isolation | Everything outside the unit |
| Data processing, utilities | **Unit** with fixtures | Minimal; prefer real test data |

For APIs, routing/validation/serialisation are part of what you are building, so mocking the
framework tests nothing. For pure logic the opposite holds.

Write the failing test first. The point is confirming the test *can* fail; a test written after the
code often cannot.

### Test data: do not invent what the real data looks like

The most damaging test failure mode in this work is not a broken test — it is a passing test built
on fabricated data. Plausible-looking arrays with invented shapes, ranges or distributions produce a
green suite that proves nothing, and the problem surfaces later against real inputs.

**When you cannot write a meaningful test because you do not know what real data looks like, stop
and say so.** Do not fill the gap with assumptions. Ask instead:

- "Do you have a real example I can derive a fixture from?"
- "What does a realistic input look like here — ranges, shape, edge cases that actually occur?"
- "What would a *wrong* result look like to you?" — often more informative than the correct one.

Synthetic data derived from a real sample is good practice; synthetic data derived from a guess is
not. If you must proceed without a sample, mark the fixture explicitly as assumed and flag it in
your report rather than letting it pass silently as verified.

This applies with particular force to scientific and analysis code, where an invented distribution
can make a statistically wrong implementation look correct.

## Documentation structure

Documentation is written at three levels, so a reader can stop at the depth they need:

1. **Plain summary** — what it does, in prose, no jargon.
2. **API table** — Symbol / Purpose / Inputs / Outputs / Side effects.
3. **Walk-through** — annotated code for the parts that are genuinely non-obvious.

Levels 2 and 3 go in `<details><summary>` blocks so the page stays readable. For MkDocs Material
projects, follow [`references/mkdocs-material.md`](references/mkdocs-material.md) — it covers the
formatting rules that silently break rendering (blank lines after headers, table formatting,
progressive-disclosure syntax).

### User-facing docs and developer docs are separate trees

Where a project separates them (`docs/` published to users, `dev-docs/` for contributors and
sessions working on the code), respect the split and follow the existing convention rather than
imposing one. The test for which tree something belongs in: *could someone outside the project
reasonably need this?* If yes it is user-facing; if it only makes sense to someone changing this
codebase, it is developer-facing.

Developer docs are for **intent** — why the code is like this, what was rejected, what is planned.
They are not for mirroring what the code already states. An architecture overview written in prose
drifts out of date and then misleads more confidently than having none, because it reads as
authoritative. Where a code-graph tool indexes the project, prefer querying it for structure and
keep the written docs to the reasoning a graph cannot hold.

## Commits

Conventional Commits: `feat(scope): description`, `fix(scope): ...`, `refactor(scope): ...`.
Body lists what changed as bullets. Never commit with the test suite red.

## Communication

Measured and objective, not enthusiastic:

- State problems directly. "This approach has significant limitations", not a hedge.
- Say what you cannot verify. "I cannot confirm this works without X" beats "this should be fine".
- Challenge the premise when it deserves challenging, including the user's.
- Present trade-offs rather than endorsements. Accuracy over reassurance.
- Skip "brilliant", "excellent", "perfect". If something is a good idea, saying why is enough.

## Long-running commands

For anything over ~2 minutes (installs, builds, full test suites, data processing), output volume
can eat a large share of the context window. Capture the signal, keep the rest on disk:

```bash
<command> 2>&1 | tee full_output.txt \
  | grep -iE "(warning|error|failed|exception|fatal|critical)" | tail -n 30
echo "--- FINAL OUTPUT ---"; tail -n 100 full_output.txt
```

This catches problems from anywhere in the stream, not just the tail, while keeping the full log
available. For ordinary test runs, `2>&1 | tail -n 100` is enough. Targeted single-test runs
(`pytest -xvs path::test`) need no redirection at all.

## Known lapses

Before writing or reviewing Python, read [`references/guardrails.md`](references/guardrails.md) —
a registry of failure modes actually observed in this work.

That file is meant to change. Add an entry when a mistake recurs, using the documented format.
Propose retiring entries that stop appearing, rather than letting the list grow forever.
