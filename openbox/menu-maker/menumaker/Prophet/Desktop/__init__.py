import sys, types, os, os.path, fnmatch, re, Prophet




from Keywords import Keyword as Kw, Set as KwS
from Paths import ValidPathSet as PS
from Prophet.Categories import *
from Prophet import msg, verbose




class DesktopSet(PS) :

	def adopt(self, path) :
		path = super(DesktopSet, self).adopt(path)
		for x in os.walk(path) :
			if len(fnmatch.filter(x[2], "*.desktop")) :
				return path
		raise ValueError




_genMap = (
	("gnome", GNOME),
	("kde", KDE),
	("devel*", Development),
	("edit*", TextEditor),
	("educ*", Education),
	("edut*", Education),

	("*game*", Game),
		("arcade", ArcadeGame),
		("board*", BoardGame),
		("card*", CardGame),
		("kids*", KidsGame),
		("rogue*", AdventureGame),
		("*tactic*", StrategyGame),
		("*strat*", StrategyGame),
	("*toy*", Amusement),
	("*amus*", Amusement),

	("*graphic*", Graphics),
	("*sound*", Audio),
	("*music*", Audio),
	("*video*", Video),
	("*internet*", Network),
	("*netw*", Network),
	("*news*", News),
	("*remote*", Network),
	("*www*", Network),
	("*transfer*", FileTransfer),
	("irc", IRCClient),
	("*instant*", InstantMessaging),
	("*messag*", InstantMessaging),
	("*mail*", Email),
	("multimedia", AudioVideo),
	("*docum*", Office), # ???
	("*office*", Office),
	("*graphs*", Chart),
	("pda", PDA),
	("*present*", Presentation),
	("*spread*", Spreadsheet),
	("*word*proc*", WordProcessor),
	("*time*manag*", ProjectManagement),
	("*sett*", Settings),
	("*syst*", System),
	("*admin*", System),
	("accessib*", Accessibility),
	("archiv*", Archiving),
	("comm*", Network),
	("*file*tool*", FileManager),
	("monitor*", Monitor),
	("*publish*", Office),
	("science", Science),
	("*math*", Math),
	("*text*tool*", TextEditor), # ???
	("*config*", Settings),
		("*boot*", System),
		("*init*", System),
	("*hardw*", HardwareSettings),
	("packag*", PackageManager),
	("print*", Settings),
	("*terminal*", TerminalEmulator),
)




_kdeCfgMap = (
	("look*feel", Kw("X-KDE-settings-looknfeel")),
	("*sound*", Kw("X-KDE-settings-sound")),
	("*syst*", Kw("X-KDE-settings-system")),
	("accessib*", Kw("X-KDE-settings-accessibility")),
	("component*", Kw("X-KDE-settings-components")),
	("netw*", Kw("X-KDE-settings-network")),
	("secur*", Kw("X-KDE-settings-security")),
	("*web*", Kw("X-KDE-settings-webbrowsing")),
	("*desk*", Kw("X-KDE-settings-desktop")),
	("periph*", Kw("X-KDE-settings-peripherials")),
	("Hardware", Kw("X-KDE-settings-hardware")),
	("power*", Kw("X-KDE-settings-power")),
	
	("*info*", Kw("X-KDE-information"))
)




# Some ugly Linux distros, notably Mandrake, are known for shipping broken (???!)
# .desktop's which have no Categories section (thx, $!N, mein Freund :) that is the main method for distributing
# the apps throughout the menu thus here's the alternative method for guessing the keywords




def _dir2kws(dir) :
	"""Convert the directory name to the corresponding keyword set, if possible"""
	parts = [x.strip().lower() for x in dir.split("/")]
	if len(fnmatch.filter(parts, "kde")) and len(fnmatch.filter(parts, "*config*") + fnmatch.filter(parts, "*sett*")) :
		# Catching KDE/Configuration or KDE/Settings
		kws = [KDE, Kw("X-KDE-settings")]
		kws += [k for m, k in _kdeCfgMap for x in parts if fnmatch.fnmatch(x, m)]
	else :
		kws = [k for m, k in _genMap for x in parts if fnmatch.fnmatch(x, m)]
	if len(kws) :
		return KwS(*kws)
	else :
		return None




_kws = None




def scan() :
	"""Scan through all containers and return a list of found valid entries"""
	global _kws
	result = []
	msg("  desktop...", newline = False)
	for c in dirs :
		for w in os.walk(c) :
			_kws = _dir2kws(w[0])
			if verbose > 1 : msg("\nentering " + w[0])
			for x in fnmatch.filter(w[2], "*.desktop") :
				if verbose > 1 : msg("parsing %s..." % x, newline = False)
				try :
					result.append(App(os.path.join(w[0], x)))
					if verbose > 1 : msg("ok")
				except (NotDesktop, Prophet.NotSet), e :
					if verbose > 1 : msg("REJECTED : " + str(e))
	msg(" %d apps found" % len(result))
	return result




dirs = DesktopSet([os.path.join(p, x) for p in Prophet.prefixes for x in ("share/applications", "share/applnk", "share/gnome/apps")]) \
	+ ("/usr/share/applications", "~/.kde/share/applnk", "~/.local/share/applications")




