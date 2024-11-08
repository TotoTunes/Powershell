import-Module ActiveDirectory

#Function to connect to the O365 tennant
function M365_Connection {
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force
    Install-Module MSOnline
    Import-Module MSOnline
    Install-Module AzureAD
    Import-Module AzureAD
    
    switch ($selection) {
        1 {
            $LiveCred = Get-Credential
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
            $importresults = Import-PSSession $Session -AllowClobber
            Connect-MsolService -cred $LiveCred
            
            Install-Module AzureAD
            Connect-AzureAd -Credential $LiveCred
        }
        2 {
            $login = Read-Host "enter your login"
            Connect-AzureAd -AccountId $login
            Connect-ExchangeOnline -UserPrincipalName $login
            Connect-MsolService
        }
        Default {}
    }

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

Write-Host "Connecting to Office 365"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#M365_Connection
$login = Read-Host "enter your login"
Connect-AzureAd -AccountId $login
Connect-ExchangeOnline -UserPrincipalName $login
Connect-MsolService
Clear-Host

#Fixed paramaters
$Street = "Avenue Louise 250"
$PO_Box = "10"
$City = "Brussels"
$State = "Bruxelles-Capitale"
$ZipCode = "1050"
$Country = "BE"
$website = "www.simontbraun.eu"

#parameters for user creation
$firstname = Read-Host "Enter the first name"
while ($firstname -eq "") {
    $firstname = Read-Host "Enter the first name"
}

$Lastname = Read-Host "Enter the Last name"
while ($Lastname -eq "") {
   $Lastname = Read-Host "Enter the Last name"
}

$username = Read-Host "Enther the username"
while ($username -eq "") {
    $username = Read-Host "Enther the username"
}

$I = Read-Host "Enter the Initials for the user"
while ($I -eq "") {
    $I = Read-Host "Enter the Initials for the user"
}

$Initials = $I.ToUpper()
$Lastname_clean = $Lastname.Trim() -replace "\s"
$UPN = $firstname.ToLower()+"."+$Lastname_clean.ToLower()
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)

<#$Department = Read-Host "Enter the Departement of the new user"
while ($Department -eq "") {
    $Department = Read-Host "Enter the Departement of the new user"
}#>

$role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Associate, Reception or Student?)"
while ($role -eq "") {
    $role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Associate, Reception or Student?)"
}

$office = Read-Host "What is the office of the user?"
while ($office -eq "") {
    $office = Read-Host "What is the office of the user?"
}

$language = Read-Host "What is the language for the user? (NL or FR or UK)"
$LinkedIn = Read-Host "Paste the Linkedin URL here: "
while ($LinkedIn -eq "") {
    $LinkedIn = Read-Host "Paste the Linkedin URL here: " 
}

$Mobilephone = Read-Host "Enter mobile phone number"
while ($null -eq $Mobilephone -or $Mobilephone -eq "") {
    $Mobilephone = Read-Host "Enter mobile phone number"
}

$Phone = Read-Host "Enter DESK phone number"
while ($null -eq $Phone -or $Phone -eq "") {
    $Phone = Read-Host "Enter DESK phone number"
}

$password = Read-Host "enter the password for the new user" -AsSecureString
#$LawyerOu = "OU=$language,OU=$role,OU=Lawyers,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"
#$EmployeeOU = "OU=$Language,OU=Employees,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"

[int]$index = $example_user.DistinguishedName.IndexOf(",")
$OU= $example_user.DistinguishedName.Substring($index+1)
if ($OU.Substring(3,3).Replace(",","") -ne $Language)
{
    $Corrected_OU = $OU.Replace(($OU.Substring(3,3).Replace(",","")),$Language)
}


New-ADUser -Name $firstname" "$Lastname -Path $Corrected_OU -SamAccountName $username -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $City -State $State -Country $Country -PostalCode $ZipCode -Office $office -Surname $Lastname -GivenName $firstname -StreetAddress $Street -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu

Get-ADuser -identity $example_user.SamAccountName -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-ADUser -Identity $login -DisplayName $firstname" "$Lastname -ScriptPath $example_user.ScriptPath -HomePage $website -Initials $Initials.ToUpper() -Add @{Proxyaddresses = "SMTP:$UPN@simontbraun.eu"}
Set-ADUser -Identity $login -Description $role
Set-ADUser -Identity $login -Fax $example_user.Fax
Set-ADUser -Identity $login -POBox $PO_Box
$DeskPhone = $Phone.Insert(1," ")
Set-ADUser -Identity $login -HomePhone "+32 2 533 1$DeskPhone"
Set-ADUser -Identity $login -Title $role -Department $example_user.Department
Set-ADUser -Identity $login -MobilePhone $Mobilephone 


Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$UPN@simontbraun.be"}

Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$login@simontbraun.eu"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$login@simontbraun.be"}

Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.eu"}

$smtp=$firstname[0]+"."+$Lastname_clean
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.eu"}

$smtp2 = $firstname[0]+"."+$Lastname_clean[0]
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.eu"}

$smtp3 = $firstname+"."+ $Lastname[0]
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.eu"}

Set-ADUser -Identity $login -Add @{extensionAttribute1 = $Job}
Set-ADUser -Identity $login -Add @{extensionAttribute3 = $LinkedIn}
Set-ADUser -Identity $login -Add @{ipPhone =$Phone}
Set-ADUser -Identity $login -Add @{telephoneNumber ="+32 2 533 1$DeskPhone" }

Set-Location "\\braunbigwood.local\dfs\Personal"
mkdir $login

if ($role -eq "Lawyer" -or $role -eq "Partner") {
    $fileshare = "\\braunbigwood.local\dfs\Personal"
    $domain = "braunbigwood"
    createFolder $fileshare $login $domain
    Set-ADUser $login -HomeDirectory $fileshare+"\"+$login -HomeDrive "X:"
}

Set-Location "\\SIBDC02\c$\_Scripts"
.\DeltaSync.ps1

Write-Host "syncing... this may take up to 2 minutes" -ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 120

$AZ_New_User = Get-AzureADuser -SearchString $username
$AZ_Example_user = Get-AzureADUser -SearchString $example

$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId
Add-DistributionGroupMember -Identity "Signature 365 users" -Member "$username@simontbraun.eu" -Confirm:$false

$AZ_New_User = Get-AzureADuser -SearchString $username
$AZ_Example_user = Get-AzureADUser -SearchString $example

$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list) {
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.DisplayName "is AD synced" -ForegroundColor Blue -BackgroundColor White
    
    try {
            
        Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
        Write-Host "adding Azure AD group" -ForegroundColor Yellow
        Write-Host "user has been added to $typ.DisplayName"  -ForegroundColor Yellow
    }
    catch {
        Add-DistributionGroupMember -Identity $group.Mail -Member $AZ_New_User.UserPrincipalName
        Write-Host "adding DL" -ForegroundColor Yellow
        Write-Host "user has been added to $typ.DisplayName"  -ForegroundColor Yellow
    }
}

<#$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "Win10_VDA_E3"}).AccountSkuId
$user = Get-MsolUser -UserPrincipalName $login"@simontbraun.eu"
  if ($null -ne $user) {
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $licenses
  } else {
    Write-Output "User $displayName ($user.UserPrincipalName) not found."
  }

$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "O365_BUSINESS_ESSENTIALS"}).AccountSkuId
$user = Get-MsolUser -UserPrincipalName $login"@simontbraun.eu"
  if ($null -ne $user) {
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $licenses
  } else {
    Write-Output "User $displayName ($user.UserPrincipalName) not found."
  }
  #>