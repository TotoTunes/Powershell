# A profile exists?
Get-ChildItem "$HOME\Documents\WindowsPowerShell"
# or...
Test-Path $profile

# create an alias
New-Alias Get-Service Get-Process
# test the alias
Get-Service

# close and reopen the ise - alias is gone

# save command to profile
New-Item $PROFILE -ItemType File -Force
Add-Content $PROFILE "New-Alias Get-Service Get-Process"
# close and reopen the ise - alias persists

# remove the profile
Remove-Item "$HOME\Documents\WindowsPowerShell"
