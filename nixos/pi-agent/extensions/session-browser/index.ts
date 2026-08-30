/**
 * session-browser — `/browse-sessions`: browse all pi sessions as searchable HTML.
 *
 * Scans every project's session files under `<agentDir>/sessions` (recursively,
 * `*.jsonl`), exports each to HTML in-process (same code pi's `/export`
 * uses), mtime-cached: only changed sessions are re-exported. Writes an
 * `index.html` with a fuzzy search box and opens it in the browser.
 *
 * Output: `<agentDir>/export/index.html` + one `.html` per session.
 * Export theme follows the configured theme, like `/export`.
 *
 * No dependencies, no server: pure static files. Clicking a session in the
 * index opens its pre-exported HTML page.
 */

// ponytail: `exportSessionToHtml` is not on the public package surface
// (only via AgentSession). Deep import of the internal module; if pi
// exports it publicly, swap away these two lines.
import { spawn } from "node:child_process";
import { existsSync, readFileSync, createReadStream } from "node:fs";
import { mkdir, readdir, readFile, stat, writeFile } from "node:fs/promises";
import { createInterface } from "node:readline";
import { basename, join } from "node:path";

import {
    getAgentDir,
    getPackageDir,
    type ExtensionAPI,
    SessionManager,
} from "@earendil-works/pi-coding-agent";

type ExportSessionToHtml = (
    sm: SessionManager,
    state: unknown,
    options: { outputPath: string; themeName?: string },
) => Promise<string>;
let exportSessionToHtml: ExportSessionToHtml | undefined;

const INDEX_TEMPLATE = readFileSync(join(__dirname, "index.html"), "utf8");
// __dirname is injected by pi's jiti loader (import.meta.url is a data URL).
declare const __dirname: string;

/**
 * Theme from settings.json (`theme` key). Auto pairs like "light/dark" are
 * already resolved by the running pi terminal detection — pass nothing and
 * the export falls back to the active theme via currentThemeName.
 * Invalid/unfindable names → undefined → active theme.
 */
async function getConfiguredTheme(): Promise<string | undefined> {
    try {
        const settings = (await readFile(
            join(getAgentDir(), "settings.json"),
            "utf8",
        )) as string;
        const theme = (
            JSON.parse(settings) as { theme?: string }
        ).theme?.trim();
        if (!theme || theme.includes("/")) return undefined;
        if (theme === "dark" || theme === "light") return theme;
        return existsSync(join(getAgentDir(), "themes", `${theme}.json`))
            ? theme
            : undefined;
    } catch {
        return undefined;
    }
}

async function getExportSessionToHtml(): Promise<ExportSessionToHtml> {
    if (!exportSessionToHtml) {
        const mod = (await import(
            join(getPackageDir(), "dist/core/export-html/index.js")
        )) as { exportSessionToHtml?: unknown };
        exportSessionToHtml = mod.exportSessionToHtml as ExportSessionToHtml;
        if (!exportSessionToHtml) {
            throw new Error(
                "export module layout changed — update session-browser",
            );
        }
    }
    return exportSessionToHtml;
}

const OPENERS: Partial<Record<NodeJS.Platform, string>> = {
    darwin: "open",
    linux: "xdg-open",
    win32: "start",
};

interface SessionInfo {
    /** html file name relative to the export dir */
    file: string;
    name: string;
    project: string;
    date: string;
}

