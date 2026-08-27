import type {
    ExtensionAPI,
    ExtensionContext,
} from "@earendil-works/pi-coding-agent";

// ============================================================================
// EDIT THESE when DeepSeek changes the schedule
// (https://api-docs.deepseek.com/quick_start/pricing)
// ============================================================================

// Peak windows as [startHour, endHour) pairs in UTC, Monday-Friday only.
// Everything else (weekends, nights) is off-peak.
// Example: [1, 4] means peak from 01:00 to 03:59 UTC.
//
// French time (UTC+2, summer CEST): 01-04 UTC = 03-06, 06-10 UTC = 08-12.
// In winter (CEST->CET, UTC+1) subtract one hour: 02-05 & 07-11 local.
const PEAK_WINDOWS_UTC: [number, number][] = [
    [1, 4], // 01:00-04:00 UTC (09:00-12:00 Beijing)
    [6, 10], // 06:00-10:00 UTC (14:00-18:00 Beijing)
];

// ============================================================================

function tierAt(date: Date): "peak" | "offPeak" {
    // Peak windows only apply Monday-Friday (getUTCDay(): Sun=0 ... Sat=6)
    if (date.getUTCDay() < 1 || date.getUTCDay() > 5) return "offPeak";
    const hour = date.getUTCHours();
    return PEAK_WINDOWS_UTC.some(([start, end]) => hour >= start && hour < end)
        ? "peak"
        : "offPeak";
}

export default function (pi: ExtensionAPI) {
    // Footer status: peak ⚠️ / off-peak, only while a DeepSeek model is active.
    let lastStatus: string | undefined;
    const refreshStatus = (ctx: ExtensionContext) => {
        const status =
            ctx.model?.provider === "deepseek"
                ? tierAt(new Date()) === "peak"
                    ? "peak ⚠️"
                    : "off-peak"
                : undefined;
        if (status === lastStatus) return;
        lastStatus = status;
        ctx.ui.setStatus("deepseek-tier", status);
    };

    pi.on("session_start", (_event, ctx) => refreshStatus(ctx));
    // TODO: on turn_end price per turn
    // TODO: on turn_end copy msg to clipboard
    pi.on("turn_end", (_event, ctx) => refreshStatus(ctx));
    pi.on("model_select", (_event, ctx) => refreshStatus(ctx));
}
