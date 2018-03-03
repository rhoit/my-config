#compdef

function tvnet() {
    echo "Anonymous login has been blocked"
    local CHANNEL=$(tr '[a-z]' '[A-Z]' <<< "${1:-KANTIPUR}")
    local URL="http://103.213.31.46/iptvlivestream/net${CHANNEL}1500.stream/playlist.m3u8"
    curl -i $URL --fail || return
    mplayer $URL
}

# 2500,1500,580,265
# http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8 #test
