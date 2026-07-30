# STATUS — LAD (LLM-Assisted-Development Framework)
_Last touched: 2026-07-30_

## Goal
Convert LAD from a manually-pasted prompt library into installable Agent Skills, and use the
migration to cut content that is redundant, outdated, or broken against current tooling.

## State of play
- Local repo is on `main` at `1f3f1aa` (up to date with origin; `enh-subtree` was merged via PR #3
  and is stale/deletable). `STATUS.md` is still untracked.
- Actual tree is bigger than previously recorded: **16** files in `claude_prompts/` (not 10) and 16
  in `copilot_prompts/`, 8552 markdown lines total. README and LAD_RECIPE both document a
  10-file Claude tree and never mention `00_existing_work_discovery.md`,
  `04_maintenance_session.md`, or `04_test_quality_analysis.md` — the docs already drifted from the
  files.
- Nothing is wired into any agent's auto-discovery: no `.claude/skills/`, no `SKILL.md`, no hooks.

### Findings from the 2026-07-30 audit (these settle several old open questions)

1. **The Claude/Copilot fork is obsolete — delete, don't port.** Agent Skills is now an open
   standard (agentskills.io; authored by Anthropic, adopted broadly). VS Code agent mode, the
   GitHub Copilot cloud agent / CLI / code review, JetBrains, Codex, Cursor and Gemini CLI all read
   skills, and **VS Code + Copilot read `.claude/skills/` directly** (also `.github/skills/` and the
   vendor-neutral `.agents/skills/`). The convergence covers the *discovery layer*, not just the
   file format, so the "thin per-tool adapter" hypothesis is unnecessary. One skill tree serves
   both tools; the 16 `copilot_prompts/` files are redundant.

2. **`TodoWrite` is disabled by default** as of Claude Code v2.1.142, superseded by
   `TaskCreate`/`TaskGet`/`TaskList`/`TaskUpdate`. `claude_prompts/` references it 59 times and
   uses it as the *state mechanism* for phase-2 resumability. This is a functional break, not
   cosmetic staleness — and it answers the old question about where cross-session state lives: it
   has to move to the Task tools.

3. **Plugins answer the distribution + enforcement gap.** A Claude Code plugin bundles skills,
   hooks, agents, MCP config and settings as one versioned unit installed via
   `/plugin install`. That replaces `git subtree pull` plus manual "reload canonical LAD toolkit"
   copies into consuming projects. A bundled `SessionStart` hook gives LAD the enforcement the
   EMUSES session showed it lacked (codebase-memory-mcp's hook is enforced; LAD's phases are not).

4. **Three generations of the test-quality framework coexist.** `04_test_quality_analysis.md`
   shares 1 line with the `04a`–`04d` set (an unrelated older implementation);
   `04_test_quality_systematic.md` is a condensed variant of it (23/16/29/9 shared lines with
   04a/b/c/d). ~2100 lines in `claude_prompts/` alone for one workflow.

5. **Structural dead weight.** The `<system>`/`<user>` XML wrapper and `{{MUSTACHE}}` placeholders
   are paste-era artifacts (skills use the body directly plus `$ARGUMENTS`/named `arguments`). The
   ~12-line objectivity/communication preamble is copy-pasted into 9 files. `/compact` coaching is
   largely superseded by auto-compaction. `01c_chatgpt_review.md` is a manual copy-paste-to-ChatGPT
   loop that subagents and `/code-review` supersede.

6. **Spec constraint to design against**: keep each `SKILL.md` under 500 lines / ~5k tokens, push
   detail into `references/`. `02_iterative_implementation.md` alone is 569 lines.

## Decided strategy
Shape agreed with the user 2026-07-30. Full plan (with sub-plans and checkpoints) lives in
`docs/lad-v2/plan.md` — read that before starting work. Pre-rewrite tree tagged `v1-prompts`
(local tag only, not pushed).

**Locked decisions**: Copilot support dropped (Claude Code only — cross-tool compat comes free via
the Agent Skills standard rather than being designed for); distribution via Claude Code **plugin**
+ marketplace in this repo, replacing git subtree; per-feature artifacts slimmed to
`plan.md` + `context.md` during work, with a condensed `docs/decisions/<slug>.md` record written
post-merge by a new `consolidate-feature` skill (indexed in `docs/DECISIONS.md`); enforcement
limited to a **SessionStart pointer hook** — no lint or test-blocking hooks.

**Ship LAD as a Claude Code plugin containing 8 skills**, replacing 32 prompt files:

| Skill | Replaces | Notes |
|---|---|---|
| `lad-standards` | the duplicated preamble | `user-invocable: false`, model-invoked background knowledge |
| `feature-kickoff` | `00_feature_kickoff` + `00_existing_work_discovery` | discovery-before-build is part of kickoff |
| `plan-feature` | `01` + `01b` + `01d` | `01c` (ChatGPT) dropped in favour of a review subagent |
| `implement-feature` | `02` + `02b` | checkpoint becomes an internal stage |
| `finalize-feature` | `03` | drop the model-cost analysis (asks the model to invent ROI numbers) |
| `consolidate-feature` | *new* | post-merge condensed record → `docs/decisions/<slug>.md` |
| `test-quality` | `04a`–`04d` | delete `04_test_quality_analysis` + `04_test_quality_systematic` |
| `maintenance-session` | `04_maintenance_session` | currently undocumented in README/RECIPE |

Plus `hooks/hooks.json` with a `SessionStart` pointer. Delete `copilot_prompts/`,
`.copilot-instructions.md`, `.vscode/`; keep `documentation_standards/` as a `references/` asset.

**Rationale for the key calls**: plugin over subtree because it gives versioned installs and lets
LAD ship hooks; deletion over porting for the Copilot fork because the user no longer uses Copilot
and a second copy buys nothing.

