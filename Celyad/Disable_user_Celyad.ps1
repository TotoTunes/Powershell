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
#Function to generate text box and input out of office message
function OutOfOfficeMessage {
    Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(550,650)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(325,560)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(400,560)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the information in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.RichTextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(500,500)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox.Text
    Return $x
}
}

$login = Read-Host "Enther the username"
$AD = Get-aduser -identity $login
$OU = "OU=disabled users,DC=medpole,DC=local"
M365_Connection
#disable user in AD
Disable-ADAccount -Identity $login

#remove AD groups
$ADGroups = Get-ADPrincipalGroupMembership -Identity  $User | where {$_.Name -ne “Domain Users”}

$ADGroups | Export-Csv -Path C:\Temp\ADGroups\$login'.csv'
Write-Host "All AD groups have been exported to C:\Temp\username.csv"

Remove-ADPrincipalGroupMembership -Identity $User -MemberOf $AdGroups -confirm:$false

#remove Company attribute
Get-aduser -Identity $login | Set-Aduser -Company ""

#remove Manager attribute
Set-ADUser -Identity $login -Clear manager

#SYNC
Set-Location "\\CEL-DOM03\C$\temp"
.\DeltaSync.ps1
Set-Location "C:\temp"

#Sync Deactivation
Set-Aduser -Identity $login -Clear ProxyAddresses

#Move OU
Get-ADUser $login | Move-ADObject -TargetPath $OU

#SYNC
Set-Location "\\CEL-DOM03\C$\temp"
.\DeltaSync.ps1
Set-Location "C:\temp"

#recover deleted user

#convert to shared mailbox
Get-mailbox -Identity "$login@celyad.com" | Set-MailBox -Type Shared
#set out of office message
$message = OutOfOfficeMessage

#remove license