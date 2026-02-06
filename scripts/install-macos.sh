#!/bin/bash
# Claude Code CLI Tools Installer for macOS
# ==========================================

set -e

echo "🚀 Installing Claude Code CLI tools for macOS..."
echo ""

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Core tools
echo ""
echo "🔧 Installing core tools..."
brew install \
    imagemagick \
    poppler \
    qpdf \
    jq \
    yq \
    ripgrep \
    fd \
    bat \
    tree \
    pandoc \
    gh

# Python tools
echo ""
echo "🐍 Installing Python tools..."
if command -v pip3 &> /dev/null; then
    pip3 install httpie csvkit
elif command -v uv &> /dev/null; then
    uv pip install httpie csvkit
else
    echo "⚠️  pip3/uv not found. Install Python tools manually:"
    echo "   pip install httpie csvkit"
fi

# Verify installations
echo ""
echo "✅ Verifying installations..."
echo ""

tools=(
    "convert:ImageMagick"
    "pdftotext:poppler"
    "qpdf:qpdf"
    "jq:jq"
    "yq:yq"
    "rg:ripgrep"
    "fd:fd"
    "bat:bat"
    "tree:tree"
    "pandoc:pandoc"
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
echo "   1. Copy aliases to your shell config:"
echo "      cat aliases/bash_aliases_claude >> ~/.zshrc"
echo "   2. Reload shell: source ~/.zshrc"
echo "   3. Authenticate GitHub: gh auth login"
