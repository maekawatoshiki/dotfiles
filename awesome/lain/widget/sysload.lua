
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013,      Luke Bonham                
      * (c) 2010-2012, Peter Hofmann              
                                                  
--]]

local helpers      = require("lain.helpers")
local wibox        = require("wibox")
local io           = { open = io.open }
local string       = { match  = string.match }
local setmetatable = setmetatable

-- System load
-- lain.widget.sysload
local sysload = {}

local function factory(args)
    local args     = args or {}
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    sysload.widget = wibox.widget.textbox()

    function sysload.update()
        local f = io.open("/proc/loadavg")
        local ret = f:read("*all")
        f:close()

        load_1, load_5, load_15 = string.match(ret, "([^%s]+) ([^%s]+) ([^%s]+)")

        widget = sysload.widget
        settings()
    end

    helpers.newtimer("sysload", timeout, sysload.update)

    return sysload
end

return setmetatable(sysload, { __call = function(_, ...) return factory(...) end })
