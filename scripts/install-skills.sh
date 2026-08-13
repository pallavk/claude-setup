#!/usr/bin/env bash
# Symlink this repo's portable skills into local agent skill directories.
# Works for Claude Code (~/.claude/skills) and Codex (~/.codex/skills).
# Safe to re-run; existing correct symlinks are left alone.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

if [ ! -d "$SKILLS_SRC" ]; then
    echo "No skills/ directory found at $SKILLS_SRC" >&2
    exit 1
fi

link_into() {
    local target_root="$1"
    mkdir -p "$target_root"
    for skill in "$SKILLS_SRC"/*/; do
        [ -f "$skill/SKILL.md" ] || continue
        local name dest
        name="$(basename "$skill")"
        dest="$target_root/$name"
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "${skill%/}" ]; then
            echo "  ok: $dest"
        elif [ -e "$dest" ]; then
            echo "  SKIP (exists, not our symlink): $dest" >&2
        else
            ln -s "${skill%/}" "$dest"
            echo "  linked: $dest"
        fi
    done
}

installed_any=false
for agent_dir in "$HOME/.claude" "$HOME/.codex"; do
    if [ -d "$agent_dir" ]; then
        echo "Installing skills into $agent_dir/skills"
        link_into "$agent_dir/skills"
        installed_any=true
    fi
done

if [ "$installed_any" = false ]; then
    echo "No agent directories found (~/.claude or ~/.codex). Nothing installed." >&2
    echo "Alternatively: npx skills@latest add ./skills/<name>" >&2
    exit 1
fi

echo "Done. Skills also load automatically from the repo via CLAUDE.md / AGENTS.md."

# ── Third-party skills: Matt Pocock's set ────────────────────────────────
# https://github.com/mattpocock/skills — curated picks that match our workflow.
# Installed via the cross-agent `skills` CLI (works for Claude Code, Codex, etc.).
# Skip with: SKIP_THIRD_PARTY=1 scripts/install-skills.sh

MATT_POCOCK_SKILLS=(
    tdd
    diagnosing-bugs
    to-spec
    to-tickets
    implement
    handoff
    research
)

if [ "${SKIP_THIRD_PARTY:-0}" = "1" ]; then
    echo "Skipping third-party skills (SKIP_THIRD_PARTY=1)."
elif command -v npx >/dev/null 2>&1; then
    echo ""
    echo "Installing Matt Pocock skills (${MATT_POCOCK_SKILLS[*]})..."
    for s in "${MATT_POCOCK_SKILLS[@]}"; do
        npx -y skills@latest add "mattpocock/skills/$s" || \
            echo "  WARN: failed to add mattpocock/skills/$s" >&2
    done
    echo "Update later with: npx skills update"
else
    echo "npx not found — skipping Matt Pocock skills." >&2
    echo "Install manually: npx skills@latest add mattpocock/skills" >&2
    echo "Or as a Claude Code plugin: claude plugins install mattpocock-skills" >&2
fi
