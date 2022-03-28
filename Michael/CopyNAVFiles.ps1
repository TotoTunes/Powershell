$Path = "C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Add-ins"
$Path1 = "$Env:UserProfile\AppData\Roaming\Microsoft\Microsoft Dynamics NAV\90"
$Source = "\\frigga01\sources$\Software\Microsoft\Dynamics NAV\Files\Add-ins"
$Source1 = "\\frigga01\sources$\Software\Microsoft\Dynamics NAV\Files\ClientUser"
robocopy $Source $Path /E /IS
robocopy $Source1 $Path1 /E /IS