### Further problems found on the full read (2026-07-30)
- **EMUSES paths leaked into the framework.** `04a`'s regression protocol — the most recent
  deliberate addition (`d765702`) — hardcodes `emuses/**/statistical*.py`, `pytest --cov=emuses`,
  `tests/security/`. The idea is sound; the paths make it inert elsewhere. Treat any `emuses/`
  reference in LAD as a bug.
- **Much of the 04 family is `echo "..." >> file.md` shell scripting** building markdown line by
  line when the agent has a Write tool. Large share of those ~2100 lines is volume, not content.
- **LAD's session-continuity files duplicate the STATUS.md convention.** `notes/pdca_session_state.md`,
  `notes/essential_context.md`, `notes/next_session_prep.md`, `PROJECT_STATUS.md`, `feature_vars.md`
  are a second scheme for a job STATUS.md already does. Resolved by the slim-artifact decision.
- **Unsourceable numbers**: "Research Software Standard (30-60% pass rate)", "Enterprise (85-95%)",
  and phase 03's "% cost reduction vs single-model approach". The underlying idea (a solo researcher
  shouldn't chase 100% green) survives as a skip-justification rubric; the fake precision does not.

**Parked**: skills for local/small-model agents. Adoption of the standard is entirely
frontier-tool; designing for 7B models risks a lowest-common-denominator format. Revisit only if a
concrete need appears.

## Progress
**The rewrite is complete except the EMUSES migration (C4).** All eight skills exist and are
verified loading in a cold `--plugin-dir` session, which also routes correctly ("lots of my tests are
failing" → `test-quality`). `claude plugin validate` passes.

`~8550 lines → ~1100.` Both prompt trees, `.copilot-instructions.md`, `.vscode/`, the old
`CLAUDE.md` and `LAD_RECIPE.md` are gone; the stale `enh-subtree` branch is deleted.

**Everything is staged but NOT committed** — awaiting the user's go-ahead to commit and push.

The session-start hook derives its skill list from the skills directory, so it expanded from one
stage to the full pipeline across sub-plans A→C without being edited. Keep it that way; a hardcoded
list is how the v1 README came to claim 10 prompt files when there were 16.

Guardrails resolved as a **maintenance mechanism** rather than a fixed list: entries carry status
(`confirmed` / `seeded-unverified` / `retired`), sighting dates and the assistants observed on, with
a stated retirement trigger. Rationale: model behaviour moves fast enough that an unpruned list
would rot into exactly the kind of unreviewed content that made v1 need this rewrite.
**G001–G009 are all `confirmed`** — the user recognised every seeded candidate from 2025–2026
sessions. Retirement rule amended accordingly: one model improving is *not* grounds for retiring an
entry, since a lapse a frontier model has stopped making may still be live elsewhere; retire on
absence of sightings only.

### A5 checkpoint feedback, incorporated
- **`lad-standards` was incomplete.** Correction to an earlier claim of mine: the communication
  guidelines lived in this repo's *project* `CLAUDE.md` (now deleted), not in the user's global one.
  That file was also the template consuming projects inherited via subtree; as a plugin nothing
  inherits it, so its content had to move into the skill. Now carried: communication guidelines,
  the token-optimisation command pattern for >2min commands, the three-level documentation
  convention. `MKDOCS_MATERIAL_FORMATTING_GUIDE.md` moved to
  `skills/lad-standards/references/mkdocs-material.md`. Deliberately *not* carried: the empty
  per-project state tables (superseded by `STATUS.md` + `docs/decisions/`).
- **Kickoff must hand off references, not prose** — `path:line` / qualified names, verified to
  resolve, using code-graph tools where the project is indexed and Grep/Glob otherwise (conditional,
  never a hard dependency). Plus a new step locating the *documentation* surface, so later stages
  read the CLI/API contract from source rather than reconstructing it from `--help`.
- **New guardrail G009** from the user's real experience: fabricated test fixtures. Getting stuck
  finding a meaningful real-world test and quietly settling for heavier mocking, or inventing
  plausible data shapes, yields a green suite that proves nothing. Corrective is to stop and ask for
  a real sample to derive a fixture from. Promoted into `lad-standards` as its own section too,
  since it matters most in analysis code where an invented distribution hides a wrong implementation.

## Open questions / next
Task-level breakdown and what each skill replaced is in `docs/lad-v2/plan.md`.

- [ ] **Commit and push.** Everything is staged. `v1-prompts` tag marks the pre-rewrite tree; it is
      local only and should be pushed alongside.
- [ ] **C4 — migrate EMUSES.** Handoff written: `docs/lad-v2/emuses-migration.md`. To be executed by
      a **fresh** session in `~/neuro_apps/emuses`, not from here. Blocked on (a) LAD being pushed,
      since `/plugin marketplace add` reads the remote, and (b) the pre-existing EMUSES session
      finishing — it was running on `fix/security-dependency-updates` with 8 uncommitted files and
      predates the revamp, so it still believes `.lad/claude_prompts/*` exists.
      **Critical**: `.lad/` is not a clean snapshot. Four EMUSES work-product files live inside it
      (~1226 lines, all last touched 2025-09-01/02) and a naive `rm -rf .lad/` destroys them.
      Rescue and triage before deleting.
- [ ] Publish the marketplace: users add it with `/plugin marketplace add chrisfoulon/LAD`, which
      requires these changes on `main` at the remote. Untested end-to-end until pushed — only the
      local `--plugin-dir` path has been verified.
- [ ] Delete `docs/lad-v2/` once the rewrite is settled, or consolidate it into
      `docs/decisions/lad-v2.md` — dogfooding `consolidate-feature` on LAD's own rewrite would be a
      genuine test of that skill.
