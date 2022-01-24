<#
Author: Estevão França
Script Description: This script will enable the Accelerated Nerworking in multiple VM's under the same RG
Date: 01/19/2021
Version: 1

.Example 

.\Enable-AzAcceleratedNicMultipleVMs.ps1 -subscriptionId <SubscriptionId> -tenantId <TenantId> -resourceGroupName <ResourceGroupName>

#>

param(
    [Parameter(Mandatory=$True)]
    [string]$subscriptionId,
    
    [Parameter(Mandatory=$True)]
    [string]$tenantId,
    
    [Parameter(Mandatory=$True)]
    [string]$resourceGroupName
)

if ($null -eq $subscriptionId -or $null -eq $tenantId -or $null -eq $resourceGroupName) {
    Write-Error "Please, Execute the Script again"
}else {
    #Connecting on Azure Tenant ...
    Write-Host "Login into the Azure Account" -ForegroundColor Blue
    $null = az login --tenant $tenantId --verbose

    #Selecting Subscription
    Write-Host "Selecting the Subscription..." -ForegroundColor Blue
    az account set --subscription $subscriptionId --verbose
}


#Variables Section
$enableAcceleratedNic = $True #The Value Should be True or False

#Getting list of VM's under the RG
$azureVM = az vm list -g $resourceGroupName | ConvertFrom-Json

foreach ($vm in $azureVM){
    #Getting VM details
    $vmSetting = az vm show -n $vm.name -g $resourceGroupName | ConvertFrom-Json
    Write-Host "=================="-ForegroundColor Green
    Write-Host "Working on VM:"$vm.Name

    #Enabling Accelerated networking
    Write-Output "Checking the Accelerated Networking...."

    #Getting Network Adapter properties
    $nicState = az network nic show --name $vmSetting.networkProfile.networkInterfaces.Id.Split('/')[8] --resource-group $resourceGroupName | ConvertFrom-Json

    #Checking VM Number of cores
    [string]$vmSize = "'" + $vmSetting.hardwareProfile.vmSize + "'"
    $vmNumberOfCores = az vm list-sizes -l $vmSetting.location --query "[?contains(name, $vmSize)]" | ConvertFrom-Json

    #Checking if VM is part of an availability set

    if ($null -eq $vmSetting.availabilitySet.id){
        Write-Host " This vm is not part of an availability set"
        Write-Host "Moving forward with the deployment..."
    }else {
        Write-Warning -Message "This VM is part of an availability set and due this, the deployment may fail. If you get an error, please check the Microsoft Documentation" 
    }
    
    Write-Host ""
    Write-Host ""

    # This condition checks if the Accelerated network is already enabled, if it is, the script will ignore the VM and got to the next
    if ($nicState.enableAcceleratedNetworking -eq $false -and $vmNumberOfCores.NumberOfCores -ge 4){
        Write-Host "Accelerated networking is not enabled..."
        Write-Host "Enabling..."

        Write-Host ""
        Write-Host ""

        # Deallocate the VM
        Write-Host "Checking if the VM is deallocated" -ForegroundColor Gray
        $status = az vm get-instance-view --name $vm.name --resource-group $resourceGroupName --query instanceView.statuses[1] -o json | ConvertFrom-Json
        Start-Sleep -Seconds 5
        Write-Host ""
        if ($status.displayStatus -eq "VM deallocated"){
            Write-Host "VM already deallocated" -ForegroundColor Green
        }else {
            Write-Host "The VM" $vm.name "is running and will be deallocated" -ForegroundColor Red
            az vm deallocate --name $vm.name --resource-group $resourceGroupName
        }
        Write-Host ""
        Write-Host ""
        #enabling ...
        Write-Host ""
        Write-Host "Enabling Accelerated Networking..."
        az network nic update --name $vmSetting.networkProfile.networkInterfaces.Id.Split('/')[8] --resource-group $resourceGroupName --accelerated-networking $enableAcceleratedNic
        #Starting VM
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Output "Starting VM..."
        Write-Host ""
        Write-Host ""
        az vm start --name $vm.name --resource-group $resourceGroupName --no-wait
        Write-Warning -Message "VM will be started in the backgroud, please check VM state over the Azure Portal"
        Write-Host "Preparing next VM.." -ForegroundColor Yellow
        Write-Host "================" -ForegroundColor Green
        Write-Host ""

    }else {
        Write-Host ""
        Write-Host ""
        Write-Host "Accelerated nic is enabled or cannot be enabled on VM:" $vm.name -ForegroundColor Red
        Write-Host "Going to the Next VM..."
        Write-Host ""
        Write-Host "===============" -ForegroundColor Green
    }

}
