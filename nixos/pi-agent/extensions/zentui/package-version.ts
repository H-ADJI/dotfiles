import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

export type PackageVersionResult = {
	ecosystem: string;
	version: string;
};

export type PackageVersionReadResult =
	| { kind: "ok"; result: PackageVersionResult | null }
	| { kind: "error" };

function cleanVersion(value: string | undefined): string | undefined {
	if (!value || /[\u0000-\u001f\u007f-\u009f]/.test(value)) return undefined;
	let text = value.trim();
	if (!text) return undefined;

	if (text.length >= 2) {
		const first = text[0];
		const last = text[text.length - 1];
		if ((first === '"' && last === '"') || (first === "'" && last === "'")) {
			text = text.slice(1, -1);
		}
	}

	while (text.startsWith("v") || text.startsWith("V")) {
		const next = text[1];
		if (!next || next < "0" || next > "9") break;
		text = text.slice(1);
	}

	text = text.trim();
	if (!text) return undefined;
	if (/\s/.test(text)) return undefined;
	return text;
}

export function readPackageVersion(cwd: string): PackageVersionResult | null {
	const full = join(cwd, "package.json");
	if (!existsSync(full)) return null;
	let raw: string;
	try {
		raw = readFileSync(full, "utf8");
	} catch {
		return null;
	}
	try {
		const parsed = JSON.parse(raw) as Record<string, unknown>;
		const version = cleanVersion(typeof parsed.version === "string" ? parsed.version : undefined);
		if (version) return { ecosystem: "nodejs", version };
	} catch {
		return null;
	}
	return null;
}

export async function readPackageVersionResult(cwd: string): Promise<PackageVersionReadResult> {
	try {
		return { kind: "ok", result: readPackageVersion(cwd) };
	} catch {
		return { kind: "error" };
	}
}
