import os.path, MenuMaker, Prophet, Prophet.Legacy




from MenuMaker import indent, writeFullMenu




menuFile = "~/.pekwm/menu"




def _map(x) :
	for d, s in (("\'", "\""),) :
		x = x.replace(s, d)
	return x




class pekwm(Prophet.Legacy.App) : pass




class Sep(object) :
	def emit(self, level) :
		return ['%sSeparator {}' % indent(level)]




class App(object) :
	def emit(self, level) :
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		return ['%sEntry = "%s" { Actions = "Exec %s &" }' % (indent(level), _map(self.app.name), cmd)]




class Menu(object) :
	tag = "Submenu"
	def emit(self, level) :
		result = ['%s%s = "%s" {' % (indent(level), self.tag, _map(self.name))]
		for x in self :
			result += x.emit(level + 1)
		result.append('%s}' % indent(level))
		return result




class Root(object) :
	name = "/"
	tag = "Rootmenu"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [MenuMaker.Sep(), SysMenu()]
		super(Root, self).__init__(subs)
	def emit(self, level) :
		if writeFullMenu :
			return super(Root, self).emit(level) + [windowMenu]
		else :
			result = []
			for x in self :
				result += x.emit(level)
			return result




class SysMenu(MenuMaker.Menu) :
	name = "PekWM"
	def __init__(self) :
		subs = [
			ThemesMenu(),
			X("Reload", "Reload"),
			X("Restart", "Restart"),
			MenuMaker.Sep(),
			X("Exit", "Exit")
		]
		super(SysMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom




class ThemesMenu(MenuMaker.Menu) :
	name = "Themes"
	def __init__(self) :
		subs = []
		try :
			prefix = pekwm().prefix
			themeset = os.path.join(prefix, "share/pekwm/scripts/pekwm_themeset.pl")
			if Prophet.isExe(themeset) :
				for dir in (os.path.join(prefix, "share/pekwm/themes"), "~/.pekwm/themes") :
					if os.path.isdir(os.path.expanduser(dir)) :
						subs.append(X(None, "Dynamic %s %s" % (themeset, dir)))
		except Prophet.NotSet :
			pass
		super(ThemesMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom




class X(MenuMaker.Entry) :
	def __init__(self, entry, actions) :
		super(X, self).__init__()
		self.entry = entry
		self.actions = actions
		self.align = MenuMaker.Entry.StickBottom
	def emit(self, level) :
		if self.entry :
			return ['%sEntry = "%s" { Actions = "%s" }' % (indent(level), _map(self.entry), self.actions)]
		else :
			return ['%sEntry { Actions = "%s" }' % (indent(level), self.actions)]




windowMenu = '''
WindowMenu = "Window Menu" {
	Entry = "(Un)Stick" { Actions = "Toggle Sticky" }
	Entry = "(Un)Shade" { Actions = "Toggle Shaded" }
	Submenu = "Maximize" {
		Entry = "Full" { Actions = "Toggle Maximized True True" }
		Entry = "Horizontal" { Actions = "Toggle Maximized True False" }
		Entry = "Vertical" { Actions = "Toggle Maximized False True" }
	}
	Submenu = "Fill" {
		Entry = "Full" { Actions = "MaxFill True True" }
		Entry = "Horizontal" { Actions = "MaxFill True False" }
		Entry = "Vertical" { Actions = "MaxFill False True" }
	}
	Submenu = "Stacking" {
		Entry = "Raise " { Actions = "Raise" }
		Entry = "Lower" { Actions = "Lower" }
		Entry = "Always On Top " { Actions = "Toggle AlwaysOnTop" }
		Entry = "Always Below" { Actions = "Toggle AlwaysBelow" }
	}
	Submenu = "Decor" {
		Entry = "Decor" { Actions = "Toggle DecorBorder; Toggle DecorTitlebar" }
		Entry = "Border" { Actions = "Toggle DecorBorder" }
		Entry = "Titlebar" { Actions = "Toggle DecorTitlebar" }
	}
	Submenu = "Skip" {
		Entry = "Menus" { Actions = "Toggle Skip Menus" }
		Entry = "Focus Toggle" { Actions = "Toggle Skip FocusToggle" }
		Entry = "Snap" { Actions = "Toggle Skip Snap" }
	}
	Entry = "Iconify " { Actions = "Set Iconified" }
	Entry = "Manual Action" { Actions = "ShowCmdDialog" }
	Separator {}
	Entry = "Close" { Actions = "Close" }
	Entry = "Kill " { Actions = "Kill " }
}
'''
