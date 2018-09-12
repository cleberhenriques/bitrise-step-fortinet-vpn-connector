#!/bin/bash
echo "Adding universe repository to apt-get"
sudo add-apt-repository "deb http://cz.archive.ubuntu.com/ubuntu cosmic main universe"

echo "Update repositories, installing ppp and openfortivpn"
sudo apt-get update && sudo apt-get install -y ppp && sudo apt-get install -y openfortivpn

echo "Starting VPN connection with gateway - ${host}:${port}"
sudo nohup openfortivpn ${host}:${port} --password=${password} --username=${username} --trusted-cert ${trusted_cert} &> $BITRISE_DEPLOY_DIR/logs.txt & disown

echo "Waiting connection"
( until fgrep -q "Tunnel is up" $BITRISE_DEPLOY_DIR/logs.txt; do sleep 1; done )
