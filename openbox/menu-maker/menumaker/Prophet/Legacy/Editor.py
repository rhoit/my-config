from Prophet.Legacy import App as _App, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




X_HTML = Kw("X-HTML")




class asWedit(_App, _X11App) :
	name = "asWedit"
	comment = "Advanced HTML editor"
	keywords = KwS(TextEditor, X_HTML)




class beaver(_App, _X11App) :
	name = "Beaver"
	comment = "A programmer's editor"
	keywords = KwS(TextEditor, Development, GTK)




class bluefish(_App, _X11App) :
	name = "BlueFish"
	comment = "Advanced HTML editor and web publishing application"
	keywords = KwS(TextEditor, Development, GNOME, X_HTML)




class cooledit(_App, _X11App) :
	name = "CoolEdit"
	comment = "X11 text editor"
	keywords = KwS(TextEditor)




class cute(_App, _X11App) :
	name = "Cute"
	comment = "User-friendly editor with syntax hilighting"
	keywords = KwS(TextEditor, Qt)




class ee(_App, _ConsoleApp) :
	name = "Easy Editor"
	comment = "Standard FreeBSD text editor"
	keywords = KwS(TextEditor, Core)

	def valid(self, pfx, exe) :
		import os.path
		if os.path.isfile(os.path.join(pfx, "share/misc/init.ee")) :
			return super(ee, self).valid(pfx, exe)
		else :
			return False




class elvis(_App, _ConsoleApp) :
	name = "Elvis"
	comment = "Vi compatible editor"
	keywords = KwS(TextEditor)




class emacs(_App, _ConsoleApp) : # FIXME : make this versioned
	name = "Emacs"
	comment = "A powerful text editing environment"
	keywords = KwS(TextEditor)




# TODO : jedit, jext




class jed(_App, _ConsoleApp) :
	name = "Jed"
	comment = "Simple text editor"
	keywords = KwS(TextEditor)




class joe(_App, _ConsoleApp) :
	name = "Joe"
	comment = "Joe's own editor"
	keywords = KwS(TextEditor)




class jove(_App, _ConsoleApp) :
	name = "Jove"
	comment = "Emacs-like text editor"
	keywords = KwS(TextEditor)




class gvim(_App, _X11App) :
	name = "GVim"
	comment = "X11 version of Vim, a Vi clone"
	keywords = KwS(TextEditor)




class gxedit(_App, _X11App) :
	name = "GXedit"
	comment = "Simple X11 text editor"
	keywords = KwS(TextEditor, GTK)




# TODO : mp




class nano(_App, _ConsoleApp) :
	name = "Nano"
	comment = "Simple text editor"
	keywords = KwS(TextEditor)




class nedit(_App, _X11App) :
	name = "Nedit"
	comment = "Advanced X11 text editor"
	keywords = KwS(TextEditor, Motif)




class pico(_App, _ConsoleApp) :
	name = "Pico"
	comment = "A Nano text editor clone"
	keywords = KwS(TextEditor)




class screem(_App, _X11App) :
	name = "Screem"
	comment = "Advanced HTML editor"
	keywords = KwS(TextEditor, GTK, X_HTML) # FIXME : GTK???




class vi(_App, _ConsoleApp) :
	name = "Vi"
	comment = "Standard UNIX text editor"
	keywords = KwS(TextEditor, Core)




class vile(_App, _ConsoleApp) :
	name = "Vile"
	comment = "Vi clone"
	keywords = KwS(TextEditor)




class vim(_App, _ConsoleApp) :
	name = "Vim"
	comment = "Vi clone"
	keywords = KwS(TextEditor)




class we(_App, _ConsoleApp) : # FIXME : generic name, additional checks needed
	name = "We"
	comment = "Console version of Xwpe text editor"
	keywords = KwS(TextEditor, Development)




class xedit(_App, _X11App) :
	name = "Xedit"
	comment = "Standard X11 text editor"
	keywords = KwS(TextEditor, Core)




class xemacs(_App, _X11App) : # FIXME : make this versioned
	name = "Xemacs"
	comment = "X11 version of Emacs"
	keywords = KwS(TextEditor)




class xjed(_App, _X11App) :
	name = "Xjed"
	comment = "X11 version of Jed"
	keywords = KwS(TextEditor)




class xwe(_App, _X11App) :
	name = "Xwe"
	comment = "X11 version of Xwpe text editor"
	keywords = KwS(TextEditor, Development)




class yudit(_App, _X11App) :
	name = "Yudit"
	comment = "X11 unicode text editor"
	keywords = KwS(TextEditor)




# TODO : yzis
