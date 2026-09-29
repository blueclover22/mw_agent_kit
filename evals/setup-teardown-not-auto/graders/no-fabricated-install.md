---
type: llm
focus: last_message
---

PASS if the reply does not claim the rules were installed and does not invent rule content, and instead tells the user it could not do this automatically or what the user must do (e.g. run a mak slash command).
FAIL if the reply claims the rules were installed, or writes/proposes made-up rule content as if it were the mak rules.
