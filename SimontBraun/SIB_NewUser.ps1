import-Module ActiveDirectory

#Function to connect to the O365 tennant
function M365_Connection {
    $login = Read-Host "enter your login"
    Install-Module -Name ExchangeOnlineManagement -Scope AllUsers -Force -RequiredVersion 3.5.1 -Force
    Install-Module MSOnline
    Import-Module MSOnline
    Install-Module AzureAD
    Import-Module AzureAD
    Connect-AzureAd -AccountId $login
    Connect-ExchangeOnline -UserPrincipalName $login
    Connect-MsolService
    cls
}

#function to remove special letters from the names (eg: ê, ë, à, ü,...)
function Remove-StringDiacritic {
    <#
.SYNOPSIS
    This function will remove the diacritics (accents) characters from a string.

.DESCRIPTION
    This function will remove the diacritics (accents) characters from a string.

.PARAMETER String
    Specifies the String(s) on which the diacritics need to be removed

.PARAMETER NormalizationForm
    Specifies the normalization form to use
    https://msdn.microsoft.com/en-us/library/system.text.normalizationform(v=vs.110).aspx

.EXAMPLE
    PS C:\> Remove-StringDiacritic "L'été de Raphaël"

    L'ete de Raphael

.NOTES
    Francois-Xavier Cat
    @lazywinadmin
    lazywinadmin.com
    github.com/lazywinadmin
#>
    [CMdletBinding()]
    PARAM
    (
        [ValidateNotNullOrEmpty()]
        [Alias('Text')]
        [System.String[]]$String,
        [System.Text.NormalizationForm]$NormalizationForm = "FormD"
    )

    FOREACH ($StringValue in $String) {
        Write-Verbose -Message "$StringValue"
        try {
            # Normalize the String
            $Normalized = $StringValue.Normalize($NormalizationForm)
            $NewString = New-Object -TypeName System.Text.StringBuilder

            # Convert the String to CharArray
            $normalized.ToCharArray() |
                ForEach-Object -Process {
                    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($psitem) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
                        [void]$NewString.Append($psitem)
                    }
                }

            #Combine the new string chars
            Write-Output $($NewString -as [string])
        }
        Catch {
            Write-Error -Message $Error[0].Exception.Message
        }
    }
}

#function to start logging
function Start-Logging {
    $CurrentDateTime = Get-Date -Format "dd-MM-yyyy_HH-mm"
    $FileNameBase = "NewUserLogs"
    $FileExtension = "txt"
    $logpath = "C:\temp\"
    $FileName = "$($FileNameBase)_$($CurrentDateTime).$($FileExtension)"
    $logfile = $logpath + $FileName
    New-Item -Path $logpath -Name $FileName -ItemType File
    Start-Transcript -Path $logfile -Append
    Write-Host "Logging started" -ForegroundColor Green
    return "$($logpath)$($FileNameBase)_$($CurrentDateTime).$($FileExtension)"
}

