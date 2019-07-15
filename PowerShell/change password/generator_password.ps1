#Генератор паоля 
#Длина пароля
$PassLength = 3
#нестандартных символа
$NonAlfaNumeric = 0
Add-Type -AssemblyName System.Web
$pas = [System.Web.Security.Membership]::GeneratePassword($PassLength,$NonAlfaNumeric)
Write-Host Design-$pas