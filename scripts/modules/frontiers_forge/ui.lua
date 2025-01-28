local Util = require("frontiers_forge.util")

local offsets = {
    health_bar          = 0x01E13DDC,
    power_bar           = 0x01E13E60,
    main_exp_bar        = 0x01E14044,
    secondary_exp_bar   = 0x01E14018,
    compass_face        = 0x01E13D20,
    compass_back        = 0x01E13D5C,
    target_nameplate    = 0x01E1416C,
    active_effects      = 0x0026904C,
    ability_bar         = 0x0027315C,
    chat_window         = 0x01DF5B5C
}

local UI = {}

local eqoa_mips_opcodes = eqoa_mips_opcodes or {NOP = 0x00000000}

local function NopInstruction(offset)
    local original_opcode = Util.ReadFromOffset(offset, "uint32_t")
    eqoa_mips_opcodes[offset] = original_opcode

    Util.WriteToOffset(offset, "uint32_t", eqoa_mips_opcodes.NOP)
end

local function RestoreInstruction(offset)
    Util.WriteToOffset(offset, "uint32_t", eqoa_mips_opcodes[offset])
end

local function DisableFlag(offset)
    Util.WriteToOffset(offset, "uint8_t", 0)
end

local function EnableFlag(offset)
    Util.WriteToOffset(offset, "uint8_t", 1)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                                Health Bar                                 ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisableHealthBar()
    NopInstruction(offsets.health_bar)
end

function UI.EnableHealthBar()
    RestoreInstruction(offsets.health_bar)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                                Power Bar                                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisablePowerBar()
    NopInstruction(offsets.power_bar)
end

function UI.EnablePowerBar()
    RestoreInstruction(offsets.power_bar)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                              Experience Bars                              ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisableMainExpBar()
    NopInstruction(offsets.main_exp_bar)
end

function UI.EnableMainExpBar()
    RestoreInstruction(offsets.main_exp_bar)
end

function UI.DisableSecondaryExpBar()
    NopInstruction(offsets.secondary_exp_bar)
end

function UI.EnableSecondaryExpBar()
    RestoreInstruction(offsets.secondary_exp_bar)
end

function UI.DisableExperienceBars()
    UI.DisableMainExpBar()
    UI.DisableSecondaryExpBar()
end

function UI.EnableExperienceBars()
    UI.EnableMainExpBar()
    UI.EnableSecondaryExpBar()
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                                 Compass                                   ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
function UI.DisableCompass()
    NopInstruction(offsets.compass_face)
    NopInstruction(offsets.compass_back)
end

function UI.EnableCompass()
    RestoreInstruction(offsets.compass_face)
    RestoreInstruction(offsets.compass_back)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                             Target Nameplate                              ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
function UI.DisableTargetNameplate()
    NopInstruction(offsets.target_nameplate)
end

function UI.EnableTargetNameplate()
    RestoreInstruction(offsets.target_nameplate)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                              Active Effects                               ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisableActiveEffectsDisplay()
    DisableFlag(offsets.active_effects)
end

function UI.EnableActiveEffectsDisplay()
    EnableFlag(offsets.active_effects)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                               Ability Bar                                 ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisableAbilityBar()
    DisableFlag(offsets.ability_bar)
end

function UI.EnableAbilityBar()
    EnableFlag(offsets.ability_bar)
end

-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                               Chat Window                                 ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

function UI.DisableChatWindow()
    NopInstruction(offsets.chat_window)
end

function UI.EnableChatWindow()
    RestoreInstruction(offsets.chat_window)
end

function UI.DisableUI()
    UI.DisableHealthBar()
    UI.DisablePowerBar()
    UI.DisableExperienceBars()
    UI.DisableCompass()
    UI.DisableTargetNameplate()
    UI.DisableActiveEffectsDisplay()
    UI.DisableAbilityBar()
    UI.DisableChatWindow()
end

function UI.EnableUI()
    UI.EnableHealthBar()
    UI.EnablePowerBar()
    UI.EnableExperienceBars()
    UI.EnableCompass()
    UI.EnableTargetNameplate()
    UI.EnableActiveEffectsDisplay()
    UI.EnableAbilityBar()
    UI.EnableChatWindow()
end

return UI