Get-Process -Name "notepad" | Get-Member
Get-Process -Name "N*" | Select-Object Name,CPU,NonpagedSystemMemorySize,NonpagedSystemMemorySize64 | Format-Table

Get-Process -Name "A*" |Format-List

Write-Host "Thomas" -ForegroundColor Red -BackgroundColor Green

Get-Service | Where-Object {$_.StartType -eq "Automatic"} | Out-GridView -PassThru | Start-Service
