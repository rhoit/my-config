import sys




if not (sys.version_info[0] >= 2 and sys.version_info[1] >= 3) :
    fatal("Python 2.3 or higher is required")




from Prophet import warn, fatal
from Keywords import Keyword as Kw, Set as KwS
import Prophet.Legacy.Shell as T




from Config import *




verbose			= 0
omitEmptyMenu	= True  # Whether to omit or to retain empty menu
writeFullMenu	= True  # Whether to generate the entire menu or just a part to be included into the hand crafted one




fronts = {
	Kw("IceWM")			: KwS("IceWM"),
	Kw("BlackBox")		: KwS("BlackBox"),
	Kw("FluxBox")		: KwS("FluxBox"),
	Kw("PekWM")			: KwS("PekWM"),
	Kw("Deskmenu")		: KwS("Deskmenu"),
	Kw("Xfce4")			: KwS("Xfce", "Xfce4"),
	Kw("OpenBox3")		: KwS("OpenBox", "OpenBox3"),
	Kw("WindowMaker")	: KwS("WindowMaker", "WMaker")
}




# FIXME : the order should be frontend-specific
# For instance, Xfce may want to have Xfterm the preferable terminal
terms = [
	(T.xterm, KwS("Xterm")),
	(T._xfterm, KwS("Xfterm")),
	(T.xvt, KwS("Rxvt", "Xvt")),
	(T.aterm, KwS("Aterm")),
	(T.wterm, KwS("Wterm")),
	(T.Eterm, KwS("Eterm")),
	(T._gterm, KwS("GNOME-terminal", "Gterm")),
	(T._konsole, KwS("Konsole"))
]




def msg(s, newline = True) :
	if verbose :
		sys.stderr.write(s)
		if newline :
			sys.stderr.write("\n")
	sys.stderr.flush()




def indent(level) :
	"""Return indentation string for specified level"""
	x = ""
	for i in range(0, level) : x += "	" # FIXME : make this stuff faster
	return x




def setFrontend(module) :
	"""Specify the frontend to use"""
	for x in (Entry, Sep, App, Menu, Root) :
		try :
			x.__bases__ = (getattr(module, x.__name__),) + x.__bases__
		except AttributeError :
			pass




class Entry(object) :
	"""Basic menu class"""
	# Alignment specifiers
	Floating	= 0 # Element is subject to sorting
	StickTop	= 1 # Element should be placed at the menu top retaining the original order
	StickBottom	= 2 # ...at the bottom...

	def __init__(self) :
		self.align = Entry.Floating




class Sep(Entry) :
	"""A separator"""

	def __init__(self) :
		self.align = Entry.StickBottom




class App(Entry) :
	"""Application entry"""

	def __init__(self, app) :
		super(App, self).__init__()
		self.name = app.name
		self.app = app




class Menu(Entry, list) :
	"""Class which may contain other (sub)menus and single entries"""

	def __init__(self, subs) :
		super(Menu, self).__init__()
		self[:] = subs

	def distribute(self, apps) :
		"""Distribute the application entries among the menu's submenus and then try to place the
			rest into itself. Return the list of the apps that didn't fit anywhere"""
		for x in self :
			if isinstance(x, Menu) :
				apps = x.distribute(apps)
		rest = []
		for x in apps :
			if self.suitable(x) :
				self.append(App(x))
			else :
				rest.append(x)
		return rest

	def empty(self) :
		"""Check whether the menu is empty, i.e. doesn't contain any meaningful entries
			(non-empty submenus, for ex.)"""
		for x in self :
			if isinstance(x, Menu) :
				if not x.empty :
					return False
			else :
				return False
			# TODO : separators do not count
		return True
	empty = property(empty)

	def emit(self, level) :
		if omitEmptyMenu and self.empty :
			return []
		else :
			return super(Menu, self).emit(level) # Delegating it in hope that there is frontend-specific emit() down the inheritance graph

	def suitable(self, app) :
		"""Simple suitability test -- check whether the app falls into any of specified categories"""
		return len(self.keywords & app.keywords) > 0

	def arrange(self) :
		top = []
		bottom = []
		mfloat = []
		efloat = []
		for x in self :
			if isinstance(x, Menu) :
				x.arrange()
			if   x.align == Entry.Floating :
				if isinstance(x, Menu) :
					mfloat.append(x)
				else :
					efloat.append(x)
			elif x.align == Entry.StickTop :
				top.append(x)
			elif x.align == Entry.StickBottom :
				bottom.append(x)
		mfloat.sort(Menu.compare)
		efloat.sort(Menu.compare)
		self[:] = top + mfloat + efloat + bottom

	compare = staticmethod(lambda x, y : cmp(x.name.lower(), y.name.lower()))




