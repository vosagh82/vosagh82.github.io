#$date_with_offset= (Get-Date).AddDays(-210)
#$users = Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -lt $date_with_offset } | Sort LastLogonDate
#foreach ($user in $users) {
#set-aduser $user -enabled $false; move-adobject -identity $user -targetpath "ou=Уволенные,ou=Мск Л. пользователи,ou=Местоположение,dc=msk,dc=aetp,dc=nn"
#}
#Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -lt $date_with_offset } | Sort LastLogonDate | FT Name, LastLogonDate -AutoSize #| Out-File c:\Script\users.txt


$timespan = New-Timespan –Days 210
$dc = "OU=Users,OU=DESIGN,DC=corp,DC=isddesign,DC=com"
Search-ADAccount –UsersOnly –AccountInactive -SearchBase $dc –TimeSpan $timespan | Sort LastLogonDate | FT Name, LastLogonDate -AutoSize