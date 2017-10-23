# KUBO-vESXI-PWRCLI-KS
# PowerCLI scripts and KickStart Config files to set up PKS/NSX-T/vSAN in a nested lab environment

This repository contains powerCLI scripts to create vESXi VM in a nested LAB environment and then kickstart ESXi configurtions using configuration files.
The lab environment is intended to have NSX-T and vSAN.

## Create vESXi VM

* Use powerCLI script '1-create-vESXi-PKS-NSX-VSAN-ALL.ps1' to create following vESXi VMs:

vESXi-1: used for MGMT (must be part of MGMT Cluster)
vESXi-11, vESXi-12, vESXi-13: used for COMPUTE (must be part of COMPUTE Cluster)
vESXi-21: used for EDGE (must be part of EDGE Cluster)

Procedure:

Open VMware vSphere PowerCLI application.

Go to the directory where the script is located.

Then type:
```
.\1-create-vESXi-PKS-NSX-VSAN-ALL.ps1
```


## Kickstart ESXi configs

* Use kickstart config files 'ks-SC-vESXi-<x>.cfg'to automatically configure ESXi during the hypervisor install phase.
  
  Place the kickstart config files at the root directory of your web server.
  
  Procedure:
  
  Start the vESXi VM. It should start loading the ESXi ISO.
  select install from the installer
  press SHIFT + o (letter o)
  type:
  ```
  ks=http://<web server ip>/ks-SC-vESXi-<x>.cfg ip=<temporary IP> netmaks=<netmask> gateway=<gateway>
  ```
  for instance:
  ```
  ks=http://10.40.206.13:8080/ks-vESXi-1.cfg ip=10.173.13.10 netmask=255.255.255.128 gateway=10.173.13.125
  ```
  
