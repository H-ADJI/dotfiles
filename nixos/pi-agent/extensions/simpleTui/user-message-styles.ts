import type { Theme, ThemeColor } from "@earendil-works/pi-coding-agent";
import {
	Markdown,
	type MarkdownTheme,
	truncateToWidth,
	visibleWidth,
} from "@earendil-works/pi-tui";
import type { SimpleTuiConfig } from "./config";
import {
	EDITOR_ACCENT_FALLBACK,
	EDITOR_BORDER_FALLBACK,
	renderStyleOrFallback,
} from "./style";
import { sanitizeUserMessageSourceText } from "./user-message-osc";

export type UserMessageStyleRenderInput = {
	text: string;
	width: number;
	theme?: Theme;
	config: SimpleTuiConfig;
};

function themeFg(theme: Theme | undefined, color: ThemeColor, text: string): string {
	return theme ? theme.fg(color, text) : text;
}

function makeMarkdownTheme(theme: Theme | undefined): MarkdownTheme {
	return {
		heading: (text) => themeFg(theme, "mdHeading", text),
		link: (text) => themeFg(theme, "mdLink", text),
		linkUrl: (text) => themeFg(theme, "mdLinkUrl", text),
		code: (text) => themeFg(theme, "mdCode", text),
		codeBlock: (text) => themeFg(theme, "mdCodeBlock", text),
		codeBlockBorder: (text) => themeFg(theme, "mdCodeBlockBorder", text),
		quote: (text) => themeFg(theme, "mdQuote", text),
		quoteBorder: (text) => themeFg(theme, "mdQuoteBorder", text),
		hr: (text) => themeFg(theme, "mdHr", text),
		listBullet: (text) => themeFg(theme, "mdListBullet", text),
		bold: (text) => (theme ? theme.bold(text) : text),
		italic: (text) => (theme ? theme.italic(text) : text),
		underline: (text) => (theme ? theme.underline(text) : text),
		strikethrough: (text) => (theme ? theme.strikethrough(text) : text),
	};
}

function renderMarkdown(text: string, width: number, theme: Theme | undefined): string[] {
	const renderer = new Markdown(text, 0, 0, makeMarkdownTheme(theme), {
		color: (content) => themeFg(theme, "userMessageText", content),
	});
	const lines = renderer.render(Math.max(1, width));
	return lines.length > 0 ? lines : [""];
}

function fillLine(content: string, width: number): string {
	const truncated = truncateToWidth(content, Math.max(0, width), "");
	return `${truncated}${" ".repeat(Math.max(0, width - visibleWidth(truncated)))}`;
}

function accent(theme: Theme | undefined, config: SimpleTuiConfig, text: string): string {
	return theme
		? renderStyleOrFallback(theme, config.colors.editorAccent, EDITOR_ACCENT_FALLBACK, text)
		: text;
}

function border(theme: Theme | undefined, config: SimpleTuiConfig, text: string): string {
	return theme
		? renderStyleOrFallback(theme, config.colors.editorBorder, EDITOR_BORDER_FALLBACK, text)
		: text;
}

function renderLabeled({ text, width, theme, config }: UserMessageStyleRenderInput): string[] {
	if (width <= 0) return [""];
	if (width <= 2) {
		return renderMarkdown(text, width, theme).map((line) => truncateToWidth(line, width, ""));
	}

	const horizontalPadding = width >= 5 ? 1 : 0;
	const contentWidth = Math.max(1, width - 2 - horizontalPadding * 2);
	const body = renderMarkdown(text, contentWidth, theme);
	const top =
		width >= 9
			? `${border(theme, config, "╭─")}${accent(theme, config, " User ")}${border(
					theme,
					config,
					`${"─".repeat(Math.max(0, width - 9))}╮`,
				)}`
			: border(theme, config, `╭${"─".repeat(Math.max(0, width - 2))}╮`);
	const padding = " ".repeat(horizontalPadding);
	const side = (line: string) =>
		`${border(theme, config, "│")}${padding}${fillLine(line, contentWidth)}${padding}${border(
			theme,
			config,
			"│",
		)}`;
	const bottom = border(theme, config, `╰${"─".repeat(Math.max(0, width - 2))}╯`);
	return [top, ...body.map(side), bottom];
}

export function userMessageStyleCacheKey(_config: SimpleTuiConfig): string {
	return "labeled:v1";
}

export function renderUserMessageStyle(input: UserMessageStyleRenderInput): string[] {
	// Raw user input is a terminal trust boundary. Strip every source control,
	// including OSC 8; Markdown may add its own validated links afterward.
	return renderLabeled({
		...input,
		text: sanitizeUserMessageSourceText(input.text),
	});
}
