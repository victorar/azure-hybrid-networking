#Install Routing Feature
Install-WindowsFeature -Name "Routing" -IncludeAllSubFeature -IncludeManagementTools

#Rename network adapters (External has outbout connectivity, and internal does not)
Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null} | Rename-NetAdapter -NewName "External" -PassThru
Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -eq $null} | Rename-NetAdapter -NewName "Internal" -PassThru

#Get the IP Address of the External Adapter
$extIPAddress = Get-NetIPAddress -InterfaceAlias External | Where-Object {$_.AddressFamily -eq "IPV4"}

#Configure Routing and NAT gateway
Install-RemoteAccess -VpnType RoutingOnly
 
cmd.exe /c "netsh routing ip nat install"
cmd.exe /c "netsh routing ip nat add interface $extNIC"
cmd.exe /c "netsh routing ip nat set interface $extNIC mode=full"
cmd.exe /c "netsh routing ip nat add interface $intNIC"
