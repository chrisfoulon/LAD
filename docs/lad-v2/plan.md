# Plan — LAD v2: prompt library → Claude Code plugin

_Created 2026-07-30. Dogfooding LAD's own phases on LAD itself._

## Decisions locked (2026-07-30 session)

| Question | Decision |
|---|---|
| Copilot support | **Dropped.** Claude Code only. Cross-tool compat comes free via the Agent Skills standard; not designed for. |
| Distribution | **Claude Code plugin**, installed via `/plugin` from a marketplace in this repo. Replaces git subtree. |
| Per-feature artifacts | **Slim during work** (`plan.md` + `context.md`), **condensed record at the end** via a new `consolidate-feature` skill. |
| Enforcement | **SessionStart hook only** — a short protocol pointer. No lint/test-blocking hooks. |
| Consolidated record | **`docs/decisions/<slug>.md`** (what was built / choices + why / rejected alternatives / deviations / known limits) with a one-line-per-feature index at `docs/DECISIONS.md`. Working `plan.md` + `context.md` are pruned once consolidated. |

## Complexity assessment

**Task count**: 8. **Domains**: scaffolding, skill authoring, docs, consumer migration.
Per LAD's own rule (>6 tasks OR mixed domains → split), **this plan splits into 3 sub-plans**.

## Target structure

```
LAD/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json          # so `/plugin marketplace add chrisfoulon/LAD` works
├── skills/
│   ├── lad-standards/            # user-invocable: false — background standards + guardrails
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── guardrails.md     # observed LLM lapses (see open question 1)
│   │       └── mkdocs-material.md
│   ├── feature-kickoff/          # 00 + 00_existing_work_discovery
│   ├── plan-feature/             # 01 + 01b + 01d
│   ├── implement-feature/        # 02 + 02b
│   ├── finalize-feature/         # 03
│   ├── consolidate-feature/      # NEW — post-merge condensed record
│   ├── test-quality/             # 04a–04d collapsed
│   └── maintenance-session/      # 04_maintenance_session
├── hooks/hooks.json              # SessionStart pointer only
├── README.md
└── LAD_RECIPE.md
```

Deleted: `claude_prompts/` (16 files), `copilot_prompts/` (16 files), `.copilot-instructions.md`,
`.vscode/`, `CLAUDE.md` (its content is either in the user's global CLAUDE.md already or moves into
`lad-standards`).

## Sub-plan A — Foundation

- [x] A1: Scaffold plugin (`plugin.json`, `marketplace.json`), `claude plugin validate` passes
- [x] A2: Write `lad-standards` skill + `references/guardrails.md` (dated/status entries, retirement
      process; G001 confirmed, G002–G008 seeded-unverified pending real sightings)
- [x] A3: `hooks/hooks.json` + `session-start.sh`. Skill list is **derived from the skills directory**
      rather than hardcoded, so the announcement cannot drift from what exists.
- [x] A4: `feature-kickoff` written; verified loading via `--plugin-dir` in a real session —
      registers as `lad:feature-kickoff`, hook fires and injects.
- [ ] A5: **Checkpoint** — user reviews the prototype before the remaining skills are written
- [x] A6: Deleted `copilot_prompts/` (16 files), `.copilot-instructions.md`, `.vscode/`, `CLAUDE.md`

## Sub-plan B — Core workflow skills

