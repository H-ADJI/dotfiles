import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { ZentuiConfig } from "./config";

const PINWHEEL_FRAMES = ["-", "\\", "|", "/"];
const SPINNER_INTERVAL_MS = 100;

export class WorkingLineController {
	private installed = false;

	constructor(private readonly getConfig: () => ZentuiConfig) {}

	startSession(ctx: ExtensionContext): void {
		const config = this.getConfig();
		if (!config.components.workingLine.enabled) return;
		ctx.ui.setWorkingIndicator({ frames: PINWHEEL_FRAMES, intervalMs: SPINNER_INTERVAL_MS });
		this.installed = true;
	}

	dispose(ctx: ExtensionContext): void {
		if (!this.installed) return;
		try {
			ctx.ui.setWorkingIndicator();
		} catch {
			// Restoring the default spinner is best-effort during teardown.
		}
		this.installed = false;
	}
}
