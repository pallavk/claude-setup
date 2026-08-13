# CLAUDE.md

This repository contains CLI tools and configurations for Claude Code environments.

## Available CLI Tools

After running the installer for your platform, these tools are available:

### Image Processing
- `convert` (ImageMagick) - Resize, convert, manipulate images
- `identify` - Get image dimensions and metadata

### PDF Tools
- `pdftotext` - Extract text from PDFs
- `pdftoppm` - Convert PDF pages to images
- `pdfinfo` - Get PDF metadata
- `qpdf` - Split, merge, rotate PDFs

### Document Conversion
- `pandoc` - Universal document converter (MD ↔ DOCX ↔ PDF ↔ HTML)

### Data Processing
- `jq` - JSON processor
- `yq` - YAML processor
- `csvlook`, `csvsql` (csvkit) - CSV manipulation

### File Search
- `rg` (ripgrep) - Fast content search
- `fd` / `fdfind` - Fast file finder
- `bat` / `batcat` - Syntax-highlighted file viewer
- `tree` - Directory structure visualization

### HTTP & APIs
- `http` (httpie) - Friendly HTTP client

### Git & GitHub
- `gh` - GitHub CLI

### Google Workspace
- `gog` - Gmail/Calendar/Drive CLI; multi-account (`gog` = personal, `gog --account work` or `gog-work` = work)
- Full setup guide (web + local, Claude + Codex): `docs/google-workspace-setup.md`

## Helper Aliases

When aliases are installed, these shortcuts are available:

| Alias | Purpose |
|-------|---------|
| `resize50 img` | Resize image to 50% |
| `tojpg img` | Convert to JPG |
| `pdf2img doc.pdf` | PDF pages to JPG images |
| `pdf2txt doc.pdf` | Extract PDF text |
| `md2docx doc.md` | Markdown to Word |
| `jqp` | Pretty print JSON |
| `t` / `t3` | Tree view (2/3 levels) |
| `gog-work` | gog against the work Google account |
| `inbox` / `inbox-work` | Unread inbox peek (personal/work) |
| `lsclaude` | Show all helpers |

### WSL-Specific
| Alias | Purpose |
|-------|---------|
| `ss` | List recent screenshots |
| `lastss_path` | Path to latest screenshot |
| `clip` / `paste` | Windows clipboard |
| `clipfile X` | Copy file to clipboard |

## When to Use These Tools

- **Large images**: Use `resize50` before sharing with Claude
- **PDF analysis**: Use `pdf2txt` or `pdf2img` (Claude can't read PDFs directly)
- **API testing**: Use `http` for readable output
- **File search**: Claude uses `rg` internally - same syntax works
- **Sharing content**: Use `clipfile` to copy file contents

## Skills

Portable agent skills live in `skills/<name>/SKILL.md` (work with Claude Code and
Codex; see AGENTS.md). Install locally with `scripts/install-skills.sh`.

| Skill | Purpose |
|-------|---------|
| `email-triage` | Sweep and label the Gmail inbox, draft (never send) replies |
| `add-tool` | Add/remove a CLI tool in sync across all installers, aliases, docs |
| `weekly-review` | End-of-week recap from calendar, email, git + next-week priorities |

When adding or changing any tool or alias in this repo, follow `skills/add-tool/SKILL.md`.

## File Structure

```
claude-setup/
├── scripts/
│   ├── install-wsl.sh       # WSL installer
│   ├── install-macos.sh     # macOS installer
│   ├── install-ubuntu.sh    # Ubuntu/Debian installer
│   └── install-windows.ps1  # Windows PowerShell installer
│   └── install-skills.sh    # Symlink skills/ into ~/.claude and ~/.codex
├── skills/
│   ├── email-triage/SKILL.md
│   ├── add-tool/SKILL.md
│   └── weekly-review/SKILL.md
├── aliases/
│   ├── bash_aliases_claude  # Bash/Zsh aliases
│   └── powershell_aliases.ps1  # PowerShell aliases
└── docs/
    ├── tools-reference.md   # Detailed tool documentation
    └── google-workspace-setup.md  # Email/Google setup for Claude & Codex, web & local
```
