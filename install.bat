@rem ##########################################################################
@rem
@rem  telegraf instalation script for Windows
@rem  list command:
@rem    - telegraf.exe --service uninstall	Remove the telegraf service
@rem    - telegraf.exe --service start	    Start the telegraf service
@rem    - telegraf.exe --service stop	    Stop the telegraf service
@rem
@rem ##########################################################################

start "download telegraf binary" wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.2_windows_amd64.zip -UseBasicParsing -OutFile telegraf-_windows_amd64.zip
start "extract zip to C:\Program Files\InfluxData\telegraf\" Expand-Archive .\telegraf-1.20.2_windows_amd64.zip -DestinationPath 'C:\Program Files\InfluxData\telegraf\'
start "go to telegraf source" cd "C:\Program Files\InfluxData\telegraf"
start "move telegraf binary and config to parent directory" mv .\telegraf-1.20.2\telegraf.* .
start "install Telegraf as a Windows service so that it starts automatically along with our system" .\telegraf.exe --service install --config 'C:\Program Files\InfluxData\telegraf\telegraf.conf'
start "test once to check instalation work" C:\"Program Files"\InfluxData\telegraf\telegraf.exe --config C:\"Program Files"\InfluxData\telegraf\telegraf.conf --test
start "start telegraf as a service and collect data" telegraf.exe --service start