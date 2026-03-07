/**
 * Agent Duel extension
 *
 * Adds:
 * - /duel <prompt>: run a read-only, two-agent suggestion workflow
 * - Ctrl+Shift+Y: prompt for input and run /duel quickly
 *
 * Flow:
 * 1) Ask scout and planner the same prompt via subagent parallel mode
 * 2) Compare both outputs in the main model (current model)
 *
 * No implementation is requested in this flow.
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { Key } from "@mariozechner/pi-tui";

function buildDuelPrompt(task: string): string {
	return [
		"Run a read-only dual-agent suggestion workflow.",
		"",
		`Task: ${task}`,
		"",
		"Requirements:",
		"- Suggestions only. Do NOT implement.",
		"- Do NOT edit or write files.",
		"- Do NOT produce diffs/patches.",
		"- Keep outputs concise and high-signal.",
		"",
		"Execution steps:",
		"1) Call the `subagent` tool in PARALLEL mode with exactly these two tasks (same task text for both):",
		"   - scout: independent suggestions for the task",
		"   - planner: independent suggestions for the task",
		"",
		"2) After both return, compare the two outputs yourself (as the current model).",
		"",
		"3) Final response format:",
		"   - Scout Suggestions",
		"   - Planner Suggestions",
		"   - Comparison (agreements, differences, trade-offs)",
		"   - Recommended Next Step (still suggestion-only)",
	].join("\n");
}

function queueDuel(pi: ExtensionAPI, ctx: ExtensionContext, task: string): void {
	const prompt = buildDuelPrompt(task);

	if (ctx.isIdle()) {
		pi.sendUserMessage(prompt);
		ctx.ui.notify("Started agent duel: scout vs planner (suggestions only)", "info");
	} else {
		pi.sendUserMessage(prompt, { deliverAs: "followUp" });
		ctx.ui.notify("Queued agent duel as follow-up", "info");
	}
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("duel", {
		description: "Ask scout + planner the same prompt (read-only) and compare their suggestions",
		handler: async (args, ctx) => {
			const fromArgs = args.trim();
			const fromInput = fromArgs
				? fromArgs
				: (await ctx.ui.input("Agent duel", "Prompt for both agents (suggestions only)"))?.trim() ?? "";

			if (!fromInput) {
				ctx.ui.notify("Agent duel cancelled", "warning");
				return;
			}

			queueDuel(pi, ctx, fromInput);
		},
	});

	pi.registerShortcut(Key.ctrlShift("y"), {
		description: "Agent duel (scout vs planner, suggestions only)",
		handler: async (ctx) => {
			const task = (await ctx.ui.input("Agent duel", "Prompt for both agents (suggestions only)"))?.trim();
			if (!task) return;
			queueDuel(pi, ctx, task);
		},
	});
}
