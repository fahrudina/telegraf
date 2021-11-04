#rem ##########################################################################
#rem
#rem  telegraf instalation script for Windows
#rem  list command:
#rem    - telegraf.exe --service uninstall	Remove the telegraf service
#rem    - telegraf.exe --service start	    Start the telegraf service
#rem    - telegraf.exe --service stop	    Stop the telegraf service
#rem
#rem ##########################################################################

function Is-Service-Exist {
    #check service exist
    $service = Get-Service -Name W32Time -ErrorAction SilentlyContinue
    return ($service.Length -gt 0) 
}

$config = 'C:\Program Files\InfluxData\telegraf\telegraf.conf'
function Register-Service {
    Write-Host "install Telegraf as a Windows service so that it starts automatically along with our system" 
        C:\'Program Files'\InfluxData\telegraf\telegraf.exe --service install --config $config
    Write-Host "test once to check instalation work"
        C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config $config --test
    Write-Host "start telegraf as a service and collect data"
        C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config $config --service start
}

function Install-Telegraf {
    if (Is-Service-Exist) {
        # if service allready exist in the system
        # stop it before remove
        C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config $config --service stop
    }

    Write-Host "remove folder"
        Remove-Item -LiteralPath 'C:\Program Files\InfluxData\telegraf' -Force -Recurse -Confirm:$false
    Write-Host "download telegraf" 
        wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.2_windows_amd64.zip -UseBasicParsing -OutFile telegraf-1.20.2_windows_amd64.zip
    Write-Host "extract zip to C:\Program Files\InfluxData\telegraf\" 
        Expand-Archive .\telegraf-1.20.2_windows_amd64.zip -DestinationPath 'C:\Program Files\InfluxData\telegraf\'
    Write-Host "move telegraf binary and config to parent directory" 
        mv 'C:\Program Files\InfluxData\telegraf\telegraf-1.20.2\telegraf.*' 'C:\Program Files\InfluxData\telegraf'
    
    Register-Service
}

function Question-To-Install {
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Install ulang'
    $no = New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'Tidak install ulang'
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $result = $host.ui.PromptForChoice('Install ulang?', 'Apakah anda ingin install?', $options, 0)

    switch ($result)
        {
            0 {
                $message = "Melakukan install ..."
                $install = $true
            }
            1 {
                $install = $false
            }
        }
    Write-Host $message
    return $install
}

# Full path of the file
$file = 'C:\Program Files\InfluxData\telegraf\telegraf.exe'

#If the file exist, ask what action need to do
if (Test-Path -Path $file -PathType Leaf) {
    Write-Host "Telegraf sudah terinstall, apakah kamu mau install ulang?"
    if (Question-To-Install) {
        Install-Telegraf
    }else {
        #check service exist
        if (-not(Is-Service-Exist)) {
            # Service not exist in system try to register service to system and start it
            Register-Service
        }
    }
}
#Telegraf not exist, start to install telegraf
else {
    Install-Telegraf
}