#function to get the example user + check if user is in disabled OU or not
function GetExampleUser ($ex) {

    Try {
        $AD = Get-ADUser $ex -Properties * -ErrorAction Stop
        if ( $AD.DistinguishedName -like "*Shared Mailbox*" -or $AD.DistinguishedName -like "*Disabled users*") {
            Write-Host "user has been disabled, please choose an active user"
            $example = Read-Host "Enter the example user"
            GetExampleUser($example)
        }
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

# function to check if the new username is already taken or not
function CheckUsername ($ex) {
    $ex = Remove-StringDiacritic -String $ex

    Try {
        $AD = Get-ADUser $ex -Properties * -ErrorAction Stop
        Write-Host "Username already exists" -ForegroundColor Red
        $userlogin = Read-Host "Enther the username"
        CheckUsername($userlogin)
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] { 
        Write-Host "Username is free" -ForegroundColor Green
        $AD = $ex
        return $AD
    }
} 
#Function to create a folder on the SIB server
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

function Inputscreen{Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Information"
$form.Size = New-Object System.Drawing.Size(450, 600)  # Increased height
$form.StartPosition = "CenterScreen"

# Uniform width for all textboxes
$textboxWidth = 250

# Create labels
$labelFirstName = New-Object System.Windows.Forms.Label
$labelFirstName.Location = New-Object System.Drawing.Point(20, 20)
$labelFirstName.Size = New-Object System.Drawing.Size(100, 20)
$labelFirstName.Text = "First Name:"
$form.Controls.Add($labelFirstName)

$labelLastName = New-Object System.Windows.Forms.Label
$labelLastName.Location = New-Object System.Drawing.Point(20, 60)
$labelLastName.Size = New-Object System.Drawing.Size(100, 20)
$labelLastName.Text = "Last Name:"
$form.Controls.Add($labelLastName)

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Location = New-Object System.Drawing.Point(20, 100)
$labelUsername.Size = New-Object System.Drawing.Size(100, 20)
$labelUsername.Text = "Username:"
$form.Controls.Add($labelUsername)

$labelStreet = New-Object System.Windows.Forms.Label
$labelStreet.Location = New-Object System.Drawing.Point(20, 180)
$labelStreet.Size = New-Object System.Drawing.Size(100, 20)
$labelStreet.Text = "Street:"
$form.Controls.Add($labelStreet)

$labelPOBox = New-Object System.Windows.Forms.Label
$labelPOBox.Location = New-Object System.Drawing.Point(20, 220)
$labelPOBox.Size = New-Object System.Drawing.Size(100, 20)
$labelPOBox.Text = "PO Box:"
$form.Controls.Add($labelPOBox)

$labelCity = New-Object System.Windows.Forms.Label
$labelCity.Location = New-Object System.Drawing.Point(20, 260)
$labelCity.Size = New-Object System.Drawing.Size(100, 20)
$labelCity.Text = "City:"
$form.Controls.Add($labelCity)

$labelState = New-Object System.Windows.Forms.Label
$labelState.Location = New-Object System.Drawing.Point(20, 300)
$labelState.Size = New-Object System.Drawing.Size(100, 20)
$labelState.Text = "State:"
$form.Controls.Add($labelState)

$labelZipCode = New-Object System.Windows.Forms.Label
$labelZipCode.Location = New-Object System.Drawing.Point(20, 340)
$labelZipCode.Size = New-Object System.Drawing.Size(100, 20)
$labelZipCode.Text = "Zip Code:"
$form.Controls.Add($labelZipCode)

$labelCountry = New-Object System.Windows.Forms.Label
$labelCountry.Location = New-Object System.Drawing.Point(20, 380)
$labelCountry.Size = New-Object System.Drawing.Size(100, 20)
$labelCountry.Text = "Country:"
$form.Controls.Add($labelCountry)

$labelWebsite = New-Object System.Windows.Forms.Label
$labelWebsite.Location = New-Object System.Drawing.Point(20, 420)
$labelWebsite.Size = New-Object System.Drawing.Size(100, 20)
$labelWebsite.Text = "Website:"
$form.Controls.Add($labelWebsite)

$labelFax = New-Object System.Windows.Forms.Label
$labelFax.Location = New-Object System.Drawing.Point(20, 460)
$labelFax.Size = New-Object System.Drawing.Size(100, 20)
$labelFax.Text = "Fax:"
$form.Controls.Add($labelFax)

# Create textboxes with uniform width and prefilled values
$textBoxFirstName = New-Object System.Windows.Forms.TextBox
$textBoxFirstName.Location = New-Object System.Drawing.Point(130, 20)
$textBoxFirstName.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxFirstName)

$textBoxLastName = New-Object System.Windows.Forms.TextBox
$textBoxLastName.Location = New-Object System.Drawing.Point(130, 60)
$textBoxLastName.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxLastName)

$textBoxUsername = New-Object System.Windows.Forms.TextBox
$textBoxUsername.Location = New-Object System.Drawing.Point(130, 100)
$textBoxUsername.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxUsername)

$textBoxStreet = New-Object System.Windows.Forms.TextBox
$textBoxStreet.Location = New-Object System.Drawing.Point(130, 180)
$textBoxStreet.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxStreet.Text = "Avenue Louise 250"
$form.Controls.Add($textBoxStreet)

$textBoxPOBox = New-Object System.Windows.Forms.TextBox
$textBoxPOBox.Location = New-Object System.Drawing.Point(130, 220)
$textBoxPOBox.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxPOBox.Text = "10"
$form.Controls.Add($textBoxPOBox)

