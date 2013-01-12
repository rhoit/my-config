import os.path, MenuMaker, Prophet, Prophet.Legacy




from MenuMaker import indent, writeFullMenu
from xBox import X, Sep, App, Menu, Root as _Root




menuFile = "~/.fluxbox/menu"




class fluxbox(Prophet.Legacy.App) : pass




class Root(_Root) :
	name = "FluxBox"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [MenuMaker.Sep(), SysMenu()]
		super(Root, self).__init__(subs)




class StylesMenu(MenuMaker.Menu) :
	name = "Styles"
	def __init__(self, dirs) :
		super(StylesMenu, self).__init__([X(x, "stylesdir") for x in dirs if os.path.isdir(os.path.expanduser(x))])
		self.align = MenuMaker.Entry.StickBottom




class SysMenu(MenuMaker.Menu) :
	name = "FluxBox"
	def __init__(self) :
		subs = [X("Workspaces", "workspaces")]
		try :
			subs += [StylesMenu([os.path.join(fluxbox().prefix, "share/fluxbox/styles"), "~/.fluxbox/styles"])]
		except Prophet.NotSet :
			pass
		subs += [
			X("Configure", "config"),
			X("Reconfig", "reconfig"),
			X("Restart", "restart"),
			MenuMaker.Sep(),
			X("Exit", "exit")
		]
		super(SysMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom