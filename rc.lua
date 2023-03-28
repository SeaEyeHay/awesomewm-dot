-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local awful = require 'awful'
require 'awful.autofocus'

-- Notification library
local naughty = require 'naughty'

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require 'awful.hotkeys_popup.keys'

-- Theme Handler
local theme = require 'beautiful'


--[[---------------------------------------------------------------------------
																												     Error handling
--]]---------------------------------------------------------------------------

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
																												  Variables Definition
--]]---------------------------------------------------------------------------

require 'var'

-------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
																								     KeyBindings Definition
--]]---------------------------------------------------------------------------

require 'keys'

-------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
																																Rules Definition
--]]---------------------------------------------------------------------------

require 'rules'

-------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
																																User Interface
--]]---------------------------------------------------------------------------

local ui				= require 'ui'

awful.screen.connect_for_each_screen(function (scrn)
				ui.set_wallpaper(scrn)
				ui.make_tags(scrn)
				ui.make_bottom(scrn)
				ui.make_top(scrn)
end)

client.connect_signal("request::titlebars", function(c) ui.set_titlebar(c) end)
client.connect_signal("manage", function(c) ui.set_clients(c) end)

client.connect_signal("unfocus", function(c) c.border_color = theme.border_normal end)
client.connect_signal("focus", function(c)
				local color = theme.mytags[c.first_tag.name].highlight
				c.border_color = color
end)

client.connect_signal('property::fullscreen', ui.handle_fullscreen)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-------------------------------------------------------------------------------


awesome.connect_signal('startup', function()
				require 'widget.global-menu'
				require 'startup'
end)

