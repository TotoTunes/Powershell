function GetExampleUser ($ex) {

    Try {
        $AD = Get-ADUser $ex -Properties * -ErrorAction Stop
        Write-Host "User found" -ForegroundColor Green
        return $AD
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] { 
        Write-Host "User Not found" -ForegroundColor Red

        $example = Read-Host "Example user"
        GetExampleUser($example)

    }
    return $AD
    
}

Set-Variable -Name AIA -Value "OU=Users,OU=Agidens Infra Automation (AIA),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name BEL -Value "OU=Users,OU=Belasco (BEL),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name BEC -Value "OU=Users,OU=BESIX Connect (BEC),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name INF -Value "OU=Users,OU=BESIX Infra (INF),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name INL -Value "OU=Users,OU=BESIX Infra Nederland (INL),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name BIS -Value "OU=Users,OU=BESIX Infra Support (BIS),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly
Set-Variable -Name VDB -Value "OU=Users,OU=Van den Berg (VDB),OU=_BESIX-Schelle,DC=HBE,DC=local" -Option ReadOnly

