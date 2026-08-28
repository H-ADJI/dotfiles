import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { SimpleTuiConfig } from "./config";

export class WorkingLineController {
	constructor(private readonly getConfig: () => SimpleTuiConfig) {}

	startTurn(ctx: ExtensionContext): void {
		const config = this.getConfig();
		if (!config.enabled || !config.workingLine.enabled) return;
		const messages = config.workingLine.messages;
		const text = messages[Math.floor(Math.random() * messages.length)] ?? "Working";
		ctx.ui.setWorkingMessage(text);
	}

	dispose(ctx: ExtensionContext): void {
		try {
			ctx.ui.setWorkingMessage();
		} catch {
			// Best-effort restore during teardown.
		}
	}
}
