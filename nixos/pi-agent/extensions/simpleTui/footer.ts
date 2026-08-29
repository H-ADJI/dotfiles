import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import type { SimpleTuiConfig } from "./config";
import {
	collectExtensionStatusSegments,
	type ExtensionStatusSegment,
} from "./extension-status";
import { renderStyle } from "./style";

function isDeepseekModel(model: { provider?: string; id?: string; name?: string } | undefined): boolean {
	if (!model) return false;
	return (
		model.provider === "deepseek" ||
		/deepseek/i.test(model.id ?? "") ||
		/deepseek/i.test(model.name ?? "")
	);
}

function deepseekTierAt(date: Date, windows: [number, number][]): "peak" | "offPeak" {
	if (date.getUTCDay() < 1 || date.getUTCDay() > 5) return "offPeak";
	const hour = date.getUTCHours();
	return windows.some(([start, end]) => hour >= start && hour < end) ? "peak" : "offPeak";
}

const DEEPSEEK_ICON = "🐋";
const SEPARATOR = " | ";

export function installFooter(
	ctx: ExtensionContext,
	getConfig: () => SimpleTuiConfig,
	hooks: {
		setRequestRender: (fn: (() => void) | undefined) => void;
		setExtensionStatusesGetter?: (fn: (() => ReadonlyMap<string, string>) | undefined) => void;
		onDispose?: () => void;
	},
): void {
	ctx.ui.setFooter((tui, theme, footerData) => {
		hooks.setRequestRender(() => tui.requestRender());
		hooks.setExtensionStatusesGetter?.(() => footerData.getExtensionStatuses());

		return {
			dispose: () => {
				hooks.setRequestRender(undefined);
				hooks.setExtensionStatusesGetter?.(undefined);
				hooks.onDispose?.();
			},
			invalidate() {},
			render(width: number): string[] {
				if (width <= 0) return [""];
				const config = getConfig();
				const footer = config.footer;
				const innerWidth = Math.max(1, width - 2);

				const deepseekTierLabel =
					footer.deepseekTier.enabled && isDeepseekModel(ctx.model)
						? (() => {
								const tier = deepseekTierAt(new Date(), footer.deepseekTier.peakWindowsUtc);
								const label =
									tier === "peak"
										? `${DEEPSEEK_ICON}: ${footer.deepseekTier.labels.peak}`
										: `${DEEPSEEK_ICON}: ${footer.deepseekTier.labels.offPeak}`;
								return renderStyle(theme, tier === "peak" ? "red" : "black", label);
							})()
						: "";

				const extensionStatuses = collectExtensionStatusSegments(
					footerData.getExtensionStatuses(),
					config,
				);
				const renderExtensionStatus = (segment: ExtensionStatusSegment) =>
					segment.colorMode === "original"
						? segment.text
						: renderStyle(theme, config.colors.extensionStatus, segment.text);
				const right = [deepseekTierLabel, ...extensionStatuses.right.map(renderExtensionStatus)]
					.filter(Boolean)
					.join(SEPARATOR);

				const rightWidth = visibleWidth(right);
				const line =
					rightWidth >= innerWidth
						? truncateToWidth(right, innerWidth, "")
						: `${' '.repeat(innerWidth - rightWidth)}${right}`;
				const framed = width > 2 ? ` ${truncateToWidth(line, width - 2, "")} ` : line;
				return [truncateToWidth(framed, width, "")];
			},
		};
	});
}
