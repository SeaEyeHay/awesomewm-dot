-- Awesomewm Dependencies
local wibox	= require 'wibox'
local gears	= require 'gears'

-- Awesomewm Theme Handler
local theme	= require 'beautiful'


--[[-----------------------------------------------------------------
																												DBUS Wrapper
--]]-----------------------------------------------------------------

local lgi							= require 'lgi'
local Gio							= lgi.Gio
local Variant			= lgi.GLib.Variant

-- Connection Manager root object
local Manager = setmetatable({}, {
				__index = Gio.DBusProxy.new_for_bus_sync(
								Gio.BusType.SYSTEM,									-- Bus
								Gio.DBusProxyFlags.NONE,				-- Flags
								nil,																								-- Interface's Info
								"net.connman",														-- Bus's name
								"/",																								-- Object's Path
								"net.connman.Manager"	 					-- Interface
				)
})

---------------------------------------------------------------------

local _M = { Ctrl={}, Speed={} }



return _M

