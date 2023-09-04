import-Module ActiveDirectory


function M365_Connection {
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers
    Install-Module MSOnline
    Import-Module MSOnline
    Install-Module AzureAD
    Import-Module AzureAD
    Write-host "Select if you want to connect with an MFA enabled account or not"
    Write-Host "Select 1 for regular account"
    Write-Host "Select 2 for MFA account"
    $selection = Read-Host "Select 1 or 2: "
    
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
    Write-host $AD.UserPrincipalName
    return $AD   
}

function CreateFolder ($path,$username,$domain) {

        $fullpath = $path+"\"+$username
            Write-Host $fullpath
            $user = $domain+"\"+$username
            Write-Host $user
            $acl = get-acl -path $fullpath
            $new=$user,"FullControl","ContainerInherit,ObjectInherit","None","Allow"
            $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
            $acl.AddAccessRule($accessRule)
            $acl | Set-Acl $fullpath
            Write-Host "the folder $fullpath is created" -ForegroundColor Yellow
}

Set-Variable -Name "OU" -Option ReadOnly -Value "OU=Gebruikers,DC=capricorn,DC=local"
Set-Variable -Name "Domain" -Option Constant -Value "Capricorn"
Set-Variable -Name "fileshare" -Option Constant -Value "\\FP\Users"

Write-Host "Connecting to Office 365"
M365_Connection
Clear-Host

$Firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
Write-host "Enther the username (first.lastname all small letters)" -ForegroundColor Re
$login = Read-Host 
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$letters = (65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_}
$numbers = (65..90) + (97..122) | Get-Random -Count 5
$password = [string]($letters+$numbers+"!")
$SecurePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

Try{
    $AD =  Get-ADUser $Firstname -Properties * -ErrorAction Stop
    Write-Host "User already exists" -ForegroundColor Red
    exit
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    { 
     Write-Host "Login is available" -ForegroundColor Green
    }

New-ADUser -Name $Firstname" "$Lastname -path $OU -SamAccountName $login -AccountPassword $SecurePassword ´
-DisplayName $Firstname" "$Lastname -EmailAddress $login@capricorn.be ´
-City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode ´
-Office $example_user.Office -Surname $Lastname ´
-GivenName $Firstname -Company $example_user.Company ´
-Enabled $true -UserPrincipalName $login@capricorn.be

Start-Sleep -Seconds 10

Set-ADUser -Identity $login -DisplayName $Firstname" "$Lastname -HomePage $website -Add @{Proxyaddresses = "SMTP:$login@capricorn.be";}
$f = $Firstname.ToLower()
Set-Aduser -Identity $login -Add @{Proxyaddresses = "smtp:$f@capricorn.be";}

Write-Host "$login is created." 
Start-Sleep -Seconds 5
get-ADuser -identity $example_user -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login

Set-Location \\FP\Users
mkdir $login
createFolder $fileshare $login $domain
Pause

Write-Host "Starting Sync to O365" -ForegroundColor DarkCyan
Write-Host " "
Set-Location "\\DC1\C$\temp"
.\DeltaSync.ps1

Write-Host "syncing... this may take up to 2 minutes" -ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 120

$AZ_New_User = Get-AzureADuser -SearchString $login
$AZ_Example_user = Get-AzureADUser -SearchString $example 

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

$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "SPE_E3"}).AccountSkuId
$user = Get-MsolUser -UserPrincipalName $login"@capricorn.be"
  if ($user -ne $null) {
    Set-MsolUserLicense -UserPrincipalName "$login@capricorn.be" -AddLicenses $licenses
  } else {
    Write-Output "User $displayName (""$login@capricorn.be"") not found."
  }