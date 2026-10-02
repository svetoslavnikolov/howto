```PowerShell
# Add a program to Windows Menu

param(
    [Parameter(Mandatory = $true)]
    [string]$BaseName,

    [Parameter(Mandatory = $true)]
    [string]$FolderName
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$exePath = Join-Path $scriptDir "$BaseName.exe"

if (-not (Test-Path $exePath)) {
    Write-Error "Executable not found: $exePath"
    exit 1
}

$startMenuFolder = Join-Path `
    $env:APPDATA `
    "Microsoft\Windows\Start Menu\Programs\$FolderName"

New-Item -ItemType Directory -Path $startMenuFolder -Force | Out-Null

$shortcutPath = Join-Path $startMenuFolder "$BaseName.lnk"

$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)

$shortcut.TargetPath       = $exePath
$shortcut.WorkingDirectory = $scriptDir
$shortcut.IconLocation     = "$exePath,0"
$shortcut.Description      = $BaseName

$shortcut.Save()

Write-Host "Created shortcut:"
Write-Host "  $shortcutPath"

```
