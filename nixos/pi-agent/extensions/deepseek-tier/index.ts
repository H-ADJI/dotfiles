/**
 * deepseek-tier — publish the DeepSeek peak/off-peak pricing tier as a footer
 * status, so a footer owner (zentui, or pi's native footer) renders it.
 *
 * Config: ~/.pi/agent/deepseek-tier.json
 *   {
 *     "enabled": true,
 *     "peakWindowsUtc": [[1, 4], [6, 10]],
 *     "labels": { "peak": "peak pricing", "offPeak": "off-peak pricing" }
 *   }
 *
 * Only publishes the status when the active model is a DeepSeek model.
 * Peak/off-peak is evaluated in UTC, Mon–Fri; weekends are always off-peak.
 * Status is refreshed every minute so hour-boundary changes land without a
 * manual redraw.
 *
 * The published text carries its own color (peak = red, off-peak = black).
 * Tell zentui to preserve it:
 *
 *   "components": {
 *     "footer": {
 *       "styles": {
 *         "starship": {
 *           "extensionStatuses": {
 *             "colorModes": { "deepseekTier": "original" }
 *           }
 *         }
 *       }
 *     }
 *   }
 */

import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import {
	getAgentDir,
	type ExtensionAPI,
	type ExtensionContext,
} from "@earendil-works/pi-coding-agent";

type DeepseekTierConfig = {
	enabled: boolean;
	peakWindowsUtc: [number, number][];
	labels: { peak: string; offPeak: string };
};

const STATUS_KEY = "deepseekTier";
const DEEPSEEK_ICON = "🐋";
const REFRESH_INTERVAL_MS = 60_000;

const DEFAULT_CONFIG: DeepseekTierConfig = {
	enabled: true,
	peakWindowsUtc: [[1, 4], [6, 10]],
	labels: { peak: "peak pricing", offPeak: "off-peak pricing" },
};

function loadConfig(): DeepseekTierConfig {
	try {
		const path = join(getAgentDir(), "deepseek-tier.json");
		if (!existsSync(path)) return DEFAULT_CONFIG;
		const raw = JSON.parse(readFileSync(path, "utf8")) as Partial<DeepseekTierConfig>;
		const labels: Partial<DeepseekTierConfig["labels"]> = raw.labels ?? {};
		return {
			enabled: typeof raw.enabled === "boolean" ? raw.enabled : DEFAULT_CONFIG.enabled,
			peakWindowsUtc: Array.isArray(raw.peakWindowsUtc)
				? (raw.peakWindowsUtc as [number, number][])
				: DEFAULT_CONFIG.peakWindowsUtc,
			labels: {
				peak: typeof labels.peak === "string" ? labels.peak : DEFAULT_CONFIG.labels.peak,
				offPeak:
					typeof labels.offPeak === "string"
						? labels.offPeak
						: DEFAULT_CONFIG.labels.offPeak,
			},
		};
	} catch {
		return DEFAULT_CONFIG;
	}
}

function isDeepseekModel(model: ExtensionContext["model"]): boolean {
	if (!model) return false;
	return (
		model.provider === "deepseek" ||
		/deepseek/i.test(model.id) ||
		/deepseek/i.test(model.name)
	);
}

function tierAt(date: Date, windows: [number, number][]): "peak" | "offPeak" {
	if (date.getUTCDay() < 1 || date.getUTCDay() > 5) return "offPeak";
	const hour = date.getUTCHours();
	return windows.some(([start, end]) => hour >= start && hour < end)
		? "peak"
		: "offPeak";
}

function ansi(color: "red" | "black", text: string): string {
	return `\x1b[${color === "red" ? 31 : 30}m${text}\x1b[0m`;
}

export default function (pi: ExtensionAPI) {
	let timer: ReturnType<typeof setInterval> | undefined;

	const update = (ctx: ExtensionContext) => {
		const config = loadConfig();
		if (!config.enabled || !isDeepseekModel(ctx.model)) {
			ctx.ui.setStatus(STATUS_KEY, undefined);
			return;
		}
		const tier = tierAt(new Date(), config.peakWindowsUtc);
		const label = `${DEEPSEEK_ICON}: ${
			tier === "peak" ? config.labels.peak : config.labels.offPeak
		}`;
		ctx.ui.setStatus(STATUS_KEY, ansi(tier === "peak" ? "red" : "black", label));
	};

	pi.on("session_start", (_event, ctx) => {
		update(ctx);
		if (!timer) timer = setInterval(() => update(ctx), REFRESH_INTERVAL_MS);
	});

	pi.on("model_select", (_event, ctx) => update(ctx));

	pi.on("session_shutdown", (_event, ctx) => {
		if (timer) {
			clearInterval(timer);
			timer = undefined;
		}
		ctx.ui.setStatus(STATUS_KEY, undefined);
	});
}
