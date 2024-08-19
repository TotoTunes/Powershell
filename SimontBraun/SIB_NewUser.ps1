import-Module ActiveDirectory

#Function to connect to the O365 tennant
function M365_Connection {
    Install-Module MSOnline
    Import-Module MSOnline
    Install-Module AzureAD
    Import-Module AzureAD
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers
    $LiveCred = Get-Credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
    $importresults = Import-PSSession $Session -AllowClobber
    Connect-MsolService -cred $LiveCred
    Install-Module AzureAD
    Connect-AzureAd -Credential $LiveCred
    Connect-ExchangeOnline -cred $LiveCred

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
    $new = $user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
    $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
    $acl.AddAccessRule($accessRule)
    $acl | Set-Acl $fullpath
    Write-Host "the folder $fullpath is created" -ForegroundColor Yellow
}

Write-Host "Connecting to Office 365"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#M365_Connection
Write-host "Select if you want to connect with an MFA enabled account or not"
Write-Host "Select 1 for regular account"
Write-Host "Select 2 for MFA account"
$selection = Read-Host "Select 1 or 2: "

switch ($selection) {
    1 {
        M365_Connection
    }
    2 {
        $cred = Get-Credential
        $login = $cred.UserName.ToString()
        #$cred = ConvertTo-SecureString -String $login.ToString()
        Connect-AzureAd -AccountId $login
        Connect-ExchangeOnline -UserPrincipalName $login
        Connect-MsolService -Credential $cred
    
    }
    Default {}
}
Clear-Host

#Fixed paramaters
$Street = "Avenue Louise 250"
$PO_Box = "10"
$City = "Brussels"
$State = "Bruxelles-Capitale"
$ZipCode = "1050"
$Country = "BE"

#parameters for user creation
$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$I = Read-Host "Enter the Initials for the user"
$Initials = $I.ToUpper()
$Lastname_clean = $Lastname.Trim() -replace "\s"
$UPN = $firstname.ToLower()+"."+$Lastname_clean.ToLower()
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)

<#$Job = Read-Host "Enter the Job title of the new user"
while ($Job -eq "") {
    $Job = Read-Host "Enter the Job title of the new user"
}#>

$office = Read-Host "What is the office of the user?"
while ($office -eq "") {
    $office = Read-Host "What is the office of the user?"
}

$language = Read-Host "What is the language for the user? (NL or FR or UK)"
$role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Employee, Reception)"
$LinkedIn = Read-Host "Paste the Linkedin URL here: "

$Mobilephone = Read-Host "Enter mobile phone number"
while ($null -eq $Mobilephone -or $Mobilephone -eq "") {
    $Mobilephone = Read-Host "Enter mobile phone number"
}

$Phone = Read-Host "Enter DESK phone number"
while ($null -eq $Phone -or $Phone -eq "") {
    $Phone = Read-Host "Enter DESK phone number"
}

$password = Read-Host "enter the password for the new user" -AsSecureString
$website = "www.simontbraun.eu"
#$LawyerOu = "OU=$language,OU=$role,OU=Lawyers,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"
#$EmployeeOU = "OU=$Language,OU=Employees,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"

$index = $example_user.DistinguishedName.IndexOf(",")
$OU= $example_user.DistinguishedName.Substring($index+1)

New-ADUser -Name $firstname" "$Lastname -Path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $City -State $State -Country $Country -PostalCode $ZipCode -Office $office -Surname $Lastname -GivenName $firstname -StreetAddress $Street -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu

Get-ADuser -identity $example_user.SamAccountName -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-ADUser -Identity $login -DisplayName $firstname" "$Lastname -ScriptPath $example_user.ScriptPath -HomePage $website -Initials $Initials.ToUpper() -Add @{Proxyaddresses = "SMTP:$UPN@simontbraun.eu"}
Set-ADUser -Identity $login -Description $role
Set-ADUser -Identity $login -Fax $example_user.Fax
Set-ADUser -Identity $login -POBox $PO_Box
$DeskPhone = $Phone.Substring(0,1) + " "+ $Phone.Substring(1,2)
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

Set-ADUser -Identity $login -Replace @{extensionAttribute1 = $role}
Set-ADUser -Identity $login -Replace @{extensionAttribute3 = $LinkedIn}
Set-ADUser -Identity $login -Replace @{ipPhone =$DeskPhone }
Set-ADUser -Identity $login -Replace @{telephoneNumber ="+32 2 533 1$DeskPhone" }

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

$AZ_New_User = Get-AzureADuser -SearchString $login"@simontbraun.eu"
$AZ_Example_user = Get-AzureADUser -SearchString $example"@simontbraun.eu"

$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list) {
    $group.Mail
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.DisplayName "is AD synced"
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
Add-DistributionGroupMember -Identity "Signature 365 users" -Member "$login@simontbraun.eu" -Confirm:$false
<#$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "Win10_VDA_E3"}).AccountSkuId
$user = Get-MsolUser -UserPrincipalName $login"@simontbraun.eu"
  if ($null -ne $user) {
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $licenses
  } else {
    Write-Output "User $displayName ($user.UserPrincipalName) not found."
  }#>

$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "SPB"}).AccountSkuId
$user = Get-MsolUser -UserPrincipalName $login"@simontbraun.eu"
  if ($null -ne $user) {
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $licenses
  } else {
    Write-Output "User $displayName ($user.UserPrincipalName) not found."
  }
