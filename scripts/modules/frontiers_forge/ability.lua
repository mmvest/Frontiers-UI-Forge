local ffi = require("ffi")
local util = require("frontiers_forge.util")

ffi.cdef[[
    typedef struct {
        uint8_t unknown_00[0x10];       // byte   0 -  15 
        uint32_t id;                    // byte  16 -  19
        uint32_t id_repeat;             // byte  20 -  23
        uint32_t index;                 // byte  24 -  27
        uint8_t unknown_01[0x10];       // byte  28 -  43
        uint32_t level;                 // byte  44 -  47
        float range;                    // byte  48 -  51
        uint32_t cast_time;             // byte  52 -  55
        uint32_t pwr_cost;              // byte  56 -  59
        uint32_t icon_bkgrnd_ref;       // byte  60 -  63
        uint32_t icon_foregrnd_ref;     // byte  64 -  67
        uint32_t scope;                 // byte  68 -  71
        uint32_t cooldown;              // byte  72 -  75
        uint32_t equip_req;             // byte  76 -  79
        wchar_t name[0x02];             // byte  80 -  83   Don't know the actual length of the name
        uint8_t unknown_02[0x7C];       // byte  84 - 207
        wchar_t description[0x02];      // byte 208 - 211   Don't know the actual length of the description
        uint8_t unknown_03[0x104];      // byte 212 - 472
    } Ability; 
]]

local Ability = {}
Ability.__index = Ability

-- Scope Enum
Ability.Scope = {
    SELF = 0,
    TARGET = 1,
    GROUP = 2,
    PET = 3,
    CORPSE = 4,
    UNKNOWN = 5
}

Ability.size = 0x1D8  -- This is my best estimate for now -- hopefully correct

function Ability.new(address)
    if type(address) == "number" then
        address = ffi.cast("Ability*", address)
    elseif not ffi.istype("Ability*", address) then
        error("Invalid pointer type for Ability")
    end

    local self = setmetatable({}, Ability)
    self.ptr = address  -- Store the FFI pointer
    return self
end

function Ability:GetIndex()
    return self.ptr.index
end

function Ability:GetLevel()
    return self.ptr.level
end

function Ability:GetRange()
    return self.ptr.range
end

function Ability:GetCastTime()
    return self.ptr.cast_time
end

function Ability:GetPwrCost()
    return self.ptr.pwr_cost
end

function Ability:GetScope()
    return self.ptr.scope
end

function Ability:GetCooldown()
    return self.ptr.cooldown
end

function Ability:GetEquipRequirements()
    return self.ptr.equip_req
end

function Ability:GetName()
    return util.utf16_to_utf8(self.ptr.name)
end

function Ability:GetDescription()
    return util.utf16_to_utf8(self.ptr.description)
end

return Ability