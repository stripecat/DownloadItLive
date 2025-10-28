## Quick summary

This repository is a small PowerShell utility named `DownloadItLive` that periodically downloads news files (MP3) and places them where PlayIt Live (PIL) can use them. The codebase is a single script and a small runtime layout created next to the script: `PublicFiles/`, `Logs/`, `Temporary/`, and `ChangeFile/`.

## What an AI coding agent should know up-front

- Primary entry point: `DownloadItLive.ps1` — all logic lives in this PowerShell script.
- Config is mostly top-of-file variables: `InitialDirectory` (derived from current working dir), `NewsURLs`, `Destination_dir`, `LogDir`, `Temp_dir`, `ReportFileChange`, `MoveSeparateFiles`, and `ChangeFile`.
- Side-effect files/dirs created at runtime: `PublicFiles/` (downloaded files), `Logs/Log.txt`, `Temporary/`, and `ChangeFile/LatestChange.txt`.

## Typical developer workflows & commands

- Run interactively on Windows (PowerShell Core or Windows PowerShell):

  pwsh -NoProfile -ExecutionPolicy Bypass -File .\DownloadItLive.ps1

- For automation the author recommends a Scheduled Task that runs hourly (script suggests running every hour 5 minutes before broadcast). Ensure the scheduled task runs under an account with write access to the script folder.

## Important runtime / behavioural details (do not change without reason)

- The script uses `Invoke-WebRequest -OutFile` to download URLs. Each `NewsURL` must resolve to a direct downloadable file (no 302 redirects or HTML pages).
- `MoveSeparateFiles` controls whether files are moved individually (1) or only if all are successfully downloaded (0). Tests, logs and callers may depend on this behaviour.
- `ReportFileChange` toggles logging of changed files; when a change is detected the script writes a short timestamp to `ChangeFile/LatestChange.txt`.
- The script computes file equality via `Get-FileHash` and logs messages to `Logs/Log.txt` via `Logwrite()`.

## Patterns & conventions to follow in edits

- Keep modifications PowerShell-native (no extra frameworks). Prefer existing functions: `Test-Hash`, `Copy-Files`, `Logwrite` and the existing error handling pattern.
- Logging is appended to `Logs/Log.txt`; keep messages human-readable and preserve existing log prefixes (`[CHANGE]`, `[WARNING]`, `[ERROR]`).
- Avoid adding network dependencies or external packages. If adding tests or helpers, keep them as separate PS scripts or include a `tests/` folder and document how to run them.

## Files to inspect when making changes

- `DownloadItLive.ps1` — the entire application logic and the place to update behavior.
- `README.md` — contains install and operational guidance (mirrors script expectations).
- `ChangeFile/LatestChange.txt` — used by the script to store the latest change timestamp and can be referenced by monitoring tooling.

## Safety & deployment notes

- The author suggests using a local webserver and `Remote URL` in PlayIt Live as an alternative; if implementing that workflow, ensure the server listens only on `127.0.0.1` and serve static files only.
- When changing download logic, preserve current behaviour for partial failure vs. all-or-nothing copying controlled by `MoveSeparateFiles`.

## When unsure, ask about

- Intended scheduling/frequency in the target environment (the README suggests an hourly scheduled task).
- Whether the `NewsURLs` list should be made configurable (file, registry, or environment).

---
If you want, I can adapt this into a short `AGENT.md` too, or add quick-run unit tests for the hashing/copy logic. Any areas you want me to expand or clarify?
