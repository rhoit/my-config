# HISTORY FILE
HISTSIZE=2500
HISTFILESIZE=5000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

function myprompt {
#Case of chroot   
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
}

function defprompt {
    PS1="[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\033[00m\]]\$ "
}
defprompt

if [ -d ~/.bashrc.d ]; then
  for f in ~/.bashrc.d/*; do
     . "$f"
  done
  unset f
fi


# START XLE BLOCK
	# export XLEPATH="$HOME/xle" 
	# export PATH=${XLEPATH}/bin:$PATH 
	# export LD_LIBRARY_PATH=${XLEPATH}/lib:$LD_LIBRARY_PATH 
	# export DYLD_LIBRARY_PATH=${XLEPATH}/lib:$DYLD_LIBRARY_PATH 
	# export WEB_BROWSER=firefox 
# END XLE BLOCK
