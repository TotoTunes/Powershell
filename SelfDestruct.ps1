$hostname = Read-Host "Enter Hostname of laptop"
Enter-PSSession -ComputerName $hostname -Credential "$hostname\administrator"

Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak("System temperature exceeded, battery has become critically unstable. This laptop will self destruct in 10 . 9 . 8 . 7 . 6 . 5 . 4 . 3 . 2 . 1 . ha ha, this was a lie, much like the cake");