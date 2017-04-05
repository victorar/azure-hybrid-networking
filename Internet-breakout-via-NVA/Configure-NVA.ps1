#Install Routing Feature
Install-WindowsFeature -Name "Routing" -IncludeAllSubFeature -IncludeManagementTools

#Rename network adapters (External has outbout connectivity, and internal does not)
Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null} | Rename-NetAdapter -NewName "External" -PassThru
Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -eq $null} | Rename-NetAdapter -NewName "Internal" -PassThru

#Get the IP Address of the External Adapter
$extIPAddress = Get-NetIPAddress -InterfaceAlias External | Where-Object {$_.AddressFamily -eq "IPV4"}

#Get the NAT IP Address as well as the NAT external address space
$natIP = $extIPAddress.IPAddress
$netPrefix = $extIPAddress.PrefixLength
$extAddressPrefix = $natIP.Substring(0,$natIP.LastIndexOf(".")) + ".0/" + $netPrefix

#Configure NAT
New-NetNat -Name 'NVANAT' -ExternalIPInterfaceAddressPrefix $extAddressPrefix
Add-NetNatExternalAddress -NatName 'NVANAT' -IPAddress $natIP -PortStart 5000 -PortEnd 49151
