switch-intercept
================

switch-intercept is a convenience script that automates system setup and teardown for executing
man-in-the-middle attacks against local hosts behind a router or switch via ARP spoofing + mitmproxy.

Purpose
-------
A common attack vector against a target on the same switch as you is to use ARP cache poisoning to convince 
the target that their default gateway is a machine which you control. This allows you to transparently execute
a man-in-the-middle attack against the target.

This type of MITM attack is quite simple, but it's a multistep process; first you have to poison the target's
ARP cache, then configure the MITM box to forward IPv4 packets so the target can still get out to the Internet, and
finally actually capture the traffic flowing through your machine.

Doing this by hand against an active target will probably result in them noticing some kind of network disruption
while you get all the pieces in place. This script bundles all the necessary setup and teardown together to make
this easier and, more importantly, much faster.

For more information about mitmproxy, see http://mitmproxy.org/doc/config.html.

For more information on this particular attack, see https://en.wikipedia.org/wiki/ARP_spoofing.

Dependencies
------------
    # apt-get install dsniff libffi-dev python-dev libxml2-dev libxslt-dev
    # pip install mitmproxy

Use
---
    # ./live-intercept.sh <interface> <victim> <gateway>
    # ./passive-intercept.sh <interface> <victim> <gateway> <logfile>

* ```<interface>``` is the network interface connected to the LAN (e.g. wlan0, eth0)

* ```<victim>```    is the local IP address of the victim (e.g. 192.168.1.101)

* ```<gateway>```   is the local IP address of the victim's default gateway (e.g. 192.168.1.1)

* ```<logfile>```   is the path of the file to log intercepted HTTP packets to (e.g. mitmdump-outfile.dump)


The live- variant will launch mitmproxy for live traffic auditing. Note that using mitmproxy in this mode will result in
all intercepted traffic being kept in memory for the duration of the session, so it isn't suited for long-term monitoring.

The passive- variant will launch mitmdump, which will write a summary of each intercepted packet to stdout and log (append) full
packets to ```<logfile>```.

Notes
-----
By default, both HTTP (port 80) and HTTPS (port 443) are forward to mitmproxy (8080). Hence, if the
target specified does not trust the mitmproxy root certificate, they will receive a big fat SSL
warning every time they attempt to access an HTTPS resource. DO NOT specify a target who does
not trust the SSL certificate unless you want to reveal yourself.

If you only want to intercept HTTP, comment out the appropriate line before running the script.

Note that after running this script once, the iptables rules that forward these ports to mitmproxy
will stay in memory until you reboot.

License
-------
```
Copyright 2015  Quentin Young

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
```
