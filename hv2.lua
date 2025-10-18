local HttpService = game:GetService("HttpService")--2
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local loggedRequests = {}
local isKicking = false
local targetURL = ""

local function kickUser(msg)
    if isKicking then return end
    isKicking = true
    task.spawn(function()
        LocalPlayer:Kick(msg or "Access denied")
    end)
end

local function logRequest(url)
    if type(url) ~= "string" or #url < 15 then return end
    if url == targetURL or url:find(targetURL, 1, true) then
        loggedRequests[url] = true
    end
end

local function isLoggedContent(text)
    if type(text) ~= "string" or #text < 15 then return false end
    local lowerText = text:lower()
    for request in pairs(loggedRequests) do
        if lowerText:find(request:lower(), 1, true) then
            return true
        end
    end
    return false
end

local function destroyMaliciousGUI(obj)
    task.spawn(function()
        local root = obj
        local tries = 0
        
        while root and root.Parent ~= CoreGui and root.Parent ~= game and tries < 10 do
            root = root.Parent
            tries = tries + 1
        end
        
        if root and root:IsA("Instance") then
            pcall(function() root:Destroy() end)
        elseif obj and obj:IsA("Instance") then
            pcall(function() obj:Destroy() end)
        end
        
        if obj and obj.Parent and obj.Parent:IsA("Instance") then
            pcall(function() obj.Parent:Destroy() end)
        end
        
        kickUser("Display error")
    end)
end

local function protectClipboard()
    if _G.__CLIPBOARD_PROTECTED then return end
    _G.__CLIPBOARD_PROTECTED = true
    
    local funcs = {"setclipboard", "toclipboard", "set_clipboard"}
    for _, funcName in ipairs(funcs) do
        pcall(function()
            if getgenv and getgenv()[funcName] then
                local original = getgenv()[funcName]
                getgenv()[funcName] = function(content)
                    if isLoggedContent(content) then
                        kickUser("Unexpected error")
                        return
                    end
                    return original(content)
                end
            end
        end)
    end
end

local function protectFileSystem()
    if _G.__FILE_PROTECTED then return end
    _G.__FILE_PROTECTED = true
    
    local fileFuncs = {"writefile", "appendfile"}
    for _, funcName in ipairs(fileFuncs) do
        pcall(function()
            if getgenv and getgenv()[funcName] then
                local original = getgenv()[funcName]
                getgenv()[funcName] = function(path, content)
                    if isLoggedContent(path) or (content and isLoggedContent(content)) then
                        kickUser("Security violation")
                        return
                    end
                    return original(path, content)
                end
            end
        end)
    end
end

local function protectConsole()
    if _G.__CONSOLE_PROTECTED then return end
    _G.__CONSOLE_PROTECTED = true
    
    local origPrint = print
    print = function(...)
        local args = {...}
        for _, arg in ipairs(args) do
            if isLoggedContent(tostring(arg)) then
                kickUser("Runtime error")
                return
            end
        end
        return origPrint(...)
    end
    
    local origWarn = warn
    warn = function(...)
        local args = {...}
        for _, arg in ipairs(args) do
            if isLoggedContent(tostring(arg)) then
                kickUser("Runtime error")
                return
            end
        end
        return origWarn(...)
    end
    
    _G.print = print
    _G.warn = warn
    if getgenv then
        getgenv().print = print
        getgenv().warn = warn
    end
end

local function checkTextElement(obj)
    if not obj or not obj:IsA("Instance") then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel")) then
        return
    end
    
    local function checkText()
        if not obj or not obj:IsA("Instance") or not obj.Parent then return false end
        local text = obj.Text
        if text and isLoggedContent(text) then
            destroyMaliciousGUI(obj)
            return true
        end
        return false
    end
    
    if checkText() then return end
    
    local connection
    pcall(function()
        connection = obj:GetPropertyChangedSignal("Text"):Connect(function()
            if checkText() and connection then
                connection:Disconnect()
            end
        end)
    end)
end

local function scanGUI(root)
    if not root or not root:IsA("Instance") then return end
    
    pcall(function()
        for _, descendant in ipairs(root:GetDescendants()) do
            task.spawn(function()
                checkTextElement(descendant)
            end)
        end
    end)
    
    pcall(function()
        root.DescendantAdded:Connect(function(obj)
            task.spawn(function()
                checkTextElement(obj)
            end)
        end)
    end)
end

local function protectGUI()
    if _G.__GUI_PROTECTED then return end
    _G.__GUI_PROTECTED = true
    
    task.spawn(function()
        for _, child in ipairs(CoreGui:GetChildren()) do
            scanGUI(child)
        end
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, child in ipairs(playerGui:GetChildren()) do
                scanGUI(child)
            end
        end
    end)
    
    CoreGui.ChildAdded:Connect(function(child)
        task.spawn(function()
            task.wait(0.5)
            scanGUI(child)
        end)
    end)
    
    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                for _, obj in ipairs(CoreGui:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel") then
                        if obj.Text and isLoggedContent(obj.Text) then
                            destroyMaliciousGUI(obj)
                        end
                    end
                end
            end)
        end
    end)
end

local function getHWID()
    local service = game:GetService("RbxAnalyticsService")
    if type(service) ~= "userdata" or type(service.GetClientId) ~= "function" then
        return nil
    end
    
    local results = {}
    for i = 1, 5 do
        local success, hwid = pcall(function()
            return service:GetClientId()
        end)
        if success and hwid then
            table.insert(results, hwid)
        end
        task.wait(0.05)
    end
    
    if #results < 3 then return nil end
    
    for i = 2, #results do
        if results[i] ~= results[1] then
            return nil
        end
    end
    
    return results[1]
end

local function getWhitelist(url)
    targetURL = url
    logRequest(url)
    
    for attempt = 1, 3 do
        local success, response = pcall(function()
            return game:HttpGet(url .. "?v=" .. os.time())
        end)
        
        if success then
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            if parseSuccess and type(data) == "table" then
                return data
            end
        end
        task.wait(0.2)
    end
    return nil
end

local function authenticate(hwidList)
    protectClipboard()
    protectFileSystem()
    protectConsole()
    protectGUI()
    
    local userHWID = getHWID()
    if not userHWID then
        kickUser("HWID failed")
        return false
    end
    
    local whitelist
    if type(hwidList) == "string" then
        whitelist = getWhitelist(hwidList)
        if not whitelist then
            kickUser("Connection failed")
            return false
        end
    elseif type(hwidList) == "table" then
        whitelist = hwidList
    else
        kickUser("Invalid input")
        return false
    end
    
    for _, id in ipairs(whitelist) do
        if tostring(id):lower() == tostring(userHWID):lower() then
            return true
        end
    end
    
    kickUser("Access denied")
    return false
end

return function(hwidList)
    local success = authenticate(hwidList)
    return {
        authenticated = success,
        hwid = getHWID()
    }
end
