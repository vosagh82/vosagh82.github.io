
$name_vm = 'test_w'
$path_vm = 'D:\Hyper-V\windows\'
$path_iso = 'D:\soft\iso\windows\Windows Server\Windows Server 2012\SW_DVD5_Win_Svr_Std_and_DataCtr_2012_64Bit_Russian_Core_MLF_X18-27640.ISO'
$vhd_vm = $path_vm + '\' + $name_vm  + '\'+ $name_vm + '.vhdx'
$size_vhd_vm = 4GB 
$memory_vm = 2GB



New-VM -Name $name_vm -MemoryStartupBytes $memory_vm -Path $path_vm -Generation 2


New-VHD -Path $vhd_vm -SizeBytes $size_vhd_vm -Dynamic


Add-VMHardDiskDrive -VMName $name_vm -Path $vhd_vm


Set-VMDvdDrive -VMName $name_vm -ControllerNumber 1 -Path $path_iso


Start-VM –Name $name_vm