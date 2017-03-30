
$adapterPrefix = "Ethernet"
$extNIC="External"
$intNIC="Internal"

#Install Routing Feature
Install-WindowsFeature -Name "Routing" -IncludeAllSubFeature -IncludeManagementTools

#Rename Network Adapters
Get-NetAdapter -Name "$adapterPrefix 2" | Rename-NetAdapter -NewName $extNIC -PassThru
Get-NetAdapter -Name "$adapterPrefix 3" | Rename-NetAdapter -NewName $intNIC -PassThru

#Configure Routing and NAT gateway
Install-RemoteAccess -VpnType RoutingOnly
 
cmd.exe /c "netsh routing ip nat install"
cmd.exe /c "netsh routing ip nat add interface $extNIC"
cmd.exe /c "netsh routing ip nat set interface $extNIC mode=full"
cmd.exe /c "netsh routing ip nat add interface $intNIC"
