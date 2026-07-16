---
name: codex-dream-skin
description: Install, customize, launch, verify, troubleshoot, or restore a real reversible skin for the official Codex Desktop app on macOS or Windows. Use when a user asks to apply a Codex Dream Skin, use a generated banner in Codex, check whether a skin actually works, reapply it after an update, capture proof of the live result, or return Codex to its official appearance.
---

# Codex Dream Skin

Apply a real renderer skin to the official Codex Desktop app. Keep Codex's native sidebar, project selector, cards, task content, and composer interactive. Never treat a showcase screenshot as an installed theme.

## Rules

- Run the bundled platform wrapper. It downloads and verifies the pinned runtime source before invoking it.
- Never modify `Codex.app`, `app.asar`, `WindowsApps`, or an official code signature.
- Ask for explicit authorization before restarting a running Codex window; unsaved input may be lost.
- Use only an HTTPS image URL or a user-selected local image. Never use a full-interface showcase screenshot as the background.
- Report success only after the runtime verifier passes. If verification fails, report the failure and offer Restore.
- Warn that the loopback CDP debugging session is powerful and unauthenticated to other local processes. Advise the user not to run untrusted local software while the skin is active.
- Do not change API keys, model providers, accounts, chats, projects, or unrelated Codex settings.

## Choose the platform

Check the operating system first.

- macOS: use `scripts/dream-skin-macos.sh`.
- Windows: use `scripts/dream-skin-windows.ps1`.
- Linux: stop. Codex Dream Skin is not supported.

Resolve all script paths relative to this `SKILL.md` file. Do not assume the current working directory is the skill directory.

## macOS workflow

Use the following sequence:

```bash
# Download and validate the pinned source without changing Codex
bash scripts/dream-skin-macos.sh source

# Validate Codex, its signed bundled runtime, and the theme payload
bash scripts/dream-skin-macos.sh doctor

# Close Codex first. Install without launching or restarting it.
bash scripts/dream-skin-macos.sh install

# Apply a generated banner URL to the installed engine without restarting Codex.
bash scripts/dream-skin-macos.sh customize-url "https://cdn.example.com/banner.png" \
  --name "My Dream Skin" --accent "#7cff46" --secondary "#36d7e8" --highlight "#642a8c"

# This displays a native confirmation if Codex must restart.
bash scripts/dream-skin-macos.sh start

# Verify live DOM markers and optionally save proof.
bash scripts/dream-skin-macos.sh verify --screenshot "/absolute/path/codex-dream-skin-proof.png"
```

For a local image selected by the user, run the installed customizer:

```bash
bash scripts/dream-skin-macos.sh customize-file "/absolute/path/banner.png" --name "My Dream Skin"
```

Restore the official appearance:

```bash
# Removes the live skin and restores the saved base appearance.
bash scripts/dream-skin-macos.sh restore

# Use only after the user explicitly approves closing and reopening Codex.
bash scripts/dream-skin-macos.sh restore --restart-codex
```

Treat nonzero exit status, missing native UI markers, or a failed screenshot inspection as failure. A downloaded image is not proof that it was applied.

## Windows workflow

Use Windows PowerShell:

```powershell
# Download and validate the pinned source without changing Codex.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action source

# Close Codex first, then install the reversible base theme and shortcuts.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action install

# Displays a native confirmation if Codex must restart.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action start

# Verify the live renderer and save proof.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action verify -ScreenshotPath "C:\Users\me\Desktop\codex-dream-skin-proof.png"

# Restores saved appearance and asks before closing an open Codex window.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\dream-skin-windows.ps1 -Action restore
```

The pinned Windows runtime currently provides its bundled theme and safe rollback. Do not promise arbitrary image customization on Windows until that runtime adds it and verification passes.

## Verification report

After Verify, state:

- operating system;
- runtime commit;
- whether live injection verification passed;
- proof screenshot path, if produced;
- whether the native sidebar and composer remained present;
- how to run Restore.

Do not claim visual parity with showcase artwork. Codex updates can change renderer selectors; rerun Verify after every Codex update.
