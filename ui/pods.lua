-- Awesomewm Dependencies
local awful = require 'awful'
local gears = require 'gears'
local wibox = require 'wibox'

local lain  = require 'lain'

-- User-made Widgets
local weatherWidget = require 'awesome-wm-widgets.weather-widget.weather'
local todoWidget				= require 'awesome-wm-widgets.todo-widget.todo'
local fsWidget						= require 'awesome-wm-widgets.fs-widget.fs-widget'

-- My widget
local wifi						= require 'widget.wirelessStatus'
local kblayout		= require 'widget.keyboard'


-- Theme Handler
local theme = require 'beautiful'


--[[-------------------------------------------------------
																				Groupes of Widgets
--]]-------------------------------------------------------

local pod = {
				widget		= wibox.container.background,
				shape			= gears.shape.hexagon,
				bg						= theme.bghigh,
				id						= 'background',
				{
								widget		= wibox.container.margin,
								left				= 20,
								right			= 20,
								{
												layout		= wibox.layout.fixed.horizontal,
												spacing	= 17,
												id						= 'content',

												spacing_widget = {
																widget						= wibox.widget.separator,
																orientation	= 'vertical',
																thickness			= 1,
																span_ratio		= 0.8,
																color							= theme.fgnormal,
												}
								}
				}
}

function pod:make(args)
				-- Build the scafolding
				local newPod  = wibox.widget(self)
				local content = newPod:get_children_by_id('content')[1]

				newPod:get_children_by_id('background')[1].forced_width = args.forced

				-- Add the list of items for the Pod
				for _, item in ipairs(args.items) do
								content:add(item)
				end


				return newPod
end


--[[-------------------------------------------------------
																  Keyboard Layouts Switcher
--]]-------------------------------------------------------


-----------------------------------------------------------


local _M = {}

function _M.make_right()
				local calendar = wibox.widget {
								layout		= wibox.layout.fixed.horizontal,
								spacing = 5,
								{
												widget		= wibox.container.margin,
												top					= 2,
												bottom		= 2,
												{
																widget		= wibox.widget.imagebox,
																image			= theme.pods_calendar,
												}
								},
								{
												widget		= wibox.widget.textclock,
												format		= '%a %b %d %Y'
								}
				}

				local clock = wibox.widget {
								layout		= wibox.layout.fixed.horizontal,
								spacing = 3,
								{
												widget		= wibox.widget.imagebox,
												image			= theme.pods_clock,
								},
								{
												widget		= wibox.widget.textclock,
												format		= '%H:%M'
								}
				}

				local tray = wibox.widget {
								widget		= wibox.container.margin,
								top					= 2,
								bottom		= 2,
								wibox.widget.systray(false)
				}

				local weather = weatherWidget {
								api_key = 'dc15509b64353dc71c79d5f0a4935f5b',
								coordinates = { 46.8123, -71.2127 }
				}

				return pod:make { items={ weather, clock, calendar, todoWidget(), tray, }, }
end

function _M.make_center()
				local fsIndic = fsWidget { mounts={ "/", "/home" } }

				return pod:make { items={ fsIndic } }
end

function _M.make_left()
				-----------------------------------------------------------------
				volume = lain.widget.pulse {
				    settings = function()
				        local vlevel =  (volume_now.left + volume_now.right)/2 .. "%"
												if volume_now.muted == "yes" then vlevel = "muted" end
				        widget:set_markup(lain.util.markup(theme.fghigh, vlevel))
				    end
				}

				local layoutVolume = wibox.widget {
								layout		= wibox.layout.fixed.horizontal,
								spacing	= 3,
								{
												widget		= wibox.widget.imagebox,
												image			= theme.pods_volume
								},
								volume.widget,
				}

				volume.widget:buttons(awful.util.table.join(
								awful.button({}, 1, function() -- left click
    				    awful.spawn("pavucontrol")
    				end),
    				awful.button({}, 2, function() -- middle click
    				    os.execute(string.format("pactl set-sink-volume %s 100%%", volume.device))
    				    volume.update()
    				end),
    				awful.button({}, 3, function() -- right click
    				    os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
    				    volume.update()
    				end),
    				awful.button({}, 4, function() -- scroll up
    				    os.execute(string.format("pactl set-sink-volume %s +1%%", volume.device))
    				    volume.update()
    				end),
    				awful.button({}, 5, function() -- scroll down
    				    os.execute(string.format("pactl set-sink-volume %s -1%%", volume.device))
    				    volume.update()
    				end)
				))

				-----------------------------------------------------------------

				local wifiStatus = wifi {
								notification_preset = { fg=theme.fg_normal },
    				timeout = 10,

								widget = wibox.widget {
												widget		= wibox.container.margin,
												top					= 2,
												bottom		= 2,
												{
																layout		= wibox.layout.fixed.horizontal,
																spacing	= 5,
																{
																				widget		= wibox.widget.imagebox,
																				image			= theme.wifidisc,
																				id						= 'symbol'
																},
																{
																				widget		= wibox.widget.textbox,
																				markup		= "WIFI",
																				id						= 'interface'
																},
												}
								},

    				settings = function(self)
												local symbol				= self.widget:get_children_by_id('symbol')[1]
												local interface	= self.widget:get_children_by_id('interface')[1]

												interface.markup = self.perc .. ".0%"

    				    if self.status == "1" or self.status == "" then
    				        symbol:set_image(theme.wifidisc)
    				    else
    				        if self.perc <= 5 then
    				            symbol:set_image(theme.wifinone)
    				        elseif self.perc <= 25 then
    				            symbol:set_image(theme.wifilow)
    				        elseif self.perc <= 50 then
    				            symbol:set_image(theme.wifimed)
    				        elseif self.perc <= 75 then
    				            symbol:set_image(theme.wifihigh)
    				        else
    				            symbol:set_image(theme.wififull)
    				        end
    				    end
    				end,
				}

				QuickEsc:insert(function() kblayout.force_update() end)

				return pod:make { items={ layoutVolume, wifiStatus.widget, kblayout.widget } }
end

function _M.make_test()
				local testWidget = wibox.widget {
								widget		= wibox.widget.textbox,
								markup		= "<b>It's a message</b>"
				}

				return pod:make { items={ testWidget } }
end


return _M

