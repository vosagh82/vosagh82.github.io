#Cкрипт по уведомления на почту об окончании срока действия пароля.

Import-Module ActiveDirectory

#System globalization
#$ci = New-Object System.Globalization.CultureInfo("ru-RU")

#SMTP server name
$smtpServer = "smtp-relay.gmail.com"

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
	$msg.From = "admin@solvve.com"
	$msg.To.Clear()
	$msg.To.Add($to)
	$msg.Subject = "Password expiration notice"
	$msg.Body = "<html><body><font face='Arial'>This is an automatically generated message.<br><br><b>Please note that the password for your account <i><u>ISDDESIGN\$upn</u></i> will expire on $expiryDate.</b><br><br>Please change your password immediately or at least before this date as you will be unable to access the service without contacting your administrator.</font></body></html>"
}

Function EmailStructureReport($to)
{
	$msgr.IsBodyHtml = $true
	$msgr.From = "voza@solvve.com"
	$msgr.To.Add($to)
	$msgr.Subject = "Script running report"
	$msgr.Body = "<html><body><font face='Arial'><b>This is a daily report.<br><br>Script has successfully completed its work.<br>$NotificationCounter users have recieved notifications:<br><br>$ListOfAccounts<br><br></b></font></body></html>"
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
	$userEmailAddress = $ADAccount.Mail
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
#Calculating DaysToExpireDD to DD format (w/o fractional part and dot)
	 $DaysToExpireDD = $DaysToExpire.ToString() -Split ("\S{17}$")
	 Write-host "The password for account $samAccountName expires on: $ExpiryDate. Days left: $DaysToExpireDD"
		#if (($DaysToExpire.Days -eq 15) -or ($DaysToExpire.Days -eq 7) -or ($DaysToExpire.Days -le 3))
        if  ($DaysToExpire.Days -le 7)
		{
		$expiryDate = $expiryDate.ToString("d",$ci)
        #Write-host "userEmai=" $userEmailAddress
#Generate e-mail structure and send message
			if ($userEmailAddress)
			{
	 		 EmailStructure $userEmailAddress $expiryDate $samAccountName
	 		 #$smtp.Send($msg)
    			 Write-Host "NOTIFICATION - $samAccountName :: e-mail was sent to $userEmailAddress"
   			 $NotificationCounter = $NotificationCounter + 1
    			 $ListOfAccounts = $ListOfAccounts + $samAccountName + " - $DaysToExpireDD days  left. Sent to $userEmailAddress<br>"
			}
   		}
	}
}
Write-Host "SENDING REPORT TO IT DEPARTMENT"
EmailStructureReport("voza@solvve.com")
#$smtp.Send($msgr)
