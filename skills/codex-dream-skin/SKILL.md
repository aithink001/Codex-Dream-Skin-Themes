---
name: codex-dream-skin
description: Install, customize, launch, hot-switch, pause, inspect, verify, package, repair, recover, update, or restore a real reversible skin for the official Codex Desktop app on macOS or Windows. Use when a user asks to apply a Codex Dream Skin, turn a local or CDN image into a Codex theme, manage saved themes or the macOS menu bar controller, prove that a skin actually works, reapply it after a Codex update, troubleshoot CDP injection, recover appearance configuration, build a distributable theme package, or return Codex to its official appearance.
---

# Codex Dream Skin

Apply a real renderer skin to the official Codex Desktop app while keeping the native sidebar, project selector, cards, task content, menus, keyboard focus, and composer interactive.

## Safety guarantees

- The platform wrapper downloads a pinned runtime and verifies its exact Git commit before use.
- Official `Codex.app`, `app.asar`, `WindowsApps`, signatures, accounts, chats, projects, API keys, and model providers remain unchanged.
- Restart confirmation appears before a running Codex window is closed. Unsaved input may be lost after confirmation.
- Custom themes use an HTTPS image URL or a local image selected by the user. Full-interface showcase screenshots are visual references, not theme backgrounds.
- Decorative layers do not receive pointer events, so native controls remain clickable.
- A theme is considered active only after Verify passes.
- CDP listens on loopback only. Because local processes under the same user can still access it, use Restore when the themed session is no longer needed.

## Select the platform

- macOS: run `scripts/dream-skin-macos.sh`.
- Windows: run `scripts/dream-skin-windows.ps1` with Windows PowerShell.
- Linux: not supported.

The commands below use paths relative to this Skill folder.

## macOS capabilities

### Preflight and install

```bash
# Download and validate the pinned runtime without changing Codex.
bash scripts/dream-skin-macos.sh source

# Initialize a safe default theme on first use, then validate app identity, runtime, config, and payload.
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

# Return to the bundled Midnight Aurora preset, without applying yet.
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

# Non-interactive restart after the restart has already been confirmed.
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

# Without --no-brew, Homebrew may install SwiftBar after confirmation.
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

# Restart Codex and remove Desktop launchers after confirmation.
bash scripts/dream-skin-macos.sh restore --restart-codex --uninstall

# Regression suite and distributable ZIP builders with SHA-256 output.
bash scripts/dream-skin-macos.sh test
bash scripts/dream-skin-macos.sh build-client-release "/absolute/Codex Theme Editor.zip"
bash scripts/dream-skin-macos.sh build-release
```

## Windows capabilities

Windows requires the official Microsoft Store `OpenAI.Codex` package and Node.js 22+. The runtime dynamically discovers the current Appx package, validates Store identity, serializes operations with a per-user lock, and preserves strict UTF-8 `config.toml` bytes.

```powershell
# Download and validate the pinned source.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action source

# Close Codex first. Create shortcuts, or skip them.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action install
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action install -NoShortcuts

# Open the system-tray controller for image picking, saving/switching themes, pause, and restore.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action tray

# Start with native restart confirmation; optionally choose port/profile or foreground diagnosis.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start -Port 9335
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start -ProfilePath "C:\path\profile" -ForegroundInjector

# Non-interactive restart after the restart has already been confirmed.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start-authorized

# Verify and capture proof.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action verify -ScreenshotPath "C:\absolute\proof.png"

# Selectively restore saved appearance and prompt before closing Codex.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore

# Restore without reopening Codex.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore -NoRelaunch

# Close and restore without another prompt after the action has already been confirmed.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore-authorized

# Exact byte-for-byte recovery of the pre-install config; the current config is archived first.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action recover-config

# Remove shortcuts and restore appearance, or run all regression tests.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action uninstall
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action test
```

The Windows installer initializes a bundled theme and starts its system-tray controller unless `-NoShortcuts` is used. From the tray, the user can choose a local PNG, JPEG, or WebP background, save the current theme, switch saved themes, pause or resume the skin, reapply it, and fully restore Codex. Images must be no larger than 16 MB and must pass dimension and metadata validation.

## Verification

Verify checks the live renderer and can save a proof screenshot for visual inspection.

- Home: visible independent banner, live native heading, two to four native suggestion cards, real project selector, native composer, native sidebar, no horizontal overflow.
- Task: selected background remains decorative; messages, approvals, attachments, menus, and composer stay readable and clickable.
- Decoration: `pointer-events: none`; no rasterized fake native controls.
- Resilience: `verify --reload` on macOS or a manual Windows reload check shows reinjection.
- Safety: verified loopback target and process identity; official signature/package unchanged.
- Rollback: Restore removes injection, closes the saved CDP session when restarted, and preserves unrelated configuration.

The result includes the operating system, pinned runtime commit, live verification status, proof path, native sidebar/composer status, reload result when tested, and the Restore command. Codex updates may change renderer selectors, so rerun install, launch, and Verify after every update.
