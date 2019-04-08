# mar/28/2019 12:57:18 by RouterOS 6.40.5
# software id = 
#
# model = RB912R-2nD
# serial number = 9913091B1189

/interface lte
set [ find ] name=lte1

/interface lte apn
set [ find default=yes ] apn=drei.at

/interface ethernet
set [ find default-name=ether1 ] comment="local net (LAN)"

/interface ovpn-client
add certificate=station2.crt_0 cipher=aes256 comment=kron-vpnpoint \
    connect-to=$OvpnIP name=ovpn-kron \
    user=$OvpnUser password=$OvpnPW

/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-Ce distance=indoors \
    frequency=auto mode=ap-bridge ssid=kronst wireless-protocol=802.11 disabled=yes

/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot

/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN




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

/system clock
set time-zone-name=Europe/Vienna

/system gps
set port=serial0

/ip service
set telnet disabled=yes
set api disabled=yes
set api-ssl disabled=yes

/system logging
add action=echo disabled=yes topics=ovpn

/tool netwatch
add comment="EVA700 Watchedog" host=192.168.0.175 interval=30m













