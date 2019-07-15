
$start = 2
$end = 10
$ping = 1
while ($start -le $end) {
$IP = "10.88.20.$start"
Write-Host "Pinging $IP"
Test-Connection -ComputerName $IP -count 1 -Quiet

$start++
}