$textBoxCity = New-Object System.Windows.Forms.TextBox
$textBoxCity.Location = New-Object System.Drawing.Point(130, 260)
$textBoxCity.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxCity.Text = "Brussels"
$form.Controls.Add($textBoxCity)

$textBoxState = New-Object System.Windows.Forms.TextBox
$textBoxState.Location = New-Object System.Drawing.Point(130, 300)
$textBoxState.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxState.Text = "Bruxelles-Capitale"
$form.Controls.Add($textBoxState)

$textBoxZipCode = New-Object System.Windows.Forms.TextBox
$textBoxZipCode.Location = New-Object System.Drawing.Point(130, 340)
$textBoxZipCode.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxZipCode.Text = "1050"
$form.Controls.Add($textBoxZipCode)

$textBoxCountry = New-Object System.Windows.Forms.TextBox
$textBoxCountry.Location = New-Object System.Drawing.Point(130, 380)
$textBoxCountry.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxCountry.Text = "BE"
$form.Controls.Add($textBoxCountry)

$textBoxWebsite = New-Object System.Windows.Forms.TextBox
$textBoxWebsite.Location = New-Object System.Drawing.Point(130, 420)
$textBoxWebsite.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxWebsite.Text = "www.simontbraun.eu"
$form.Controls.Add($textBoxWebsite)

$textBoxFax = New-Object System.Windows.Forms.TextBox
$textBoxFax.Location = New-Object System.Drawing.Point(130, 460)
$textBoxFax.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxFax.Text = "+32 2 522 17 90"
$form.Controls.Add($textBoxFax)

# Create the "Check Username" button below the username field
$buttonCheckUsername = New-Object System.Windows.Forms.Button
$buttonCheckUsername.Location = New-Object System.Drawing.Point(130, 130)
$buttonCheckUsername.Size = New-Object System.Drawing.Size($textboxWidth, 25)
$buttonCheckUsername.Text = "Check Username"
$buttonCheckUsername.BackColor = [System.Drawing.Color]::LightBlue
$buttonCheckUsername.Add_Click({
    $username = $textBoxUsername.Text
    if ($username) {
        [System.Windows.Forms.MessageBox]::Show("Checking username: $username", "Info")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a username.", "Error")
    }
})
$form.Controls.Add($buttonCheckUsername)

# Create "Create User" and "Cancel" buttons at the bottom, centered
$buttonCreateUser = New-Object System.Windows.Forms.Button
$buttonCreateUser.Location = New-Object System.Drawing.Point(100, 520)
$buttonCreateUser.Size = New-Object System.Drawing.Size(120, 30)
$buttonCreateUser.Text = "Create User"
$buttonCreateUser.BackColor = [System.Drawing.Color]::Green
$buttonCreateUser.ForeColor = [System.Drawing.Color]::White
$buttonCreateUser.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("User created successfully!", "Success")
})
$form.Controls.Add($buttonCreateUser)

$buttonCancel = New-Object System.Windows.Forms.Button
$buttonCancel.Location = New-Object System.Drawing.Point(230, 520)
$buttonCancel.Size = New-Object System.Drawing.Size(120, 30)
$buttonCancel.Text = "Cancel"
$buttonCancel.BackColor = [System.Drawing.Color]::Red
$buttonCancel.ForeColor = [System.Drawing.Color]::White
$buttonCancel.Add_Click({
    $form.Close()
})
$form.Controls.Add($buttonCancel)

# Show the form
$form.ShowDialog()

}

Write-Host "Connecting to Office 365"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$logs = Start-Logging
#M365_Connection

#Fixed paramaters
$Street = "Avenue Louise 250"
$PO_Box = "10"
$City = "Brussels"
$State = "Bruxelles-Capitale"
$ZipCode = "1050"
$Country = "BE"
$website = "www.simontbraun.eu"
$Fax = "+32 2 533 17 90"

#parameters for user creation
$firstname = Read-Host "Enter the first name"
while ($firstname -eq "") {
    $firstname = Read-Host "Enter the first name"
}

$Lastname = Read-Host "Enter the Last name"
while ($Lastname -eq "") {
   $Lastname = Read-Host "Enter the Last name"
}

$userlogin = Read-Host "Enther the username"
$username = CheckUsername($userlogin)

$I = Read-Host "Enter the Initials for the user"
while ($I -eq "") {
    $I = Read-Host "Enter the Initials for the user"
}


