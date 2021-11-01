#!/bin/bash

# check user role need access as root
if [ "$EUID" -ne 0 ]
  then echo "This script need access as root!\n please run with sudo"
  exit
fi

# download telegraf binary
VERSION="1.20.2"

mkdir -p /tmp/telegraf && \
cd /tmp/telegraf && \
curl -O https://dl.influxdata.com/telegraf/releases/telegraf-${VERSION}_linux_amd64.tar.gz && \
    tar xf telegraf-${VERSION}_linux_amd64.tar.gz && \
    cd telegraf-${VERSION}

# set telegraf service for auto restart when server restart
# command to reload the systemd manager configuration
    # systemctl daemon-reload
# command to start: 
    # sudo systemctl start telegraf
# command to check status: 
    # sudo systemctl status telegraf
# command to stop: 
    # sudo systemctl stop telegraf
# command to reload config:
    # sudo systemctl reload telegraf
# command to enable service on every reboot
    # sudo systemctl enable telegraf
# command to disable on evert reboot
    # sudo systemctl disable telegraf
# commad to view log from syslog
    # tail -f /var/log/syslog

#TODO:
    # get token and generateID
    # get unique macID from server and register to netmonk server
    # set URL dinamoc value to URL 

#  set value URL here!!
    URL=http://localhost:8080/telegrafs

###
MPID='$MAINPID'
cat << EOF > usr/lib/telegraf/scripts/telegraf.service
[Unit]
Description=The plugin-driven server agent for reporting metrics into InfluxDB
Documentation=https://github.com/influxdata/telegraf
After=syslog.target network.target
ConditionFileIsExecutable=/usr/bin/telegraf

StartLimitBurst=5
StartLimitIntervalSec=10

[Service]
ExecStart=/usr/bin/telegraf "--config" $URL "--service" "telegraf" "--config-directory" "/etc/telegraf/telegraf.d"
ExecReload=/bin/kill -HUP $MPID
Restart=always
RestartSec=60
StandardOutput=/var/log/telegraf/telegraf.log
StandardError=/var/log/telegraf/telegraf.log
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

# setup
cp -r etc/* /etc/ && cp -r var/log/* /var/log/ && cp -r usr/bin/* /usr/bin/ && cp -r usr/lib/telegraf/scripts/telegraf.service /etc/systemd/system/
rm -rf /tmp/telegraf
cd -

sudo systemctl daemon-reload && sudo systemctl stop telegraf && sudo systemctl enable telegraf && sudo service telegraf start