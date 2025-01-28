local Util = require("frontiers_forge.util")

local AbilityBar = {}

local num_actions = { [0] = 5, [1] = 5, [2] = 4}

function AbilityBar.GetCurrentActionBarIndex()
    local selected_action_bar_index_offset = 0x268954
    return Util.ReadFromOffset(selected_action_bar_index_offset, "uint32_t")
end

function AbilityBar.GetAction(action_bar_index, action_index)
    -- There are only 3 actions bars -- make sure index respects that restraint
    if action_bar_index < 0 or action_bar_index > 2 then return nil end

    -- The first two action bars have 5 slots, the last one has 4. Make sure action index respects that restraint
    if action_index > 4 or action_index < 0 then return nil end
    if action_index > 3 and action_bar_index == 2 then return nil end

    local action_size_bytes = 0x20      -- 32 bytes
    local action_bar_size_bytes = 0xA0  -- 160 bytes, except for bar 3, which is 128 bytes due to only having 4 slots
    local action_bar_offset = 0x1E93550 + action_bar_index * action_bar_size_bytes
    local action_offset = action_bar_offset + action_bar_index * action_size_bytes
    if action_bar_index == 2 then
        -- action bar 3 logic specifically -- the struct is a bit different as it manages equipment/items rather than spells
        local amount = Util.ReadFromOffset(action_offset + 0x10, "uint32_t")
        local inventory_index = Util.ReadFromOffset(action_offset + 0x1C, "uint32_t")
        return {amount = amount, inventory_index = inventory_index}
    end

    local action_icon_id = Util.ReadFromOffset(action_offset + 0x04, "uint32_t")
    local ability_book_index = Util.ReadFromOffset(action_offset + 0x1C, "uint32_t") - 1 -- For some reason, the index is stored 1-based here so we need to get it to be 0 based hence the -1
    return {action_icon_id = action_icon_id, ability_book_index = ability_book_index}
end

function AbilityBar.GetActionsFromActionBar(action_bar_index)
    local num_actions = num_actions[action_bar_index]
    local actions = {}
    for idx = 0, num_actions - 1 do
        actions[idx] = AbilityBar.GetAction(action_bar_index, idx)
    end
    return actions
end

function AbilityBar.GetActionsFromCurrentActionBar()
    return AbilityBar.GetActionsFromActionBar(AbilityBar.GetCurrentActionBarIndex())
end

function AbilityBar.GetSelectedActionFromActionBar(action_bar_index)
end

function AbilityBar.GetActionsFromAllActionBars()
end



function AbilityBar.GetCurrentlySelectedActionIndex()
end

function AbilityBar.GetCurrentlySelectedAction()
end



return AbilityBar