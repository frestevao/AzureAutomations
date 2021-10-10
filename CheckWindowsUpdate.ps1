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

Write-Output "======================================================" 
Write-Output "End of the code"
Write-Output "======================================================"
