Install-Module MSOnline
Import-Module MSOnline
Install-Module AzureAD
Import-Module AzureAD 
$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
$importresults = Import-PSSession $Session -AllowClobber
Connect-MsolService -cred $LiveCred
Connect-AzureAd -Credential $LiveCred