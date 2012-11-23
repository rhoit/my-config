import os.path, MenuMaker, Prophet, Prophet.Legacy




from MenuMaker import indent, writeFullMenu
from xBox import X, App, Menu, Root as _Root




# The original BB doesn't have per user menu file, only the system-wide




class blackbox(Prophet.Legacy.App) : pass




class Root(_Root) :
	name = "BlackBox"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [SysMenu()]
		super(Root, self).__init__(subs)




class StylesMenu(MenuMaker.Menu) :
	name = "Styles"
	def __init__(self, dirs) :
		super(StylesMenu, self).__init__([X(x, "stylesdir") for x in dirs if os.path.isdir(os.path.expanduser(x))])
		self.align = MenuMaker.Entry.StickBottom




class SysMenu(MenuMaker.Menu) :
	name = "BlackBox"
	def __init__(self) :
		subs = [X("Workspaces", "workspaces")]
		try :
			subs += [StylesMenu([os.path.join(blackbox().prefix, "share/blackbox/styles"), "~/.blackbox/styles"])]
		except Prophet.NotSet :
			pass
		subs += [
			X("Configure", "config"),
			X("Reconfig", "reconfig"),
			X("Restart", "restart"),
			X("Exit", "exit")
		]
		super(SysMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom