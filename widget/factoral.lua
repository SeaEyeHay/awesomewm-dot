-- AwesomeWm's modules
local awful					= require 'awful'
local wibox 				= require 'wibox'
local gears 				= require 'gears'
local naughty			= require 'naughty'

-- Style
---@require 'theme'
local theme = require 'beautiful'

-- OOP
local obj			= require 'classic'


--[[------------------------------------------------------------
																								  DataStructure
--]]------------------------------------------------------------

local Discrete = obj:extend()

function Discrete:new(path)
				self.ls					= setmetatable({ }, { __index=table })
				self.index		= { }
				self.path			= path

				self:reload()
end

function Discrete:reload()
				local file = io.open(self.path, 'r')
				if file == nil then return end

				for factor, order in string.gmatch(file:read('a'), "(0%.%d+);(%d+)%s+") do
								factor, order = tonumber(factor), tonumber(order)

								self.ls[order]						= factor
								self.index[factor]		= order
				end


				file:close()
end

function Discrete:save()
				local file = io.open(self.path, 'w')
				if file == nil then return end

				for order, factor in self:iter() do
								local line = tostring(factor) .. ";" .. tostring(order) .. "\n"
								file:write(line)
				end


				file:close()
end


function Discrete:insert(factor)
				-- MUST be unique
				if self.index[factor] ~= nil then return end

				self.ls:insert(factor)
				self.ls:sort()

				self.index = { }
				for i, v in ipairs(self.ls) do
								self.index[v] = i
				end


				self:save()
end

function Discrete:remove(factor)
				local i = self.index[factor]

				self.ls:remove(i)
				self.index[factor] = nil


				self:save()
end


function Discrete:next(factor)
				local i = self.index[factor]
				return self.ls[i + 1] or factor
end

function Discrete:prev(factor)
				local i = self.index[factor]
				return self.ls[i - 1] or factor
end

function Discrete:find_closest(factor)
				for i, v in ipairs(self.ls) do
								if v > factor then
												return self.ls[i - 1], v
								end
				end
end

function Discrete:iter()
				return ipairs(self.ls)
end

--------------------------------------------------------------

local _M = {}

-- Factors for each layout
for _, layout in pairs(awful.layout.layouts) do
				local file = ConfDir .. "/cache/" .. layout.name .. "-factors.csv"
				_M[layout.name] = Discrete(file)
end


-- 
function _M.show_listing(layout, get)
				-- Shortcut
				if type(layout) == 'string' then layout = _M[layout] end

				local items = setmetatable({ }, { __index=table })
				items:insert { "Close", function() --[[Do Nothing]] end, theme.factorIcon.close }
				items:insert { "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"																																	}

				for _, f in layout:iter() do
								items:insert { string.format("%.8f", f),
																				   function() layout:remove(f) end,
																			    theme.factorIcon.remove }
				end

				items:insert { "Empty",
																   function() layout:insert( get() ) end,
															    theme.factorIcon.add }


				local menu = awful.menu(items)
				menu:show()
end


-- 
_M.Widget = {
				layout		= wibox.layout.fixed.horizontal,
				spacing	= 3,
				{
								widget		= wibox.widget.imagebox,
								id						= 'icon',
				},
				{
								widget		= wibox.widget.textbox,
								id						= 'factor',
				}
}

function _M.Widget:make(img, get)
				local newWidget = wibox.widget(self)

				local factor				= newWidget:get_children_by_id('factor')[1]
				local icon						= newWidget:get_children_by_id('icon')[1]

				-- Current layout
				local layout
				newWidget:connect_signal('button::press', function(_, _, _, btn)
								if btn == 1 then
												_M.show_listing(layout.name, function()
																local newFactor, _ = get()
																return newFactor
												end)
								end
				end)

				-- Update the factor
				local function update()
								local newFactor
								newFactor, layout = get()
								factor.markup = string.format("%.2f", newFactor)
				end

				-- vertical or horizontal factor's icon
				icon.image = theme.factorIcon[img]

				-- Display the current factor
				update()

				return newWidget, update
end


return _M

