#!/bin/bash

set -euo pipefail

UPSTREAM_REPOSITORY="https://github.com/Fei-Away/Codex-Dream-Skin.git"
UPSTREAM_COMMIT="a1c48b3a84cc64532196e624fdf33ee1277cb018"
CACHE_PARENT="${CODEX_DREAM_SKIN_CACHE_DIR:-${HOME}/Library/Caches/CodexDreamSkinSkill}"
SOURCE_ROOT="${CACHE_PARENT}/source-${UPSTREAM_COMMIT}"
WRAPPER_PATH="$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")"
WORLD_CUP_PROFILE_SCRIPT="$(cd "$(dirname "$0")" && pwd -P)/set-world-cup-profile.mjs"
WORLD_CUP_THEME_URL="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/themes/world-cup-victory-night.png"
WORLD_CUP_STATE_ROOT="${HOME}/Library/Application Support/CodexDreamSkinStudio"
WORLD_CUP_RESULT_PATH="${WORLD_CUP_STATE_ROOT}/world-cup-install-result.txt"
WORLD_CUP_LOG_PATH="${WORLD_CUP_STATE_ROOT}/world-cup-install.log"
WORLD_CUP_ERROR_LOG_PATH="${WORLD_CUP_STATE_ROOT}/world-cup-install-error.log"

fail() {
  printf 'Codex Dream Skin Skill: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: dream-skin-macos.sh <command> [arguments]

Commands:
  world-cup                     One-click install, apply, and verify the World Cup theme
  world-cup-status              Read the one-click installation result without restarting
  source                         Download and validate the pinned runtime source
  doctor [--require-live]        Validate Codex, runtime, payload, and optional live session
  install [options]              Install without launching; supports --port/--no-launchers
  customize [options]            Open the native image picker and prepare a theme
  customize-url URL [options]    Download an HTTPS banner and prepare it without restarting Codex
  customize-file PATH [options]  Prepare a local banner without restarting Codex
  reset-demo                     Select the bundled Midnight Aurora preset without applying it
  library-add-url URL [options]  Add an HTTPS image as a saved theme without applying it
  library-add-file PATH [opts]   Add a local image as a saved theme without applying it
  list-themes                    List saved theme IDs and names
  select-theme ID                Select a saved theme without applying it
  switch-theme ID                Select and safely apply a saved theme
  status [--short|--json|--deep] Read the current session, port, process, and theme state
  start [options]                Start or reapply; prompts before restarting a running Codex
  start-authorized [options]     Restart without prompting; requires prior explicit authorization
  pause [--port PORT]            Remove the live skin but keep base appearance settings
  verify [options]               Verify live injection; supports --screenshot ABSOLUTE_PATH
  restore [options]              Remove the skin and restore base appearance
  menubar-install [--no-brew]    Install the optional SwiftBar menu controller
  menubar-apply                  Apply from the menu controller with native confirmation
  build-client-release [PATH]    Build a customer ZIP and print its SHA-256
  build-release [--skip-tests]   Build the complete runtime release ZIP
  test                           Run the pinned runtime's static regression suite

The runtime is pinned to commit a1c48b3a84cc64532196e624fdf33ee1277cb018.
EOF
}

require_macos() {
  [ "$(/usr/bin/uname -s)" = "Darwin" ] || fail "This wrapper supports macOS only."
}

