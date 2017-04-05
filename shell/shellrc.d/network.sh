#!/bin/bash

alias dcpp-admin='telnet localhost 53696'
alias nc-share-key='nc -l -p 1234 < ~/.ssh/id_rsa.pub'
alias netstat-open-ports='netstat --all --numeric --programs --inet --inet6'

alias nmap-find-rpi='sudo nmap -sP 192.168.1.0/24 | awk "/^Nmap/{ip=\$NF}/B8:27:EB/{print ip}"'
alias nmap-find-bbb='sudo nmap -sP 192.168.1.0/24 | awk "/^Nmap/{ip=\$NF}/D0:39:72/{print ip}"'

function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	address=($@)

    if (( $# == 0 )); then
		echo -n "username: "; read username
		if [[ $username != "" ]]; then
			echo -n "password: "
			read -es password
			local auth="$username:$password@"
		fi

		echo -n "server: "; read server
		echo -n "port: "; read port
		local address="$server:$port"
	fi

    valid=$(echo $address | sed -n 's/^\([0-9]\{1,3\}.\)\{4\}:\([0-9]\+ *\)\?$/&/p')
    if [[ $valid != $address ]]; then
        >&2 echo 'Invalid address!'
		>&2 echo 'For authentification use without agruments.'
		echo $address
		echo $auth
        return 1
    fi

    export http_proxy="http://$auth$address/"
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export rsync_proxy=$http_proxy
    echo "Proxy environment variable set."
}

function proxy_off(){
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
    echo -e "Proxy environment variable removed."
}

# proxy using socat
# exec socat STDIO PROXY:$_proxy:$1:$2,proxyport=$_proxyport
