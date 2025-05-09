﻿$reg = Get-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
if($reg.Property.Count -eq  2) {
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1 -Type Dword -Force
}


$light = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme

if ($light.AppsUseLightTheme -eq  0) {
Write-Host "Switch To light"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1;
$taskbar = Read-Host -Prompt 'Dow you want to change the taskbar color as well? (Y/N)'

if ($taskbar -eq "Y") {
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemusesLightTheme -Value 1
}

}
else {
Write-Host "Switch To Dark"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
$taskbar = Read-Host -Prompt 'Dow you want to change the taskbar color as well? (Y/N)'

if ($taskbar -eq "Y") {
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemusesLightTheme -Value 0
}
}