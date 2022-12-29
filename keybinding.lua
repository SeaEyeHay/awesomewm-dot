local awful = require "awful"
local lain  = require "lain"
local gears = require "gears"

local var = require "variables"


local hotkeys_popup = require("awful.hotkeys_popup").widget
local my_table						= awful.util.table or gears.table -- 4.{0,1} compatibility
local volume        = lain.widget.pulse()

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type


-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({ var.modkey }, "p", function() os.execute("flameshot gui") end,
              {description = "take a screenshot", group = "hotkeys"}),

    -- X screen locker
    awful.key({ var.modkey, var.altkey }, "l", function () os.execute(var.scrlocker) end,
              {description = "lock screen", group = "hotkeys"}),

    -- Hotkeys
    awful.key({ var.modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ var.modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ var.modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ var.modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ var.altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ var.altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ var.altkey, var.modkey    }, "j",
        function ()
            awful.client.focus.byidx( -1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ var.altkey, var.modkey     }, "k",
        function ()
            awful.client.focus.byidx(1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ var.modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ var.modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ var.modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ var.modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    awful.key({ var.modkey,           }, "a", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ var.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ var.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( 1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ var.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ var.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ var.modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ var.modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ var.modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),

    -- On the fly useless gaps change
    awful.key({ var.altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ var.altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ var.modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ var.modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ var.modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ var.modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ var.modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ var.modkey,           }, "Return", function () awful.spawn(var.terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ var.modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ var.modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ var.altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ var.altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ var.modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ var.modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ var.modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ var.modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ var.modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ var.modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ var.modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    -- awful.key({ var.modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
    --           {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    --[[
    awful.key({ var.altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ var.altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ var.altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),
    --]]

    -- Brightness
    awful.key({ var.modkey, "Ctrl" }, "u", function () os.execute(". $HOME/.config/awesome/scripts/bash/brightness +") end,
              {description = "Brightness +10%", group = "hotkeys"}),
    awful.key({ var.modkey, "Ctrl" }, "d", function () os.execute(". $HOME/.config/awesome/scripts/bash/brightness -") end,
              {description = "Brightness -10%", group = "hotkeys"}),

    -- PulseAudio volume control
    awful.key({ var.modkey, var.altkey }, "Up",
        function ()
            os.execute(string.format("pactl set-sink-volume %s +1%%", volume.device))
            volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "Down",
        function ()
            os.execute(string.format("pactl set-sink-volume %s -1%%", volume.device))
            volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "m",
        function ()
            os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
            volume.update()
        end,
        {description = "volume mute toggle", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "1",
        function ()
            os.execute(string.format("pactl set-sink-volume %s 100%%", volume.device))
            volume.update()
        end,
        {description = "volume 100%", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "0",
        function ()
            os.execute(string.format("pactl set-sink-volume %s 0%%", volume.device))
            volume.update()
        end,
        {description = "volume 0%", group = "hotkeys"}),

    -- playerctl audio prev/next/play-pause (used currently with Spotify)
    awful.key({ var.modkey, var.altkey }, "Left",
        function ()
            os.execute("playerctl previous")
        end,
        {description = "player previous", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "Right",
        function ()
            os.execute("playerctl next")
        end,
        {description = "player next", group = "hotkeys"}),
    awful.key({ var.modkey, var.altkey }, "p",
        function ()
            os.execute("playerctl play-pause")
        end,
        {description = "player play-pause", group = "hotkeys"}),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ var.modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ var.modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    -- User programs
    --[[
    awful.key({ var.modkey }, "q", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),
    awful.key({ var.modkey }, "a", function () awful.spawn(guieditor) end,
              {description = "run gui editor", group = "launcher"}),
    --]]
    --
    -- Default
    --[[ Menubar
    awful.key({ var.modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
    --[[ dmenu
    awful.key({ var.modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"})
    --]]
    -- alternatively use rofi, a dmenu-like application with more features
    -- check https://github.com/DaveDavenport/rofi for more details
    -- rofi
    awful.key({ var.modkey }, "d", function ()
            os.execute("rofi -show drun -width 95 -show-icons")
        end,
        {description = "show rofi drun", group = "launcher"}),
    awful.key({ var.modkey }, "r", function ()
            os.execute("rofi -show run -width 95")
        end,
        {description = "show rofi run", group = "launcher"}),
    awful.key({ var.modkey }, "w", function ()
            os.execute("rofi -show windowcd -width 95")
        end,
        {description = "show rofi windowcd", group = "launcher"}),
    awful.key({ var.modkey }, "f", function ()
            os.execute("rofi -show window -width 95 -show-icons")
        end,
        {description = "show rofi window", group = "launcher"})
    --[[
    -- Prompt
    awful.key({ var.modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ var.modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = my_table.join(
    awful.key({ var.altkey, var.modkey   }, "i",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    --[[
    awful.key({ var.modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    --]]
    awful.key({ var.modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ var.modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ var.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ var.modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ var.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ var.modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ var.modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only - across screens.
        awful.key({ var.modkey }, "#" .. i + 9,
                  function ()
                    for screen = 1, screen.count() do
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                            awful.tag.viewonly(tag)
                        end
                    end
                  end,
                  descr_view),
        -- Toggle tag display - across screens.
        awful.key({ var.modkey, "Control" }, "#" .. i + 9,
                  function ()
                    for screen = 1, screen.count() do
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ var.modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ var.modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ var.modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ var.modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
