#Checking if the Log path Exist

$logPath = Test-Path -Path "C:\scriptlogs"

if ($logPath -eq $false){

    Write-Error -Message "Log path doesn't exist"
    mkdir c:\logs
    
}else {
    Write-Output "Log path does exist"
}

$updates = Start-WUScan 
Write-Output "======================================================" >> C:\scriptlogs\log.txt
Write-Output "List of updates that will be applied" >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt
Write-Output ""  >> C:\scriptlogs\log.txt

foreach ($update in $updates){

Write-Output $update.Title >> C:\scriptlogs\log.txt

}

Write-Output ""  >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt
Write-Output "End of the list of updates" >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt

Write-Output ""  >> C:\Users\admstvao\Desktop\logs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt
Write-Output "Starting the patching application" >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt

$installUpdates = Install-WuUpdates (Start-WUScan)

if ($installUpdates -eq $true){

    Write-Output "Patches were applied with success" >> C:\scriptlogs\log.txt

    $rebootstatus = Get-WUIspendingReboot

   if ($rebootstatus -eq $true){
    
        Write-Output "Patches applied and the server will be rebooted"  >> C:\scriptlogs\log.txt

        Restart-Computer -Force
   
   }else{
   
        Write-Output "Unknown error"  >> C:\scriptlogs\log.txt
    
    }

}Else{

    Write-Output "Unknown error " >> C:\scriptlogs\log.txt
}

Write-Output ""  >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt
Write-Output "End of the code" >> C:\scriptlogs\log.txt
Write-Output "======================================================" >> C:\scriptlogs\log.txt 
