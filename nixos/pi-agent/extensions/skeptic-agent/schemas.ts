/**
 * ask_user — schemas.
 *
 * Schemas describe what the LLM is allowed to pass to this tool. pi uses them
 * to (a) validate the call and (b) tell the model what arguments exist.
 *
 * The schema mirrors the UI data model on purpose: each question is just an
 * `isMultipleChoice` boolean + `options` array. `options: []` = free-text
 * answer. Choice questions always get an extra free-form row in the UI.
 *
 * Learn Typebox: https://github.com/sinclairzx81/typebox
 * - `Type.Object({...})` = a JSON object
 * - `Type.Optional(...)` = the field may be omitted
 * - `Type.Boolean(...)`  = true/false
 */

import { Type, type Static } from "typebox";

// One option in a choice question.
export const OptionSchema = Type.Object({
    label: Type.String({
        description: "Short display label",
        maxLength: 100,
    }),
    description: Type.Optional(
        Type.String({
            description: "Explanation of this choice",
            maxLength: 300,
        }),
    ),
    recommended: Type.Optional(
        Type.Boolean({
            description:
                "true if this is the option the model recommends the user choose",
        }),
    ),
});

// A single question. It mirrors UiQuestion in index.ts.
export const QuestionSchema = Type.Object({
    question: Type.String({
        description: "Complete question to ask",
        maxLength: 1000,
        minLength: 1,
    }),
    header: Type.String({
        description: "Very short label",
        maxLength: 30,
    }),
    // true = multiple choice, false = single choice. Irrelevant when
    // `options` is empty (free-text question).
    isMultipleChoice: Type.Boolean({
        description: "true = multiple choice, false = single choice",
    }),
    // choices; an empty array means the user types a free-form answer.
    options: Type.Array(OptionSchema, {
        description: "Available choices; empty = free-text answer",
    }),
});

// The top-level shape the LLM sends: `{ questions: [...] }`.
export const AskUserParamsSchema = Type.Object({
    questions: Type.Array(QuestionSchema, {
        description: "Questions to ask",
        minItems: 1,
        maxItems: 10,
    }),
});

// TypeScript types derived from the schemas.
export type AskUserParams = Static<typeof AskUserParamsSchema>;
export type Option = Static<typeof OptionSchema>;
