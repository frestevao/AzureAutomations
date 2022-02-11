.SYNOPSIS
    Enable-AzAcceleratedNetworkingMultipleVMs is a sample script that can help Azure Administrators to enable Accelerated Networking in multiple VM's in the same Resource Group
.DESCRIPTION
    This script will helps to enable the Accelerated Networking in multilple VM's under the same Resource Group, it will verify if the feature is enabled and if the VM does supports.
.PARAMETER SubscriptionId
    You need to inform the subscriptionId, in case your tenant has more than one subscription.
.PARAMETER TenantId
    You need to inform the tenantId, in case your user has access to more than one Tenant.
.PARAMETER ResourceGroupName    
    Resource Group where you store your VM's
.DESCRIPTION
    This script will enable the Accelerated Nerworking in multiple VM's under the same RG
.Example 
    .\Enable-AzAcceleratedNicMultipleVMs.ps1 -subscriptionId <SubscriptionId> -tenantId <TenantId> -resourceGroupName <ResourceGroupName>
.NOTES
    Version: 1
    Date: 01/24/2022

.NOTES

    I'm not responsble for any damage on your environment, please validade the script before running on your production environment.
