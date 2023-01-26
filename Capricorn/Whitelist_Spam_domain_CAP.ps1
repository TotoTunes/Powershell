#$dom = Read-Host "Enter domain to whitelist"
#Set-HostedContentFilterPolicy -Identity default -AllowedSenderDomains @{Add=$dom} -Verbose
#Set-HostedContentFilterPolicy -Identity "Most secured anti-spam policy" -AllowedSenderDomains @{Add=$dom}



$path = Read-host "Enter \\path\filename.csv"
$mails = Import-Csv -Path $path -Header "Identity", "SenderAddress", "Subject", "ReceivedTime", "Release" -Delimiter ";"
foreach ($m in $mails) {
    Write-Host $m.SenderAddress
    Write-Host $m.Release 
    
    if ($m.Release -eq "Y") {
        $dom = ($m.SenderAddress.Split("@"))[1]

        if ($dom -ne "gmail.com") {
            Write-Host "this domain will be whitelisted" -ForegroundColor Green
            Write-Host $dom
            Set-HostedContentFilterPolicy -Identity default -AllowedSenderDomains @{Add = $dom }
            Set-HostedContentFilterPolicy -Identity "Most secured anti-spam policy" -AllowedSenderDomains @{Add = $dom }
        } 
    }
    else {
        Write-Host "this domain will not be whitelisted" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}