# mar/28/2019 12:57:18 by RouterOS 6.40.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="WAN(LTE) interface"
set [ find default-name=ether2 ] comment="local net (LAN)"
/interface ovpn-client
add certificate=station2.crt_0 cipher=aes256 comment=kron-vpnpoint \
    connect-to=192.168.0.111 mac-address=02:03:D8:28:6D:58 name=ovpn-kron \
    user=kron
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip address
add address=192.168.0.1/24 disabled=yes interface=ether2 network=192.168.0.0
/ip dhcp-client
add disabled=no interface=ether1
/ip firewall filter
add action=fasttrack-connection chain=forward comment="established, related" \
    connection-state=established,related
add action=accept chain=forward comment="established, related" \
    connection-state=established,related
add action=drop chain=forward comment="defoult WAN drop" in-interface=ether1
add action=accept chain=forward comment=default
add action=accept chain=output comment=defoult
add action=accept chain=input comment="always allow ssh" dst-port=22 \
    protocol=tcp
add action=accept chain=input comment="allow ftp,http(config),win-box" \
    dst-port=22,21,80,8291 protocol=tcp
add action=accept chain=input comment=default
/ip firewall nat
add action=masquerade chain=srcnat comment="default SNAT" disabled=yes \
    out-interface=ether1
add action=dst-nat chain=dstnat comment=portforwarding disabled=yes dst-port=\
    8080 in-interface=ovpn-kron protocol=tcp to-addresses=192.168.0.175 \
    to-ports=80
/ip service
set telnet disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system logging
add action=echo disabled=yes topics=ovpn
/tool netwatch
add comment="EVA700 Watchedog" host=192.168.0.175 interval=30m
