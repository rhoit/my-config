import MenuMaker




from MenuMaker import indent




menuFile = "~/.icewm/menu"




def _map(x) :
	for d, s in (("\'", "\""),) :
		x = x.replace(s, d)
	return x




class App(object) :
	def emit(self, level) :
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		return ['%sprog "%s" - %s' % (indent(level), _map(self.app.name), cmd)]




class Menu(object) :
	def emit(self, level) :
		result = ['%smenu "%s" folder {' % (indent(level), _map(self.name))]
		for x in self :
			result += x.emit(level + 1)
		result.append('%s}' % indent(level))
		return result




class Root(object) :
	def emit(self, level) :
		menu = []
		for x in self :
			menu += x.emit(level)
		return menu
