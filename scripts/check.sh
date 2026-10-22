#!/usr/bin/env bash
# Consistency checks for the mak plugin repository.
# Usage: bash scripts/check.sh — prints hits per check; exit 1 on any hit, else prints OK.
set -u

cd "$(dirname "$0")/.." || exit 1

fail=0

report() {
  # $1 = check name, $2 = hits (empty means pass)
  if [ -n "$2" ]; then
    echo "[$1]"
    echo "$2"
    fail=1
  fi
}

# Old skill paths (pre-plugin layout).
report "old path ~/.claude/skills" "$(grep -rn "~/.claude/skills" skills/ agents/)"

# Old design-doc path.
report "old design-doc path .claude/docs" "$(grep -rn "\.claude/docs" skills/ agents/)"

# Korean residue outside the setup snippet. UTF-8 locale is required: without it
# (e.g. Git Bash with LANG unset) the Hangul range matches any non-ASCII byte such as an em dash.
report "Korean residue" "$(LC_ALL=C.UTF-8 grep -rln '[가-힣]' skills/ agents/ | grep -v claude-md-snippet)"

# Bare (unprefixed) skill/agent names in backticks. Match-level, not line-level,
# so a bare name on the same line as a mak:-prefixed one is still caught.
report "bare skill/agent names" "$(
  for n in $(ls -d skills/*/ | xargs -n1 basename) $(ls agents/*.md | xargs -n1 basename | sed 's/.md//'); do
    grep -rHoE "\`$n\`" skills/*/SKILL.md agents/*.md
  done
)"

if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo OK
