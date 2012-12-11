from Prophet.Legacy import App as _App, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




class BasiliskII(_App, _X11App) :
	name = "Basilisk II"
	comment = "Apple Mac emulator"
	keywords = KwS(Emulator)




class bochs(_App, _ConsoleApp) :
	name = "Bochs"
	comment = "x86 architecture emulator"
	keywords = KwS(Emulator)




class dosemu(_App, _ConsoleApp) :
	name = "DOSemu"
	comment = "MS-DOS emulator"
	keywords = KwS(Emulator)




class xdosemu(_App, _X11App) :
	name = "XDOSemu"
	comment = "MS-DOS emulator, X version"
	keywords = KwS(Emulator)




# TODO : Frodo




class fuse(_App, _X11App) :
	name = "Fuse"
	comment = "ZX-Spectrum emulator"
	keywords = KwS(Emulator)




class generator(_App, _X11App) :
	name = "Generator"
	comment = "Sega Megadrive emulator"
	keywords = KwS(Emulator)




class snes9x(_App, _X11App) :
	name = "Snes9x"
	comment = "Super Nintendo emulator"
	keywords = KwS(Emulator)




# TODO : Vice




class vmware(_App, _X11App) : # FIXME : may reside in its own prefix
	name = "VMWare"
	comment = "x86 virtualizator"
	keywords = KwS(Emulator)




# NOTE : the following two are not interactive




#class wine(_App, _X11App) :
#	name = "Wine"
#	comment = "win32 emulator"
#	keywords = KwS(Emulator)




#class winex(_App, _X11App) :
#	name = "WineX"
#	comment = "win32 emulator"
#	keywords = KwS(Emulator)




# TODO : xmame/xmess




# TODO : vmware, xen




class xz80(_App, _X11App) :
	name = "XZ80"
	comment = "ZX-Spectrum emulator"
	keywords = KwS(Emulator)




class xzx(_App, _X11App) :
	name = "XZ80"
	comment = "ZX-Spectrum emulator"
	keywords = KwS(Emulator)




class zsnes(_App, _X11App) :
	name = "ZSnes"
	comment = "Super Nintendo emulator"
	keywords = KwS(Emulator)
