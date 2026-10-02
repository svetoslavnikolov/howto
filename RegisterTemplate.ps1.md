Register a Document template, so that it can be created directly with FileExplorer

```PowerShell
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TemplatePath,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$DocumentType
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $TemplatePath -PathType Leaf)) {
    throw "Template file not found: $TemplatePath"
}

if (-not $DocumentType.StartsWith(".")) {
    $DocumentType = "." + $DocumentType
}

$shellNewPath = "HKCU:\Software\Classes\$DocumentType\ShellNew"
New-Item -Path $shellNewPath -Force | Out-Null
New-ItemProperty `
    -Path $shellNewPath `
    -Name "FileName" `
    -Value ([System.IO.Path]::GetFullPath($TemplatePath)) `
    -PropertyType String `
    -Force | Out-Null

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
    Write-Warning "Could not notify Explorer about the template registration: $_"
}

Write-Host "Registered template for ${DocumentType}:"
Write-Host "  $([System.IO.Path]::GetFullPath($TemplatePath))"
```
