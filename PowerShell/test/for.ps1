
for ($i = 2; $i -lt 10; $i++)
{ 
 $ip="10.88.20.$i"


#ping 

 $ipStatus=Test-Connection -ComputerName $ip -Quiet -Count 1

#exit if not ping 

if ($ipStatus -eq $False)   {continue} # {break} # {write-host "pc disabled"} breack

# telnte smb port 445

 
 Write-Host $ip

#start service

 get-service -computername @($ip) | where {$_.name -eq 'SepMasterService'} | format-table Name,Status,Machinename -autosize 

#Test-NetConnection -Port 445 -ComputerName "$ip"

}