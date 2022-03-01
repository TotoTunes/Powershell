$start = Set-Date -Date 8:30
$end = Set-Date -Date 11:45


$time = New-TimeSpan -Start 8:30 -End 11:45

$percent = (($time/100)*25).Minutes

$newEnd = $end.Minute+$percent
Write-Host $newEnd


$start = Get-date -Hour 8 -Minute 30 -Second 0
$end = Get-date -Hour 11 -Minute 45 -Second 0
$minutesLongExamen = (($end - $start).TotalMinutes * 1.25)
$span = New-timespan -Minutes $minutesLongExamen
$start + $span