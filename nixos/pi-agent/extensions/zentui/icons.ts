export type IconMode = "auto" | "nerd" | "ascii";

export type IconGlyphs = {
	mode: IconMode;
	package: string;
};

export type ResolvedIcons = IconGlyphs;

export function resolveConfiguredIcons(
	mode: IconMode,
	overrides: Partial<IconGlyphs> = {},
): ResolvedIcons {
	const basePackage = mode === "ascii" ? "pkg" : "\uf487";
	return { mode, package: overrides.package ?? basePackage };
}
