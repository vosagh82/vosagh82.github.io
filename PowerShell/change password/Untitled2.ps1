#System globalization
#$ci = New-Object System.Globalization.CultureInfo("ru-RU")
 
#SMTP server name
$smtpServer = "srv-mail.mycompany.local"
 
#Creating a Mail object
$msg = new-object Net.Mail.MailMessage
#Creating a Mail object for report
$msgr = new-object Net.Mail.MailMessage
 
#Creating SMTP server object
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
#E-mail structure
Function EmailStructure($to,$expiryDate,$upn)
{
$msg.IsBodyHtml = $true
$msg.From = "pwdmonitoring@mycompany.ru"
$msg.To.Clear()
$msg.To.Add($to)
$msg.Subject = "Password expiration notice"
$msg.Body =
"<html><body><font face='Arial'>Сообщение сгенерированно автоматически.<br><br><b>напоминание, что пароль для вашего аккаунта <i><u>$upn</u></i> истекает $expiryDate.</b><br><br>Вы можете изменить свой пароль на </font></body></html>"
}
 
Function EmailStructureReport($to)
{
$msgr.IsBodyHtml = $true
$msgr.From = "pwdmonitoring@mycompany.ru"
$msgr.To.Add($to)
$msgr.Subject = "Script running report"
$msgr.Body =
"<html><body><font face='Arial'><b>Это ежедневный отчет.<br><br>Скрипт успешно завершил работу.<br>$NotificationCounter пользователи получили уведомление:<br><br>$ListOfAccounts<br><br></b></font></body></html>"
}
 
#Set the target OU that will be searched for user accounts
$OU = "OU=Users,OU=DESIGN,DC=corp,DC=isddesign,DC=com"
 
$ADAccounts = Get-ADUser -LDAPFilter "(objectClass=user)" -searchbase $OU -properties PasswordExpired, PasswordNeverExpires, PasswordLastSet, Mail, Enabled | Where-object {$_.Enabled -eq $true -and $_.PasswordNeverExpires -eq $false}
$NotificationCounter = 0
$ListOfAccounts = ""
 
Foreach ($ADAccount in $ADAccounts)
{
$accountFGPP = Get-ADUserResultantPasswordPolicy $ADAccount
 
if ($accountFGPP -ne $null)
{
$maxPasswordAgeTimeSpan = $accountFGPP.MaxPasswordAge
}
else
{
$maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
}
#Fill in the user variables
$samAccountName = $ADAccount.samAccountName
$userEmailAddress = $ADAccount.mail
$userPrincipalName = $ADAccount.UserPrincipalName
 
if ($ADAccount.PasswordExpired)
{
Write-host "The password for account $samAccountName has expired!"
}
else
{
$ExpiryDate = $ADAccount.PasswordLastSet + $maxPasswordAgeTimeSpan
$TodaysDate = Get-Date
$DaysToExpire = $ExpiryDate - $TodaysDate
$DaysToExpireDD = $DaysToExpire.ToString() -Split ("\S{17}$")
Write-host "The password for account $samAccountName expires on: $ExpiryDate. Days left: $DaysToExpireDD"
if (($DaysToExpire.Days -eq 15) -or ($DaysToExpire.Days -eq 7) -or ($DaysToExpire.Days -le 3))
{
$expiryDate = $expiryDate.ToString("d",$ci)
#Generate e-mail structure and send message
if ($userEmailAddress)
{
EmailStructure $userEmailAddress $expiryDate $samAccountName
$smtp.Send($msg)
Write-Host "NOTIFICATION - $samAccountName :: e-mail was sent to $userEmailAddress"
$NotificationCounter = $NotificationCounter + 1
$ListOfAccounts = $ListOfAccounts + $samAccountName + "&#9; - $DaysToExpireDD days left.<br>"
}
}
 
}
}
Write-Host "SENDING REPORT TO IT DEPARTMENT"
EmailStructureReport("support@mycompany.ru")
$smtp.Send($msgr)