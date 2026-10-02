```PowerShell
 param(
    [Parameter(Mandatory=$true)]
    [string]$Extension,          # Example: .db

    [Parameter(Mandatory=$true)]
    [string]$ProgId,             # Example: Database.Document

    [Parameter(Mandatory=$true)]
    [string]$DocumentName,       # Example: Database Database

    [Parameter(Mandatory=$true)]
    [string]$ExePath,            # Example: C:\Apps\MyExecutable.exe

    [string]$IconPath = ""
)

$ErrorActionPreference = "Stop"

if (-not $Extension.StartsWith(".")) {
    $Extension = "." + $Extension
}

function Set-DefaultValue {
    param(
        [string]$Path,
        [string]$Value
    )

    $key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($Path)
    $key.SetValue("", $Value)
    $key.Close()
}

function Set-StringValue {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value
    )

    New-Item -Path $Path -Force | Out-Null

    New-ItemProperty `
        -Path $Path `
        -Name $Name `
        -Value $Value `
        -PropertyType String `
        -Force | Out-Null
}

$ClassesRoot = "Software\Classes"
$PSClassesRoot = "HKCU:\Software\Classes"

# Extension -> ProgID
Set-DefaultValue "$ClassesRoot\$Extension" $ProgId

# OpenWithProgids
New-Item `
    -Path "$PSClassesRoot\$Extension\OpenWithProgids" `
    -Force | Out-Null

New-ItemProperty `
    -Path "$PSClassesRoot\$Extension\OpenWithProgids" `
    -Name $ProgId `
    -Value ([byte[]]@()) `
    -PropertyType Binary `
    -Force | Out-Null

# ProgID
Set-DefaultValue "$ClassesRoot\$ProgId" $DocumentName

Set-StringValue `
    "$PSClassesRoot\$ProgId" `
    "FriendlyTypeName" `
    $DocumentName

# Icon
if ($IconPath -and (Test-Path $IconPath)) {
    Set-DefaultValue `
        "$ClassesRoot\$ProgId\DefaultIcon" `
        "`"$IconPath`",0"
}
else {
    Set-DefaultValue `
        "$ClassesRoot\$ProgId\DefaultIcon" `
        "`"$ExePath`",0"
}

# Open command
Set-DefaultValue "$ClassesRoot\$ProgId\shell" "open"

Set-DefaultValue `
    "$ClassesRoot\$ProgId\shell\open\command" `
    "`"$ExePath`" `"%1`""

# Applications registration
$appExe = Split-Path $ExePath -Leaf

Set-DefaultValue `
    "Software\Classes\Applications\$appExe\shell\open\command" `
    "`"$ExePath`" `"%1`""

# Refresh Explorer
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class NativeMethods
{
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(
        uint eventId,
        uint flags,
        IntPtr item1,
        IntPtr item2);
}
"@

[NativeMethods]::SHChangeNotify(
    0x08000000,
    0,
    [IntPtr]::Zero,
    [IntPtr]::Zero)

Write-Host "Registered $Extension -> $ProgId"
```
