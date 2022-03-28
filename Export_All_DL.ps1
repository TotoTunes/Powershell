
Get-DistributionGroup -ResultSize Unlimited | Export-Csv -Path C:\temp\All_DL.csv
$file = C:\temp\All_DL.csv
Import-Csv $file | ForEach-Object {

$list = Get-DistributionGroup $_.DisplayName
Write-Host $_.DisplayName


Get-DistributionGroupMember -Identity $_."DisplayName" | Select Name, PrimarySMTPAddress |
Export-CSV -Path C:\temp\$list".csv" -NoTypeInformation -Encoding UTF8

}