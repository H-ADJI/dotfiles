/**
 * ask_user — schemas.
 *
 * Schemas describe what the LLM is allowed to pass to this tool. pi uses them
 * to (a) validate the call and (b) tell the model what arguments exist.
 *
 * Learn Typebox: https://github.com/sinclairzx81/typebox
 * - `Type.Object({...})`  = a JSON object
 * - `Type.Optional(...)`  = the field may be omitted
 * - `Type.Literal(...)`   = an exact string value (used as a discriminator)
 * - `Type.Unsafe(...)`    = write a raw JSON Schema keyword
 */

import { Type, type Static } from "typebox";

// One option in a choice question.
export const OptionSchema = Type.Object({
    label: Type.String({ description: "Short display label" }),
    description: Type.Optional(
        Type.String({ description: "Explanation of this choice" }),
    ),
});

// Fields shared by every question type.
const ChoiceBase = {
    header: Type.String({
        description: "Very short question label",
        maxLength: 30,
    }),
    question: Type.String({ description: "Complete question to ask" }),
    custom: Type.Optional(
        Type.Boolean({
            description: "Allow a free-form custom answer",
        }),
    ),
};

// Each question is ONE of: single choice, multiple choice, or free text.
// A `type` literal discriminates the variants so `oneOf` matches exactly one.
export const SingleChoiceSchema = Type.Object({
    ...ChoiceBase,
    type: Type.Literal("single", { description: "Pick one of the options" }),
    options: Type.Array(OptionSchema, {
        description: "Available choices",
        minItems: 2,
    }),
});

export const MultipleChoiceSchema = Type.Object({
    ...ChoiceBase,
    type: Type.Literal("multiple", { description: "Pick any of the options" }),
    options: Type.Array(OptionSchema, {
        description: "Available choices",
        minItems: 2,
    }),
});

export const FreeTextSchema = Type.Object({
    ...ChoiceBase,
    type: Type.Literal("text", { description: "Free-form answer" }),
});

// TypeScript types derived from the schemas above.
export type SingleChoiceQuestion = Static<typeof SingleChoiceSchema>;
export type MultipleChoiceQuestion = Static<typeof MultipleChoiceSchema>;
export type FreeTextQuestion = Static<typeof FreeTextSchema>;
export type Question =
    | SingleChoiceQuestion
    | MultipleChoiceQuestion
    | FreeTextQuestion;
export type Option = Static<typeof OptionSchema>;

const QuestionSchema = Type.Union([
    SingleChoiceSchema,
    MultipleChoiceSchema,
    FreeTextSchema,
]);

// The top-level shape the LLM sends: `{ questions: [...] }`.
export const AskUserParamsSchema = Type.Object({
    questions: Type.Array(QuestionSchema, {
        description: "Questions to ask",
        minItems: 1,
        maxItems: 10,
    }),
});

// `Static<typeof ...>` turns a Typebox schema back into a TypeScript type.
export type AskUserParams = Static<typeof AskUserParamsSchema>;
