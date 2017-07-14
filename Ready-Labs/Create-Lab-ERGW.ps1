
$rgName = "ReadyLab-Networking"
$templateUri = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ready-Labs/ExpressRouteGW/azuredeploy.json"

Login-AzureRmAccount

$templateParams = @{
    vnetName = "Hub-VNet";    
}

New-AzureRmResourceGroupDeployment `
        -Name "DeployNetworkResources" `
        -ResourceGroupName $rgName `
        -TemplateUri $templateUri `
        -TemplateParameterObject $templateParams `
        -Verbose
