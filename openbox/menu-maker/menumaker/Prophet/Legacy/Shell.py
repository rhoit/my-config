from Prophet.Legacy import App as _App, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




class _Terminal(_App, _X11App) :
	runFlag = "-e"
	def runCmd(self, cmd) :
		return self._runCmd + cmd
	def setExecmd(self) :
		super(_Terminal, self).setExecmd()
		self._runCmd = self.execmd + " " + self.runFlag + " "




class aterm(_Terminal) :
	name = "Aterm"
	comment = "X terminal emulator"
	keywords = KwS(TerminalEmulator)




class c3270(_App, _ConsoleApp) :
	name = "c3270"
	comment = "An IBM 3278/3279 terminal emulator"
	keywords = KwS(TerminalEmulator)




class dfm(_App, _X11App) : # FIXME : generic name
	name = "Dfm"
	comment = "OS/2 Workplace Shell clone"
	keywords = KwS(FileManager, Shell)




class emelfm(_App, _X11App) :
	name = "emelFM"
	comment = "Simple file manager"
	keywords = KwS(FileManager, GTK)




class Eterm(_Terminal) :
	name = "Eterm"
	comment = "Enlightenment terminal emulator"
	keywords = KwS(TerminalEmulator)




class fr(_App, _X11App) : # FIXME : generic name
	name = "FileRunner"
	comment = "File manager written in Tcl/Tk"
	keywords = KwS(FileManager, Shell)




class git(_App, _ConsoleApp) :
	name = "GIT"
	comment = "GNU interactive tools"
	keywords = KwS(FileManager, Shell, Utility)




class gmc(_App, _X11App) :
	name = "GnomeMC"
	comment = "GNOME version of Midnight Commander"
	keywords = KwS(FileManager, Shell, GNOME)




class _gterm(_Terminal) :
	exes = ["gnome2-terminal", "gnome-terminal", "gterminal"]
	name = "GNOME terminal"
	comment = "X terminal emulator for GNOME"
	keywords = KwS(TerminalEmulator, GNOME)




class _konsole(_Terminal) :
	exes = ["konsole"]
	name = "Konsole"
	comment = "X terminal emulator for KDE"
	keywords = KwS(TerminalEmulator, KDE)




class kterm(_Terminal) :
	name = "Kterm"
	comment = "Japanese X terminal emulator"
	keywords = KwS(TerminalEmulator)




class mc(_App, _ConsoleApp) :
	name = "MC"
	comment = "Midnight Commander"
	exes = ["midc", "mc"]
	keywords = KwS(FileManager, Shell)




class rdesktop(_App, _X11App) :
	name = "Rdesktop"
	comment = "MS Windows terminal client"
	keywords = KwS(TerminalEmulator)




class rox(_App, _X11App) :
	name = "ROX"
	comment = "RISCOS-like file manager"
	keywords = KwS(FileManager, Shell)




class tuxcmd(_App, _X11App) :
	name = "TuxCommander"
	comment = "File manager for X"
	keywords = KwS(FileManager, Shell)




class wterm(_Terminal) :
	name = "Wterm"
	comment = "X terminal emulator"
	keywords = KwS(TerminalEmulator)




class x3270(_App, _X11App) :
	name = "x3270"
	comment = "An IBM 3278/3279 terminal emulator"
	keywords = KwS(TerminalEmulator)




class xfiles(_App, _X11App) :
	name = "X-Files"
	comment = "File manager for X"
	exes = ["X-Files"]
	keywords = KwS(FileManager, Shell)




class _xfterm(_Terminal) :
	exes = ["xfterm4", "xfterm"]
	name = "Xfterm"
	comment = "X terminal emulator for Xfce"
	keywords = KwS(TerminalEmulator, Kw("Xfce"))




class xnc(_App, _X11App) :
	name = "XNC"
	comment = "X Nothern Captain - NC clone"
	keywords = KwS(FileManager, Shell)




class xplore(_App, _X11App) :
	name = "Xplorer"
	comment = "X file manager"
	keywords = KwS(FileManager, Shell, Motif)




class xterm(_Terminal) :
	name = "Xterm"
	comment = "X terminal emulator"
	keywords = KwS(TerminalEmulator, Core)




class xvt(_Terminal) : # FIXME : do we need a separate entry for rxvt?
	name = "Rxvt"
	comment = "X terminal emulator"
	exes = ["rxvt", "xvt"]
	keywords = KwS(TerminalEmulator)




class xwc(_App, _X11App) :
	name = "XWinCommander"
	comment = "X file manager"
	keywords = KwS(FileManager, Shell)
