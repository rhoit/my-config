import types, sys, os, os.path, stat, string, fnmatch, re




from Paths import ValidPathSet as VPS
from Keywords import Set as KwS, Keyword as Kw
from Categories import *




verbose			= 0
omitExecPath	= True  # Omit (whenever possible) the path to the executable if the latter is in the PATH
skipMissExec	= True  # Skip the entries whose executables are not found




class NotFound(Exception) :
	"""Raised when an appropriate file is not found"""




class NotSet(Exception) :
	"""Raised when getter fails to return any meaningful result"""




def msg(s, newline = True) :
	if verbose :
		sys.stderr.write(s)
		if newline :
			sys.stderr.write("\n")
	sys.stderr.flush()




def warn(s, newline = True) :
	sys.stderr.write(s)
	if newline :
		sys.stderr.write("\n")
	sys.stderr.flush()




def fatal(s, newline = True, code = 1) :
	sys.stderr.write(s)
	if newline :
		sys.stderr.write("\n")
	sys.stderr.flush()
	sys.exit(code)




def isExe(exe) :
	"""Check whether the specified name can be considered executable"""
	# Exec's have x-bit set for current uid, aren't directories, and don't have leading dot
	try :
		st = os.stat(exe)
		return (stat.S_IMODE(st[stat.ST_MODE]) & 0100) \
			and not stat.S_ISDIR(st[stat.ST_MODE]) \
			and not os.path.basename(exe).startswith(".")
	except OSError :
		return False




class PathSet(VPS) :

	def adopt(self, path) :
		path = super(PathSet, self).adopt(path)
		try :
			for exe in os.listdir(path) :
				if isExe(os.path.join(path, exe)) :
					return path
		except OSError :
			pass
		raise ValueError

	def which(self, exe) :
		if os.path.isabs(exe) :
			exe = os.path.basename(exe)
		for p in self :
			x = os.path.join(p, exe)
			if isExe(x) :
				return x
		raise NotFound




class PrefixSet(VPS) :

	def __init__(self, *args, **kwds) :
		self.binpaths = {}
		self.bins = ["bin", "sbin", "", "games"]
		super(PrefixSet, self).__init__(*args, **kwds)

	def adopt(self, path) :
		path = super(PrefixSet, self).adopt(path)
		for bin in self.bins :
			dir = os.path.join(path, bin)
			# A valid bindir contains at least one executable
			try :
				for x in os.listdir(dir) :
					if isExe(os.path.join(dir, x)) :
						self.binpaths[path] = PathSet([os.path.join(path, x) for x in self.bins])
						return path
			except OSError :
				pass
		raise ValueError




# Set of valid directories containing executables extracted from PATH
paths = PathSet(os.environ["PATH"].split(":"))




# Set of valid prefixes
prefixes = PrefixSet([os.path.dirname(x) for x in paths]) \
	+ ["~", "/", "/usr", "/usr/local", "/usr/X11", "/usr/X11R7", "/usr/X11R6", "/usrX11R5", "/opt", "$QTDIR", "$KDEDIR"]




# Match the most widespread shells
# TODO : detect absolute paths
_shStart = re.compile("^\s*(a|b|ba|c|k|pdk|tc|z)?sh\s+")




# Match complex shell command (i.e. with pipelines, and's or's etc.)
_shComplexCmd = re.compile("(;.*){2,}|\||&&|\(|\)|\{|\}")




