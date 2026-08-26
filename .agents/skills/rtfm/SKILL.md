---
name: rtfm
description: Consult documentation, manuals, specifications, and source code to find the correct APIs, interfaces, and configurations instead of guessing. Use whenever the agent is unsure about a library or tool's exact API, a config key, a signature, or behavior across versions, or when the user says RTFM, read the docs/manual/spec, check the source, or look it up.
compatibility: Requires curl, htmlq, git, and network access for fetching docs and source.
---

# RTFM

## When to Use

Activate when: using an API, CLI, configurations, or schema you are not 100% sure about; behavior changed between versions; you hit an error you cannot explain; you need an exact signature, option name, or field. Do not rely on training memory or guess — look it up.

## General Procedure

1. Identify the tool/library and the **installed version** (e.g. `pip show`, `npm ls`, `nix flake show`, `--version`)
2. Pick a source below and read the exact signature, option, or schema
3. Confirm the answer matches the _installed_ version, not latest online

## Options

### Nix

When looking for nix related options use : https://searchix.ovh/?query={QUERY}, replace the query value with what you are looking for.

```bash
# to find list of options
curl --url 'https://searchix.ovh/?query=some+keywords'  | htmlq "tbody tr"

# to check for pagination
curl --url 'https://searchix.ovh/?query=some+keywords'  | htmlq "[aria-label='pagination'] a"
```

grep through the list, use htmlq again to navigate options

### Git Repos

When given a git repo, do a shallow clone into a temporary directory, and look for docs / README.

### CLIs / TUIs

When looking for how to use a CLI / TUI use either its man pages or help option

### Sources

- https://github.com/noctalia-dev/noctalia-docs
- https://github.com/ghostty-org/website
- https://github.com/hyprwm/hyprland-wiki
- https://github.com/neovim/neovim.github.io/
- https://github.com/starship/starship
- https://github.com/alexpasmantier/television
- https://wiki.nixos.org/wiki/NixOS_Wiki
- https://wiki.archlinux.org/title/Main_page
- https://github.com/agentskills/agentskills
- https://github.com/NixOS/nix.dev
- https://github.com/noctalia-dev/community-plugins

### Other

Curl the website / use search engines if available.

## Gotchas

- **Training memory is stale**: APIs change between versions. Always confirm against the installed version's docs/source, not your recollection or latest online docs.
- **Latest online docs ≠ installed version**: a package may be behind (or ahead of) upstream docs. Check the pinned version first.
- **Source code is ground truth**: when docs are ambiguous, read the installed package's source for the exact signature/schema.
- When dealing with websites / repos sometimes we get blocked / rate limited - mention it in your output and don't abuse the servers.
- When no source available / couldn't figure out the correct APIs / references, mention it in the response.
