
$rgName = "ReadyLab-Networking"
$location = "West Europe"

Login-AzureRmAccount

New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmResourceGroupDeployment `
        -Name "DeployNetworkResources" `
        -ResourceGroupName $rgName `
        -TemplateFile .\azuredeploy.json `
        -Verbose
