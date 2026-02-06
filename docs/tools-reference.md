# CLI Tools Reference for Claude Code

Detailed documentation for each tool in the Claude Code environment.

---

## Image Processing

### ImageMagick

**What it does:** Swiss army knife for image manipulation - resize, convert, annotate, composite.

**Why Claude needs it:** Resize large screenshots for faster processing; convert between formats.

```bash
# Resize image to 50%
convert image.png -resize 50% smaller.png

# Convert PNG to JPG (Claude processes JPGs faster)
convert screenshot.png screenshot.jpg

# Get image dimensions
identify image.png

# Resize to max width of 1200px (preserving aspect ratio)
convert image.png -resize 1200x image_resized.png

# Add text annotation
convert image.png -pointsize 24 -annotate +10+30 'Label' annotated.png

# Create thumbnail
convert image.png -thumbnail 200x200 thumb.png
```

---

## PDF Tools

### poppler-utils

**What it does:** Extract text and images from PDFs, get metadata, convert to images.

**Why Claude needs it:** Claude can't directly read PDFs - convert to text or images first.

```bash
# Extract text from PDF
pdftotext document.pdf output.txt

# Extract text preserving layout
pdftotext -layout document.pdf output.txt

# Extract specific pages
pdftotext -f 1 -l 5 document.pdf output.txt

# Convert PDF pages to images (for visual analysis)
pdftoppm -jpeg -r 150 document.pdf page
# Creates: page-1.jpg, page-2.jpg, etc.

# Get PDF metadata
pdfinfo document.pdf

# Extract all images from PDF
pdfimages -j document.pdf images/
```

### qpdf

**What it does:** PDF surgery - split, merge, rotate, decrypt.

**Why Claude needs it:** Extract specific pages, merge documents for processing.

```bash
# Extract pages 1-5
qpdf document.pdf --pages . 1-5 -- subset.pdf

# Merge multiple PDFs
qpdf --empty --pages file1.pdf file2.pdf file3.pdf -- merged.pdf

# Rotate page 1 by 90 degrees
qpdf document.pdf --rotate=+90:1 -- rotated.pdf

# Remove password protection
qpdf --password=secret --decrypt encrypted.pdf decrypted.pdf

# Linearize for web (fast web view)
qpdf --linearize document.pdf web-optimized.pdf
```

---

## Document Conversion

### pandoc

**What it does:** Universal document converter - Markdown, Word, PDF, HTML, and 40+ formats.

**Why Claude needs it:** Generate Word docs from Markdown, convert between formats.

```bash
# Markdown to Word
pandoc document.md -o document.docx

# Markdown to PDF (use wkhtmltopdf engine - lighter than texlive)
pandoc document.md -o document.pdf --pdf-engine=wkhtmltopdf

# Word to Markdown
pandoc document.docx -o document.md

# HTML to Markdown
pandoc page.html -o page.md

# With table of contents
pandoc document.md --toc -o document.pdf

# Standalone HTML with CSS
pandoc document.md -s -c style.css -o document.html
```

---

## JSON & Data Processing

### jq

**What it does:** Command-line JSON processor - filter, transform, query JSON data.

**Why Claude needs it:** Parse API responses, extract data from JSON files.

```bash
# Pretty print JSON
cat data.json | jq .

# Extract specific field
cat data.json | jq '.name'

# Filter array
cat data.json | jq '.items[] | select(.status == "active")'

# Transform data
cat data.json | jq '{id: .id, label: .name}'

# Get array length
cat data.json | jq '.items | length'

# Compact output (remove whitespace)
cat data.json | jq -c .

# Raw string output (no quotes)
cat data.json | jq -r '.name'
```

### yq

**What it does:** Like jq but for YAML files.

**Why Claude needs it:** Parse Docker Compose, Kubernetes manifests, config files.

```bash
# Read YAML value
yq '.services.web.image' docker-compose.yml

# Convert YAML to JSON
yq -o=json . config.yaml

# Update value in place
yq -i '.version = "2.0"' config.yaml

# Merge YAML files
yq '. *= load("override.yaml")' base.yaml
```

### csvkit

**What it does:** Suite of tools for working with CSV files.

**Why Claude needs it:** Analyze data exports, transform spreadsheet data.

