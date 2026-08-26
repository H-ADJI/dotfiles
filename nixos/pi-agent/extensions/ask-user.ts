/**
 * ask_user tool - blocking user decision prompts.
 *
 * TUI: custom multi-question form with review screen.
 * RPC: falls back to pi's built-in ctx.ui dialogs (select/input).
 * ponytail: no markdown rendering, no overlay, no comments. Add when a real
 * use case demands them.
 */

import type {
    ExtensionAPI,
    ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import {
    CURSOR_MARKER,
    Key,
    matchesKey,
    parseKey,
    visibleWidth,
    wrapTextWithAnsi,
} from "@earendil-works/pi-tui";
import { Type, type Static } from "typebox";

const OptionSchema = Type.Object({
    label: Type.String({ description: "Short display label" }),
    description: Type.Optional(
        Type.String({ description: "Explanation or trade-off" }),
    ),
});

const QuestionSchema = Type.Object({
    question: Type.String({ description: "Complete question to ask" }),
    header: Type.Optional(
        Type.String({ description: "Very short label, max 30 chars" }),
    ),
    options: Type.Optional(
        Type.Array(OptionSchema, { description: "Available choices" }),
    ),
    multiple: Type.Optional(
        Type.Boolean({ description: "Allow selecting multiple choices" }),
    ),
    custom: Type.Optional(
        Type.Boolean({
            description: "Allow a typed custom answer (default: true)",
        }),
    ),
});

const AskUserParams = Type.Object({
    questions: Type.Array(QuestionSchema, {
        description: "Questions to ask",
        minItems: 1,
        maxItems: 10,
    }),
});

type AskUserParams = Static<typeof AskUserParams>;
type Option = Static<typeof OptionSchema>;

const OTHER_LABEL = "Type your own answer";

interface Answer {
    header: string;
    question: string;
    values: string[];
}

interface UiQuestion {
    header: string;
    prompt: string;
    options: Option[];
    multiple: boolean;
    custom: boolean;
}

interface UiResult {
    answers: Answer[];
    cancelled: boolean;
}

export default function askUser(pi: ExtensionAPI) {
    pi.registerTool({
        name: "ask_user",
        label: "Ask User",
        description:
            "Ask the user one or more questions and return their answers. Use to clarify ambiguous requirements, get preferences, or let the user decide trade-offs. Answers are arrays of selected labels.",
        promptSnippet:
            "ask_user — ask the user questions to clarify decisions and trade-offs",
        promptGuidelines: [
            "Use ask_user when a decision materially changes implementation and only the user can choose.",
            "Use ask_user for ambiguous requirements, preferences, or trade-offs; do not ask for facts you can inspect yourself.",
            "In ask_user, set option descriptions to explain trade-offs or consequences concisely.",
        ],
        parameters: AskUserParams,
        executionMode: "sequential",

        async execute(
            _toolCallId,
            params: AskUserParams,
            signal,
            onUpdate,
            ctx,
        ) {
            if (ctx.mode !== "tui") {
                throw new Error(
                    "ask_user requires an interactive TUI session.",
                );
            }

            if (params.questions.length === 0) {
                throw new Error("ask_user requires at least one question.");
            }

            const questions: UiQuestion[] = params.questions.map(
                (raw, index) => ({
                    header: raw.header?.trim() || `Q${index + 1}`,
                    prompt: raw.question.trim(),
                    options: raw.options ?? [],
                    multiple: raw.multiple === true,
                    custom: raw.custom !== false,
                }),
            );

            for (const question of questions) {
                if (!question.prompt) {
                    throw new Error(
                        `ask_user question "${question.header}" must have non-empty question text.`,
                    );
                }
            }

            onUpdate?.({
                content: [{ type: "text", text: "Waiting for user input..." }],
                details: { waiting: true },
            });

            ctx.ui.setWorkingVisible?.(false);
            let result: UiResult | null;
            try {
                result = await askInTui(ctx, questions, signal);
            } finally {
                ctx.ui.setWorkingVisible?.(true);
            }

            if (!result) {
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

            const summary = result.answers
                .map(
                    (answer) =>
                        `${answer.header}: ${answer.values.join(", ") || "(no selection)"}`,
                )
                .join("\n");

            return {
                content: [{ type: "text", text: `User answers:\n${summary}` }],
                details: { cancelled: false, answers: result.answers },
            };
        },
    });
}

// ─── TUI custom form ────────────────────────────────────────────────────────

type RenderOption = Option & { isOther?: boolean };

function askInTui(
    ctx: ExtensionContext,
    questions: UiQuestion[],
    signal: AbortSignal | undefined,
): Promise<UiResult | null> {
    return ctx.ui.custom<UiResult | null>((tui, theme, keybindings, done) => {
        let finished = false;
        const finish = (value: UiResult | null) => {
            if (finished) return;
            finished = true;
            done(value);
        };

        if (signal?.aborted) {
            finish(null);
        }
        const onAbort = () => finish(null);
        signal?.addEventListener("abort", onAbort);

        // State
        let tab = 0;
        const totalTabs = questions.length + 1; // last tab is review
        const optionFocus = questions.map(() => 0);
        const answers: string[][] = questions.map(() => []);
        let editing = false;
        let editingQuestion = -1;
        let draft = "";
        let cachedLines: string[] | undefined;

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

        if (questions[0]?.options.length === 0) {
            editing = true;
            editingQuestion = 0;
            draft = answers[0]?.[0] ?? "";
        }

        function refresh() {
            cachedLines = undefined;
            tui.requestRender();
        }

        function allAnswered() {
            return questions.every((_, index) => answers[index]!.length > 0);
        }

        function advance() {
            goToTab(tab < questions.length - 1 ? tab + 1 : questions.length);
        }

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

        function currentOptions(question: UiQuestion): RenderOption[] {
            const options: RenderOption[] = [...question.options];
            if (question.custom) {
                options.push({ label: OTHER_LABEL, isOther: true });
            }
            return options;
        }

        function saveAnswer(questionIndex: number, values: string[]) {
            answers[questionIndex] = values.filter(Boolean);
        }

        function toggleMulti(questionIndex: number, label: string) {
            const current = answers[questionIndex] ?? [];
            answers[questionIndex] = current.includes(label)
                ? current.filter((value) => value !== label)
                : [...current, label];
            refresh();
        }

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
                // Freeform-only question.
                saveAnswer(questionIndex, [trimmed]);
                advance();
                return;
            }

            // Custom "other" answer.
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

        function beginEditing(questionIndex: number, initial: string) {
            editing = true;
            editingQuestion = questionIndex;
            draft = initial;
            refresh();
        }

        function handleInput(data: string) {
            if (editing) {
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

        function handleQuestionInput(data: string) {
            const question = questions[tab];
            if (!question) return;

            if (isNext(data)) {
                goToTab((tab + 1) % totalTabs);
                return;
            }
            if (isPrev(data)) {
                goToTab((tab - 1 + totalTabs) % totalTabs);
                return;
            }

            if (question.options.length === 0) {
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

        function renderDraft() {
            const cursor = `${CURSOR_MARKER}\x1b[7m \x1b[0m`;
            return theme.fg("text", `${draft}${cursor}`);
        }

        function render(width: number): string[] {
            if (cachedLines) return cachedLines;

            const lines: string[] = [];
            const renderWidth = Math.max(1, width);

            function addWrapped(text: string) {
                lines.push(...wrapTextWithAnsi(text, renderWidth));
            }

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

            // Tabs
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

        function renderQuestion(
            questionIndex: number,
            add: (text: string) => void,
            addWithPrefix: (prefix: string, text: string) => void,
            _: number,
        ) {
            const question = questions[questionIndex]!;
            const isEditingQuestion =
                editing && editingQuestion === questionIndex;
            addWithPrefix(" ", theme.fg("text", question.prompt));
            add("");

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
