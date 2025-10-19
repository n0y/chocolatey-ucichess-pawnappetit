#Shared for everyone
$uciChessDir = Join-Path $env:ProgramData "UCI-Chess"
$uciChessGuiDir = Join-Path $uciChessDir "GUI"
$uciChessEngineDir = Join-Path $uciChessDir "Engine"

$isAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    $startMenuPath = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs"
} else {
    $specialFolder = [System.Environment+SpecialFolder]::Programs
    $startMenuPath = [System.Environment]::GetFolderPath($specialFolder)
}

$uciChessShortcutDir = Join-Path $startMenuPath "UCI-Chess"

#Shared for this package

$uciChessPackageName = "ucichess-pawnappetit"
$uciChessPkgInstallDirName = "pawn-appetit"
$uciChessPkgInstallDir = Join-Path $uciChessGuiDir $uciChessPkgInstallDirName
$uciChessPkgExecPath = Join-Path $uciChessPkgInstallDir "pawn-appetit.exe"

$uciChessPkgShortcutDir = Join-Path $uciChessShortcutDir "GUI"
$uciChessPkgShortcutPath = Join-Path $uciChessPkgShortcutDir "Pawn Appetit.lnk"

#Individual for this script

$packageArgs = @{
    PackageName    = $uciChessPackageName
    ChecksumType   = 'sha256'
    Url64bit       = 'https://github.com/Pawn-Appetit/pawn-appetit/releases/download/v%%VERSION%%/Pawn.Appetit_%%VERSION%%_x64-setup.exe'
    Checksum64     = '%%CHECKSUM%%'
    ChecksumType64 = 'sha256'
    SilentArgs     = "/S /D=$uciChessPkgInstallDir"
}

Install-ChocolateyPackage @packageArgs

"Installing shortcut"
Install-ChocolateyShortcut -targetPath $uciChessPkgExecPath -ShortcutFilePath $uciChessPkgShortcutPath

"Removing installer shortcut"
$installerShortcut = Join-Path $startMenuPath "Pawn Appetit.lnk"
if (Test-Path $installerShortcut) {
    Remove-Item $installerShortcut
}

"Installing engine maintenance script"
Copy-Item -Path (Join-Path $PSScriptRoot "sync-engines.ps1") -Destination $uciChessPkgInstallDir