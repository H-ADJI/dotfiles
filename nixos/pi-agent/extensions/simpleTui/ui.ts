import { CustomEditor, type KeybindingsManager, type Theme } from "@earendil-works/pi-coding-agent";
import {
	type Component,
	type EditorTheme,
	type TUI,
	truncateToWidth,
} from "@earendil-works/pi-tui";
import type { SimpleTuiConfig } from "./config";
import { type MinimalistEditorMetadata, renderMinimalistFrame } from "./minimalist-editor";
import { safeThemeFg } from "./style";

type AutocompleteListInternals = Pick<Component, "render">;

type AutocompleteEditorInternals = {
	autocompleteList?: AutocompleteListInternals;
	isShowingAutocomplete?: () => boolean;
};

type AutocompleteCapture = {
	compatible: boolean;
	called: number;
	rows: string[];
};

function isStringArray(value: unknown): value is string[] {
	return Array.isArray(value) && value.every((line) => typeof line === "string");
}

function autocompleteCount(
	source: AutocompleteEditorInternals,
	capture: AutocompleteCapture | undefined,
	baseLineCount: number,
): { known: true; count: number } | { known: false } {
	try {
		const showing = source.isShowingAutocomplete;
		if (typeof showing !== "function" || !showing.call(source)) return { known: true, count: 0 };
		if (
			!capture?.compatible ||
			capture.called !== 1 ||
			capture.rows.length <= 0 ||
			capture.rows.length >= baseLineCount
		)
			return { known: false };
		return { known: true, count: capture.rows.length };
	} catch {
		return { known: false };
	}
}

function renderWithAutocompleteCapture<T>(
	source: AutocompleteEditorInternals,
	render: () => T,
): { value: T; capture?: AutocompleteCapture } {
	let showing = false;
	try {
		showing =
			typeof source.isShowingAutocomplete === "function" &&
			source.isShowingAutocomplete.call(source);
	} catch {
		return { value: render() };
	}
	if (!showing) return { value: render(), capture: { compatible: true, called: 0, rows: [] } };

	let list: AutocompleteListInternals;
	let own: PropertyDescriptor | undefined;
	let predecessor: (...args: unknown[]) => unknown;
	try {
		const candidate = source.autocompleteList;
		if (!candidate) return { value: render() };
		own = Object.getOwnPropertyDescriptor(candidate, "render");
		const current = Reflect.get(candidate, "render");
		if (typeof current !== "function") return { value: render() };
		if (own && (!("value" in own) || own.writable !== true)) return { value: render() };
		if (!own && !Object.isExtensible(candidate)) return { value: render() };
		list = candidate;
		predecessor = current as (...args: unknown[]) => unknown;
	} catch {
		return { value: render() };
	}

	const capture: AutocompleteCapture = { compatible: true, called: 0, rows: [] };
	const wrapper = function (this: AutocompleteListInternals, ...args: unknown[]) {
		const result = Reflect.apply(predecessor, this, args);
		capture.called++;
		if (!isStringArray(result)) {
			capture.compatible = false;
			return result;
		}
		capture.rows = [...result];
		return result;
	};
	const installedDescriptor: PropertyDescriptor = {
		...(own ?? { configurable: true, enumerable: false, writable: true }),
		value: wrapper,
	};
	try {
		Object.defineProperty(list, "render", installedDescriptor);
	} catch {
		return { value: render() };
	}

	try {
		return { value: render(), capture };
	} finally {
		let current: PropertyDescriptor | undefined;
		let currentValue: unknown;
		try {
			current = Object.getOwnPropertyDescriptor(list, "render");
			currentValue = current && "value" in current ? current.value : Reflect.get(list, "render");
		} catch {
			currentValue = undefined;
		}
		if (currentValue === wrapper) {
			try {
				if (own) Object.defineProperty(list, "render", own);
				else Reflect.deleteProperty(list, "render");
			} catch {
				capture.compatible = false;
			}
		} else {
			capture.compatible = false;
		}
	}
}

