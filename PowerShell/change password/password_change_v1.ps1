#Change password user and send email 

Import-Module ActiveDirectory

#System globalization
#$ci = New-Object System.Globalization.CultureInfo("ru-RU")

#SMTP server name
$smtpServer = "" #"smtp-relay.gmail.com"

#Creating a Mail object
$msg = new-object Net.Mail.MailMessage
#Creating a Mail object for report
$msgr = new-object Net.Mail.MailMessage

#Creating SMTP server object
$smtp = new-object Net.Mail.SmtpClient($smtpServer)

#E-mail structure
Function EmailStructure($to,$expiryDate,$upn)
{
#Write-host "newpass"=$NewPassUser
	$msg.IsBodyHtml = $true
	$msg.From = "admin@solvve.com"
	$msg.To.Clear()
	$msg.To.Add($to)
	$msg.Subject = "Password expiration notice"
	#$msg.Body = "<html><body><font face='Arial'>This is an automatically generated message.<br>Your password for your account <b>DESIGN\$upn</b> will chane on $TodaysDate.</br><br> Your NEW password.<br><b>$NewPassUser</b></br> </font></body></html>"
    $msg.Body = "<html><body><font face='Arial'>Hi<br><br>The password for your domain account <b>DESIGN\$upn</b> was about to expire less then 1 week.<br> So it was changed $TodaysDate.<br>Your new password is:<br><b>$NewPassUser</b><br><br>System administration team.<br>This is an automatically generated message.</font></body></html>"

}

Function EmailStructureReport($to)
{
	$msgr.IsBodyHtml = $true
	$msgr.From = "admin@solvve.com"
	$msgr.To.Add($to)
	$msgr.Subject = "Script running report"
	$msgr.Body = "<html><body><font face='Arial'><b>This is a week report.<br><br>Script has successfully completed its work.<br>$NotificationCounter users have recieved new password:<br><br>$ListOfAccounts<br><br></b></font></body></html>"
}

#Set the target OU that will be searched for user accounts
$OU = "OU=vpn,OU=Users,OU=DESIGN,DC=corp,DC=isddesign,DC=com"
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
        #день смены пароля последний 1 
		if (($DaysToExpire.Days -le 8))
		{
		$expiryDate = $expiryDate.ToString("d",$ci)
        #Write-host "userEmai=" $userEmailAddress
#Generate e-mail structure and send message
			if ($userEmailAddress)
			{
	 		 
	 		 
    			 Write-Host "NOTIFICATION - $samAccountName :: e-mail was sent to $userEmailAddress"
                 #
   			 $NotificationCounter = $NotificationCounter + 1
    			 $ListOfAccounts = $ListOfAccounts + $samAccountName + " - $DaysToExpireDD days  left. Sent to $userEmailAddress<br>"
                 #######################
                 #generate password length
                 $PassLength = 3
                 #difucult
                 $NonAlfaNumeric = 3
                 Add-Type -AssemblyName System.Web
                 $Pass = [System.Web.Security.Membership]::GeneratePassword($PassLength,$NonAlfaNumeric)
                 $Dom = "Design-"
                 $NewPassUser = $Dom + $Pass
                 Write-Host "PASSWORD=" $NewPassUser
                 #######################
                 #Change password 
                 #Set-ADAccountPassword -Identity $samAccountName -NewPassword $NewPassUse –Reset
                 Set-ADAccountPassword  -Identity $samAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassUser -Force) –PassThru
                 ######################
                 ##EmailStructure $userEmailAddress $expiryDate $samAccountName $NewPassUser
                 ##$smtp.Send($msg)
			}
   		}
	}
}
#$NotificationCounter = 0
if ($NotificationCounter -gt 0)
{Write-Host "SENDING REPORT TO IT DEPARTMENT"
##EmailStructureReport("servicedesk@solvve.com")
#EmailStructureReport("voza@solvve.com")
##$smtp.Send($msgr)
}
