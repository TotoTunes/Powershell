import-Module ActiveDirectory

function GetExampleUser ($ex) {

    Try{
    $AD =  Get-ADUser $ex -ErrorAction Stop
    $AD = Get-ADUser $ex -properties *
    Write-Host "User found" -ForegroundColor Green
    return $AD
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    { 
     Write-Host "User Not found" -ForegroundColor Red
    
     $example = Read-Host "Example user"
     GetExampleUser($example)
    
    }
    return $AD
        
    }

$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$password = Read-Host "enter the password for the new user" -AsSecureString
$Job = Read-Host "Enter the Job title of the new user"
$regio = Read-Host "Where will the user be working? (e.g: VEVO)"
$OU = "OU=exchange,OU=Users,OU=VINCIPark,DC=vincibe,DC=lan"

New-ADUser -Name $firstname" "$Lastname -Path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname+" "+$Lastname -EmailAddress "$firstname.$lastname@group-indigo.com" -Office $regio -Surname $Lastname -GivenName $firstname -Enabled $true -UserPrincipalName $login@vincibe.lan

Set-ADUser -Identity $login -Description $Job -Title $Job -DisplayName $firstname" "$Lastname

Start-Sleep -Seconds 20

$copy = $example
$paste  = $login
get-ADuser -identity $copy -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $paste
Write-Host "user created and groups copied" -ForegroundColor Green