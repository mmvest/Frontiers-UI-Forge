local ffi = require("ffi")
local Util = require("frontiers_forge.util")

local EntityList = {}

local entity_list_offset = 0x1FB6C30
local entities = ffi.cast("uint32_t*", Util.EEmem() + entity_list_offset)
local min_entity_list_idx = 0  -- 0th index is always the player
local max_entity_list_idx = 23 -- 24 total entities, including the player

function EntityList.GetEntityByIndex(index)
    if index < min_entity_list_idx or index > max_entity_list_idx then
        error("Index out of bounds: Entity list index must be between " ..min_entity_list_idx.. " and " ..max_entity_list_idx)
    end

    -- Entity ID
    local id = Util.ReadFromOffset(entities[index] + 0x0C, "uint32_t")
    local percent_hp = Util.ReadFromOffset(entities[index] + 0x19, "uint8_t") / 0xFF

    -- Entity Coordinates
    local coordinate_addr = Util.EEmem() + entities[index] + 0x40
    local float_ptr = ffi.cast("float*", coordinate_addr)

    local x = float_ptr[0]
    local y = float_ptr[1]
    local z = float_ptr[2]

    -- Entity Name
    local name_addr = Util.EEmem() + entities[index] + 0x58
    local name_ptr = ffi.cast("char*", name_addr)
    local name = ffi.string(name_ptr)

    -- Entity Level
    local level = Util.ReadFromOffset(entities[index] + 0x70, "uint8_t")

    -- Target of entity
    local target_id = Util.ReadFromOffset(entities[index] + 0x74, "uint8_t")

    return { id = id, percent_hp = percent_hp, x = x, y = y, z = z, name = name, level = level, target_id = target_id}
end

function EntityList.GetEntityById(target_id)
    for index = min_entity_list_idx, max_entity_list_idx do
        local entity = EntityList.GetEntityByIndex(index)
        if entity.id == target_id then
            return entity
        end
    end
    return nil
end

function EntityList.GetAllEntitiesWithName(target_name)
    local named_entities = {}

    for index = min_entity_list_idx, max_entity_list_idx do
        local entity = EntityList.GetEntityByIndex(index)
        if entity.name == target_name then
            table.insert( named_entities, entity)
        end
    end

    if #named_entities == 0 then
        return nil
    end

    return named_entities
end

function EntityList.GetFirstEntityWithName(target_name)

    for index = min_entity_list_idx, max_entity_list_idx do
        local entity = EntityList.GetEntityByIndex(index)
        if entity.name == target_name then
            return entity
        end
    end

    return nil
end

function EntityList.GetAllEntities()
    local all_entities = {}

    for index = min_entity_list_idx, max_entity_list_idx do
        local entity = EntityList.GetEntityByIndex(index)

        table.insert( all_entities, entity )
    end

    return all_entities
end

return EntityList