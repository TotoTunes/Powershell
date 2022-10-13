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
#disable user in AD
Disable-ADAccount -Identity $login

#remove AD groups
$ADGroups = Get-ADPrincipalGroupMembership -Identity  $User | where {$_.Name -ne “Domain Users”}

$ADGroups | Export-Csv -Path C:\Temp\ADGroups\$login'.csv'
Write-Host "All AD groups have been exported to C:\Temp\username.csv"

Remove-ADPrincipalGroupMembership -Identity $User -MemberOf $AdGroups -confirm:$false

#remove Company attribute
get-aduser
#remove Manager attribute
#SYNC
#convert to shared mailbox
#set out of office message
#Move OU
#Sync Deactivation
#SYNC
#recover deleted user
#remove license