
$name_vm = 'ubuntu20-Dev'
$path_vm = 'D:\Hyper-V\linux\'
#$path_iso = 'D:\soft\iso\windows\Windows Server\Windows Server 2012\SW_DVD5_Win_Svr_Std_and_DataCtr_2012_64Bit_Russian_Core_MLF_X18-27640.ISO'
$vhd_vm = $path_vm + '\' + $name_vm  + '\'+ $name_vm + '.vhdx'
$size_vhd_vm = 4GB
$memory_vm = 4GB



New-VM -Name $name_vm -MemoryStartupBytes $memory_vm -Path $path_vm -Generation 2


#New-VHD -Path $vhd_vm -SizeBytes $size_vhd_vm -Dynamic

#Copy hdd from ubuntu
Copy-Item -Path "D:\Hyper-V\linux\ubuntu20t1\Virtual Hard Disks\ubuntu20t1.vhdx" -Destination "$vhd_vm" -Recurse

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

#start
Start-VM –Name $name_vm
