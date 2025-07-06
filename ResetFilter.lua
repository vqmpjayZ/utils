--[[
    __   __   ______     _____     ______     __     ______   ______   ______    
   /\ \ / /  /\  __ \   /\  __-.  /\  == \   /\ \   /\  ___\ /\__  _\ /\  ___\   
   \ \ \'/   \ \  __ \  \ \ \/\ \ \ \  __<   \ \ \  \ \  __\ \/_/\ \/ \ \___  \   
    \ \__|    \ \_\ \_\  \ \____-  \ \_\ \_\  \ \_\  \ \_\      \ \_\  \/\_____\   
     \/_/      \/_/\/_/   \/____/   \/_/ /_/   \/_/   \/_/       \/_/   \/_____/ 

Original: heartasians
Modified by vqmpjay
[+] Re-worked EVERYTHING and fixed both Legacy and Modern Chat methods
[+] Fixed FPS dropping and forced "You do not own that emote" not to show
[+] Added trigger via function (getgenv) 
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local chatBar = CoreGui:FindFirstChildWhichIsA("TextBox", true)
local sayMessageRequest = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
local isLegacy = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
local emoteErr = '<font color="#f74b52">You do not own that emote.</font>'
local lastRun = 0

local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
local function randStr(len)
	local str = ""
	for i = 1, len do
		local idx = math.random(1, #chars)
		str = str .. chars:sub(idx, idx)
	end
	return str
end

task.spawn(function()
	while true do
		for _, obj in ipairs(CoreGui:GetDescendants()) do
			if obj:IsA("TextLabel") and obj.Text == emoteErr then
				local msg = obj:FindFirstAncestor("TextMessage")
				if msg then msg:Destroy() end
			end
		end
		RunService.RenderStepped:Wait()
	end
end)

local function ResetFilter()
	if isLegacy then
		for i = 1, 10 do
			task.delay(0.01 * i, function()
				local msg = randStr(15) .. " bipas"
				pcall(function() Players:Chat(msg) end)
			end)
		end
	else
		for i = 1, 4 do
			task.delay(0.25 * i, function()
				if sayMessageRequest then
					local garbage = randStr(math.random(5, 10))
					sayMessageRequest:FireServer("/e " .. garbage, "All")
				end
			end)
		end
	end
end

chatBar:GetPropertyChangedSignal("Text"):Connect(function()
	if not chatBar:IsFocused() and tick() - lastRun > 20 then
		lastRun = tick()
		local input = chatBar.Text
		chatBar.Text = ""
		if input ~= "" then
			ResetFilter()
		end
	end
end)

getgenv().ResetFilter = ResetFilter
return ResetFilter
