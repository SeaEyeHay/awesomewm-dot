local awful = require 'awful'
local gears	= require 'gears'
local factoral = require 'widget.factoral'

local logout = require 'awesome-wm-widgets.logout-popup-widget.logout-popup'

local hotkeys_popup = require("awful.hotkeys_popup")


--[[-----------------------------------------------------------------
																												Factor Selector
--]]-----------------------------------------------------------------

local function make_factor_selector(flist)
				local factorIndex = #flist / 2

				return function(incr)
								incr = incr or 0
								factorIndex = factorIndex + incr

								if factorIndex > #flist then
												factorIndex = #flist
								elseif factorIndex < 1 then
												factorIndex = 1
								end


								return flist[factorIndex]
				end
end

---------------------------------------------------------------------


--[[-----------------------------------------------------------------
																												Global Menu Button
--]]-----------------------------------------------------------------

clientbuttons = gears.table.join(
				--awful.button({ modkey }, 2, function() gmenu:toggle() end)
				)

---------------------------------------------------------------------


-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "`", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

				-- Selection
				awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
				awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),


    -- Layout manipulation
    awful.key({ modkey, "Shift"					}, "j", function () awful.client.swap.bydirection('down')    end,
              {description = "swap with the client under", group = "client"}),
    awful.key({ modkey, "Shift"					}, "k", function () awful.client.swap.bydirection('up')    end,
              {description = "swap with the client above", group = "client"}),
    awful.key({ modkey, "Shift"					}, "h", function () awful.client.swap.bydirection('left') end,
              {description = "swap with the client to the left", group = "client"}),
    awful.key({ modkey, "Shift"					}, "l", function () awful.client.swap.bydirection('right') end,
              {description = "swap with the client to the right", group = "client"}),

				-- Size manipulation
				awful.key({ modkey, 'Control'			}, 'h',
												function()
																local tag							= awful.screen.focused().selected_tag
																local factors			= factoral[tag.layout.name]

																local shrunk				= factors:prev(tag.master_width_factor)
																if shrunk == nil then shrunk, _ = factors:find_closest(tag.master_width_factor) end

																tag.master_width_factor = shrunk
												end,
												{description="Shrink the master client width", group='layout'}),
				awful.key({ modkey, 'Control'			}, 'l',
												function()
																local tag							= awful.screen.focused().selected_tag
																local factors			= factoral[tag.layout.name]

																local grown					= factors:next(tag.master_width_factor)
																if grown == nil then _, grown = factors:find_closest(tag.master_width_factor) end

																tag.master_width_factor = grown
												end,
												{description="Grow the master client width", group='layout'}),


				awful.key({ modkey														}, 'a',
								function()
												local tag = awful.screen.focused().selected_tag

												if tag.master_count == 1 then
																tag.master_count = 2
												else
																tag.master_count = 1
												end
								end,
								{ description="Toggle the number of master windows", group='client' }),

    awful.key({ modkey,													}, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "t", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then c:emit_signal("request::activate", "key.unminimize", {raise = true}) end
								end,
        {description = "restore minimized", group = "client"}),
				awful.key({ modkey , 'Shift'  }, 'n',
								function()
												local current			= client.focus
												local restored		= awful.client.restore()

												if restored then
																restored:emit_signal("request::activate", "key.unminimize", {raise = true})
																restored:swap(current)
												end

												current.minimized = true
								end,
								{ description="Swap a minimized client", group='client' }),

    -- Menus
    awful.key({ modkey }, "Return",					function() awful.spawn 'rofi -show drun' end,
              { description="show the menubar", group="launcher"}),
				awful.key({ modkey }, 'BackSpace',		function() logout.launch() end,
												  { description="Show the power control menu", group="launcher" }),

				-- PulseAudio volume control
				awful.key({ }, "XF86AudioRaiseVolume",
				    function ()
				        os.execute(string.format("pactl set-sink-volume %s +5%%", volume.device))
				        volume.update()
				    end),
				awful.key({ }, "XF86AudioLowerVolume",
				    function ()
				        os.execute(string.format("pactl set-sink-volume %s -5%%", volume.device))
				        volume.update()
				    end),
				awful.key({ }, "XF86AudioMute",
				    function ()
				        os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
				        volume.update()
				    end),

				-- Run QuickEsc functions
				awful.key({ modkey }, 'Escape', function () for _, fn in ipairs(QuickEsc) do fn() end			end,
												  { group="other" })
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey            }, "x",			  function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "space",
												  function (c)
																		local master = awful.client.getmaster()
																		if c == master then
																								awful.client.focus.history.previous()
																								c = client.focus
																		end

																		c:swap(master)
														end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the "qwer"
local tagKeys = { 'q', 'w', 'e', 'r' }
for i, key in pairs(tagKeys) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, key,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag", group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, key,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag : " .. key, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag : "..key, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, 'Mod1' }, key,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag : " .. key, group = "tag"})
    )
end


-- Set keys
root.keys(globalkeys)
-- }}}


