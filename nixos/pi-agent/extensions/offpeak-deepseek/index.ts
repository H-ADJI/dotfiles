import { readFileSync } from "node:fs";
import { join } from "node:path";
import { getAgentDir, type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";

// Peak windows and footer labels come from ~/.pi/agent/offpeak-deepseek.json
// (symlinked from the nix config via home.file, like zentui.json).
// Peak windows are [startHour, endHour) pairs in UTC, Monday-Friday only;
// everything else (weekends, nights) is off-peak.
interface Config {
	peakWindowsUtc: [number, number][];
	labels: { peak: string; offPeak: string };
}

const config: Config = JSON.parse(
	readFileSync(join(getAgentDir(), "offpeak-deepseek.json"), "utf8"),
);

function tierAt(date: Date): "peak" | "offPeak" {
	// Peak windows only apply Monday-Friday (getUTCDay(): Sun=0 ... Sat=6)
	if (date.getUTCDay() < 1 || date.getUTCDay() > 5) return "offPeak";
	const hour = date.getUTCHours();
	return config.peakWindowsUtc.some(([start, end]) => hour >= start && hour < end) ? "peak" : "offPeak";
}

export default function (pi: ExtensionAPI) {
	// Footer status, only while a DeepSeek model is active.
	let lastStatus: string | undefined;
	const refreshStatus = (ctx: ExtensionContext) => {
		const status =
			ctx.model?.provider === "deepseek"
				? tierAt(new Date()) === "peak"
					? config.labels.peak
					: config.labels.offPeak
				: undefined;
		if (status === lastStatus) return;
		lastStatus = status;
		ctx.ui.setStatus("deepseek-tier", status);
	};

	pi.on("session_start", (_event, ctx) => refreshStatus(ctx));
	pi.on("turn_end", (_event, ctx) => refreshStatus(ctx));
	pi.on("model_select", (_event, ctx) => refreshStatus(ctx));
}
