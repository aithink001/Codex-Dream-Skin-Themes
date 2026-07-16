#!/bin/bash

set -euo pipefail

UPSTREAM_REPOSITORY="https://github.com/Fei-Away/Codex-Dream-Skin.git"
UPSTREAM_COMMIT="26c6c410e0e0bfc053356474620e17f934f483fc"
CACHE_PARENT="${CODEX_DREAM_SKIN_CACHE_DIR:-${HOME}/Library/Caches/CodexDreamSkinSkill}"
SOURCE_ROOT="${CACHE_PARENT}/source-${UPSTREAM_COMMIT}"

fail() {
  printf 'Codex Dream Skin Skill: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: dream-skin-macos.sh <command> [arguments]

Commands:
  source                         Download and validate the pinned runtime source
  doctor [--require-live]        Validate Codex, runtime, payload, and optional live session
  install                        Install without launching Codex
  customize-url URL [options]    Download an HTTPS banner and prepare it without restarting Codex
  customize-file PATH [options]  Prepare a local banner without restarting Codex
  start                          Start or reapply; prompts before restarting a running Codex
  verify [options]               Verify live injection; supports --screenshot ABSOLUTE_PATH
  restore [options]              Remove the skin and restore base appearance
  test                           Run the pinned runtime's static regression suite

The runtime is pinned to commit 26c6c410e0e0bfc053356474620e17f934f483fc.
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
}

installed_script() {
  local name="$1"
  local path="${HOME}/.codex/codex-dream-skin-studio/scripts/${name}"
  [ -x "$path" ] || fail "Dream Skin is not installed. Run the install command first."
  printf '%s\n' "$path"
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

require_macos
[ "$#" -gt 0 ] || { usage; exit 2; }
command_name="$1"
shift

case "$command_name" in
  source)
    [ "$#" -eq 0 ] || fail "The source command takes no arguments."
    ensure_source
    printf 'Pinned Codex Dream Skin runtime ready: %s\n' "$UPSTREAM_COMMIT"
    ;;
  doctor)
    ensure_source
    exec "$SOURCE_ROOT/macos/scripts/doctor-macos.sh" "$@"
    ;;
  install)
    [ "$#" -eq 0 ] || fail "The install command takes no arguments."
    ensure_source
    exec "$SOURCE_ROOT/macos/scripts/install-dream-skin-macos.sh" --no-launch
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
  start)
    [ "$#" -eq 0 ] || fail "The start command takes no arguments."
    starter="$(installed_script start-dream-skin-macos.sh)"
    exec "$starter" --prompt-restart
    ;;
  verify)
    verifier="$(installed_script verify-dream-skin-macos.sh)"
    exec "$verifier" "$@"
    ;;
  restore)
    restorer="$(installed_script restore-dream-skin-macos.sh)"
    exec "$restorer" --restore-base-theme "$@"
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
