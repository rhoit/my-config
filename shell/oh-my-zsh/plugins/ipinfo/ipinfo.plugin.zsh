#compdef ifconfig-public

function ipinfo {
    # curl ipecho.net/plain
    >&2 echo "curl ipinfo.io/${1:-<keyvalue>}"
    curl ipinfo.io/$1
}
