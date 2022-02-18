$day = 1
$month = 7
$year = (get-date).AddYears(1).Year
$year
get-date -Date "$day/$month/$year"


Get-Process | Where-Object {$_.CPU -gt 1 -and $_.Company -ne "Microsoft*"}


Get-Process | Select-Object -ExpandProperty CPU | Measure-Object -Sum^C

Get-Service | Where-Object {$_.Name.}