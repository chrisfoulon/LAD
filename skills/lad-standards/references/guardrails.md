# Guardrail registry

Failure modes worth actively preventing when writing Python. Each one looks locally reasonable and
is wrong in context, which is why a general instruction to "write good code" does not catch them.

**This file is designed to be edited over time.** Model behaviour changes fast; a guardrail that
mattered for one generation can be dead weight two generations later. Entries therefore carry dates
and a status, and stale ones get retired. A short list of real lapses is worth more than a long list
of plausible ones — resist the temptation to append without pruning.

## Status values

| Status | Meaning |
|---|---|
| `confirmed` | Observed in a real session in this project, with a date. |
| `seeded-unverified` | Plausible failure mode written when the registry was created. **Not** evidence of anything. Promote to `confirmed` on first real sighting; delete if it never shows up. |
| `retired` | No longer observed. Kept briefly with a retirement date, then deleted. |

## Adding an entry

Add it when a mistake is caught **twice**, or once with real consequences. One-off slips are noise.

```markdown
### G0NN — <short imperative title>

**Status**: confirmed · **First seen**: YYYY-MM-DD · **Last seen**: YYYY-MM-DD · **Seen on**: <model>

- **Symptom**: what it looks like in the diff — concrete enough to grep for.
- **Trigger**: the pressure that produces it. Nearly always a shortcut around an obstacle.
- **Do instead**: the corrective, stated as an action.
```

## Retiring an entry

Review when the registry passes ~12 entries, or after a major model upgrade. If an entry has not
been seen in six months or across two model generations, mark it `retired` with a date. Delete
retired entries after another cycle. Retiring is not a loss — git history keeps them, and a registry
nobody reads prevents nothing.

**One model improving is not grounds for retirement.** These entries were confirmed across several
assistants over 2025–2026. A lapse that a current frontier model has largely stopped making may
still be live in a smaller or older one, and the cost of keeping a stale entry is a few tokens
against the cost of a silently reintroduced bug. Retire on absence of sightings, not on the
assumption that a vendor has fixed it.

---

## Active

### G001 — Imports belong at module top

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: `import x` inside a function body rather than at module top.
- **Trigger**: a circular import. The local import makes the error disappear without addressing the
  dependency cycle that caused it.
- **Do instead**: fix the dependency direction — move the shared piece to a third module, or depend
  on an interface rather than a concrete class. A genuinely deferred import (expensive optional
  dependency, documented plugin loading) is fine, but say so in a comment.

### G002 — Never edit a test to match broken code

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: a failing assertion's expected value is changed to whatever the code currently
  returns; a test's setup is loosened until it passes.
- **Trigger**: the test is the visible obstacle, so it looks like the thing to fix.
- **Do instead**: establish which of the two is wrong before touching either. If the test encodes
  the intended behaviour, the code is the bug. If the intended behaviour genuinely changed, say so
  explicitly and change the test deliberately, not incidentally.

### G003 — Never skip or delete a failing test to reach green

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: `@pytest.mark.skip`, `xfail`, a deleted test case, or a narrowed selector that quietly
  drops the failure from the run.
- **Trigger**: a green suite reads as success, and the failure looks unrelated to the current task.
- **Do instead**: report the failure and let it stay red, or fix it. A skip is a decision with a
  reason attached and a date; a skip added to make a number look better is a lie about the suite.

### G004 — Tests must be able to fail

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: the test asserts only on mock call arguments — `mock.assert_called_with(...)` — and
  never on the behaviour the unit produces. It passes whatever the implementation does.
- **Trigger**: mocking everything is the path of least resistance for an awkward dependency.
- **Do instead**: assert on the return value or observable effect. Keep mock-call assertions for
  cases where the *call itself* is the contract, such as a side effect on an external service.

### G005 — Edit in place, do not create parallel versions

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: `module_v2.py`, `process_new()`, `ClassImproved` sitting next to the original, with
  nothing deleted and both reachable.
- **Trigger**: avoiding the risk of breaking the existing path.
- **Do instead**: change the original and rely on the tests and git to make it safe. If both really
  must exist during a migration, the old one gets a deprecation note and a removal plan in the same
  change.

### G006 — Do not swallow exceptions

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: `except Exception: pass`, or a bare `except:` that logs at debug level and continues.
- **Trigger**: making an intermittent error go away without diagnosing it.
- **Do instead**: catch the specific exception you can actually handle, and let the rest propagate.
  An error that reaches the user is better than a silent wrong answer — especially in analysis code,
  where a swallowed exception becomes a plausible-looking wrong number.

### G007 — Do not add defensive guards that hide bugs

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: unrequested `if x is None: return None` at the top of a function, or a `getattr(obj,
  'attr', default)` where the attribute should always exist.
- **Trigger**: a `None` appeared during testing and the guard made it stop.
- **Do instead**: find out why the value was `None`. If it is legitimately optional, handle it
  deliberately and document it in the docstring. If it is not, the guard converts a loud crash into
  a quiet wrong result.

### G008 — No `sys.path` manipulation

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: `sys.path.insert(0, ...)` or `sys.path.append(...)` added to make an import resolve.
- **Trigger**: running a script from a directory where the package is not importable.
- **Do instead**: fix the packaging — an editable install, a correct `pyproject.toml`, or running as
  a module with `python -m`. Path manipulation works on one machine and breaks on the next.

### G009 — Do not invent what real data looks like

**Status**: confirmed · **Seen**: 2025–2026, recurring · **Seen on**: multiple assistants

- **Symptom**: a fixture full of plausible-looking values — arrays with guessed shapes, ranges or
  distributions, invented file formats, made-up identifier schemes — with nothing tying it to a real
  sample. The test passes and proves nothing. A close relative: getting stuck trying to write a
  "real world" test, then quietly settling for heavier mocking instead of saying so.
- **Trigger**: the real data is not to hand and inventing some is the only visible way forward.
- **Do instead**: say you are blocked and ask. "Do you have a real example I can derive a fixture
  from?" / "What does a realistic input look like — shape, ranges, edge cases that actually occur?"
  / "What would a wrong answer look like?" Synthetic data derived from a real sample is good
  practice; synthetic data derived from a guess is a test that cannot fail. If you genuinely must
  proceed without a sample, label the fixture as assumed and flag it in your report — never let an
  assumption pass as verified.

## Retired

*(none yet)*
