```
# Remove from Windows Menu

param(
    [Parameter(Mandatory = $true)]
    [string]$BaseName,

    [Parameter(Mandatory = $true)]
    [string]$FolderName
)

$ErrorActionPreference = "Stop"

$startMenuFolder = Join-Path `
    $env:APPDATA `
    "Microsoft\Windows\Start Menu\Programs\$FolderName"

$shortcutPath = Join-Path $startMenuFolder "$BaseName.lnk"

if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
    Write-Host "Removed shortcut:"
    Write-Host "  $shortcutPath"
}

# Remove folder if empty
if (Test-Path $startMenuFolder) {

    $itemCount = (Get-ChildItem $startMenuFolder -Force | Measure-Object).Count

    if ($itemCount -eq 0) {
        Remove-Item $startMenuFolder -Force
        Write-Host "Removed empty folder:"
        Write-Host "  $startMenuFolder"
    }
}
```
