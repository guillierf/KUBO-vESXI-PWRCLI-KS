#Connect to ESXi host
Connect-VIServer -User root -Password VMware1! -Server 10.172.209.70

$VMNamesAll = "vESXi-1","vESXi-11","vESXi-12","vESXi-13"
 
foreach($vm in $VMNamesAll){

$active = Get-VM $vm

if($active.PowerState -eq "PoweredOn"){
Get-VM $vm | Stop-VM -Kill -Confirm:$false
Get-VM $vm | Remove-VM -DeleteFromDisk -Confirm:$false -RunAsync}
else
{Get-VM $vm | Remove-VM -DeleteFromDisk -Confirm:$false -RunAsync}
}
