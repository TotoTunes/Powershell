for ($i = 0; $i -lt 101; $i++) {
    Write-Host $i
    if ($i -lt 10) {
        Write-Host "Just starting"
    }
    elseif ($i -ge 10 -AND $i -le 75){
        Write-Host "fully started"
    }
    elseif ($i -ge 75 -and $i -le 100) {
        Write-Host "almost there"
    }
    elseif ($i -eq 100) {
        Write-Host "DONE"
    }
    Start-Sleep -Milliseconds 1000
}

#region Solution
<# 
for ($i = 0; $i -lt 100; $i++) {
    if ($i -lt 10) {
        $co = "Just starting"
    }
    elseif ($i -lt 25) {
        $co = "Fully started"
    }
    elseif ($i -lt 75) {
        $co = "Doing the work"
    }
    else {
        $co = "Finishing up"
    }


    Write-Progress -PercentComplete $i -Activity "Time until time is up" -CurrentOperation $co
    Start-Sleep -Milliseconds (Get-Random -Minimum 250 -Maximum 500)
}
#>
#endregion

