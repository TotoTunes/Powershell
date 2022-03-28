$list = Import-Excel "C:\temp\Kopie van Test.xlsx"
$list | Foreach {Get-ADUser $_.user -Properties *|Select givenName, name, emailaddress} | Export-excel c:\temp\lijstje.xlsx