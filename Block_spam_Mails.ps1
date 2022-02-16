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
Connect-Exchangeonline

}

function BlockDomain {

    $dom = Read-Host "Enter the domain to block"
    Write-host "Domain will be added to Spam block list and default spam filter"
    Set-HostedContentFilterPolicy -Identity default -BlockedSenderDomains $dom
    
    $Y = Read-Host "Do you want to block another domain? (Y/N)"

    if ($Y -eq "Y") {
        BlockSender
        
    }
}

function BlockSender {
    $send = Read-Host "Enter the sender to block"
    Write-host "Sender will be added to Spam block list and default spam filter"
    Set-HostedContentFilterPolicy -Identity default -BlockedSenderDomains $send

    $Y = Read-Host "Do you want to block another sender? (Y/N)"

    if ($Y -eq "Y") {
        BlockSender
        
    }
    
}

M365_Connection

Write-Host "1. Block domain 
2. block sender"
$choice = Read-Host ":"
if ($choice -eq 1) {
    
    BlockDomain
}
if ($choice -eq 2) {

   
    BlockSender
    
}