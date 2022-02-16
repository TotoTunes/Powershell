$lis = Import-Csv -Path "C:\Users\thomas\OneDrive - IT Anywhere\Documenten\Celyad\SPAM\Celyad blocked  domains list 20-01-2022.csv" -Header "Domain"
Foreach ($dom in $lis) {
Set-HostedContentFilterPolicy -Identity Default -BlockedSenderDomains @{Add=$dom.Domain} -Verbose
Write-Host $dom.Domain
}
