# STATUS — LAD (LLM-Assisted-Development Framework)
_Last touched: 2026-07-30_

## Goal
Keep LAD useful as a personal development framework: a small set of skills that prevent the failure
modes that actually recur, without accumulating content nobody reads.

## State of play
**v2 shipped and installed.** LAD is a Claude Code plugin of eight Agent Skills, on `main`
(PR #5 merged). `/plugin marketplace add chrisfoulon/LAD` → `/plugin install lad@lad` verified
working end to end. `8552 lines → ~1150`.

Skills: `lad-standards` (model-invoked background), then the feature pipeline —
`feature-kickoff` → `plan-feature` → `implement-feature` → `finalize-feature` →
`consolidate-feature` (post-merge) — plus `test-quality` and `maintenance-session` standalone.
A `SessionStart` hook announces the pipeline; its skill list is derived from the skills directory,
so it cannot drift from what exists. Keep it that way.

Pre-rewrite tree is tagged `v1-prompts` (pushed) — the recovery path for 8172 deleted lines.

Note: `/reload-plugins` reports `0 skills` for this plugin. Cosmetic — that counter only covers
`commands/` directories and LAD uses `skills/`. Not a failure.

## Decided strategy
- **Claude Code only.** Copilot support dropped; cross-tool compatibility comes free from the
  Agent Skills standard rather than being designed for and maintained as a second copy.
- **Plugin, not subtree.** Consuming projects no longer carry a `.lad/` copy. Versioned installs,
  and it lets LAD ship hooks — the enforcement v1 lacked.
- **Slim working artifacts, durable decisions.** During a feature: `plan.md` + `context.md` in the
  project's own dev-docs convention (`dev-docs/`, `docs/`, whatever exists — LAD follows, never
  imposes). Post-merge, `consolidate-feature` condenses them into `decisions/<slug>.md` with an
  index, and prunes the rest. This is what lets `STATUS.md` stay a current-state file: superseded
  detail is retained there rather than lost or accumulated here.
- **Guardrails are a maintained registry, not a fixed list.** Entries carry sighting dates and a
  status, with an explicit retirement process. G001–G009 confirmed. One model improving is *not*
  grounds for retirement — retire on absence of sightings only. Bar for adding: second sighting, or
  first with real consequences. An append-only list is how v1 reached 8500 lines.
- **No invented numbers.** If the model cannot measure it, it does not report it. This removed the
  "model cost optimisation" analysis and the unciteable "industry standard" pass rates.

## Open questions / next
- [ ] **EMUSES migration is mid-flight**, run from a session in `~/neuro_apps/emuses` against
      `docs/lad-v2/emuses-migration.md`. Rescue step done: four EMUSES work-product files
      (1226 lines) moved out of `.lad/` into `dev-docs/project-history/phase-implementations/` with
      history preserved; regression gate 13/13. Plugin now installed. Remaining: commit the rescue
      as its own checkpoint, delete `.lad/`, then repoint the five live references
      (`CLAUDE.md:25`, `CLAUDE.md:182`, `scripts/README.md:119`,
      `.github/copilot-instructions.md:7-8`, `.coveragerc:9`).
- [ ] `tests/conftest.py:158` in EMUSES hardcodes an absolute Windows path, so the session-scoped
      `emuses_pipeline_results` fixture cannot work on this machine. Pre-existing, found during the
      migration, correctly left unfixed there. Good first candidate for `/lad:test-quality`.
- [ ] Dogfood `consolidate-feature` on this rewrite: condense `docs/lad-v2/` into
      `docs/decisions/lad-v2.md`. Would both test the skill and capture *why* Copilot was dropped
      and subtree gave way to a plugin — the two decisions most likely to be second-guessed later.
- [ ] v2 is unproven in daily use. The open question is whether the eight skills are the right
      seams, which only using them on a real feature will answer. Watch for stages that get skipped
      or that need re-invoking to stick.