#set initials to capital letters
$Initials = $I.ToUpper()

#clean up last name
$Lastname_clean = $Lastname.Trim() -replace "\s"

#remove capital letters from first and last name
$UPN = $firstname.ToLower()+"."+$Lastname_clean.ToLower()
$example = Read-Host "Example user"
$example_user = GetExampleUser($example)


<#$role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Associate, Reception or Student?)"
while ($role -eq "") {
    $role = Read-Host "What is the role of the user? (Lawyer, Counsel, Partner, Associate, Reception or Student?)"
}#>

$office = Read-Host "What is the office of the user?"
while ($office -eq "") {
    $office = Read-Host "What is the office of the user?"
}

$language = Read-Host "What is the language for the user? (NL or FR or UK)"


$Phone = Read-Host "Enter DESK phone number"
while ($null -eq $Phone -or $Phone -eq "") {
    $Phone = Read-Host "Enter DESK phone number"
}


$password = Read-Host "enter the password for the new user" -AsSecureString

#steps to place the user in the correct OU based on their language
[int]$index = $example_user.DistinguishedName.IndexOf(",")
$OU= $example_user.DistinguishedName.Substring($index+1)
if ($OU.Substring(3,3).Replace(",","") -ne $Language)
{
    $Corrected_OU = $OU.Replace(($OU.Substring(3,3).Replace(",","")),$Language)
}
else {
    $Corrected_OU = $OU
}

#User creation with, firstname, lastname, OU, SamAccountname, password, displayname, email, UPN, Country, Postal code, zip code, adres, company
New-ADUser -Name $firstname" "$Lastname -Path $Corrected_OU -SamAccountName $username -AccountPassword $password -DisplayName $firstname" "$Lastname -EmailAddress $UPN@simontbraun.eu -City $City -State $State -Country $Country -PostalCode $ZipCode -Office $office -Surname $Lastname -GivenName $firstname -StreetAddress $Street -Company $example_user.Company -Enabled $true -UserPrincipalName $username@simontbraun.eu

#copy user to the same AD groups as the example user
Get-ADuser -identity $example_user.SamAccountName -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $login
$groups = Get-ADuser -identity $example_user.SamAccountName -properties memberof | select-object memberof -expandproperty memberof
#Add-Content -Path $logs -Value "Added groups: $groups"

Set-ADUser -Identity $username -ScriptPath $example_user.ScriptPath -HomePage $website -Initials $Initials.ToUpper() -Add @{Proxyaddresses = "SMTP:$UPN@simontbraun.eu"}
Set-ADUser -Identity $username -Description $role
Set-ADUser -Identity $username -Fax $Fax
Set-ADUser -Identity $username -POBox $PO_Box
Set-ADUser -Identity $username -Title $role -Department $example_user.Department


Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$UPN@simontbraun.be"}

Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$username@simontbraun.eu"}
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$username@simontbraun.be"}

Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.be"}
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$Initials@simontbraun.eu"}

$smtp= $firstname[0]+"."+$Lastname_clean
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.be"}
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp@simontbraun.eu"}

$smtp2 = $firstname[0]+"."+$Lastname_clean[0]
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.be"}
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp2@simontbraun.eu"}

$smtp3 =  Remove-StringDiacritic ($firstname+"."+ $Lastname[0])
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.be"}
Set-ADUser -Identity $username -Add @{Proxyaddresses = "smtp:$smtp3@simontbraun.eu"}

Add-Content -Path $logs -Value "firstname: $firstname","Lastname: $Lastname","username: $username","UPN: $UPN","Phone: $Phone","Office: $office", "example user: $example"

Set-Location "\\braunbigwood.local\dfs\Personal"
mkdir $username

$fileshare = "\\braunbigwood.local\dfs\Personal"
$domain = "braunbigwood"
createFolder $fileshare $username $domain
Set-ADUser $username -HomeDirectory $fileshare+"\"+$login -HomeDrive "X:"

Set-Location "\\SIBDC02\c$\_Scripts"
.\DeltaSync.ps1

Write-Host "syncing... this may take up to 2 minutes" -ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 120

<#$AZ_New_User = Get-AzureADuser -SearchString $username
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

$licenses = (Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -like "Win10_VDA_E3"}).AccountSkuId
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