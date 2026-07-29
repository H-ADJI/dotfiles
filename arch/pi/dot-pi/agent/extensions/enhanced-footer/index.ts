import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  let currentThinkingLevel = "off";

  pi.on("thinking_level_select", async (event, ctx) => {
    currentThinkingLevel = event.level;
  });

  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => ({
      invalidate() {},
      render(width: number): string[] {
        const usage = ctx.getContextUsage();
        const model = ctx.model;
        
        // --- LINE 1: STATUS & IDENTITY ---
        const statuses = Array.from(footerData.getExtensionStatuses().values());
        const isPlanMode = statuses.some(s => s.toLowerCase().includes("plan"));
        const modeLabel = isPlanMode 
          ? theme.fg("warning", "[PLAN MODE]") 
          : theme.fg("success", "[AUTO MODE]");
        
        const modelInfo = theme.fg("accent", ` ${model?.provider || "none"}/${model?.id || "none"} `);
        const thinking = theme.fg("accent", ` Thinking: ${currentThinkingLevel} `);
        const git = footerData.getGitBranch() ? theme.fg("accent", ` branch:${footerData.getGitBranch()} `) : "";

        const line1 = truncateToWidth(`${modeLabel}${modelInfo}${thinking}${git}`, width);

        // --- LINE 2: USAGE & METRICS ---
        let line2 = "";
        if (usage && model?.contextWindow) {
          const used = usage.tokens;
          const total = model.contextWindow;
          const percent = Math.round((used / total) * 100);
          
          const usageColor = percent > 90 ? "error" : percent > 70 ? "warning" : "success";
          const barWidth = 15;
          const filledWidth = Math.round((percent / 100) * barWidth);
          const bar = theme.fg(usageColor, "█".repeat(filledWidth)) + 
                      theme.fg("borderMuted", "░".repeat(Math.max(0, barWidth - filledWidth)));

          const stats = ` ${used.toLocaleString()} / ${(total / 1000).toFixed(0)}k (${percent}%)`;
          
          // Full word breakdown
          const breakdown = theme.fg("dim", ` (Input:${usage.inputTokens || 0} Output:${usage.outputTokens || 0} Cache:${usage.cacheReadTokens || 0})`);
          
          // Cost
          const costText = usage.cost?.total ? theme.fg("warning", ` $${usage.cost.total.toFixed(3)}`) : "";

          line2 = theme.fg("muted", "Context: ") + bar + theme.fg(usageColor, stats) + breakdown + costText;
        } else {
          line2 = theme.fg("dim", "Metrics update after first turn...");
        }

        return [
          theme.fg("border", "─".repeat(width)),
          line1,
          truncateToWidth(line2, width)
        ];
      },
      dispose: footerData.onBranchChange(() => tui.requestRender()),
    }));
  });
}
