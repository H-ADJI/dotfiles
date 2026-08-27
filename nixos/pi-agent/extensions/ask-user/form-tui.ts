/**
 * ask_user — interactive TUI form.
 *
 * This file only draws the form and handles keyboard input. It has no tool
 * registration and no schemas; those live in index.ts and schemas.ts.
 *
 * The form is a `ctx.ui.custom()` component:
 *   render()        -> return lines of text to draw
 *   handleInput()   -> receive key presses
 *   done(value)     -> close the form and resolve the promise
 *
 * Learn the API:
 * - https://pi.dev/docs/latest/tui
 * - https://pi.dev/docs/latest/extensions
 */

import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import {
    CURSOR_MARKER,
    Key,
    matchesKey,
    parseKey,
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
    multiple: boolean;
    custom: boolean;
}

export interface Answer {
    header: string;
    question: string;
    values: string[];
}

export interface UiResult {
    answers: Answer[];
    cancelled: boolean;
}

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
export function runForm(
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
        // make circulare using modulo
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
                options.push({
                    label: OTHER_LABEL,
                    isOther: true,
                    recommended: false,
                });
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
                question: question.questionText,
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
            addWithPrefix(" ", theme.fg("text", question.questionText));
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
