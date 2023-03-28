local wibox = require 'wibox'
local awful = require 'awful'
local gears = require 'gears'

local freedesktop = require 'freedesktop'

local theme = require 'beautiful'



--[[-----------------------------------------------------------------------
																												My Custom TagList Widget
--]]-----------------------------------------------------------------------

local MyTagList = {
				--[[---------------------------------------
												Widget Hierarchy of the TagList
				--]]---------------------------------------
				tag = {
								widget		= wibox.container.background,
								shape			= gears.shape.hexagon,
								id						= 'background',
								{
												layout		= wibox.layout.align.horizontal,
												id						= 'tasks',
												{
																widget		= wibox.container.background,
																shape			= gears.shape.hexagon,
																id						= 'btnBackground',
																{
																				widget		= wibox.container.margin,
																				left				= 20,
																				right			= 20,
																				{
																								widget		= wibox.widget.textbox,
																								id						= 'tagName',
																				}
																}
												},
												nil,
												{
																widget		= wibox.container.background,
																shape			= gears.shape.powerline,
																id						= 'prompt',
																{
																				widget		= wibox.container.margin,
																				left				= 13,
																				right			= 10,
																				{
																								widget		= wibox.widget.textbox,
																								markup		= "<b>+</b>"
																				}
																}
												}
								}
				},
				-------------------------------------------


				--[[---------------------------------------
											Widget Hierarchy of the TaskList
				--]]---------------------------------------
				task = {
								style = {
												shape			= gears.shape.powerline,
								},

								layout = {
												layout		= wibox.layout.fixed.horizontal,
												spacing	= -6,
								},

								widget_template = {
												widget		= wibox.container.background,
												id						= 'background_role',
												{
																layout		= wibox.container.margin,
																right			= 12,
																left				= 14,
																top					= 2,
																bottom		= 2,
																{
																				widget		= wibox.widget.imagebox,
																				id						= "icon_role",
																}
												},
								}
				},
				-------------------------------------------
}


function MyTagList:make_task(args)
				local tasklist = awful.widget.tasklist {
								screen		= args.screen,
								filter		= awful.widget.tasklist.filter.alltags,
								source		= function() return args.tag:clients() end,

								--[[----------------------------------
																				Mouse's Controles
								--]]----------------------------------
								buttons	= gears.table.join(
            awful.button({ }, 1, function (c)
																if c == client.focus then c.minimized = true
                else
																				if not args.tag.selected then args.tag:view_only() end
																				c:emit_signal("request::activate", "tasklist", { raise=true })
                end
            end),
												awful.button({ }, 2, function(c)
																if c.minimized then
																				c.minimized = false
																				c:swap(client.focus)
																				client.focus.minimized = true
																else
																				c:swap(client.focus)
																end
												end),
												awful.button({ }, 3, function()
                awful.menu.client_list({ theme={ width=250 } })
            end),
            awful.button({ }, 4, function ()
																awful.client.focus.byidx(1)
            end),
            awful.button({ }, 5, function ()
																awful.client.focus.byidx(-1)
            end)
								),
								--------------------------------------

								layout										= self.task.layout,
								widget_template	= self.task.widget_template,
								style = {
												shape							= self.task.style.shape,
												bg_focus				= theme.mytags[args.tag.name].highlight
								},
				}

				return tasklist
end


function MyTagList:make_tag(args)
				-- Build the Base Widget and its Hierachy 
				local newTagBtn = wibox.widget(self.tag)

				-- Widgets to be Modified
				local background				= newTagBtn:get_children_by_id('background')[1]
				local btnBackground	= newTagBtn:get_children_by_id('btnBackground')[1]
				local tagName							= newTagBtn:get_children_by_id('tagName')[1]
				local tasks									= newTagBtn:get_children_by_id('tasks')[1]
				local prompt								= newTagBtn:get_children_by_id('prompt')[1]

				-- Mouse controles for the tags
				btnBackground:connect_signal('button::press', function(_, _, _, mouse)
								if						mouse == 1 then args.tag:view_only()												-- Left-click to select single tag
								elseif		mouse == 3 then awful.tag.viewtoggle(args.tag)		-- Right-click to select multiple tags
								end
				end)

				local launcher = freedesktop.menu.build { tag=args.tag }
				launcher:add { "Close", function() launcher:hide() end }
				launcher:add { "-------------------------------------" }

				-- Mouse controles for the prompt
				prompt:connect_signal('button::press', function(_, _, _, mouse)
								if mouse == 1 then launcher:toggle() end
				end)

				-- Updating the Button Style According to the State
				local function update(tag)
								if tag.selected then
												-- Tasklist's background
												background.bg							=	args.style.bgfocus
												background.fg							= args.style.fgfocus
												-- Tag selector button
												btnBackground.bg				= args.style.highlight
												btnBackground.fg				= args.style.fgfocus
												-- Prompt Menu Button
												prompt.bg											= args.style.highlight
												prompt.fg											= args.style.fgfocus
								else
												-- Tasklist's background
												background.bg							=	args.style.bgnormal
												background.fg							= args.style.fgnormal
												-- Tag selector button
												btnBackground.bg				= args.style.bghigh
												btnBackground.fg				= args.style.fghigh
												-- Prompt Menu Button
												prompt.bg											= args.style.bghigh
												prompt.fg											= args.style.fghigh
								end
				end

				args.tag:connect_signal('property::selected', update)
				args.tag:connect_signal('cleared', update)

				-- Set default state for the widget
				update(args.tag)
				tagName.markup = ("<b>" .. args.tag.name .. "</b>")

				-- Build and insert the tasklist
				tasks.second = ( MyTagList:make_task(args) )


				return newTagBtn
end

function MyTagList:make_list(scrn)
				-- List container for the tags
				local layout =  wibox.widget {
								layout		= wibox.layout.flex.horizontal,
								spacing	= 12
				}

				-- Build button for each tags of the screen
				for _, tag in ipairs(scrn.tags) do
								local style = setmetatable({}, { __index=gears.table })
								if theme.mytags ~= nil then
												style:crush(theme.mytags.default)
												style:crush(theme.mytags[tag.name])
								end

								layout:add( MyTagList:make_tag {screen=scrn, tag=tag, style=style} )
				end


				return layout
end

---------------------------------------------------------------------------


return MyTagList

