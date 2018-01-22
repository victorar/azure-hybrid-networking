
$rgName = "Azure-ReadyLab"
$location = "West US"
$templateUri = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ready-Labs/1801/Azure/VPN/azuredeploy.json"

Login-AzureRmAccount

Remove-AzureRmResourceGroup -Name $rgName -Force -ErrorAction Ignore
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmResourceGroupDeployment `
        -Name "ReadyLab-AzureDeployment" `
        -ResourceGroupName $rgName `
        -TemplateUri $templateUri `
        -Verbose
