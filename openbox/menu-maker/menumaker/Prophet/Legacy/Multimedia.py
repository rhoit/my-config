from Prophet.Legacy import App as _App, ConsoleApp as _ConsoleApp, X11App as _X11App
from Keywords import Keyword as Kw, Set as KwS
from Prophet.Categories import *




class alsamixer(_App, _ConsoleApp) :
	name = "ALSA mixer"
	comment = "ALSA sound mixer"
	keywords = KwS(Audio, Mixer)




class alsamixergui(_App, _X11App) :
	name = "X ALSA mixer"
	comment = "ALSA sound mixer for X11"
	keywords = KwS(Audio, Mixer)




class alsaplayer(_App, _X11App) :
	name = "ALSA player"
	comment = "ALSA audio player for X11"
	keywords = KwS(Audio, Player)




# REASON : requires device to be specified in command line
#class amixer(_App, _ConsoleApp) :
#	name = "Amixer"
#	comment = "ALSA sound mixer"
#	keywords = KwS(Audio, Mixer)




class audacity(_App, _X11App) :
	name = "Audacity"
	comment = "Sound editor for X11"
	keywords = KwS(Audio, AudioVideoEditing)




class aumix(_App, _ConsoleApp) :
	name = "AUmix"
	comment = "Sound mixer"
	keywords = KwS(Audio, Mixer)




class aviplay(_App, _X11App) :
	name = "Aviplay"
	comment = "Vidio player for X11"
	keywords = KwS(Video, Player)




class beep(_App, _X11App) :
	name = "Beep"
	comment = "Beep media player, a XMMS fork"
	exes = ["beep-media-player"]
	keywords = KwS(Audio, Player, GTK)




class cheesetracker(_App, _X11App) :
	name = "CheeseTracker"
	comment = "Sound tracker similar to the ScreamTracker"
	keywords = KwS(Audio, Player, Sequencer)




class cdp(_App, _ConsoleApp) :
	name = "CDp"
	comment = "CD player"
	keywords = KwS(Audio, Player)




class cplay(_App, _ConsoleApp) :
	name = "CPlay"
	comment = "Console autio player"
	keywords = KwS(Audio, Player)




class flxine(_App, _X11App) :
	name = "FLXINE"
	comment = "XINE media player"
	keywords = KwS(AudioVideo, Audio, Video, TV, Tuner, Player)




class fxtv(_App, _X11App) :
	name = "FxTV"
	comment = "*BSD TV tuner"
	keywords = KwS(AudioVideo, Video, Tuner, TV)




class easytag(_App, _X11App) :
	name = "EasyTag"
	comment = "Audio file tags manager"
	keywords = KwS(AudioVideo, AudioVideoEditing)




class emusic(_App, _X11App) :
	name = "Emusic"
	comment = "Enlightenment media player"
	keywords = KwS(AudioVideo, Audio, Player)




class eroaster(_App, _X11App) :
	name = "Eroaster"
	comment = "CD ripper/burner"
	keywords = KwS(Audio, Recorder, DiscBurning)




class _HelixReal(_App, _X11App) :
	comment = "Media player"
	keywords = KwS(AudioVideo, Audio, Video, TV, Tuner, Player, GTK)
	def __init__(self) :
		try :
			super(_HelixReal, self).__init__()
		except Prophet.NotFound :
			raise




class hxplay(_HelixReal) :
	prefix = "HelixPlayer"
	name = "HelixPlayer"




class realplay(_HelixReal) :
	prefix = "RealPlayer"
	name = "RealPlayer"




class gcombust(_App, _X11App) :
	name = "Gcombust"
	comment = "CD ripper/burner"
	keywords = KwS(Audio, Recorder, DiscBurning)




class gmplayer(_App, _X11App) :
	name = "Gmplayer"
	comment = "Mplayer frontend"
	keywords = KwS(AudioVideo, Audio, Video, TV, Tuner, Player, GTK)




class gqmpeg(_App, _X11App) :
	name = "GQmpeg"
	comment = "Media player"
	keywords = KwS(AudioVideo, Audio, Video, Player)




class gqcam(_App, _X11App) :
	name = "GQcam"
	comment = "Web camera control program"
	keywords = KwS(Video, Network)




class grip(_App, _X11App) :
	name = "Grip"
	comment = "CD ripper/burner"
	keywords = KwS(Audio, Recorder, DiscBurning)




class gtv(_App, _X11App) :
	name = "Gtv"
	comment = "Vidio player for X11"
	keywords = KwS(Video, Player)




class gxine(_App, _X11App) :
	name = "GXINE"
	comment = "XINE media player"
	keywords = KwS(AudioVideo, Audio, Video, TV, Tuner, Player, GTK)




class motv(_App, _X11App) :
	name = "MoTV"
	comment = "TV tuner"
	keywords = KwS(AudioVideo, Video, Tuner, TV, Motif)




class mp3shell(_App, _X11App) :
	name = "MP3shell"
	comment = "Audio player"
	keywords = KwS(Audio, Player)




class radio(_App, _ConsoleApp) :
	name = "Radio"
	comment = "Radio control utility"
	keywords = KwS(Audio, Player, Tuner, Utility)




class rexima(_App, _ConsoleApp) :
	name = "Rexima"
	comment = "Sound mixer"
	keywords = KwS(Audio, Mixer)




class x11amp(_App, _X11App) :
	name = "X11amp"
	comment = "Audio player, a WinAmp clone"
	keywords = KwS(Audio, Player)




class xanim(_App, _X11App) :
	name = "Xanim"
	comment = "X video player"
	keywords = KwS(Video, Player)




class xatitv(_App, _X11App) :
	name = "XatiTV"
	comment = "TV tuner control for ATI cards"
	keywords = KwS(AudioVideo, Video, Tuner, TV, Utility)




class xaumix(_App, _X11App) :
	name = "Xaumix"
	comment = "Sound mixer, an Aumix frontend"
	keywords = KwS(Audio, Mixer)




class xawtv(_App, _X11App) :
	name = "XawTV"
	comment = "TV tuner"
	keywords = KwS(AudioVideo, Video, Tuner, TV)




class xcdroast(_App, _X11App) :
	name = "Xcdroast"
	comment = "CD burner"
	keywords = KwS(Audio, DiscBurning)




class xmix(_App, _X11App) :
	name = "Xmix"
	comment = "X sound mixer"
	keywords = KwS(Audio, Mixer)




class xmms(_App, _X11App) :
	name = "XMMS"
	comment = "X multimedia sound system"
	keywords = KwS(Audio, Player, GTK)




class xmovie(_App, _X11App) :
	name = "Xmovie"
	comment = "X video player"
	keywords = KwS(Video, Player)




class xmps(_App, _X11App) :
	name = "XMPS"
	comment = "X video player"
	keywords = KwS(Video, Player)




class xpcd(_App, _X11App) :
	name = "XPCD"
	comment = "PhotoCD Viewer"
	keywords = KwS(Graphics, Photograph, Viewer)




class zinf(_App, _X11App) :
	name = "Zinf"
	comment = "Media player"
	keywords = KwS(AudioVideo, Audio, Video, TV, Tuner, Player, GTK)