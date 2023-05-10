$bios = Get-WmiObject Win32_BIOS
$serial = $bios.serialnumber
Rename-Computer -NewName "GOR-$serial" -Restart