- [x] B1: `plan-feature` (01 + 01b self-review + 01d split evaluation; 01c ChatGPT loop dropped)
- [x] B2: `implement-feature` (02 TDD loop + 02b checkpoint gate; Task tools; the 04a regression
      protocol survives here as "commit a rollback point and map the blast radius before a
      broad-reach change", stripped of its EMUSES paths)
- [x] B3: `finalize-feature` (03 minus the model-cost analysis)
- [x] B4: `consolidate-feature` — writes `docs/decisions/<slug>.md` + updates `docs/DECISIONS.md`
      index, harvests guardrails, then proposes pruning the working files. Invoked post-merge.
- [x] B-verify: all six skills load via `--plugin-dir`; the session-start hook auto-expanded to the
      full five-stage pipeline with no edit, confirming the derived-list design.
- [ ] B5: **Checkpoint** — user review before the auxiliary skills and doc rewrite

## Sub-plan C — Auxiliary skills, docs, migration

- [x] C1: `test-quality` — 04a–04d (1474 lines) collapsed to 113. EMUSES paths and echo-scripting
      gone. The invented "industry standard" percentages are replaced by a skip-justification rubric
      that asks what the test protected against, rather than benchmarking against a fabricated
      number. G002/G003/G009 called out at the top, since this is where they get violated.
- [x] C2: `maintenance-session` — ported to 85 lines; impact tiers kept, plus "fix only what you
      understand" and a requirement to report tiers separately so a whitespace sweep cannot be
      presented as debt reduction.
- [x] C3: `README.md` rewritten (103 lines). **`LAD_RECIPE.md` deleted** — fully superseded: its
      workflow chapters are the skills, its standards sections are in `lad-standards`, its Copilot
      half is gone. Unverifiable claims dropped.
- [ ] C4: Migrate EMUSES off the `.lad/` subtree snapshot — handoff at `emuses-migration.md`, to be
      run from a fresh EMUSES session. Investigation found `.lad/` is not a clean snapshot: it holds
      ~1226 lines of EMUSES work product that a naive delete would destroy.
- [x] C6 (unplanned, found by dogfooding C4): skills hardcoded `docs/<slug>/`, but EMUSES uses
      `dev-docs/`. All four now follow the project's existing convention and only fall back to
      `docs/` when there is none. A framework that imposes its own layout on an established codebase
      is a framework that gets worked around.
- [x] C5: Deleted the stale `enh-subtree` branch (was merged into main via PR #3)

## Content rules for every skill

1. `SKILL.md` under 500 lines / ~5k tokens; detail goes to `references/`.
2. No `<system>`/`<user>` wrappers, no `{{MUSTACHE}}` — use `$ARGUMENTS` / named `arguments`.
3. No objectivity/communication preamble — it is already in the user's global CLAUDE.md.
4. No `echo "..." >> file.md` scripting — the agent has Write.
5. `TodoWrite` → `TaskCreate`/`TaskUpdate`/`TaskList`.
6. No invented metrics. If a number cannot be measured, do not ask the model to produce it.
7. No project-specific paths. Anything naming `emuses/` is a bug.
8. **Hand off references, not prose.** Every stage that passes state to the next records
   `path:line` or qualified names, verified to resolve. Use code-graph tools where the project is
   indexed, Grep/Glob otherwise — conditionally, never as a hard dependency. Applies to
   `plan-feature` and `implement-feature` as much as to `feature-kickoff`.
9. **Documentation is located, not rediscovered.** Where a feature touches documented surface
   (CLI, API, config), record where that documentation lives and what needs updating, so later
   stages read the contract instead of reconstructing it from `--help`.
10. **Never invent what real data looks like.** When a meaningful test needs real inputs that are
    not to hand, stop and ask for a sample rather than fabricating a fixture. Applies to
    `implement-feature` and `test-quality`. See guardrail G009.

## Risks

- **Deletion is irreversible in practice.** Mitigation: the pre-rewrite tree stays reachable at tag
  `v1-prompts` (to create before sub-plan A) and in git history regardless.
- **EMUSES depends on the current `.lad/` layout.** Its snapshot keeps working until C4; nothing
  breaks mid-migration.
- **Guardrails may be over-fitted to guessed failure modes** rather than observed ones. Mitigation:
  open question 1 — do not write `guardrails.md` until the list is grounded.

## Open questions

1. **Which LLM lapses have actually been observed?** — blocks A2 only. Fallback if unanswered:
   seed `guardrails.md` with candidate lapses explicitly marked unverified, prune later once real
   ones are identified. Everything else in sub-plan A can proceed without this.
