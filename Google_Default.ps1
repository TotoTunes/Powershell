$user = [Environment]::UserName

<#the whole if statement is a failsafe so that it doesn't set google as searchprovder EVERY time you log in#>

if (( test-path "c:\users$user\AppData\LocalLow\Microsoft\Internet Explorer\Services\google_gpo.ico") -like "False") {

"running script"

<#create custom reg value so it doesn't break anything on system#>

$regvalue = "{"+[Guid]::NewGuid().ToString().ToUpper()+"}"

$regvalue

$user = [Environment]::UserName

<#copy the icon from c:\users$user\AppData\LocalLow\Microsoft\Internet Explorer\Services\ beforehand and put into DFS share from a system that has Google as search provider#>

copy "\domain.com\Login\google_gpo.ico" "c:\users$user\AppData\LocalLow\Microsoft\Internet Explorer\Services\google_gpo.ico"

New-Item -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes" -Name $regvalue –Force

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes" -Name DefaultScope -Value $regvalue

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name DisplayName -Value Google -PropertyType String

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name FaviconPath -Value "c:\users$user\AppData\LocalLow\Microsoft\Internet Explorer\Services\google_gpo.ico" -PropertyType String

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name FaviconURL -Value https://www.google.com/favicon.ico -PropertyType String

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name OSDFileURL -Value https://www.microsoft.com/en-us/IEGallery/GoogleAddOns -PropertyType String

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name ShowSearchSuggestions -Value 1 -PropertyType DWord

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name SuggestionsURL -Value "https://www.google.com/complete/search?q={searchTerms}&client=ie8&mw={ie:maxWidth}&sh={ie:sectionHeight}&rh={ie:rowHeight}&inputencoding={inputEncoding}&outputencoding={outputEncoding}" -PropertyType String

New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes$regvalue" -Name URL -Value "https://www.google.com/search?q={searchTerms}&sourceid=ie7&rls=com.microsoft:{language}:{referrer:source}&ie={inputEncoding?}&oe={outputEncoding?}" -PropertyType String

copy \ennsbros.com\Login\google_gpo.ico "c:\users$user\AppData\LocalLow\Microsoft\Internet Explorer\Services\google_gpo.ico"

}

else

{

"google already set as search engine"

}