local wibox = require 'wibox'
local gears = require 'gears'

local gfs = require 'gears.filesystem'
local themes_path = gfs.get_themes_dir()

local home = os.getenv 'HOME'
local icon = "/usr/share/icons/Adwaita/24x24/"

-------------------------------------------------------------------------


-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Background Colors
--]]---------------------------------------------------------------------
local bg0											= '#282828'
local bg0_h									= '#1D2021'
local bg0_s									= '#32302F'
local bg1											= '#3C3836'
local bg2											= '#504945'
local bg3											= '#665C54'
local bg4											= '#7C6F64'

--[[---------------------------------------------------------------------
																												Foreground Colors
--]]---------------------------------------------------------------------
local fg0											= '#FBF1C7'
local fg1											= '#EBDBB2'
local fg2											= '#D5C4A1'
local fg3											= '#BDAE93'
local fg4											= '#A89984'

--[[---------------------------------------------------------------------
																												Highlight Colors
--]]---------------------------------------------------------------------
local red											= '#CC241D'
local redAlt								= '#FB4934'

local green									= '#98971A'
local greenAlt						= '#B8BB26'

local yellow								= '#D79921'
local yellowAlt					= '#FABD2F'

local blue										= '#458588'
local blueAlt							= '#83A598'

local purple								= '#B16286'
local purpleAlt					= '#D3869B'

local aqua										= '#689D6A'
local aquaAlt							= '#8EC07C'

local orange								= '#D65D0E'
local orangeAlt					= '#FE8019'

local gray										= '#A89984'
local grayAlt							= '#928374'


-------------------------------------------------------------------------


--[[---------------------------------------------------------------------

--]]---------------------------------------------------------------------
local theme = {
				font = "sans 10",

				tasklist_bg_normal						= bg2,
				tasklist_fg_normal						= fg0,
				tasklist_bg_urgent						= red,
				tasklist_fg_urgent						= fg0,

				bar_bg																		= orange,

				bgnormal				= bg0_s,
				fgnormal				= fg2,
				bghigh						= bg2,
				fghigh						= fg0,
				bgfocus					= bg3,
				fgfocus					= fg0,
}
-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Base Colorscheme
--]]---------------------------------------------------------------------

theme.bg_normal															= bg0_h
theme.bg_focus																= bg1
theme.bg_minimize													= bg3
theme.bg_urgent															= red

theme.fg_normal															= fg1
theme.fg_focus																= fg0
theme.fg_minimize													= fg3
theme.fg_urgent															= bg0

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Load the Wallpaper
--]]---------------------------------------------------------------------

theme.wallpaper = home .. "/Pictures/Wallpaper/void.png"

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																								Tag Specific Colorshemes
--]]---------------------------------------------------------------------

theme.mytags = {
				['Q'] = { highlight = aqua,   },
				['W'] = { highlight = yellow, },
				['E'] = { highlight = purple, },
				['R'] = { highlight = green,  },

				default = {
								bgnormal				= bg0_s,
								fgnormal				= fg2,
								bghigh						= bg2,
								fghigh						= fg0,
								bgfocus					= bg3,
								fgfocus					= fg0,
				}
}

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												System Tray Styles
--]]---------------------------------------------------------------------

theme.bg_systray = bg2
theme.systray_icon_spacing = 5

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																								  Contextual Menu Style
--]]---------------------------------------------------------------------

theme.menu_border_color = orange
theme.menu_border_width = 2
theme.menu_width = 300
theme.menu_height = 24
theme.menu_font = 'sans 12'

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Icons for Layouts
--]]---------------------------------------------------------------------

theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																								Icons for Layouts
--]]---------------------------------------------------------------------

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

theme.lain_icons         = os.getenv "HOME" .. "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerfairw.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Icons for the Pods
--]]---------------------------------------------------------------------

theme.pods_sep						= "/usr/share/icons/Papirus-Dark/symbolic/apps/separator-symbolic.svg"

theme.pods_calendar = "/usr/share/icons/Papirus-Dark/symbolic/mimetypes/x-office-calendar-symbolic.svg"
theme.pods_clock				= "/usr/share/icons/Papirus-Dark/24x24/actions/clock.svg"
theme.pods_volume			= "/usr/share/icons/Papirus-Dark/24x24/actions/audio-volume-high.svg"
theme.pods_keyboard	= "/usr/share/icons/Papirus-Dark/16x16/devices/input-keyboard.svg"

theme.pods_numlock = {
				on														= "/usr/share/icons/Papirus-Dark/symbolic/status/numlock-enabled-symbolic.svg",
				off													= "/usr/share/icons/Papirus-Dark/symbolic/status/numlock-disabled-symbolic.svg"
}

theme.pods_capslock = {
				on														= "/usr/share/icons/Papirus-Dark/symbolic/status/capslock-enabled-symbolic.svg",
				off													= "/usr/share/icons/Papirus-Dark/symbolic/status/capslock-disabled-symbolic.svg"
}

theme.wifidisc						= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-disconnected-symbolic.svg"
theme.wifinone						= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-signal-none-symbolic.svg"
theme.wifilow							= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-signal-weak-symbolic.svg"
theme.wifimed							= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-signal-ok-symbolic.svg"
theme.wifihigh						= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-signal-good-symbolic.svg"
theme.wififull						= "/usr/share/icons/Papirus-Dark/symbolic/status/network-wireless-signal-excellent-symbolic.svg"

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Icons for the Global Menu
--]]---------------------------------------------------------------------

theme.globalShutdown				= "/usr/share/icons/Papirus-Dark/symbolic/actions/system-shutdown-symbolic.svg"
theme.globalReboot						= "/usr/share/icons/Papirus-Dark/symbolic/actions/system-reboot-symbolic.svg"
theme.globalSuspend					= "/usr/share/icons/Papirus-Dark/symbolic/actions/system-suspend-symbolic.svg"
theme.globalHibernate			= "/usr/share/icons/Papirus-Dark/symbolic/actions/system-hibernate-symbolic.svg"
theme.globalLock								= "/usr/share/icons/Papirus-Dark/symbolic/actions/system-lock-screen-symbolic.svg"
theme.globalLogout						= "/usr/share/icons/Papirus-Dark/symbolic/actions/application-exit-symbolic.svg"

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Icons for Flags
--]]---------------------------------------------------------------------

theme.caFlag								= "/home/anthony/Pictures/flags/4x3/ca.svg"
theme.usFlag								= "/home/anthony/Pictures/flags/4x3/us.svg"

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																								Look for the Layout List
--]]---------------------------------------------------------------------
--
theme.layoutlist_disable_name																			= true
theme.layoutlist_spacing																								= -6

theme.layoutlist_bg_selected																				= orangeAlt

theme.layoutlist_shape_selected																	= gears.shape.powerline
theme.layoutlist_shape_border_width_selected				= 1

-------------------------------------------------------------------------


--[[---------------------------------------------------------------------
																												Client's Look
--]]---------------------------------------------------------------------

theme.border_width  = 2
theme.useless_gap			= 3

theme.border_normal = bg2
theme.border_focus  = orange

-------------------------------------------------------------------------


return theme

