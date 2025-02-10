local Ability = require("frontiers_forge.ability")
local Util = require("frontiers_forge.util")

local AbilityList  = {}

AbilityList.address = AbilityList.address or (Util.EEmem() + Util.ReadFromOffset(0x1FDB264, "uint32_t") + 0x1D8)
AbilityList.max_num_abilities = 150 -- I don't actually know, so this will suffice for now

function AbilityList.GetAbilityByIndex(index)
    if type(index) ~= "number" or index < 0  or index >= AbilityList.max_num_abilities then
        error("Invalid index: must be a non-negative number between 0 and 149 inclusive")
    end

    local ability_offset = index * Ability.size
    local ability_address = AbilityList.address + ability_offset
    return Ability.new(ability_address)
end

return AbilityList