ensure_source() {
  require_macos
  command -v git >/dev/null 2>&1 || fail "git is required to download the pinned runtime."
  /bin/mkdir -p "$CACHE_PARENT"

  if [ ! -e "$SOURCE_ROOT" ]; then
    git clone --filter=blob:none --no-checkout "$UPSTREAM_REPOSITORY" "$SOURCE_ROOT"
  fi
  [ -d "$SOURCE_ROOT/.git" ] || fail "Cache path exists but is not a Git repository: $SOURCE_ROOT"

  origin="$(git -C "$SOURCE_ROOT" remote get-url origin)"
  [ "$origin" = "$UPSTREAM_REPOSITORY" ] || fail "Cached runtime has an unexpected origin: $origin"
  if ! git -C "$SOURCE_ROOT" cat-file -e "${UPSTREAM_COMMIT}^{commit}" 2>/dev/null; then
    git -C "$SOURCE_ROOT" fetch --depth 1 origin "$UPSTREAM_COMMIT"
  fi
  git -C "$SOURCE_ROOT" checkout --quiet --detach "$UPSTREAM_COMMIT"
  actual="$(git -C "$SOURCE_ROOT" rev-parse HEAD)"
  [ "$actual" = "$UPSTREAM_COMMIT" ] || fail "Runtime commit verification failed: $actual"

  installer="$SOURCE_ROOT/macos/scripts/install-dream-skin-macos.sh"
  default_theme="$SOURCE_ROOT/macos/presets/preset-midnight-aurora/theme.json"
  [ -s "$default_theme" ] || fail "Pinned runtime is missing its default theme: $default_theme"
  /usr/bin/grep -Fq 'seed_bundled_presets' "$installer" \
    || fail "Pinned runtime is missing first-install theme initialization."
  /usr/bin/grep -Fq 'switch-theme-macos.sh" --id preset-midnight-aurora' "$installer" \
    || fail "Pinned runtime is missing its first-install default theme selection."
}

ensure_default_theme() {
  (
    . "$SOURCE_ROOT/macos/scripts/common-macos.sh"
    discover_codex_app
    require_macos_runtime
    ensure_state_root
    seed_bundled_presets
    if [ ! -f "$THEME_DIR/theme.json" ]; then
      "$SCRIPT_DIR/switch-theme-macos.sh" --id preset-midnight-aurora --no-apply >/dev/null
    fi
  )
}

installed_script() {
  local name="$1"
  local path="${HOME}/.codex/codex-dream-skin-studio/scripts/${name}"
  [ -x "$path" ] || fail "Dream Skin is not installed. Run the install command first."
  printf '%s\n' "$path"
}

reject_argument() {
  local forbidden="$1"
  shift
  local argument
  for argument in "$@"; do
    [ "$argument" != "$forbidden" ] || fail "Argument $forbidden is not allowed for this command. Use the explicit authorized command after user approval."
  done
}

run_safe_start() {
  reject_argument --restart-existing "$@"
  local starter
  starter="$(installed_script start-dream-skin-macos.sh)"
  exec "$starter" --prompt-restart "$@"
}

download_https_image() {
  local url="$1"
  local output="$2"
  case "$url" in
    https://*) ;;
    *) fail "Only HTTPS image URLs are accepted." ;;
  esac
  command -v curl >/dev/null 2>&1 || fail "curl is required to download a banner URL."
  curl --fail --location --silent --show-error \
    --proto '=https' --proto-redir '=https' \
    --connect-timeout 15 --max-time 120 \
    --output "$output" "$url"
  [ -s "$output" ] || fail "The downloaded banner is empty."
  bytes="$(/usr/bin/stat -f '%z' "$output")"
  [ "$bytes" -le 52428800 ] || fail "The downloaded banner exceeds 50 MB."
}

write_world_cup_result() {
  local status="$1"
  local detail="$2"
  local screenshot="${3:-}"
  local temporary
  /bin/mkdir -p "$WORLD_CUP_STATE_ROOT"
  /bin/chmod 700 "$WORLD_CUP_STATE_ROOT"
  temporary="${WORLD_CUP_RESULT_PATH}.tmp.$$"
  /usr/bin/printf '%s\n' \
    "status=${status}" \
    'theme=World Cup Victory Night' \
    "detail=${detail}" \
    "screenshot=${screenshot}" \
    > "$temporary"
  /bin/chmod 600 "$temporary"
  /bin/mv -f "$temporary" "$WORLD_CUP_RESULT_PATH"
}

