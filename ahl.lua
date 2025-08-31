if _G.__ANTI_HTTP_SPY_ACTIVE then
    return
end
_G.__ANTI_HTTP_SPY_ACTIVE = true

local DEBUG_MODE = true

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local capturedRequests = {}
local kickInitiated = false
local activeCleanupRunning = false

local function debugPrint(...)
    if DEBUG_MODE then
        print("[AntiLogger]", ...)
    end
end

local function debugWarn(...)
    if DEBUG_MODE then
        warn("[AntiLogger]", ...)
    end
end

local function kickPlayer(reason)
    if kickInitiated then return end
    kickInitiated = true
    
    debugWarn("Kicking player:", reason)
    
    task.spawn(function()
        lp:Kick("Unexpected Error Occurred")
    end)
end

local function captureRequest(url)
    if type(url) ~= "string" or #url < 15 then return end
    
    if url:match("^https?://[%w%-_%.]+/[%w%-_%.%%%?%&%=%#%+%/]*$") then
        capturedRequests[url] = true
        debugPrint("Captured request:", url)
    end
end

local function isRequestContent(text)
    if type(text) ~= "string" or #text < 15 then return false end
    
    local suspiciousCount = 0
    
    for request in pairs(capturedRequests) do
        if text == request then
            return true
        end
        
        if #request > 20 and text:find(request:sub(1, 20), 1, true) and text:find(request:sub(-15), 1, true) then
            suspiciousCount = suspiciousCount + 1
            if suspiciousCount >= 2 then
                return true
            end
        end
    end
    
    return false
end

local function isLegitimateUI(obj)
    if not obj or not obj:IsA("Instance") then return false end
    
    local legitNames = {"Frame", "ScrollingFrame", "TextLabel", "TextButton", "ImageLabel", "ImageButton"}
    local current = obj
    local depth = 0
    
    while current and depth < 5 do
        if current.Name and (
            current.Name:lower():find("krnl") or 
            current.Name:lower():find("executor") or 
            current.Name:lower():find("script") or
            current.Name:lower():find("inject") or
            current.Name:lower():find("menu") or
            current.Name:lower():find("gui")
        ) then
            return true
        end
        current = current.Parent
        depth = depth + 1
    end
    
    return false
end

local function createHttpHook(originalFunc)
    return function(...)
        local args = {...}
        
        for _, arg in ipairs(args) do
            if type(arg) == "string" then
                captureRequest(arg)
            elseif type(arg) == "table" and (arg.Url or arg.url) then
                captureRequest(arg.Url or arg.url)
            end
        end
        
        local success, result = pcall(originalFunc, ...)
        
        if success and result then
            if type(result) == "string" then
                captureRequest(result)
            elseif type(result) == "table" and (result.Body or result.body) then
                local body = result.Body or result.body
                if type(body) == "string" then
                    captureRequest(body)
                end
            end
        end
        
        return result
    end
end

local function hookHttpMethods()
    pcall(function()
        if game.HttpGet then
            local orig = game.HttpGet
            game.HttpGet = function(self, url, ...)
                captureRequest(url)
                return orig(self, url, ...)
            end
        end
    end)
    
    pcall(function()
        if game.HttpGetAsync then
            local orig = game.HttpGetAsync
            game.HttpGetAsync = function(self, url, ...)
                captureRequest(url)
                return orig(self, url, ...)
            end
        end
    end)
    
    pcall(function()
        if game.HttpPost then
            local orig = game.HttpPost
            game.HttpPost = function(self, url, ...)
                captureRequest(url)
                return orig(self, url, ...)
            end
        end
    end)
    
    pcall(function()
        if game.HttpPostAsync then
            local orig = game.HttpPostAsync
            game.HttpPostAsync = function(self, url, ...)
                captureRequest(url)
                return orig(self, url, ...)
            end
        end
    end)
    
    if getgenv then
        pcall(function()
            if getgenv().request then
                getgenv().request = createHttpHook(getgenv().request)
            end
        end)
        
        pcall(function()
            if getgenv().syn and getgenv().syn.request then
                getgenv().syn.request = createHttpHook(getgenv().syn.request)
            end
        end)
        
        pcall(function()
            if getgenv().http and getgenv().http.request then
                getgenv().http.request = createHttpHook(getgenv().http.request)
            end
        end)
    end
    
    pcall(function()
        if _G.request then
            _G.request = createHttpHook(_G.request)
        end
    end)
    
    pcall(function()
        if _G.http_request then
            _G.http_request = createHttpHook(_G.http_request)
        end
    end)
