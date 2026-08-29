import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import {
    Input,
    Key,
    matchesKey,
    visibleWidth,
    wrapTextWithAnsi,
} from "@earendil-works/pi-tui";
import type { Option } from "./schemas";

// The "Type your own answer" row we append to choice questions.
const OTHER_LABEL = "Type your own answer";

// Plain shapes used only by the form. `Option` comes from schemas.ts.
export interface UiQuestion {
    header: string;
    questionText: string;
    options: Option[];
    isMultipleChoice: boolean;
}

export interface Answer {
    header: string;
    question: string;
    values: string[];
}

export interface UiResult {
    answers: Answer[];
}

type RenderOption = Option & { isOther?: boolean };

// ─── Pure helpers (no form state) ────────────────────────────────────────

function isAnswered(answers: string[][], index: number): boolean {
    return answers[index].length > 0;
}

function allAnswered(questions: UiQuestion[], answers: string[][]): boolean {
    return questions.every((_, index) => isAnswered(answers, index));
}

function buildAnswers(questions: UiQuestion[], answers: string[][]): Answer[] {
    return questions.map((question, index) => ({
        header: question.header,
        question: question.questionText,
        values: answers[index] ?? [],
    }));
}

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
export function runForm(
    ctx: ExtensionContext,
    questions: UiQuestion[],
    signal: AbortSignal,
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
        let editingQuestion = -1; // which question is being typed
        let cachedLines: string[] | undefined; // last rendered screen, for speed

        // Single-line editor for free-text answers.
        // ponytail: undo history persists across editing sessions; reset it if stale undo ever confuses.
        const input = new Input();
        input.onSubmit = (value) => submitDraft(value);
        input.onEscape = () => {
            leaveEditing();
            refresh();
        };

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
        if (questions[0].options.length === 0) {
            beginEditing(0, answers[0][0] ?? "");
        }

        // ─── Small helpers ──────────────────────────────────────────────
        // Force the screen to redraw. `cachedLines` is cleared so render()
        // rebuilds the screen.
        function refresh() {
            cachedLines = undefined;
            tui.requestRender();
        }

        // Stop editing.
        function leaveEditing() {
            editingQuestion = -1;
            input.focused = false;
        }

        // After answering the current question, move on (or to review).
        function advance() {
            goToTab(tab < questions.length - 1 ? tab + 1 : questions.length);
        }

        // Switch to another tab. If it's a free-form question, start typing.
        function goToTab(nextTab: number) {
            tab = nextTab;
            if (tab === questions.length) {
                leaveEditing();
                refresh();
                return;
            }

            const question = questions[tab];
            if (question.options.length === 0) {
                if (isAnswered(answers, tab)) {
                    // Already answered: show the saved text read-only.
                    leaveEditing();
                    refresh();
                } else {
                    // Unanswered free-form question: start typing immediately.
                    beginEditing(tab, "");
                }
                return;
            }
            leaveEditing();
            refresh();
        }

        // The list of options to show, plus the free-form row.
        function currentOptions(question: UiQuestion): RenderOption[] {
            const options: RenderOption[] = [...question.options];
            options.push({ label: OTHER_LABEL, isOther: true });
            return options;
        }

        // Store an answer, dropping empty strings.
        function saveAnswer(questionIndex: number, values: string[]) {
            answers[questionIndex] = values.filter(Boolean);
        }

        // Multi-select: add/remove a chosen label.
        function toggleMulti(questionIndex: number, label: string) {
            const current = answers[questionIndex];
            answers[questionIndex] = current.includes(label)
                ? current.filter((value) => value !== label)
                : [...current, label];
            refresh();
        }

        // Enter was pressed while typing free text.
        function submitDraft(rawValue: string) {
            if (editingQuestion < 0) return;
            const questionIndex = editingQuestion;
            const question = questions[questionIndex];
            const trimmed = rawValue.trim();
            leaveEditing();

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
            if (question.isMultipleChoice) {
                const current = answers[questionIndex];
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
            editingQuestion = questionIndex;
            input.setValue(initial);
            input.focused = true;
            refresh();
        }

        // ─── Input handling ─────────────────────────────────────────────
        // pi sends raw key data here. We route it to the right handler.
        function handleInput(data: string) {
            if (editingQuestion >= 0) {
                input.handleInput(data);
                refresh();
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
                if (allAnswered(questions, answers)) {
                    finish({ answers: buildAnswers(questions, answers) });
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
                    beginEditing(tab, answers[tab][0] ?? "");
                    return;
                }
                if (isCancel(data)) {
                    finish(null);
                }
                return;
            }

            const options = currentOptions(question);
            const focus = optionFocus[tab];

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

            if (question.isMultipleChoice) {
                // Multi-select: Space toggles, Enter advances when done.
                if (matchesKey(data, Key.space)) {
                    const option = options[focus];
                    if (!option.isOther) {
                        toggleMulti(tab, option.label);
                    }
                    return;
                }
                if (isConfirm(data)) {
                    const option = options[focus];
                    if (option.isOther) {
                        beginEditing(tab, "");
                        return;
                    }
                    if (isAnswered(answers, tab)) {
                        advance();
                    }
                    return;
                }
            } else {
                // Single select: Enter picks it and moves on.
                if (isConfirm(data)) {
                    const option = options[focus];
                    if (option.isOther) {
                        beginEditing(tab, "");
                        return;
                    }
                    saveAnswer(tab, [option.label]);
                    advance();
                    return;
                }
            }

            if (isCancel(data)) {
                finish(null);
            }
        }

        // ─── Rendering ──────────────────────────────────────────────────
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
                const answered = isAnswered(answers, i);
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
            const submitLabel = allAnswered(questions, answers)
                ? "✓ Review"
                : "Review";
            tabs.push(
                submitActive
                    ? theme.bg(
                          "selectedBg",
                          theme.fg("text", ` ${submitLabel} `),
                      )
                    : theme.fg(
                          allAnswered(questions, answers) ? "success" : "dim",
                          ` ${submitLabel} `,
                      ),
            );
            addWrappedWithPrefix(" ", tabs.join(" "));
            lines.push("");

            // Show the active tab's body.
            if (tab === questions.length) {
                renderReview(addWrapped, addWrappedWithPrefix);
            } else {
                renderQuestion(
                    tab,
                    renderWidth,
                    addWrapped,
                    addWrappedWithPrefix,
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
            width: number,
            add: (text: string) => void,
            addWithPrefix: (prefix: string, text: string) => void,
        ) {
            const question = questions[questionIndex];
            const isEditingQuestion = editingQuestion === questionIndex;
            addWithPrefix(" ", theme.fg("text", question.questionText));
            add("");

            // Free-form question: show the text input.
            if (question.options.length === 0) {
                if (isEditingQuestion) {
                    addWithPrefix(" ", theme.fg("muted", "Your answer:"));
                    for (const line of input.render(Math.max(1, width - 2))) {
                        addWithPrefix(" ", theme.fg("text", line));
                    }
                    add("");
                    addWithPrefix(
                        " ",
                        theme.fg("dim", "Enter to submit • Esc to cancel"),
                    );
                } else {
                    const saved = answers[questionIndex][0];
                    if (saved) {
                        addWithPrefix(" ", theme.fg("text", saved));
                        addWithPrefix(
                            " ",
                            theme.fg(
                                "dim",
                                "Enter to edit • Tab/←→ tabs • Esc cancel",
                            ),
                        );
                    } else {
                        addWithPrefix(
                            " ",
                            theme.fg("muted", "Free text answer"),
                        );
                        addWithPrefix(
                            " ",
                            theme.fg(
                                "dim",
                                "Enter to type • Tab/←→ tabs • Esc cancel",
                            ),
                        );
                    }
                }
                return;
            }

            // Choice question: list options with markers.
            const options = currentOptions(question);
            const focus = optionFocus[questionIndex];
            const selected = new Set(answers[questionIndex]);

            options.forEach((option, index) => {
                const focused = index === focus;
                const isOther = option.isOther === true;
                const isSelected = !isOther && selected.has(option.label);
                const marker = question.isMultipleChoice
                    ? isOther
                        ? " "
                        : isSelected
                          ? theme.fg("success", "[x]")
                          : "[ ]"
                    : focused
                      ? theme.fg("accent", ">")
                      : " ";
                const prefix = ` ${marker} `;
                const recommendedMark = option.recommended
                    ? " [recommended]"
                    : "";
                const label = `${index + 1}. ${option.label}${recommendedMark}${isOther && isEditingQuestion ? " ✎" : ""}`;
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

            // Show any saved free-form answers that don't match an option.
            const optionLabels = new Set(options.map((o) => o.label));
            const customValues = answers[questionIndex].filter(
                (value) => !optionLabels.has(value),
            );
            for (const value of customValues) {
                add("");
                addWithPrefix(" ", theme.fg("text", `✎ ${value}`));
            }

            // If typing a custom "other" answer, show the input line.
            if (isEditingQuestion) {
                add("");
                addWithPrefix(" ", theme.fg("muted", "Your answer:"));
                for (const line of input.render(Math.max(1, width - 2))) {
                    addWithPrefix(" ", theme.fg("text", line));
                }
            }

            add("");
            const help = question.isMultipleChoice
                ? "Space toggle • Enter next • Tab/←→ tabs • Esc cancel"
                : "↑↓ select • Enter choose • Tab/←→ tabs • Esc cancel";
            addWithPrefix(" ", theme.fg("dim", help));
        }

        // Render the review tab: summary + submit. Not selectable.
        function renderReview(
            add: (text: string) => void,
            addWithPrefix: (prefix: string, text: string) => void,
        ) {
            addWithPrefix(" ", theme.fg("accent", theme.bold("Review")));
            add("");

            questions.forEach((question, index) => {
                const values =
                    answers[index].join(", ") ||
                    theme.fg("warning", "unanswered");
                addWithPrefix(
                    " ",
                    theme.fg("muted", `${question.header}: `) +
                        theme.fg("text", values),
                );
            });

            add("");
            const submitText = allAnswered(questions, answers)
                ? theme.fg("success", "> Submit")
                : theme.fg(
                      "warning",
                      `Unanswered: ${questions
                          .filter((_, i) => !isAnswered(answers, i))
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