launch_world_cup_helper() {
  ensure_source
  (
    . "$SOURCE_ROOT/macos/scripts/common-macos.sh"
    discover_codex_app
    require_macos_runtime
    ensure_state_root
    : > "$WORLD_CUP_LOG_PATH"
    : > "$WORLD_CUP_ERROR_LOG_PATH"
    /bin/chmod 600 "$WORLD_CUP_LOG_PATH" "$WORLD_CUP_ERROR_LOG_PATH"
    "$NODE" -e '
      const fs = require("node:fs");
      const { spawn } = require("node:child_process");
      const [stdoutPath, stderrPath, wrapper] = process.argv.slice(1);
      const stdout = fs.openSync(stdoutPath, "a");
      const stderr = fs.openSync(stderrPath, "a");
      const child = spawn("/bin/bash", [wrapper, "__world-cup-helper"], {
        detached: true,
        env: process.env,
        stdio: ["ignore", stdout, stderr],
      });
      fs.closeSync(stdout);
      fs.closeSync(stderr);
      child.unref();
      process.stdout.write(String(child.pid));
    ' "$WORLD_CUP_LOG_PATH" "$WORLD_CUP_ERROR_LOG_PATH" "$WRAPPER_PATH"
  )
}

run_world_cup_helper() {
  local temporary_image=""
  local screenshot_path="${HOME}/Desktop/World Cup Victory Night - Verify.png"
  local install_script customizer starter verifier

  write_world_cup_result running '正在自动安装和应用，请勿手动重新打开 Codex。'
  world_cup_failed() {
    local exit_code="$1"
    local line="$2"
    [ -z "$temporary_image" ] || /bin/rm -f "$temporary_image"
    write_world_cup_result failed "安装在第 ${line} 行失败（退出码 ${exit_code}），请读取 world-cup-install-error.log。"
  }
  trap 'exit_code=$?; world_cup_failed "$exit_code" "$LINENO"' ERR

  ensure_source
  (
    . "$SOURCE_ROOT/macos/scripts/common-macos.sh"
    discover_codex_app
    require_macos_runtime
    ensure_state_root
    stop_codex true
  )

  install_script="$SOURCE_ROOT/macos/scripts/install-dream-skin-macos.sh"
  "$install_script" --no-launch

  temporary_image="$(/usr/bin/mktemp "${TMPDIR:-/tmp}/codex-world-cup.XXXXXX")"
  download_https_image "$WORLD_CUP_THEME_URL" "$temporary_image"
  customizer="$(installed_script customize-theme-macos.sh)"
  "$customizer" --image "$temporary_image" --no-apply \
    --name 'World Cup Victory Night' \
    --tagline '冠军之夜，为热爱全力以赴。' \
    --quote 'PLAY BOLD. BUILD BOLDER.' \
    --accent '#d7aa42' --secondary '#0b8f62' --highlight '#f6d77a'
  (
    . "$SOURCE_ROOT/macos/scripts/common-macos.sh"
    ensure_state_root
    "$NODE" "$WORLD_CUP_PROFILE_SCRIPT" "$THEME_DIR/theme.json"
  )
  /bin/rm -f "$temporary_image"
  temporary_image=""

  starter="$(installed_script start-dream-skin-macos.sh)"
  "$starter"
  verifier="$(installed_script verify-dream-skin-macos.sh)"
  "$verifier" --screenshot "$screenshot_path"
  write_world_cup_result success '主题已安装、应用并通过 Verify。' "$screenshot_path"
  trap - ERR
}

require_macos
[ "$#" -gt 0 ] || { usage; exit 2; }
command_name="$1"
shift

case "$command_name" in
  world-cup)
    [ "$#" -eq 0 ] || fail "The world-cup command takes no arguments."
    /usr/bin/osascript <<'APPLESCRIPT' >/dev/null
