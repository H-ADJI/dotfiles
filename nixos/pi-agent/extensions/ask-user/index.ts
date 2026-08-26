/**
 * ask_user tool — implementation.
 *
 * The schemas live in `./schemas.ts`; this file is the actual tool logic.
 *
 * WHAT THIS TOOL DOES
 *   The LLM calls `ask_user` with 1..10 questions. This extension opens an
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

import type {
    ExtensionAPI, // the `pi` object pi gives every extension
    ExtensionContext, // the `ctx` object passed to tools/events
} from "@earendil-works/pi-coding-agent";

import {
    CURSOR_MARKER, // hidden marker that moves the real terminal cursor
    Key, // helpers to describe keys, e.g. Key.backspace, Key.shift("tab")
    matchesKey, // `matchesKey(data, Key.backspace)` -> did the user press backspace?
    parseKey, // turn raw terminal input into a readable string like "a" or "space"
    visibleWidth, // width of a string counting wide/ANSI chars correctly
    wrapTextWithAnsi, // wrap text to a width without breaking color codes
} from "@earendil-works/pi-tui";

// Schemas + types defined in ./schemas.ts. The schema is a value
// (`AskUserParamsSchema`), the TS shape is a type (`AskUserParams`).
import {
    AskUserParamsSchema,
    type AskUserParams,
    type Option,
} from "./schemas";

// The "Type your own answer" row we append to choice questions.
const OTHER_LABEL = "Type your own answer";

// ─── Our own (non-schema) types ────────────────────────────────────────────
// These are the plain shapes we use inside the tool, once the schema input
// has been cleaned up.
interface Answer {
    header: string; // short label, e.g. "Scope"
    question: string; // full question text
    values: string[]; // chosen label(s), e.g. ["staging"] or ["a","b"]
}

interface UiQuestion {
    header: string;
    prompt: string; // same as `question`, but trimmed
    options: Option[];
    multiple: boolean;
    custom: boolean;
}

interface UiResult {
    answers: Answer[];
    cancelled: boolean;
}

// ─── Registering the tool ──────────────────────────────────────────────────
// `export default function initExtension(pi)` is the entry point pi calls when
// the extension loads. Here we tell pi "there is a tool called ask_user".
export default function initExtension(pi: ExtensionAPI) {
    pi.registerTool({
        // Identity + model-facing text.
        name: "ask_user",
        label: "Ask User",
        description:
            "Ask the user one or more questions and return their answers. Use to clarify ambiguous requirements, get preferences, or let the user decide trade-offs. Answers are arrays of selected labels.",
        // promptSnippet / promptGuidelines are injected into the system prompt
        // so the model knows when to call this tool. See extensions.md.
        promptSnippet:
            "ask_user — ask the user questions to clarify decisions and trade-offs",
        promptGuidelines: [
            "Use ask_user when a decision materially changes implementation and only the user can choose.",
            "Use ask_user for ambiguous requirements, preferences, or trade-offs; do not ask for facts you can inspect yourself.",
            "In ask_user, set option descriptions to explain trade-offs or consequences concisely.",
        ],
        // The schema the LLM must respect when calling.
        parameters: AskUserParamsSchema,
        // Run tools one at a time (no parallel sibling tool calls) so a form
        // never races with another tool. See extensions.md -> Custom Tools.
        executionMode: "sequential",

        // ─── execute() ──────────────────────────────────────────────────
        // This is what runs when the model calls the tool. It is `async`, so
        // it can `await` the form until the user answers.
        async execute(
            _toolCallId, // id of this specific call (not needed here)
            params: AskUserParams, // the validated args from the LLM
            signal, // AbortSignal: fires if the user cancels the whole turn
            onUpdate, // callback to stream progress into the TUI tool row
            ctx, // everything about the current session + UI
        ) {
            // This tool needs the interactive TUI (custom UI + keyboard).
            if (ctx.mode !== "tui") {
                throw new Error(
                    "ask_user requires an interactive TUI session.",
                );
            }

            if (params.questions.length === 0) {
                throw new Error("ask_user requires at least one question.");
            }

            // Clean up the LLM input into our internal UiQuestion shape.
            // `raw` is a discriminated union, so `raw.type` tells us which
            // variant it is and TypeScript narrows the fields for us.
            const questions: UiQuestion[] = params.questions.map((raw) => {
                const base = {
                    header: raw.header.trim(),
                    prompt: raw.question.trim(),
                    custom: raw.custom !== false,
                };
                if (raw.type === "single") {
                    return { ...base, options: raw.options, multiple: false };
                }
                if (raw.type === "multiple") {
                    return { ...base, options: raw.options, multiple: true };
                }
                return { ...base, options: [], multiple: false };
            });

            for (const question of questions) {
                if (!question.prompt) {
                    throw new Error(
                        `ask_user question "${question.header}" must have non-empty question text.`,
                    );
                }
            }

            // Tell the TUI "tool is waiting for the user" so it doesn't look
            // frozen. See pi-ask-user/supi-ask-user for the same pattern.
            onUpdate?.({
                content: [{ type: "text", text: "Waiting for user input..." }],
                details: { waiting: true },
            });

            // Hide the spinner while the form is up.
            ctx.ui.setWorkingVisible?.(false);
            let result: UiResult | null;
            try {
                // Open the custom form. This *waits* until the user submits
                // or cancels.
                result = await askInTui(ctx, questions, signal);
            } finally {
                // Always restore the spinner, even on error/cancel.
                ctx.ui.setWorkingVisible?.(true);
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

// ─── TUI custom form ───────────────────────────────────────────────────────
// Everything below is the interactive form. It only runs in TUI mode.

type RenderOption = Option & { isOther?: boolean };

/**
 * Opens the form and resolves to the user's answers (or null if cancelled).
 *
 * `ctx.ui.custom()` replaces the editor with our component. The component
 * must return `{ render, invalidate, handleInput, ... }`. See tui.md.
 * The callback gives us:
 *   tui        - low-level screen object (requestRender, terminal size)
 *   theme      - colors/styling helpers (theme.fg, theme.bg)
 *   keybindings- the user's configured key bindings
 *   done(value)- call this to close the form and resolve the promise
 */
