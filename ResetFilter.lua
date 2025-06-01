--[[
    __   __   ______     _____     ______     __     ______   ______   ______    
   /\ \ / /  /\  __ \   /\  __-.  /\  == \   /\ \   /\  ___\ /\__  _\ /\  ___\   
   \ \ \'/   \ \  __ \  \ \ \/\ \ \ \  __<   \ \ \  \ \  __\ \/_/\ \/ \ \___  \   
    \ \__|    \ \_\ \_\  \ \____-  \ \_\ \_\  \ \_\  \ \_\      \ \_\  \/\_____\   
     \/_/      \/_/\/_/   \/____/   \/_/ /_/   \/_/   \/_/       \/_/   \/_____/ 

Original by: heartasians
Modified by vqmpjay
[+] Added More Executor Support
[+] Added new working method's for Legacy Chat and Modern Chat
[+] Added trigger via function
]]

-- // Recommended Settings //
local CONFIG = {
    FILTER_RESET_COUNT = 15,
    FILTER_RESET_DELAY = 0.05,
    RANDOM_STRING_LENGTH = 5,
    SYSTEM_MESSAGE_CHECK_INTERVAL = 0.1,
    SYSTEM_MESSAGE_TIMEOUT = 3
}

local TCS = game:GetService("TextChatService")
local RStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local isLegacy = TCS.ChatVersion == Enum.ChatVersion.LegacyChatService
local ChatBar
local systemMessageConnection
local lastResetTime = 0

if isLegacy then
    ChatBar = PlayerGui:FindFirstChild("Chat"):FindFirstChild("ChatBar", true)
else
    ChatBar = CoreGui:FindFirstChild("TextBoxContainer", true)
end

if not ChatBar then
    error("Could not find ChatBar")
end

ChatBar = ChatBar:FindFirstChild("TextBox") or ChatBar

local chars = {}
for i = 97, 122 do chars[#chars + 1] = string.char(i) end
for i = 65, 90 do chars[#chars + 1] = string.char(i) end

local function GenerateRandomString(length)
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
    end
end

local hiddenElements = {}

local function hideSystemMessage(element)
    if not hiddenElements[element] then
        element.Visible = false
        hiddenElements[element] = true
        
        local parentFrame = element.Parent
        while parentFrame and not parentFrame:IsA("Frame") and not parentFrame:IsA("ScrollingFrame") do
            parentFrame = parentFrame.Parent
        end
        
        if parentFrame and not hiddenElements[parentFrame] then
            parentFrame.Visible = false
            hiddenElements[parentFrame] = true
        end
    end
end

local function searchAndHideText(parent)
    for _, child in pairs(parent:GetDescendants()) do
        if (child:IsA("TextLabel") or child:IsA("TextButton")) and
            (child.Text:find("You do not own that emote") or
             child.Text:find("Emote not found") or
             child.Text:find("That emote doesn't exist")) then
            hideSystemMessage(child)
        end
    end
end

local function SetupSystemMessageRemoval()
    if not isLegacy then
        if systemMessageConnection then
            systemMessageConnection:Disconnect()
        end
        
        hiddenElements = {}
        
        local success, coreGui = pcall(function()
            return game:GetService("CoreGui")
        end)
        
        if not success then
            coreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end
        
        local startTime = tick()
        local lastCheck = 0
        
        systemMessageConnection = RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            
            if currentTime - lastCheck >= CONFIG.SYSTEM_MESSAGE_CHECK_INTERVAL then
                searchAndHideText(coreGui)
                lastCheck = currentTime
            end
            
            if currentTime - startTime >= CONFIG.SYSTEM_MESSAGE_TIMEOUT then
                systemMessageConnection:Disconnect()
                systemMessageConnection = nil
            end
        end)
    end
end

local function ResetFilter()
    local currentTime = tick()
    if currentTime - lastResetTime < 0.5 then
        return true
    end
    lastResetTime = currentTime
    
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
        SendChat(message)
        ResetFilter()
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
