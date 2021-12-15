#!/bin/bash


DETECTOS(){
        dist=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`

        if [ "$dist" = "Ubuntu" ]; then
                os="ubuntu"
                echo "OS IS $os"
        else
                dist=`cat /etc/*-release | head -1 | awk '{print $1}'`
                if [ "$dist" = "CentOS" ]; then
                        os="centos"
                        echo "OS IS $os"
                fi
        fi
}
DETECTOS

CDPINSTALL(){

	if [ "$os" = centos ]; then
		yum -y update

		#cdp-agent installation in centos7

		uname -r
		touch /etc/yum.repos.d/r1soft.repo
		echo "[r1soft]" >> /etc/yum.repos.d/r1soft.repo
		echo "name=R1Soft Repository Server" >> /etc/yum.repos.d/r1soft.repo
		echo "baseurl=http://repo.r1soft.com/yum/stable/\$basearch/" >> /etc/yum.repos.d/r1soft.repo
		echo "enabled=1" >> /etc/yum.repos.d/r1soft.repo
		echo "gpgcheck=0" >> /etc/yum.repos.d/r1soft.repo
	
		cat /etc/yum.repos.d/r1soft.repo
		yum -y install serverbackup-enterprise-agent
		serverbackup-setup --test-connection
		yum -y install kernel-devel
		yum info kernel-devel
		yum -y install "kernel-devel-uname-r == $(uname -r)"
		serverbackup-setup --get-module
		r1soft-setup --get-key https://s11.storage.magehost.cloud/
		serverbackup-setup --list-keys
		/etc/init.d/cdp-agent restart
		systemctl enable cdp-agent
	
		echo "cdp-agent is installed successfully"
		echo "verify installation by running :"
	
		echo "-------------------------"
		echo "service cdp-agent status "
		echo "-------------------------"
	else
		if [ "$os" = ubuntu ]; then
			echo deb http://repo.r1soft.com/apt stable main >> /etc/apt/sources.list
			wget http://repo.r1soft.com/r1soft.asc
			apt-key add r1soft.asc
			apt-get update -y
			apt-get install r1soft-cdp-enterprise-agent -y
			r1soft-setup --test-connection
			r1soft-setup --get-key https://s11.storage.magehost.cloud/
			serverbackup-setup --list-keys
			service cdp-agent start
			systemctl enable cdp-agent
			echo "cdp-agent is installed successfully"
			echo "verify installation by running :"
			echo "-------------------------"
			echo "service cdp-agent status "
			echo "-------------------------"
		fi
	fi
}
CDPINSTALL
