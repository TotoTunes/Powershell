$PathNav = "$env:APPDATA\Microsoft\Microsoft Dynamics NAV\90"
$SourceNav = "\\frigga01\sources$\Software\Microsoft\Dynamics NAV\SupportFiles\ClientUser"
If(!(test-path $PathNav))
{
      New-Item -ItemType Directory -Force -Path $PathNav
}
robocopy $SourceNav $PathNav /E /IS