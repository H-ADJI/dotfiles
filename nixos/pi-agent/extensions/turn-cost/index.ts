import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const KEY = "turn-cost";

  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setStatus(KEY, undefined);
  });

  // Per-turn cost from the assistant message usage on turn completion.
  pi.on("turn_end", async (event, ctx) => {
    const cost = event.message.usage?.cost?.total;
    if (cost != null) ctx.ui.setStatus(KEY, `turn $${cost.toFixed(4)}`);
  });
}
