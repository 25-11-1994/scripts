#!/bin/bash


#******Script to install and configure csf in a ubuntu server********#

#Update repo and install dependencies
apt-get update -y
apt-get install sendmail sendmail-bin dnsutils unzip git perl iptables libio-socket-ssl-perl libcrypt-ssleay-perl libnet-libidn-perl libio-socket-inet6-perl libsocket6-perl libwww-perl liblwp-protocol-https-perl -y

wget http://download.configserver.com/csf.tgz
tar -xvzf csf.tgz
cd csf/ && bash install.sh

#Make csf ready for prod use
sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf

#Open the necessary ports for IPV4
sed -i 's/TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995"/TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995,2283,1167,10000,10050,10051,20000"/g' /etc/csf/csf.conf

#Allow IPV6 networking
sed -i 's/IPV6 = "0"/IPV6 = "1"/g' /etc/csf/csf.conf

#Open the necessary port for IPV6
sed -i 's/TCP6_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995"/TCP6_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995,2283"/g' /etc/csf/csf.conf

#Amend paths as per the installation
sed -i 's|IPTABLES = "/sbin/iptables"|IPTABLES = "/usr/sbin/iptables"|' /etc/csf/csf.conf
sed -i 's|IPTABLES_SAVE = "/sbin/iptables-save"|IPTABLES_SAVE = "/usr/sbin/iptables-save"|' /etc/csf/csf.conf
sed -i 's|IPTABLES_RESTORE = "/sbin/iptables-restore"|IPTABLES_RESTORE = "/usr/sbin/iptables-restore"|' /etc/csf/csf.conf
sed -i 's|IP6TABLES = "/sbin/ip6tables"|IP6TABLES = "/usr/sbin/ip6tables"|' /etc/csf/csf.conf
sed -i 's|IP6TABLES_SAVE = "/sbin/ip6tables-save"|IP6TABLES_SAVE = "/usr/sbin/ip6tables-save"|' /etc/csf/csf.conf
sed -i 's|IP6TABLES_RESTORE = "/sbin/ip6tables-restore"|IP6TABLES_RESTORE = "/usr/sbin/ip6tables-restore"|' /etc/csf/csf.conf

#Reload csf rules to make changes in effect
csf -ra
systemctl start lfd && systemctl start csf


