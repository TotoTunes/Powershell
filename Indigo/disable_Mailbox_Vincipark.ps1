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

#to be completed: check if user has E1 license and convert to shared mailbox if needed
$pre_2000_account = Read-Host "Account name for mailbox to disable"
$ADobject = Get-ADUser -Identity $pre_2000_account -Properties *

$UPN = $ADobject.UserPrincipalName
M365_Connection
pause
$msoluser = Get-MsolUser -UserPrincipalName $UPN
Set-Mailbox $UPN -Type shared 

$ADobject.SamAccountName | Set-ADUser -Replace @{msExchHideFromAddressLists=$true}
Set-ADUser -Identity  $ADobject -Clear ProxyAddresses

Set-ADUser -Identity $ADobject -Add @{proxyaddresses = "SMTP:_$UPN" }









$pre_2000_account = Read-Host "Account name for mailbox to disable"
$ADobject = Get-ADUser -Identity $pre_2000_account
$UPN = $ADobject.UserPrincipalName


$ADobject.SamAccountName | Set-ADUser -Replace @{msExchHideFromAddressLists=$true}
Set-ADUser -Identity  $ADobject -Clear ProxyAddresses

Set-ADUser -Identity $ADobject -Add @{proxyaddresses = "SMTP:_$UPN" }
Write-Host "$UPN is disabled"