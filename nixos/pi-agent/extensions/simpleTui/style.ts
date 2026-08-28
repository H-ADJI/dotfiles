import type { ColorSpec } from "./config";

type ThemeLike = {
	fg(color: string, text: string): string;
	bold?: (text: string) => string;
	italic?: (text: string) => string;
	underline?: (text: string) => string;
};

export type { ThemeLike };

export const EDITOR_ACCENT_STYLE = "blue";
export const EDITOR_BORDER_STYLE = "bright-black";
export const EDITOR_ACCENT_FALLBACK = "blue";
export const EDITOR_BORDER_FALLBACK = "bright-black";

function isHexColor(value: string): boolean {
	return /^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/.test(value);
}

function expandHexColor(hex: string): string {
	const body = hex.slice(1);
	if (body.length === 3) {
		return body
			.split("")
			.map((ch) => ch + ch)
			.join("");
	}
	return body;
}

function hexToAnsi(hex: string, isBackground = false): string {
	const normalized = expandHexColor(hex);
	const r = Number.parseInt(normalized.slice(0, 2), 16);
	const g = Number.parseInt(normalized.slice(2, 4), 16);
	const b = Number.parseInt(normalized.slice(4, 6), 16);
	return `\x1b[${isBackground ? 48 : 38};2;${r};${g};${b}m`;
}

const terminalColorCodes = new Map([
	["black", 30],
	["red", 31],
	["green", 32],
	["yellow", 33],
	["blue", 34],
	["purple", 35],
	["cyan", 36],
	["white", 37],
	["bright-black", 90],
	["bright-red", 91],
	["bright-green", 92],
	["bright-yellow", 93],
	["bright-blue", 94],
	["bright-purple", 95],
	["bright-cyan", 96],
	["bright-white", 97],
]);

const terminalStyleModifiers = new Map([
	["bold", 1],
	["dim", 2],
	["dimmed", 2],
	["italic", 3],
	["underline", 4],
]);

function terminalColorToAnsi(color: string, isBackground = false): string | undefined {
	const normalized = color.toLowerCase();
	const colorCode = terminalColorCodes.get(normalized);
	if (colorCode !== undefined) return `${isBackground ? colorCode + 10 : colorCode}`;

	if (/^(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(normalized)) {
		return `${isBackground ? 48 : 38};5;${normalized}`;
	}

	if (isHexColor(normalized)) return hexToAnsi(normalized, isBackground).slice(2, -1);
	return undefined;
}

export function renderTerminalStyle(style: string, text: string): string {
	const codes: string[] = [];
	for (const token of style.trim().split(/\s+/)) {
		if (!token) continue;

		const normalized = token.toLowerCase();
		const modifier = terminalStyleModifiers.get(normalized);
		if (modifier !== undefined) {
			codes.push(`${modifier}`);
			continue;
		}

		const isForeground = normalized.startsWith("fg:");
		const isBackground = normalized.startsWith("bg:");
		const colorName = isForeground || isBackground ? normalized.slice(3) : normalized;
		const color = terminalColorToAnsi(colorName, isBackground);
		if (color) codes.push(color);
	}

	return codes.length ? `\x1b[${codes.join(";")}m${text}\x1b[0m` : text;
}

export function safeThemeFg(theme: ThemeLike, color: string, text: string): string {
	try {
		return theme.fg(color, text);
	} catch {
		return text;
	}
}

/** Terminal-first styling; non-terminal specs (e.g. legacy theme tokens) fall back to theme.fg. */
export function renderStyle(theme: ThemeLike, style: ColorSpec, text: string): string {
	if (style.trim() === "") return text;
	const styled = renderTerminalStyle(style, text);
	return styled === text ? safeThemeFg(theme, style, text) : styled;
}

export function renderStyleOrFallback(
	theme: ThemeLike,
	style: ColorSpec | undefined,
	fallback: ColorSpec,
	text: string,
): string {
	return renderStyle(theme, style ?? fallback, text);
}

export function renderEditorBorder(text: string): string {
	return renderTerminalStyle(EDITOR_BORDER_STYLE, text);
}
