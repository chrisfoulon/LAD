# Handoff — migrating EMUSES off the `.lad/` subtree

_Written 2026-07-30 from the LAD session. For a **fresh** session in `~/neuro_apps/emuses`._

## Why this exists

LAD v2 is a Claude Code plugin, not a directory copied into projects. EMUSES carries a `.lad/`
snapshot from the old subtree model. This is the migration.

The LAD-side facts below were gathered from EMUSES on 2026-07-30 but the *judgement calls* need
EMUSES context, which the LAD session does not have. Verify before acting; things may have moved.

## Prerequisites, in this order

1. **LAD must be pushed first.** `/plugin marketplace add chrisfoulon/LAD` reads the GitHub remote.
   If LAD is not pushed, installation fails.
2. **The pre-existing EMUSES session must finish and commit first.** As of 2026-07-30 a session was
   running on branch `fix/security-dependency-updates` with 8 uncommitted files. It started *before*
   the LAD revamp, so it believes `.lad/claude_prompts/*` still exists. Do not migrate underneath it.
3. **Use a fresh session** so `SessionStart` picks up the installed plugin.

## Step 1 — Rescue before deleting

`.lad/` is **not** a clean framework snapshot. Four files are EMUSES work product that was written
into it and would be destroyed by `rm -rf .lad/`:

| File | Lines | Last touched |
|---|---|---|
| `.lad/PHASE2_TO_PHASE3_HANDOVER.md` | 398 | 2025-09-02 |
| `.lad/FRAMEWORK_IMPLEMENTATION_GUIDE.md` | 328 | 2025-09-01 |
| `.lad/TEST_QUALITY_FRAMEWORK.md` | 298 | 2025-09-01 |
| `.lad/COVERAGE_ANALYSIS_PHASE2.md` | 202 | 2025-09-01 |

All four are ~11 months stale, which suggests they describe finished phases — but **that is a guess
from timestamps, not a finding**. Triage them with EMUSES knowledge:

- Still relevant → move to `dev-docs/` (EMUSES's own convention), do not leave in `.lad/`
- Historical → `dev-docs/project-history/`, where similar archives already live
- Genuinely dead → delete deliberately, having decided so

Do this **before** removing `.lad/`, not after.

## Step 2 — Install the plugin, remove `.lad/`

```
/plugin marketplace add chrisfoulon/LAD
/plugin install lad@lad
```

Then delete `.lad/` once step 1 is complete. Everything else in it (`claude_prompts/`,
`copilot_prompts/`, `LAD_RECIPE.md`, `CLAUDE.md`, `documentation_standards/`, `README.md`,
`LICENSE.md`) is superseded framework content — recoverable from the LAD repo at tag `v1-prompts`.

## Step 3 — Repoint the references

15 files referenced `.lad/`, `claude_prompts`, `copilot_prompts` or `LAD_RECIPE` as of 2026-07-30.
These four are live and need real decisions:

| File | Reference | What it needs |
|---|---|---|
| `CLAUDE.md:25` | "`.lad/CLAUDE.md` — Static development guidelines and patterns" | That file is deleted. Its content is now the `lad-standards` skill, loaded automatically. Repoint or drop the line. |
| `CLAUDE.md:182` | "Static guidelines in `.lad/CLAUDE.md`" | Same. |
| `scripts/README.md:119` | "Testing Guidelines from `.lad/CLAUDE.md`" | Same — point at `lad-standards` or inline the few lines it needs. |
| `.github/copilot-instructions.md:7-8` | "do not modify any files under `.lad/`" | Moot once `.lad/` is gone. Also note LAD v2 dropped Copilot support, so consider whether this file has any remaining purpose. |
| `.coveragerc:9` | `omit = .lad/*` | Harmless once `.lad/` is gone, but stale. Remove. |

The remaining references are inside `dev-docs/` — historical plans and context files. Most are
records of past work and should stay as history. Check, do not bulk-edit.

## Step 4 — Note on doc conventions

EMUSES uses `dev-docs/<slug>/`, not `docs/<slug>/`. The v2 skills were updated on 2026-07-30 to
follow a project's existing convention rather than imposing `docs/` — this was found *because* of
this migration. Confirm the skills actually respect `dev-docs/` in practice; if a skill creates
`docs/<slug>/` anyway, that is a LAD bug worth reporting back.

`consolidate-feature` will want `dev-docs/decisions/` and `dev-docs/DECISIONS.md`.

## Step 5 — Verify

- `/plugin` shows `lad` enabled; `/lad:feature-kickoff` autocompletes
- Session start announces the LAD pipeline
- Nothing in the repo still points at a `.lad/` path that no longer exists:
  `grep -rIn "\.lad/" . --exclude-dir=.git`
- EMUSES's test suite is no worse than before the migration

## Worth knowing

EMUSES was reportedly hard to make changes in because of its size. Two v2 behaviours target that
directly, and are worth trying deliberately rather than waiting to stumble into:

- `feature-kickoff` searches for existing implementations before anything is built, and prefers a
  code-graph tool (`codebase-memory-mcp`, which EMUSES already has) over grep. On a large codebase
  that is the difference between finding the existing thing and building a second one.
- `plan-feature` splits work spanning multiple domains into sub-plans with context evolution between
  them, so a large feature does not have to be held in one pass.