end

local function hookFileSystemFunctions()
    local fileFunctions = {
        {"writefile", true},
        {"appendfile", true},
        {"makefolder", false},
        {"delfolder", false},
        {"delfile", false}
    }
    
    for _, funcData in ipairs(fileFunctions) do
        local funcName, checkContent = funcData[1], funcData[2]
        
        pcall(function()
            if getgenv and getgenv()[funcName] then
                local orig = getgenv()[funcName]
                getgenv()[funcName] = function(path, content)
                    if isRequestContent(path) or (checkContent and content and isRequestContent(content)) then
                        kickPlayer("File logger detected")
                        return
                    end
                    if checkContent then
                        return orig(path, content)
                    else
                        return orig(path)
                    end
                end
            end
        end)
        
        pcall(function()
            if _G[funcName] then
                local orig = _G[funcName]
                _G[funcName] = function(path, content)
                    if isRequestContent(path) or (checkContent and content and isRequestContent(content)) then
                        kickPlayer("File logger detected")
                        return
                    end
                    if checkContent then
                        return orig(path, content)
                    else
                        return orig(path)
                    end
                end
            end
        end)
    end
end

local function hookClipboardFunctions()
    local clipboardFuncs = {"setclipboard", "toclipboard", "set_clipboard", "Clipboard.set", "copystring"}
    
    for _, funcName in ipairs(clipboardFuncs) do
        pcall(function()
            local parts = funcName:split(".")
            if #parts == 1 then
                if getgenv and getgenv()[funcName] then
                    local orig = getgenv()[funcName]
                    getgenv()[funcName] = function(content)
                        if isRequestContent(content) then
                            kickPlayer("Clipboard logger detected")
                            return
                        end
                        return orig(content)
                    end
                end
                
                if _G[funcName] then
                    local orig = _G[funcName]
                    _G[funcName] = function(content)
                        if isRequestContent(content) then
                            kickPlayer("Clipboard logger detected")
                            return
                        end
                        return orig(content)
                    end
                end
            else
                local obj = getgenv and getgenv()[parts[1]] or _G[parts[1]]
                if obj and obj[parts[2]] then
                    local orig = obj[parts[2]]
                    obj[parts[2]] = function(content)
                        if isRequestContent(content) then
                            kickPlayer("Clipboard logger detected")
                            return
                        end
                        return orig(content)
                    end
                end
            end
        end)
    end
    
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                if getclipboard then
                    local clipContent = getclipboard()
                    if clipContent and isRequestContent(clipContent) then
                        kickPlayer("Clipboard contains logged URL")
                    end
                end
            end)
        end
    end)
end

local function hookConsoleFunctions()
    local origPrint = print
    print = function(...)
        local args = {...}
        for _, arg in ipairs(args) do
            if isRequestContent(tostring(arg)) then
                kickPlayer("Print logger detected")
                return
            end
        end
        return origPrint(...)
    end
    
    local origWarn = warn
    warn = function(...)
        local args = {...}
        for _, arg in ipairs(args) do
            if isRequestContent(tostring(arg)) then
                kickPlayer("Warn logger detected")
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

    local consoleFuncs = {
        "rconsoleprint", "rconsoleinfo", "rconsoleerr", "rconsolelog", 
        "rconsolewrite", "rconsolewarn", "consoleprint", "consolewarn"
    }
    
    for _, funcName in ipairs(consoleFuncs) do
        pcall(function()
            if getgenv and getgenv()[funcName] then
                local orig = getgenv()[funcName]
                getgenv()[funcName] = function(content, ...)
                    if isRequestContent(tostring(content)) then
                        kickPlayer("Console logger detected")
                        return
                    end
                    return orig(content, ...)
                end
            end
        end)
        
        pcall(function()
            if _G[funcName] then
                local orig = _G[funcName]
                _G[funcName] = function(content, ...)
                    if isRequestContent(tostring(content)) then
                        kickPlayer("Console logger detected")
                        return
                    end
                    return orig(content, ...)
                end
            end
        end)
    end
