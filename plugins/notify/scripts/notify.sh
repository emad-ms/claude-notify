#!/usr/bin/env bash
# notify.sh — "Claude is done / awaiting input" sound.
# Cross-platform: macOS (afplay), Linux (paplay/aplay/play/canberra-gtk-play), terminal bell fallback.
# Always exits 0 so a missing audio tool never reports a hook failure to Claude Code.

play_macos() {
  afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
}

play_linux() {
  local sound
  for candidate in \
    /usr/share/sounds/freedesktop/stereo/complete.oga \
    /usr/share/sounds/freedesktop/stereo/message.oga \
    /usr/share/sounds/alsa/Front_Center.wav; do
    if [ -f "$candidate" ]; then sound="$candidate"; break; fi
  done

  if command -v paplay >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    paplay "$sound" >/dev/null 2>&1 &
  elif command -v aplay >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    aplay -q "$sound" >/dev/null 2>&1 &
  elif command -v canberra-gtk-play >/dev/null 2>&1; then
    canberra-gtk-play -i complete >/dev/null 2>&1 &
  elif command -v play >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    play -q "$sound" >/dev/null 2>&1 &
  else
    printf '\a'
  fi
}

case "$(uname -s 2>/dev/null || echo unknown)" in
  Darwin) play_macos ;;
  Linux*|FreeBSD*|*BSD*) play_linux ;;
  *) printf '\a' ;;  # Git-Bash on Windows falls here — terminal bell as last resort
esac

exit 0
