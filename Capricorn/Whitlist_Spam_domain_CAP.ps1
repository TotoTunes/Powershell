$dom = Read-Host "Enter domain to whitelist"
Set-HostedContentFilterPolicy -Identity default -AllowedSenderDomains @{Add=$dom} -Verbose
Set-HostedContentFilterPolicy -Identity "Most secured anti-spam policy" -AllowedSenderDomains @{Add=$dom}