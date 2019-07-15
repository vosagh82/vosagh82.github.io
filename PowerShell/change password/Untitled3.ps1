# Берем текущую дату и возвращаемся на 53 дня назад. То есть уведомлять будем за 7 дней до истечения срока действия пароля
$pdate = (Get-Date).AddDays(-53).ToFileTime()

# Подключаем модуль Active Directory
Import-Module ActiveDirectory

# Делаем выборку пользователей, учетные записи которых включены, пароль изменен более 53 дней ранее, исключаем тех, у кого срок действия пароля не ограничен, у кого отсутствует e-mail адрес, и тек кто никогда не логинился
$pusers = Get-ADUser -Filter {(Enabled -eq $true) -and (pwdLastSet -le $pdate) -and (PasswordNeverExpires -eq $false)} -Properties pwdLastSet,mail,lastLogonTimestamp | Where-Object {$_.mail -ne $null -and $_.lastLogonTimestamp -ne $null}

# Выполняем для каждого выбранного объекта цыкл
foreach ($puser in $pusers) {

# Дата изменения пароля у нашего юзера
$pwdLastSet = $puser.pwdLastSet
# Сегодняшняя дата
$tdate = (Get-Date).ToFileTime()
# Конвертируем, что бы можно было увеличить значение
$pwdLastSet = [DateTime]::FromFileTime($pwdLastSet)
# Прибавляем к дате последней смены пароля 60 дней, тем самым получая дату истечения пароля, и конвертируем обратно для дальнейшей обработки
$pwdLastSet = $pwdLastSet.AddDays(+60).ToFileTime()

# Если дата истечения пароля еще не наступила, то есть она больше сегодняшней даты
if ($pwdLastSet -gt $tdate) {
# Конвертируем для отправки даты истечения по почте
$pwdLastSet = [DateTime]::FromFileTime($pwdLastSet)
$pwdLastSet = $pwdLastSet.ToLongDateString()

# Данные для отправки почты
$Subject = "Уведомление о необходимости смены пароля"
$Server = "mail.domain.test"
$From = "noreply@domain.test"
$secpasswd = ConvertTo-SecureString "pa$$w0rd" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential("noreply@domain.test", $secpasswd)


# Отправляем e-mail юзеру
$email = $puser.mail
$To = "$email"
$body = "Срок действия вашего пароля истекает $pwdLastSet Настоятельно рекомендуем вам сменить пароль!”
Send-MailMessage -From $From -To $To -SmtpServer $Server -Body "$body" -Subject $Subject -credential $mycreds
}
}
# Если же пароль уже истек, нет смысла отправлять уведомление, пользователь всё равно не сможет его прочесть, пока не сменит пароль.
