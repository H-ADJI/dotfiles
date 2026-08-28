import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { SimpleTuiConfig } from "./config";

const PINWHEEL_FRAMES = ["-", "\\", "|", "/"];
const SPINNER_INTERVAL_MS = 100;

export class WorkingLineController {
	private installed = false;

	constructor(private readonly getConfig: () => SimpleTuiConfig) {}

	startSession(ctx: ExtensionContext): void {
		const config = this.getConfig();
		if (!config.enabled || !config.workingLine.enabled) return;
		ctx.ui.setWorkingIndicator({ frames: PINWHEEL_FRAMES, intervalMs: SPINNER_INTERVAL_MS });
		this.installed = true;
	}

	startTurn(ctx: ExtensionContext): void {
		if (!this.installed) return;
		const messages = this.getConfig().workingLine.messages;
		const text = messages[Math.floor(Math.random() * messages.length)] ?? "Working";
		ctx.ui.setWorkingMessage(text);
	}

	dispose(ctx: ExtensionContext): void {
		if (!this.installed) return;
		try {
			ctx.ui.setWorkingMessage();
			ctx.ui.setWorkingIndicator();
		} catch {
			// Best-effort restore during teardown.
		}
		this.installed = false;
	}
}
