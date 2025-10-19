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
    FileType       = "exe"
    File           = (Join-Path $uciChessPkgInstallDir "uninstall.exe")
    SilentArgs     = "/S"
}

Uninstall-ChocolateyPackage @packageArgs

if (Test-Path $uciChessPkgInstallDir) {
    "Removing program installation"
    Remove-Item -Path $uciChessPkgInstallDir -Force -ErrorAction Stop -Recurse
}

if (Test-Path $uciChessPkgShortcutPath) {
    "Removing shortcut"
    Remove-Item -Path $uciChessPkgShortcutPath
}
