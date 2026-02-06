# Claude Code Environment Setup

CLI tools and configurations for an effective Claude Code development environment.

## Quick Start

### WSL (Windows Subsystem for Linux)
```bash
curl -sSL https://raw.githubusercontent.com/pallavk/claude-setup/main/scripts/install-wsl.sh | bash
```

### macOS
```bash
curl -sSL https://raw.githubusercontent.com/pallavk/claude-setup/main/scripts/install-macos.sh | bash
```

### Ubuntu/Debian
```bash
curl -sSL https://raw.githubusercontent.com/pallavk/claude-setup/main/scripts/install-ubuntu.sh | bash
```

### Windows (PowerShell as Admin)
```powershell
irm https://raw.githubusercontent.com/pallavk/claude-setup/main/scripts/install-windows.ps1 | iex
```

## What Gets Installed

| Category | Tools | Purpose |
|----------|-------|---------|
| **Images** | ImageMagick | Resize, convert, manipulate images |
| **PDF** | poppler-utils, qpdf | Extract text, split/merge PDFs |
| **Documents** | pandoc | Convert Markdown ↔ Word ↔ PDF ↔ HTML |
| **JSON/Data** | jq, yq | Parse and transform JSON/YAML |
| **Search** | ripgrep, fd | Fast file and content search |
| **Git** | gh CLI | GitHub operations from terminal |
| **HTTP** | httpie | Friendly HTTP client |
| **CSV** | csvkit | CSV manipulation and queries |

## Directory Structure

```
claude-setup/
├── README.md                    # This file
├── CLAUDE.md                    # Instructions for Claude Code
├── docs/
│   └── tools-reference.md       # Detailed tool documentation
├── scripts/
│   ├── install-wsl.sh           # WSL installer
│   ├── install-macos.sh         # macOS installer
│   ├── install-ubuntu.sh        # Ubuntu/Debian installer
│   └── install-windows.ps1      # Windows PowerShell installer
└── aliases/
    ├── bash_aliases_claude      # Bash aliases for Claude workflows
    └── powershell_aliases.ps1   # PowerShell aliases for Windows
```

## Post-Installation

After running the installer, add the aliases to your shell:

**Bash/Zsh:**
```bash
cat aliases/bash_aliases_claude >> ~/.bash_aliases
source ~/.bash_aliases
```

**PowerShell:**
```powershell
cat aliases/powershell_aliases.ps1 >> $PROFILE
. $PROFILE
```

## Why These Tools?

Claude Code can read files, execute commands, and process outputs. These tools enhance that workflow:

- **Screenshots** → Claude can analyze images you share
- **PDF tools** → Convert PDFs to text/images for Claude to read
- **Image resize** → Smaller images = faster processing
- **JSON/YAML** → Parse API responses and config files
- **Clipboard** → Quickly share content between Windows and WSL

## License

MIT
