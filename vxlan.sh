#!/bin/bash

#Must run as root (sudo)
#Must have installed openvswitch
#Must have two network ports available, one that is routable to the other virtual tunnel end point (VTEP)

#myVTEP=172.27.0.35 (for reference, not used)
tunnelPort=enp2s0
bridge=br1
VLAN=91
VTEP=172.27.0.51

#Blow away anything there
ovs-vsctl del-br ${bridge}

#Create the bridge
ovs-vsctl add-br ${bridge}

#Add the physical interface to the bridge
ovs-vsctl add-port ${bridge} ${tunnelPort}

#add the fake bridge for VLAN
ovs-vsctl add-br vlan${VLAN} ${bridge} ${VLAN}

#map tag to VID
ovs-vsctl add-port vlan${bridge} vxlan-$(VLAN) -- set interface vxlan-$(VLAN} type=vxlan options:key=${VLAN} options:remote_ip=${VTEP}

ovs-vsctl show