class App(object) :
	"""Single application that has specific executable and thus can be put into a menu"""
	
	Console			= Kw("Console")
	XWindow			= Kw("XWindow")
	GNOME			= Kw("GNOME")
	KDE				= Kw("KDE")
	Xfce			= Kw("Xfce")
	GNUstep			= Kw("GNUstep")

	def getPrefixes(self) :
		return prefixes

	def getPaths(self) :
		return paths

	def setKeywords(self) :
		# Make sure the keywords field always exists
		try :
			self.keywords
		except AttributeError :
			self.keywords = KwS()

	def setName(self) :
		try :
			self.name
		except AttributeError :
			# Deduce name from the executable
			self.name = os.path.basename(self.exename).capitalize()

	def setExecmd(self) :
		# If an absolute path is given, check it
		# otherwise try to locate the executable via the PATH envar
		path = self.exename
		paths = self.getPaths()
		if os.path.isabs(path) :
			if skipMissExec and not isExe(path) :
				raise NotSet("%s is not executable" % path)
			if omitExecPath :
				try :
					# Check whether the specified filename is that one accessible via the PATH
					located = paths.which(path)
					try :
						if os.path.samefile(path, located) :
							path = os.path.basename(path)
					except OSError :
						pass
				except NotFound :
					pass
		else :
			# Here and forth we're given a relative path
			try :
				located = paths.which(path)
				# There is no reason to check for located<->path identity; we simply
				# make sure the executable can be accessed via PATH
				if not omitExecPath :
					# Sice we're initially given a relative path, make it full
					# by consuming the result of locateExec()
					path = located
			except NotFound :
				if skipMissExec :
					raise NotSet("executable %s not found in PATH" % path)
		# Execmd is fully formatted command line for the application
		try :
			self.execmd = path + " " + self.exeargs # exeargs may be missing, it's OK
		except AttributeError :
			self.execmd = path

	def setTerminal(self) :
		try :
			self.terminal
		except AttributeError :
			self.terminal = len(self.keywords & KwS(ConsoleOnly)) > 0

	def setNativenv(self) :
		try :
			self.nativenv
		except AttributeError :
			pass
			if self.terminal :
				self.nativenv = App.Console
			else :
				self.nativenv = App.XWindow
			for x in self.keywords :
				if   fnmatch.fnmatchcase(x, "*GNOME*") :
					self.nativenv = App.GNOME
					break
				elif fnmatch.fnmatchcase(x, "*KDE*") :
					self.nativenv = App.KDE
					break
				elif fnmatch.fnmatchcase(x, "*XFCE*") :
					self.nativenv = App.Xfce
					break
				# TODO : GNUstep???

		# Attributes to set, mandatory(+), optional(-) :
		# +exename		-- executable, with or w/o path
		# -exeargs		-- arguments that follow the exename
		# +execmd		-- a fully formatted command line for the app
		# +keywords		-- a set of keywords, must not be empty
		# +terminal		-- True if the app requires console support
		# +nativenv		-- the environment required by the app
		# -name			-- short description of the app
		# -comment		-- a more detailed description

		# NOTE : When determining whether the application should be run in terminal,
		# consult the self.terminal and _not_ the self.nativenv

	def testGoodness(self, cmd) :
		# Raise NotSet if cmd is not "good enough" and thus isn't worth further consideration
		# Current implementation filters out complex commands and commands
		# that are started with ?sh (a frequent Debian case)
		if _shStart.search(cmd) or _shComplexCmd.search(cmd) :
			raise NotSet("not good enough : " + cmd)

	def __setup__(self) :
		self.setExename()
		self.setKeywords()
		try :
			self.setExeargs()
		except AttributeError :
			pass
		self.setExecmd()
		self.setName()
		self.setTerminal()
		self.setNativenv()
		# Skip unwanted entries
		if skip[self.nativenv] :
			raise NotSet("unwanted %s environment" % self.nativenv)
		try :
			self.setComment()
		except AttributeError :
			pass




skip = {App.Console : False, App.XWindow : False, App.GNOME : False, App.KDE : False, App.Xfce : False}




def merge(entries) :
	"""Removes repeating entries from the list using fuzzy matching technique"""
	# NOTE : this is the deliberate violation of the immutability principle
	# __matched attribute is set for the entries that have been successfully matched before
	# Such entries should be skipped
	# It is thought that this approach is faster than keeping them in separate list
	msg("* merging...", newline = False)
	result = []
	esz = len(entries)
	for i in range(0, esz - 1) :
		e = entries[i]
		if hasattr(e, "__matched") :
			continue
		matching = [e] # List containing matching entries
		for j in range(i + 1, esz) :
			x = entries[j]
			if hasattr(x, "__matched") :
				continue
			# Matching e and x
			if os.path.basename(e.exename) == os.path.basename(x.exename) :
				# The main criteria is the considence of the executables
				try :
					eargs = e.exeargs
				except AttributeError :
					eargs = None
				try :
					xargs = x.exeargs
				except AttributeError :
					xargs = None
				if not eargs and not xargs :
					# Both entries don't have arguments, consider them matching
					matching.append(x)
				elif eargs and xargs :
					# Both entries do have arguments, match them
					if Kw(eargs) == Kw(xargs) :
						# Squeeze the spaces and don't consider the case of the characters
						matching.append(x)
		if len(matching) < 2 :
			# Only one candidate, no choice
			winner = e
		else :
			# Several candidates, must choose the most relevant
			winner = None
			for m in matching :
				if winner :
					if m.pref > winner.pref :
						winner = m
					elif m.pref == winner.pref :
						# For now the longer name is the better
						if len(m.name) > len(winner.name) :
							winner = m
				else :
					winner = m
		result.append(winner)
		# This is done in the last step to mark e which was put in matching
		for m in matching :
			m.__matched = True
	msg(" %d coincidings detected" % (len(entries) - len(result)))
	return result
