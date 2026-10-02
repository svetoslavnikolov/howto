```PowerShell

# UnregisterFileType.ps1
#
# Removes a per-user file association created by RegisterFileType.ps1.
#
# Example:
#   .\UnregisterFileType.ps1 `
#       -Extension ".pmdb" `
#       -Application "PmDatabase"

param(
    [Parameter(Mandatory = $true)]
    [string]$Extension,

    [Parameter(Mandatory = $true)]
    [string]$Application
)

$ErrorActionPreference = "Stop"

if (-not $Extension.StartsWith(".")) {
    $Extension = "." + $Extension
}

$ProgId = "$Application.Document"
$AppExe = "$Application.exe"

$KeysToRemove = @(
    "HKCU:\Software\Classes\$Extension",
    "HKCU:\Software\Classes\$ProgId",
    "HKCU:\Software\Classes\Applications\$AppExe"
)

foreach ($Key in $KeysToRemove) {
    if (Test-Path $Key) {
        Remove-Item -Path $Key -Recurse -Force
        Write-Host "Removed $Key"
    }
}

#
# Notify Explorer that file associations changed
#
try {

    Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class Shell32NativeMethods
{
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(
        uint wEventId,
        uint uFlags,
        IntPtr dwItem1,
        IntPtr dwItem2);
}
"@

    [Shell32NativeMethods]::SHChangeNotify(
        0x08000000,
        0,
        [System.IntPtr]::Zero,
        [System.IntPtr]::Zero
    )

    Write-Host "Explorer notification sent."
}
catch {
    Write-Warning "Could not notify Explorer: $_"
}

Write-Host ""
Write-Host "Unregistered $Extension for $Application."
```
