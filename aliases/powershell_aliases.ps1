# Claude Code Helper Aliases for PowerShell
# ==========================================
# Add to $PROFILE (run: notepad $PROFILE)

# ─────────────────────────────────────────────────────────────
# Screenshots
# ─────────────────────────────────────────────────────────────

$ScreenshotsPath = "$env:USERPROFILE\Pictures\Screenshots"

function cdss { Set-Location $ScreenshotsPath }

function ss {
    Get-ChildItem $ScreenshotsPath -File |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 10 |
        Format-Table Name, LastWriteTime, @{N='Size(KB)';E={[math]::Round($_.Length/1KB)}}
}

function lastss {
    (Get-ChildItem $ScreenshotsPath -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1).Name
}

function lastss-path {
    (Get-ChildItem $ScreenshotsPath -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
}

# ─────────────────────────────────────────────────────────────
# Clipboard
# ─────────────────────────────────────────────────────────────

function clipfile($path) {
    Get-Content $path | Set-Clipboard
    Write-Host "Copied $path to clipboard"
}

# ─────────────────────────────────────────────────────────────
# Image Processing
# ─────────────────────────────────────────────────────────────

function resize50($image) {
    $output = "small_$(Split-Path $image -Leaf)"
    magick $image -resize 50% $output
    Write-Host "Created: $output"
}

function resizew($image, $width = 1200) {
    $output = "w${width}_$(Split-Path $image -Leaf)"
    magick $image -resize "${width}x" $output
    Write-Host "Created: $output (width: ${width}px)"
}

function tojpg($image) {
    $output = [System.IO.Path]::ChangeExtension($image, ".jpg")
    magick $image $output
    Write-Host "Created: $output"
}

# ─────────────────────────────────────────────────────────────
# PDF Tools (requires poppler)
# ─────────────────────────────────────────────────────────────

function pdf2txt($pdf, $output) {
    if (-not $output) { $output = [System.IO.Path]::ChangeExtension($pdf, ".txt") }
    pdftotext -layout $pdf $output
    Write-Host "Created: $output"
}

# ─────────────────────────────────────────────────────────────
# JSON Processing
# ─────────────────────────────────────────────────────────────

function jqp { $input | jq . }

# ─────────────────────────────────────────────────────────────
# Navigation
# ─────────────────────────────────────────────────────────────

function t { tree /F /A | Select-Object -First 50 }

# ─────────────────────────────────────────────────────────────
# Document Conversion
# ─────────────────────────────────────────────────────────────

function md2docx($input, $output) {
    if (-not $output) { $output = [System.IO.Path]::ChangeExtension($input, ".docx") }
    pandoc $input -o $output
    Write-Host "Created: $output"
}

function md2pdf($input, $output) {
    if (-not $output) { $output = [System.IO.Path]::ChangeExtension($input, ".pdf") }
    pandoc $input -o $output
    Write-Host "Created: $output"
}

# ─────────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────────

function lsclaude {
    Write-Host "Claude Code Helpers:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Screenshots:" -ForegroundColor Yellow
    Write-Host "  cdss        - Go to Screenshots folder"
    Write-Host "  ss          - List recent screenshots"
    Write-Host "  lastss      - Most recent screenshot name"
    Write-Host "  lastss-path - Full path to latest screenshot"
    Write-Host ""
    Write-Host "Clipboard:" -ForegroundColor Yellow
    Write-Host "  clipfile X  - Copy file contents to clipboard"
    Write-Host ""
    Write-Host "Images:" -ForegroundColor Yellow
    Write-Host "  resize50 X     - Resize image to 50%"
    Write-Host "  resizew X 800  - Resize to width 800px"
    Write-Host "  tojpg X        - Convert to JPG"
    Write-Host ""
    Write-Host "PDF:" -ForegroundColor Yellow
    Write-Host "  pdf2txt X      - Extract text from PDF"
    Write-Host ""
    Write-Host "Documents:" -ForegroundColor Yellow
    Write-Host "  md2docx X      - Markdown to Word"
    Write-Host "  md2pdf X       - Markdown to PDF"
}
