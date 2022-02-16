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

$userUPN=$mail
$planName="ENTERPRISEPACK"
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

#function to get a valid user
function GetExampleUser ($ex) {

Try{
$AD =  Get-ADUser $ex -Properties * -ErrorAction Stop
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

#Function to create folder on \\CEL-FSV01\Users
function CreateFolder ($path,$username,$domain) {

    $fullpath = $path+"\"+$username
        Write-Host $fullpath
        $user = $domain+"\"+$username
        Write-Host $user
        $acl = get-acl -path $fullpath
        $new=$user,”FullControl”,”ContainerInherit,ObjectInherit”,”None”,”Allow”
        $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
        $acl.AddAccessRule($accessRule)
        $acl | Set-Acl $fullpath
        Write-Host "the folder $fullpath is created" -ForegroundColor Yellow
    }

#Fixed parameters that don't change
$OU = "OU=Gebruikers,DC=capricorn,DC=local"
$Domain = "capricorn"
$fileshare = "\\FP\Users"

Write-Host "Connecting to Office 365"
M365_Connection
cls

$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$password = Read-Host "enter the password for the new user" -AsSecureString
$website = "www.capricorn.be"

New-ADUser -Name $firstname" "$Lastname -Path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $login@capricorn.be -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@capricorn.be
Start-Sleep -Seconds 10 
Set-ADUser -Identity $login -DisplayName $firstname" "$Lastname -HomePage $website -Manager $manager -Add @{Proxyaddresses = "SMTP:$login@capricorn.be";}

Write-Host "$login is created." 
Start-Sleep -Seconds 5
get-ADuser -identity $example_user -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-Location \\FP\Users
mkdir $login
createFolder $fileshare $login $domain
Pause

Write-Host "Starting Sync to O365" -ForegroundColor DarkCyan
Write-Host " "
cd "\\DC1\C$\temp"
.\DeltaSync.ps1

Write-Host "syncing... this may take up to 2 minutes" -ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 120

$AZ_New_User = Get-AzureADuser -SearchString $login

#AssingLicenses($AZ_New_User.UserPrincipalName)

$AZ_Example_user = Get-AzureADUser -SearchString $example 
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list){
$group.DisplayName

Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -ErrorAction Stop
}