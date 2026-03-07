/**
 * JJ checkpoint extension
 *
 * Optional auto-checkpointing for jj repos.
 * - Default: off
 * - Enable with /jj-checkpoint on or --jj-checkpoint
 * - Auto mode checkpoints after turns that used edit/write tools
 * - Manual checkpoint: /jj-checkpoint now
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const STATUS_KEY = "jj-cp";
let enabled = false;
let checkpointCount = 0;

async function isJjRepo(pi: ExtensionAPI): Promise<boolean> {
	const result = await pi.exec("jj", ["root"]);
	return result.code === 0;
}

async function hasWorkingCopyChanges(pi: ExtensionAPI): Promise<boolean> {
	const result = await pi.exec("jj", ["status", "--color=never"]);
	if (result.code !== 0) return false;
	return /^\s*[MADRC?]\s+/m.test(result.stdout);
}

function setStatus(ctx: ExtensionContext): void {
	if (!enabled) {
		ctx.ui.setStatus(STATUS_KEY, undefined);
		return;
	}
	ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("warning", "● jj-cp:on"));
}

async function createCheckpoint(pi: ExtensionAPI, reason: string): Promise<{ ok: boolean; detail: string }> {
	if (!(await isJjRepo(pi))) return { ok: false, detail: "not a jj repo" };
	if (!(await hasWorkingCopyChanges(pi))) return { ok: false, detail: "working copy clean" };

	const command = ["new", "-m", `pi checkpoint: ${reason}`];
	const result = await pi.exec("jj", command);
	if (result.code !== 0) {
		const detail = result.stderr?.trim() || result.stdout?.trim() || `exit ${result.code}`;
		return { ok: false, detail };
	}
	checkpointCount += 1;
	return { ok: true, detail: `checkpoint #${checkpointCount}` };
}

export default function (pi: ExtensionAPI) {
	pi.registerFlag("jj-checkpoint", {
		description: "Enable automatic jj checkpoints after edit/write turns",
		type: "boolean",
		default: false,
	});

	pi.registerCommand("jj-checkpoint", {
		description: "jj checkpoint control: /jj-checkpoint [on|off|now|status]",
		handler: async (args, ctx) => {
			const action = args.trim().toLowerCase() || "status";

			if (action === "on") {
				enabled = true;
				setStatus(ctx);
				ctx.ui.notify("jj auto-checkpoint enabled", "info");
				return;
			}

			if (action === "off") {
				enabled = false;
				setStatus(ctx);
				ctx.ui.notify("jj auto-checkpoint disabled", "info");
				return;
			}

			if (action === "now") {
				const result = await createCheckpoint(pi, `manual ${new Date().toISOString()}`);
				if (result.ok) ctx.ui.notify(`jj ${result.detail}`, "info");
				else ctx.ui.notify(`jj checkpoint skipped: ${result.detail}`, "warning");
				return;
			}

			const mode = enabled ? "on" : "off";
			ctx.ui.notify(`jj checkpoint status: ${mode}, created: ${checkpointCount}`, "info");
		},
	});

	pi.on("session_start", async (_event, ctx) => {
		enabled = Boolean(pi.getFlag("jj-checkpoint"));
		checkpointCount = 0;
		setStatus(ctx);
	});

	pi.on("session_switch", async (_event, ctx) => {
		checkpointCount = 0;
		setStatus(ctx);
	});

	pi.on("turn_end", async (event, ctx) => {
		if (!enabled) return;

		const usedEditOrWrite = event.toolResults.some(
			(toolResult) => toolResult.toolName === "edit" || toolResult.toolName === "write",
		);
		if (!usedEditOrWrite) return;

		const result = await createCheckpoint(pi, `turn ${checkpointCount + 1}`);
		if (result.ok) {
			ctx.ui.notify(`jj ${result.detail}`, "info");
		} else {
			ctx.ui.notify(`jj checkpoint skipped: ${result.detail}`, "warning");
		}
		setStatus(ctx);
	});
}
