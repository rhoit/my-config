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

# gdb
alias gdb="gdb -q"


# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"

# emacs behaviour
function emacs {
    if [[ $# -eq 0 ]]; then
	/usr/bin/emacs # "emacs" is function, will cause recursion
    else
        # if [[ ${1}[] == "-" ]]; then "string match '-'"
	#     setsid emacsclient -a /usr/bin/emacs @1
	# fi
	emacsclient -n -a /usr/bin/emacs $@
    fi
}

# file browser (nemo) behaviour
function nemo {
    if [[ $# -eq 0 ]]; then
	setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
	setsid /usr/bin/nemo $@
    fi
}
