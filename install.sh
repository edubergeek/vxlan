#!/bin/bash
#Must run as root (sudo)
#Prerequisite: A minimal install of CentOS 7
yum -y update
yum -y install @'Development Tools' net-tools wget yum-utils openssl-devel 

export ovsver=2.9.0-4
wget http://mirror.centos.org/centos/7/virt/x86_64/ovirt-4.2/openvswitch-${ovsver}.el7.x86_64.rpm
yum -y localinstall openvswitch-${ovsver}.el7.x86_64.rpm 

systemctl start openvswitch.service
systemctl enable openvswitch.service
