$list = Import-Csv -Path "C:\temp\ELF\Book1.csv" -Header NAME,admin -Delimiter ";"
$DL = Get-DistributionGroup -Identity "projectleader2022@liberalforum.eu"
foreach ($l in $list) {
    Write-Host $l.NAME "&" $l.admin
    pause
    try {
        get-mailcontact -identity $l.admin -ErrorAction stop
    }
    catch {
        New-MailContact -Name $l.NAME -ExternalEmailAddress $l.admin

        Set-MailContact -Identity $l.admin -HiddenFromAddressListsEnabled $true
    }

    Add-DistributionGroupMember -Identity $DL.PrimarySmtpAddress -Member "c.luijkx@vvd.nl"
}