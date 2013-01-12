import re, os.path, glob, fnmatch, Prophet




from Paths import ValidPathSet as PS
from Keywords import Keyword as Kw, Set as KwS
from Prophet import NotSet
from Prophet.Categories import *
from Prophet import msg, verbose




class DebianSet(PS) :

	def adopt(self, path) :
		path = super(DebianSet, self).adopt(path)
		if len(glob.glob(os.path.join(path, "*"))) :
			return path # Directory should not be empty
		raise ValueError




dirs = DebianSet(("/etc/menu", "/usr/lib/menu", "/usr/share/menu", "/usr/share/menu/default", "~/.menu"))




# If dirs isn't empty then assume we're running Debian and therefore it's reasonable
# to use local menu entries instead of cached ones
if not len(dirs) :
	dirs = DebianSet((os.path.join(__path__[0], "menu"),))
	runDebian = False
else :
	runDebian = True




def scan() :
	"""Scan through all containers and return a list of found valid entries"""
	result = []
	msg("  debian...", newline = False)
	for d in dirs :
		for f in glob.glob(os.path.join(d, "*")) :
			if verbose > 1 : msg("\nparsing " + f)
			try :
				entries = _parse(f)
			except NotSet, e :
				if verbose > 1 : msg("REJECTED : " + str(e))
			else :
				for e in entries :
					try :
						result.append(App(e))
					except Prophet.NotSet, e :
						if verbose > 1 : msg("REJECTED : " + str(e))
	msg(" %d apps found" % len(result))
	return result




def _parse(debmenu) :
	try :
		file = open(debmenu)
	except IOError :
		raise NotSet("couldn't read the file " + debmenu)
	entry = ""
	entries = []
	next = False
	try :
		for x in file :
			x = x.strip()
			if next :
				if not len(x) :
					next = False
					continue
				if not x.startswith("#") :
					if x.endswith("\\") :
						entry += " " + x.rstrip("\\")
						next = True
					else :
						entry += " " + x
						next = False
			else :
				if not len(x) :
					continue
				if not x.startswith("#") and x.startswith("?") :
					if len(entry) :
						entries += _parseEntry(entry)
					if x.endswith("\\") :
						entry = x.rstrip("\\")
						next = True
					else :
						entry = x
						next = False
	except IOError :
		raise NotSet("i/o error while reading the file " + debmenu)
	except StopIteration :
		pass
	if len(entry) :
		entries += _parseEntry(entry)
	return entries




_package	= re.compile('^\?\s*?package\s*?\((.*?)\)\s*?\:')
_key		= re.compile('(\w+)\s*=\s*(".*?"|\S+)')



def _parseEntry(s) :
	entry = {}
	x = _package.match(s)
	if x :
		entry["package"] = x.group(1)
		for x in re.findall(_key, s) :
			entry[ x[0] ] = x[1].strip('"')
	return [entry]




class App(Prophet.App) :

	pref = 10

	def __new__(cls, entry) :
		self = object.__new__(cls)
		self.__setup__(entry)
		return self

	def __setup__(self, entry) :
		self.entry = entry
		super(App, self).__setup__()
		del self.entry
		# TODO : filter out GNOME/KDE apps since they should be picked up by the .desktop scanner anyways
		# To accomplish this scan title/longtitle/description/whatever for the clues (gnome-*, "Calculator for GNOME", etc.)

	def setName(self) :
		try :
			self.name = self.entry["title"]
		except KeyError :
			super(App, self).setName()

	def setComment(self) :
		try :
			self.comment = self.entry["longtitle"]
		except KeyError :
			try :
				self.comment = self.entry["description"]
			except KeyError :
				super(App, self).setComment()

	def setKeywords(self) :
		try :
			sect = self.entry["section"]
		except KeyError :
			sect = ""
		try :
			hint = self.entry["hints"]
		except KeyError :
			hint = ""
		kws = _deb2kws(sect, hint)
		if not len(kws) :
			raise Prophet.NotSet("no keywords guessed")
		self.keywords = kws

	def setTerminal(self) :
		try :
			needs = Kw(self.entry["needs"])
			if   needs == Kw("X11") :
				self.terminal = False
			elif needs == Kw("text") :
				self.terminal = True
			else :
				raise Prophet.NotSet("unsupported needs entry (%s)" % needs)
		except KeyError :
			super(App, self).setTerminal()

	def setExename(self) :
		try :
			cmd = self.entry["command"]
		except KeyError :
			raise Prophet.NotSet("no command entry found")
		self.testGoodness(cmd)
		scmd = cmd.split(" ", 1)
		if len(scmd) >= 2 :
			cmd = scmd[0].strip()
			args = scmd[1].strip()
			for x in args.split() :
				if fnmatch.fnmatch(x, "*/*/*") and not os.path.exists(x) :
					# An argument specified in the command line looks like a path. If it
					# doesn't exist, the entire command is likely to be worthless, so throw it off
					raise Prophet.NotSet("nonexistent path %s as command argument")
			self.exeargs = args
		if not runDebian :
			# If we're not running Debian specified command may be located
			# elsewhere therefore we have to scan PATH for it
			cmd = os.path.basename(cmd)
			if cmd in ("sh", "bash", "csh", "tcsh", "zsh", "ls", "killall", "echo", "nice", "xmessage", "xlock") : # List of globs of unwanted commands
				# Debian seems to have lots of shell commands. While it would be nice
				# to try to analyze them, this isn't a priority since they're often
				# too Debian-specific.
				raise Prophet.NotSet("%s blacklisted" % cmd)
		self.exename = cmd