```bash
# Pretty print CSV as table
csvlook data.csv

# Get column statistics
csvstat data.csv

# Query CSV with SQL
csvsql --query "SELECT name, SUM(amount) FROM data GROUP BY name" data.csv

# Convert JSON to CSV
in2csv data.json > data.csv

# Extract specific columns
csvcut -c name,email data.csv

# Filter rows
csvgrep -c status -m "active" data.csv
```

---

## File Search

### ripgrep (rg)

**What it does:** Extremely fast recursive search (faster than grep).

**Why Claude needs it:** Claude Code uses ripgrep internally for searching codebases.

```bash
# Basic search
rg "pattern"

# Search specific file types
rg "TODO" --type py

# Case insensitive
rg -i "error"

# Show context lines
rg -C 3 "function"

# Search hidden files
rg --hidden "config"

# List files only (no matches)
rg -l "import"

# Invert match (lines NOT matching)
rg -v "debug"
```

### fd

**What it does:** Modern alternative to `find` - faster and friendlier syntax.

**Why Claude needs it:** Quickly locate files by name pattern.

```bash
# Find by name
fd "config"

# Find by extension
fd -e py

# Find in specific directory
fd "test" src/

# Find directories only
fd -t d "components"

# Find and execute command
fd -e jpg -x convert {} {.}.png

# Exclude patterns
fd -E node_modules "index"
```

---

## HTTP & APIs

### httpie

**What it does:** Friendly HTTP client with intuitive syntax (better than curl for APIs).

**Why Claude needs it:** Test APIs, fetch data from web services.

```bash
# GET request
http GET api.example.com/users

# POST with JSON body
http POST api.example.com/users name=John email=john@example.com

# With headers
http GET api.example.com/data Authorization:"Bearer token123"

# Download file
http --download example.com/file.zip

# Form data
http --form POST api.example.com/upload file@photo.jpg

# Follow redirects
http --follow GET short.url/abc
```

---

## Git & GitHub

### gh (GitHub CLI)

**What it does:** GitHub operations from the command line.

**Why Claude needs it:** Create PRs, manage issues, view repo info without leaving terminal.

```bash
# Clone repo
gh repo clone owner/repo

# Create pull request
gh pr create --title "Feature" --body "Description"

# List open PRs
gh pr list

# View PR details
gh pr view 123

# Create issue
gh issue create --title "Bug" --body "Description"

# View repo in browser
gh repo view --web

# Run GitHub Actions workflow
gh workflow run build.yml
```

---

## Clipboard (WSL/Windows)

### clip.exe / powershell

**What it does:** Copy/paste between WSL and Windows clipboard.

**Why Claude needs it:** Share content between terminal and Windows apps.

```bash
# Copy to Windows clipboard
echo "text" | clip.exe
cat file.txt | clip.exe

# Paste from Windows clipboard
powershell.exe Get-Clipboard

# Copy file path for Windows apps
wslpath -w /home/user/file.txt | clip.exe
```

---

## Viewing & Navigation

### bat

**What it does:** `cat` with syntax highlighting, line numbers, and git integration.

**Why Claude needs it:** Better file viewing with context.

```bash
# View file with highlighting
bat file.py

# Show line numbers only
bat -n file.py

# Plain mode (no decorations)
bat -p file.py

# Show non-printable characters
bat -A file.py
```

### tree

**What it does:** Display directory structure as tree.

**Why Claude needs it:** Quickly understand project layout.

```bash
# Show 2 levels deep
tree -L 2

# Directories first
tree --dirsfirst

# Show only directories
tree -d

# Exclude patterns
tree -I "node_modules|__pycache__"

# With file sizes
tree -h
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Resize image 50% | `convert img.png -resize 50% small.png` |
| PDF to text | `pdftotext doc.pdf output.txt` |
| PDF to images | `pdftoppm -jpeg -r 150 doc.pdf page` |
| Merge PDFs | `qpdf --empty --pages a.pdf b.pdf -- merged.pdf` |
| MD to Word | `pandoc doc.md -o doc.docx` |
| Pretty JSON | `cat data.json \| jq .` |
| Search code | `rg "pattern" --type py` |
| Find files | `fd "config" -e yaml` |
| API request | `http GET api.example.com/data` |
| Create PR | `gh pr create --title "Title"` |
| Copy to clipboard | `echo "text" \| clip.exe` |
| Directory tree | `tree -L 2 --dirsfirst` |
