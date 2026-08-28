import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { resolveConfiguredIcons, type IconMode, type ResolvedIcons } from "./icons";

export type ColorSpec = string;
export type ColorSource = "theme" | "terminal";
export type { IconMode } from "./icons";

export type ContextThresholds = { warning: number; error: number };
export type PathDisplayMode = "basename" | "full";
export type MinimalistPathDisplayMode = "compact" | "project" | "full";
export type MinimalistContextFormat = "percent" | "percent-total";
export type EditorBorderColorMode = "static" | "adaptive";
export type SeparatorStyle = "pipe" | "dot" | "chevron" | "none";
export type ModelLabelSource = "id" | "name";
export type ExtensionStatusPlacement = "off" | "left" | "middle" | "right";
export type ExtensionStatusColorMode = "zentui" | "original";

export type DeepseekTierConfig = {
	peakWindowsUtc: [number, number][];
	labels: { peak: string; offPeak: string };
};

export type MinimalistEditorStyleConfig = {
	pathDisplay: MinimalistPathDisplayMode;
	contextFormat: MinimalistContextFormat;
	contextGauge: boolean;
	showTimer: boolean;
	showCost: boolean;
	showSessionName: boolean;
	showGit: boolean;
	contextThresholds: ContextThresholds;
};

export type EditorComponentConfig = {
	enabled: boolean;
	style: "minimalist";
	colorSource: ColorSource;
	viewportIndicators: boolean;
	borderColorMode: EditorBorderColorMode;
	modelLabel: ModelLabelSource;
	styles: { minimalist: MinimalistEditorStyleConfig };
};

export type UserMessagesComponentConfig = {
	enabled: boolean;
	style: "labeled";
	colorSource: ColorSource;
};

export type SelectorBordersComponentConfig = {
	enabled: boolean;
	style: "zentui";
	colorSource: ColorSource;
};

export type GitMetricsConfig = { onlyNonzero: boolean; ignoreSubmodules: boolean };
export type ExtensionStatusesConfig = {
	defaultPlacement: ExtensionStatusPlacement;
	placements: Record<string, ExtensionStatusPlacement>;
	colorModes: Record<string, ExtensionStatusColorMode>;
};

export type StarshipFooterStyleConfig = {
	separator: SeparatorStyle;
	segments: {
		deepseekTier: boolean;
	};
	extensionStatuses: ExtensionStatusesConfig;
};

export type FooterComponentConfig = {
	enabled: boolean;
	style: "starship";
	colorSource: ColorSource;
	modelLabel: ModelLabelSource;
	styles: { starship: StarshipFooterStyleConfig };
};

export type WorkingLineComponentConfig = {
	enabled: boolean;
	spinner: string;
	textIntervalMs: number;
	colorSource: ColorSource;
	messages: { custom: boolean };
};

export type ComponentsConfig = {
	editor: EditorComponentConfig;
	userMessages: UserMessagesComponentConfig;
	selectorBorders: SelectorBordersComponentConfig;
	footer: FooterComponentConfig;
	workingLine: WorkingLineComponentConfig;
};

export type PolishedTuiColors = {
	editorAccent: ColorSpec;
	editorBorder: ColorSpec;
	editorModel: ColorSpec;
	editorProvider: ColorSpec;
	editorThinking: ColorSpec;
	editorThinkingMinimal: ColorSpec;
	editorThinkingLow: ColorSpec;
	editorThinkingMedium: ColorSpec;
	editorThinkingHigh: ColorSpec;
	editorThinkingXhigh: ColorSpec;
	editorThinkingMax: ColorSpec;
	cost: ColorSpec;
	sessionName: ColorSpec;
	sessionDuration: ColorSpec;
	contextNormal: ColorSpec;
	contextWarning: ColorSpec;
	contextError: ColorSpec;
	editorGitBranch: ColorSpec;
	gitStatus: ColorSpec;
	cwd: ColorSpec;
	separator: ColorSpec;
	extensionStatus: ColorSpec;
	workingLineHigh: ColorSpec;
};

