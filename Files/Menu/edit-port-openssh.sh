#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman

#Check Curl
if [ ! -e /usr/bin/curl ]; then
	if [[ "$OS" = 'debian' ]]; then
	apt-get -y update && apt-get -y install curl
	else
	yum -y update && yum -y install curl
	fi
fi

# check registered ip
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Connecting to Server..."
sleep 0.4
echo "Checking Permision..."
sleep 0.3
CEK=PR Aiman
if [ "$CEK" != "PR Aiman" ]; then
		echo -e "${red}Permission Denied!${NC}";
        echo $CEK;
        exit 0;
else
echo -e "${green}Permission Accepted...${NC}"
sleep 0.6
clear
fi

#Check ROOT
if [[ $USER != "root" ]]; then
	echo "Oops! root privileges needed."
	exit
fi

#Check OS
if [[ -e /etc/debian_version ]]; then
	OS=debian
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
else
	echo "This script only works on Debian and CentOS system"
	exit
fi

#Remove Temporary Files
rm -f /tmp/opensshport


if [[ "$OS" = 'debian' ]]; then
	cd
	read -p "Input OpenSSH Ports separated by 'spaces': " port
	opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

	#Display & Delete Old OpenSSH Port
	echo ""
	echo -e "\e[34;1mPort OpenSSH before editing:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END

	exec</root/opensshport
	while read line
	do
		echo "Port $line"
		sed "/Port $line/d" -i /etc/ssh/sshd_config
	done
	rm -f /root/opensshport

	echo ""

	#Add New Port
	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "4 a\Port $i" /etc/ssh/sshd_config
				echo -e "\e[032;1mPort $i added successfully\e[0m"
			fi
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for OpenVPN\e[0m"
			fi
		else
			sed -i "4 a\Port $i" /etc/ssh/sshd_config
			echo -e "\e[032;1mPort $i added successfully\e[0m"
		fi
	done

	echo ""
	service ssh restart > /dev/null
	sleep 0.5
	#Display New Port
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenSSH after editing:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END
	exec</root/opensshport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/opensshport
else 
#######################################################################################################################################
#Jika Centos
	cd
	read -p "Input OpenSSH Ports separated by 'spaces': " port
	opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

	#Display & Delete Old OpenSSH Port
	echo ""
	echo -e "\e[34;1mPort OpenSSH before editing:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END

	exec</root/opensshport
	while read line
	do
		echo "Port $line"
		sed "/Port $line/d" -i /etc/ssh/sshd_config
	done
	rm -f /root/opensshport

	echo ""

	#Add New Port
	for i in ${port[@]}
	do
		netstat -nlpt | grep -w "$i" > /dev/null
		if [ $? -eq 0 ]; then
			netstat -nlpt | grep -i ssh | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				sed -i "12 a\Port $i" /etc/ssh/sshd_config
				echo -e "\e[032;1mPort $i added successfully\e[0m"
			fi
			netstat -nlpt | grep -i dropbear | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for Dropbear\e[0m"
			fi
			
			netstat -nlpt | grep -i squid | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for Squid\e[0m"
			fi
			
			netstat -nlpt | grep -i openvpn | grep -w "$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo -e "\e[031;1mPort $i failed to add. Port $i already used for OpenVPN\e[0m"
			fi
		else
			sed -i "12 a\Port $i" /etc/ssh/sshd_config
			echo -e "\e[032;1mPort $i added successfully\e[0m"
		fi
	done

	echo ""
	service sshd restart > /dev/null
	sleep 0.5
	#Display New Port
	rm -f /root/opensshport
	opensshport="$(netstat -nlpt | grep -i sshd | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
	echo ""
	echo -e "\e[34;1mPort OpenSSH after editing:\e[0m"
	cat > /root/opensshport <<-END
	$opensshport
	END
	exec</root/opensshport
	while read line
	do
		echo "Port $line"
	done
	rm -f /root/opensshport
fi
cd