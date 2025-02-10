local Util = require("frontiers_forge.util")
local AbilityList = require("frontiers_forge.ability_list")
local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
        uint8_t unknown_00[0x04];   // byte 0 - 3
        uint32_t ability_icon_ref;  // byte 4 - 7
        uint8_t unknown_01[0x10];   // byte 8 - 23
        uint32_t source_ref;        // byte 24 - 27     Ability List? this is a guess as of right now 
        uint32_t source_index;      // byte 28 - 31     1-based (not 0-based) index into ability list
    } AbilityBarSlot; 
]]

local AbilityBarSlot = {}
AbilityBarSlot.__index = AbilityBarSlot

function AbilityBarSlot.new(address)
    if type(address) == "number" then
        address = ffi.cast("AbilityBarSlot*", address)
    elseif not ffi.istype("AbilityBarSlot*", address) then
        error("Invalid pointer type for AbilityBarSlot")
    end

    local self = setmetatable({}, AbilityBarSlot)
    self.ptr = address  -- Store the FFI pointer
    return self
end

function AbilityBarSlot:GetAbilityIndex()
    return self.ptr.source_index - 1 -- the index is 1 based when the list is 0 based, so adjust it to be correct
end

function AbilityBarSlot:GetAbility()
    local ability_index = self:GetAbilityIndex()
    if ability_index >= 0 then
        return AbilityList.GetAbilityByIndex(ability_index)
    end
    return nil
end

function AbilityBarSlot:GetIconRef()
    return self.ptr.ability_icon_ref
end

local AbilityBar = {}
AbilityBar.__index = AbilityBar
AbilityBar.num_abilities = 5
AbilityBar.slot_size = 0x20         -- 32 bytes
AbilityBar.size = 0xA0              -- 160 bytes
AbilityBar.base_offset = 0x1E93550
AbilityBar.base_address = Util.EEmem() + AbilityBar.base_offset


function AbilityBar.GetAbilitySlot(bar_index, slot_index)
    if bar_index < 0 or bar_index > 1 then
        error("Invalid bar index: " .. tostring(bar_index))
    end

    if slot_index < 0 or slot_index >= AbilityBar.num_abilities then
        error("Invalid slot index: " .. tostring(slot_index))
    end

    local bar_address = AbilityBar.base_address + (AbilityBar.size * bar_index)
    local slot_address = bar_address + (AbilityBar.slot_size * slot_index)

    return AbilityBarSlot.new(slot_address)
end

function AbilityBar.GetAbility(bar_index, slot_index)
    -- Hmm maybe there is a way to generalize these checks so that I can pull them into their own function
    if bar_index < 0 or bar_index > 1 then
        error("Invalid bar index: " .. tostring(bar_index))
    end

    if slot_index < 0 or slot_index >= AbilityBar.num_abilities then
        error("Invalid slot index: " .. tostring(slot_index))
    end

    return AbilityBar.GetAbilitySlot(bar_index, slot_index):GetAbility()
end


return AbilityBar