local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function decrypt(encoded)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local result = ""
    encoded = encoded:gsub("[^" .. chars .. "=]", "")
    local padding = encoded:match("=*$")
    encoded = encoded:gsub("=*$", "")
    
    for i = 1, #encoded, 4 do
        local a, b, c, d = encoded:byte(i, i + 3)
        a = chars:find(string.char(a)) - 1
        b = chars:find(string.char(b)) - 1
        c = c and chars:find(string.char(c)) - 1 or 0
        d = d and chars:find(string.char(d)) - 1 or 0
        
        local combined = a * 262144 + b * 4096 + c * 64 + d
        result = result .. string.char(math.floor(combined / 65536) % 256)
        if #padding < 2 then
            result = result .. string.char(math.floor(combined / 256) % 256)
        end
        if #padding < 1 then
            result = result .. string.char(combined % 256)
        end
    end
    
    return result
end

local function getWeekNumber()
    local currentTime = os.time()
    local startOfYear = os.time({year = 2024, month = 1, day = 1, hour = 0, min = 0, sec = 0})
    local daysSinceStart = math.floor((currentTime - startOfYear) / 86400)
    return math.floor(daysSinceStart / 7)
end

local function transformHWID(hwid)
    local week = getWeekNumber()
    local seed = week * 31 + 1337
    local transformed = ""
    
    for i = 1, #hwid do
        local char = hwid:sub(i, i)
        if char:match("[A-F0-9]") then
            local num = tonumber(char, 16) or string.byte(char)
            local newNum = (num + seed + i) % 16
            transformed = transformed .. string.format("%X", newNum)
        else
            transformed = transformed .. char
        end
    end
    
    return transformed
end

local function validateServices()
    local analytics = game:GetService("RbxAnalyticsService")
    if type(analytics) ~= "userdata" or type(analytics.GetClientId) ~= "function" then
        return false
    end
    return true
end

local function getConsistentHWID()
    if not validateServices() then return nil end
    
    local hwids = {}
    for i = 1, 5 do
        local success, hwid = pcall(function()
            return game:GetService("RbxAnalyticsService"):GetClientId()
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
    
    return transformHWID(hwids[1])
end

local function fetchWhitelist(url)
    for i = 1, 4 do
        local success, result = pcall(function()
            return game:HttpGet(url .. "?t=" .. os.time() .. "&r=" .. math.random(100000, 999999))
        end)
        
        if success then
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if parseSuccess and type(data) == "table" then
                return data
            end
        end
        task.wait(0.1 + (i * 0.1))
    end
    return nil
end

local function antiDebug()
    if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then
        LocalPlayer:Kick("DBG_001")
        return false
    end
    if getgenv or getfenv(0).getgenv or _G.getgenv then
        LocalPlayer:Kick("DBG_002") 
        return false
    end
    return true
end

local function verify(encodedUrl, kickMsg)
    if not antiDebug() then return false end
    if not validateServices() then
        LocalPlayer:Kick("ERR_001")
        return false
    end
    
    local hwid = getConsistentHWID()
    if not hwid then
        LocalPlayer:Kick("ERR_002")
        return false
    end
    
    local url = decrypt(encodedUrl)
    local whitelist = fetchWhitelist(url)
    if not whitelist then
        LocalPlayer:Kick("ERR_003")
        return false
    end
    
    for _, id in ipairs(whitelist) do
        if tostring(id):lower() == tostring(hwid):lower() then
            return true
        end
    end
    
    LocalPlayer:Kick(kickMsg or "ERR_004")
    return false
end

return verify