_section	= re.compile("\s*?\[\s*(.*)\s*\].*?") # Match section definition, e.g. [Global Settings]
_skip		= re.compile("\s*[\#\;].*") # Match comments - lines starting with # or ;
_entry		= re.compile("\s*?(.*)\s*?\=\s*?(.*)\s*?") # Match any valid entry, e.g. key = value
_pkey		= re.compile("(\w+)\s*\[\s*(\w+)\s*\]") # Match parametrized key, e.g. key[param]




_DE = Kw("Desktop Entry")




def _parse(desktop) :
	section = []
	inSection = False
	try :
		xs = open(desktop).readlines()
	except IOError :
		raise NotDesktop("i/o error while reading .desktop file")
	for x in xs :
		if re.match(_skip, x) :
			continue
		rx = re.match(_section, x)
		if rx :
			inSection = (Kw(rx.group(1)) == _DE)
			continue
		if inSection :
			rx = re.match(_entry, x)
			if rx :
				section.append( (rx.group(1), rx.group(2)) ) # (key, value)
	if len(section) :
		return _parseEntries(section)
	raise NotDesktop("[Desktop Entry] section is either absent or empty")





def _parseEntries(entries) :
	e = {}
	for key, val in entries :
		rx = re.match(_pkey, key)
		if rx :
			pass # TODO : _parseLocale
		else :
			e[key] = _parseValue(val)
	return e




def _parseValue(value) :
	vl = [x.strip() for x in value.split(";") if not (x.strip() == "")]
	if len(vl) > 1 :
		return tuple(vl)
	else :
		return value.strip()




class NotDesktop(Exception) :
	"""Exception is raised when parser fails to decode entry"""




def _string(x) :
	"""Pick up the most appropriate string representation out of all specified variants
		Choice is made with respect to current locale and type of specified argument"""
	if type(x) == types.DictType :
		return x[""]
	# FIXME : locale handling
	else :
		# Now argument is assumed to be a string
		return x




def _bool(x) :
	"""Convert string to boolean"""
	if x.lower() in ("yes", "true", "1") :
		return True
	else :
		return False




class App(Prophet.App) :

	pref = 20

	def __new__(cls, desktop) :
		self = object.__new__(cls)
		self.__setup__(desktop)
		return self

	def __setup__(self, desktop) :
		self.desktop = _parse(desktop)
		try :
			if not (self.desktop["Type"] == "Application") :
				raise NotDesktop("Entry type is not Application")
		except KeyError :
			raise NotDesktop("Entry type is not specified")
		try :
			if _bool(self.desktop["NoDisplay"]) :
				raise NotDesktop("NoDisplay is True")
		except KeyError :
			pass
		try :
			if _bool(self.desktop["Hidden"]) :
				raise NotDesktop("Hidden is True")
		except KeyError :
			pass
		super(App, self).__setup__()
		del self.desktop

	def setName(self) :
		for x in ("Name", "GenericName") :
			try :
				self.name = _string(self.desktop[x])
				return
			except KeyError :
				pass
		super(App, self).setName()

	def setComment(self) :
		try :
			self.comment = _string(self.desktop["Comment"])
		except KeyError :
			super(App, self).setComment()

	def setKeywords(self) :
		try :
			self.keywords = KwS(*self.desktop["Categories"])
		except KeyError :
			if _kws :
				self.keywords = _kws
			else :
				raise Prophet.NotSet("Categories not found")
		if fnmatch.fnmatch(self.exename, "*kcmshell") :
			self.keywords |= KwS(KDE, Kw("X-KDE-settings"))

	def setTerminal(self) :
		try :
			self.terminal = _bool(self.desktop["Terminal"])
		except KeyError :
			super(App, self).setTerminal()

	def setExename(self) :
		try :
			cmd = self.desktop["Exec"]
			# According to some reports, newer Debian-based distros
			# (notably, Ubuntu 5.10+) make an attempt to generate .desktop's
			# directly from their (Debian-style) database which means all those
			# ugly complex shell commands may emerge right here!
			# So we got to get rid of them for good.
			self.testGoodness(cmd)
			# Exec entry may contain the %-prefixed arguments that make no sense for us
			# and should be filtered out. If they're there, set exename to anything prior first
			# argument encountered
			scmd = cmd.split()
			if len(scmd) < 2 :
				self.exename = cmd
			else :
				self.exename = scmd[0].strip()
				self.exeargs = ""
				for i in range(1, len(scmd)) :
					if "%" in scmd[i] :
						break # First %arg encountered terminates the list
					try :
						if scmd[i].startswith("-") and "%" in scmd[i+1] :
							break # Filter out things like `-caption "%c"'
					except IndexError :
						pass
					self.exeargs += scmd[i] + " "
				self.exeargs = self.exeargs.rstrip()
				if not len(self.exeargs) :
					del self.exeargs
		except KeyError :
			try :
				# As a last resort, check for TryExec entry. It should not contain arguments so consume it all.
				self.exename = self.desktop["TryExec"]
			except KeyError :
				raise NotDesktop("Neither Exec nor TryExec specified")
				# If both entries are absent, this desktop file is totally useless for us

	def setNativenv(self) :
		super(App, self).setNativenv()
		# Not all Xfce apps have a distinguishing keywords therefore make an
		# additional check for the clues from its public name
		if fnmatch.fnmatch(self.name.lower(), "*xfce*") :
			self.nativenv = App.Xfce
		# A few GNOME apps do not manifest themselfs (according to their .desktop file)
		# as such
		elif fnmatch.fnmatch(os.path.basename(self.exename), "gnome*") :
			self.nativenv = App.GNOME
