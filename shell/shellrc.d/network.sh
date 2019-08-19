#!/bin/bash

#
# iproute2
# https://imdjh.github.io/toolchain/2015/10/07/drill-if-you-can-dig-if-you-have-to.html
alias dig="echo 'drill if you can, dig if you have to, nslookup if you must'"
alias netstat="echo 'netstat was pass now its *ss* hail! hitler'"

alias dcpp-admin='telnet localhost 53696'
alias nc-share-key='nc -l -p 1234 < ~/.ssh/id_rsa.pub'
alias netstat-open-ports='netstat --all --numeric --programs --inet --inet6'

alias nmap-find-rpi='local h=$(hostname -i); sudo nmap -sP $h/24 | awk "/^Nmap/{ip=\$NF}/B8:27:EB/{print ip}"'
alias nmap-find-bbb='local h=$(hostname -i); sudo nmap -sP $h/24 | awk "/^Nmap/{ip=\$NF}/D0:39:72/{print ip}"'
alias nmap-find-stv='local h=$(hostname -i); sudo nmap -sP $h/24 | awk "/^Nmap/{ip=\$NF}/50:56:BF/{print ip}"'


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

function ssh-sftp-wrapper {
    ##
    ### ssh wrapper for smart behaviour
    command=$1
    shift
    if [[ $# -eq 0 ]]; then
        /usr/bin/$command # will cause recursion if not
        return
    fi

    /usr/bin/$command $*

    exitcode=$?
    if [[ $exitcode -eq 0 ]]; then
        return 0
    fi

    ## catch error
    /usr/bin/$command $* 2> /tmp/ssh_key_error >/dev/null

    local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
    if [[ $v == "" ]]; then
        return $exitcode
    fi

    echo -n "\nDo you wanna fix and continue? "
    read reply
    if [[ ${reply[0]} == "y" || ${reply[0]} == "Y" || $reply == "" ]]; then
        local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
        sed -i "${v}d" $HOME/.ssh/known_hosts
        /usr/bin/$command $*
        return $?
    fi
}


function ssh {
    if [[ -z $SSH_AUTH_SOCK ]]; then
        echo "ssh-agent daemon not active"
        # gnome-keyring-daemon
        # eval $(ssh-agent -s)
        # ssh-add
    fi
    ssh-add -l | cut -d' ' -f2,3
    ssh-sftp-wrapper ssh $@
}

alias sftp="ssh-sftp-wrapper sftp "

function winRCP {
    # Connect to windows for fun
    WINDOWS_PASSWORD=$1
    ssh -N -f -L 3389:localhost:3389 telescope.fqdn
    rdesktop -K -u nibz -p $WINDOWS_PASSWORD -g 95% localhost
}
