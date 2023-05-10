#https://docs.microsoft.com/en-us/powershell/module/international/copy-userinternationalsettingstosystem?view=windowsserver2022-ps 

#https://social.technet.microsoft.com/Forums/en-US/358f6f6a-f7b2-4816-960c-1e1fbe4871ca/powershellcopy-international-settings-to-the-welcome-screen-system-account-and-new-user-account 


Set-WinSystemLocale nl-BE
$language = New-WinUserLanguageList -Language en-BE
$language[0].InputMethodTips.Add("2000:00000813")
$language[0].InputMethodTips.Remove("2000:0000080C")
Set-WinUserLanguageList -LanguageList $language -Confirm

#Copy-UserInternationalSettingsToSystem -WelcomeScreen $true -NewUser $true