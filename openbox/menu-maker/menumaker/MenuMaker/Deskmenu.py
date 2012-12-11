import MenuMaker




from MenuMaker import writeFullMenu




menuFile = "~/.deskmenurc"




def _map(x) :
	for d, s in (("|", ":"),) :
		x = x.replace(s, d)
	return x




class Sep(object) :
	def emit(self, level) :
		return ["divider=", ""]




class App(object) :
	def emit(self, level) :
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		return ["menuitem=%s:%s" % (_map(self.app.name), cmd)]




class Menu(object) :
	def emit(self, level) :
		menu = ["submenu=%s" % _map(self.name)]
		for x in self :
			menu += x.emit(level + 1)
		menu += ["endmenu=", ""]
		return menu




class Root(object) :
	name = "Deskmenu"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [MenuMaker.Sep(),  X("windowlist=Windows"), X("workspaces=Workspaces")]
		super(Root, self).__init__(subs)
	def emit(self, level) :
		if writeFullMenu :
			menu = ["keycode=Control+Escape", ""]
		else :
			menu = []
		for x in self :
			menu += x.emit(level)
		return menu




class X(MenuMaker.Entry) :
	def __init__(self, x) :
		super(X, self).__init__()
		self.align = MenuMaker.Entry.StickBottom
		self.x = x
	def emit(self, level) :
		return [self.x]
