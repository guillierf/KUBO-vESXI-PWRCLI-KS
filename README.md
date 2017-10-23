# KUBO-vESXI-PWRCLI-KS
# PowerCLI scripts and KickStart Config files to set up PKS/NSX-T/vSAN in a nested lab environment

This repository contains powerCLI scripts to create vESXi VM in a nested LAB environment and then kickstart ESXi configurtions using configuration files.
The lab environment is intended to have NSX-T and vSAN.

## Create vESXi VM

* Use powerCLI script '1-create-vESXi-PKS-NSX-VSAN-ALL.ps1' to create vESXi VM.

vESXi-1: used for MGMT (must be part of MGMT Cluster)
vESXi-11, vESXi-12, vESXi-13: used for COMPUTE (must be part of COMPUTE Cluster)
vESXi-21: used for EDGE (must be part of EDGE Cluster)

## Kickstart ESXi configs

* Use kickstart config files 'ks-SC-vESXi-<x>.cfg'to automatically configure ESXi during the hypervisor install phase.
  
  Place the kickstart config files at the root directory of your web server.
  
  Procedure:
  
  start the vESXi VM
  select install from the installer
  press SHIFT + o (letter o)
  type:
  ```
  ks=http://<web server ip>/ks-SC-vESXi-<x>.cfg ip=<temporary IP> netmaks=<netmask> gateway=<gateway>
  ```
  
