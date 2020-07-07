#!/bin/bash
#Must run as root (sudo)
#Prerequisite: A minimal install of CentOS 7
yum -y update
yum -y install @'Development Tools' net-tools wget yum-utils openssl-devel 

useradd ovs
passwd ovs
su - ovs

# for CentOS 7.8 use openvswitch 2.5.9 (LTS)
# look here http://docs.openvswitch.org/en/latest/faq/releases/
# but also consider that CentOS (RHEL) kernels are modified from upstream
export ovsver=2.5.9

mkdir -p ~/rpmbuild/SOURCES
wget http://openvswitch.org/releases/openvswitch-${ovsver}.tar.gz
cp openvswitch-${ovsver}.tar.gz ~/rpmbuild/SOURCES 
tar xvzf ~/openvswitch-${ovsver}.tar.gz
sed 's/openvswitch-kmod, //g' openvswitch-${ovsver}/rhel/openvswitch.spec > openvswitch-${ovsver}/rhel/openvswitch_no_kmod.spec
rpmbuild -bb --nocheck openvswitch-${ovsver}/rhel/openvswitch_no_kmod.spec
exit

yum -y localinstall /home/ovs/rpmbuild/RPMS/x86_64/openvswitch-${ovsver}-1.el7.x86_64.rpm

systemctl start openvswitch.service
systemctl enable openvswitch.service
