/**
 * clipboard — auto-copy the final assistant response to the system clipboard.
 *
 * After every `agent_settled` event (i.e. when the agent is truly done — no
 * retries, compaction retries, or queued follow-ups left), the last assistant
 * response text is copied. Uses pi's own `copyToClipboard()` helper (the same
 * one behind the built-in `/copy` command), which picks wl-copy/xclip/pbcopy
 * or OSC 52 depending on the environment — no extra dependency.
 *
 * Config: `~/.pi/agent/clipboard.json`, `{ "enabled": true }`.
 * The file is read fresh on every settle, so toggling it takes effect without
 * `/reload`. Missing/invalid file → enabled (default).
 *
 * Disable without editing nix: set `enabled` to `false` in that file.
 */

import { readFile } from "node:fs/promises";
import { join } from "node:path";

import {
    copyToClipboard,
    getAgentDir,
    type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

export default function initExtension(pi: ExtensionAPI) {
    pi.on("agent_settled", async (_event, ctx) => {
        let enabled = true;
        try {
            ({ enabled = true } = JSON.parse(
                await readFile(join(getAgentDir(), "clipboard.json"), "utf8"),
            ));
        } catch {
            // Missing/unreadable config → enabled (default).
        }
        if (!enabled) return;

        // Last assistant message on the current branch, like
        // examples/extensions/qna.ts. Entry wraps a message.
        const branch = ctx.sessionManager.getBranch();
        let text = "";
        for (let i = branch.length - 1; i >= 0; i--) {
            const entry = branch[i];
            if (entry.type !== "message") continue;
            const msg = entry.message;
            if ("role" in msg && msg.role === "assistant") {
                // Aborted/cancelled turn → don't copy the partial response.
                if (msg.stopReason !== "stop") return;
                text = msg.content
                    .filter((c): c is { type: "text"; text: string } => c.type === "text")
                    .map((c) => c.text)
                    .join("\n");
                break;
            }
        }
        if (!text) return;

        try {
            await copyToClipboard(text);
            if (ctx.hasUI) {
                ctx.ui.notify("Response copied to clipboard", "info");
            }
        } catch (err) {
            // Never break the session over a clipboard failure
            if (ctx.hasUI) {
                ctx.ui.notify(`Clipboard copy failed: ${err}`, "error");
            }
        }
    });
}