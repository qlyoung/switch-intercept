# intercepting done, clean up
echo "[+] All done, cleaning up..."
killall arpspoof

# wait for arpspoof to die
wait

echo "[+] Hosts re-arped"
echo "[!] Please remember to reset your iptables rules. Current rules:"
iptables -S
