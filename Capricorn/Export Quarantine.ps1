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


$user = Read-Host "Enter email adres of user"
$date = Get-Date -Format "dd-MM-yyyy"
#Get-QuarantineMessage -RecipientAddress $user | select Identity,SenderAddress,Subject,ReceivedTime | Export-Csv "c:\temp\quarantined_$date.csv" -NoTypeInformation
Get-QuarantineMessage -RecipientAddress $user | select Identity,SenderAddress,Subject,ReceivedTime,@{Name="Release";Expression=" "} |Export-Csv "c:\temp\quarantined_$date.csv" -NoTypeInformation
#Import-Csv -Path "C:\temp\quarantined_$date.csv" | Select-Object *,"Release" | Export-Csv C:\temp\quarantined.csv -NoTypeInformation
