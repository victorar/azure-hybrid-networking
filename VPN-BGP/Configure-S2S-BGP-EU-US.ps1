#region 1. Setting up variables
##Instructions / More information
##https://azure.microsoft.com/en-us/documentation/articles/vpn-gateway-bgp-resource-manager-ps/

#Variables required for West US vNet
$Sub1 = "BalaN"
$GWIPName1 = "VNet1GWIP"
$RG1 = "HybridCAT-Lab"
$Location1 = "West US"
$VNetName1 = "HybridCAT-US-VNET"
$GWIPconfName1 = "gwipconf1"
$GWName1 = "USWestGW"
$VNet1ASN = 65010
$Connection12 = "VNet1toVNet2"

#Variables required for West Europe vNet
$Sub2 = "VictorAr"
$GWIPName2 = "VNet2GWIP"
$RG2 = "hybridcat-lab"
$Location2 = "West Europe"
$VNetName2 = "hybridcat-emea-vnet"
$GWIPconfName2 = "gwipconf2"
$GWName2 = "VNet2GW"
$VNet2ASN = 65020
$Connection21 = "VNet2toVNet1"

Login-AzureRmAccount
#endregion

#region 2. Create VPN Gateway for West Europe vNet with BGP Parameters - Subscription 2
Select-AzureRmSubscription -SubscriptionName $Sub2

$gwpip2    = New-AzureRmPublicIpAddress -Name $GWIPName2 -ResourceGroupName $RG2 -Location $Location2 -AllocationMethod Dynamic

$vnet2     = Get-AzureRmVirtualNetwork -Name $VNetName2 -ResourceGroupName $RG2
$subnet2   = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet2
$gwipconf2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName2 -Subnet $subnet2 -PublicIpAddress $gwpip2

New-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2 -Location $Location2 -IpConfigurations $gwipconf2 -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard -Asn $VNet2ASN
#endregion

#region 3. Create VPN Gateway for West US vNet with BGP Parameters - Subscription 1
Select-AzureRmSubscription -SubscriptionName $sub1

$gwpip1    = New-AzureRmPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG1 -Location $Location1 -AllocationMethod Dynamic

$vnet1     = Get-AzureRmVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1
$subnet1   = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1
$gwipconf1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $subnet1 -PublicIpAddress $gwpip1

New-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1 -Location $Location1 -IpConfigurations $gwipconf1 -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard -Asn $VNet1ASN
#endregion

#region 4. Connect West US and West Europe vNets gateways
Select-AzureRmSubscription -SubscriptionName $sub1
$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1

Select-AzureRmSubscription -SubscriptionName $sub2
$vnet2gw = Get-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2

Select-AzureRmSubscription -SubscriptionName $sub1
New-AzureRmVirtualNetworkGatewayConnection -Name $Connection12 -ResourceGroupName $RG1 -VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet2gw -Location $Location1 -ConnectionType Vnet2Vnet -SharedKey 'AzureHybridCAT1' -EnableBgp True

Select-AzureRmSubscription -SubscriptionName $sub2
New-AzureRmVirtualNetworkGatewayConnection -Name $Connection21 -ResourceGroupName $RG2 -VirtualNetworkGateway1 $vnet2gw -VirtualNetworkGateway2 $vnet1gw -Location $Location2 -ConnectionType Vnet2Vnet -SharedKey 'AzureHybridCAT1' -EnableBgp True
#endregion

