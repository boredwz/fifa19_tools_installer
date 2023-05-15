# [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
# & {$((iwr -useb 'https://raw.githubusercontent.com/wvzxn/fifa19_tools_installer/main/setup.ps1').Content)} -uninstall|iex

param([switch]$uninstall)

function Uninstall {
    @(
        "fmm.zip",
        "ei.rar",
        "$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk" ,
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\FIFA 19 Launcher.lnk"
    ) | ForEach-Object { if (Test-Path $_) { Remove-Item $_ } }
    
    "FrostyModManager\Mods" | ?{ Test-Path $_ } | Copy-Item -Destination "#backup_Mods" -Recurse
    "$env:LOCALAPPDATA\Frosty" | ?{ Test-Path $_ } | Remove-Item -Recurse
    "ModData" | ?{ Test-Path $_ } | Remove-Item -Recurse
    "FrostyModManager" | ?{ Test-Path $_ } | Remove-Item -Recurse
    mkdir "FrostyModManager" | Out-Null
    "#backup_Mods" | ?{ Test-Path $_ } | Move-Item -Destination "FrostyModManager\$_" -Force
}

#   Import
$urlWC = "https://gist.githubusercontent.com/ChrisStro/37444dd012f79592080bd46223e27adc/raw/5ba566bd030b89358ba5295c04b8ef1062ddd0ce/Get-FileFromWeb.ps1"
$urlExtract = "https://gist.githubusercontent.com/wvzxn/8f326deb99c3267ecf741a21fa73becb/raw/0646c5e45e6bacd28c7ab3cb0d7dd0178ce28b02/ExtractArchive.ps1"
$urlFrosty = "https://github.com/CadeEvs/FrostyToolsuite/releases/latest/download/FrostyModManager.zip"
$urlInjector = "https://github.com/master131/ExtremeInjector/releases/download/v3.7.3/Extreme.Injector.v3.7.3.-.by.master131.rar"
Invoke-WebRequest -useb "$urlWC" | Invoke-Expression          # Get-FileFromWeb $Url  $Path
Invoke-WebRequest -useb "$urlExtract" | Invoke-Expression     # ExtractArchive  $Path $Destination

if ((Get-Location).Path -notmatch "FIFA")
{
    Write-Warning "Run this script inside FIFA 19 folder"
    Pause
    Exit
}

#   Go to FIFA 19 Root Folder
Set-Location ((Get-Location).Path -replace '^(.+?\\[^\\]*?fifa[^\\]*?)(?:\\.+)?$','$1')

echo "uninstall: $uninstall"
Pause
exit

#   Remove Leftovers + Backup Mods
Uninstall
if ($uninstall) { Write-Host "Uninstalling completed."; Pause; Exit }

#   Download Tools
Get-FileFromWeb "$urlFrosty" "fmm.zip"
Get-FileFromWeb "$urlInjector" "ei.rar"
ExtractArchive @("fmm.zip", "ei.rar") @("", "FrostyModManager")

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
    "UAC.ShellExecute inj, `"`", `"`", `"runas`", 1",
    "UAC.ShellExecute fmm, `"`", `"`", `"runas`", 1"
) | Set-Content "FrostyModManager\#FIFA19_Launcher.vbs"

#   Create FIFA19_Launcher Shortcut
$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk")
$Shortcut.IconLocation = (Resolve-Path "FIFA19.exe").Path
$Shortcut.TargetPath = (Resolve-Path "FrostyModManager\#FIFA19_Launcher.vbs").Path
$Shortcut.Save()
Copy-Item "$env:USERPROFILE\Desktop\FIFA 19 Launcher.lnk" "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

#   Bypass Frosty block to create fifa19.cache
$filter="commentary*.toc"
foreach ($i in @("data\win32","patch\win32"))
{
    if (!(Test-Path "$i\comm")) { mkdir "$i\comm" | Out-Null }
    Move-Item "$i\$filter" "$i\comm"
}
Write-Host "== Select FIFA 19 location in Frosty Mod Manager and wait (It may take more than 5 minutes)."
Write-Host "== Then close Frosty Mod Manager and return to this window."
Start-Process "FrostyModManager\FrostyModManager.exe" -WorkingDirectory "FrostyModManager" -Verb runAs -Wait
foreach ($i in @("data\win32","patch\win32")) { Move-Item "$i\comm\$filter" $i }
Write-Host "== Done!"
Pause