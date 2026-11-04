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
# Code points, not [가-힣]: glibc rejects that range under C.UTF-8 and the check would silently pass.
report "Korean residue" "$(LC_ALL=C.UTF-8 grep -rlP '[\x{AC00}-\x{D7A3}]' skills/ agents/ | grep -v claude-md-snippet)"

# Bare (unprefixed) skill/agent names in backticks. Match-level, not line-level,
# so a bare name on the same line as a mak:-prefixed one is still caught.
report "bare skill/agent names" "$(
  for n in $(ls -d skills/*/ | xargs -n1 basename) $(ls agents/*.md | xargs -n1 basename | sed 's/.md//'); do
    grep -rHoE "\`$n\`" skills/*/SKILL.md agents/*.md
  done
)"

# SKILL.md length (progressive-disclosure limit).
report "SKILL.md over 500 lines" "$(
  for f in skills/*/SKILL.md; do
    n=$(wc -l < "$f")
    [ "$n" -le 500 ] || echo "$f: $n lines"
  done
)"

# Skill listing text: Claude Code truncates description + when_to_use past 1,536 characters.
report "description + when_to_use over 1536 chars" "$(
  for f in skills/*/SKILL.md; do
    n=$(awk 'NR > 1 && /^---$/ { exit }
             /^[a-z_-]+:/ { keep = /^(description|when_to_use):/ }
             keep { sub(/^(description|when_to_use):[ ]*/, ""); print }' "$f" \
      | tr -d '\n' | LC_ALL=C.UTF-8 wc -m)
    [ "$n" -le 1536 ] || echo "$f: $n chars"
  done
)"

# Setup snippet mirror pair: identical markers, same line count, bounded size.
snippet_ko=skills/setup/assets/claude-md-snippet.ko.md
snippet_en=skills/setup/assets/claude-md-snippet.en.md
report "snippet mirror mismatch" "$(
  [ "$(head -1 "$snippet_ko")" = "$(head -1 "$snippet_en")" ] || echo "first lines differ"
  [ "$(tail -1 "$snippet_ko")" = "$(tail -1 "$snippet_en")" ] || echo "last lines differ"
  [ "$(wc -l < "$snippet_ko")" -eq "$(wc -l < "$snippet_en")" ] || echo "line counts differ"
)"
# Bytes, not characters: Korean takes half the characters of English for the same rules,
# so a character limit would bind only the English file.
report "snippet over 6000 bytes" "$(
  for f in "$snippet_ko" "$snippet_en"; do
    n=$(wc -c < "$f")
    [ "$n" -le 6000 ] || echo "$f: $n bytes"
  done
)"

