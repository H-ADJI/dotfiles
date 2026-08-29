import { homedir } from "node:os";
import type { ContextThresholds, PathDisplayMode } from "./config";

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

export function contextColorTier(
	percent: number | null | undefined,
	thresholds: ContextThresholds = { warning: 70, error: 90 },
): "normal" | "warning" | "error" {
	if (percent === null || percent === undefined || !Number.isFinite(percent)) return "normal";
	if (percent >= thresholds.error) return "error";
	if (percent >= thresholds.warning) return "warning";
	return "normal";
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