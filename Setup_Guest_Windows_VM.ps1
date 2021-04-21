Write-Host "Please select one of the options below: `n (1) Check if firewall has open ports required for NGT `n (2) Open ports 5986 and 23578"

$userIn = Read-Host -Prompt "`n"

if ($userIn -eq "1"){
    $fireOutput = Get-NetFirewallPortFilter | Select-Object LocalPort | Select-String -Pattern "(5986)|(23578)"
    #$fireOutput = Get-NetTCPConnection | Select-Object LocalPort, State, LocalAddress | Select-String -Pattern "(5968)|(23578)"
    if ($fireOutput -eq $null){
        Write-Host "`n The required ports are not open"
        $addboth = Read-Host -Prompt "Would you like to add both? (yes/no)"
        if ($addboth -eq "yes"){
            netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow 
            netsh advfirewall firewall add rule name="Nutanix-IPC" dir=in localport=23578 protocol=TCP action=allow
           Get-NetFirewallPortFilter | Select-Object LocalPort | Select-String -Pattern "(5986)|(23578)"
           # sleep 5; netsh advfirewall firewall delete rule name="WinRM-HTTPS"
           # sleep 5; netsh advfirewall firewall delete rule name="Nutanix-IPC"
            }

        }

    if ($fireOutput -like '*5986*' -and $fireOutput -like "*23578*"){
       Write-Host "Both ports are there"
    }
    elseif ($fireOutput -notlike '*5986*' -and $fireOutput -like "*23578*"){
       Write-Host "Port 5986 is not open"
    }
    elseif ($fireOutput -like '*5986*' -and $fireOutput -notlike "*23578*"){
       Write-Host "Port 23578 is not open"
    }
}