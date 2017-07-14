
$rgName = "ReadyLab-Networking"
$location = "West US"
$templateUri = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ready-Labs/HubAndSpoke/azuredeploy.json"

Login-AzureRmAccount

New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmResourceGroupDeployment `
        -Name "DeployNetworkResources" `
        -ResourceGroupName $rgName `
        -TemplateUri $templateUri `
        -Verbose
