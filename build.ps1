# Build script — packages src\ into otzaria-books-downloader.otzplugin
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root

$src = Join-Path $root 'src'
if (-not (Test-Path (Join-Path $src 'manifest.json'))) {
    Write-Error "src\manifest.json not found — run this from the repo root"
    exit 1
}

$out = Join-Path $root 'otzaria-books-downloader.otzplugin'
if (Test-Path $out) { Remove-Item $out -Force }

# ה-manifest חייב לשבת בשורש הארכיון, לא בתוך תיקייה — לכן דוחסים את
# תוכן src\ ולא את התיקייה עצמה.
Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $src, $out, [System.IO.Compression.CompressionLevel]::Optimal, $false)

Write-Host "Built: $out" -ForegroundColor Green
Get-Item $out | Format-List Name, Length, LastWriteTime
