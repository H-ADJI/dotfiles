import { existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import type {
	ExtensionAPI,
	ExtensionContext,
	KeybindingsManager,
	Theme,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI } from "@earendil-works/pi-tui";
import { loadConfig, type ZentuiConfig } from "./config";
import { installFooter } from "./footer";
import { emptyGitStatus, readGitStatus } from "./git";
import { readPackageVersionResult } from "./package-version";
import { installSelectorBorderStyle, removeSelectorBorderStyle } from "./selector-border";
import { SessionLifecycle } from "./session-lifecycle";
import {
	applyGitToState,
	createInitialState,
	modelLabelFor,
	syncState,
	type FooterState,
} from "./state";
import { PolishedEditor } from "./ui";
import { installUserMessageStyle, removeUserMessageStyle } from "./user-message";
import { WorkingLineController } from "./working-line";

function findRepositoryRoot(cwd: string): string | undefined {
	let current = resolve(cwd);
	while (true) {
		if (existsSync(join(current, ".git"))) return current;
		const parent = dirname(current);
		if (parent === current) return undefined;
		current = parent;
	}
}

export default function (pi: ExtensionAPI) {
	let currentConfig: ZentuiConfig = loadConfig();
	const state: FooterState = createInitialState(emptyGitStatus());
	const sessionLifecycle = new SessionLifecycle();
	let activeTheme: Theme | undefined;
	let requestEditorRender: (() => void) | undefined;
	let requestFooterRender: (() => void) | undefined;
	let runCost = 0;
	let projectRoot: string | undefined;
	let cleanupUserMessages: () => void = () => {};
	let cleanupSelectorBorders: () => void = () => {};
	let agentStartEpoch: number | undefined;
	let agentTimer: ReturnType<typeof setInterval> | undefined;
	const workingLine = new WorkingLineController(() => currentConfig);

	const getConfig = () => currentConfig;
	const getActiveTheme = () => activeTheme;
	const refresh = () => {
		requestFooterRender?.();
		requestEditorRender?.();
	};
	const getThinkingLevel = () =>
		sessionLifecycle.isCurrent() ? pi.getThinkingLevel() : ("off" as const);
	const getEditorCostLabel = () =>
		`${state.costLabel}${runCost > 0 ? ` +$${runCost.toFixed(3)}` : ""}`;

	const startAgentTimer = () => {
		if (agentTimer) return;
		agentTimer = setInterval(() => requestEditorRender?.(), 1000);
	};
	const stopAgentTimer = () => {
		if (agentTimer) clearInterval(agentTimer);
		agentTimer = undefined;
	};

	const refreshGit = async (ctx: ExtensionContext) => {
		const generation = sessionLifecycle.currentGeneration();
		const cwd = ctx.cwd;
		const [git, pkg] = await Promise.all([
			readGitStatus(cwd, { readMetrics: true }),
			readPackageVersionResult(cwd),
		]);
		if (!sessionLifecycle.isCurrent(generation)) return;
		if (git.kind === "ok") {
			projectRoot = findRepositoryRoot(cwd);
			applyGitToState(state, git.status);
		}
		if (pkg.kind === "ok") state.packageVersion = pkg.result;
		refresh();
	};

	const makeEditorFactory = (ctx: ExtensionContext) => {
		const sessionTheme = ctx.ui.theme;
		const factory = ((tui: TUI, theme: EditorTheme, keybindings: KeybindingsManager) => {
			requestEditorRender = () => tui.requestRender();
			return new PolishedEditor(
				tui,
				theme,
				keybindings,
				sessionTheme,
				getConfig,
				() => ({
					cwd: ctx.cwd,
					projectRoot,
					branch: state.branch,
					dirty: state.dirty,
					ahead: state.ahead,
					behind: state.behind,
					costLabel: getEditorCostLabel(),
					modelLabel: modelLabelFor(state, currentConfig.components.editor.modelLabel),
					thinkingLevel: getThinkingLevel(),
					contextPercent: ctx.getContextUsage()?.percent ?? undefined,
					contextWindow:
						ctx.model?.contextWindow ?? ctx.getContextUsage()?.contextWindow,
					sessionName: ctx.sessionManager.getSessionName() ?? "",
					agentDurationMs: agentStartEpoch ? Date.now() - agentStartEpoch : 0,
					agentActive: agentStartEpoch !== undefined,
				}),
			);
		}) as NonNullable<Parameters<ExtensionContext["ui"]["setEditorComponent"]>[0]>;
		return factory;
	};

	const installUi = (ctx: ExtensionContext) => {
		if (!ctx.hasUI) return;
		activeTheme = ctx.ui.theme;
		syncState(state, ctx);
		try {
			ctx.ui.setEditorComponent(makeEditorFactory(ctx));
		} catch {
			// Editor decoration is optional; fall back to the base editor.
		}
		try {
			cleanupUserMessages = installUserMessageStyle(getActiveTheme, getConfig);
		} catch {
			cleanupUserMessages = () => {};
		}
		try {
			cleanupSelectorBorders = installSelectorBorderStyle(getActiveTheme, getConfig);
		} catch {
			cleanupSelectorBorders = () => {};
		}
		installFooter(ctx, state, getConfig, {
			setRequestRender: (fn) => {
				requestFooterRender = fn;
			},
			onBranchChange: () => {
				refreshGit(ctx);
			},
			onDispose: () => {
				requestFooterRender = undefined;
			},
		});
		workingLine.startSession(ctx);
		refreshGit(ctx);
		refresh();
	};

	const cleanupUi = (ctx?: ExtensionContext) => {
		stopAgentTimer();
		try {
			cleanupUserMessages();
		} catch {
			// Best-effort cleanup.
		}
		try {
			cleanupSelectorBorders();
		} catch {
			// Best-effort cleanup.
		}
		cleanupUserMessages = () => {};
		cleanupSelectorBorders = () => {};
		requestEditorRender = undefined;
		requestFooterRender = undefined;
		activeTheme = undefined;
		if (ctx) workingLine.dispose(ctx);
	};

	pi.on("session_start", async (_event, ctx) => {
		sessionLifecycle.start();
		state.sessionStartEpoch = Date.now();
		runCost = 0;
		projectRoot = undefined;
		agentStartEpoch = undefined;
		installUi(ctx);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		sessionLifecycle.shutdown();
		cleanupUi(ctx);
	});

	pi.on("agent_start", () => {
		runCost = 0;
		agentStartEpoch = Date.now();
		startAgentTimer();
		refresh();
	});

	pi.on("turn_end", (event) => {
		const msg = event.message;
		if (msg.role !== "assistant") return;
		runCost += msg.usage.cost.total;
		requestEditorRender?.();
	});

	pi.on("agent_settled", () => {
		agentStartEpoch = undefined;
		stopAgentTimer();
		refresh();
	});

	pi.on("agent_end", (_event, ctx) => {
		syncState(state, ctx);
		refresh();
	});

	pi.on("model_select", (_event, ctx) => {
		syncState(state, ctx);
		refresh();
	});

	pi.on("thinking_level_select", (_event, ctx) => {
		syncState(state, ctx);
		refresh();
	});

	pi.on("session_info_changed", (_event, ctx) => {
		syncState(state, ctx);
		refresh();
	});

	pi.on("session_compact", (_event, ctx) => {
		syncState(state, ctx);
		refresh();
	});
}
