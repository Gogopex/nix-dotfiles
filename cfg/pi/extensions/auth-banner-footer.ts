/**
 * Auth Banner Footer
 *
 * Replaces the default footer to:
 * - hide cost/price
 * - keep exactly two clean lines
 * - show compact auth indicator (Sub/API)
 * - place auth indicator on the same line as jj/git status
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

function sanitizeStatusText(text: string): string {
	return text
		.replace(/[\r\n\t]/g, " ")
		.replace(/ +/g, " ")
		.trim();
}

function formatTokens(count: number): string {
	if (count < 1000) return count.toString();
	if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1000000) return `${Math.round(count / 1000)}k`;
	if (count < 10000000) return `${(count / 1000000).toFixed(1)}M`;
	return `${Math.round(count / 1000000)}M`;
}

function compactPath(path: string, width: number): string {
	const home = process.env.HOME || process.env.USERPROFILE;
	let out = home && path.startsWith(home) ? `~${path.slice(home.length)}` : path;
	if (out.length <= width) return out;
	const half = Math.max(4, Math.floor((width - 3) / 2));
	return `${out.slice(0, half)}...${out.slice(-(half - 1))}`;
}

function padRight(left: string, right: string, width: number): string {
	const leftWidth = visibleWidth(left);
	const rightWidth = visibleWidth(right);
	if (leftWidth + 2 + rightWidth <= width) {
		return left + " ".repeat(Math.max(2, width - leftWidth - rightWidth)) + right;
	}

	const maxRight = Math.max(8, Math.floor(width * 0.45));
	const truncatedRight = truncateToWidth(right, maxRight);
	const freeForLeft = Math.max(1, width - visibleWidth(truncatedRight) - 2);
	const truncatedLeft = truncateToWidth(left, freeForLeft);
	const gap = " ".repeat(Math.max(2, width - visibleWidth(truncatedLeft) - visibleWidth(truncatedRight)));
	return truncateToWidth(truncatedLeft + gap + truncatedRight, width);
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const branch = footerData.getGitBranch();
					const sessionName = ctx.sessionManager.getSessionName();

					let pathLine = compactPath(process.cwd(), Math.max(20, width));
					if (sessionName) pathLine += ` • ${sessionName}`;

					const rawVcs = footerData.getExtensionStatuses().get("vcs");
					const vcsPart = rawVcs
						? sanitizeStatusText(rawVcs).replace(/^[●•]\s*/, "")
						: branch
							? theme.fg("dim", `git:${branch}`)
							: theme.fg("dim", "no-vcs");

					let contextPart = theme.fg("dim", "ctx --");
					const contextUsage = ctx.getContextUsage();
					if (contextUsage && contextUsage.contextWindow > 0) {
						const pct = (contextUsage.tokens / contextUsage.contextWindow) * 100;
						const text = `ctx ${pct.toFixed(1)}%/${formatTokens(contextUsage.contextWindow)}`;
						if (pct > 90) contextPart = theme.fg("error", text);
						else if (pct > 70) contextPart = theme.fg("warning", text);
						else contextPart = theme.fg("dim", text);
					}

					const modelPart = ctx.model
						? theme.fg("dim", `${ctx.model.id}${ctx.model.reasoning ? `/${pi.getThinkingLevel()}` : ""}`)
						: theme.fg("warning", "no-model");

					let authPart = theme.fg("warning", "NoModel");
					let accountPart = "";
					if (ctx.model) {
						const usingOAuth = ctx.modelRegistry.isUsingOAuth(ctx.model);
						authPart = usingOAuth
							? `${theme.fg("success", "Sub")} ${theme.fg("dim", "API")}`
							: `${theme.fg("dim", "Sub")} ${theme.fg("error", theme.bold("API"))}`;

						if (usingOAuth) {
							const credential = ctx.modelRegistry.authStorage.get(ctx.model.provider);
							const email = credential && credential.type === "oauth" && typeof credential.email === "string"
								? credential.email.toLowerCase()
								: undefined;

							if (email) {
								const isWork = email.endsWith("@chess.com");
								accountPart = isWork ? theme.fg("warning", "Work") : theme.fg("accent", "Personal");
							} else if (credential && credential.type === "oauth" && typeof credential.accountId === "string") {
								const workAccountIds = (process.env.PI_WORK_ACCOUNT_IDS || "")
									.split(",")
									.map((v) => v.trim())
									.filter(Boolean);
								accountPart = workAccountIds.includes(credential.accountId)
									? theme.fg("warning", "Work")
									: theme.fg("accent", "Personal");
							}
						}
					}

					const rightPieces = [contextPart, modelPart, authPart, accountPart].filter(Boolean);
					const rightPart = rightPieces.join("  ");
					const secondLine = padRight(vcsPart, rightPart, width);

					return [
						truncateToWidth(theme.fg("dim", pathLine), width),
						truncateToWidth(secondLine, width),
					];
				},
			};
		});
	});
}
