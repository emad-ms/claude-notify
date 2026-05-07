# permission.ps1 — Windows native. Plays "Exclamation" sound for permission prompts.
# Distinct from notify.ps1's "Asterisk" so the two events sound different.
if ($IsMacOS -or $IsLinux) { exit 0 }

try {
  [System.Media.SystemSounds]::Exclamation.Play()
} catch {
  [Console]::Beep(440, 120)
  Start-Sleep -Milliseconds 80
  [Console]::Beep(660, 120)
}

exit 0
