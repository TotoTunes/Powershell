
function convertToSharedMailbox ($us){
    $msoluser = Get-MsolUser -UserPrincipalName $us
    $licenses = $msoluser.Licenses.accountskuid

    if ($licenses -contains "vincipark:ENTERPRISEPACK") {
        Write-Host "user has E3 license. Mailbox will be converted" -ForegroundColor Red
        pause
        Set-Mailbox $us -Type shared 
        Write-Host "mailbox has been converted to a shared mailbox" -ForegroundColor Green
        Write-Host "Licenses will be removed. Press enter to continue?" -ForegroundColor Red
        Pause
        foreach ($lic in $licenses) {

            Set-MsolUserLicense -UserPrincipalName $us -RemoveLicenses $lic
        }
    }
    else {
        Write-Host "This user does not have a E3 license, mailbox will not be converted to shared"
        Write-Host "Licenses will be removed. Press enter to continue?" -ForegroundColor Red
        foreach ($lic in $licenses) {

            Set-MsolUserLicense -UserPrincipalName $us -RemoveLicenses $lic
        }
    }

    
} 

function M365_Connection {
    Install-Module MSOnline  -Force
Import-Module MSOnline -Force
Install-Module AzureAD -Force
Import-Module AzureAD -Force
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
$importresults = Import-PSSession $Session -AllowClobber
Connect-MsolService -cred $LiveCred

Install-Module AzureAD
Connect-AzureAd -Credential $LiveCred

}

$path = "OU=Disabled-Users,OU=Accounts,OU=BE,DC=vincipark,DC=net"
$User = Read-host "Enter username to disable (Citrix login)"
$ADObject = Get-ADUser -Identity $User -properties *
M365_Connection
convertToSharedMailbox $ADObject.mail

Write-Host $ADObject.Name "will be disabled"
Disable-ADAccount $User
$ADGroups = Get-ADPrincipalGroupMembership -Identity  $User | Where-Object {$_.Name -ne “Utilisa. du domaine”}

Write-Host "All AD groups have been exported to C:\Temp\ADgroups\username.csv"
$ADGroups | Export-Csv -Path C:\Temp\ADGroups\$User'.csv'
Write-Host "Connecting to Office 365" -ForegroundColor Yellow

Remove-ADPrincipalGroupMembership -Identity $User -MemberOf $AdGroups -confirm:$false -verbose

Write-Host $ADObject.Name "will be moved to the Disabled OU"
Get-ADUser $User | Move-ADObject -TargetPath $path