_secs = {
	Kw("Appearance") : (Settings, DesktopSettings),
	Kw("AI") : (Science,),
	Kw("Databases") : (Database, Office),
	Kw("Editors") : (TextEditor, Utility),
	Kw("Educational") : (Education,),
	Kw("Emulators") : (Emulator,),
	Kw("Games") : (Game,),
		Kw("Adventure") : (AdventureGame, Game),
		Kw("Arcade") : (ArcadeGame, Game),
		Kw("Board") : (BoardGame, Game),
		Kw("Card") : (CardGame, Game),
		Kw("Puzzles") : (LogicGame, Game),
		Kw("Simulation") : (Simulation, Game),
		Kw("Sports") : (SportsGame, Game),
		Kw("Strategy") : (StrategyGame, Game),
		Kw("Tetris-like") : (BlocksGame, Game),
	Kw("Graphics") : (Graphics,),
	Kw("Hamradio") : (HamRadio, Network),
	Kw("Math") : (Math, Science),
	Kw("Misc") : (Utility,), # ???
	Kw("Net") : (Network,),
	Kw("Analog") : (Engineering, Network),
	Kw("Headlines") : (News, Network),
	Kw("Programming") : (Development,),
	Kw("Shells") : (Shell, ConsoleOnly), # ???
	Kw("Sound") : (Audio, AudioVideo),
	Kw("System") : (System,),
		Kw("Admin") : (Settings, System),
#		Kw("GNOME") : (GNOME, GTK),
	Kw("Technical") : (Engineering,),
	Kw("Text") : (TextEditor, Utility),
	Kw("Tools") : (Utility,),
	Kw("Viewers") : (Viewer, Graphics),
		Kw("XawTV") : (TV, Viewer, Video, AudioVideo),
	Kw("Toys") : (Amusement,),
	Kw("Help") : (Utility, Kw("X-Help")),
	Kw("Screen") : (Utility,), # ???
#	Kw("Lock") : (Utility, Kw("X-Lock")),
	Kw("Saver") : (Screensaver, Utility),
	Kw("System") : (System,),
	Kw("XShells") : (Shell,)
}




_hints = {
	Kw("3D") : (ActionGame, Game), # ???
	Kw("Bitmap") : (RasterGraphics, x2DGraphics, Graphics),
	Kw("Boot") : (System, Utility),
	Kw("Bug reporting") : (Development,),
	Kw("Calculators") : (Calculator, Utility),
	Kw("Clocks") : (Clock, Utility),
	Kw("Config") : (Settings,),
	Kw("Debuggers") : (Debugger, Development),
	Kw("Documents") : (Office,),
	Kw("Doom") : (ActionGame, Game),
	Kw("Drawing") : (RasterGraphics, x2DGraphics, Graphics),
	Kw("Vector") : (VectorGraphics, Graphics),
	Kw("Equation") : (Math, Science),
	Kw("Editor") : (WordProcessor, Office),
	Kw("Formula") : (Presentation, Office),
	Kw("Fonts") : (DesktopSettings, Settings),
	Kw("Mail") : (Email, Office, Network),
	Kw("Calendar") : (Calendar, Office),
	Kw("Monitoring") : (Monitor, System),
	Kw("IRC") : (IRCClient, Network),
	Kw("ISDN") : (Telephony, Dialup, Network), # ???
	Kw("Images") : (x2DGraphics, Graphics),
	Kw("Internet") : (Network,),
	Kw("HTML") : (Network,),
	Kw("Mahjongg") : (LogicGame, Game),
	Kw("Mines") : (LogicGame, Game),
	Kw("Mixers") : (Mixer, Audio),
	Kw("Real-time") : (StrategyGame, Game),
	Kw("Parallel") : (Math, Science, Network),
	Kw("Distributed") : (Math, Science, Network),
	Kw("PostScript") : (Presentation, Office),
	Kw("Presentation") : (Presentation, Office),
	Kw("SameGame") : (LogicGame, Game),
	Kw("Screenshot") : (Graphics, Utility),
	Kw("Setup") : (System,),
	Kw("Install") : (System,),
	Kw("Config") : (Settings,),
	Kw("Spreadsheets") : (Spreadsheet, Office),
	Kw("Terminal") : (TerminalEmulator),
	Kw("Translation") : (Languages, Education),
	Kw("Dictionary") : (Languages, Education),
	Kw("Time") : (Clock, Utility),
	Kw("Users") : (System, Settings),
	Kw("VNC") : (Network,),
	Kw("Video") : (Video, AudioVideo),
	Kw("Web Browsers") : (WebBrowser, Network),
	Kw("Word Processors") : (WordProcessor, Office)
}




_rejs = (
	Kw("Modules"), Kw("WindowManagers"), Kw("WorkSpace"), Kw("Lock"), Kw("GNOME")
)




def _deb2kws(sec, hint) :
	"""Convert Debian style section/hints entries to an equivalent keyword set"""
	kws = []
	for x in sec.split("/") :
		x = Kw(x)
		if x in _rejs :
			raise Prophet.NotSet("section %s rejected" % x)
		try :
			kws += _secs[x]
		except KeyError :
			pass
	for x in hint.split(",") :
		x = Kw(x)
		try :
			kws += _hints[x]
		except KeyError :
			pass
	return KwS(*kws)
