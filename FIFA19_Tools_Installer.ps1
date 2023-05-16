#  FIFA19 Tools Installer (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn/
#  
#  [Credits]
#    ExtractArchive.ps1  | wvzxn     | https://gist.github.com/wvzxn/8f326deb99c3267ecf741a21fa73becb
#    Frosty Mod Manager  | CadeEvs   | https://github.com/CadeEvs/FrostyToolsuite
#    FIFA19key           | fifermods | https://www.fifermods.com/frosty-key
#    Extreme Injector    | master131 | https://github.com/master131/ExtremeInjector
#  
#  [Description]
#    The script installs Frosty Mod Manager, Extreme Injector,
#    bypasses Frosty's CPY block and creates shortcuts on Desktop and Start Menu.

param([switch]$Uninstall)

function Uninstall
{
    @(
        "fmm.zip",
        "ei.rar",
        "$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk" ,
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\FIFA 19 Launcher.lnk"
    ) | ?{ Test-Path $_ } | Remove-Item

    "$env:LOCALAPPDATA\Frosty" | ?{ Test-Path $_ } | Remove-Item -Recurse
    "ModData" | ?{ Test-Path $_ } | Remove-Item -Recurse
    if (Test-Path "FrostyModManager")
    {
        Get-ChildItem "FrostyModManager" -Exclude "Mods","#backup_Mods" | Remove-Item -Recurse
        if (Test-Path "FrostyModManager\Mods\FIFA19")
        {
            if (!(Test-Path "#backup_Mods")) { mkdir "#backup_Mods" | Out-Null }
            Move-Item "FrostyModManager\Mods\FIFA19" -Destination "#backup_Mods" -Force
            Write-Host "== #backup_Mods folder created" -for Green
        }
    }
    else { mkdir "FrostyModManager" | Out-Null }
}

#   Import
$urlExtract = "https://gist.githubusercontent.com/wvzxn/8f326deb99c3267ecf741a21fa73becb/raw/ebb82b5257d49f4e35869ff513aa6412a375ed81/ExtractArchive.ps1"
$urlFrosty = "https://github.com/CadeEvs/FrostyToolsuite/releases/latest/download/FrostyModManager.zip"
$urlFrostyKey = "https://raw.githubusercontent.com/wvzxn/fifa19_tools_installer/master/frosty_key_fifa19"
$urlInjector = "https://github.com/master131/ExtremeInjector/releases/download/v3.7.3/Extreme.Injector.v3.7.3.-.by.master131.rar"
Invoke-WebRequest -useb "$urlExtract" | Invoke-Expression

#   Check for FIFA 19 Root Folder
Set-Location ((Get-Location).Path -replace '^(.+?\\[^\\]*?fifa[^\\]*?)(?:\\.+)?$','$1')
if (!(Test-Path "FIFA19.exe")) { Write-Warning "Run this script inside FIFA 19 folder"; return }

#   Remove Leftovers + Backup Mods
Uninstall
if ($Uninstall) { Write-Host "== Uninstalling completed." -for Green; return }

#   Download Tools
Write-Host @(
    "== Downloading Frosty Mod Manager...",
    "[$("{0:N2}" -f ((Invoke-WebRequest $urlFrosty -Method Head).Headers.'Content-Length' / 1MB))MB]"
) -for Green
(New-Object System.Net.WebClient).DownloadFile($urlFrosty, (Get-Location).Path + "\fmm.zip")

Write-Host @(
    "== Downloading Extreme Injector...",
    "[$("{0:N2}" -f ((Invoke-WebRequest $urlInjector -Method Head).Headers.'Content-Length' / 1MB))MB]"
) -for Green
(New-Object System.Net.WebClient).DownloadFile($urlInjector, (Get-Location).Path + "\ei.rar")

ExtractArchive @("fmm.zip", "ei.rar") @("", "FrostyModManager")
Remove-Item @("fmm.zip", "ei.rar")

#   Create FIFA19_Launcher.vbs
@(
    "Dim scriptDir",
    "Dim inj",
    "Dim fmm",
    "scriptDir = CreateObject(`"Scripting.FileSystemObject`").GetParentFolderName(WScript.ScriptFullName)",
    "inj = scriptDir & `"\`" & `"Extreme Injector v3.exe`"",
    "fmm = scriptDir & `"\`" & `"FrostyModManager.exe`"",
    "",
    "'   Run as Administrator",
    "Set UAC = CreateObject(`"Shell.Application`")",
    "UAC.ShellExecute inj, `"`", scriptDir, `"runas`", 1",
    "UAC.ShellExecute fmm, `"`", scriptDir, `"runas`", 1"
) | Set-Content "FrostyModManager\#FIFA19_Launcher.vbs"

#   Create FIFA19_Launcher Shortcut
Write-Host "== Press [Y] to add FIFA 19 Launcher shortcuts to Desktop and Start Menu" -for Green
if (([Console]::ReadKey($true).Key) -eq "Y")
{
    $Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk")
    $Shortcut.IconLocation = (Resolve-Path "FIFA19.exe").Path
    $Shortcut.TargetPath = (Resolve-Path "FrostyModManager\#FIFA19_Launcher.vbs").Path
    $Shortcut.Save()
    Copy-Item "$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
}

#   FIFA19 key + Bypass Frosty block to create fifa19.cache
$filter="commentary*.toc"
foreach ($i in @("data\win32","patch\win32"))
{
    if (!(Test-Path "$i\comm")) { mkdir "$i\comm" | Out-Null }
    Move-Item "$i\$filter" "$i\comm"
}
Clear-Host
Write-Warning "Do not close this window."
Write-Host "== 1. Press [Y] to copy FIFA 19 KEY" -for Green
Write-Host "==      Or you can find the key at https://www.fifermods.com/frosty-key" -for Green
Write-Host "== 2. In Frosty window:" -for Green
Write-Host "==    - Select FIFA19.exe location" -for Green
Write-Host "==    - Paste the key and wait (It may take more than 5 minutes)." -for Green
Write-Host "== 3. Then close Frosty Mod Manager and return to this window." -for Green
if (([Console]::ReadKey($true).Key) -eq "Y") { (Invoke-WebRequest -useb $urlFrostyKey).Content | Set-Clipboard }
Start-Process "FrostyModManager\FrostyModManager.exe" -WorkingDirectory "FrostyModManager" -Verb runAs -Wait
foreach ($i in @("data\win32","patch\win32")) { Move-Item "$i\comm\$filter" $i }
Write-Host "== Done!" -for Green

return