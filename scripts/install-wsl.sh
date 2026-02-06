#!/bin/bash
# Claude Code CLI Tools Installer for WSL
# ========================================

set -e

echo "🚀 Installing Claude Code CLI tools for WSL..."
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
    wslu

# Python tools
echo ""
echo "🐍 Installing Python tools..."
if command -v pip3 &> /dev/null; then
    pip3 install --user httpie csvkit
elif command -v uv &> /dev/null; then
    uv pip install httpie csvkit
else
    echo "⚠️  Neither pip3 nor uv found. Install Python tools manually:"
    echo "   pip install httpie csvkit"
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
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
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
    "wslview:wslu"
    "yq:yq"
    "gh:GitHub CLI"
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

# Python tools check
if command -v http &> /dev/null; then
    echo "  ✓ httpie"
else
    echo "  ✗ httpie (not found)"
fi

if command -v csvlook &> /dev/null; then
    echo "  ✓ csvkit"
else
    echo "  ✗ csvkit (not found)"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Copy aliases: cat aliases/bash_aliases_claude >> ~/.bash_aliases"
echo "   2. Reload shell: source ~/.bash_aliases"
echo "   3. Authenticate GitHub: gh auth login"
echo ""
echo "💡 Note: On Ubuntu, use 'batcat' instead of 'bat' and 'fdfind' instead of 'fd'"
