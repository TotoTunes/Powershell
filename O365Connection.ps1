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
    Connect-ExchangeOnline -cred $LiveCred

}
Install-Module -Name ExchangeOnlineManagement -Scope AllUsers
Write-host "Select if you want to connect with an MFA enabled account or not"
Write-Host "Select 1 for regular account"
Write-Host "Select 2 for MFA account"
$selection = Read-Host "Select 1 or 2: "

switch ($selection) {
    1 {
        M365_Connection
    }
    2 {
        $cred = Get-Credential
        $login = $cred.UserName.ToString()
        #$cred = ConvertTo-SecureString -String $login.ToString()
        Connect-AzureAd -AccountId $login
        Connect-ExchangeOnline -UserPrincipalName $login
        Connect-MsolService -Credential $cred
    
    }
    Default {}
}