export default function initExtension(pi: ExtensionAPI) {
    pi.registerCommand("browse-sessions", {
        description: "Browse all sessions as searchable HTML in the browser",
        handler: async (_args, ctx) => {
            const agentDir = getAgentDir();
            const sessionsDir = join(agentDir, "sessions");
            const exportDir = join(agentDir, "export");
            await mkdir(exportDir, { recursive: true });

            let jsonlFiles: string[];
            try {
                jsonlFiles = await scanJsonl(sessionsDir);
            } catch {
                if (ctx.hasUI)
                    ctx.ui.notify(`No sessions dir: ${sessionsDir}`, "error");
                else console.error(`No sessions dir: ${sessionsDir}`);
                return;
            }
            if (jsonlFiles.length === 0) {
                if (ctx.hasUI) ctx.ui.notify("No sessions found", "error");
                else console.log("No sessions found");
                return;
            }

            const sessions: SessionInfo[] = [];
            for (const jsonl of jsonlFiles) {
                const htmlName = `${basename(jsonl, ".jsonl")}.html`;
                const html = join(exportDir, htmlName);
                try {
                    const [jsonlStat, htmlStat] = await Promise.all([
                        stat(jsonl),
                        stat(html).catch(() => undefined),
                    ]);
                    if (!htmlStat || htmlStat.mtimeMs < jsonlStat.mtimeMs) {
                        await exportSession(jsonl, html);
                    }
                } catch (err) {
                    // Continue with other sessions; skip this one if it can't export.
                    if (ctx.hasUI)
                        ctx.ui.notify(
                            `Export failed for ${basename(jsonl)}: ${err}`,
                            "error",
                        );
                    else
                        console.error(
                            `Export failed for ${basename(jsonl)}: ${err}`,
                        );
                    continue;
                }
                sessions.push(await readSession(jsonl, htmlName));
            }

            sessions.sort((a, b) =>
                a.date < b.date ? 1 : a.date > b.date ? -1 : 0,
            );
            const indexPath = join(exportDir, "index.html");
            await writeFile(
                indexPath,
                buildIndex(
                    sessions,
                    (await getConfiguredTheme()) === "light" ? "light" : "dark",
                ),
            );
            openBrowser(indexPath);

            if (ctx.hasUI)
                ctx.ui.notify(`Sessions index: ${indexPath}`, "info");
            else console.log(`Sessions index: ${indexPath}`);
        },
    });
}

async function scanJsonl(dir: string): Promise<string[]> {
    const out: string[] = [];
    for (const entry of await readdir(dir, { withFileTypes: true })) {
        const p = join(dir, entry.name);
        if (entry.isDirectory()) out.push(...(await scanJsonl(p)));
        else if (entry.isFile() && entry.name.endsWith(".jsonl")) out.push(p);
    }
    return out;
}

/**
 * Export one session in-process, same code path as `/export`.
 * Theme: resolves via the running pi's configured theme (currentThemeName).
 */
async function exportSession(jsonl: string, html: string): Promise<void> {
    const fn = await getExportSessionToHtml();
    await fn(SessionManager.open(jsonl), undefined, {
        outputPath: html,
        themeName: await getConfiguredTheme(),
    });
}

/**
 * Read header (cwd, timestamp) + latest `session_info` name from the jsonl.
 * Only parses lines that could be those entries — message lines are huge.
 */
async function readSession(
    file: string,
    htmlName: string,
): Promise<SessionInfo> {
    const info: SessionInfo = {
        file: htmlName,
        name: "",
        project: "",
        date: "",
    };
    const rl = createInterface({
        input: createReadStream(file),
        crlfDelay: Infinity,
    });
    for await (const line of rl) {
        if (!line.startsWith('{"type":"session')) continue;
        try {
            const entry = JSON.parse(line) as {
                type?: string;
                cwd?: string;
                timestamp?: string;
                name?: string;
            };
            if (entry.type === "session") {
                info.project = entry.cwd ?? "";
                info.date = entry.timestamp ?? "";
            } else if (
                entry.type === "session_info" &&
                entry.name !== undefined
            ) {
                info.name = entry.name.trim();
            }
        } catch {
            // malformed line — ignore
        }
    }
    const mtime = await stat(file).catch(() => undefined);
    if (!info.date) info.date = mtime?.mtime.toISOString() ?? htmlName;
    return info;
}

function buildIndex(sessions: SessionInfo[], theme: "light" | "dark"): string {
    // Escape `<` so user data can't break out of the JSON script block.
    const data = JSON.stringify(sessions).replace(/</g, "\\u003c");
    return INDEX_TEMPLATE.replace("__DATA__", data).replace("__THEME__", theme);
}

function openBrowser(path: string): void {
    const opener = OPENERS[process.platform];
    if (!opener) return;
    const child = spawn(opener, [path], { detached: true, stdio: "ignore" });
    child.unref();
}
