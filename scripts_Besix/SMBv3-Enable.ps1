if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
$parameters = @{
    Path  = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    Name  = 'DisableCompression'
    Type  = 'DWORD'
    Value = 1
    Force = $true
}
Set-ItemProperty @parameters