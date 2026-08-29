import type {
    ExtensionAPI,
    ExtensionContext,
    KeybindingsManager,
    Theme,
} from "@earendil-works/pi-coding-agent";
import type { EditorTheme, TUI } from "@earendil-works/pi-tui";
import { loadConfig, type SimpleTuiConfig } from "./config";
import { installFooter } from "./footer";
import { installSelectorBorderStyle } from "./selector-border";
import { PolishedEditor } from "./ui";
import { installUserMessageStyle } from "./user-message";
import { WorkingLineController } from "./working-line";

export default function (pi: ExtensionAPI) {
    let currentConfig: SimpleTuiConfig = loadConfig();
    let activeTheme: Theme | undefined;
    let requestEditorRender: (() => void) | undefined;
    let requestFooterRender: (() => void) | undefined;
    let agentStartEpoch: number | undefined;
    let agentTimer: ReturnType<typeof setInterval> | undefined;
    let modelLabel = "none";
    let cleanupUserMessages: () => void = () => {};
    let cleanupSelectorBorders: () => void = () => {};
    const workingLine = new WorkingLineController(() => currentConfig);

    const getConfig = () => currentConfig;
    const getActiveTheme = () => activeTheme;
    const refresh = () => {
        requestFooterRender?.();
        requestEditorRender?.();
    };
    const getThinkingLevel = () => pi.getThinkingLevel();

    const startAgentTimer = () => {
        if (agentTimer) return;
        agentTimer = setInterval(() => requestEditorRender?.(), 1000);
    };
    const stopAgentTimer = () => {
        if (agentTimer) clearInterval(agentTimer);
        agentTimer = undefined;
    };

    const makeEditorFactory = (ctx: ExtensionContext) => {
        const sessionTheme = ctx.ui.theme;
        return ((
            tui: TUI,
            theme: EditorTheme,
            keybindings: KeybindingsManager,
        ) => {
            requestEditorRender = () => tui.requestRender();
            return new PolishedEditor(
                tui,
                theme,
                keybindings,
                sessionTheme,
                getConfig,
                () => ({
                    cwd: ctx.cwd,
                    modelLabel,
                    thinkingLevel: getThinkingLevel(),
                    contextPercent: ctx.getContextUsage()?.percent ?? undefined,
                    contextWindow:
                        ctx.model?.contextWindow ??
                        ctx.getContextUsage()?.contextWindow,
                    sessionName: ctx.sessionManager.getSessionName() ?? "",
                    agentDurationMs: agentStartEpoch
                        ? Date.now() - agentStartEpoch
                        : 0,
                    agentActive: agentStartEpoch !== undefined,
                }),
            );
        }) as NonNullable<
            Parameters<ExtensionContext["ui"]["setEditorComponent"]>[0]
        >;
    };

    const installUi = (ctx: ExtensionContext) => {
        if (!ctx.hasUI) return;
        activeTheme = ctx.ui.theme;
        modelLabel = ctx.model?.id ?? "none";
        try {
            ctx.ui.setEditorComponent(makeEditorFactory(ctx));
        } catch {
            // Editor decoration is optional; fall back to the base editor.
        }
        try {
            cleanupUserMessages = installUserMessageStyle(
                getActiveTheme,
                getConfig,
            );
        } catch {
            cleanupUserMessages = () => {};
        }
        try {
            cleanupSelectorBorders = installSelectorBorderStyle(
                getActiveTheme,
                getConfig,
            );
        } catch {
            cleanupSelectorBorders = () => {};
        }
        installFooter(ctx, getConfig, {
            setRequestRender: (fn) => {
                requestFooterRender = fn;
            },
            onDispose: () => {
                requestFooterRender = undefined;
            },
        });
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
        currentConfig = loadConfig();
        if (!currentConfig.enabled) return;
        agentStartEpoch = undefined;
        installUi(ctx);
    });

    pi.on("session_shutdown", async (_event, ctx) => {
        cleanupUi(ctx);
    });

    pi.on("agent_start", () => {
        agentStartEpoch = Date.now();
        startAgentTimer();
        refresh();
    });

    pi.on("turn_start", (_event, ctx) => {
        workingLine.startTurn(ctx);
    });

    pi.on("agent_settled", () => {
        agentStartEpoch = undefined;
        stopAgentTimer();
        refresh();
    });

    pi.on("model_select", (_event, ctx) => {
        modelLabel = ctx.model?.id ?? "none";
        refresh();
    });

    pi.on("thinking_level_select", (_event, ctx) => {
        refresh();
    });

    pi.on("session_info_changed", (_event, ctx) => {
        refresh();
    });
}