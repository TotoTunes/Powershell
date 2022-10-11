


Write-Host "Initializing Azure AD Delta Sync..." -ForegroundColor Yellow

$session = New-PSSession -ComputerName cel-dom03

Invoke-Command -Session $session -ScriptBlock {
Install-Module adsynctools -force
Import-Module adsynctools -force
Start-Sleep -s 6
Start-ADSyncSyncCycle -PolicyType Delta

#Wait 10 seconds for the sync connector to wake up.
Start-Sleep -Seconds 10

#Display a progress indicator and hold up the rest of the script while the sync completes.
While(Get-ADSyncConnectorRunStatus){
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 10
}

Write-Host " | Complete!" -ForegroundColor Green


}

Start-Sleep -s 6
Remove-PSSession -session $session