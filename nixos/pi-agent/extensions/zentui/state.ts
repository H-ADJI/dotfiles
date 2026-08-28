import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { ModelLabelSource } from "./config";
import { buildCostLabel, getUsageTotals } from "./format";
import type { GitStatusSummary } from "./git";
import type { PackageVersionResult } from "./package-version";

export type FooterState = {
	modelLabel: string;
	modelId: string;
	modelName: string;
	costLabel: string;
	branch?: string;
	dirty: boolean;
	ahead: number;
	behind: number;
	metrics?: GitStatusSummary["metrics"];
	packageVersion?: PackageVersionResult | null;
	sessionStartEpoch?: number;
};

export function createInitialState(git: GitStatusSummary): FooterState {
	return {
		modelLabel: "no-model",
		modelId: "",
		modelName: "",
		costLabel: "$0.000",
		branch: git.branch,
		dirty: git.dirty,
		ahead: git.ahead,
		behind: git.behind,
		metrics: git.metrics,
		packageVersion: undefined,
		sessionStartEpoch: Date.now(),
	};
}

export function modelLabelFor(
	state: Pick<FooterState, "modelId" | "modelName">,
	source: ModelLabelSource,
): string {
	return source === "name" ? state.modelName || state.modelId || "no-model" : state.modelId || "no-model";
}

export function syncState(state: FooterState, ctx: ExtensionContext): void {
	const totals = getUsageTotals(ctx);
	const m = ctx.model;
	state.modelId = m?.id ?? "";
	state.modelName = m?.name ?? "";
	state.modelLabel = modelLabelFor(state, "id");
	state.costLabel = buildCostLabel(totals);
}

export function applyGitToState(state: FooterState, git: GitStatusSummary): void {
	state.branch = git.branch;
	state.dirty = git.dirty;
	state.ahead = git.ahead;
	state.behind = git.behind;
	state.metrics = git.metrics;
}
