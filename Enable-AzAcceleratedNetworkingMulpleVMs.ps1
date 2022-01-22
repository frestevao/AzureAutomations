<#
Author: Estevão França
Script Description: This script will enable the Accelerated Nerworking in multiple VM's under the same RG
Date: 01/19/2021
Version: 1
#>


#Variables Section
$subscriptionId = ""
$tenantId = ""
$resourceGroupName = ""
$enableAcceleratedNic = $True #The Value Should be True or False

#Connecting on Azure Tenant ...
$null = az login --tenant $tenantId

#Selecting Subscription
az account set --subscription $subscriptionId

#Getting list of VM's under the RG
$azureVM = az vm list -g $resourceGroupName | ConvertFrom-Json

foreach ($vm in $azureVM){
    #Getting VM details
    $vmSetting = az vm show -n $vm.name -g $resourceGroupName | ConvertFrom-Json
    Write-Host "=================="-ForegroundColor Green
    Write-Host "Working on VM:"$vm.Name

    #Enabling Accelerated networking
    Write-Output "Checking the Accelerated Networking...."

    $nicState = az network nic show --name $vmSetting.networkProfile.networkInterfaces.Id.Split('/')[8] --resource-group $resourceGroupName | ConvertFrom-Json

    [string]$vmSize = "'" + $vmSetting.hardwareProfile.vmSize + "'"
    $vmNumberOfCores = az vm list-sizes -l $vmSetting.location --query "[?contains(name, $vmSize)]" | ConvertFrom-Json

    # This condition checks if the Accelerated network is already enabled, if it is, the script will ignore the VM and got to the next
    if ($nicState.enableAcceleratedNetworking -eq $false -and $vmNumberOfCores.NumberOfCores -ge 4){
        Write-Host "Accelerated networking is not enabled..."
        Write-Host "Enabling..."
        # Deallocate the VM
        Write-Host "Checking if the VM is deallocated" -ForegroundColor Gray
        $status = az vm get-instance-view --name $vm.name --resource-group $resourceGroupName --query instanceView.statuses[1] -o json | ConvertFrom-Json
        Start-Sleep -Seconds 5

        if ($status.displayStatus -eq "VM deallocated"){
            Write-Host "VM already deallocated" -ForegroundColor Green
        }else {
            Write-Host "The VM" $vm.name "is running and will be deallocated" -ForegroundColor Red
            az vm deallocate --name $vm.name --resource-group $resourceGroupName
        }

        #enabling ...
        az network nic update --name $vmSetting.networkProfile.networkInterfaces.Id.Split('/')[8] --resource-group $resourceGroupName --accelerated-networking $enableAcceleratedNic --verbose      
        #Starting VM
        Write-Output "Starting VM..."
        az vm start --name $vm.name --resource-group $resourceGroupName
        Write-Host "Preparing next VM.."
        Write-Host "================" -ForegroundColor Green

    }else {
        Write-Host "Accelerated nic is enabled or cannot be enabled on VM:" $vm.name -ForegroundColor Red
        Write-Host "Going to the Next VM..."
        Write-Host "===============" -ForegroundColor Green
    }

}
