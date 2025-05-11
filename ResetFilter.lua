--[[
 __   __   ______     _____     ______     __     ______   ______   ______    
/\ \ / /  /\  __ \   /\  __-.  /\  == \   /\ \   /\  ___\ /\__  _\ /\  ___\   
\ \ \'/   \ \  __ \  \ \ \/\ \ \ \  __<   \ \ \  \ \  __\ \/_/\ \/ \ \___  \  
 \ \__|    \ \_\ \_\  \ \____-  \ \_\ \_\  \ \_\  \ \_\      \ \_\  \/\_____\ 
  \/_/      \/_/\/_/   \/____/   \/_/ /_/   \/_/   \/_/       \/_/   \/_____/ 
Original by: heartasians
Modified by vqmpjay

[+] Added More Executor Support
[+] Added new method for Legacy Chat and new method for Modern Chat
[+] Added trigger via function

]]

-- // Recommended Settings //
local CONFIG = {
    FILTER_RESET_COUNT = 15,
    FILTER_RESET_DELAY = 0.05,
    RANDOM_STRING_LENGTH = 5
}

local TCS = game:GetService("TextChatService")
local RStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local isLegacy = TCS.ChatVersion == Enum.ChatVersion.LegacyChatService

local ChatBar
if isLegacy then
    ChatBar = PlayerGui:FindFirstChild("Chat"):FindFirstChild("ChatBar", true)
else
    ChatBar = CoreGui:FindFirstChild("TextBoxContainer", true)
end

if not ChatBar then
    error("Could not find ChatBar")
end

ChatBar = ChatBar:FindFirstChild("TextBox") or ChatBar

