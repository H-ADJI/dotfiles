# Pi extension: auto-copy final response to clipboard (NixOS)

After every `agent_settled` event, copy the final assistant response text to the
system clipboard. First feature of a small extension collection; keep it minimal.
Enable/disable via a JSON config file, wired through `default.nix` like
caveman/ponytail.

## Facts from exploration (why the plan looks like this)

- pi exports `copyToClipboard(text): Promise<void>` from
  `@earendil-works/pi-coding-agent` (same helper its built-in `/copy` command
  uses, `dist/utils/clipboard.js`). It handles wl-copy / xclip / pbcopy / OSC 52
  itself. No own clipboard code, no new dependency.
- pi exports `getAgentDir()` — resolves the real agent config dir (`~/.pi/agent`).
- `default.nix` already symlinks the whole `nixos/pi-agent/extensions/` dir into
  pi's config dir, so a new subdirectory is auto-discovered. No nix change
  needed for loading.
- Last assistant text: walk `ctx.sessionManager.getBranch()` backwards, take the
  last message with `role === "assistant"`, join its text parts (same pattern as
  `examples/extensions/qna.ts`).
- `agent_settled` fires once per prompt, after retries/compaction/follow-ups are
  done — exactly "final response sent to user".
- Caveat: caveman's config in `default.nix` is placed via
  `xdg.configFile."pi/agent/caveman.json"` (`~/.config/pi/agent/`), but
  `pi-caveman/extensions/caveman.ts` reads `~/.pi/agent/caveman.json`. Mismatch —
  that config probably never loads. We use the module's `configDir` instead
  (same pattern as `simpleTui.json`), which lands where pi actually reads.

## Steps

### 1. Create `nixos/pi-agent/extensions/clipboard/index.ts`

Single file, dir + `index.ts` structure like `skeptic-agent/` (room for future
features in the same dir).

```ts
import { readFile } from "node:fs/promises";
import { join } from "node:path";
import {
    copyToClipboard,
    getAgentDir,
    type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

interface ClipboardConfig { enabled: boolean }
const DEFAULT_CONFIG: ClipboardConfig = { enabled: true };

async function loadConfig(): Promise<ClipboardConfig> {
    // missing/unreadable/unparseable file → defaults (feature on)
    try {
        const raw = await readFile(join(getAgentDir(), "clipboard.json"), "utf8");
        return { ...DEFAULT_CONFIG, ...JSON.parse(raw) };
    } catch {
        return DEFAULT_CONFIG;
    }
}

export default function initExtension(pi: ExtensionAPI) {
    pi.on("agent_settled", async (_event, ctx) => {
        if (!loadConfig().then(c => c.enabled).catch(() => true)) return; // see note

        const branch = ctx.sessionManager.getBranch();
        let text = "";
        for (let i = branch.length - 1; i >= 0; i--) {
            const msg = branch[i];
            if (msg.role !== "assistant") continue;
            // assistant content: string | block array; keep text blocks only
            text = typeof msg.content === "string"
                ? msg.content
                : (msg.content ?? [])
                    .filter(b => b.type === "text")
                    .map(b => b.text)
                    .join("\n");
            break;
        }
        if (!text) return;
        try {
            await copyToClipboard(text);
            ctx.ui.notify("Response copied to clipboard", "info");
        } catch (err) {
            ctx.ui.notify(`Clipboard copy failed: ${err}`, "error");
        }
    });
}
```

Notes:
- `enabled` check reads the config file fresh on every settle → toggling
  `clipboard.json` takes effect without `/reload`. Final code will
  `await` it properly instead of the `.then` shorthand sketched above.
- Silent no-op when no assistant text (e.g. aborted turn); notify only on
  success/failure of the copy itself.
- Copy full text, no truncation. Thinking blocks / tool calls excluded (text
  blocks of the assistant message only).
- Errors never throw out of the handler — a clipboard failure must not break
  the session.

### 2. Wire enable/disable in `nixos/pi-agent/default.nix`

Add to the existing `home.file` set (same pattern as `simpleTui.json`, so the
file lands in pi's real config dir):

```nix
"${config.programs.pi-coding-agent.configDir}/clipboard.json".text =
  builtins.toJSON { enabled = true; };
```

Flip to `false` to disable the extension without deleting it. (Optional later
cleanup, not this task: caveman's `xdg.configFile."pi/agent/caveman.json"` is
read from the wrong path by the extension — could be moved to this same
`configDir` pattern.)

### 3. Document in `nixos/pi-agent/extensions/clipboard/README.md`

- What it does, `agent_settled` event, `copyToClipboard` from pi.
- Config: `~/.pi/agent/clipboard.json`, `{"enabled": true}` (default when
  missing), read per-settle so no reload needed.
- Manual step: `home-manager switch` / rebuild to refresh the config-dir
  symlinks (extensions dir + clipboard.json). No other manual steps.

### 4. Typecheck + verify

- `tsc --noEmit` in `nixos/pi-agent/` (existing tsconfig setup) → clean.
- User manual: rebuild/switch, run `pi`, send a prompt, paste somewhere →
  final response is in clipboard. Toggle `enabled = false`, rebuild, confirm
  no copy.
