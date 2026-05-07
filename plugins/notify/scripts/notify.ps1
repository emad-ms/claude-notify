# notify.ps1 — Windows native (PowerShell). Plays the system "Asterisk" sound for done/awaiting-input.
# On macOS/Linux pwsh installs, exit early — the bash script handles those platforms.
if ($IsMacOS -or $IsLinux) { exit 0 }

try {
  [System.Media.SystemSounds]::Asterisk.Play()
} catch {
  # Last-resort fallback: terminal bell.
  [Console]::Beep(880, 120)
}

exit 0