local function GenerateRandomString(length)
    local chars = {}
    for i = 97, 122 do chars[#chars + 1] = string.char(i) end
    for i = 65, 90 do chars[#chars + 1] = string.char(i) end
    
    local str = ""
    for i = 1, length do
        str = str .. chars[math.random(#chars)]
    end
    return str
end

local function SendChat(Message)
    if isLegacy then
        local ChatRemote = RStorage:FindFirstChild("SayMessageRequest", true)
        if ChatRemote then
            ChatRemote:FireServer(Message, "All")
        else
            error("Could not find SayMessageRequest remote")
        end
    else
        local Channel = TCS.TextChannels:FindFirstChild("RBXGeneral")
        if Channel then
            Channel:SendAsync(Message)
        else
            error("Could not find RBXGeneral channel")
        end
    end
end

local function FakeChat(Message)
    if isLegacy then
        Players:Chat(Message)
    else
        return
    end
end

local function SetupSystemMessageRemoval()
    if not isLegacy then
        task.spawn(function()
            local function findChatContainer()
                local paths = {
                    function() return CoreGui:FindFirstChild("ExperienceChat", true) end,
                    function() 
                        local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
                        if playerGui then
                            return playerGui:FindFirstChild("Chat", true)
                        end
                        return nil
                    end
                }
                
                for _, pathFunc in ipairs(paths) do
                    local result = pathFunc()
                    if result then return result end
                end
                
                return nil
            end
            
            local chatContainer = findChatContainer()
            if not chatContainer then
                return
            end
            
            local messageList
            for _, v in pairs(chatContainer:GetDescendants()) do
                if (v.Name == "RCTScrollContentView" or v.Name == "MessageLogDisplay" or v.Name == "List") and 
                   (v:IsA("Frame") or v:IsA("ScrollingFrame")) then
                    messageList = v
                    break
                end
            end
            
            if not messageList then
                return
            end
            
            local function isEmoteSystemMessage(message)
                for _, descendant in pairs(message:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        local text = descendant.Text
                        if text and (
                            text:find("You do not own that emote") or
                            text:find("Emote not found") or
                            text:find("emote")
                        ) then
                            return true
                        end
                    end
                end
                
                return false
            end
            
            local checkedMessages = {}
            
            local function processAllMessages()
                for _, message in pairs(messageList:GetChildren()) do
                    if not checkedMessages[message] then
                        checkedMessages[message] = true
                        
                        if isEmoteSystemMessage(message) then
                            message.Visible = false
                            message.Size = UDim2.new(0, 0, 0, 0)
                            
                            for _, child in pairs(message:GetDescendants()) do
                                if child:IsA("GuiObject") then
                                    child.Visible = false
                                end
                            end
                        end
                    end
                end
            end
            
            processAllMessages()
            
            local connection = messageList.ChildAdded:Connect(function(message)
                task.wait(0.1)
                
                if not checkedMessages[message] then
                    checkedMessages[message] = true
                    
                    if isEmoteSystemMessage(message) then
                        message.Visible = false
                        message.Size = UDim2.new(0, 0, 0, 0)
                        
                        for _, child in pairs(message:GetDescendants()) do
                            if child:IsA("GuiObject") then
                                child.Visible = false
                            end
                        end
                    end
                end
            end)
            
            task.delay(CONFIG.FILTER_RESET_COUNT * CONFIG.FILTER_RESET_DELAY + 5, function()
                connection:Disconnect()
            end)
            
            for i = 1, 10 do
                task.delay(i * 0.5, processAllMessages)
            end
        end)
    end
end

local function ResetFilter()
    if isLegacy then
        for i = 1, 10 do
            local guid = GenerateRandomString(30)
            local filler = "bipas momen"
            local reset = guid .. " " .. filler
            
            task.spawn(function()
                task.wait(0.01 * i)
                FakeChat(reset)
            end)
        end
    else
        SetupSystemMessageRemoval()
        
        for i = 1, CONFIG.FILTER_RESET_COUNT do
            task.spawn(function()
                task.wait(CONFIG.FILTER_RESET_DELAY * i)
                
                local randomEmote = GenerateRandomString(CONFIG.RANDOM_STRING_LENGTH)
                local emoteCommand = "/e " .. randomEmote
                
                SendChat(emoteCommand)
            end)
        end
    end
    
    return true
end

local function ProcessMessage(message)
    if message and message ~= "" then
        local words = {}
        for word in message:gmatch("%S+") do
            table.insert(words, word)
        end
        
        for i, word in ipairs(words) do
            SendChat(word)
            ResetFilter()
            task.wait(CONFIG.FILTER_RESET_COUNT * CONFIG.FILTER_RESET_DELAY + 0.1)
        end
    end
end

local bypassEnabled = true
local bypassKey = Enum.KeyCode.RightShift

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == bypassKey and not gameProcessed then
        bypassEnabled = not bypassEnabled
        local status = bypassEnabled and "enabled" or "disabled"
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Chat Bypass",
            Text = "Bypass " .. status,
            Duration = 2
        })
    end
end)

local function runScript()
    local Connection = Instance.new("BindableFunction")
    
    for _, c in pairs(getconnections(ChatBar.FocusLost)) do
        c:Disconnect()
    end
    
    ChatBar.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local message = ChatBar.Text
            ChatBar.Text = ""
            
            if bypassEnabled then
                Connection:Invoke(message)
            else
                SendChat(message)
            end
        end
    end)
    
    Connection.OnInvoke = ProcessMessage
end

local success, err = pcall(runScript)

if not success then
    local function runScriptWithoutDisconnect()
        local Connection = Instance.new("BindableFunction")
        
        ChatBar.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local message = ChatBar.Text
                ChatBar.Text = ""
                
                if bypassEnabled then
                    Connection:Invoke(message)
                else
                    SendChat(message)
                end
            end
        end)
        
        Connection.OnInvoke = ProcessMessage
    end
    
    pcall(runScriptWithoutDisconnect)
end

getgenv().ResetFilter = ResetFilter
getgenv().SendChat = SendChat

return {
    ResetFilter = ResetFilter,
    SendChat = SendChat
}
