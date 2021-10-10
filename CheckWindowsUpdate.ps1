$updates = Start-WUScan 
Write-Output "======================================================" 
Write-Output "List of updates that will be applied" 
Write-Output "======================================================" 
Write-Output ""  

foreach ($update in $updates){

Write-Output $update.Title

}

Write-Output ""  
Write-Output "======================================================" 
Write-Output "End of the list of updates" 
Write-Output "======================================================" 

Write-Output ""  
Write-Output "======================================================" 
Write-Output "Starting the patching application" 
Write-Output "======================================================" 

$installUpdates = Install-WuUpdates (Start-WUScan)

if ($installUpdates -eq $true){

    Write-Output "Patches were applied with success" 

    $rebootstatus = Get-WUIspendingReboot

   if ($rebootstatus -eq $true){
    
        Write-Output "Patches applied and the server will be rebooted"

        Restart-Computer -Force
   
   }else{
   
        Write-Output "Unknown error" 
    
    }

}Else{

    Write-Output "Unknown error "
}

Write-Output "======================================================" 
Write-Output "End of the code"
Write-Output "======================================================"
