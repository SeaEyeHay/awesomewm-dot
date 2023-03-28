-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Awesome dependencies
local awful	= require 'awful'
local wibox = require 'wibox'
local gears = require 'gears'
local lain		= require 'lain'

-- Local dependencies
local theme					= require 'beautiful'
local MyTagList = require 'ui.taglist'
local pods						= require 'ui.pods'


---------------------------------------------------------------------------

local function make_layout_switcher(scrn)
				return awful.widget.layoutlist {
								screen = scrn,

								widget_template = {
												widget		= wibox.container.background,
												id						= 'background_role',
												{
																widget		= wibox.container.margin,
																top					= 2,
																bottom		= 2,
																left				= 12,
																right			= 12,
																{
																				widget		= wibox.widget.imagebox,
																				id						= 'icon_role'
																}
												}
								}
				}
end

---------------------------------------------------------------------------


local _M = {}

function _M.make_top(scrn)
				scrn.top = awful.wibar { screen=scrn, position='top', height=24 }

				--[[-----------------------------------
												Full Layout of the Wibar
				--]]-----------------------------------
				scrn.top:setup {
								layout		= wibox.container.background,
								bg						= theme.bar_bg,
								{
												layout		= wibox.container.margin,
												bottom		= 2,
												{
																layout		= wibox.container.background,
																bg						= theme.bg_normal,

																{
																				layout		= wibox.container.margin,
																				left				= 10,
																				right			= 10,
																				top					= 1,
																				bottom		= 1,

																				--[[--------------------------------------------
																																Contents of the Top Bar
																				--]]--------------------------------------------
																				{
																								layout		= wibox.layout.stack,
																								{
																												layout		= wibox.layout.align.horizontal,
																												pods.make_left(),
																												nil,
																												pods.make_right()
																								},
																								{
																												layout		= wibox.container.place,
																												halign		= 'center',
																												pods.make_center(),
																								}
																				}
																				------------------------------------------------
																}
												}
								}
				}

end

function _M.make_bottom(scrn)
				scrn.bottom = awful.wibar { screen=scrn, position='bottom', height=24 }

				local taglist = MyTagList:make_list(scrn)
				local layoutlist = make_layout_switcher(scrn)

				--[[-----------------------------------
												Full Layout of the Wibar
				--]]-----------------------------------
				scrn.bottom:setup {
								layout		= wibox.container.background,
								bg						= theme.bar_bg,
								{
												layout		= wibox.container.margin,
												top					= 2,
												{
																layout		= wibox.container.background,
																bg						= theme.bg_normal,

																--[[--------------------------------------------
																								  Contents of the Bottom Bar
																--]]--------------------------------------------
																{
																				layout		= wibox.layout.align.horizontal,
																				nil,
																				{
																								layout		= wibox.container.margin,
																								left				= 120,
																								right			= 200,
																								top					= 1,
																								bottom		= 1,

																								taglist,
																				},
																				{
																								widget		= wibox.container.background,
																								shape			= function(cr, w, h) gears.shape.rectangular_tag(cr, w, h, -h/2) end,
																								bg						= theme.bar_bg,
																								{
																												layout		= wibox.container.margin,
																												left				= 12,
																												right			= 12,
																												top					= 2,
																												bottom		= 2,

																												layoutlist,
																								}
																				}
																}
																------------------------------------------------
												}
								}
				}
end

function _M.make_tags(scrn)
				awful.tag( {'Q', 'W', 'E', 'R'}, scrn, awful.layout.suit.tile )
end


function _M.set_clients(client, context, hints)
				client.shape = function(cr, w, h) gears.shape.octogon(cr, w, h, 6) end
			 if not awesome.startup then awful.client.setslave(client) end

    if awesome.startup and not client.size_hints.user_position and not client.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(client)
    end
end

function _M.set_titlebar(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise=true })
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise=true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size=16 }) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end

function _M.set_wallpaper(s)
    -- Wallpaper
    if theme.wallpaper then
        local wallpaper = theme.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

function _M.handle_fullscreen(c)
				if c.fullscreen then
								c.shape = gears.shape.rectangle
				else
								c.shape = function(cr, w, h) gears.shape.octogon(cr, w, h, 6) end
				end
end


return _M

