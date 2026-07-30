#!/usr/bin/env bash
# Injected into context at session start. Keep this SHORT — it costs tokens every
# single session, in every project where the LAD plugin is enabled. It is a pointer
# to the workflow, not the workflow itself.
#
# The skill list is derived from what is actually on disk rather than hardcoded, so
# it cannot advertise skills that do not exist. Do not replace this with a literal
# list; that is precisely how the v1 docs drifted from the v1 tree.
set -euo pipefail

root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Feature pipeline, in execution order. Only those present are announced.
pipeline=()
for s in feature-kickoff plan-feature implement-feature finalize-feature consolidate-feature; do
  [ -f "$root/skills/$s/SKILL.md" ] && pipeline+=("/lad:$s")
done

# Everything else on disk that a user can actually invoke. Discovered rather than
# listed, so adding a skill needs no edit here — only the pipeline order above is
# knowledge this script has to hold.
standalone=()
for d in "$root"/skills/*/; do
  s=$(basename "$d")
  [ -f "$d/SKILL.md" ] || continue
  case " ${pipeline[*]} " in *" /lad:$s "*) continue ;; esac
  grep -qiE '^user-invocable:[[:space:]]*(false|no|off|0)' "$d/SKILL.md" && continue
  standalone+=("/lad:$s")
done

[ ${#pipeline[@]} -eq 0 ] && [ ${#standalone[@]} -eq 0 ] && exit 0

echo "LAD workflow available."
if [ ${#pipeline[@]} -gt 0 ]; then
  joined="${pipeline[0]}"
  for step in "${pipeline[@]:1}"; do joined="$joined -> $step"; done
  printf 'Feature work, in order: %s\n' "$joined"
  echo "Do not start a non-trivial feature by writing code: run ${pipeline[0]} first, so existing"
  echo "implementations are found before new ones are built."
fi
[ ${#standalone[@]} -gt 0 ] && printf 'Also available: %s\n' "${standalone[*]}"

[ -f STATUS.md ] && echo "STATUS.md exists at the project root — read it before exploring."

exit 0
