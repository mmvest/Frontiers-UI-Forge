local ffi = require("ffi")
local Util = require("frontiers_forge.util")

-- Define player_offset
local player_offset = 0x1FBBA0C

-- Define Player functions
local Player = {}

function Player.GetName()
    local name_addr = ffi.cast("char*", Util.EEmem() + player_offset + 0x04)
    return ffi.string(name_addr)
end

function Player.GetLevel()
    return Util.ReadFromOffset(player_offset + 0x24, "uint32_t")
end

function Player.GetExp()
    return Util.ReadFromOffset(player_offset + 0x28, "uint32_t")
end

function Player.GetTotalStr()
    return Util.ReadFromOffset(player_offset + 0x64, "uint32_t")
end

function Player.GetTotalSta()
    return Util.ReadFromOffset(player_offset + 0x68, "uint32_t")
end

function Player.GetTotalAgi()
    return Util.ReadFromOffset(player_offset + 0x6C, "uint32_t")
end

function Player.GetTotalDex()
    return Util.ReadFromOffset(player_offset + 0x70, "uint32_t")
end

function Player.GetTotalWis()
    return Util.ReadFromOffset(player_offset + 0x74, "uint32_t")
end

function Player.GetTotalInt()
    return Util.ReadFromOffset(player_offset + 0x78, "uint32_t")
end

function Player.GetTotalCha()
    return Util.ReadFromOffset(player_offset + 0x7C, "uint32_t")
end

function Player.GetBaseStr()
    return Util.ReadFromOffset(player_offset + 0xD8, "uint32_t")
end

function Player.GetBaseSta()
    return Util.ReadFromOffset(player_offset + 0xDC, "uint32_t")
end

function Player.GetBaseAgi()
    return Util.ReadFromOffset(player_offset + 0xE0, "uint32_t")
end

function Player.GetBaseDex()
    return Util.ReadFromOffset(player_offset + 0xE4, "uint32_t")
end

function Player.GetBaseWis()
    return Util.ReadFromOffset(player_offset + 0xE8, "uint32_t")
end

function Player.GetBaseInt()
    return Util.ReadFromOffset(player_offset + 0xEC, "uint32_t")
end

function Player.GetBaseCha()
    return Util.ReadFromOffset(player_offset + 0xF0, "uint32_t")
end

function Player.GetCurrentHp()
    return Util.ReadFromOffset(player_offset + 0x80, "uint32_t")
end

function Player.GetMaxHp()
    return Util.ReadFromOffset(player_offset + 0x84, "uint32_t")
end

function Player.GetBaseHp()
    return Util.ReadFromOffset(player_offset + 0xF8, "uint32_t")
end

function Player.GetCurrentPwr()
    return Util.ReadFromOffset(player_offset + 0x88, "uint32_t")
end

function Player.GetMaxPwr()
    return Util.ReadFromOffset(player_offset + 0x8C, "uint32_t")
end

function Player.GetBasePwr()
    return Util.ReadFromOffset(player_offset + 0x100, "uint32_t")
end

function Player.GetAc()
    return Util.ReadFromOffset(player_offset + 0x9C, "uint32_t")
end

function Player.GetCoordinates()
    local coordinate_address = Util.EEmem() + 0x1FB65B0
    local float_ptr = ffi.cast("float*", coordinate_address)

    local x = float_ptr[0]
    local y = float_ptr[1]
    local z = float_ptr[2]

    return { x = x, y = y, z = z }
end

function Player.GetTargetEntityId()
    local current_target_offset = 0x1FBB870
    return Util.ReadFromOffset(current_target_offset, "uint32_t")
end

return Player
