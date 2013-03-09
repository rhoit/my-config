#my-config

Some Handy and Fun configuration of mine, kinda backup!

## bashrc.d

I really don't like working on my .bashrc too much so i break it playing
so

I just add this line to your .bashrc and be happy

	if [ -d /your/bashrc.d/location ]; then
		for f in /your/bashrc.d/location/*; do
			. "$f"
		done
		unset f
	fi

### cowfortune
	 _____________________________________
	/ its something like this in your     \
	\ terminal.                           /
	 -------------------------------------
	  \
	   \   \_\_    _/_/
	    \      \__/
	           (oo)\_______
	           (__)\       )\/\
	               ||----w |
	               ||     ||

### gitprompt

	$ [bash-forever (master)‚☹]
