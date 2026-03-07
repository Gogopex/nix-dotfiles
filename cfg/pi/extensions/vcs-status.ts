/**
 * VCS status extension
 *
 * Shows lightweight repo context in Pi footer status:
 * - jj: workspace + change id + dirty marker
 * - git fallback: branch + dirty marker
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

interface VcsInfo {
	kind: "jj" | "git";
	label: string;
	dirty: boolean;
}

function parseJjWorkspaceLine(line: string): { workspace: string; changeId: string } | null {
	// Example: default: qumsomru 3505cbb6 (no description set)
	const match = line.match(/^([^:\s]+):\s+\S+\s+([0-9a-f]{6,})/i);
	if (!match) return null;
	return { workspace: match[1], changeId: match[2].slice(0, 8) };
}

function isJjDirty(statusOutput: string): boolean {
	if (!statusOutput.trim()) return false;
	// Match changed file lines like: "M file.ts", "A file.ts", "? file.ts"
	return /^\s*[MADRC?]\s+/m.test(statusOutput);
}

async function getVcsInfo(pi: ExtensionAPI): Promise<VcsInfo | null> {
	const jjWorkspace = await pi.exec("jj", ["workspace", "list", "--color=never"]);
	if (jjWorkspace.code === 0) {
		const firstLine = jjWorkspace.stdout.split("\n").map((l) => l.trim()).find(Boolean);
		if (firstLine) {
			const parsed = parseJjWorkspaceLine(firstLine);
			if (parsed) {
				const jjStatus = await pi.exec("jj", ["status", "--color=never"]);
				const dirty = jjStatus.code === 0 ? isJjDirty(jjStatus.stdout) : false;
				return {
					kind: "jj",
					label: `jj:${parsed.workspace}@${parsed.changeId}`,
					dirty,
				};
			}
		}
	}

	const gitBranch = await pi.exec("git", ["rev-parse", "--abbrev-ref", "HEAD"]);
	if (gitBranch.code === 0) {
		const branch = gitBranch.stdout.trim();
		if (branch) {
			const gitStatus = await pi.exec("git", ["status", "--porcelain"]);
			const dirty = gitStatus.code === 0 && gitStatus.stdout.trim().length > 0;
			return {
				kind: "git",
				label: `git:${branch}`,
				dirty,
			};
		}
	}

	return null;
}

function renderStatus(ctx: ExtensionContext, info: VcsInfo | null): string | undefined {
	if (!info) return undefined;

	const theme = ctx.ui.theme;
	const dot = info.dirty ? theme.fg("warning", "●") : theme.fg("success", "●");
	const color = info.kind === "jj" ? "accent" : "muted";
	return `${dot} ${theme.fg(color, info.label)}`;
}

export default function (pi: ExtensionAPI) {
	let updating = false;
	let queued = false;

	const refresh = async (ctx: ExtensionContext) => {
		if (updating) {
			queued = true;
			return;
		}

		updating = true;
		do {
			queued = false;
			try {
				const info = await getVcsInfo(pi);
				ctx.ui.setStatus("vcs", renderStatus(ctx, info));
			} catch {
				ctx.ui.setStatus("vcs", undefined);
			}
		} while (queued);
		updating = false;
	};

	pi.on("session_start", async (_event, ctx) => refresh(ctx));
	pi.on("turn_end", async (_event, ctx) => refresh(ctx));
	pi.on("session_switch", async (_event, ctx) => refresh(ctx));
	pi.on("session_tree", async (_event, ctx) => refresh(ctx));
	pi.on("session_fork", async (_event, ctx) => refresh(ctx));
}
