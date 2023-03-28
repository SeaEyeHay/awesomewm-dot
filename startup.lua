local spawn = require 'awful.spawn'
local once  = spawn.once

---------------------------------------------------------------------------------------

local start
do
    -- Register a new boolean
    awesome.register_xproperty("awesome_restart_check", "boolean")

    -- Check if this boolean is already set
    local restart_detected = awesome.get_xproperty("awesome_restart_check") ~= nil
    -- Set it to true
    awesome.set_xproperty("awesome_restart_check", true)

				-- These commands will be run only at startup
				function start(cmd)
								if not restart_detected then spawn(cmd) end
				end
end

---------------------------------------------------------------------------------------


local HOME = os.getenv 'HOME'
local CONF = os.getenv 'XDG_CONFIG_HOME' or HOME .. '/.config'


---------------------------------------------------------------------------------------


--[[-----------------------------------------------------------------------------------
																								Programmes to be Run Automatically
--]]-----------------------------------------------------------------------------------

spawn { 'xmodmap ', HOME, '/.xmodmaprc' }							-- Configure the modifier keys

start			'udiskie --no-notify --tray'												-- Automatically mount USB drives
start			'blueman-tray'																										-- Start bluetooth in the background
start			'pulseaudio --start -D'

once				'picom'																																	-- Compositor
once				'light-locker'																										-- Lock-Screen

-- Jupyter Notebook Server
once		{
				"jupyter-lab --no-browser --port 9999 --port-retries=0",
}

-- Start a xbindkeys daemon with the generated config
require('xbindkeys').start()

