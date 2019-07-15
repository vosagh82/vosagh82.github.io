#Генератор паоля 
#Длина пароля
$PassLength = 16
#нестандартных символа
$NonAlfaNumeric = 4
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword($PassLength,$NonAlfaNumeric)