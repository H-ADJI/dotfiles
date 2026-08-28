export type IconMode = "auto" | "nerd" | "ascii";

export type ResolvedIcons = {
	mode: IconMode;
};

export function resolveConfiguredIcons(mode: IconMode): ResolvedIcons {
	return { mode };
}
