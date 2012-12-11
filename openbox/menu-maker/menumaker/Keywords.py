"""Module to handle keywords and sets of keywords"""




import types, itertools




from sets import Set as _Set




class Keyword(str) :
	"""Keyword is a case insensitive string with the spaces omitted,
		that is Keyword(Foo Bar) == Keyword(foobar)"""

	def __init__(self, s) :
		t = ""
		for x in str(s).split() :
			# FIXME : speed up the hashing by xor'ing the parts on which self is split
			# instead of performing this string concatenation
			t += x
		self.hash = hash(t.lower())
		str.__init__(self, s)

	def __hash__(self) :
		return self.hash

	def __eq__(self, other) :
		if not isinstance(other, Keyword) :
			other = Keyword(other)
		return self.hash == other.hash # Use direct hash comparison to save a call to self.__hash__()




class Set(_Set) :
	"""Mutable set of keywords. Besides keywords, it can operate on ordinary strings as well,
		which get implicitly converted into the Keyword instances"""

	def __init__(self, *args) :
		# Handle special case when this __init__ is used as a copy constructor,
		# i.e. with Set or ifilter instance as a sole argument
		# This is needed to overcome flawed standard sets implementation in Python 2.3+
		if len(args) == 1 :
			x = args[0]
			if isinstance(x, (Set, itertools.ifilter)) :
				_Set.__init__(self, x)
				return
		# ALARM : dependence on the sets.Set implementation !!!
		xargs = []
		for x in args :
			if isinstance(x, Keyword) :
				xargs.append(x)
			else :
				xargs.append(Keyword(x))
		_Set.__init__(self, xargs)

	def __contains__(self, x) :
		if isinstance(x, Keyword) :
			return _Set.__contains__(self, x)
		else :
			return _Set.__contains__(self, Keyword(x))