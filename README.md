#goto.sh - Go To Domain
Do you run services with a lot of virtual domains? [eg. shared hosting]

goto.sh should make it easier to find the directory of the domain you're looking for.

##Usage
Unless you only ever want to use it to print the domain [`-e` option] you'll need to set it up as alias, because `goto.sh` must be sourced into your current shell to `cd` properly.

eg: `alias goto='. /path/to/goto.sh'`

	 Syntax: goto [-[w|m]ieph] match
	
	 Flags:
	  -w Goto web dir [default, overrides -m in case of -wm]
	  -m Goto mail dir
	  -i Run interactively
	     Will show a list if more than one domain matches.
	  -e Just echo result, don't cd to dir.
	  -p Use pushd instead of cd
	  -h Show this help
	  
Example in interactive mode:

	# goto -ie home
	  1: myhome.com
	  2: yourhome.com
	  3: homeslice.com
	  4: sliceofhome.com
	  5: homehomehomehome.com
	
	Your selection: 3
	/var/www/vhosts/homeslice.com
	  
##Notes
* When running in non-interactive mode `goto.sh` will simply select the first domain that matches, as sorted lexically.
* When running in interactive mode the selection list is printed to stderr so as not to interfere with output capture while using the -e flag.
* As-is it's set to work with the [god-awful] configuration of our Plesk servers that run both mail and web service on the same machine, so -w and -m will switch between the using `$webhome` and `$mailhome` defined in the script. If necessary it should be a simple matter to modify and extend this aspect of the script as `getopts` is used to process the flag arguments, and a simple `if/else` handles the directory portion.
