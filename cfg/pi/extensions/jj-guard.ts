/**
 * JJ guard extension
 *
 * Blocks risky mutating git commands and nudges toward jj equivalents.
 * Helpful for jj-first workflows.
 */

import { isToolCallEventType, type ExtensionAPI } from "@mariozechner/pi-coding-agent";

const gitWritePattern =
	/\bgit\s+(commit|push|rebase|merge|cherry-pick|revert|reset|switch|checkout|tag|stash|branch\s+-d|restore\s+--staged)\b/i;

function jjHint(command: string): string {
	if (/\bgit\s+commit\b/i.test(command)) return "Try: jj describe (or jj commit).";
	if (/\bgit\s+push\b/i.test(command)) return "Try: jj git push.";
	if (/\bgit\s+rebase\b/i.test(command)) return "Try: jj rebase.";
	if (/\bgit\s+merge\b/i.test(command)) return "Try: jj squash or jj abandon + rebase (depends on intent).";
	if (/\bgit\s+cherry-pick\b/i.test(command)) return "Try: jj cherry-pick <rev>.";
	if (/\bgit\s+reset\b/i.test(command)) return "Try: jj restore / jj abandon / jj op undo (depends on intent).";
	if (/\bgit\s+checkout\b/i.test(command) || /\bgit\s+switch\b/i.test(command))
		return "Try: jj new / jj edit / jj workspace add.";
	return "This repo is configured jj-first. Prefer jj equivalents.";
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (!isToolCallEventType("bash", event)) return;

		const command = event.input.command?.trim() ?? "";
		if (!gitWritePattern.test(command)) return;

		if (!ctx.hasUI) {
			return { block: true, reason: "Blocked mutating git command in non-interactive mode (jj guard)" };
		}

		const ok = await ctx.ui.confirm(
			"jj-first guard",
			`${command}\n\n${jjHint(command)}\n\nAllow this command once?`,
		);

		if (!ok) {
			return { block: true, reason: "Blocked by jj-first guard" };
		}
	});
}
