#!/bin/bash
echo "Adding universe repository to apt-get"
sudo add-apt-repository "deb http://cz.archive.ubuntu.com/ubuntu cosmic main universe"

echo "Update repositories, installing ppp and openfortivpn"
sudo apt-get update && sudo apt-get install -y ppp && sudo apt-get install -y openfortivpn

echo "Installing iputils"

sudo apt-get install -y iputils-ping

echo "Starting VPN connection with gateway - ${host}:${port}'}"

sudo printf ${password} | nohup openfortivpn ${host}:${port} --username=${username} --trusted-cert ${trusted_cert} &> $BITRISE_DEPLOY_DIR/logs.txt & disown


printf "%s" "waiting for VPN connection ..."
while ! ping -c 1 ${host} &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n"  "VPN connection is up and running"
