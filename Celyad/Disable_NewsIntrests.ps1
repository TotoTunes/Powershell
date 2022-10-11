New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name WindowsFeeds
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsFeeds" -Name EnableFeeds -Type DWORD -Value 0