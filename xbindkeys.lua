local spawn = require 'awful.spawn'


--[[-------------------------------------------------------
																								   State
--]]-------------------------------------------------------

-- Data for generating the config
local bindingsData						= setmetatable({}, { __index=table })
local bindingsLookup				= setmetatable({}, { __index=table })

-- Functions to be called by KeyBindings
XBindKeysCallbacks = {}

-- Register a new PID
local xpropName = "awesome_kblayout_xbindkeys"
awesome.register_xproperty(xpropName, 'number')

-- Infos about the xbindkeys daemon
local pid = awesome.get_xproperty(xpropName)

-- Temporary file holding the Configuration
local filePath = os.tmpname()

-----------------------------------------------------------


--[[-------------------------------------------------------
																				XbindKeys Module
--]]-------------------------------------------------------

local _M = {}


function _M.start()
				-- Only one instance on xbindkeys at a time
				_M.stop()

				-- Configuration for xbindkeys
				do
								-- Generate the Config file
								local bindings						= ""
								XBindKeysCallbacks		= {}
								for i, v in ipairs(bindingsData) do
												XBindKeysCallbacks[i] = v.call
												bindings = bindings .. _M.format(v.bind, i, v.comment)
								end

								-- Write the config to the temporary file
								local file	= io.open(filePath, 'w')
								if file == nil then error "Can't open config file for xbindkeys" end

								file:write(bindings)

								file:close()
				end

				-- Run xbindkeys with the generated config
				pid = spawn("xbindkeys -n -f " .. filePath)
				awesome.set_xproperty(xpropName, pid)
end

function _M.stop()
				if pid == nil then return end
				os.execute("kill " .. pid)
end


function _M.add(binding, callback, comment)
				comment	= comment or binding
				bindingsData:insert { bind=binding, call=callback, comment=comment }
				bindingsLookup[binding] = #binding
end

function _M.remove(bind)
				local index = bindingsLookup:remove(bind)
				return bindingsData:remove(index)
end

function _M.exist(bind)
				local index = bindingsLookup[bind]
				return index ~= nil
end


function _M.format(binding, cmd, comment)
				local commentLine			= "# " .. comment .. "\n"
				local cmdLine							= [["echo 'XBindKeysCallbacks[]] .. cmd .. [[]()' | awesome-client"]]
				local bindLine						= "\n\t" .. binding .. "\n\n"

				return commentLine .. cmdLine .. bindLine
end

-----------------------------------------------------------


return _M

