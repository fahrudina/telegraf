#rem ##########################################################################
#rem
#rem  telegraf instalation script for Windows
#rem  list command:
#rem    - telegraf.exe --service uninstall	Remove the telegraf service
#rem    - telegraf.exe --service start	    Start the telegraf service
#rem    - telegraf.exe --service stop	    Stop the telegraf service
#rem
#rem ##########################################################################

Write-Host "remove folder"
    Remove-Item -LiteralPath 'C:\Program Files\InfluxData\telegraf' -Force -Recurse -Confirm:$false
Write-Host "download telegraf" 
    wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.2_windows_amd64.zip -UseBasicParsing -OutFile telegraf-1.20.2_windows_amd64.zip
Write-Host "extract zip to C:\Program Files\InfluxData\telegraf\" 
    Expand-Archive .\telegraf-1.20.2_windows_amd64.zip -DestinationPath 'C:\Program Files\InfluxData\telegraf\'
Write-Host "move telegraf binary and config to parent directory" 
    mv 'C:\Program Files\InfluxData\telegraf\telegraf-1.20.2\telegraf.*' 'C:\Program Files\InfluxData\telegraf'
Write-Host "install Telegraf as a Windows service so that it starts automatically along with our system" 
    C:\'Program Files'\InfluxData\telegraf\telegraf.exe --service install --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf'
Write-Host "test once to check instalation work"
    C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf' --test
Write-Host "start telegraf as a service and collect data"
    C:\'Program Files'\InfluxData\telegraf\telegraf.exe --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf' --service start