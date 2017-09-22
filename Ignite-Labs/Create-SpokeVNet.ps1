
$rgName = "IgniteUserRG"
$location = "West US"
$templateUri = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ignite-Labs/SpokeVNet/azuredeploy.json"

Login-AzureRmAccount

New-AzureRmResourceGroupDeployment `
        -Name "DeployNetworkResources" `
        -ResourceGroupName $rgName `
        -TemplateUri $templateUri `
        -Verbose