import os.path, fnmatch




from Prophet.Categories import *
from Keywords import Set as KwS, Keyword as Kw




class Root(Menu) :

	def __init__(self) :
		subs = [
			DevApps, Editors, OfficeApps, ScienceApps, NetApps, GraphicApps,
			Multimedia, Edutainment, Games, Shells, SystemApps, Utils, Misc
		]
		super(Root, self).__init__([x([]) for x in subs])

	def suitable(self, app) :
		return True




def _menu(id, kws) :
	class _Menu(Menu) :
		name = id
		def suitable(self, app) :
			return len(app.keywords & kws) > 0
	return _Menu




class KDevelop(Menu) :
	name = "KDevelop"
	def suitable(self, app) :
		return fnmatch.fnmatch(app.name, "*KDevelop*")




class DevApps(Menu) :
	name = "Development"
	keywords = KwS(Development, Building, Debugger, IDE, GUIDesigner, Profiling, RevisionControl, Translation, WebDevelopment)

	def __init__(self, subs) :
		subs = [KDevelop]
		super(DevApps, self).__init__([x([]) for x in subs])




class Editors(Menu) :
	name = "Editors"
	keywords = KwS(TextEditor)




class Misc(Menu) :
	"""Menu that contains the entries that didn't fit elsewhere"""
	name = "Other"
	def suitable(self, app) :
		return True




class Shells(Menu) :
	name = "Shells"
	keywords = KwS(Shell, TerminalEmulator, FileManager, Emulator)




class Utils(Menu) :
	name = "Utilities"
	keywords = KwS(Utility, Accessibility, Calculator, Clock, Applet, Archiving, TrayIcon)




# KDE-specific keywords
#XKM	= Kw("X-KDE-More")
#XKI	= Kw("X-KDE-information")
#




class GNOMESettings(Menu) :
	name = "GNOME"
	keywords = KwS(GNOME, Settings)

	def suitable(self, app) :
		return len(app.keywords & self.keywords) == 2




def _kdeMenu(id, kws) :
	class _Menu(Menu) :
		name = id
		def suitable(self, app) :
			return len(app.keywords & KwS(KDE, "X-KDE-settings")) and len(app.keywords & kws)
	return _Menu




class KDESettings(Menu) :
	name = "KDE"

	def __init__(self, subs) :
		subs = [
			("Look & Feel", KwS("X-KDE-settings-looknfeel")),
			("Sound", KwS("X-KDE-settings-sound")),
			("System", KwS("X-KDE-settings-system")),
			("Accessibility", KwS("X-KDE-settings-accessibility")),
			("Components", KwS("X-KDE-settings-components")),
			("Network", KwS("X-KDE-settings-network")),
			("Security", KwS("X-KDE-settings-security")),
			("Web", KwS("X-KDE-settings-webbrowsing")),
			("Desktop", KwS("X-KDE-settings-desktop")),
			("Peripherials", KwS("X-KDE-settings-peripherials")),
			("Hardware", KwS("X-KDE-settings-hardware")),
			("Power", KwS("X-KDE-settings-power"))
		]
		super(KDESettings, self).__init__([_kdeMenu(*x)([]) for x in subs])

	def suitable(self, app) :
		for x in app.keywords :
			if fnmatch.fnmatch(x, "X-KDE-settings*") :
				return True
		return False




