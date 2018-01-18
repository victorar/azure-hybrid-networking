
#region 1. Declare variables
# Navigate to the downloaded folder and import the **Connect** PowerShell module
Import-Module C:\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1

$ArmEndpoint = "https://management.local.azurestack.external"
$GraphAudience = "https://graph.windows.net/"
$aadTenant   = "yourAADtenant.onmicrosoft.com"

$UserName = 'youruser@yourAADtenant.onmicrosoft.com'

$rgName = "AzS-ReadyLab"
$location = "local"

#endregion

#region 2. Connect to Azure Stack subscription via PowerShell
# Register an AzureRM environment that targets your Azure Stack instance
Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint $ArmEndpoint

# Set the GraphEndpointResourceId value
Set-AzureRmEnvironment -Name "AzureStackUser" -GraphAudience $GraphAudience

# Get the Active Directory tenantId that is used to deploy Azure Stack
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $aadTenant -EnvironmentName "AzureStackUser"

# Sign in to your environment
Write-Host "Please sign in to Azure Stack subscription as $UserName" -ForegroundColor Cyan
Login-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantID
#endregion

#region 3. (only required for new deployments) Register resource providers

foreach($s in (Get-AzureRmSubscription)) {
        Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
Get-AzureRmResourceProvider -ListAvailable | Register-AzureRmResourceProvider
    }

#endregion

#region 4. Create resource group in Azure Stack

Remove-AzureRmResourceGroup -Name $rgName -Force -ErrorAction Ignore
New-AzureRmResourceGroup -Name $rgName -Location $location

#endregion

#region 5. Deploy resources in Azure Stack (VNet, Gateway, VM)

$azsTemplate = "https://raw.githubusercontent.com/victorar/azure-hybrid-networking/master/Ready-Labs/1801/AzureStack/azuredeploy.json"

$azsParams = @{
    localGatewayIpAddress = "x.x.x.x";          #Public IP Address of the VPN gateway in Azure
    localAddressPrefix1 = "192.168.2.0/24";     #Address space of the hub VNet in Azure
    localAddressPrefix2 = "10.101.0.0/16";      #Address space of the spoke VNet in Azure
    VNetAddressPrefix = "10.51.0.0/16";         #Address space of the Azure Stack VNet
    subnetPrefix = "10.51.1.0/24";              #Subnet in Azure Stack VNet
    gatewaySubnetPrefix = "10.51.0.0/24";       #Gateway subnet in Azure Stack
    sharedKey = "abc123";                       #pre-shared key for VPN
    vmName = "AZSVM01";                         #Name of the VM to be created
    adminUsername = "azsadmin";                 #Administrator of the VM to be created
    adminPassword = "YourAdminPWD"              #Password of the VM administrator
}

New-AzureRmResourceGroupDeployment -Name "Azs-Resources" -ResourceGroupName $rgName -TemplateFile $azsTemplate -TemplateParameterObject $azsParams -Verbose
            
#endregion