function clampRenderedLines(lines: string[], width: number): string[] {
	const maxWidth = Math.max(0, width);
	return lines.map((line) => truncateToWidth(line, maxWidth, ""));
}

function ansiStrippedText(line: string): string {
	return line.replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "").replace(/\x1b\][^\x07]*(?:\x07|\x1b\\)/g, "");
}

function parseEditorBorder(
	line: string,
	direction: "above" | "below",
): { count?: string } | undefined {
	const plain = ansiStrippedText(line);
	if (/^─+$/.test(plain)) return {};

	const arrow = direction === "above" ? "↑" : "↓";
	const match = new RegExp(`^─── ${arrow} ([1-9]\\d*) more ─*$`).exec(plain);
	return match?.[1] ? { count: match[1] } : undefined;
}

export class PolishedEditor extends CustomEditor {
	private readonly getMinimalistMetadata: () => MinimalistEditorMetadata;
	private readonly onMinimalistDecorationChange: (active: boolean) => void;
	private readonly getConfig: () => SimpleTuiConfig;
	private readonly uiTheme: Theme;

	constructor(
		tui: TUI,
		theme: EditorTheme,
		keybindings: KeybindingsManager,
		uiTheme: Theme,
		getConfig: () => SimpleTuiConfig,
		getMinimalistMetadata: () => MinimalistEditorMetadata,
		onMinimalistDecorationChange: (active: boolean) => void = () => {},
	) {
		super(tui, theme, keybindings, { paddingX: 0 });
		this.borderColor = (text: string) => safeThemeFg(uiTheme, "border", text);
		this.uiTheme = uiTheme;
		this.getConfig = getConfig;
		this.getMinimalistMetadata = getMinimalistMetadata;
		this.onMinimalistDecorationChange = onMinimalistDecorationChange;
	}

	render(width: number): string[] {
		const config = this.getConfig();
		if (width <= 4) {
			this.onMinimalistDecorationChange(false);
			return clampRenderedLines(super.render(width), width);
		}
		try {
			const captured = renderWithAutocompleteCapture(
				this as unknown as AutocompleteEditorInternals,
				() => super.render(Math.max(0, width - 4)),
			);
			const baseRendered = captured.value;
			if (baseRendered.length < 2) {
				this.onMinimalistDecorationChange(false);
				return clampRenderedLines(baseRendered, width);
			}
			const autocomplete = autocompleteCount(
				this as unknown as AutocompleteEditorInternals,
				captured.capture,
				baseRendered.length,
			);
			if (!autocomplete.known) {
				this.onMinimalistDecorationChange(false);
				return clampRenderedLines(baseRendered, width);
			}
			const editorFrame =
				autocomplete.count > 0 ? baseRendered.slice(0, -autocomplete.count) : baseRendered;
			const autocompleteLines =
				autocomplete.count > 0 ? baseRendered.slice(-autocomplete.count) : [];
			if (editorFrame.length < 2) {
				this.onMinimalistDecorationChange(false);
				return clampRenderedLines(baseRendered, width);
			}
			const parsedTop = parseEditorBorder(editorFrame[0] ?? "", "above");
			const parsedBottom = parseEditorBorder(editorFrame.at(-1) ?? "", "below");
			if (!parsedTop || !parsedBottom) {
				this.onMinimalistDecorationChange(false);
				return clampRenderedLines(baseRendered, width);
			}
			const viewport = { above: parsedTop.count, below: parsedBottom.count };
			const lines = renderMinimalistFrame({
				width,
				editorLines: editorFrame.slice(1, -1),
				autocompleteLines,
				viewport: undefined,
				inputText: this.getText(),
				metadata: this.getMinimalistMetadata(),
				uiTheme: this.uiTheme,
				config,
				borderColor: this.borderColor,
			});
			this.onMinimalistDecorationChange(true);
			return lines;
		} catch {
			this.onMinimalistDecorationChange(false);
			return clampRenderedLines(super.render(width), width);
		}
	}
}
