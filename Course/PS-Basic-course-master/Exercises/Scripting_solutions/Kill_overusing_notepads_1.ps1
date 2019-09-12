# open the notepads with increasing amount of text
$text = "Lorem ipsum" * 20
$file = "c:\tmp\tmp.txt"
New-Item -ItemType file -Path $file

for ($i = 0; $i -lt 10; $i ++) {
    $text | Out-File -FilePath $file -Append
    notepad $file
    $text = $text * 2
}
