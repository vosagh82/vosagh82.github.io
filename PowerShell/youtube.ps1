$file = "$env:windir\System32\drivers\etc\hosts"
#$file = "D:\hosts.txt"
$string = "127.0.0.1	www.youtube.com"

$containsWord = Get-Content $file | %{$_ -match $string}

if ($containsWord -contains $true) {
    Write-Host "There is!"
    (Get-Content -path $file -Raw) -replace $string, "" | Out-File $file
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("YouTube Включен")

} else {
    Write-Host "There ins't!"
    $string  | Add-Content -PassThru $file
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("YouTube Отключен")
}

#$string | Add-Content -PassThru $file
#Write-Host $string1
#Write-Host $string
#"127.0.0.1	www.youtube.com" | Add-Content -PassThru $file
