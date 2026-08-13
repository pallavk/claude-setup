# Claude Code CLI Tools Installer for Windows
# ============================================
# Run as Administrator in PowerShell

Write-Host "🚀 Installing Claude Code CLI tools for Windows..." -ForegroundColor Cyan
Write-Host ""

# Check for winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget not found. Please install App Installer from Microsoft Store." -ForegroundColor Red
    exit 1
}

# Check for Chocolatey (optional, for additional tools)
$hasChoco = Get-Command choco -ErrorAction SilentlyContinue

Write-Host "🔧 Installing core tools via winget..." -ForegroundColor Yellow
Write-Host ""

# Core tools via winget
$wingetTools = @(
    @{id="ImageMagick.ImageMagick"; name="ImageMagick"},
    @{id="jqlang.jq"; name="jq"},
    @{id="BurntSushi.ripgrep.MSVC"; name="ripgrep"},
    @{id="sharkdp.fd"; name="fd"},
    @{id="sharkdp.bat"; name="bat"},
    @{id="JohnMacFarlane.Pandoc"; name="pandoc"},
    @{id="GitHub.cli"; name="GitHub CLI"},
    @{id="GoLang.Go"; name="Go (for gog)"},
    @{id="Git.Git"; name="Git"}
)

foreach ($tool in $wingetTools) {
    Write-Host "  Installing $($tool.name)..." -ForegroundColor Gray
    winget install --id $tool.id --silent --accept-package-agreements --accept-source-agreements 2>$null
}

# Tools requiring Chocolatey or manual install
if ($hasChoco) {
    Write-Host ""
    Write-Host "🍫 Installing additional tools via Chocolatey..." -ForegroundColor Yellow

    choco install -y poppler qpdf yq tree
} else {
    Write-Host ""
    Write-Host "⚠️  Chocolatey not found. Some tools require manual installation:" -ForegroundColor Yellow
    Write-Host "   - poppler (PDF tools): https://github.com/oschwartz10612/poppler-windows/releases"
    Write-Host "   - qpdf: https://github.com/qpdf/qpdf/releases"
    Write-Host "   - yq: https://github.com/mikefarah/yq/releases"
    Write-Host ""
    Write-Host "   Or install Chocolatey first: https://chocolatey.org/install"
}

# Python tools
Write-Host ""
Write-Host "🐍 Installing Python tools..." -ForegroundColor Yellow

if (Get-Command pip -ErrorAction SilentlyContinue) {
    pip install httpie csvkit
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    python -m pip install httpie csvkit
} else {
    Write-Host "⚠️  Python not found. Install Python and run: pip install httpie csvkit" -ForegroundColor Yellow
}

# Verify installations
Write-Host ""
Write-Host "✅ Verifying installations..." -ForegroundColor Green
Write-Host ""

$tools = @(
    @{cmd="magick"; name="ImageMagick"},
    @{cmd="jq"; name="jq"},
    @{cmd="rg"; name="ripgrep"},
    @{cmd="fd"; name="fd"},
    @{cmd="bat"; name="bat"},
    @{cmd="pandoc"; name="pandoc"},
    @{cmd="gh"; name="GitHub CLI"},
    @{cmd="gog"; name="gog (Google CLI)"},
    @{cmd="git"; name="Git"}
)

foreach ($tool in $tools) {
    if (Get-Command $tool.cmd -ErrorAction SilentlyContinue) {
        Write-Host "  ✓ $($tool.name)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($tool.name) (not found)" -ForegroundColor Red
    }
}

# Check Python tools
if (Get-Command http -ErrorAction SilentlyContinue) {
    Write-Host "  ✓ httpie" -ForegroundColor Green
} else {
    Write-Host "  ✗ httpie (not found)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 Installation complete!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor White
Write-Host "   1. Restart your terminal to refresh PATH"
Write-Host "   2. Add PowerShell aliases to your profile:"
Write-Host "      notepad `$PROFILE"
Write-Host "   3. Authenticate GitHub: gh auth login"
Write-Host "   4. Install gog (Google Workspace CLI): go install github.com/openclaw/gogcli/cmd/gog@latest"
Write-Host "      Then: gog auth add you@gmail.com --services gmail,calendar,drive"
Write-Host ""
Write-Host "💡 For WSL integration, also run install-wsl.sh inside your WSL distro" -ForegroundColor Gray
