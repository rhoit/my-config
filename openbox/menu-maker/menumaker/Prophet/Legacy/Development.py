import os.path, Prophet




from Prophet.Legacy import App as _App, ZeroG as _ZeroG, DropIn as _DropIn, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




class cforge(_App, _X11App) :
	name = "CForge IDE"
	comment = "Code Forge IDE"
	keywords = KwS(Development, IDE) # Qt, Motif ???




class ddd(_App, _X11App) :
	name = "DDD debugger"
	comment = "X11 Display Data Debugger"
	keywords = KwS(Development, Debugger, Motif)




class eclipse(_DropIn, _X11App) :
	name = "Eclipse"
	comment = "Eclipse Java IDE"
	keywords = KwS(Development, Debugger, Java, GTK)

	def relevant(self, path) :
		if Prophet.isExe(os.path.join(path, "eclipse")) :
			raise eclipse.StopDescention(path)




class eric3(_App, _X11App) :
	name = "Eric IDE"
	comment = "Python IDE for X11"
	keywords = KwS(Development, IDE)




class estudio(_App, _X11App) :
	name = "EiffelStudio"
	comment = "EiffelStudio IDE"
	keywords = KwS(Development, IDE, Debugger)

	def getPrefixes(self) :
		return super(estudio, self).getPrefixes() + "$ISE_EIFFEL/studio/spec/$ISE_PLATFORM"




# TODO : Komodo




class jbuilder(_ZeroG, _X11App) :
	name = "JBuilder"
	magic = ".*?Borland\sJBuilder.*?"
	comment = "Borland JBuilder IDE"
	keywords = KwS(Development, IDE, GUIDesigner, Java)




class fluid(_App, _X11App) :
	name = "Fluid"
	comment = "FLTK interface builder"
	keywords = KwS(Development, IDE, GUIDesigner)




class fp(_App, _ConsoleApp) : # FIXME : name's pretty generic, name clash possible
	name = "FreePascal"
	comment = "Standart IDE for the FreePascal"
	keywords = KwS(Development, IDE, Core)




class gdb(_App, _ConsoleApp) :
	name = "GDB"
	comment = "Standard GNU debugger"
	keywords = KwS(Development, Debugger, Core)




class idb(_App, _ConsoleApp) :
	name = "IDB"
	comment = "Intel debugger"
	keywords = KwS(Development, Debugger)




class idea(_ZeroG, _X11App) :
	exes = ["idea.sh", "idea"]
	name = "IDEA"
	magic = ".*?IntelliJ\sIDEA.*?"
	comment = "IntelliJ IDEA IDE"
	keywords = KwS(Development, IDE, GUIDesigner, Java)




class kylix(_App, _X11App) :
	name = "Kylix"
	comment = "Borland Delphi IDE for UNIX"
	exes = ["startdelphi", "startkylix"]
	keywords = KwS(Development, IDE, GUIDesigner, Debugger)




class lazarus(_DropIn, _X11App) :
	name = "Lazarus"
	comment = "Delphi-like FreePascal IDE"
	keywords = KwS(Development, Debugger, GUIDesigner, GTK)

	def relevant(self, path) :
		if Prophet.isExe(os.path.join(path, "lazarus")) :
			raise lazarus.StopDescention(path)




class motor(_App, _ConsoleApp) :
	name = "Motor IDE"
	comment = "Console IDE with Borland look&feel"
	keywords = KwS(Development, IDE)




class netbeans(_DropIn, _X11App) :
	name = "NetBeans"
	comment = "NetBeans Java IDE"
	keywords = KwS(Development, Debugger, Java, GTK)

	def relevant(self, path) :
		if Prophet.isExe(os.path.join(path, "bin/netbeans")) :
			raise netbeans.StopDescention(path)




class tkcvs(_App, _X11App) :
	name = "TkCVS"
	comment = "X11 CVS frontend"
	keywords = KwS(Development, RevisionControl)




class ups(_App, _X11App) : # FIXME : generic name
	name = "UPS"
	comment = "Native X11 debugger"
	keywords = KwS(Development, Debugger)




class wpe(_App, _ConsoleApp) :
	name = "WPE"
	comment = "A text-mode Borland-like IDE"
	keywords = KwS(Development, IDE)




class xwpe(_App, _X11App) :
	name = "XWPE"
	comment = "Borland-like IDE for X11"
	keywords = KwS(Development, IDE)




class xxgdb(_App, _X11App) :
	name = "XXGDB"
	comment = "X11 GDB frontend"
	keywords = KwS(Development, Debugger)
