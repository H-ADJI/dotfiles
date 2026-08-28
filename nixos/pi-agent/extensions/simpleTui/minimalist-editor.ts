import { basename, isAbsolute, relative, sep } from "node:path";
import type { Theme } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import type { SimpleTuiConfig } from "./config";
import { sanitizeEditorMetadataText } from "./editor-metadata-format";
import {
	contextColorTier,
	formatCount,
	formatCwdLabel,
	formatElapsedDuration,
} from "./format";

export { formatElapsedDuration } from "./format";

import {
	EDITOR_ACCENT_FALLBACK,
	EDITOR_BORDER_FALLBACK,
	renderStyle,
	renderStyleOrFallback,
	safeThemeFg,
} from "./style";

const MINIMALIST_MODEL_FALLBACK = "bold purple";
const MINIMALIST_THINKING_FALLBACK = "bold yellow";
const MINIMALIST_ADAPTIVE_TERMINAL_THINKING_FALLBACKS: Record<string, string> = {
	minimal: "bright-black",
	low: "blue",
	medium: "cyan",
	high: "yellow",
	xhigh: "red",
	max: "bright-red",
};

export type MinimalistEditorMetadata = {
	cwd: string;
	projectRoot?: string;
	branch?: string;
	dirty?: boolean;
	ahead?: number;
	behind?: number;
	costLabel?: string;
	modelLabel?: string;
	thinkingLevel?: string;
	contextPercent?: number;
	contextWindow?: number;
	sessionName?: string;
	agentDurationMs?: number;
	agentActive?: boolean;
};

export type MinimalistFrameOptions = {
	width: number;
	editorLines: string[];
	autocompleteLines?: string[];
	viewport?: {
		above?: string;
		below?: string;
	};
	inputText: string;
	metadata: MinimalistEditorMetadata;
	uiTheme: Theme;
	config: SimpleTuiConfig;
	borderColor?: (text: string) => string;
};

function fillLine(content: string, width: number): string {
	const truncated = truncateToWidth(content, Math.max(0, width), "");
	return `${truncated}${" ".repeat(Math.max(0, width - visibleWidth(truncated)))}`;
}

function clampLines(lines: string[], width: number): string[] {
	return lines.map((line) => truncateToWidth(line, Math.max(0, width), ""));
}

export function renderFramedAutocompleteRows({
	width,
	lines,
	renderBorder,
}: {
	width: number;
	lines: string[];
	renderBorder: (text: string) => string;
}): string[] {
	if (width <= 4 || lines.length === 0) return clampLines(lines, width);
	const contentWidth = width - 4;
	return clampLines(
		[
			`${renderBorder("├")}${renderBorder("─".repeat(width - 2))}${renderBorder("┤")}`,
			...lines.map(
				(line) => `${renderBorder("│")} ${fillLine(line, contentWidth)} ${renderBorder("│")}`,
			),
		],
		width,
	);
}

function joinStyled(parts: string[], separator: string): string {
	return parts.filter(Boolean).join(separator);
}

function thinkingStyle(config: SimpleTuiConfig, level: string): string | undefined {
	switch (level.toLowerCase()) {
		case "minimal":
			return config.colors.editorThinkingMinimal ?? config.colors.editorThinking;
		case "low":
			return config.colors.editorThinkingLow ?? config.colors.editorThinking;
		case "medium":
			return config.colors.editorThinkingMedium ?? config.colors.editorThinking;
		case "high":
			return config.colors.editorThinkingHigh ?? config.colors.editorThinking;
		case "xhigh":
			return config.colors.editorThinkingXhigh ?? config.colors.editorThinking;
		case "max":
			return (
				config.colors.editorThinkingMax ??
				config.colors.editorThinkingXhigh ??
				config.colors.editorThinking
			);
		default:
			return config.colors.editorThinking;
	}
}

function renderTopLeft(
	inputText: string,
	metadata: MinimalistEditorMetadata,
	uiTheme: Theme,
	config: SimpleTuiConfig,
	includeSessionName = true,
): string {
	const trimmed = inputText.trimStart();
	const bashMode = trimmed.startsWith("!!") ? "no-context" : trimmed.startsWith("!") ? "shell" : "";
	const parts: string[] = [];
	if (bashMode) {
		parts.push(
			bashMode === "no-context"
				? safeThemeFg(uiTheme, "muted", "$")
				: safeThemeFg(uiTheme, "bashMode", "$"),
		);
	}
	if (metadata.agentDurationMs !== undefined) {
		const duration = formatElapsedDuration(metadata.agentDurationMs);
		parts.push(
			metadata.agentActive
				? renderStyleOrFallback(
						uiTheme,
						config.colors.sessionDuration,
						EDITOR_ACCENT_FALLBACK,
						duration,
					)
				: safeThemeFg(uiTheme, "muted", duration),
		);
	}
	const sessionName = includeSessionName
		? sanitizeEditorMetadataText(metadata.sessionName ?? "")
		: "";
	if (sessionName) {
		parts.push(renderStyle(uiTheme, config.colors.sessionName, sessionName));
	}
	return joinStyled(parts, safeThemeFg(uiTheme, "muted", " · "));
}

