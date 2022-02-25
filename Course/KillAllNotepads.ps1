
$text = "Lorem ipsum" * 20
$file = "c:\temp\tmp.txt"
New-Item -ItemType file -Path $file

for ($i = 0; $i -lt 10; $i ++) {
    $text | Out-File -FilePath $file -Append
    notepad $file
    $text = $text * 2
}
Write-Host (Get-Process -Name "notepad").Count
Get-Process -Name "notepad" | Sort-Object -Property CPU -Descending| Select-Object $_.  | Stop-Process -Id $_.Id
Write-Host (Get-Process -Name "notepad").Count

#region solution
<#
$notepads = Get-Process Notepad

$averageCPU = ($notepads | Measure-Object -Average CPU).Average

#the pipe
$notepads | Where-Object CPU -gt $averageCPU | Stop-Process

#the loop
foreach ($notepad in $notepads) {
    if ($notepad.CPU -gt $averageCPU) {
        Write-Host "Killing $($notepad.ID)" -ForegroundColor Red -BackgroundColor Black
        $notepad.kill()
    }
}
#>
#endregion