# Subagent git guard. Arguments are JSON-escaped, as the hook receives them on stdin.
hook_case() {
  # $1 = expected exit code, $2 = agent_type ("" = main thread), $3 = command, $4 = description
  agent_field=""
  [ -n "$2" ] && agent_field="\"agent_type\":\"$2\","
  printf '{"session_id":"s",%s"tool_name":"Bash","tool_input":{"command":"%s","description":"%s"}}\n' \
    "$agent_field" "$3" "${4-}" | sh hooks/block-agent-git.sh 2>/dev/null
  rc=$?
  [ "$rc" -eq "$1" ] || echo "expected exit $1, got $rc: agent='$2' command='$3'"
}
report "git guard hook" "$(
  hook_case 2 mak:coder 'git commit -m x'
  hook_case 2 mak:coder 'git push'
  hook_case 2 mak:coder 'git -C a commit'
  hook_case 2 mak:coder 'git --no-pager push'
  hook_case 2 mak:coder 'cd a && git commit'
  hook_case 2 mak:coder 'cd a&&git commit'
  hook_case 2 mak:coder 'cd a;git push'
  hook_case 2 mak:coder 'true | git push'
  hook_case 2 mak:coder 'cd a\ngit push'
  hook_case 2 mak:coder 'git commit -m \"x\"'
  hook_case 2 mak:coder 'git -C \"a b\" commit'
  hook_case 2 mak:coder "git -C 'a b' push"
  hook_case 2 mak:coder 'git\tpush'
  hook_case 2 mak:coder 'git \\\ncommit'
  hook_case 2 mak:coder 'git -c user.name=\"a b\" commit'
  hook_case 2 mak:coder "git -c user.name='a b' -c x=y commit"
  hook_case 2 mak:coder 'out=\"$(git push 2>&1)\"'
  hook_case 2 mak:coder 'echo \"`git push`\"'
  hook_case 2 mak:coder 'git -C C:\\temp commit'
  hook_case 2 mak:coder 'git -C C:\\new push'
  hook_case 2 mak:coder 'cd \"$d\" && git commit -m \"m\"'
  hook_case 2 mak:coder 'git add \"$f\" && git commit -m \"m\"'
  hook_case 2 mak:coder 'git -C \"$d\" commit -m \"m\"'
  hook_case 2 mak:coder 'echo \"$x\"; git push; echo \"d\"'
  hook_case 2 mak:coder 'git -C \"$HOME/a b\" commit'
  hook_case 2 mak:coder 'git -c a=\"$b c\" commit'
  hook_case 2 mak:coder "echo 'say \\\"hi' && git commit -m \\\"x\\\""
  hook_case 2 mak:coder "echo don\\\\'t && git commit -m x"
  hook_case 2 mak:coder 'echo \"oops ; git commit'
  hook_case 2 mak:coder '\\git commit'
  hook_case 2 mak:coder "# don't do this\\ngit commit -m 'x'"
  hook_case 2 mak:coder "cat > f <<EOF\\ndon't\\nEOF\\ngit commit -m 'x'"
  hook_case 2 mak:coder 'cat > f <<EOF\nsay \"hi\nEOF\ngit commit -m \"x\"'
  hook_case 2 mak:coder "msg=\\\"\$(cat <<'EOF'\\nsubject\\nEOF\\n)\\\" && git commit -m \\\"\$msg\\\""
  hook_case 2 mak:coder 'python -c \"import x\nprint(1)\" && git commit -m \"done\"'
  hook_case 2 mak:coder 'echo \"a\nb\" > f && git push origin \"main\"'
  hook_case 2 mak:coder "echo 'a\\nb' > f && git commit -m 'x'"
  hook_case 2 mak:coder 'git -C \"a\nb\" commit'
  hook_case 2 mak:coder 'git -P commit -m x'
  hook_case 2 mak:coder 'git -p push'
  hook_case 0 mak:reviewer 'git -P log'
  hook_case 2 mak:coder 'git -C \"$(git rev-parse --show-toplevel)\" commit'
  hook_case 2 mak:coder 'git -C \"$(dirname \"$f\")\" commit'
  hook_case 2 mak:coder 'git -C a\\ b commit'
  hook_case 2 mak:coder 'git -c a=b\\ c commit'
  hook_case 2 mak:coder 'git \\\r\ncommit'
  hook_case 2 mak:coder 'echo \"a\\\"b\"; git push'
  hook_case 0 mak:reviewer 'echo \"a\\\"; git commit\"'
  hook_case 0 mak:reviewer 'grep git\\ commit f'
  hook_case 0 mak:reviewer 'git --version\npush.sh'
  hook_case 0 mak:reviewer 'git -C \"$d\" status && grep \"git commit\" f'
  hook_case 0 mak:reviewer 'grep \"$a\" f; grep \"git commit\" g'
  hook_case 0 mak:reviewer "echo \\\"it's git commit\\\""
  hook_case 0 mak:reviewer "echo 'say \\\"git commit\\\"'"
  hook_case 0 mak:reviewer 'grep -n \"never run git commit\" CLAUDE.md'
  hook_case 0 mak:reviewer 'git log --grep \"fix git push\"'
  hook_case 0 mak:reviewer 'rg \"(git commit|git push)\" skills'
  hook_case 0 mak:reviewer 'echo \"; git commit\"'
  hook_case 0 mak:reviewer "grep -n 'run git push' docs"
  hook_case 0 mak:reviewer 'git log --grep \"git commit\"'
  hook_case 0 mak:reviewer 'git grep \"git push\" docs'
  hook_case 0 mak:reviewer 'git log && grep -n \"git commit\" CLAUDE.md'
  hook_case 0 '' 'git commit -m x'
  hook_case 0 Explore 'git commit -m x'
  hook_case 0 mak:coder 'git log --grep commit'
  hook_case 0 mak:coder 'git --no-pager log'
  hook_case 0 mak:coder 'git status' 'Check before git commit'
)"

if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo OK
