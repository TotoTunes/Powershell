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


#remove license