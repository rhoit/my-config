import MenuMaker, Prophet.Legacy




from MenuMaker import indent, writeFullMenu




menuFile = "~/.config/xfce4/desktop/menu.xml"




def _map(x) :
	for d, s in (("&amp;", "&"), ("\'", "\"")) :
		x = x.replace(s, d)
	return x




class xfss(Prophet.Legacy.App) :
	exes = ["xfce-setting-show"]
	name = "Settings"




class xfhelp(Prophet.Legacy.App) :
	exes = ["xfhelp4"]
	name = "Help"




class xfabout(Prophet.Legacy.App) :
	exes = ["xfce4-about"]
	name = "About"



class Sep(object) :
	def emit(self, level) :
		return ['%s<separator/>' % indent(level)]




class App(object) :
	def emit(self, level) :
		if self.app.terminal :
			term = " term=\"true\""
		else :
			term = ""
		return ['%s<app name="%s" cmd="%s"%s/>' % (indent(level), _map(self.app.name), self.app.execmd, term)]




class Menu(object) :
	def emit(self, level) :
		result = ['%s<menu name="%s">' % (indent(level), _map(self.name))]
		for x in self :
			result += x.emit(level + 1)
		result.append('%s</menu>' % indent(level))
		return result




class Root(object) :
	def __init__(self, subs) :
		if writeFullMenu :
			subs = subs + [MenuMaker.Sep(), SysMenu()]
		super(Root, self).__init__(subs)
	def emit(self, level) :
		if writeFullMenu :
			menu = [
				'<?xml version="1.0" encoding="UTF-8"?>',
				'<!DOCTYPE xfdesktop-menu []>',
				'<xfdesktop-menu>',
				'<title name="Desktop Menu"/>'
			] + MenuMaker.Sep().emit(level)
			for x in self :
				menu += x.emit(level)
			menu.append('</xfdesktop-menu>')
			return menu
		else :
			menu = []
			for x in self :
				menu += x.emit(level)
			return menu




class SysMenu(MenuMaker.Menu) :
	name = "Xfce"
	def __init__(self) :
		subs = []
		for cls in (xfss, xfhelp, xfabout) :
			try :
				subs.append(MenuMaker.App(cls()))
			except Prophet.NotSet :
				pass
		subs += [
			MenuMaker.Sep(),
			X('<builtin name="Quit" cmd="quit"/>')
		]
		super(SysMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom




class X(MenuMaker.Entry) :
	def __init__(self, x) :
		super(X, self).__init__()
		self.align = MenuMaker.Entry.StickBottom
		self.x = x
	def emit(self, level) :
		return [indent(level) + self.x]
