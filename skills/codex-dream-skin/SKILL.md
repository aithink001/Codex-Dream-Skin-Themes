---
name: codex-dream-skin
description: Install, customize, launch, hot-switch, pause, inspect, verify, package, repair, recover, update, or restore a real reversible skin for the official Codex Desktop app on macOS or Windows. Use when a user asks to apply a Codex Dream Skin, turn a local or CDN image into a Codex theme, manage saved themes or the macOS menu bar controller, prove that a skin actually works, reapply it after a Codex update, troubleshoot CDP injection, recover appearance configuration, build a distributable theme package, or return Codex to its official appearance.
---

# Codex Dream Skin

Apply a real renderer skin to the official Codex Desktop app. Keep Codex's native sidebar, project selector, cards, task content, menus, keyboard focus, and composer interactive. Never treat a showcase screenshot as an installed theme.

## Non-negotiable rules

- Run the bundled platform wrapper. It downloads the pinned runtime source and verifies its exact Git commit before invoking it.
- Never modify `Codex.app`, `app.asar`, `WindowsApps`, an official code signature, accounts, chats, projects, API keys, model providers, or unrelated settings.
- Ask for explicit authorization before restarting a running Codex window. Use `start-authorized` or `restore-authorized` only after that authorization; unsaved input may be lost.
- Use an HTTPS image URL or a user-selected local image. Never use a full-interface showcase screenshot as a background.
- Keep decorative layers non-interactive and reject any result that hides or replaces native controls.
- Report success only after Verify passes. Downloading an image, installing files, or starting an injector is not proof of success.
- Warn that loopback CDP is powerful and has no same-user authentication. Advise the user not to run untrusted local software while the skin is active.

## Select the platform

- macOS: run `scripts/dream-skin-macos.sh`.
- Windows: run `scripts/dream-skin-windows.ps1` with Windows PowerShell.
- Linux: stop; the runtime does not support Linux.

Resolve script paths relative to this `SKILL.md`. Do not assume the current working directory is the skill folder.

## macOS capabilities

### Preflight and install

```bash
# Download and validate the pinned runtime without changing Codex.
bash scripts/dream-skin-macos.sh source

# Validate official app identity, Team ID, architecture, signed bundled Node 20+, config, and payload.
bash scripts/dream-skin-macos.sh doctor

# Close Codex first. Installs launchers but does not launch Codex.
bash scripts/dream-skin-macos.sh install

# Optional custom port or no Desktop launchers.
bash scripts/dream-skin-macos.sh install --port 9341 --no-launchers
```

The installer backs up and changes only `appearanceTheme` and `appearanceDarkCodeThemeId`. It installs the engine under `~/.codex/codex-dream-skin-studio` and mutable state under `~/Library/Application Support/CodexDreamSkinStudio`.

### Create or reset a theme

```bash
# Native Finder picker; prepares without applying.
bash scripts/dream-skin-macos.sh customize

# Local image with full theme metadata and colors.
bash scripts/dream-skin-macos.sh customize-file "/absolute/banner.png" \
  --name "My Skin" --tagline "My tagline" --quote "MAKE SOMETHING WONDERFUL" \
  --accent "#7cff46" --secondary "#36d7e8" --highlight "#642a8c"

# HTTPS CDN image with the same metadata controls.
bash scripts/dream-skin-macos.sh customize-url "https://cdn.example.com/banner.png" --name "My Skin"

# Return to the bundled abstract demo, without applying yet.
bash scripts/dream-skin-macos.sh reset-demo
```

Accept PNG, JPEG, HEIC, TIFF, or WebP. Reject source files over 50 MB and prepared files over 16 MB. Recommend width of at least 2000 px and a visually quiet left side.

### Theme and image library

```bash
# Add an image as a saved theme without applying it.
bash scripts/dream-skin-macos.sh library-add-file "/absolute/banner.png" --name "Saved Skin"
bash scripts/dream-skin-macos.sh library-add-url "https://cdn.example.com/banner.png" --name "Saved Skin"

# Inspect saved IDs, select without applying, or safely switch and apply.
bash scripts/dream-skin-macos.sh list-themes
bash scripts/dream-skin-macos.sh select-theme "THEME_ID"
bash scripts/dream-skin-macos.sh switch-theme "THEME_ID"
```

`switch-theme` uses live reapplication when the verified CDP session exists. Otherwise it invokes the safe start path and displays native restart confirmation.

