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

Write-Host "Connecting to Office 365"
#M365_Connection
Clear-Host

#parameters for user creation
$firstname = Read-Host "Enter the first name"
$Lastname = Read-Host "Enter the Last name"
$login = Read-Host "Enther the username"
$I = Read-Host "Enter the Initials for the user"
$Initials = $I.ToUpper()
$UPN = $firstname+"."+$Lastname
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)
$Job = Read-Host "Enter the Job title of the new user"
while ($Job -eq "") {
    $Job = Read-Host "Enter the Job title of the new user"
}
$office = Read-Host "What is the office of the user?"
while ($office -eq "") {
    $office = Read-Host "What is the office of the user?"
}
$language = Read-Host "What is the language for the user? (NL or FR or UK)"
#$role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Employee, Reception)"
$LinkedIn = Read-Host "Paste the Linkedin URL here: "
$Mobilephone = Read-Host "Enter mobile phone number"
while ($null -eq $Mobilephone -or $Mobilephone -eq "") {
    $Mobilephone = Read-Host "Enter mobile phone number"
}
$DeskPhone = Read-Host "Enter DESK phone number"
while ($null -eq $DeskPhone -or $DeskPhone -eq "") {
    $DeskPhone = Read-Host "Enter DESK phone number"
}

$password = Read-Host "enter the password for the new user" -AsSecureString
$website = "www.simontbraun.eu"
#$LawyerOu = "OU=$language,OU=$role,OU=Lawyers,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"
#$EmployeeOU = "OU=$Language,OU=Employees,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local"

$index = $example_user.DistinguishedName.IndexOf(",")
$OU= $example_user.DistinguishedName.Substring($index+1)

New-ADUser -Name $firstname" "$Lastname -Path $OU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -State $example_user.State -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu

<#switch ($role) {
    1 {    
        New-ADUser -Name $firstname" "$Lastname -Path $LawyerOu -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu
    }
    2 {
        New-ADUser -Name $firstname" "$Lastname -Path $LawyerOu -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu
    }
    3 {
        New-ADUser -Name $firstname" "$Lastname -Path $LawyerOu -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu
    }
    4 {
        New-ADUser -Name $firstname" "$Lastname -Path $EmployeeOU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu
    }
    5 {
        New-ADUser -Name $firstname" "$Lastname -Path $EmployeeOU -SamAccountName $login -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $example_user.City -Country $example_user.Country -PostalCode $example_user.PostalCode -Office $example_user.Office -Surname $Lastname -GivenName $firstname -Company $example_user.Company -Enabled $true -UserPrincipalName $login@simontbraun.eu
    }
    Default {}
}#>

#OU=FR,OU=Partners,OU=Lawyers,OU=Personal,OU=SimontBraun,DC=braunbigwood,DC=local




Set-ADUser -Identity $login -DisplayName $firstname" "$Lastname -ScriptPath $example_user.ScriptPath -HomePage $website -Initials $Initials.ToUpper() -Add @{Proxyaddresses = "SMTP:$login@simontbraun.eu"}
Set-ADUser -Identity $login -Description $Job
Set-ADUser -Identity $login -Fax $example_user.Fax
Set-ADUser -Identity $login -POBox $example_user.POBox
Set-Aduser -Identity $login -Street $example_user.Street
Set-ADUser -Identity $login -HomePhone "+32 2 533 1$DeskPhone"
Set-ADUser -Identity $login -Title $Job -Department $example_user.Department
Set-ADUser -Identity $login -MobilePhone $Mobilephone 

Set-ADUser -Identity $login -Add @{Proxyaddresses = "SMTP:$login@simontbraun.eu"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$login@simontbraun.be"}

Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$UPN@simontbraun.eu"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$UPN@simontbraun.be"}

Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.eu"}
$smtp=$firstname[0]+"."+$Lastname
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.eu"}
$smtp2 = $firstname[0]+"."+$Lastname[0]
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.eu"}
$smtp3 = $firstname+"."+ $Lastname[0]
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.be"}
Set-ADUser -Identity $login -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.eu"}
Set-ADUser -Identity $login -Replace @{extensionAttribute1 = $Job}
Set-ADUser -Identity $login -Replace @{extensionAttribute3 = $LinkedIn}
Set-ADUser -Identity $login -Replace @{ipPhone =$DeskPhone }
Set-ADUser -Identity $login -Replace @{telephoneNumber ="+32 2 533 1$DeskPhone" }