end

local function destroyMaliciousGUI(obj)
    if isLegitimateUI(obj) then return end
    
    task.spawn(function()
        local root = obj
        local tries = 0
        
        while root and root.Parent ~= CoreGui and root.Parent ~= game and tries < 10 do
            root = root.Parent
            tries = tries + 1
        end
        
        if root and root:IsA("Instance") and not isLegitimateUI(root) then
            pcall(function() root:Destroy() end)
        elseif not isLegitimateUI(obj) then
            pcall(function() obj:Destroy() end)
        end
        
        if obj and obj.Parent and obj.Parent:IsA("Instance") and not isLegitimateUI(obj.Parent) then
            pcall(function() obj.Parent:Destroy() end)
        end
        
        if not kickInitiated then
            kickPlayer("HTTP logger GUI detected")
        end
    end)
end

local function checkTextElement(obj)
    if not obj or not obj:IsA("Instance") then return end
    if isLegitimateUI(obj) then return end
    
    if not (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel")) then
        return
    end
    
    local function checkText()
        if not obj or not obj:IsA("Instance") or not obj.Parent then return false end
        if isLegitimateUI(obj) then return false end
        
        local text = obj.Text
        if text and #text > 15 and isRequestContent(text) then
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
    
    pcall(function()
        obj.AncestryChanged:Connect(function(_, parent)
            if not parent and connection then
                connection:Disconnect()
            end
        end)
    end)
end

local function scanGUI(root)
    if not root or not root:IsA("Instance") then return end
    if isLegitimateUI(root) then return end
    
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

local function scanAllLocations()
    pcall(function()
        for _, child in ipairs(CoreGui:GetChildren()) do
            if not isLegitimateUI(child) then
                task.spawn(function()
                    scanGUI(child)
                end)
            end
        end
    end)
    
    pcall(function()
        local playerGui = lp:FindFirstChild("PlayerGui")
        if playerGui then
            for _, child in ipairs(playerGui:GetChildren()) do
                if not isLegitimateUI(child) then
                    task.spawn(function()
                        scanGUI(child)
                    end)
                end
            end
        end
    end)
end

local function startActiveCleanup()
    if activeCleanupRunning then return end
    activeCleanupRunning = true
    
    task.spawn(function()
        while true do
            task.wait(1)
            
            pcall(function()
                for _, obj in ipairs(CoreGui:GetDescendants()) do
                    if not isLegitimateUI(obj) and (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel")) then
                        if obj.Text and #obj.Text > 15 and isRequestContent(obj.Text) then
                            destroyMaliciousGUI(obj)
                        end
                    end
                end
            end)
        end
    end)
end

task.spawn(function()
    captureRequest("https://example.com/api/endpoint")
    captureRequest("https://api.example.org/data/collect")
    captureRequest("https://github.com/user/repo/raw/main/logger.lua")
    captureRequest("https://pastebin.com/raw/abcdef123")
    captureRequest("https://raw.githubusercontent.com/user/repo/main/script.lua")
    captureRequest("https://discord.com/api/webhooks/")
end)

hookHttpMethods()
hookFileSystemFunctions()
hookClipboardFunctions()
hookConsoleFunctions()

task.wait(2)
scanAllLocations()
startActiveCleanup()

CoreGui.ChildAdded:Connect(function(child)
    if not isLegitimateUI(child) then
        task.spawn(function()
            task.wait(0.5)
            scanGUI(child)
        end)
    end
end)

task.spawn(function()
    while task.wait(3) do
        hookHttpMethods()
        hookFileSystemFunctions()
        hookClipboardFunctions()
    end
end)
