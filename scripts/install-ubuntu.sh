#!/bin/bash
# Claude Code CLI Tools Installer for Ubuntu/Debian
# ==================================================

set -e

echo "🚀 Installing Claude Code CLI tools for Ubuntu/Debian..."
echo ""

# Update package lists
echo "📦 Updating package lists..."
sudo apt update

# Core tools
echo ""
echo "🔧 Installing core tools..."
sudo apt install -y \
    imagemagick \
    poppler-utils \
    qpdf \
    jq \
    ripgrep \
    fd-find \
    bat \
    tree \
    pandoc \
    wkhtmltopdf \
    curl

# Python tools
echo ""
echo "🐍 Installing Python tools..."
if command -v pip3 &> /dev/null; then
    pip3 install --user httpie csvkit
elif command -v uv &> /dev/null; then
    uv pip install httpie csvkit
else
    sudo apt install -y python3-pip
    pip3 install --user httpie csvkit
fi

# yq (YAML processor)
echo ""
echo "📄 Installing yq..."
if ! command -v yq &> /dev/null; then
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
fi

# GitHub CLI
echo ""
echo "🐙 Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

# Google Workspace CLI (Gmail, Calendar, Drive)
echo ""
echo "📧 Installing gog (Google Workspace CLI)..."
if ! command -v gog &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install openclaw/tap/gogcli
    elif command -v go &> /dev/null; then
        go install github.com/openclaw/gogcli/cmd/gog@latest
    else
        echo "⚠️  Neither brew nor go found. Install gog manually:"
        echo "   brew install openclaw/tap/gogcli"
        echo "   or: go install github.com/openclaw/gogcli/cmd/gog@latest"
    fi
fi

# Verify installations
echo ""
echo "✅ Verifying installations..."
echo ""

tools=(
    "convert:ImageMagick"
    "pdftotext:poppler-utils"
    "qpdf:qpdf"
    "jq:jq"
    "rg:ripgrep"
    "fdfind:fd-find"
    "batcat:bat"
    "tree:tree"
    "pandoc:pandoc"
    "yq:yq"
    "gh:GitHub CLI"
    "gog:gog (Google CLI)"
)

for tool_pair in "${tools[@]}"; do
    cmd="${tool_pair%%:*}"
    name="${tool_pair##*:}"
    if command -v "$cmd" &> /dev/null; then
        echo "  ✓ $name"
    else
        echo "  ✗ $name (not found)"
    fi
done

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Copy aliases: cat aliases/bash_aliases_claude >> ~/.bash_aliases"
echo "   2. Reload shell: source ~/.bash_aliases"
echo "   3. Authenticate GitHub: gh auth login"
echo "   4. Set up gog accounts: gog auth add you@gmail.com --services gmail,calendar,drive"
echo ""
echo "💡 Note: On Ubuntu, use 'batcat' instead of 'bat' and 'fdfind' instead of 'fd'"
