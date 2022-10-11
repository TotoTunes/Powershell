import-Module ActiveDirectory

#Function to connect to the O365 tennant
function M365_Connection {
    Install-Module MSOnline
    Import-Module MSOnline
    Install-Module AzureAD
    Import-Module AzureAD
    $LiveCred = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
    $importresults = Import-PSSession $Session -AllowClobber
    Connect-MsolService -cred $LiveCred

    Install-Module AzureAD
    Connect-AzureAd -Credential $LiveCred

}

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

$OU = "OU=Celyad,OU=SBSUsers,OU=Users,OU=MyBusiness,DC=medpole,DC=local"

#parameters for user creation
$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username (first letter of firstname + lastname)"
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$Job = Read-Host "Enter the Job title of the new user"
$password = Read-Host "enter the password for the new user" -AsSecureString


New-ADUser -Name $firstname" "$Lastname -Path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $login@liberalforum.eu -Surname $Lastname -GivenName $firstname -Enabled $true

Start-Sleep -Seconds 10 

Set-ADUser -Identity $login -Description $Job -Title $Job -DisplayName $firstname" "$Lastname -ScriptPath $example_user.ScriptPath
Write-Host "$login is created." 

M365_Connection

New-AzADUser -DisplayName $firstname" "$Lastname -MailNickname $login@liberalforum.eu -Mail $login@liberalforum.eu -AccountEnabled $true -GivenName $firstname -Surname $Lastname -JobTitle $Job -UserPrincipalName $login@liberalforum.eu -UserType "Member"

$AZ_Example_user = Get-MsolUser -UserPrincipalName $example@liberalforum.eu
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($gr in $group_list) 
{
    $gr.Mail
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.MailNickName
        try {
            Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
            Write-Host "adding Azure AD group" -ForegroundColor Yellow
        }
        catch {
            Add-DistributionGroupMember -Identity $group.Mail -Member $AZ_New_User.UserPrincipalName
            Write-Host "adding DL" -ForegroundColor Yellow
        }
}