function AddUserToGroup ($Users, $Group) 
{

    foreach ($u in $Users)
    {
        Add-ADGroupMember -Identity $Group -Members $u -whatif
    }
    
}

$AgidensOU = "OU=Users,OU=Agidens Infra Automation (AIA),OU=_BESIX-Schelle,DC=HBE,DC=local"
$BesixConnectOU = "OU=Users,OU=BESIX Connect (BEC),OU=_BESIX-Schelle,DC=HBE,DC=local"
$B6InfraSupportOU = "OU=Users,OU=BESIX Infra Support (BIS),OU=_BESIX-Schelle,DC=HBE,DC=local"
$ADgroup = "SGG_VDB_APP_TEKENBUREEL"

Write-Host "Adding Agidens Users" -ForegroundColor Green
$AgidensUsers = Get-AdUser -Filter * -Searchbase $AgidensOU
AddUserToGroup($AgidensUsers,$ADgroup)

Write-Host "Adding Besix Connect Users" -ForegroundColor Green
$BesixConnectUsers = Get-AdUser -Filter * -Searchbase $BesixConnectOU
AddUserToGroup($BesixConnectUsers,$ADgroup)

Write-Host "Adding B6 Infra support Users" -ForegroundColor Green
$B6InfrasupportUsers = Get-AdUser -Filter * -Searchbase $B6InfraSupportOU
AddUserToGroup($B6InfrasupportUsers,$ADgroup)