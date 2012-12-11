import sys, os, glob, re




from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *
from Prophet import msg




import Prophet




class App(Prophet.App) :
	"""A simple application that may have different executables"""

	pref = 30

	def __new__(cls) :
		try :
			self = cls.__inst__
			if not self :
				raise Prophet.NotSet
		except AttributeError :
			self = cls.__inst__ = object.__new__(cls)
			try :
				self.__setup__()
			except Prophet.NotSet :
				cls.__inst__ = None
				raise
		return self

	def setKeywords(self) :
		super(App, self).setKeywords()
		self.keywords |= KwS(Legacy)

	def setExename(self) :
		# Obtain known executable names for the application
		try :
			exes = self.exes
		except AttributeError :
			# If none were explicitly specified, use self class name
			exes = [self.__class__.__name__]
		prefixes = self.getPrefixes()
		paths = self.getPaths()
		valids = []
		for x in exes :
			for pfx, bps in prefixes.binpaths.items() :
				try :
					exe = bps.which(x)
					if self.valid(pfx, exe) :
						valids.append((pfx, exe))
				except Prophet.NotFound :
					pass
		try :
			self.prefix, self.exename = self.select(valids)
		except Prophet.NotFound :
			raise Prophet.NotSet

	def valid(self, pfx, exe) :
		return True

	def select(self, valids) :
		if len(valids) :
			return valids[0]
		else :
			raise Prophet.NotFound




class ConsoleApp(Prophet.App) :
	"""Mixin class for the console application that must be run in terminal"""

	def setKeywords(self) :
		super(ConsoleApp, self).setKeywords()
		self.keywords |= KwS(ConsoleOnly)




class X11App(Prophet.App) :
	"""Mixin class for the X11 GUI application"""




class ZeroG(App) :
	"""Application installed by the ZeroG LaunchAnywhere system.
		This is usually a commercial Java application"""

	registry = "~/.com.zerog.registry.xml"

	def getPrefixes(self) :
		prefixes = super(ZeroG, self).getPrefixes()
		try :
			zerog = file(os.path.expanduser(self.registry), "r")
			pattern = re.compile(".*<product.*name=\"(%s)\".*location=\"(.*)\".*last_modified=\"(.*)\".*>.*" % self.magic)
			found = []
			for x in zerog :
				rx = pattern.match(x)
				if rx :
					found.append( (rx.group(3), rx.group(1), rx.group(2)) )
			zerog.close()
			found.sort()
			found.reverse()
			prefixes = Prophet.PrefixSet([x[2] for x in found]) + prefixes
		except IOError :
			pass
		return prefixes




class DropIn(App) :

	maxDepth = 3

	dropRoots = ["~"]

	class StopDescention(Exception) : pass

	def getPrefixes(self) :
		prefixes = super(DropIn, self).getPrefixes()
		try :
			for r in self.dropRoots :
				self.descend(os.path.expanduser(r), 1)
		except DropIn.StopDescention, path :
			prefixes += path
		return prefixes

	def descend(self, path, depth) :
		self.relevant(path)
		if depth > self.maxDepth :
			return
		try :
			for x in os.listdir(path) :
				dir = os.path.join(path, x)
				if not x.startswith(".") and os.path.isdir(dir) :
					self.descend(dir, depth + 1)
		except OSError :
			pass




__legacy__ = ["Development", "Editor", "Emulator", "Multimedia", "Network", "Shell"]




entries = [] # List of all legacy entries found




def _register(module, this = True) :
	"""Import and store the specified module along with all its submodules"""

	try :
		names = module.__legacy__
	except AttributeError :
		names = []

	if this :
		for k, v in module.__dict__.items() :
			if not k.startswith("_") and type(v) == type and issubclass(v, Prophet.App) :
				entries.append(v)

	for x in names :
		name = module.__name__ + "." + x
		try :
			__import__(name)
		except ImportError :
			raise ImportError("No module named " + name)
		imp = sys.modules[name]
		_register(imp)
		




def setup() :
	_register(sys.modules[__name__], this = False)




def scan() :
	result = []
	msg("  legacy...", newline = False)
	for x in entries :
		try :
			result.append( x() )
		except Prophet.NotSet :
			pass
	msg(" %d apps found" % len(result))
	return result
