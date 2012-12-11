import os.path, Prophet




from Prophet.Legacy import App as _App, DropIn as _DropIn, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




class abook(_App, _ConsoleApp) :
	name = "Abook"
	comment = "Address book"
	keywords = KwS(ContactManagement)




class alicq(_App, _X11App) :
	name = "ALICQ"
	comment = "ICQ client for X"
	keywords = KwS(Network, InstantMessaging)




class althea(_App, _X11App) :
	name = "Althea"
	comment = "E-mail client for X"
	keywords = KwS(Network, Email)




class aria(_App, _X11App) :
	name = "Aria"
	comment = "Download manager"
	keywords = KwS(Network, FileTransfer, P2P)




class BitchX(_App, _ConsoleApp) : # FIXME : versioned
	name = "Bitch X"
	comment = "IRC client"
	keywords = KwS(Network, IRCClient)




class cadaver(_App, _ConsoleApp) : # FIXME ????
	name = "Cadaver"
	comment = "WebDAV client"
	keywords = KwS(Network)




# TODO : camstream, gqcam




class centericq(_App, _ConsoleApp) :
	name = "CenterICQ"
	comment = "Console instant messenger"
	keywords = KwS(Network, InstantMessaging)




class dillo(_App, _X11App) :
	name = "Dillo"
	comment = "Small & agile web browser"
	keywords = KwS(Network, WebBrowser, GTK)



class elinks(_App, _ConsoleApp) :
	name = "ELinks"
	comment = "Text-mode web browser"
	keywords = KwS(Network, WebBrowser)




class elm(_App, _ConsoleApp) :
	name = "Elm"
	comment = "Console mailer"
	keywords = KwS(Network, Email)




class everybuddy(_App, _X11App) :
	name = "EveryBuddy"
	comment = "X11 instant messenger"
	keywords = KwS(Network, InstantMessaging)




# TODO : better detection
class firefox(_App, _X11App) :
	name = "FireFox"
	comment = "Mozilla-derived web browser"
	keywords = KwS(Network, WebBrowser, GTK)
	exes = ["MozillaFirefox", "mozilla-firefox", "firefox"]




class ftp(_App, _ConsoleApp) :
	name = "FTP"
	comment = "Console FTP client"
	keywords = KwS(Network, FileTransfer, Core)




class icqnix(_App, _X11App) :
	name = "ICQnix"
	comment = "ICQ client for X"
	keywords = KwS(Network, InstantMessaging)




class irssi(_App, _ConsoleApp) :
	name = "Irssi"
	comment = "IRC client"
	keywords = KwS(Network, IRCClient)




class licq(_App, _X11App) :
	name = "Licq"
	comment = "ICQ client for X"
	keywords = KwS(Network, InstantMessaging)




class links(_App, _ConsoleApp) :
	name = "Links"
	comment = "Text-mode web browser"
	keywords = KwS(Network, WebBrowser)




class LinNeighbohrhood(_App, _X11App) :
	name = "Lin... SAMBA browser"
	comment = "LinNxxx SAMBA browser"
	keywords = KwS(Network, FileTransfer, RemoteAccess)




class linpopup(_App, _X11App) :
	name = "LinPopUp"
	comment = "Program to communicate with Windows"
	keywords = KwS(Network, RemoteAccess)
	exes = ["LinPopUp", "linpopup"]




class lftp(_App, _ConsoleApp) :
	name = "LFTP"
	comment = "Console FTP client"
	keywords = KwS(Network, FileTransfer)




class lynx(_App, _ConsoleApp) :
	name = "Lynx"
	comment = "Text-mode web browser"
	keywords = KwS(Network, WebBrowser)




class mail(_App, _ConsoleApp) :
	name = "Mail"
	comment = "Console mailer"
	keywords = KwS(Network, Email, Core)




# TODO : better detection
class mozilla(_App, _X11App) :
	name = "Mozilla"
	comment = "Mozilla web suite"
	keywords = KwS(Network, WebBrowser, Email, WebDevelopment, GTK)




class mutt(_App, _ConsoleApp) :
	name = "Mutt"
	comment = "Mail user agent"
	keywords = KwS(Network, Email)




class ncftp(_App, _ConsoleApp) :
	name = "NcFTP"
	comment = "Improved FTP client"
	keywords = KwS(Network, FileTransfer)




class netscape(_App, _X11App) :
	name = "Netscape"
	comment = "Netscape web suite"
	keywords = KwS(Network, WebBrowser, Email, WebDevelopment)




class opera(_DropIn, _X11App) :
	name = "Opera"
	comment = "Opera browser"
	keywords = KwS(WebBrowser, Email)

	def relevant(self, path) :
		if Prophet.isExe(os.path.join(path, "opera")) :
			raise opera.StopDescention(path)




class paddress(_App, _X11App) :
	name = "Paddress"
	comment = "Address book"
	keywords = KwS(ContactManagement)




class pan(_App, _X11App) :
	name = "Pan"
	comment = "News agent"
	keywords = KwS(Network, News)




class pine(_App, _ConsoleApp) :
	name = "Pine"
	comment = "Mail/news agent"
	keywords = KwS(Network, Email, News)




class postilion(_App, _X11App) :
	name = "Postilion"
	comment = "Tcl/Tk mail client"
	keywords = KwS(Network, Email)




class skipstone(_App, _X11App) :
	name = "Skipstone"
	comment = "Mozilla-derived web browser"
	keywords = KwS(Network, WebBrowser)




class spruce(_App, _X11App) :
	name = "Spruce"
	comment = "X11 mail client"
	keywords = KwS(Network, Email)




class slrn(_App, _X11App) :
	name = "SLRN"
	comment = "USENET newreader"
	keywords = KwS(Network, News)




class talk(_App, _ConsoleApp) : # FIXME : is it text-mode?
	name = "Talk"
	comment = "Talk communication client"
	keywords = KwS(Network, IRCClient)




class telnet(_App, _ConsoleApp) :
	name = "Telnet"
	comment = "Standard Telnet client"
	keywords = KwS(Network, Shell, Core)




class thunderbird(_App, _X11App) :
	name = "Thunderbird"
	comment = "Mozilla news/mail client"
	keywords = KwS(Network, News, Email)
	exes = ["MozillaThunderbird", "thunderbird"]




class tkpppoe(_App, _X11App) :
	name = "TkPPPoE"
	comment = "PPP frontend"
	keywords = KwS(Network, Dialup)




class tkrat(_App, _X11App) :
	name = "TkRat"
	comment = "Tcl/Tk mail client"
	keywords = KwS(Network, Email)




class w3m(_App, _ConsoleApp) :
	name = "W3m"
	comment = "Text-mode web browser"
	keywords = KwS(Network, WebBrowser)




class xarchie(_App, _X11App) :
	name = "Xarchie"
	comment = "Archie client"
	keywords = KwS(Network)




class xchat(_App, _X11App) :
	name = "X-Chat"
	comment = "Powerful chat client"
	keywords = KwS(Network, InstantMessaging)




class xmailbox(_App, _X11App) :
	name = "Xmailbox"
	comment = "Mail delivery notifier"
	keywords = KwS(Network, Email)




class ytalk(_App, _ConsoleApp) :
	name = "Ytalk"
	comment = "Talk compatible communication client"
	keywords = KwS(Network, IRCClient)
