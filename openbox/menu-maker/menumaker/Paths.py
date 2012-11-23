import os, os.path, stat




class PathSet(object) :
	"""Represents an ordered set of unique normalized file paths.
		The paths may be the subject to user (~) and variable ($) expansion.
		This class fulfills the sequence contract (i.e. len(), x[], iterating etc.).
	"""

	def __init__ (self, *args, **kwds) :
		"""Construct a set. Any number of either string-like objects or the sequences of
			thereof is accepted.

			The following keywords are recognized:
				userExpand	-- (default True)
				varExpand	-- (default True)
		"""
		self.paths = []
		try :
			self.varExpand = kwds["varExpand"]
		except KeyError :
			self.varExpand = True
		try :
			self.userExpand = kwds["userExpand"]
		except KeyError :
			self.userExpand = True
		for x in args :
			self.append(x)

	def __iter__(self) :
		return self.paths.__iter__()

	def __len__(self) :
		return len(self.paths)

	def __str__(self) :
		paths = self.paths
		if len(paths) > 1 :
			s = str(paths[0])
			for x in paths[1:] :
				s += ":" + str(x)
		elif len(paths) > 0 :
			s = str(paths[0])
		else :
			s = ""
		return s

	def __contains__ (self, path) :
		return self.adopt(path) in self.paths

	def __getitem__(self, index) :
		return self.paths[index]

	def __add__(self, other) :
		x = self.__class__()
		x.append(self)
		x.append(other)
		return x

	def __iadd__(self, other) :
		self.append(other)
		return self

	def adopt(self, path) :
		"""Validates the specified path and converts it to a form suitable for inclusion
			into the set. Must either return the path or raise ValueError if an inappropriate
			path was given.
		"""
		if self.userExpand and path.startswith("~") :
			path = os.path.expanduser(path)
		if self.varExpand and "$" in path :
			path = os.path.expandvars(path)
		path = os.path.normpath(path)
		if path in self.paths :
			raise ValueError
		else :
			return path

	def append(self, arg) :
		if isinstance(arg, str) :
			try :
				self.paths.append(self.adopt(arg))
			except ValueError :
				pass
		else :
			for x in arg :
				self.append(str(x)) # WARNING : a recursive call, stay alert




class ValidPathSet(PathSet) :
	"""Represents the PathSet of the valid paths. The symbolic links are respected
		and have the preference over the real directories they point to.
	"""

	def adopt(self, path) :
		path = super(ValidPathSet, self).adopt(path)
		try :
			st = os.stat(path)
			for xst in self.stats :
				if os.path.samestat(st, xst) :
					if os.path.islink(path) and not os.path.islink(self.stats[xst]) : # FIXME : inefficiency
						# In case of real path followed by the symlink to it
						# the latter has the preference
						self.paths[self.paths.index(self.stats[xst])] = path
						del self.stats[xst]; self.stats[st] = path
					# In all other cases the path is discarded
					raise ValueError # To prevent the appending of the path
			self.stats[st] = path
			return path
		except OSError :
			raise ValueError

	def __init__(self, *args, **kwds) :
		self.stats = {}
		super(ValidPathSet, self).__init__(*args, **kwds)
