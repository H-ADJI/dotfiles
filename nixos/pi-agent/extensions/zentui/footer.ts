import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import type { SeparatorStyle, ZentuiConfig } from "./config";
import {
	collectExtensionStatusSegments,
	type ExtensionStatusSegment,
} from "./extension-status";
import type { FooterState } from "./state";
import { renderStyleForSource } from "./style";

const separatorText: Record<SeparatorStyle, string> = {
	pipe: " | ",
	dot: " · ",
	chevron: " › ",
	none: " ",
};

function deepseekTierAt(date: Date, windows: [number, number][]): "peak" | "offPeak" {
	if (date.getUTCDay() < 1 || date.getUTCDay() > 5) return "offPeak";
	const hour = date.getUTCHours();
	return windows.some(([start, end]) => hour >= start && hour < end) ? "peak" : "offPeak";
}

const DEEPSEEK_ICON = "🐋";

export function installFooter(
	ctx: ExtensionContext,
	state: FooterState,
	getConfig: () => ZentuiConfig,
	hooks: {
		setRequestRender: (fn: (() => void) | undefined) => void;
		setExtensionStatusesGetter?: (fn: (() => ReadonlyMap<string, string>) | undefined) => void;
		onBranchChange?: () => void;
		onDispose?: () => void;
	},
): void {
	ctx.ui.setFooter((tui, theme, footerData) => {
		hooks.setRequestRender(() => tui.requestRender());
		hooks.setExtensionStatusesGetter?.(() => footerData.getExtensionStatuses());
		const unsubscribeBranch = footerData.onBranchChange(() => {
			hooks.onBranchChange?.();
			tui.requestRender();
		});

		return {
			dispose: () => {
				unsubscribeBranch();
				hooks.setRequestRender(undefined);
				hooks.setExtensionStatusesGetter?.(undefined);
				hooks.onDispose?.();
			},
			invalidate() {},
			render(width: number): string[] {
				if (width <= 0) return [""];
				const config = getConfig();
				const starship = config.components.footer.styles.starship;
				const colorSource = config.components.footer.colorSource;
				const sep = renderStyleForSource(
					theme,
					colorSource,
					config.colors.separator,
					separatorText[starship.separator],
				);
				const innerWidth = Math.max(1, width - 2);

				// Left side intentionally empty for now; re-add segments here later.
				const left = "";

				const extensionStatuses = collectExtensionStatusSegments(
					footerData.getExtensionStatuses(),
					config,
				);
				const renderExtensionStatus = (segment: ExtensionStatusSegment) =>
					segment.colorMode === "original"
						? segment.text
						: renderStyleForSource(theme, colorSource, config.colors.extensionStatus, segment.text);
				const deepseekTierLabel =
					starship.segments.deepseekTier && ctx.model?.provider === "deepseek"
						? (() => {
								const tier = deepseekTierAt(new Date(), config.deepseekTier.peakWindowsUtc);
								const label =
									tier === "peak"
										? `${DEEPSEEK_ICON}: ${config.deepseekTier.labels.peak}`
										: `${DEEPSEEK_ICON}: ${config.deepseekTier.labels.offPeak}`;
								return renderStyleForSource(
									theme,
									colorSource,
									tier === "peak" ? "red" : "black",
									label,
								);
							})()
						: "";
				const right = [deepseekTierLabel, ...extensionStatuses.right.map(renderExtensionStatus)]
					.filter(Boolean)
					.join(sep);

				const leftWidth = visibleWidth(left);
				const rightWidth = visibleWidth(right);
				let line: string;
				if (leftWidth >= innerWidth) {
					line = truncateToWidth(left, innerWidth, "");
				} else if (leftWidth + 1 + rightWidth <= innerWidth) {
					line = `${left}${" ".repeat(innerWidth - leftWidth - rightWidth)}${right}`;
				} else {
					line = truncateToWidth(left, innerWidth, "");
				}
				const framed = width > 2 ? ` ${truncateToWidth(line, width - 2, "")} ` : line;
				return [truncateToWidth(framed, width, "")];
			},
		};
	});
}
