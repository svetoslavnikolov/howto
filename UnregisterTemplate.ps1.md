```PowerShell
# Unregister document template

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$DocumentType
)

$ErrorActionPreference = "Stop"

if (-not $DocumentType.StartsWith(".")) {
    $DocumentType = "." + $DocumentType
}

$documentTypePath = "HKCU:\Software\Classes\$DocumentType"
$shellNewPath = "$documentTypePath\ShellNew"

if (Test-Path -LiteralPath $shellNewPath) {
    Remove-ItemProperty -LiteralPath $shellNewPath -Name "FileName" -ErrorAction SilentlyContinue

    $shellNewKey = Get-Item -LiteralPath $shellNewPath
    $hasValues = $shellNewKey.Property.Count -gt 0
    $hasSubKeys = @(Get-ChildItem -LiteralPath $shellNewPath -ErrorAction SilentlyContinue).Count -gt 0

    if (-not $hasValues -and -not $hasSubKeys) {
        Remove-Item -LiteralPath $shellNewPath -Force
    }
}

if (Test-Path -LiteralPath $documentTypePath) {
    $documentTypeKey = Get-Item -LiteralPath $documentTypePath
    $hasValues = $documentTypeKey.Property.Count -gt 0
    $hasSubKeys = @(Get-ChildItem -LiteralPath $documentTypePath -ErrorAction SilentlyContinue).Count -gt 0

    if (-not $hasValues -and -not $hasSubKeys) {
        Remove-Item -LiteralPath $documentTypePath -Force
    }
}

try {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Shell32NativeMethods
{
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(
        uint eventId,
        uint flags,
        IntPtr item1,
        IntPtr item2);
}
"@

    [Shell32NativeMethods]::SHChangeNotify(
        0x08000000,
        0,
        [IntPtr]::Zero,
        [IntPtr]::Zero)
}
catch {
    Write-Warning "Could not notify Explorer about the template unregistration: $_"
}

Write-Host "Unregistered template for $DocumentType."
```
