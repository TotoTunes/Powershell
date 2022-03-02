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

#function to assign licenses (E3 and Microsoft Defender for O365)
function AssingLicenses ($mail) {

    $userUPN = $mail
    $planName = "ENTERPRISEPACK"
    $planName2 = "ATP_ENTERPRISE"
    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName -EQ).SkuID
    $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $LicensesToAssign.AddLicenses = $License

    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $LicensesToAssign

    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $planName2 -EQ).SkuID
    $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $LicensesToAssign.AddLicenses = $License

    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $LicensesToAssign
    
}

#region function to get a valid user
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
#endregion
#Function to create folder on \\CEL-FSV01\Users
function CreateFolder ($path, $username, $domain) {

    $fullpath = $path + "\" + $username
    Write-Host $fullpath
    $user = $domain + "\" + $username
    Write-Host $user
    $acl = get-acl -path $fullpath
    $new = $user, ”FullControl”, ”ContainerInherit,ObjectInherit”, ”None”, ”Allow”
    $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
    $acl.AddAccessRule($accessRule)
    $acl | Set-Acl $fullpath
    Write-Host "the folder $fullpath is created" -ForegroundColor Yellow
}

#Fixed parameters that don't change
#Set-Variable -Name Boston -Value "OU=Celyad,OU=Users,OU=Boston,DC=medpole,DC=local" -Option ReadOnly
$Boston = "OU=Celyad,OU=Users,OU=Boston,DC=medpole,DC=local"
$Belgium = "OU=Celyad,OU=SBSUsers,OU=Users,OU=MyBusiness,DC=medpole,DC=local"
$Domain = "medpole"
$fileshare = "\\cel-fsv01\Users"

Write-Host "Connecting to Office 365"
M365_Connection
Clear-Host

#parameters for user creation
$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$Job = Read-Host "Enter the Job title of the new user"
$man = Read-Host "What is the username of the manager?"
$manager = GetExampleUser($man)
$password = Read-Host "enter the password for the new user" -AsSecureString
$website = "www.celyad.com"
$USA = Read-Host "Is the user located in the USA? (Y/N)"

if ($USA -eq "Y") {

    New-ADUser -Name $firstname" "$Lastname -Path $Boston -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $login@celyad.com -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@celyad.com

} 
else {

    New-ADUser -Name $firstname" "$Lastname -Path $Belgium -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $login@celyad.com -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@celyad.com

}

Start-Sleep -Seconds 10 

Set-ADUser -Identity $login -Description $Job -Title $Job -Department $example_user.Department -DisplayName $firstname" "$Lastname -ScriptPath $example_user.ScriptPath -HomePage $website -Manager $manager -Add @{Proxyaddresses = "SMTP:$login@celyad.com"; }
Write-Host "$login is created." 
Start-Sleep -Seconds 5
get-ADuser -identity $example_user -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-Location \\CEL-fsv01\Users
mkdir $login
createFolder $fileshare $login $domain
Pause

Write-Host "Starting Sync to O365" -ForegroundColor DarkCyan
Write-Host " "
Set-Location "\\CEL-DOM01\C$\Users\Public\Public Desktop"
.\DeltaSync.ps1

Write-Host "syncing... this may take some time" -ForegroundColor Yellow -BackgroundColor Black
#Start-Sleep -Seconds 180

for ($i = 0; $i -lt 180; $i++) {
    
    $i++
    Start-Sleep -Seconds 1
    Write-Progress -PercentComplete $i -Activity "Syncing" -SecondsRemaining (180 - $i)
}



$AZ_New_User = Get-AzureADuser -SearchString "temp01"


$AZ_Example_user = Get-AzureADUser -SearchString "igennart" 
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list) {
    $group.Mail
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.MailNickName
    if ($typ.DirSyncEnabled -eq $false) {
        try {
            Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
            Write-Host "adding Azure AD group" -ForegroundColor Yellow
        }
        catch {
            Add-DistributionGroupMember -Identity $group.Mail -Member $AZ_New_User.UserPrincipalName
            Write-Host "adding DL" -ForegroundColor Yellow
        }
    }

}

<#
$acl = get-acl -path $fileshare
$new=$user,”FullControl”,”ContainerInherit,ObjectInherit”,”None”,”Allow”
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
$acl.AddAccessRule($accessRule)
$acl | Set-Acl $dfsfolder
#>