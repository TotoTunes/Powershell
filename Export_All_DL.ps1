
Get-DistributionGroup -ResultSize Unlimited | select Name, PrimarySmtpAddress | Export-Csv -Path C:\temp\All_DL.csv -NoTypeInformation
$file = "C:\temp\All_DL.csv"
Import-Csv -path $file | ForEach-Object {

$list = Get-DistributionGroup $_.Name
Write-Host $_.Name


Get-DistributionGroupMember -Identity $_.Name | Select Name, PrimarySMTPAddress |
Export-CSV -Path C:\temp\$list".csv" -NoTypeInformation -Encoding UTF8

}