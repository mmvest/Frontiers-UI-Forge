local ffi = require("ffi")
local Util = require("frontiers_forge.util")

local Camera = {}

function Camera.GetCoordinates()
    local coordinate_address = Util.EEmem() + 0x1FB66DC
    local float_ptr = ffi.cast("float*", coordinate_address)

    local x = float_ptr[0]
    local y = float_ptr[1]
    local z = float_ptr[2]

    return { x = x, y = y, z = z }
end

function Camera.GetFacingRadians()
    return Util.ReadFromOffset(0x1FB66AC, "float")
end

function Camera.GetFacingDegrees()
    return Util.RadiansToDegrees(Util.GetCompassRadians())
end


return Camera