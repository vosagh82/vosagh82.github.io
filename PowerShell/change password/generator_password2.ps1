function Get-RandomCharacters($length, $characters) { 
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 
    $private:ofs="" 
    $pass = return [String]$characters[$random]
}

Get-RandomCharacters -length 8 -characters 'abcdefghiklmnoprstuvwxyz1234567890' | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Verbose 4>&1

 

Write-Host $pass

