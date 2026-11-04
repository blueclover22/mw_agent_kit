#!/bin/sh
# PreToolUse guard: blocks git commit/push from mak:* subagents.
# Prevents mistakes; it is not a security boundary, so anything unexpected passes (exit 0).
# Missed: `git --git-dir x commit`, `/usr/bin/git commit`, `git.exe commit`,
# `Git commit`, `$GIT commit`, `sh -c "..."`, `eval "..."`, aliases, quoted names (`git "commit"`),
# a quote opened earlier on the same line by `$'...'`, a substitution with nested quotes (`x="$(cd "$d" && git push)"`), `git -C $(cmd arg) commit` unquoted, a continuation
# inside a word (`git com\<newline>mit`).
# Falsely blocked: `git commit --dry-run`, `git push --help`, `echo git commit`, comments, heredoc bodies, lines of a multi-line quoted
# string, text after an unmatched apostrophe on its line, and text in double quotes that holds
# `$(` or a backtick.
export LC_ALL=C

input=$(cat)

agent=$(printf '%s\n' "$input" \
  | grep -oE '"agent_type"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 \
  | sed 's/^"agent_type"[[:space:]]*:[[:space:]]*"//; s/"$//')
case "$agent" in
  mak:*) ;;
  *) exit 0 ;;
esac

# Only the first "command" key is inspected (tool_input.command in the hook's input), so a
# description mentioning git never matches.
# The awk step decodes the JSON string, then walks it tracking shell quotes. A quoted span
# becomes one token, so grep "git commit" never matches and git -C "a b" commit does.
# Double quotes holding $( or a backtick also get a line of their own, because that code runs.
# It scans twice and blocks on either result. Resetting quote state at each newline keeps an
# apostrophe in a comment or heredoc body from hiding later lines; not resetting keeps a
# multi-line string from hiding the command after its closing quote. An unterminated quote stays.
command=$(printf '%s\n' "$input" \
  | grep -oE '"command"[[:space:]]*:[[:space:]]*"([^"\\]|\\.)*"' | head -1 \
  | sed 's/^"command"[[:space:]]*:[[:space:]]*"//; s/"$//' \
  | awk -v sq="'" '
    function scan(s, reset,    i, c, out, extra, q, buf) {
      out = ""; extra = ""; q = ""; buf = ""
      for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        if (q == "") {
          if (c == "\\") {
            i++; c = substr(s, i, 1)
            out = out ((c == "\n") ? " " : (c == " ") ? "_" : c)
          }
          else if (c == sq || c == "\"") { q = c; buf = "" }
          else out = out c
        } else if (reset && c == "\n") {
          out = out buf c; q = ""
        } else if (c == q) {
          if (q == "\"" && (index(buf, "$(") || index(buf, "`"))) extra = extra "\n" buf
          out = out "QUOTED"
          q = ""
        } else if (q == "\"" && c == "\\") {
          i++; buf = buf c substr(s, i, 1)
        } else buf = buf c
      }
      return out (q == "" ? "" : buf) extra
    }
    {
      s = ""
      for (i = 1; i <= length($0); i++) {
        c = substr($0, i, 1)
        if (c != "\\") { s = s c; continue }
        i++
        c = substr($0, i, 1)
        s = s ((c == "n") ? "\n" : (c == "t") ? " " : (c == "r") ? "" : c)
      }
      print scan(s, 1)
      print scan(s, 0)
    }')

if printf '%s\n' "$command" \
  | grep -qE '(^|[[:space:];&|(`])git([[:space:]]+(-[cC][[:space:]]+[^[:space:]]+|-[pP]|--[^[:space:]]+))*[[:space:]]+(commit|push)([^[:alnum:]_-]|$)'; then
  echo "mak: subagents must not run git commit/push. Leave the changes uncommitted and report them; committing belongs to the main thread on the user's explicit request." >&2
  exit 2
fi

exit 0
