--credits: heartasians
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local IsLegacy = (TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService)
local ChatRemote = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
local Channel = not IsLegacy and TextChatService.TextChannels.RBXGeneral

local Chat = function(Message)
    if IsLegacy then
        ChatRemote:FireServer(Message, "All")
    else
        Channel:SendAsync(Message)
    end
end

local gen = function(length)
    return " " .. string.rep("ৌ", length)
end

local chats = getgenv().Chats

local function Length(Table)
    local counter = 0 
    for _, v in pairs(Table) do
        counter =counter + 1
    end
    return counter
end

local full = ""
for _, info in chats do
    local msg = info[1]:gsub("⬛","✕✕"):gsub("✅","⬛")
    local length = info[2]
    full = full .. msg
    if _ ~= #chats then
        full = full .. gen(length)
    end
end
Chat(full)
