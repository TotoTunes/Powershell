$list = Get-QuarantineMessage -SenderAddress "newsletter@celyad.com"

foreach ($l in $list) {
    if ( $l.ReleaseStatus -ne "RELEASED") {
        Release-QuarantineMessage -identity $l.Identity -ReleaseToAll
        Write-Host $l.SenderAddress "sent to "
    }
    else {
        Write-Host $l.Identity "already released" -ForegroundColor Yellow
    }
}

$list = Get-QuarantineMessage -SenderAddress "invoice_approval@celyad.com"

foreach ($l in $list) {
    if ( $l.ReleaseStatus -ne "RELEASED") {
        Release-QuarantineMessage -identity $l.Identity -ReleaseToAll
        Write-Host $l.SenderAddress "sent to "
    }
    else {
        Write-Host $l.Identity "already released" -ForegroundColor Yellow
    }
}