function askInTui(
    ctx: ExtensionContext,
    questions: UiQuestion[],
    signal: AbortSignal | undefined,
): Promise<UiResult | null> {
    return ctx.ui.custom<UiResult | null>((tui, theme, keybindings, done) => {
        // `finished` guard: done() must only be called once.
        let finished = false;
        const finish = (value: UiResult | null) => {
            if (finished) return;
            finished = true;
            done(value);
        };

        // If the whole agent turn is aborted, close the form.
        if (signal?.aborted) {
            finish(null);
        }
        const onAbort = () => finish(null);
        signal?.addEventListener("abort", onAbort);

        // ─── Form state ─────────────────────────────────────────────────
        let tab = 0; // which tab we're on: 0..questions.length-1, review = questions.length
        const totalTabs = questions.length + 1; // last tab is review
        const optionFocus = questions.map(() => 0); // selected option per question
        const answers: string[][] = questions.map(() => []); // values per question
        let editing = false; // are we typing free text right now?
        let editingQuestion = -1; // which question is being typed
        let draft = ""; // the in-progress free text
        let cachedLines: string[] | undefined; // last rendered screen, for speed

        // ─── Keybindings ────────────────────────────────────────────────
        // Instead of hardcoding keys, ask pi what the user configured.
        // `kb(action, data)` -> true if the pressed key matches that action.
        const kb = (
            action: Parameters<typeof keybindings.matches>[1],
            data: string,
        ) => keybindings.matches(data, action);
        const isUp = (data: string) => kb("tui.select.up", data);
        const isDown = (data: string) => kb("tui.select.down", data);
        const isConfirm = (data: string) => kb("tui.select.confirm", data);
        const isCancel = (data: string) => kb("tui.select.cancel", data);
        const isNext = (data: string) =>
            kb("tui.input.tab", data) || kb("tui.editor.cursorRight", data);
        const isPrev = (data: string) =>
            kb("tui.editor.cursorLeft", data) ||
            matchesKey(data, Key.shift("tab"));

        // If the very first question is free-form, start typing immediately.
        if (questions[0]?.options.length === 0) {
            editing = true;
            editingQuestion = 0;
            draft = answers[0]?.[0] ?? "";
        }

        // ─── Small helpers ──────────────────────────────────────────────
        // Force the screen to redraw. `cachedLines` is cleared so render()
        // rebuilds the screen.
        function refresh() {
            cachedLines = undefined;
            tui.requestRender();
        }

        // True once every question has at least one answer.
        function allAnswered() {
            return questions.every((_, index) => answers[index]!.length > 0);
        }

        // After answering the current question, move on (or to review).
        function advance() {
            goToTab(tab < questions.length - 1 ? tab + 1 : questions.length);
        }

        // Switch to another tab. If it's a free-form question, start typing.
        function goToTab(nextTab: number) {
            tab = nextTab;
            if (tab === questions.length) {
                editing = false;
                editingQuestion = -1;
                draft = "";
                refresh();
                return;
            }

            const question = questions[tab];
            if (question?.options.length === 0) {
                beginEditing(tab, answers[tab]?.[0] ?? "");
                return;
            }
            editing = false;
            editingQuestion = -1;
            draft = "";
            refresh();
        }

        // The list of options to show, plus the "Type your own answer" row.
        function currentOptions(question: UiQuestion): RenderOption[] {
            const options: RenderOption[] = [...question.options];
            if (question.custom) {
                options.push({ label: OTHER_LABEL, isOther: true });
            }
            return options;
        }

        // Store an answer, dropping empty strings.
        function saveAnswer(questionIndex: number, values: string[]) {
            answers[questionIndex] = values.filter(Boolean);
        }

        // Multi-select: add/remove a chosen label.
        function toggleMulti(questionIndex: number, label: string) {
            const current = answers[questionIndex] ?? [];
            answers[questionIndex] = current.includes(label)
                ? current.filter((value) => value !== label)
                : [...current, label];
            refresh();
        }

        // Enter was pressed while typing free text.
        function submitDraft() {
            if (editingQuestion < 0) return;
            const questionIndex = editingQuestion;
            const question = questions[questionIndex];
            const trimmed = draft.trim();
            editing = false;
            editingQuestion = -1;
            draft = "";

            if (!question) {
                refresh();
                return;
            }

            if (question.options.length === 0) {
                // Free-form-only question: save and move on.
                saveAnswer(questionIndex, [trimmed]);
                advance();
                return;
            }

            // "Type your own answer" on a choice question.
            if (!trimmed) {
                refresh();
                return;
            }
            if (question.multiple) {
                const current = answers[questionIndex] ?? [];
                if (!current.includes(trimmed)) current.push(trimmed);
                saveAnswer(questionIndex, current);
                refresh();
            } else {
                saveAnswer(questionIndex, [trimmed]);
                advance();
            }
        }

        // Switch into typing mode for a question.
        function beginEditing(questionIndex: number, initial: string) {
            editing = true;
            editingQuestion = questionIndex;
            draft = initial;
            refresh();
        }

        // ─── Input handling ─────────────────────────────────────────────
        // pi sends raw key data here. We route it to the right handler.
        function handleInput(data: string) {
            if (editing) {
                // We're typing text.
                if (isCancel(data)) {
                    editing = false;
                    editingQuestion = -1;
                    draft = "";
                    refresh();
                    return;
                }
                if (isConfirm(data)) {
                    submitDraft();
                    return;
                }
                if (matchesKey(data, Key.backspace)) {
                    draft = draft.slice(0, -1);
                    refresh();
                    return;
                }
                const key = parseKey(data);
                if (key === "space" || data === "space") {
                    draft += " ";
                    refresh();
                    return;
                }
                if (key && key.length === 1) {
                    draft += key;
                    refresh();
                }
                return;
            }

            if (tab === questions.length) {
                handleReviewInput(data);
                return;
            }

            handleQuestionInput(data);
        }

        // Review tab: just submit, or tab back to a question.
        function handleReviewInput(data: string) {
            if (isConfirm(data)) {
                if (allAnswered()) {
                    finish({
                        answers: buildAnswers(questions, answers),
                        cancelled: false,
                    });
                }
                return;
            }
            if (isCancel(data)) {
                finish(null);
                return;
            }
            if (isPrev(data)) {
                goToTab(questions.length - 1);
                return;
            }
            if (isNext(data)) {
                goToTab(0);
            }
        }

        // One question tab: navigate options, pick, or start typing.
        function handleQuestionInput(data: string) {
            const question = questions[tab];
            if (!question) return;

            // Move between tabs.
            if (isNext(data)) {
                goToTab((tab + 1) % totalTabs);
                return;
            }
            if (isPrev(data)) {
                goToTab((tab - 1 + totalTabs) % totalTabs);
                return;
            }

            if (question.options.length === 0) {
                // Free-form question.
                if (isConfirm(data)) {
                    beginEditing(tab, answers[tab]?.[0] ?? "");
                    return;
                }
                if (isCancel(data)) {
                    finish(null);
                }
                return;
            }

            const options = currentOptions(question);
            const focus = optionFocus[tab] ?? 0;

            // Move the highlight up/down.
            if (isUp(data)) {
                optionFocus[tab] = Math.max(0, focus - 1);
                refresh();
                return;
            }
            if (isDown(data)) {
                optionFocus[tab] = Math.min(options.length - 1, focus + 1);
                refresh();
                return;
            }

            if (question.multiple) {
                // Multi-select: Space toggles, Enter advances when done.
                if (matchesKey(data, Key.space)) {
                    const option = options[focus];
                    if (option && !option.isOther) {
                        toggleMulti(tab, option.label);
                    }
                    return;
                }
                if (isConfirm(data)) {
                    const option = options[focus];
                    if (option?.isOther) {
                        beginEditing(tab, "");
                        return;
                    }
                    if ((answers[tab]?.length ?? 0) > 0) {
                        advance();
                    }
                    return;
                }
            } else {
                // Single select: Enter picks it and moves on.
                if (isConfirm(data)) {
                    const option = options[focus];
                    if (option?.isOther) {
                        beginEditing(tab, "");
                        return;
                    }
                    if (option) {
                        saveAnswer(tab, [option.label]);
                        advance();
                    }
                    return;
                }
            }

            if (isCancel(data)) {
                finish(null);
            }
        }

        // Turn internal answers into the public Answer[] result.
        function buildAnswers(
            questions: UiQuestion[],
            answers: string[][],
        ): Answer[] {
            return questions.map((question, index) => ({
                header: question.header,
                question: question.prompt,
                values: answers[index] ?? [],
            }));
        }

        // ─── Rendering ──────────────────────────────────────────────────
        // Draw a one-line text input with a fake cursor. CURSOR_MARKER lets
        // the terminal position the real cursor for IME support.
        function renderDraft() {
            const cursor = `${CURSOR_MARKER}\x1b[7m \x1b[0m`;
            return theme.fg("text", `${draft}${cursor}`);
        }

        // Builds the whole screen as an array of strings (one per terminal row).
        function render(width: number): string[] {
            if (cachedLines) return cachedLines;

            const lines: string[] = [];
            const renderWidth = Math.max(1, width);

            // Add a line, word-wrapped to the terminal width.
            function addWrapped(text: string) {
                lines.push(...wrapTextWithAnsi(text, renderWidth));
            }

            // Add a line with a fixed prefix (indent/arrow) that survives wrapping.
            function addWrappedWithPrefix(prefix: string, text: string) {
                const prefixWidth = visibleWidth(prefix);
                if (prefixWidth >= renderWidth) {
                    addWrapped(prefix + text);
                    return;
                }
                const wrapped = wrapTextWithAnsi(
                    text,
                    renderWidth - prefixWidth,
                );
                const continuationPrefix = " ".repeat(prefixWidth);
                for (let i = 0; i < wrapped.length; i++) {
                    lines.push(
                        `${i === 0 ? prefix : continuationPrefix}${wrapped[i]}`,
                    );
                }
            }

            lines.push(theme.fg("accent", "─".repeat(renderWidth)));

            // Tabs: one per question + review.
            const tabs: string[] = [];
            for (let i = 0; i < questions.length; i++) {
                const active = i === tab;
                const answered = (answers[i]?.length ?? 0) > 0;
                const label = `${answered ? "■" : "□"} ${questions[i]!.header}`;
                tabs.push(
                    active
                        ? theme.bg("selectedBg", theme.fg("text", ` ${label} `))
                        : theme.fg(
                              answered ? "success" : "muted",
                              ` ${label} `,
                          ),
                );
            }
            const submitActive = tab === questions.length;
            const submitLabel = allAnswered() ? "✓ Review" : "Review";
            tabs.push(
                submitActive
                    ? theme.bg(
                          "selectedBg",
                          theme.fg("text", ` ${submitLabel} `),
                      )
                    : theme.fg(
                          allAnswered() ? "success" : "dim",
                          ` ${submitLabel} `,
                      ),
            );
            addWrappedWithPrefix(" ", tabs.join(" "));
            lines.push("");

            // Show the active tab's body.
            if (tab === questions.length) {
                renderReview(addWrapped, addWrappedWithPrefix, renderWidth);
            } else {
                renderQuestion(
                    tab,
                    addWrapped,
                    addWrappedWithPrefix,
                    renderWidth,
                );
            }

            lines.push("");
            lines.push(theme.fg("accent", "─".repeat(renderWidth)));

            cachedLines = lines;
            return lines;
        }

        // Render a single question tab.
        function renderQuestion(
            questionIndex: number,
            add: (text: string) => void,
            addWithPrefix: (prefix: string, text: string) => void,
            _width: number,
        ) {
            const question = questions[questionIndex]!;
            const isEditingQuestion =
                editing && editingQuestion === questionIndex;
            addWithPrefix(" ", theme.fg("text", question.prompt));
            add("");

            // Free-form question: show the text input.
            if (question.options.length === 0) {
                if (isEditingQuestion) {
                    addWithPrefix(" ", theme.fg("muted", "Your answer:"));
                    addWithPrefix(" ", renderDraft());
                    add("");
                    addWithPrefix(
                        " ",
                        theme.fg("dim", "Enter to submit • Esc to cancel"),
                    );
                } else {
                    addWithPrefix(" ", theme.fg("muted", "Free text answer"));
                    addWithPrefix(
                        " ",
                        theme.fg("dim", "Enter to type • Esc to cancel"),
                    );
                }
                return;
            }

            // Choice question: list options with markers.
            const options = currentOptions(question);
            const focus = optionFocus[questionIndex] ?? 0;
            const selected = new Set(answers[questionIndex] ?? []);

            options.forEach((option, index) => {
                const focused = index === focus;
                const isOther = option.isOther === true;
                const isSelected = !isOther && selected.has(option.label);
                const marker = question.multiple
                    ? isSelected
                        ? theme.fg("success", "[x]")
                        : "[ ]"
                    : focused
                      ? theme.fg("accent", ">")
                      : " ";
                const prefix = ` ${marker} `;
                const label = `${index + 1}. ${option.label}${isOther && isEditingQuestion ? " ✎" : ""}`;
                const color =
                    focused || (isOther && isEditingQuestion)
                        ? "accent"
                        : "text";
                addWithPrefix(prefix, theme.fg(color, label));
                if (option.description) {
                    addWithPrefix(
                        "      ",
                        theme.fg("muted", option.description),
                    );
                }
            });

            // If typing a custom "other" answer, show the input line.
            if (isEditingQuestion) {
                add("");
                addWithPrefix(" ", theme.fg("muted", "Your answer:"));
                addWithPrefix(" ", renderDraft());
            }

            add("");
            const help = question.multiple
                ? "Space toggle • Enter next • Tab/←→ tabs • Esc cancel"
                : "↑↓ select • Enter choose • Tab/←→ tabs • Esc cancel";
            addWithPrefix(" ", theme.fg("dim", help));
        }

        // Render the review tab: summary + submit. Not selectable.
        function renderReview(
            add: (text: string) => void,
            addWithPrefix: (prefix: string, text: string) => void,
            _width: number,
        ) {
            addWithPrefix(" ", theme.fg("accent", theme.bold("Review")));
            add("");

            questions.forEach((question, index) => {
                const values =
                    (answers[index] ?? []).join(", ") ||
                    theme.fg("warning", "unanswered");
                addWithPrefix(
                    " ",
                    theme.fg("muted", `${question.header}: `) +
                        theme.fg("text", values),
                );
            });

            add("");
            const submitText = allAnswered()
                ? theme.fg("success", "> Submit")
                : theme.fg(
                      "warning",
                      `Unanswered: ${questions
                          .filter((_, i) => (answers[i]?.length ?? 0) === 0)
                          .map((q) => q.header)
                          .join(", ")}`,
                  );
            addWithPrefix(" ", submitText);

            add("");
            addWithPrefix(
                " ",
                theme.fg("dim", "Enter submit • Tab/←→ back • Esc cancel"),
            );
        }

        // The component pi needs: how to draw it and how to feed it keys.
        // `invalidate` is called on theme changes. `dispose` cleans up.
        return {
            render,
            invalidate: () => {
                cachedLines = undefined;
            },
            handleInput,
            dispose: () => {
                signal?.removeEventListener("abort", onAbort);
            },
        };
    });
}
