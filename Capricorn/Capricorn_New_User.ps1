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

#region function to get a valid user
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
#endregion
#Function to create folder on \\FP\Users
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
#Set-Variable -Name Boston -Value "OU=Celyad,OU=Users,OU=Boston,DC=medpole,DC=local" -Option ReadOnly
Set-Variable -Name "OU" -Option ReadOnly -Value "OU=Gebruikers,DC=capricorn,DC=local"
Set-Variable -Name "Domain" -Option Constant -Value "Capricorn"
Set-Variable -Name "filshare" -Option Constant -Value "\\FP\Users"
<#$OU = "OU=Gebruikers,DC=capricorn,DC=local"
$Domain = "capricorn"
$fileshare = "\\FP\Users"#>

Write-Host "Connecting to Office 365"
M365_Connection
Clear-Host

$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$letters = (65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}
$numbers = (65..90) + (97..122) | Get-Random -Count 5
$password = ($letters+$numbers) -AsSecureString

New-ADUser -Name $firstname" "$Lastname -path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $login@Capricorn.be -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname ´
-GivenName $firstname -Company $example_user.Company ´
-Enabled $true -UserPrincipalName $login@capricorn.be

Start-Sleep -Seconds 10

Set-ADUser -Identity $login -DisplayName $firstname" "$Lastname -HomePage $website -Add @{Proxyaddresses = "SMTP:$login@capricorn.be";}

Write-Host "$login is created." 
Start-Sleep -Seconds 5
get-ADuser -identity $example_user -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-Location \\CEL-fsv01\Users
mkdir $login
createFolder $fileshare $login $domain
Pause