function renderTopRight(
	metadata: MinimalistEditorMetadata,
	uiTheme: Theme,
	config: SimpleTuiConfig,
	availableWidth: number,
	renderBorder: (text: string) => string,
	renderThinking: (text: string) => string,
): string {
	const parts: string[] = [];
	const joinParts = (values: string[]) =>
		values.map((part, index) => (index > 0 ? `${renderBorder(" – ")}${part}` : part)).join("");
	const cost = sanitizeEditorMetadataText(metadata.costLabel ?? "");
	if (cost) {
		parts.push(renderStyle(uiTheme, config.colors.cost, cost));
	}
	const model = sanitizeEditorMetadataText(metadata.modelLabel ?? "");
	if (model) {
		parts.push(
			renderStyleOrFallback(
				uiTheme,
				config.colors.editorModel,
				MINIMALIST_MODEL_FALLBACK,
				model,
			),
		);
	}
	const thinking = sanitizeEditorMetadataText(metadata.thinkingLevel ?? "");
	if (thinking && thinking.toLowerCase() !== "off") {
		parts.push(renderThinking(thinking));
	}
	if (metadata.contextPercent !== undefined && Number.isFinite(metadata.contextPercent)) {
		const percent = Math.round(Math.max(0, Math.min(999, metadata.contextPercent)));
		const tier = contextColorTier(percent, { warning: 70, error: 90 });
		const style =
			tier === "error"
				? config.colors.contextError
				: tier === "warning"
					? config.colors.contextWarning
					: config.colors.contextNormal;
		const total =
			config.editor.contextFormat === "percent-total" &&
			metadata.contextWindow !== undefined &&
			Number.isFinite(metadata.contextWindow) &&
			metadata.contextWindow > 0
				? `/${formatCount(metadata.contextWindow)}`
				: "";
		const text = `${percent}%${total}`;
		parts.push(renderStyle(uiTheme, style, text));
	}
	return joinParts(parts);
}

function minimalistCwdLabel(metadata: MinimalistEditorMetadata, config: SimpleTuiConfig): string {
	const full = () => formatCwdLabel(metadata.cwd, "", { mode: "full", depth: 0 });
	if (config.editor.pathDisplay === "full") return full();
	if (config.editor.pathDisplay === "compact")
		return basename(metadata.cwd) || metadata.cwd;
	if (!metadata.projectRoot) return full();

	const pathFromRoot = relative(metadata.projectRoot, metadata.cwd);
	if (pathFromRoot === ".." || pathFromRoot.startsWith(`..${sep}`) || isAbsolute(pathFromRoot)) {
		return full();
	}
	const project = basename(metadata.projectRoot) || metadata.projectRoot;
	return pathFromRoot ? `${project}/${pathFromRoot}` : project;
}

function renderBottomRight(
	metadata: MinimalistEditorMetadata,
	uiTheme: Theme,
	config: SimpleTuiConfig,
): string {
	const cwd = sanitizeEditorMetadataText(minimalistCwdLabel(metadata, config));
	return cwd
		? renderStyle(uiTheme, config.colors.cwd, cwd)
		: "";
}

function renderLabeledBorder(options: {
	width: number;
	left: string;
	leftFallbacks?: string[];
	right: string;
	leftCorner: string;
	rightCorner: string;
	renderBorder: (text: string) => string;
}): string {
	const innerWidth = Math.max(0, options.width - 2);
	let left = options.left;
	let right = options.right;
	const fitLabels = () => {
		const overhead = (left ? 3 : 1) + (right ? 3 : 1);
		const budget = Math.max(0, innerWidth - overhead);
		const leftNatural = visibleWidth(left);
		const rightNatural = visibleWidth(right);
		if (leftNatural + rightNatural <= budget) return false;

		let leftBudget = left ? budget : 0;
		let rightBudget = right ? budget : 0;
		if (left && right) {
			leftBudget = Math.ceil(budget / 2);
			rightBudget = budget - leftBudget;
			if (leftNatural < leftBudget) {
				leftBudget = leftNatural;
				rightBudget = budget - leftBudget;
			} else if (rightNatural < rightBudget) {
				rightBudget = rightNatural;
				leftBudget = budget - rightBudget;
			}
		}
		left = leftBudget > 0 ? truncateToWidth(left, leftBudget, "…") : "";
		right = rightBudget > 0 ? truncateToWidth(right, rightBudget, "…") : "";
		return leftBudget < leftNatural;
	};
	let leftTruncated = fitLabels();
	for (const fallback of options.leftFallbacks ?? []) {
		if (!leftTruncated) break;
		left = fallback;
		right = options.right;
		leftTruncated = fitLabels();
	}
	const partWidth = (label: string) => (label ? visibleWidth(label) + 3 : 1);
	let leftWidth = partWidth(left);
	let rightWidth = partWidth(right);
	if (leftWidth + rightWidth > innerWidth) {
		left = "";
		right = "";
		leftWidth = 1;
		rightWidth = 1;
	}

	const fillWidth = Math.max(0, innerWidth - leftWidth - rightWidth);
	const leftPart = left
		? `${options.renderBorder("─ ")}${left}${options.renderBorder(" ")}`
		: options.renderBorder("─");
	const rightPart = right
		? `${options.renderBorder(" ")}${right}${options.renderBorder(" ─")}`
		: options.renderBorder("─");
	return `${options.renderBorder(options.leftCorner)}${leftPart}${options.renderBorder(
		"─".repeat(fillWidth),
	)}${rightPart}${options.renderBorder(options.rightCorner)}`;
}

