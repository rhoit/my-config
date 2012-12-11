import os.path, MenuMaker, Prophet, Prophet.Legacy




from MenuMaker import indent, writeFullMenu, omitEmptyMenu




menuFile = "~/GNUstep/Defaults/WMRootMenu"




def _map(x) :
	for d, s in (("\'", "\""),) :
		x = x.replace(s, d)
	return x




class wmaker(Prophet.Legacy.App) : pass
class wmsetbg(Prophet.Legacy.App) : exeargs = "-u -t"
class setstyle(Prophet.Legacy.App) : pass
class seticons(Prophet.Legacy.App) : pass
class getstyle(Prophet.Legacy.App) : exeargs = "-t"
class geticonset(Prophet.Legacy.App) : exeargs = "-t"




class WPrefs(Prophet.Legacy.App) :
	def getPrefixes(self) :
		return Prophet.PrefixSet(os.path.join(wmaker().prefix, "lib/GNUstep/Applications/WPrefs.app")) + super(WPrefs, self).getPrefixes()




class App(object) :
	def emit(self, level) :
		cmd = self.app.execmd
		if self.app.terminal :
			cmd = MenuMaker.terminal.runCmd(cmd)
		if self._comma :
			return ['%s("%s", EXEC, "%s"),' % (indent(level), _map(self.app.name), cmd)]
		else :
			return ['%s("%s", EXEC, "%s")' % (indent(level), _map(self.app.name), cmd)]




class Menu(object) :
	def _commas(self) :
		if len(self) > 0 :
			entries = []
			for x in self :
				if isinstance(x, MenuMaker.Menu) :
					if not (omitEmptyMenu and x.empty) :
						entries.append(x)
				else :
					entries.append(x)
			if len(entries) > 0 :
				for i in range(0, len(entries) - 1) :
					entries[i]._comma = True
				entries[len(entries) - 1]._comma = False
			return entries
		else :
			return []
	def emit(self, level) :
		if len(self) > 0 :
			menu = ['%s("%s",' % (indent(level), _map(self.name))]
		else :
			menu = ['%s("%s"' % (indent(level), _map(self.name))]
		for x in self._commas() :
			menu += x.emit(level + 1)
		if self._comma :
			menu.append('%s),' % indent(level))
		else :
			menu.append('%s)' % indent(level))
		return menu




class Root(object) :
	_comma = False
	name = "WindowMaker"
	def __init__(self, subs) :
		if writeFullMenu :
			subs += [SysMenu()]
		super(Root, self).__init__(subs)
	def emit(self, level) :
		if writeFullMenu :
			return super(Root, self).emit(level)
		else :
			menu = []
			for x in self._commas() :
				menu += x.emit(level)
			return menu




class SysMenu(MenuMaker.Menu) :
	name = "WindowMaker"
	def __init__(self) :
		subs = [
			X("Workspaces", "WORKSPACE_MENU"),
			AppearanceMenu(),
			X("Run...", "SHEXEC", "%a(Run,Type command to run:)"),
			X("Save session", "SAVE_SESSION"),
			X("Clear session", "CLEAR_SESSION")
		]
		try :
			subs.append(X("Preferences", "EXEC", WPrefs().execmd))
		except Prophet.NotSet :
			pass
		subs += [
			X("Restart", "RESTART"),
			X("Exit", "EXIT")
		]
		super(SysMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom




class AppearanceMenu(MenuMaker.Menu) :
	name = "Appearance"
	def __init__(self) :
		subs = []
		try :
			sys = os.path.join(wmaker().prefix, "share/WindowMaker/")
		except Prophet.NotSet :
			sys = "/" # Doesn't actually matter
		usr = "$HOME/GNUstep/Library/WindowMaker/"
		try :
			execmd = setstyle().execmd
			for id in ("Themes", "Styles") :
				subs += self.openMenu(id, execmd, [sys + id, usr + id])
		except Prophet.NotSet :
			pass
		try :
			subs += self.openMenu("Icons", seticons().execmd, [sys + "IconSets", usr + "IconSets"])
		except Prophet.NotSet :
			pass
		try :
			subs += self.openMenu("Backgrounds", wmsetbg().execmd, [sys + "Backgrounds", usr + "Backgrounds"])
		except Prophet.NotSet :
			pass
		try :
			subs.append(X("Save Theme", "SHEXEC", getstyle().execmd + " " + usr + '''Themes/\\"%a(Theme name)\\"'''))
		except Prophet.NotSet :
			pass
		try :
			subs.append(X("Save IconSet", "SHEXEC", geticonset().execmd + " " + usr + '''IconSets/\\"%a(IconSet name)\\"'''))
		except Prophet.NotSet :
			pass
		super(AppearanceMenu, self).__init__(subs)
		self.align = MenuMaker.Entry.StickBottom
	def openMenu(self, name, execmd, dirs) :
			s = ""
			for x in dirs :
				dir = os.path.expandvars(x)
				if os.path.isdir(dir) :
					s += x + " "
			if len(s) > 0 :
				return [X(name, "OPEN_MENU", "-noext " + s + "WITH " + execmd)]
			else :
				return []




class X(MenuMaker.Entry) :
	def __init__(self, name, cmd, arg = None) :
		super(X, self).__init__()
		self.name = name
		self.cmd = cmd
		self.arg = arg
		self.align = MenuMaker.Entry.StickBottom
	def emit(self, level) :
		if self.arg :
			s = '%s("%s", %s, "%s")' % (indent(level), _map(self.name), self.cmd, self.arg)
		else :
			s = '%s("%s", %s)' % (indent(level), _map(self.name), self.cmd)
		if self._comma :
			return [s + ","]
		else :
			return [s]
