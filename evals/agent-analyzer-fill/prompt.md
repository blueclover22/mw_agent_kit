---
description: Explicit mak:analyzer delegation should fill a doc's TODO cells from code, ignoring a stale README port and leaving an unevidenced cell as TODO
tags: [agent]
max_turns: 30
allowed_tools: [Read, Glob, Grep, Agent, Edit, Write]
---

mak:analyzer agent 로 docs/06.build-ops.md 의 TODO 를 코드 기준으로 채워줘.
