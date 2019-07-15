
$file = "D:\log\test.txt"
$text = "#www"
$text1 = "www"

if($results = Get-ChildItem $file | Select-String -pattern $text){
     #Write-Host 'results found'
     $MassFile = Get-Content $file
     $MassFile.Replace($text, $text1) | Out-File  $file -Force
}else{
     #Write-Host 'results not found'
     #Add-Content -Path $file -Value $text
     $MassFile = Get-Content $file
     $MassFile.Replace($text1,$text) | Out-File  $file -Force
}