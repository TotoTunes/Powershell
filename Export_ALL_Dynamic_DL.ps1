Get-DynamicDistributionGroup -ResultSize Unlimited | select Name, PrimarySmtpAddress | Export-Csv -Path C:\temp\All_DDL.csv -NoTypeInformation
$file = "C:\temp\All_DDL.csv"
Import-Csv -path $file | ForEach-Object {

$list = Get-DynamicDistributionGroup $_.PrimarySmtpAddress
Write-Host $_.Name
$var = Get-DynamicDistributionGroup -Identity $_.PrimarySmtpAddress

Get-Recipient -RecipientPreviewFilter $var.RecipientFilter | Select Name, PrimarySMTPAddress | Export-CSV -Path C:\temp\$list".csv" -NoTypeInformation -Encoding UTF8

}