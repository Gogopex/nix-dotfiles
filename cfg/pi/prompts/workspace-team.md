---
description: run full agent team in a specific workspace (first arg = cwd)
---
Run a full subagent team in this workspace:

Workspace (cwd):
$1

Task:
${@:2}

Use `subagent` in chain mode with `cwd: "$1"` for every step:
1. `scout` for recon
2. `planner` for plan
3. `plan-reviewer` for plan QA/revision
4. `worker` for execution
5. `reviewer` for post-implementation review
6. `worker` to apply high-value review fixes

Requirements:
- Keep scope tight.
- Run relevant checks in that workspace.
- Final output: changed files, checks run, remaining risks.
