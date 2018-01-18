
#Login-AzureRmAccount

$rgName = "IgniteUserRG"
$spokeAddressSpace = "10.100.0.0/16"

$vNets = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName

foreach($vnet in $vNets){
    if($vnet.AddressSpace.AddressPrefixes -eq $spokeAddressSpace){
        Write-Host "Deleting VNet..." $vnet.Name -ForegroundColor Cyan
        $vnet | Remove-AzureRmVirtualNetwork -Force
    }
}

