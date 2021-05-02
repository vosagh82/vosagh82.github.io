
$name_vm = 'w10t1'
$path_vm = 'D:\Hyper-V\windows\'

$vhd_vm = $path_vm + '\' + $name_vm  + '\'+ $name_vm + '.vhdx'
$size_vhd_vm = 50GB
$memory_vm = 3GB


New-VM -Name $name_vm -MemoryStartupBytes $memory_vm -Path $path_vm -Generation 2


#New-VHD -Path $vhd_vm -SizeBytes $size_vhd_vm -Dynamic

#Copy hdd from ubuntu
Copy-Item -Path "D:\Hyper-V\windows\w10default\Virtual Hard Disks\w10default.vhdx" -Destination "$vhd_vm" -Recurse

#Connect hdd disk in vm
Add-VMHardDiskDrive -VMName $name_vm -Path $vhd_vm

#Hyper-V secure boot disable
#Set-VMFirmware -VMName $name_vm -DisableSecureBoot
Set-VMFirmware $name_vm -EnableSecureBoot Off

#Connect-VMNetworkAdapter
Connect-VMNetworkAdapter -VMName $name_vm -Name "Сетевой адаптер" -SwitchName Internet

#Set-VMDvdDrive -VMName $name_vm -ControllerNumber 1 -Path $path_iso

#sets the virtual machine boot from hdd
$VMHardDiskDrive = Get-VMHardDiskDrive -VMName $name_vm
Set-VMFirmware $name_vm  -FirstBootDevice $VMHardDiskDrive

#Disable automatic checkpoints 
Set-VM -VMName $name_vm -AutomaticCheckpointsEnabled $False

#start
Start-VM –Name $name_vm
