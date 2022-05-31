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
Connect-Exchangeonline

}

$path = Read-host "Enter \\path\filename.csv"
$mails = Import-Csv -Path $path -Header "Identity","SenderAddress","Subject","ReceivedTime","Release" -Delimiter ";"
foreach ($m in $mails) 
{
    Write-Host $m.SenderAddress
    Write-Host $m.Release 
    
    if ($m.Release -eq "Y") {
        Release-QuarantineMessage -Identity $m.Identity -ReleaseToAll -Verbose
        Write-Host "This message will be released" -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
    else {
        Write-Host "this mail will not be released" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}