
$rgName = "ReadyLab-Networking"
#$templateUri = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ready-Labs/HubAndSpoke/azuredeploy.json"

Login-AzureRmAccount

$templateParams = @{
    vnetName = "Hub-VNet";    
}

New-AzureRmResourceGroupDeployment `
        -Name "DeployNetworkResources" `
        -ResourceGroupName $rgName `
        -TemplateFile .\ExpressRouteGW\azuredeploy.json `
        -TemplateParameterObject $templateParams `
        -Verbose
