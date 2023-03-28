-- AwesomeWm Dependencies
local awful	= require 'awful'
local hotkeys_popup = require 'awful.hotkeys_popup'

-- Awesomewm Style Handle
local theme	= require 'beautiful'

-- 
local xbind									= require 'xbindkeys'
local freedesktop			= require 'freedesktop'


--[[-----------------------------------------------------------------
																								Awesomewm Main Menu
--]]-----------------------------------------------------------------

local awesomeMenu = {
   { "hotkeys",					function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
			{ "Terminal",				terminal },
   { "manual",						terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart",					awesome.restart },
}

---------------------------------------------------------------------


--[[-----------------------------------------------------------------
																				 Session and Power Control Menu
--]]-----------------------------------------------------------------

-- Wrapper functions
local function logout()					awesome.quit()																						end
local function lock()							os.execute "loginctl lock-session"		end
local function poweroff()			os.execute "loginctl poweroff"						end
local function reboot()					os.execute "loginctl reboot"								end
local function suspend()				os.execute "loginctl suspend"							end
local function hibernate()		os.execute "loginctl hibernate"					end

-- Entries for the submenu
local powerMenu = {
				{ "Shutdown",			poweroff,			theme.globalShutdown				},
				{ "Reboot",					reboot,					theme.globalReboot						},
				{ "---------------------------" },
				{ "Suspend",				suspend,				theme.globalSuspend					},
				{ "Hibernate",		hibernate,		theme.globalHibernate			},
				{ "---------------------------" },
				{ "Lock",							lock,							theme.globalLock								},
				{ "Logout",					logout,					theme.globalLogout						}
}

---------------------------------------------------------------------


--[[-----------------------------------------------------------------
																								Tag Switching Submenu
--]]-----------------------------------------------------------------

local screenMenu = setmetatable({}, { __index=table })

-- List all Screens
for s in screen do
				local tagMenu = setmetatable({}, { __index=table })

				-- List all Tags for each Screen
				for _, t in pairs(s.tags) do
								local function switch() t:view_only() end
								tagMenu:insert { "Tag : " .. t.name, switch }
				end

				screenMenu:insert(s.index, { "Screen #" .. s.index, tagMenu })
end

---------------------------------------------------------------------


--[[-----------------------------------------------------------------
																				   Layout Switching Submenu
--]]-----------------------------------------------------------------

local layoutMenu = setmetatable({}, { __index=table })

-- List enabled layout and generate each button
for _, layout in ipairs(awful.layout.layouts) do
				local layoutName = layout.name
				local iconName = "layout_" .. layoutName
				local function select() awful.layout.set(layout) end

				layoutMenu:insert { layoutName,	select,	theme[iconName] }
end

---------------------------------------------------------------------

local mainEntries = {
				{ "Tags",							screenMenu  },
				{ "Layouts",				layoutMenu  },
				{ "Session",				powerMenu 		},
				{ "Awesome",				awesomeMenu }
}


local globalMenu = freedesktop.menu.build { sub_menu='Applications', after=mainEntries }

globalMenu:add { "Close", function() globalMenu:hide() end, }
globalMenu:add { "---------------------------" }

xbind.add("Mod4+b:3", function() globalMenu:toggle() end)

