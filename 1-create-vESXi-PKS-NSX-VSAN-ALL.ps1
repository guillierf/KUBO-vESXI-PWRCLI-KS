#
# This script if for the second ESXi host ESXi-1 (10.172.209.70) 
#

# Stops the client whining about certs
Set-PowerCLIConfiguration -InvalidCertificateAction ignore

#Connect to ESXi host
Connect-VIServer -User root -Password VMware1! -Server 10.172.209.70


# MGMT HOSTS
#
$VMNamesAll = "vESXi-1"


Foreach ($vmName in $VMNamesAll)
{

$Exists = get-vm -name $vmName -ErrorAction SilentlyContinue  
If ($Exists){  
     Write "VM $vmName is there"  
}  
Else {  
       
 #Create the VM
 New-VM -Name $vmName  -NumCpu 8 -MemoryMB 49152 -NetworkName "MGMT-PG" -Datastore datastore2 -DiskGB 256 -DiskStorageFormat Thin -GuestId otherGuest64 -Version v11

 #Change network adapter for VMNIC0 to VMXNET3
 get-vm $vmName | get-networkadapter | set-networkadapter -Type vmxnet3 -Confirm:$false
 
 #Add Network Adapters
 get-vm $vmName |  New-NetworkAdapter -NetworkName "INFRA-PG" -StartConnected -Type vmxnet3
 get-vm $vmName |  New-NetworkAdapter  -NetworkName "NFS-PG" -StartConnected -Type vmxnet3
 

 #Create CD and mount to ESXi image
 get-vm $vmName | New-CDDrive -ISOPath "[ISCSI-DATASTORE] ISO\ESXi-6-5-0-U1\VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso" -StartConnected
 #get-vm $vmName | Set-CDDrive -Confirm:$false
 
 #Enable VM HW virtualization
 $vm = Get-VM -Name $vmName
 $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec.nestedHVEnabled = $true
 $vm.ExtensionData.ReconfigVM($spec)

 #Set to 2 CPU sockets
 $VMname= get-vm -Name $vmName
 $TotalvCPU=8
 $Cores=4

 $spec=New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
 ($VMname).ExtensionData.ReconfigVM_Task($spec)
 $VMname | set-vm -numcpu $TotalvCPU -Confirm:$false


}

}

#
# CLOUD HOSTS (NSX + VSAN)
#

$VMNamesAll = "vESXi-11","vESXi-12","vESXi-13"

Foreach ($vmName in $VMNamesAll)
{

$Exists = get-vm -name $vmName -ErrorAction SilentlyContinue  
If ($Exists){  
     Write "VM $vmName is there"  
}  
Else { 

 #Create the VM
 New-VM -Name $vmName  -NumCpu 8 -MemoryMB 49152 -NetworkName "MGMT-PG" -Datastore datastore2 -DiskGB 128 -DiskStorageFormat Thin -GuestId otherGuest64 -Version v11

 #Change network adapter for VMNIC0 to VMXNET3
 get-vm $vmName | get-networkadapter | set-networkadapter -Type vmxnet3 -Confirm:$false
 
 #Add Network Adapters
 get-vm $vmName | New-NetworkAdapter -NetworkName "NSX-VTEP-PG" -StartConnected -Type vmxnet3
 get-vm $vmName | New-NetworkAdapter -NetworkName "INFRA-PG" -StartConnected -Type vmxnet3
 get-vm $vmName | New-NetworkAdapter -NetworkName "NFS-PG" -StartConnected -Type vmxnet3
 get-vm $vmName | New-NetworkAdapter -NetworkName "VSAN-PG" -StartConnected -Type vmxnet3

 #Create CD and mount to ESXi image
 get-vm $vmName | New-CDDrive -ISOPath "[ISCSI-DATASTORE] ISO\ESXi-6-5-0-U1\VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso" -StartConnected
 #get-vm $vmName | Set-CDDrive -Confirm:$false

 #Add Second Disk (for vSAN- SSD - cache tier)
 # get-vm $vmName | New-HardDisk -CapacityGB 128 -DiskType flat -ThinProvisioned -Datastore datastore3
 get-vm $vmName | New-HardDisk -CapacityGB 128 -Datastore datastore2

 #Add Third Disk (for vSAN - HDD - capacity tier)
 # get-vm $vmName | New-HardDisk -CapacityGB 128 -DiskType flat -ThinProvisioned -Datastore datastore3 
 get-vm $vmName | New-HardDisk -CapacityGB 128 -Datastore datastore3 

 #Add Fourth Disk (for vSAN - HDD - capacity tier)
 # get-vm $vmName | New-HardDisk -CapacityGB 128 -DiskType flat -ThinProvisioned -Datastore datastore3 
 get-vm $vmName | New-HardDisk -CapacityGB 128 -Datastore datastore3 


 #Enable VM HW virtualization
 $vm = Get-VM -Name $vmName
 $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec.nestedHVEnabled = $true
 $vm.ExtensionData.ReconfigVM($spec)

 #Set to 2 CPU sockets
 $VMname= get-vm -Name $vmName
 $TotalvCPU=8
 $Cores=4

 $spec=New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
 ($VMname).ExtensionData.ReconfigVM_Task($spec)
 $VMname | set-vm -numcpu $TotalvCPU -Confirm:$false

}  
}

# EDGE HOSTS
#
$VMNamesAll = "vESXi-21"


Foreach ($vmName in $VMNamesAll)
{

$Exists = get-vm -name $vmName -ErrorAction SilentlyContinue  
If ($Exists){  
     Write "VM $vmName is there"  
}  
Else {  
       
 #Create the VM
 New-VM -Name $vmName  -NumCpu 8 -MemoryMB 16384 -NetworkName "MGMT-PG" -Datastore datastore1 -DiskGB 256 -DiskStorageFormat Thin -GuestId otherGuest64 -Version v11

 #Change network adapter for VMNIC0 to VMXNET3
 get-vm $vmName | get-networkadapter | set-networkadapter -Type vmxnet3 -Confirm:$false
 
 #Add Network Adapters
 get-vm $vmName |  New-NetworkAdapter -NetworkName "INFRA-PG" -StartConnected -Type vmxnet3
 get-vm $vmName |  New-NetworkAdapter  -NetworkName "NFS-PG" -StartConnected -Type vmxnet3
 get-vm $vmName |  New-NetworkAdapter  -NetworkName "NSX-VTEP-PG" -StartConnected -Type vmxnet3
 

 #Create CD and mount to ESXi image
 get-vm $vmName | New-CDDrive -ISOPath "[ISCSI-DATASTORE] ISO\ESXi-6-5-0-U1\VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso" -StartConnected
 #get-vm $vmName | Set-CDDrive -Confirm:$false
 
 #Enable VM HW virtualization
 $vm = Get-VM -Name $vmName
 $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
 $spec.nestedHVEnabled = $true
 $vm.ExtensionData.ReconfigVM($spec)

 #Set to 2 CPU sockets
 $VMname= get-vm -Name $vmName
 $TotalvCPU=8
 $Cores=4

 $spec=New-Object –Type VMware.Vim.VirtualMAchineConfigSpec –Property @{“NumCoresPerSocket” = $cores}
 ($VMname).ExtensionData.ReconfigVM_Task($spec)
 $VMname | set-vm -numcpu $TotalvCPU -Confirm:$false


}

}


