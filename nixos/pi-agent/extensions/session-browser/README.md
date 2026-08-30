# session-browser

`/browse-sessions` — browse all pi sessions (all projects) as static HTML.

What it does:

1. Scans every project's session files under
   `~/.pi/agent/sessions/**/*.jsonl`.
2. Exports each session to HTML in-process (pi's own `/export` code path,
   deep-imported via `getPackageDir()`), mtime-cached: only sessions changed
   since the last run are re-exported.
3. Writes `~/.pi/agent/export/index.html` — one entry per session (display
   name from `/name`, project path, date), fuzzy search by name/project/date,
   light/dark toggle (defaults to the configured pi theme, persisted in
   localStorage). The page is a standalone template at
   `extensions/session-browser/index.html`.
4. Opens the index in the browser; clicking an entry opens that session's
   pre-exported HTML page.

Details:

- Export theme follows `settings.json` `theme` (light/dark/custom),
  read per run; auto pairs like "light/dark" fall back to the active
  theme — same as `/export`.
- No dependencies, no server — pure static files. Re-run
  `/browse-sessions` whenever you want new/updated sessions included.
- Fast: 69 sessions export in under half a second; reruns only touch
  changed sessions (mtime cache).
- Note: `exportSessionToHtml` is not on the public package surface. The
  extension deep-imports `dist/core/export-html/index.js` (path derived
  from public `getPackageDir()`) — if a pi update moves that module the
  command errors loudly, one-line fix.
- Install: the extensions dir is symlinked into pi's config dir by
  `nixos/pi-agent/default.nix` — a new subdirectory appears automatically.
  `/reload` in pi (or restart) to pick it up.