### Start, status, pause, and menu bar

```bash
# Reuses the saved port or scans from 9341; prompts before any restart.
bash scripts/dream-skin-macos.sh start

# Optional custom port or foreground injector for diagnosis.
bash scripts/dream-skin-macos.sh start --port 9350
bash scripts/dream-skin-macos.sh start --foreground-injector

# Use only after explicit restart authorization.
bash scripts/dream-skin-macos.sh start-authorized --port 9350

# Fast state, machine-readable state, or deeper CDP probe.
bash scripts/dream-skin-macos.sh status
bash scripts/dream-skin-macos.sh status --json --deep

# Soft-off: remove live CSS/DOM and stop the injector without restoring base settings.
bash scripts/dream-skin-macos.sh pause
```

Optional SwiftBar controller:

```bash
# If SwiftBar already exists, avoid package installation.
bash scripts/dream-skin-macos.sh menubar-install --no-brew

# Without --no-brew, obtain approval before allowing Homebrew to install SwiftBar.
bash scripts/dream-skin-macos.sh menubar-install

# Native-confirmed menu-controller apply path.
bash scripts/dream-skin-macos.sh menubar-apply
```

The menu shows live status, current theme, apply, pause, image picker, saved-theme switching, the image drop folder, and full restore.

### Verify, restore, uninstall, and package

```bash
# Verify current DOM/CSS and optionally capture proof.
bash scripts/dream-skin-macos.sh verify --screenshot "/absolute/proof.png"

# Reload the renderer, wait for reinjection, and verify resilience.
bash scripts/dream-skin-macos.sh verify --reload --screenshot "/absolute/reload-proof.png"

# Soft removal plus selective base appearance restore.
bash scripts/dream-skin-macos.sh restore

# Use restart only after explicit authorization; add --uninstall to remove Desktop launchers.
bash scripts/dream-skin-macos.sh restore --restart-codex --uninstall

# Regression suite and distributable ZIP builders with SHA-256 output.
bash scripts/dream-skin-macos.sh test
bash scripts/dream-skin-macos.sh build-client-release "/absolute/Codex Theme Editor.zip"
bash scripts/dream-skin-macos.sh build-release
```

## Windows capabilities

Require the official Microsoft Store `OpenAI.Codex` package and Node.js 22+. The runtime dynamically discovers the current Appx package, validates Store identity, serializes operations with a per-user lock, and preserves strict UTF-8 `config.toml` bytes.

```powershell
# Download and validate the pinned source.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action source

# Close Codex first. Create shortcuts, or skip them.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action install
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action install -NoShortcuts

# Start with native restart confirmation; optionally choose port/profile or foreground diagnosis.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start -Port 9335
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start -ProfilePath "C:\path\profile" -ForegroundInjector

# Use only after explicit restart authorization.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start-authorized

# Verify and capture proof.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action verify -ScreenshotPath "C:\absolute\proof.png"

# Selectively restore saved appearance and prompt before closing Codex.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore

# Restore without reopening Codex.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore -NoRelaunch

# Use only after explicit authorization to close Codex without another prompt.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore-authorized

# Exact byte-for-byte recovery of the pre-install config. Explain that the current config is archived first.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action recover-config

# Remove shortcuts and restore appearance, or run all regression tests.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action uninstall
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action test
```

The pinned Windows runtime provides its bundled decorative theme. Do not promise arbitrary-image Windows customization until that runtime adds it and live verification passes.

## Verification acceptance

Require both automated verification and visual inspection of any proof screenshot.

- Home: visible independent banner, live native heading, two to four native suggestion cards, real project selector, native composer, native sidebar, no horizontal overflow.
- Task: selected background remains decorative; messages, approvals, attachments, menus, and composer stay readable and clickable.
- Decoration: `pointer-events: none`; no rasterized fake native controls.
- Resilience: `verify --reload` on macOS or a manual Windows reload check shows reinjection.
- Safety: verified loopback target and process identity; official signature/package unchanged.
- Rollback: Restore removes injection, closes the saved CDP session when restarted, and preserves unrelated configuration.

After Verify, report the OS, pinned runtime commit, live verification result, proof path, native sidebar/composer result, reload result when tested, and exact Restore command. Codex updates may change renderer selectors; rerun install, launch, and Verify after every update.
