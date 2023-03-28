-- Awesomewm Dependencies
local awful = require 'awful'
local wibox	= require 'wibox'
local gears = require 'gears'

-- Awesomewm Theme Handler
local theme	= require 'beautiful'

-- 
local xbind	= require 'xbindkeys'


--[[-------------------------------------------------------
																								Configuration
--]]-------------------------------------------------------

local lockKeys = { num=1, caps=2 }

local HOME = os.getenv 'HOME'

-- User Configuration for modifier keys
local modmap				= HOME .. "/.xmodmaprc"

-- Available keyboard layout
local kbLayouts = {
				{ flag=theme.caFlag, layout='ca', variant='fr' },
				{ flag=theme.usFlag, layout='us' }
}

-- 
local template = {
				widget		= wibox.container.margin,
				top					= 2,
				bottom		= 2,
				{
								layout		= wibox.layout.fixed.horizontal,
								spacing	= 4,
								{
												layout		= wibox.layout.fixed.horizontal,
												{
																widget		= wibox.widget.imagebox,
																image			= theme.pods_keyboard,
																id						= 'icon'
												},
												awful.widget.keyboardlayout(),
								},
								{
												widget		= wibox.container.margin,
												top					= 3,
												bottom		= 2,
												{
																layout		= wibox.layout.fixed.horizontal,
																spacing	= 4,
																{
																				widget		= wibox.widget.imagebox,
																				image			= theme.pods_numlock.off,
																				id						= 'numlock'
																},
																{
																				widget		= wibox.widget.imagebox,
																				image			= theme.pods_capslock.off,
																				id						= 'capslock'
																}
												}
								},
				}
}

-----------------------------------------------------------


--[[-------------------------------------------------------
																								  Processing
--]]-------------------------------------------------------

-- Menu's buttons for selecting a layout
local entries = setmetatable( {}, { __index=table } )

-- Generate command for selecting layout
for _, layout in ipairs(kbLayouts) do
				local cmd = "setxkbmap -layout " .. layout.layout
				if layout.variant ~= nil then cmd = cmd .. " -variant " .. layout.variant end

				layout.cmd = function()
								os.execute(cmd)
								os.execute("xmodmap " .. modmap)								-- Restore the modifiers keys setting
				end

				-- Add the command the the Menu
				local name = layout.layout
				if layout.variant ~= nil then name = name .. "(" .. layout.variant .. ")" end

				entries:insert { name, layout.cmd, layout.flag }
end

-----------------------------------------------------------


--[[-------------------------------------------------------
																								  XORG API
--]]-------------------------------------------------------

-- Check if the Lock keys are currently 'on' or 'off'
local function check_status()
				local handle = io.popen("xset q | awk '/(Caps Lock|Num Lock)/ {print $4; print $8}'", 'r')
				if handle == nil then error "Could not check the status of 'Lock' keys" end

				local caps, num = handle:read(), handle:read()

				handle:close()
				return caps, num
end

-----------------------------------------------------------

-- Keep track of keys' status
local caps, num = check_status()

-- Remember the current layout
local state = 0

local newIndicator		= wibox.widget(template)
local newMenu							= awful.menu { items=entries }


-- Add buttons
newIndicator:get_children_by_id('icon')[1]:connect_signal('button::press', function(_, _, _, button)
				if button == 1 then
								state = (state + 1) % (#kbLayouts)						-- Iterate over available layouts
								kbLayouts[state + 1].cmd()
				elseif button == 3 then
								newMenu:toggle()
				end
end)


-- Update keylocks Indicators
local numlock			= newIndicator:get_children_by_id('numlock')[1]
local capslock		= newIndicator:get_children_by_id('capslock')[1]

-- Set icon for startup state
numlock.image			= theme.pods_numlock[num]
capslock.image		= theme.pods_capslock[caps]

-----------------------------------------------------------


--[[-------------------------------------------------------
																				   Global Callback
--]]-------------------------------------------------------

local function signal_numlock_change()
				if num == 'on' then num = 'off' else num = 'on' end					-- Invert the state of Num
				numlock.image = theme.pods_numlock[num]
end

local function signal_capslock_change()
				if caps == 'on' then caps = 'off' else caps = 'on' end		-- Invert the state of Caps
				capslock.image = theme.pods_capslock[caps]
end

xbind.add("Mod2+Caps_Lock", signal_capslock_change)
xbind.add("Mod2+Num_Lock",		signal_numlock_change)

-----------------------------------------------------------


--[[-------------------------------------------------------
																								  Module
--]]-------------------------------------------------------

local _M = { widget=newIndicator }

function _M.force_update()
				caps, num = check_status()

				numlock.image			= theme.pods_numlock[num]
				capslock.image		= theme.pods_capslock[caps]
end


return _M

-----------------------------------------------------------

