import sys, os.path, MenuMaker, Prophet




from Keywords import Keyword as Kw, Set as KwS




import optparse
from optparse import OptionParser as _OP




from MenuMaker import msg, warn, fatal, fronts, terms




writeToStdout	= False # Output the generated menu to stdout instead of the menu file
forceWrite		= False # Overwrite existing files
noDesktop		= False # Do not scan for .desktop files
noLegacy		= False # Do not scan for the legacy apps
noDebian		= False # Exclude Debian apps database




vStr = "be verbose"
def vOpt(option, opt, value, parser) :
	v = MenuMaker.verbose
	if v < 3 :
		v += 1; MenuMaker.verbose = Prophet.verbose = v




fStr = "overwrite existing files"
def fOpt(option, opt, value, parser) :
	global forceWrite
	forceWrite = True




cStr = "dump the menu to stdout instead of file"
def cOpt(option, opt, value, parser) :
	global writeToStdout
	writeToStdout = True




iStr = "produce the output suitable for inclusion into the custom menu; MUST be used in conjunction with -c"
def iOpt(option, opt, value, parser) :
	MenuMaker.writeFullMenu = False




pStr = "always retain the path to executable (by default, the path is omitted whenever possible)"
def pOpt(option, opt, value, parser) :
	Prophet.omitExecPath = False




xdStr = "skip .desktop database scanning"
def xdOpt(option, opt, value, parser) :
	global noDesktop
	noDesktop = True




xlStr = "skip legacy knowledge base scanning"
def xlOpt(option, opt, value, parser) :
	global noLegacy
	noLegacy = True




xeStr = "skip Debian database scanning"
def xeOpt(option, opt, value, parser) :
	global noDebian
	noDebian = True




sKwS = KwS(*Prophet.skip.keys())
sStr = "skip specific categories (comma-separated list)"
def sOpt(option, opt, value, parser) :
	for x in value.split(",") :
		if not len(x) :
			continue
		x = Kw(x)
		try :
			Prophet.skip[x]
		except KeyError :
			raise optparse.OptionValueError("wrong argument %s for option %s" % (x, opt))
		Prophet.skip[x] = True




tStr = "terminal emulator to use for console applications"
def tOpt(option, opt, value, parser) :
	global term
	for t, n in terms :
		if value in n :
			term = t
			return
	raise optparse.OptionValueError("wrong argument %s for option %s" % (value, opt))




class OP(_OP) :
	def print_help(self) :
		sys.stdout.write("This is %s %s, a 100%% Python heuristics-driven menu generator\n" % (MenuMaker.pkgName, MenuMaker.pkgVer))
		sys.stdout.write("%s %s %s <%s>\n\n" % (MenuMaker.pkgHome, MenuMaker.copyright, MenuMaker.author, MenuMaker.email))
		_OP.print_help(self)
		sys.stdout.write("\nfrontends (case insensitive):\n")
		for v in fronts.values() :
			vars = list(v)
			s = str(vars[0])
			for x in vars[1:] :
				s += " | " + str(x)
			sys.stdout.write("  %s\n" % s)
		sys.stdout.write("\nterminal emulators for -t (case insensitive), in order of decreasing preference:\n")
		for t, n in terms :
			vars = list(n)
			s = str(vars[0])
			for x in vars[1:] :
				s += " | " + str(x)
			sys.stdout.write("  %s\n" % s)
		sys.stdout.write("\nskip categories for -s (case insensitive):\n")
		for k in sKwS :
			sys.stdout.write("  %s\n" % k)




op = OP(usage = "%prog [options] frontend", version = "%s %s" % (MenuMaker.pkgName, MenuMaker.pkgVer))
op.add_option("-v", "--verbose", action = "callback", callback = vOpt, help = vStr)
op.add_option("-f", "--force", action = "callback", callback = fOpt, help = fStr)
op.add_option("-c", "--stdout", action = "callback", callback = cOpt, help = cStr)
op.add_option("-i", action = "callback", callback = iOpt, help = iStr)
op.add_option("-t", metavar = "terminal", nargs = 1, type = "string", action = "callback", callback = tOpt, help = tStr)
op.add_option("-p", "--retain-path", action = "callback", callback = pOpt, help = pStr)
op.add_option("--no-desktop", action = "callback", callback = xdOpt, help = xdStr)
op.add_option("--no-legacy", action = "callback", callback = xlOpt, help = xlStr)
op.add_option("--no-debian", action = "callback", callback = xeOpt, help = xeStr)
op.add_option("-s", "--skip", metavar = "list", nargs = 1, type = "string", action = "callback", callback = sOpt, help = sStr)




opts, args = op.parse_args()




if not len(args) :
	fatal("no frontend specified")




found = False
for k, v in fronts.items() :
	if args[0] in v :
		found = True
		name = "MenuMaker.%s" % k
		frontName = k
		__import__(name)
		front = sys.modules[name]
		MenuMaker.setFrontend(front)
		break
if not found :
	fatal("unknown frontend: %s" % args[0])




if len(args) > 1 :
	warn("multiple frontends specified; the first one (%s) will be used" % frontName)




try :
	menuFile = front.menuFile
except AttributeError :
	if not writeToStdout :
		fatal("%s doesn't support writing to a file; use -c option instead" % frontName)




if not MenuMaker.writeFullMenu and not writeToStdout :
	fatal("-i MUST be used in conjunction with -c; this is done to prevent accidental overwriting of the custom menu")




import Prophet.Desktop
import Prophet.Legacy # Postpone the setup to the time when it's actually needed
import Prophet.Debian




msg("* scanning")




if noDesktop :
	msg("  skipping desktop")
	desktop = []
else :
	desktop = Prophet.Desktop.scan()




if noLegacy :
	msg("  skipping legacy")
	legacy = []
else :
	Prophet.Legacy.setup()
	legacy  = Prophet.Legacy.scan()




if noDebian :
	msg("  skipping Debian")
	debian = []
else :
	debian = Prophet.Debian.scan()




merged = Prophet.merge(legacy + desktop + debian)




msg("* generating")




if not Prophet.skip[Prophet.App.Console] :
	try :
		MenuMaker.terminal = term()
	except Prophet.NotSet :
		fatal("specified terminal emulator couldn't be found; try another one")
	except NameError :
		warn("  no terminal emulator specified; will use the default")
		found = False
		for tcls, tname in terms :
			try :
				MenuMaker.terminal = tcls()
				found = True
				break
			except Prophet.NotSet :
				pass
		if not found :
			fatal("no suitable terminal emulator found")
	msg("  using %s as terminal emulator" % MenuMaker.terminal.name)




menu = MenuMaker.Root()




if writeToStdout :
	msg("* writing")
	file = sys.stdout
else :
	msg("* writing to %s" % menuFile)
	file = os.path.expanduser(menuFile)
	dir = os.path.dirname(file)
	if not os.path.isdir(dir) :
		msg("  creating missing directory %s" % dir)
		os.makedirs(dir)
	if not forceWrite and os.path.isfile(file) :
		fatal("refuse to overwrite existing file %s; either delete it or use -f option" % file)
	file = open(file, "wt")




menu.distribute(merged)




menu.arrange()




for x in menu.emit(0) :
	file.write(x)
	file.write("\n")




msg("* done")
