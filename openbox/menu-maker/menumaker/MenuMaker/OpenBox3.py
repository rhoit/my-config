import MenuMaker




from MenuMaker import indent, writeFullMenu




menuFile = "~/.config/openbox/menu.xml"




def _map(x) :
	for d, s in (("&amp;", "&"), ("\'", "\"")) :
		x = x.replace(s, d)
	return x




class Sep(object) :
	def emit(self, level) :
		return ['%s<separator/>' % indent(level)]




class App(object) :
	def emit(self, level) :
		x = indent(level)
		xx = indent(level + 1)
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		return [
			'%s<item label="%s"> <action name="Execute">' % (x, _map(self.app.name)),
			'%s<execute>%s</execute>' % (xx, cmd),
			'%s</action> </item>' % x
		]




class Menu(object) :
	id = 0
	def __init__(self) :
		super(Menu, self).__init__()
		self.id = Menu.id
		Menu.id += 1
	def emit(self, level) :
		menu = ['%s<menu id="%s" label="%s">' % (indent(level), self.id, _map(self.name))]
		for x in self :
			menu += x.emit(level + 1)
		menu.append('%s</menu>' % indent(level))
		return menu




class Root(object) :
	name = "OpenBox 3"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [MenuMaker.Sep(), SysMenu()]
		super(Root, self).__init__(subs)
		self.id = "root-menu"
	def emit(self, level) :
		if writeFullMenu :
			menu = [
				'<?xml version="1.0" encoding="UTF-8"?>',
				'<openbox_menu>'
			]
			menu += super(Root, self).emit(level + 1)
			menu.append('</openbox_menu>')
			return menu
		else :
			menu = []
			for x in self :
				menu += x.emit(level)
			return menu




class SysMenu(MenuMaker.Menu) :
	name = "OpenBox"
	def __init__(self) :
		subs = [
			X('<menu id="client-list-menu"/>'),
			X('<item label="Reconfigure"> <action name="Reconfigure"/> </item>'),
			MenuMaker.Sep(),
			X('<item label="Exit"> <action name="Exit"/> </item>')
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
