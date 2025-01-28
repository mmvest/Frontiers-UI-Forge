local ffi = require("ffi")
local Util = require("frontiers_forge.util")

ffi.cdef[[
typedef struct {
    wchar_t data[64];       // 128 bytes
    uint32_t type;
    uint32_t unknown_00[3];
    uint32_t is_displayed;
    uint32_t unknown_01;
    uint32_t id;
    uint32_t unused;
} message;

typedef struct 
{
    uint32_t tail_index;
    uint32_t head_index;
    uint32_t unknown[2];
    message messages[32];
} chat_log;
]]

local Chat = {}

local chat_log_offset       = 0x26CDC8
local chat_log_size         = 32        -- 32 messages in chatlog circular buffer
local message_size_bytes    = 160       -- bytes
local max_message_chars     = 64        -- 64 wchar_t characters in a message max
local chat_log = ffi.cast("chat_log*", Util.EEmem() + chat_log_offset)

local function GetTailIndex()
    return chat_log.tail_index;
end

local function GetHeadIndex()
    return chat_log.head_index;
end

local function GetMessageID(index)
    return chat_log.messages[index].id;
end

local function GetMessageDataAsString(index)
    return Util.utf16_to_utf8(chat_log.messages[index].data)
end

local function GetMessageType(index)
    return chat_log.messages[index].type
end

-- Make sure we can increment or decrement an index
-- while handling the wrapping nature of a circular buffer
local function AdjustIndex(index, offset)
    local new_index = (index + offset) % chat_log_size
    if new_index < 0 then new_index = new_index + chat_log_size end
    return new_index
end

Chat.MsgType = {
    Say = 0x3F800000,
    Shout = 0x3E7CFCFD,
    -- Haven't gotten these ones yet
    Party = nil,
    Tell = nil, 
    Guild = nil,
}

function Chat.GetNextMessage()
    -- Get the current head index.
    local head_index = GetHeadIndex()

    -- Go to the previous index since head index points to the next
    -- slot to write over.
    local last_msg_index = AdjustIndex(head_index, -1)

    -- Grab the message ID
    local last_msg_id = GetMessageID(last_msg_index)

    local temp_msg_index = last_msg_index
    local temp_msg_id = last_msg_id


    -- While the messages contain the same ID, keep going backward
    -- This is so we can find the start of the full message
    while last_msg_id == temp_msg_id do
        temp_msg_index = AdjustIndex(temp_msg_index, -1)
        temp_msg_id = GetMessageID(temp_msg_index)
    end
    
    -- Temp message index contains the index of the first message struct
    -- that is not part of the current message, so add 1 to account for
    -- this so we are on the starting message struct of the current message.
    last_msg_index = AdjustIndex(temp_msg_index, 1)
    local msg_type = GetMessageType(last_msg_index)

    -- Concatenate all content
    local msg_contents = ""
    while last_msg_index ~= head_index do
        msg_contents = msg_contents .. GetMessageDataAsString(last_msg_index)
        last_msg_index = AdjustIndex(last_msg_index, 1)
    end
    
    -- return string and type
    return msg_contents, msg_type

end

function Chat.GetMessageTypeString(msg_type)
    if msg_type == Chat.MsgType.Shout   then return "Shout" end
    if msg_type == Chat.MsgType.Say     then return "Say"   end
    if msg_type == Chat.MsgType.Party   then return "Party" end
    if msg_type == Chat.MsgType.Tell    then return "Tell"  end
    if msg_type == Chat.MsgType.Guild   then return "Guild" end
    return "Unknown Message Type"
end

return Chat