display dialog "将自动关闭并重新打开 Codex 一次，然后安装、应用并验证世界杯主题。整个过程无需手动操作。" buttons {"取消", "安装世界杯主题"} default button "安装世界杯主题" cancel button "取消" with title "Codex Dream Skin"
APPLESCRIPT
    write_world_cup_result pending '等待后台接管。'
    helper_pid="$(launch_world_cup_helper)"
    case "$helper_pid" in ''|*[!0-9]*) fail "Could not start the one-click theme helper." ;; esac
    printf '世界杯主题已开始自动安装。Codex 将只重启一次，请不要手动关闭或重新打开。\n'
    ;;
  world-cup-status)
    [ "$#" -eq 0 ] || fail "The world-cup-status command takes no arguments."
    if [ -f "$WORLD_CUP_RESULT_PATH" ]; then
      /bin/cat "$WORLD_CUP_RESULT_PATH"
    else
      printf 'status=not-started\n'
    fi
    status_script="${HOME}/.codex/codex-dream-skin-studio/scripts/status-dream-skin-macos.sh"
    if [ -x "$status_script" ]; then
      "$status_script" --json --deep || true
    fi
    ;;
  __world-cup-helper)
    [ "$#" -eq 0 ] || fail "The internal world-cup helper takes no arguments."
    /bin/sleep 2
    run_world_cup_helper
    ;;
  source)
    [ "$#" -eq 0 ] || fail "The source command takes no arguments."
    ensure_source
    printf 'Pinned Codex Dream Skin runtime ready: %s\n' "$UPSTREAM_COMMIT"
    ;;
  doctor)
    ensure_source
    ensure_default_theme
    exec "$SOURCE_ROOT/macos/scripts/doctor-macos.sh" "$@"
    ;;
  install)
    reject_argument --in-place "$@"
    ensure_source
    exec "$SOURCE_ROOT/macos/scripts/install-dream-skin-macos.sh" --no-launch "$@"
    ;;
  customize)
    customizer="$(installed_script customize-theme-macos.sh)"
    exec "$customizer" --no-apply "$@"
    ;;
  customize-url)
    [ "$#" -gt 0 ] || fail "customize-url requires an HTTPS image URL."
    url="$1"
    shift
    customizer="$(installed_script customize-theme-macos.sh)"
    temporary_image="$(/usr/bin/mktemp "${TMPDIR:-/tmp}/codex-dream-skin.XXXXXX")"
    cleanup_download() { /bin/rm -f "$temporary_image"; }
    trap cleanup_download EXIT INT TERM
    download_https_image "$url" "$temporary_image"
    "$customizer" --image "$temporary_image" --no-apply "$@"
    cleanup_download
    trap - EXIT INT TERM
    printf 'Banner prepared. Run the start command to apply it.\n'
    ;;
  customize-file)
    [ "$#" -gt 0 ] || fail "customize-file requires an image path."
    image_path="$1"
    shift
    [ -f "$image_path" ] || fail "Image does not exist: $image_path"
    customizer="$(installed_script customize-theme-macos.sh)"
    exec "$customizer" --image "$image_path" --no-apply "$@"
    ;;
  reset-demo)
    [ "$#" -eq 0 ] || fail "The reset-demo command takes no arguments."
    selector="$(installed_script switch-theme-macos.sh)"
    exec "$selector" --id preset-midnight-aurora --no-apply
    ;;
  library-add-url)
    [ "$#" -gt 0 ] || fail "library-add-url requires an HTTPS image URL."
    url="$1"
    shift
    loader="$(installed_script load-image-theme-macos.sh)"
    temporary_dir="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/codex-dream-skin-library.XXXXXX")"
    source_image="$temporary_dir/source-image"
    temporary_image="$temporary_dir/banner.jpg"
    cleanup_library_download() {
      /bin/rm -f "$source_image" "$temporary_image"
      /bin/rmdir "$temporary_dir" 2>/dev/null || true
    }
    trap cleanup_library_download EXIT INT TERM
    download_https_image "$url" "$source_image"
    /usr/bin/sips -s format jpeg -s formatOptions 84 -Z 3200 "$source_image" --out "$temporary_image" >/dev/null \
      || fail "macOS could not convert the downloaded image. Use a PNG, JPEG, HEIC, TIFF, or WebP URL."
    [ -s "$temporary_image" ] || fail "The converted banner is empty."
    "$loader" --file "$temporary_image" --no-apply "$@"
    cleanup_library_download
    trap - EXIT INT TERM
    printf 'Theme saved in the image library. Use list-themes and switch-theme to apply it.\n'
    ;;
  library-add-file)
    [ "$#" -gt 0 ] || fail "library-add-file requires an image path."
    image_path="$1"
    shift
    [ -f "$image_path" ] || fail "Image does not exist: $image_path"
    loader="$(installed_script load-image-theme-macos.sh)"
    exec "$loader" --file "$image_path" --no-apply "$@"
    ;;
  list-themes)
    [ "$#" -eq 0 ] || fail "The list-themes command takes no arguments."
    themes_root="${HOME}/Library/Application Support/CodexDreamSkinStudio/themes"
    if [ ! -d "$themes_root" ]; then
      printf 'No saved themes.\n'
      exit 0
    fi
    found="false"
    for theme_dir in "$themes_root"/*; do
      [ -d "$theme_dir" ] || continue
      [ -f "$theme_dir/theme.json" ] || continue
      theme_id="$(/usr/bin/basename "$theme_dir")"
      theme_name="$(/usr/bin/python3 -c 'import json,sys; print(json.load(open(sys.argv[1], encoding="utf-8")).get("name") or sys.argv[2])' "$theme_dir/theme.json" "$theme_id" 2>/dev/null || printf '%s' "$theme_id")"
      printf '%s\t%s\n' "$theme_id" "$theme_name"
      found="true"
    done
    [ "$found" = "true" ] || printf 'No saved themes.\n'
    ;;
  select-theme)
    [ "$#" -eq 1 ] || fail "select-theme requires exactly one theme ID."
    selector="$(installed_script switch-theme-macos.sh)"
    exec "$selector" --id "$1" --no-apply
    ;;
  switch-theme)
    [ "$#" -eq 1 ] || fail "switch-theme requires exactly one theme ID."
    selector="$(installed_script switch-theme-macos.sh)"
    "$selector" --id "$1" --no-apply
    run_safe_start
    ;;
  status)
    status_script="$(installed_script status-dream-skin-macos.sh)"
    exec "$status_script" "$@"
    ;;
  start)
    run_safe_start "$@"
    ;;
  start-authorized)
    starter="$(installed_script start-dream-skin-macos.sh)"
    exec "$starter" --restart-existing "$@"
    ;;
  pause)
    pause_script="$(installed_script pause-dream-skin-macos.sh)"
    exec "$pause_script" "$@"
    ;;
  verify)
    verifier="$(installed_script verify-dream-skin-macos.sh)"
    exec "$verifier" "$@"
    ;;
  restore)
    restorer="$(installed_script restore-dream-skin-macos.sh)"
    exec "$restorer" --restore-base-theme "$@"
    ;;
  menubar-install)
    menubar_installer="$(installed_script install-menubar-macos.sh)"
    exec "$menubar_installer" "$@"
    ;;
  menubar-apply)
    [ "$#" -eq 0 ] || fail "The menubar-apply command takes no arguments."
    menubar_apply="$(installed_script apply-from-menubar-macos.sh)"
    exec "$menubar_apply"
    ;;
  build-client-release)
    ensure_source
    exec "$SOURCE_ROOT/macos/scripts/build-client-release.sh" "$@"
    ;;
  build-release)
    ensure_source
    exec "$SOURCE_ROOT/macos/scripts/build-release.sh" "$@"
    ;;
  test)
    [ "$#" -eq 0 ] || fail "The test command takes no arguments."
    ensure_source
    exec "$SOURCE_ROOT/macos/tests/run-tests.sh"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    fail "Unknown command: $command_name"
    ;;
esac