export function renderMinimalistFrame({
	width,
	editorLines,
	autocompleteLines = [],
	viewport,
	inputText,
	metadata,
	uiTheme,
	config,
	borderColor,
}: MinimalistFrameOptions): string[] {
	if (width <= 4) return clampLines(editorLines, width);
	const contentWidth = Math.max(0, width - 4);
	const adaptive = true;
	const thinking = sanitizeEditorMetadataText(metadata.thinkingLevel ?? "");
	const activeThinking = thinking && thinking.toLowerCase() !== "off" ? thinking : "";
	const renderStaticBorder = (text: string) =>
		renderStyleOrFallback(
			uiTheme,
			config.colors.editorBorder,
			EDITOR_BORDER_FALLBACK,
			text,
		);
	const terminalAdaptiveThinkingStyle = activeThinking
		? (thinkingStyle(config, activeThinking) ??
			MINIMALIST_ADAPTIVE_TERMINAL_THINKING_FALLBACKS[activeThinking.toLowerCase()] ??
			MINIMALIST_THINKING_FALLBACK)
		: undefined;
	const renderBorder = (text: string) => {
		if (!adaptive) return renderStaticBorder(text);
		return terminalAdaptiveThinkingStyle
			? renderStyle(uiTheme, terminalAdaptiveThinkingStyle, text)
			: renderStaticBorder(text);
	};
	const renderStaticThinking = (text: string) =>
		renderStyleOrFallback(
			uiTheme,
			thinkingStyle(config, text),
			MINIMALIST_THINKING_FALLBACK,
			text,
		);
	const renderThinking = adaptive ? renderBorder : renderStaticThinking;
	const separator = safeThemeFg(uiTheme, "muted", " · ");
	const viewportLabel = (direction: "above" | "below", count: string | undefined) => {
		if (!count || !/^[1-9]\d*$/.test(count)) return "";
		return safeThemeFg(uiTheme, "muted", `${direction === "above" ? "↑" : "↓"} ${count} more`);
	};
	const topMetadata = renderTopLeft(inputText, metadata, uiTheme, config);
	const topOperational = renderTopLeft(inputText, metadata, uiTheme, config, false);
	const topViewport = viewportLabel("above", viewport?.above);
	const topLeft = joinStyled([topViewport, topMetadata], separator);
	const topRightBudget = Math.max(0, width - 8 - visibleWidth(topLeft));
	const topFallbacks = [
		joinStyled([topViewport, topOperational], separator),
		topOperational,
	].filter((value, index, values) => value !== topLeft && values.indexOf(value) === index);
	const top = renderLabeledBorder({
		width,
		left: topLeft,
		leftFallbacks: topFallbacks,
		right: renderTopRight(metadata, uiTheme, config, topRightBudget, renderBorder, renderThinking),
		leftCorner: "╭",
		rightCorner: "╮",
		renderBorder,
	});
	const bottomViewport = viewportLabel("below", viewport?.below);
	const bottom = renderLabeledBorder({
		width,
		left: bottomViewport,
		leftFallbacks: undefined,
		right: renderBottomRight(metadata, uiTheme, config),
		leftCorner: "╰",
		rightCorner: "╯",
		renderBorder,
	});
	const content = editorLines.map(
		(line) => `${renderBorder("│")} ${fillLine(line, contentWidth)} ${renderBorder("│")}`,
	);
	const autocomplete = renderFramedAutocompleteRows({
		width,
		lines: autocompleteLines,
		renderBorder,
	});
	return clampLines([top, ...content, ...autocomplete, bottom], width);
}