class XfceSettings(Menu) :
	name = "Xfce"

	def suitable(self, app) :
		return len(app.keywords & KwS(Settings, Kw("X-XFCE"))) == 2




class SystemSettings(Menu) :
	name = "Settings"
	keywords = KwS(Settings, DesktopSettings, HardwareSettings, Screensaver)

	def __init__(self, subs) :
		subs = [GNOMESettings, KDESettings, XfceSettings]
		super(SystemSettings, self).__init__([x([]) for x in subs])




class SystemApps(Menu) :
	name = "System"
	keywords = KwS(System, Filesystem, Monitor, Security, PackageManager)

	def __init__(self, subs) :
		subs = [_menu("Information", KwS("X-KDE-information")), SystemSettings]
		super(SystemApps, self).__init__([x([]) for x in subs])




class ScienceApps(Menu) :
	name = "Science"
	keywords = KwS(Electronics, Engineering, Science, Astronomy, Biology, Chemistry, Geology, Math, MedicalSoftware, Physics)




class Edutainment(Menu) :
	name = "Education"
	keywords = KwS(Education, Art, Construction, Music, Languages, Teaching)




class AdventureGames(Menu) :
	name = "Adventure"
	keywords = KwS(AdventureGame, RolePlaying)




class ArcadeGames(Menu) :
	name = "Arcade"
	keywords = KwS(ArcadeGame, ActionGame)




class BoardGames(Menu) :
	name = "Board"
	keywords = KwS(BoardGame)




class CardGames(Menu) :
	name = "Card"
	keywords = KwS(CardGame)




class PuzzleGames(Menu) :
	name = "Puzzle"
	keywords = KwS(LogicGame, BlocksGame)




class SimGames(Menu) :
	name = "Simulation"
	keywords = KwS(Simulation)




class SportsGames(Menu) :
	name = "Sports"
	keywords = KwS(SportsGame)




class StrategyGames(Menu) :
	name = "Strategy"
	keywords = KwS(StrategyGame)




class ToyGames(Menu) :
	name = "Amusement"
	keywords = KwS(Amusement, KidsGame)




class Games(Menu) :
	name = "Games"
	keywords = KwS(Amusement, Game, ActionGame, AdventureGame, ArcadeGame, BoardGame, BlocksGame, CardGame, KidsGame, LogicGame, RolePlaying, Simulation, SportsGame, StrategyGame)

	def __init__(self, subs) :
		subs = [
			AdventureGames, ArcadeGames, BoardGames, CardGames, 
			PuzzleGames, SimGames, SportsGames, StrategyGames, ToyGames
		]
		super(Games, self).__init__([x([]) for x in subs])




class Multimedia(Menu) :
	name = "Multimedia"
	keywords = KwS(AudioVideo, Audio, Midi, Mixer, Sequencer, Tuner, Video, TV, AudioVideoEditing, Player, Recorder, DiscBurning)




class NetApps(Menu) :
	name = "Network"
	keywords = KwS(Network, Dialup, InstantMessaging, IRCClient, FileTransfer, HamRadio, News, Email, P2P, RemoteAccess, Telephony, WebBrowser)




class GraphicApps(Menu) :
	name = "Graphics"
	keywords = KwS(Graphics, x2DGraphics, x3DGraphics, VectorGraphics, RasterGraphics, Scanning, OCR, Photograph, Viewer)




class OfficeApps(Menu) :
	name = "Office"
	keywords = KwS(Office, Calendar, ContactManagement, Database, Dictionary, Chart, Finance, FlowChart, PDA, ProjectManagement, Presentation, Spreadsheet, WordProcessor)
