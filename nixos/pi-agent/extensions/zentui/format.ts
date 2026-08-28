import { homedir } from "node:os";
import type { ContextThresholds, PathDisplayMode } from "./config";

export type UsageTotals = {
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	cost: number;
};

type SessionUsage = {
	input?: unknown;
	output?: unknown;
	cacheRead?: unknown;
	cacheWrite?: unknown;
	cost?: unknown;
};

type SessionEntry = {
	type?: string;
	id?: string | number;
	timestamp?: string | number;
	usage?: SessionUsage;
	message?: {
		role?: string;
		usage?: SessionUsage;
	};
};

type SelectedUsage = {
	usage: SessionUsage | undefined;
	location: "message" | "entry";
	isAssistant: boolean;
};

type UsageCacheEntry = { key: string; totals: UsageTotals };

const MAX_USAGE_TOTAL = Number.MAX_VALUE;

let usageTotalsCache: UsageCacheEntry | undefined;

export function formatCount(value: number): string {
	if (value < 1000) return value.toString();
	if (value < 10_000) return `${(value / 1000).toFixed(1)}k`;
	if (value < 1_000_000) return `${Math.round(value / 1000)}k`;
	if (value < 10_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
	return `${Math.round(value / 1_000_000)}M`;
}

export function formatElapsedDuration(durationMs: number): string {
	const totalSeconds = Math.max(0, Math.floor(durationMs / 1000));
	const hours = Math.floor(totalSeconds / 3600);
	const minutes = Math.floor((totalSeconds % 3600) / 60);
	const seconds = totalSeconds % 60;
	if (hours > 0) return `${hours}h ${minutes}m`;
	if (minutes > 0) return `${minutes}m ${seconds}s`;
	return `${seconds}s`;
}

function normalizeUsageNumber(value: unknown): number {
	return typeof value === "number" && Number.isFinite(value) && value >= 0 ? value : 0;
}

function usageCostTotal(usage: SessionUsage | undefined): number {
	if (typeof usage?.cost !== "object" || usage.cost === null) return 0;
	return normalizeUsageNumber((usage.cost as { total?: unknown }).total);
}

function addUsageTotal(total: number, value: number): number {
	const sum = total + value;
	return Number.isFinite(sum) ? sum : MAX_USAGE_TOTAL;
}

function usageForEntry(entry: SessionEntry): SelectedUsage | undefined {
	if (entry.type === "message") {
		const role = entry.message?.role;
		if (role !== "assistant" && role !== "toolResult") return undefined;
		return {
			usage: entry.message?.usage,
			location: "message",
			isAssistant: role === "assistant",
		};
	}
	if (entry.type === "compaction" || entry.type === "branch_summary") {
		return { usage: entry.usage, location: "entry", isAssistant: false };
	}
	return undefined;
}

function normalizedUsage(usage: SessionUsage | undefined) {
	return {
		input: normalizeUsageNumber(usage?.input),
		output: normalizeUsageNumber(usage?.output),
		cacheRead: normalizeUsageNumber(usage?.cacheRead),
		cacheWrite: normalizeUsageNumber(usage?.cacheWrite),
		cost: usageCostTotal(usage),
	};
}

function entryIdentity(entry: SessionEntry): string {
	const selected = usageForEntry(entry);
	if (!selected) return "unsupported";
	const usage = normalizedUsage(selected.usage);
	return JSON.stringify([
		entry.id ?? null,
		entry.timestamp ?? null,
		entry.type ?? null,
		entry.message?.role ?? null,
		selected.location,
		usage.input,
		usage.output,
		usage.cacheRead,
		usage.cacheWrite,
		usage.cost,
	]);
}

function buildUsageFingerprint(entries: readonly SessionEntry[]): string {
	return entries.map(entryIdentity).join("\0");
}

function computeUsageTotals(entries: readonly SessionEntry[]): UsageTotals {
	let input = 0;
	let output = 0;
	let cacheRead = 0;
	let cacheWrite = 0;
	let cost = 0;

	for (const entry of entries) {
		const selected = usageForEntry(entry);
		if (!selected) continue;
		const usage = normalizedUsage(selected.usage);
		input = addUsageTotal(input, usage.input);
		output = addUsageTotal(output, usage.output);
		cacheRead = addUsageTotal(cacheRead, usage.cacheRead);
		cacheWrite = addUsageTotal(cacheWrite, usage.cacheWrite);
		cost = addUsageTotal(cost, usage.cost);
	}

	return Object.freeze({ input, output, cacheRead, cacheWrite, cost });
}

export function invalidateUsageTotalsCache(): void {
	usageTotalsCache = undefined;
}

export function getUsageTotals(ctx: {
	sessionManager: {
		getEntries?: () => readonly SessionEntry[];
		getBranch: () => readonly SessionEntry[];
	};
}): UsageTotals {
	const sessionManager = ctx.sessionManager as {
		getEntries?: () => readonly SessionEntry[];
		getBranch: () => readonly SessionEntry[];
	};
	const entries =
		typeof sessionManager.getEntries === "function"
			? sessionManager.getEntries()
			: sessionManager.getBranch();
	const key = buildUsageFingerprint(entries);
	if (usageTotalsCache?.key === key) return usageTotalsCache.totals;

	const totals = computeUsageTotals(entries);
	usageTotalsCache = { key, totals };
	return totals;
}

export function buildCostLabel(totals: UsageTotals): string {
	return `$${totals.cost.toFixed(3)}`;
}

export function contextColorTier(
	percent: number | null | undefined,
	thresholds: ContextThresholds = { warning: 70, error: 90 },
): "normal" | "warning" | "error" {
	if (percent === null || percent === undefined || !Number.isFinite(percent)) return "normal";
	if (percent >= thresholds.error) return "error";
	if (percent >= thresholds.warning) return "warning";
	return "normal";
}

export function buildContextGauge(percent: number, width = 10, ascii = false): string {
	const clamped = Math.max(0, Math.min(100, percent));
	const filled = Math.round((clamped / 100) * width);
	const on = ascii ? "#" : "█";
	const off = ascii ? "-" : "░";
	return `${on.repeat(filled)}${off.repeat(Math.max(0, width - filled))}`;
}

export type FormatCwdOptions = {
	mode?: PathDisplayMode;
	depth?: number;
	home?: string;
};

function normalizeDisplayPath(cwd: string): string {
	const withSlashes = cwd.replace(/\\/g, "/");
	if (withSlashes === "/" || /^\/+$/.test(withSlashes)) return "/";
	const stripped = withSlashes.replace(/\/+$/, "");
	return stripped === "" ? withSlashes : stripped;
}

function toHomePath(path: string, home: string): string {
	if (!home) return path;
	const homeNorm = home.replace(/\\/g, "/").replace(/\/+$/, "");
	if (!homeNorm) return path;
	if (path === homeNorm) return "~";
	if (path.startsWith(`${homeNorm}/`)) return `~${path.slice(homeNorm.length)}`;
	return path;
}

function applyPathDepth(path: string, depth: number): string {
	if (!Number.isFinite(depth) || depth <= 0) return path;
	const limit = Math.floor(depth);
	if (path === "~" || path === "/") return path;

	let components: string[];
	if (path.startsWith("~/")) {
		components = path.slice(2).split("/").filter(Boolean);
	} else if (/^[A-Za-z]:\//.test(path)) {
		components = path.slice(3).split("/").filter(Boolean);
	} else if (path.startsWith("/")) {
		components = path.slice(1).split("/").filter(Boolean);
	} else {
		components = path.split("/").filter(Boolean);
	}

	if (components.length <= limit) return path;
	return `…/${components.slice(-limit).join("/")}`;
}

export function formatCwdLabel(cwd: string, cwdIcon: string, options?: FormatCwdOptions): string {
	const mode = options?.mode ?? "basename";
	const normalized = normalizeDisplayPath(cwd);
	let pathText: string;
	if (mode === "full") {
		const home = options?.home ?? (() => {
			try {
				return homedir();
			} catch {
				return "";
			}
		})();
		pathText = applyPathDepth(toHomePath(normalized, home), options?.depth ?? 0);
	} else if (normalized === "/") {
		pathText = "/";
	} else {
		const parts = normalized.split("/").filter(Boolean);
		pathText = parts[parts.length - 1] ?? cwd;
	}
	return cwdIcon ? `${cwdIcon} ${pathText}` : pathText;
}
