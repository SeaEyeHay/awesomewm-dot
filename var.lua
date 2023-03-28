local awful = require 'awful'
local gears = require 'gears'
local lain  = require 'lain'

local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers.
beautiful.init( gears.filesystem.get_configuration_dir() .. "/theme.lua" )

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
				awful.layout.suit.tile,
				lain.layout.centerwork,
				awful.layout.suit.max,
				awful.layout.suit.floating,
}

-- Functions to run when Esc is hit
QuickEsc = setmetatable({}, { __index=table })

-- Fovorite window factors
WFactor = { }
HFactor = { }

