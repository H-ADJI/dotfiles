/**
 * ask_user tool — implementation.
 *
 * The schemas live in `./schemas.ts`; this file is the actual tool logic.
 *
 * WHAT THIS TOOL DOES
 *   The LLM calls `skeptic_agent` with 1..10 questions. This extension opens an
 *   interactive form (custom TUI), pauses the agent, and returns the user's
 *   answers back to the LLM.
 *
 * READ FIRST (docs / sources to learn from):
 * - Pi extensions (registerTool, ctx, execute): https://pi.dev/docs/latest/extensions
 * - Pi TUI components (custom(), render, handleInput): https://pi.dev/docs/latest/tui
 * - Pi keybindings (tui.select.up, tui.input.tab, ...): https://pi.dev/docs/latest/keybindings
 * - Similar real extensions to compare with:
 *     https://github.com/edlsh/pi-ask-user
 *     https://github.com/IgorWarzocha/howaboua-pi-stuff  (packages/pi-ask)
 *     https://github.com/mrclrchtr/supi                   (packages/supi-ask-user)
 *     https://github.com/anomalyco/opencode               (its `question` tool)
 */

//  TODO: fix free-form text display
import type {
    AgentToolUpdateCallback, // type of the `onUpdate` progress callback
    ExtensionAPI, // the `pi` object pi gives every extension
    ExtensionContext, // the `ctx` object passed to tools/events
} from "@earendil-works/pi-coding-agent";

import { AskUserParamsSchema, type AskUserParams } from "./schemas";
import {
    runForm,
    type Answer,
    type UiQuestion,
    type UiResult,
} from "./form-tui";

// ─── Registering the tool ──────────────────────────────────────────────────
// `export default function initExtension(pi)` is the entry point pi calls when
// the extension loads. Here we tell pi "there is a tool called skeptic_agent".
export default function initExtension(pi: ExtensionAPI) {
    pi.registerTool({
        name: "skeptic_agent",
        label: "Skeptic Agent",
        description:
            "Ask the user one or more questions and return their answers. Use to clarify ambiguous requirements, get preferences, or let the user decide trade-offs. Answers are arrays of selected labels.",
        promptSnippet:
            "skeptic_agent — ask the user questions to clarify decisions and trade-offs",
        promptGuidelines: [
            "Use skeptic_agent for ambiguous requirements, and to know user preferences.",
            "Use skeptic_agent to discuss trade-offs.",
            "Use skeptic_agent to challenge user choices, suggest alternative choices.",
            "In skeptic_agent, set option descriptions to explain trade-offs or consequences concisely.",
            "In skeptic_agent, set `recommended: true` only when you have a genuine best choice.",
        ],
        parameters: AskUserParamsSchema,
        executionMode: "sequential",

        // ─── execute() ──────────────────────────────────────────────────
        // This is what runs when the model calls the tool. It is `async`, so
        // it can `await` the form until the user answers.
        execute: async (
            _toolCallId: string,
            params: AskUserParams,
            signal: AbortSignal,
            onUpdate: AgentToolUpdateCallback | undefined,
            ctx: ExtensionContext,
        ) => {
            // This tool needs the interactive TUI (custom UI + keyboard).
            if (ctx.mode !== "tui") {
                throw new Error(
                    "skeptic_agent requires an interactive TUI session.",
                );
            }
            // Clean up the LLM input into our internal UiQuestion shape.
            // The schema already matches UiQuestion, so this is just trimming.
            // `options: []` = free-text question.
            const questions: UiQuestion[] = params.questions.map((raw) => ({
                header: raw.header.trim(),
                questionText: raw.question.trim(),
                options: raw.options,
                isMultipleChoice: raw.isMultipleChoice,
            }));

            // Tell the TUI "tool is waiting for the user" so it doesn't look
            // frozen. See pi-ask-user/supi-ask-user for the same pattern.
            onUpdate?.({
                content: [{ type: "text", text: "Waiting for user input..." }],
                details: { waiting: true },
            });

            // Hide the spinner while the form is up.
            ctx.ui.setWorkingVisible(false);

            let result: UiResult | null;
            try {
                result = await runForm(ctx, questions, signal); // Open form and wait until the user submits or cancels.
            } finally {
                ctx.ui.setWorkingVisible(true);
            }

            if (!result) {
                // User pressed cancel.
                return {
                    content: [
                        {
                            type: "text",
                            text: "User cancelled the questions. Stop asking and adjust based on the cancellation.",
                        },
                    ],
                    details: { cancelled: true, answers: [] as Answer[] },
                };
            }

            // Turn answers into a compact text summary the LLM reads.
            const summary = result.answers
                .map(
                    (answer) =>
                        `${answer.header}: ${answer.values.join(", ") || "(no selection)"}`,
                )
                .join("\n");

            // Return value the model sees. `details` is also stored in the
            // session for later rendering/state reconstruction.
            return {
                content: [{ type: "text", text: `User answers:\n${summary}` }],
                details: { cancelled: false, answers: result.answers },
            };
        },
    });
}
