import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);
const GIT_COMMAND_TIMEOUT_MS = 2_000;

export type GitMetricsInfo = {
	added: number;
	deleted: number;
};

export type GitStatusSummary = {
	branch?: string;
	dirty: boolean;
	ahead: number;
	behind: number;
	conflicted: number;
	untracked: number;
	stashed: number;
	modified: number;
	staged: number;
	renamed: number;
	deleted: number;
	typechanged: number;
	metrics?: GitMetricsInfo | null;
};

export type GitReadResult =
	| { kind: "ok"; status: GitStatusSummary }
	| { kind: "not_a_repo" }
	| { kind: "error" };

export function emptyGitStatus(): GitStatusSummary {
	return {
		branch: undefined,
		dirty: false,
		ahead: 0,
		behind: 0,
		conflicted: 0,
		untracked: 0,
		stashed: 0,
		modified: 0,
		staged: 0,
		renamed: 0,
		deleted: 0,
		typechanged: 0,
		metrics: undefined,
	};
}

export function parseGitStatusPorcelain(stdoutText: string, stashCount: number): GitStatusSummary {
	const status = emptyGitStatus();
	status.stashed = stashCount;

	for (const line of stdoutText.split(/\r?\n/)) {
		if (!line) continue;
		if (line.startsWith("# branch.head ")) {
			const branch = line.slice("# branch.head ".length).trim();
			if (branch === "(detached)") {
				status.branch = undefined;
			} else if (branch) {
				status.branch = branch;
			}
			continue;
		}
		if (line.startsWith("# branch.ab ")) {
			const match = line.match(/\+(\d+)\s+-(\d+)/);
			if (match) {
				status.ahead = Number(match[1] ?? 0);
				status.behind = Number(match[2] ?? 0);
			}
			continue;
		}
		if (line.startsWith("#")) continue;

		status.dirty = true;

		if (line.startsWith("? ")) {
			status.untracked += 1;
			continue;
		}
		if (line.startsWith("u ")) {
			status.conflicted += 1;
			continue;
		}
		if (!(line.startsWith("1 ") || line.startsWith("2 "))) continue;

		const xy = line.split(" ")[1] ?? "..";
		const x = xy[0] ?? ".";
		const y = xy[1] ?? ".";

		if (x === "R") status.renamed += 1;
		else if (x === "D") status.deleted += 1;
		else if (x === "T") status.typechanged += 1;
		else if (x !== "." && x !== " ") status.staged += 1;

		if (y === "M") status.modified += 1;
		else if (y === "D") status.deleted += 1;
		else if (y === "T") status.typechanged += 1;
	}

	return status;
}

export function parseGitNumstat(stdoutText: string): GitMetricsInfo {
	let added = 0;
	let deleted = 0;
	for (const line of stdoutText.split(/\r?\n/)) {
		if (!line) continue;
		const parts = line.split("\t");
		if (parts.length < 3) continue;
		const a = parts[0];
		const d = parts[1];
		if (a === "-" || d === "-") continue;
		const na = Number(a);
		const nd = Number(d);
		if (!Number.isFinite(na) || !Number.isFinite(nd)) continue;
		if (na < 0 || nd < 0) continue;
		added += na;
		deleted += nd;
	}
	return { added, deleted };
}

function isNotARepoError(error: unknown): boolean {
	const message =
		error instanceof Error
			? `${error.message}\n${"stderr" in error ? String((error as { stderr?: unknown }).stderr ?? "") : ""}`
			: String(error);
	return /not a git repository|outside repository|not a git repo/i.test(message);
}

export type ReadGitStatusOptions = {
	readMetrics?: boolean;
	ignoreSubmodules?: boolean;
};

export async function readGitStatus(
	cwd: string,
	options: ReadGitStatusOptions = {},
): Promise<GitReadResult> {
	const readMetrics = options.readMetrics === true;
	try {
		const numstatArgs = ["diff", "HEAD", "--numstat"];
		if (options.ignoreSubmodules) numstatArgs.push("--ignore-submodules=all");
		const [{ stdout: statusStdout }, stashResult, metricsResult] = await Promise.all([
			execFileAsync("git", ["status", "--porcelain=2", "--branch"], {
				cwd,
				timeout: GIT_COMMAND_TIMEOUT_MS,
			}),
			execFileAsync("git", ["stash", "list"], {
				cwd,
				timeout: GIT_COMMAND_TIMEOUT_MS,
			}).catch(() => ({ stdout: "" })),
			readMetrics
				? execFileAsync("git", numstatArgs, {
						cwd,
						timeout: GIT_COMMAND_TIMEOUT_MS,
					}).then(
						(r) => ({ stdout: typeof r.stdout === "string" ? r.stdout : String(r.stdout) }),
						() => ({ stdout: "", failed: true as const }),
					)
				: Promise.resolve({ stdout: "", failed: true as const }),
		]);
		const stdoutText = typeof statusStdout === "string" ? statusStdout : String(statusStdout);
		const stashStdout =
			typeof stashResult.stdout === "string" ? stashResult.stdout : String(stashResult.stdout);
		const stashCount = stashStdout.split(/\r?\n/).filter((line) => line.trim().length > 0).length;
		const status = parseGitStatusPorcelain(stdoutText, stashCount);
		if (readMetrics) {
			if ("failed" in metricsResult && metricsResult.failed) {
				status.metrics = null;
			} else {
				const metricsStdout =
					typeof metricsResult.stdout === "string"
						? metricsResult.stdout
						: String(metricsResult.stdout);
				status.metrics = parseGitNumstat(metricsStdout);
			}
		}
		return { kind: "ok", status };
	} catch (error) {
		if (isNotARepoError(error)) return { kind: "not_a_repo" };
		try {
			const { stdout } = await execFileAsync("git", ["rev-parse", "--is-inside-work-tree"], {
				cwd,
				timeout: GIT_COMMAND_TIMEOUT_MS,
			});
			const inside = (typeof stdout === "string" ? stdout : String(stdout)).trim();
			if (inside !== "true") return { kind: "not_a_repo" };
			return { kind: "error" };
		} catch (inner) {
			if (isNotARepoError(inner)) return { kind: "not_a_repo" };
			return { kind: "error" };
		}
	}
}
