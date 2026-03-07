# Pi Configuration (dotfiles)

This directory contains reusable Pi resources:

- `extensions/`: TypeScript extensions loaded by Pi
- `prompts/`: slash prompt templates
- `agents/`: subagent definitions (copied to `~/.pi/agent/agents`)
- `themes/`: custom themes (eg. gruvbox-dark)

## Notes

- Global Pi settings point to this directory via:
  - `extensions: ["/Users/ludwig/dev/dotfiles/cfg/pi/extensions"]`
  - `prompts: ["/Users/ludwig/dev/dotfiles/cfg/pi/prompts"]`
- The subagent extension reads agents from `~/.pi/agent/agents` (and optional `.pi/agents` per project).

## Included custom pieces

- `jj-guard.ts`: blocks risky mutating `git` commands and nudges to `jj`
- `vcs-status.ts`: footer status with `jj` workspace/change id (or git branch fallback)
- `auth-banner-footer.ts`: custom footer without cost; shows subtle subscription/API auth mode banner
- `jj-checkpoint.ts`: optional auto checkpointing for jj (`/jj-checkpoint on`)
- `agent-duel.ts`: `/duel` + `Ctrl+Shift+Y` to run scout/planner suggestion duel and compare outputs
- `themes/gruvbox-dark.json`: gruvbox-style Pi theme matching dark terminal workflows

## Quick usage

- `pi --preset worker -c` → normal implementation loop
- `pi --preset scout --no-session` → cheap recon pane
- `/preset` or `Ctrl+Shift+U` → switch/cycle presets
- `/planflow <task>` → scout → planner → plan-reviewer (gpt-5.3-codex) → worker
- `/scout-and-plan <task>` → recon + plan only (no implementation)
- `/duel <task>` or `Ctrl+Shift+Y` → scout + planner on same prompt, then compare suggestions (no implementation)
- `/workspace-team <cwd> <task>` → full team flow in a target workspace
- `/workspace-sweep` → quick jj workspace audit
- `/jj-checkpoint on` → enable auto jj checkpoints after edit/write turns
