import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { getAgentDir } from "@earendil-works/pi-coding-agent";

export type ColorSpec = string;
export type ExtensionStatusPlacement = "off" | "left" | "middle" | "right";
export type ExtensionStatusColorMode = "zentui" | "original";
export type ContextThresholds = { warning: number; error: number };
export type PathDisplayMode = "basename" | "full";

export type DeepseekTierConfig = {
	enabled: boolean;
	peakWindowsUtc: [number, number][];
	labels: { peak: string; offPeak: string };
};

export type FooterConfig = {
	deepseekTier: DeepseekTierConfig;
};

export type WorkingLineConfig = {
	enabled: boolean;
	messages: string[];
};

export type PolishedTuiColors = {
	editorAccent: ColorSpec;
	editorBorder: ColorSpec;
	editorModel: ColorSpec;
	editorThinking: ColorSpec;
	editorThinkingMinimal: ColorSpec;
	editorThinkingLow: ColorSpec;
	editorThinkingMedium: ColorSpec;
	editorThinkingHigh: ColorSpec;
	editorThinkingXhigh: ColorSpec;
	editorThinkingMax: ColorSpec;
	sessionName: ColorSpec;
	sessionDuration: ColorSpec;
	contextNormal: ColorSpec;
	contextWarning: ColorSpec;
	contextError: ColorSpec;
	cwd: ColorSpec;
	separator: ColorSpec;
	extensionStatus: ColorSpec;
};

export type SimpleTuiConfig = {
	enabled: boolean;
	workingLine: WorkingLineConfig;
	footer: FooterConfig;
	colors: PolishedTuiColors;
};

const defaultColors: PolishedTuiColors = {
	editorAccent: "blue",
	editorBorder: "bright-black",
	editorModel: "bold purple",
	editorThinking: "bold yellow",
	editorThinkingMinimal: "bright-black",
	editorThinkingLow: "blue",
	editorThinkingMedium: "cyan",
	editorThinkingHigh: "yellow",
	editorThinkingXhigh: "red",
	editorThinkingMax: "bright-red",
	sessionName: "bright-black",
	sessionDuration: "bright-black",
	contextNormal: "green",
	contextWarning: "yellow",
	contextError: "red",
	cwd: "bold cyan",
	separator: "bright-black",
	extensionStatus: "green",
};

const defaultConfig: SimpleTuiConfig = {
	enabled: true,
	workingLine: {
		enabled: true,
		messages: ["Working"],
	},
	footer: {
		deepseekTier: {
			enabled: true,
			peakWindowsUtc: [[1, 4], [6, 10]],
			labels: { peak: "peak pricing", offPeak: "off-peak pricing" },
		},
	},
	colors: defaultColors,
};

function readBool(v: unknown): boolean | undefined {
	return typeof v === "boolean" ? v : undefined;
}
function readStr(v: unknown): string | undefined {
	return typeof v === "string" ? v : undefined;
}
function readStrArr(v: unknown): string[] | undefined {
	return Array.isArray(v) && v.every((x) => typeof x === "string") ? v : undefined;
}

function mergeUserConfig(raw: unknown): SimpleTuiConfig {
	if (!raw || typeof raw !== "object") return defaultConfig;
	const parsed = raw as Record<string, unknown>;
	const workingLine = (parsed.workingLine ?? {}) as Record<string, unknown>;
	const footer = (parsed.footer ?? {}) as Record<string, unknown>;
	const deepseekTier = (footer.deepseekTier ?? {}) as Record<string, unknown>;
	const deepseekLabels = (deepseekTier.labels ?? {}) as Record<string, unknown>;

	return {
		...defaultConfig,
		enabled: readBool(parsed.enabled) ?? defaultConfig.enabled,
		workingLine: {
			enabled: readBool(workingLine.enabled) ?? defaultConfig.workingLine.enabled,
			messages: readStrArr(workingLine.messages) ?? defaultConfig.workingLine.messages,
		},
		footer: {
			deepseekTier: {
				enabled: readBool(deepseekTier.enabled) ?? defaultConfig.footer.deepseekTier.enabled,
				peakWindowsUtc: Array.isArray(deepseekTier.peakWindowsUtc)
					? (deepseekTier.peakWindowsUtc as [number, number][])
					: defaultConfig.footer.deepseekTier.peakWindowsUtc,
				labels: {
					peak: readStr(deepseekLabels.peak) ?? defaultConfig.footer.deepseekTier.labels.peak,
					offPeak: readStr(deepseekLabels.offPeak) ?? defaultConfig.footer.deepseekTier.labels.offPeak,
				},
			},
		},
	};
}

export const configPath = join(getAgentDir(), "simpleTui.json");

export function loadConfig(): SimpleTuiConfig {
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

export function getExtensionStatusPlacement(_config: SimpleTuiConfig, _key: string): ExtensionStatusPlacement {
	return "right";
}

export function getExtensionStatusColorMode(_config: SimpleTuiConfig, _key: string): ExtensionStatusColorMode {
	return "original";
}
