if _G.__ANTI_HTTP_SPY_ACTIVE then
    return
end
_G.__ANTI_HTTP_SPY_ACTIVE = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local capturedRequests = {}
local kickInitiated = false
local protectedURL = ""

local function kickPlayer(reason)
    if kickInitiated then return end
    kickInitiated = true
    task.spawn(function()
        LocalPlayer:Kick(reason or "Unexpected Error Occurred")
    end)
end

local function captureRequest(url)
    if type(url) ~= "string" or #url < 15 then return end
    if url == protectedURL or url:find(protectedURL, 1, true) then
        capturedRequests[url] = true
    end
end

local function isRequestContent(text)
    if type(text) ~= "string" or #text < 15 then return false end
    for request in pairs(capturedRequests) do
        if text == request or text:find(request, 1, true) then
            return true
        end
    end
    return false
end

local function hookClipboard()
    local clipboardFuncs = {"setclipboard", "toclipboard", "set_clipboard"}
    for _, funcName in ipairs(clipboardFuncs) do
        pcall(function()
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
        end)
    end
end

local function getConsistentHWID()
    local analytics = game:GetService("RbxAnalyticsService")
    if type(analytics) ~= "userdata" or type(analytics.GetClientId) ~= "function" then
        return nil
    end
    
    local hwids = {}
    for i = 1, 5 do
        local success, hwid = pcall(function()
            return analytics:GetClientId()
        end)
        if success and hwid then
            table.insert(hwids, hwid)
        end
        task.wait(0.05)
    end
    
    if #hwids < 3 then return nil end
    
    for i = 2, #hwids do
        if hwids[i] ~= hwids[1] then
            return nil
        end
    end
    
    return hwids[1]
end

local function fetchWhitelist(url)
    protectedURL = url
    captureRequest(url)
    
    for i = 1, 3 do
        local success, result = pcall(function()
            return game:HttpGet(url .. "?t=" .. os.time())
        end)
        
        if success then
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if parseSuccess and type(data) == "table" then
                return data
            end
        end
        task.wait(0.2)
    end
    return nil
end

local function checkWhitelist(hwids)
    hookClipboard()
    
    local hwid = getConsistentHWID()
    if not hwid then
        LocalPlayer:Kick("HWID error")
        return false
    end
    
    local whitelist
    if type(hwids) == "string" then
        whitelist = fetchWhitelist(hwids)
        if not whitelist then
            LocalPlayer:Kick("Server error")
            return false
        end
    elseif type(hwids) == "table" then
        whitelist = hwids
    else
        LocalPlayer:Kick("Config error")
        return false
    end
    
    for _, id in ipairs(whitelist) do
        if tostring(id):lower() == tostring(hwid):lower() then
            return true
        end
    end
    
    LocalPlayer:Kick("Not whitelisted")
    return false
end

return function(hwids)
    local authenticated = checkWhitelist(hwids)
    return {
        authenticated = authenticated,
        hwid = getConsistentHWID()
    }
end
