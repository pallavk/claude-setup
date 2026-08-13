# Email / Google Workspace Setup

How to give your agents (Claude Code and Codex) access to Gmail, Google Calendar, and
Drive — across your primary and work accounts — in every place you run them.

There are two access paths, and which one works depends on where the agent runs:

| Where you're running | Access path | Multi-account |
|----------------------|-------------|---------------|
| Claude on the web (claude.ai, Claude Code on the web, mobile) | claude.ai Google connectors | One Google login per connector |
| Claude Code local (WSL, macOS, hetz) | `gog` CLI | Yes — aliases per account |
| Codex local | `gog` CLI | Yes — aliases per account |
| Codex web/cloud | `gog` CLI in the environment (needs OAuth token bootstrap) | Yes, once authed |

The `skills/email-triage/` and `skills/weekly-review/` skills prefer `gog` and fall
back to the claude.ai connectors automatically, so the same skill works everywhere.

---

## Path 1: claude.ai connectors (Claude web sessions)

Web and mobile Claude sessions can't reach your local keyring, so they use the hosted
Google connectors instead.

1. Go to **claude.ai → Settings → Connectors**.
2. Connect **Gmail**, **Google Calendar**, and **Google Drive**, signing in with the
   account you want (usually primary).
3. In any chat/session, make sure the connectors are toggled on for that conversation.

Limitations:
- One Google identity per connector — to triage the work account from the web you'd
  sign the connector into the work account instead, or run triage locally with `gog`.
- Connectors are account-level: they follow your claude.ai login to every device,
  nothing to set up per machine.

## Path 2: gog CLI (local machines — Claude Code and Codex)

`gog` is a Google Workspace CLI (Gmail, Calendar, Drive, Contacts, …) with native
multi-account support. Both Claude Code and Codex just shell out to it, so one setup
serves both agents.

### Install

Run this repo's installer for your platform (`scripts/install-*.sh` — they now include
gog), or manually:

```bash
brew install openclaw/tap/gogcli                          # macOS / Linux with brew
go install github.com/openclaw/gogcli/cmd/gog@latest      # anywhere with Go
```

### One-time OAuth client (do once, reuse on every machine)

1. In [Google Cloud Console](https://console.cloud.google.com/), create (or reuse) a
   project → **APIs & Services → Credentials → Create credentials → OAuth client ID →
   Desktop app**.
2. Enable the Gmail, Calendar, and Drive APIs on the project.
3. Download the client JSON. Keep it somewhere private (NOT in this repo).

### Per-machine account setup

```bash
gog auth credentials set ~/Downloads/client_secret_*.json

# Primary account (becomes the default → plain `gog`)
gog auth add you@gmail.com --services gmail,calendar,drive

# Work account, with a friendly alias
gog auth add you@company.com --services gmail,calendar,drive
gog auth alias set work you@company.com

gog auth list --check    # verify both accounts
```

Tokens are stored in the OS keyring, so the browser-based auth dance is repeated once
per machine; the conventions (`work` alias, shell aliases) travel via this repo.

### Daily use

```bash
gog gmail search 'is:unread'                  # primary
gog --account work gmail search 'is:unread'   # work
gog-work gmail search 'is:unread'             # same, via shell alias from this repo
export GOG_ACCOUNT=you@company.com            # flip the default for this shell
```

Shell aliases from `aliases/bash_aliases_claude` / `aliases/powershell_aliases.ps1`:
`gog-work`, `inbox`, `inbox-work`.

### Headless machines (hetz)

On a server with no browser, run the `gog auth add` flow once from a machine with a
browser and the same OAuth client, then copy the token store — or use gog's manual/
device auth if your version supports it (`gog auth add --help`). If the keyring is
unavailable over SSH, check `gog auth --help` for file-based token storage options.

## Agent wiring

### Claude Code (local)

Nothing extra: Claude Code discovers `skills/` via `CLAUDE.md` (or the symlinks from
`scripts/install-skills.sh` into `~/.claude/skills`) and runs `gog` through Bash.
Approve/allowlist `gog` commands on first use. To pre-approve read-only triage, add to
`.claude/settings.json` permissions: `Bash(gog gmail search:*)`, `Bash(gog gmail thread:*)`,
`Bash(gog auth list:*)`.

### Claude on the web / Claude Code on the web

Web sessions have no keyring, so `gog` can't auth there — the skills fall back to the
claude.ai Gmail/Calendar connectors (Path 1). Make sure those are connected.

### Codex (local)

Codex reads `AGENTS.md` in this repo, which points it at `skills/`. Install the skills
globally with `scripts/install-skills.sh` (symlinks into `~/.codex/skills`) or
`npx skills@latest add ./skills/<name>`. Codex then runs the same `gog` commands.

### Codex web/cloud

Codex cloud environments can install gog (Go is available) but have no keyring or
browser. Either skip email tasks there, or provision auth explicitly in the
environment setup (e.g. restore a file-based token store from a secret) — treat this
as advanced and optional.

## Sanity checklist

- [ ] `gog auth list --check` shows primary + work on each local machine
- [ ] `gog-work gmail search 'is:unread'` returns work mail
- [ ] claude.ai connectors (Gmail/Calendar/Drive) connected for web sessions
- [ ] `/email-triage` runs and creates drafts in the right account (never sends)
