---
name: add-tool
description: Add a new CLI tool or alias to this claude-setup repo consistently across every platform. Use when the user asks to add, remove, or update a tool, package, or helper alias in this repository. Keeps all four installers, both alias files, CLAUDE.md, and docs/tools-reference.md in sync.
---

# Add a Tool to claude-setup

This repo installs the same toolbelt on WSL, macOS, Ubuntu, and Windows. Any tool or
alias change must land in every file that mentions tools, or the platforms drift.

## Files that must stay in sync

| File | What to update |
|------|----------------|
| `scripts/install-wsl.sh` | apt/manual install for WSL |
| `scripts/install-ubuntu.sh` | apt install for Ubuntu/Debian |
| `scripts/install-macos.sh` | brew install for macOS |
| `scripts/install-windows.ps1` | winget/choco install for Windows |
| `aliases/bash_aliases_claude` | bash/zsh aliases (if the tool gets a helper) |
| `aliases/powershell_aliases.ps1` | PowerShell equivalents |
| `CLAUDE.md` | tool listing + alias table |
| `docs/tools-reference.md` | detailed usage docs |

## Workflow

1. **Confirm the package name per platform.** The same tool often differs:
   apt `fd-find` (binary `fdfind`), brew `fd`, winget `sharkdp.fd`. Check each
   installer's existing style before adding.
2. **Edit every installer**, following the exact idiom already in that script
   (grouped installs, existence checks, echo formatting). If the tool is unavailable
   on a platform, add an explicit comment saying so rather than silently omitting it.
3. **Add aliases** to both alias files if a helper shortcut is wanted, and register it
   in the `lsclaude` helper listing if one exists.
4. **Update CLAUDE.md** (tool category section + alias table) and
   `docs/tools-reference.md` (usage examples).
5. **Verify:** run `bash -n` on each shell script, and grep the tool name across the
   repo to confirm no file was missed:
   `rg -l '<toolname>' scripts aliases docs CLAUDE.md`
6. **Removal** is the same checklist in reverse — grep first, then delete everywhere.

## Definition of done

`rg '<toolname>'` hits every file in the table above (or a comment explains the
platform gap), and all shell scripts pass syntax check.
