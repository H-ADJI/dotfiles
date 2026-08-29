// ask_user tool: schemas in ./schemas.ts, TUI form in ./form-tui.ts.
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
            "Ask the user one or more questions and return their answers. " +
            "Use to clarify ambiguous requirements, resolve trade-offs, or confirm decisions that materially change what gets built.",
        promptSnippet:
            "Ask the user questions to clarify requirements, resolve ambiguity, and decide trade-offs",
        promptGuidelines: [
            "Use skeptic_agent for ambiguous requirements, and to know user preferences.",
            "Use skeptic_agent to discuss trade-offs.",
            "Use skeptic_agent to challenge user choices, suggest alternative choices.",
            "Use skeptic_agent only when the answer materially changes what gets built; skip questions answerable from context or codebase conventions.",
            "In skeptic_agent, present specific options with brief trade-offs; avoid open-ended or multi-part questions.",
            "Batch independent questions into one skeptic_agent call; ask follow-up questions after answers arrive.",
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
