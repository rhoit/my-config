# My personal preference

alias run="chmod +x"

# My ways
alias startx='startx &> ~/.xlog'

# Stupid stuffs
alias rc.d='systemctl'

# ibus
export XMODIFIERS=@im=ibus

# python
alias py="python"
alias py2="python2"
alias py3="python3"

# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


# file browser (nemo) behaviour
function nemo {
    if [ $# -eq 0 ]; then
	setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
	setsid /usr/bin/nemo $1
    fi
}
