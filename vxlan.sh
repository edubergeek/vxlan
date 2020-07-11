#!/bin/bash

#Must run as root (sudo)
#Must have installed openvswitch
#Must have two network ports available, one that is routable to the other virtual tunnel end point (VTEP)

myVTEP=172.27.0.39 #(for reference, not used)
routeInt=enp1s0
tunnelInt=enp2s0
bridge=br1
VLAN=91
KEY=200
VTEP=172.27.0.35
VTEPBITS=24
IP=128.171.91.74
IPBITS=24

#Blow away anything there
ovs-vsctl del-br ${bridge}

#Create the bridge
ovs-vsctl add-br ${bridge}

#Add the physical interface to the bridge
ovs-vsctl add-port ${bridge} ${tunnelInt}

#add the fake bridge for VLAN
#ovs-vsctl add-br vlan${VLAN} ${bridge} ${VLAN}

#add the tunnel
ovs-vsctl add-port ${bridge} vxlan -- set interface vxlan type=vxlan options:key=${KEY} options:remote_ip=${VTEP}
#ovs-vsctl add-port vlan${VLAN} vxlan -- set interface vxlan type=vxlan options:key=${KEY} options:remote_ip=${VTEP}

#add VLAN IP
#ifconfig $routeInt mtu 1500 up
#ifconfig $tunnelInt mtu 1500 up
ifconfig ${bridge} ${IP}/${IPBITS} up
#ifconfig $tunnelInt up

# open the firewall to vxlan traffic
strict_rule="rule family=ipv4 source address=${VTEP}/${VTEPBITS} port protocol=udp port=4789 accept"
promiscuous_rule="rule fmaily=ipv4 source any port protocol=udp port=4789 accept"
firewall-cmd --permanent --zone=public --add-rich-rule="$strict_rule"
firewall-cmd --reload

ovs-vsctl show
ip addr show dev ${routeInt}
ip add show dev ${bridge}
ip link show dev ${tunnelInt}