export type ZentuiConfig = {
	components: ComponentsConfig;
	colors: PolishedTuiColors;
	icons: ResolvedIcons;
	deepseekTier: DeepseekTierConfig;
};

const defaultColors: PolishedTuiColors = {
	editorAccent: "blue",
	editorBorder: "bright-black",
	editorModel: "bold purple",
	editorProvider: "bright-black",
	editorThinking: "bold yellow",
	editorThinkingMinimal: "bright-black",
	editorThinkingLow: "blue",
	editorThinkingMedium: "cyan",
	editorThinkingHigh: "yellow",
	editorThinkingXhigh: "red",
	editorThinkingMax: "bright-red",
	cost: "bold green",
	sessionName: "bright-black",
	sessionDuration: "bright-black",
	contextNormal: "green",
	contextWarning: "yellow",
	contextError: "red",
	editorGitBranch: "bold blue",
	gitStatus: "red",
	cwd: "bold cyan",
	separator: "bright-black",
	extensionStatus: "green",
	workingLineHigh: "bold green",
};

const defaultConfig: ZentuiConfig = {
	components: {
		editor: {
			enabled: true,
			style: "minimalist",
			colorSource: "terminal",
			viewportIndicators: false,
			borderColorMode: "adaptive",
			modelLabel: "id",
			styles: {
				minimalist: {
					pathDisplay: "full",
					contextFormat: "percent-total",
					contextGauge: false,
					showTimer: true,
					showCost: true,
					showSessionName: true,
					showGit: true,
					contextThresholds: { warning: 70, error: 90 },
				},
			},
		},
		userMessages: { enabled: true, style: "labeled", colorSource: "terminal" },
		selectorBorders: { enabled: true, style: "zentui", colorSource: "terminal" },
		footer: {
			enabled: true,
			style: "starship",
			colorSource: "terminal",
			modelLabel: "id",
			styles: {
				starship: {
					separator: "pipe",
					segments: {
						deepseekTier: true,
					},
					extensionStatuses: {
						defaultPlacement: "right",
						placements: {},
						colorModes: {},
					},
				},
			},
		},
		workingLine: {
			enabled: true,
			spinner: "pinwheel",
			textIntervalMs: 40,
			colorSource: "terminal",
			messages: { custom: false },
		},
	},
	colors: defaultColors,
	icons: resolveConfiguredIcons("auto"),
	deepseekTier: {
		peakWindowsUtc: [[1, 4], [6, 10]],
		labels: { peak: "peak ⚠️", offPeak: "off-peak" },
	},
};

function readBool(v: unknown): boolean | undefined {
	return typeof v === "boolean" ? v : undefined;
}
function readStr(v: unknown): string | undefined {
	return typeof v === "string" ? v : undefined;
}

