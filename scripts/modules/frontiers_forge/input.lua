local ffi = require("ffi")
local Util = require("frontiers_forge.util")

-- Controller 01
local Controller_01 =
{
    button_bitfield_ptr  = ffi.cast("uint16_t*", Util.EEmem() + 0x4F3AC2),
    right_analog_ptr    = ffi.cast("uint8_t*",  Util.EEmem() + 0x4F3AC4),
    left_analog_ptr     = ffi.cast("uint8_t*",  Util.EEmem() + 0x4F3AC6)
}

-- TODO: Add controller 02

local Input = {}

Input.button_mask =
{
    square      = 0x8000,
    x           = 0x4000,
    circle      = 0x2000,
    triangle    = 0x1000,

    r1          = 0x0800,
    l1          = 0x0400,
    r2          = 0x0200,
    l2          = 0x0100,

    dpad_up     = 0x0080,
    dpad_right  = 0x0040,
    dpad_down   = 0x0020,
    dpad_left   = 0x0010,

    start       = 0x0008,
    r3          = 0x0004,
    l3          = 0x0002,
    select      = 0x0001
}



function Input.IsButtonPressed(button_mask)
    return Util.IsBitZero(Controller_01.button_bitfield_ptr[0], button_mask)
end

--  7f 7f = analog stick not moving, 7f 00 for pushing up, 7F FF for down, 00 7F for left, FF 7F for right
function Input.GetRawAnalogStickState()
    local analog_stick_state =
    {
        right_x = Controller_01.right_analog_ptr[0],
        right_y = Controller_01.right_analog_ptr[1],
        left_x = Controller_01.left_analog_ptr[0],
        left_y = Controller_01.left_analog_ptr[1]
    }

    return analog_stick_state
end

function Input.GetNormalizedAnalogStickState()
    local raw_state = Input.GetRawAnalogStickState()
    local normalized_state = {}
    for key, value in pairs(raw_state) do
        -- Normalize the raw values between -1 and 1. Doing this "ternary" check to fix some rounding errors so that
        -- the numbers are from -1 to 1, instead of going slightly under or over the min/max
        normalized_state[key] = (value - (value <= 0x7F and 0x7F or 0x80)) / 0x7F

    end

    return normalized_state
end


return Input