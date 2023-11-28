Import-Module ExchangeOnlineManagement -Force
Install-Module -Name ExchangeOnlineManagement -Scope AllUsers
$login = Read-Host "enter your UPN"
Connect-IPPSSession -UserPrincipalName $login
$send = Read-Host "enter the sender address"
$Search = new-compliancesearch -name "remove phishing $send" -exchangelocation all -contentMarchQuery '(From:"$send")'
start-compliancesearch -identity $Search.identity



Import-Module ExchangeOnlineManagement -Force
Install-Module -Name ExchangeOnlineManagement -Scope AllUsers
$login = Read-Host "enter your UPN"
Connect-IPPSSession -UserPrincipalName $login -ConnectionUri "https://ps.protection.outlook.com/powershell-liveid/"
$send = Read-Host "enter the sender address"
$Search = new-compliancesearch -name "remove phishing team@procurementsservice.info" -exchangelocation all -contentMarchQuery '(From:team@procurementsservice.info)'
start-compliancesearch -identity $Search.identity