function mergeUserConfig(raw: unknown): ZentuiConfig {
	if (!raw || typeof raw !== "object") return defaultConfig;
	const parsed = raw as Record<string, unknown>;
	const components = (parsed.components ?? {}) as Record<string, unknown>;

	const editor = (components.editor ?? {}) as Record<string, unknown>;
	const editorStyles = (editor.styles ?? {}) as Record<string, unknown>;
	const minimalist = (editorStyles.minimalist ?? {}) as Record<string, unknown>;

	const userMessages = (components.userMessages ?? {}) as Record<string, unknown>;
	const selectorBorders = (components.selectorBorders ?? {}) as Record<string, unknown>;
	const footer = (components.footer ?? {}) as Record<string, unknown>;
	const footerStyles = (footer.styles ?? {}) as Record<string, unknown>;
	const starship = (footerStyles.starship ?? {}) as Record<string, unknown>;
	const segments = (starship.segments ?? {}) as Record<string, unknown>;
	const extensionStatuses = (starship.extensionStatuses ?? {}) as Record<string, unknown>;
	const colorModes = (extensionStatuses.colorModes ?? {}) as Record<string, unknown>;
	const workingLine = (components.workingLine ?? {}) as Record<string, unknown>;
	const deepseekTier = (parsed.deepseekTier ?? {}) as Record<string, unknown>;
	const deepseekLabels = (deepseekTier.labels ?? {}) as Record<string, unknown>;

	const base = defaultConfig;
	const next: ZentuiConfig = {
		...base,
		deepseekTier: {
			peakWindowsUtc: Array.isArray(deepseekTier.peakWindowsUtc)
				? (deepseekTier.peakWindowsUtc as [number, number][])
				: base.deepseekTier.peakWindowsUtc,
			labels: {
				peak:
					(readStr(deepseekLabels.peak) as string) ?? base.deepseekTier.labels.peak,
				offPeak:
					(readStr(deepseekLabels.offPeak) as string) ?? base.deepseekTier.labels.offPeak,
			},
		},
		components: {
			editor: {
				...base.components.editor,
				colorSource: (readStr(editor.colorSource) as ColorSource) ?? base.components.editor.colorSource,
				viewportIndicators: readBool(editor.viewportIndicators) ?? base.components.editor.viewportIndicators,
				styles: {
					minimalist: {
						...base.components.editor.styles.minimalist,
						pathDisplay:
							(readStr(minimalist.pathDisplay) as MinimalistPathDisplayMode) ??
							base.components.editor.styles.minimalist.pathDisplay,
						contextFormat:
							(readStr(minimalist.contextFormat) as MinimalistContextFormat) ??
							base.components.editor.styles.minimalist.contextFormat,
					},
				},
			},
			userMessages: {
				...base.components.userMessages,
				colorSource:
					(readStr(userMessages.colorSource) as ColorSource) ?? base.components.userMessages.colorSource,
			},
			selectorBorders: {
				...base.components.selectorBorders,
				colorSource:
					(readStr(selectorBorders.colorSource) as ColorSource) ??
					base.components.selectorBorders.colorSource,
			},
			footer: {
				...base.components.footer,
				colorSource: (readStr(footer.colorSource) as ColorSource) ?? base.components.footer.colorSource,
				styles: {
					starship: {
						...base.components.footer.styles.starship,
						segments: {
							deepseekTier:
								readBool(segments.deepseekTier) ??
								base.components.footer.styles.starship.segments.deepseekTier,
						},
						extensionStatuses: {
							...base.components.footer.styles.starship.extensionStatuses,
							colorModes: (() => {
								const out: Record<string, ExtensionStatusColorMode> = {};
								for (const [key, value] of Object.entries(colorModes)) {
									if (value === "zentui" || value === "original") out[key] = value;
								}
								return out;
							})(),
						},
					},
				},
			},
			workingLine: {
				...base.components.workingLine,
				textIntervalMs:
					(typeof workingLine.textIntervalMs === "number"
						? workingLine.textIntervalMs
						: base.components.workingLine.textIntervalMs),
			},
		},
	};
	return next;
}

export const configPath = join(getAgentDir(), "zentui.json");

export function loadConfig(): ZentuiConfig {
	try {
		if (!existsSync(configPath)) return defaultConfig;
		return mergeUserConfig(JSON.parse(readFileSync(configPath, "utf8")));
	} catch {
		return defaultConfig;
	}
}

export function isExtensionStatusPlacement(value: unknown): value is ExtensionStatusPlacement {
	return value === "off" || value === "left" || value === "middle" || value === "right";
}

export function getExtensionStatusPlacement(config: ZentuiConfig, key: string): ExtensionStatusPlacement {
	return (
		config.components.footer.styles.starship.extensionStatuses.placements[key] ??
		config.components.footer.styles.starship.extensionStatuses.defaultPlacement
	);
}

export function getExtensionStatusColorMode(config: ZentuiConfig, key: string): ExtensionStatusColorMode {
	return config.components.footer.styles.starship.extensionStatuses.colorModes[key] ?? "original";
}
