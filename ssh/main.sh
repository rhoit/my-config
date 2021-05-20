#!/bin/bash


test -e "/etc/ssh/banner" || {
    cp banner /etc/ssh/banner
}


while read line; do
    if [[ -z $line ]]; then continue; fi
    kv=($line)
    v=$(sed -n "s/^${kv[0]} \(.*\)/\1/Ip" /etc/ssh/sshd_config)
    echo "${kv[0]} : '$v' -> '${kv[1]}'"
    if [[ "$v" != "${kv[1]}" ]]; then
        sed -i "/^${kv[0]}/Id" /etc/ssh/sshd_config
        echo "$line" >> /etc/ssh/sshd_config
    fi
done <<< "
PermitRootLogin no
#PasswordAuthentication no
PubkeyAuthentication yes
Banner /etc/ssh/banner
"
# NOTE: to comment don't space after it
>/dev/null sshd -T && systemctl restart sshd


# to copy cow-notify
