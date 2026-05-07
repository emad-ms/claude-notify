#!/usr/bin/env bash
# permission.sh — "About to ask for permission" sound.
# Distinct from notify.sh so you can tell the events apart by ear.

play_macos() {
  afplay /System/Library/Sounds/Funk.aiff >/dev/null 2>&1 &
}

play_linux() {
  local sound
  for candidate in \
    /usr/share/sounds/freedesktop/stereo/dialog-warning.oga \
    /usr/share/sounds/freedesktop/stereo/bell.oga \
    /usr/share/sounds/alsa/Side_Right.wav; do
    if [ -f "$candidate" ]; then sound="$candidate"; break; fi
  done

  if command -v paplay >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    paplay "$sound" >/dev/null 2>&1 &
  elif command -v aplay >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    aplay -q "$sound" >/dev/null 2>&1 &
  elif command -v canberra-gtk-play >/dev/null 2>&1; then
    canberra-gtk-play -i dialog-warning >/dev/null 2>&1 &
  elif command -v play >/dev/null 2>&1 && [ -n "${sound:-}" ]; then
    play -q "$sound" >/dev/null 2>&1 &
  else
    printf '\a\a'  # double bell as fallback so it sounds different from notify.sh
  fi
}

case "$(uname -s 2>/dev/null || echo unknown)" in
  Darwin) play_macos ;;
  Linux*|FreeBSD*|*BSD*) play_linux ;;
  *) printf '\a\a' ;;
esac

exit 0
