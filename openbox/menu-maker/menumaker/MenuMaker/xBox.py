import MenuMaker




from MenuMaker import indent, writeFullMenu




def _map(x) :
	for d, s in (("[", "("), ("]", ")")) :
		x = x.replace(s, d)
	return x




class Sep(object) :
	def emit(self, level) :
		return ['%s[separator]' % indent(level)]




class App(object) :
	def emit(self, level) :
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		return ['%s[exec] (%s) {%s}' % (indent(level), _map(self.app.name), cmd)]




class Menu(object) :
	tag = "submenu"
	def emit(self, level) :
		menu = ['%s[%s] (%s)' % (indent(level), self.tag, _map(self.name))]
		for x in self :
			menu += x.emit(level + 1)
		menu.append('%s[end]' % indent(level))
		return menu




class Root(object) :
	tag = "begin"
	def emit(self, level) :
		if writeFullMenu :
			return super(Root, self).emit(level)
		else :
			menu = []
			for x in self :
				menu += x.emit(level)
			return menu




class X(MenuMaker.Entry) :
	def __init__(self, name, tag, arg = None) :
		super(X, self).__init__()
		self.align = MenuMaker.Entry.StickBottom
		self.name = name
		self.tag = tag
		self.arg = arg
	def emit(self, level) :
		x = '%s[%s] (%s)' % (indent(level), self.tag, _map(self.name))
		if self.arg :
			x += ' {%s}' % self.arg
		return [x]
