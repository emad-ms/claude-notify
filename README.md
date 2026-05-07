# claude-notify

A tiny Claude Code plugin that plays a sound when Claude is doing something you might want to know about. Three events, two distinct sounds:

| Event | Sound (macOS) | When |
| --- | --- | --- |
| `Stop` | Glass | Claude finishes responding |
| `Notification` | Glass | Claude is awaiting input / sends a notification |
| `PermissionRequest` | Funk | Claude is **about to ask** for permission to run a tool |

Works on **macOS**, **Linux**, **WSL**, and **Windows with Git Bash** (almost every dev setup). See [Windows native](#windows-native) below if you don't have any of those.

## Install

Open a Claude Code session in your terminal. Type the **first** command and press Enter, wait for the success message, then type the **second** and press Enter:

```
/plugin marketplace add https://github.com/emad-ms/claude-notify.git
```

```
/plugin install notify@claude-notify
```

That's it. New Claude Code sessions will play the sounds. You don't need to install anything else, set up SSH keys, or know any git.

> **Important:** run the two commands one at a time — don't paste both at once. The first one needs to finish before the second runs.

> If you already have `Stop` / `Notification` / `PermissionRequest` hooks in your own `~/.claude/settings.json`, both will fire (you'll hear the sound twice). Remove your local entries to dedupe — see [Removing legacy local hooks](#removing-legacy-local-hooks) below.

### Engineer shortcut (optional)

If you have GitHub SSH set up and prefer the shorter form:

```
/plugin marketplace add emad-ms/claude-notify
```

This requires GitHub's SSH host key to be in your `~/.ssh/known_hosts`. If you've ever cloned a private GitHub repo over SSH on this machine, you're already set. If not, the HTTPS URL above is the safer pick.

## Update

```
/plugin update notify@claude-notify
```

## Disable / Uninstall

```
/plugin disable notify@claude-notify     # keep installed but silent
/plugin uninstall notify@claude-notify   # remove entirely
```

## Customize the sounds

The plugin lives at `~/.claude/plugins/cache/claude-notify/plugins/notify/scripts/`. Edit:

- `notify.sh` — change `Glass.aiff` to any other file under `/System/Library/Sounds/` (macOS) or any sound file path on Linux.
- `permission.sh` — change `Funk.aiff` similarly.

macOS sounds available: Glass, Funk, Hero, Ping, Pop, Tink, Sosumi, Submarine, Bottle, Frog, Blow, Morse, Purr, Basso.

> Edits to the cache directory are overwritten on `/plugin update`. For permanent changes, fork this repo and point `/plugin marketplace add` at your fork.

## Cross-platform notes

- **macOS** — uses `afplay` with built-in system sounds. No setup.
- **Linux / WSL** — tries `paplay` (PulseAudio), then `aplay` (ALSA), then `canberra-gtk-play`, then `play` (sox). Falls back to terminal bell (`\a`) if none are present. On most desktop distros, at least one is preinstalled.
- **Windows with Git Bash** — runs the bash script through Git Bash and falls back to terminal bell. Most devs already have Git Bash installed alongside `git`.

### Windows native

The plugin's hooks run through bash. If you don't have **WSL** or **Git Bash** installed, install one of them — Git Bash is the easier path (it ships with [Git for Windows](https://git-scm.com/download/win)). After installing, restart Claude Code and the plugin will start playing sounds.

> Why bash-only? The previous version of the plugin shipped a PowerShell fallback, but Claude Code fails the hook at config-load if PowerShell isn't on PATH (instead of silently skipping). Bash through Git Bash / WSL is universal enough that this is the simpler, less buggy path.

## Removing legacy local hooks

If you previously wired up Stop/Notification/PermissionRequest hooks directly in `~/.claude/settings.json`, remove those entries so you don't hear duplicate sounds. The relevant block looks like:

```json
"hooks": {
  "Stop":              [ { "hooks": [ { "type": "command", "command": "bash /Users/.../notify.sh" } ] } ],
  "Notification":      [ { "hooks": [ { "type": "command", "command": "bash /Users/.../notify.sh" } ] } ],
  "PermissionRequest": [ { "hooks": [ { "type": "command", "command": "bash /Users/.../permission.sh" } ] } ]
}
```

Delete those three keys and the local `notify.sh` / `permission.sh` files in `~/.claude/`. The plugin is now the single source of truth.

## How it works under the hood

This repo is a single-plugin Claude Code marketplace.

- `.claude-plugin/marketplace.json` — marketplace manifest, lists the one plugin.
- `plugins/notify/.claude-plugin/plugin.json` — plugin manifest.
- `plugins/notify/hooks/hooks.json` — declares hooks for `Stop`, `Notification`, and `PermissionRequest`. Each event has both a `bash` and a `powershell` command; whichever shell runs on your platform plays the right sound. Hooks are registered as `async: true` so they never block Claude Code.
- `plugins/notify/scripts/` — the actual sound-playing scripts.
