---
description: scout -> planner -> plan-reviewer (gpt-5.3-codex) -> worker
---
Use the `subagent` tool in chain mode with agents `scout`, `planner`, `plan-reviewer`, and `worker`.

Task:
$@

Flow requirements:
1. `scout` gathers code context and constraints for the task.
2. `planner` creates an implementation plan using `{previous}`.
3. `plan-reviewer` critiques and revises that plan using `{previous}`.
   - This step is pinned by agent config to model `gpt-5.3-codex`.
4. `worker` executes the revised plan from `{previous}`.

Execution requirements:
- Keep changes focused and minimal.
- Run relevant checks/tests.
- End with summary + changed files + risks/follow-ups.
