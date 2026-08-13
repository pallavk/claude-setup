# Agent Instructions

This file serves Codex and other AGENTS.md-compatible agents. Claude Code reads
CLAUDE.md, which contains the full tool and alias reference for this repo — read it too.

## Skills

Portable skills live in `skills/<name>/SKILL.md` (standard skill format: YAML
frontmatter with `name` and `description`, then instructions):

- `skills/email-triage/` — sweep and label the Gmail inbox, draft (never send) replies
- `skills/add-tool/` — add/remove a CLI tool consistently across all four platform installers, alias files, and docs
- `skills/weekly-review/` — end-of-week recap from calendar, email, and git, plus next-week priorities

When the user's request matches a skill's description, open its SKILL.md and follow it.

To install these skills into your agent's global skills directory on a machine, run
`scripts/install-skills.sh` (symlinks into `~/.claude/skills` and `~/.codex/skills`
when those agents are present), or use `npx skills@latest add ./skills/<name>` from a
checkout.

## Repo conventions

- Any tool or alias change must follow `skills/add-tool/SKILL.md` — all installers and
  docs stay in sync.
- Shell scripts must pass `bash -n` before committing.
