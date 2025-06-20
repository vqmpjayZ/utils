--[[
	Bypasses the Adnois and newindex anti-cheats on Roblox
        Original creator: zins (on https://scriptblox.com)
        Re-worked by Vadrifts :)
            https://dsc.gg/vadriftz

Update logs (DD/MM/YY):

--// Made it less laggy --19.6.2024
--// Added Support to Solara and Incognito --6.7.2024
--// Solara and Incognito lost unc randomly but i've made it still executeable (despite it not working anymore) --11.8.2024
--// Enhanced bypass methods and improved detection evasion --29.6.2025
--]]

local function runScript()
    local getinfo = getinfo or debug.getinfo
    local getgc = getgc or debug.getgc or function() return {} end
    local hookfunction = hookfunction or replaceclosure or function() end
    local newcclosure = newcclosure or function(f) return f end
    local setthreadidentity = setthreadidentity or set_thread_identity or setidentity or function() end
    
    local DEBUG = false
    local Hooked = {}
    local Detected, Kill
    local OriginalFunctions = {}

    local success, err = pcall(function()
        setthreadidentity(2)
    end)
    if not success then
        warn("Failed to set thread identity: " .. tostring(err))
    end

    local function deepScanForAdonis()
        local foundFunctions = {}
        
        success, err = pcall(function()
            for i, v in pairs(getgc(true)) do
                if typeof(v) == "table" then
                    local DetectFunc = rawget(v, "Detected")
                    local KillFunc = rawget(v, "Kill")
                    local CheckFunc = rawget(v, "Check")
                    local ScanFunc = rawget(v, "Scan")
                    local LogFunc = rawget(v, "Log")

                    if typeof(DetectFunc) == "function" and not Detected then
                        Detected = DetectFunc
                        OriginalFunctions.Detected = DetectFunc
                        
                        local Old; Old = hookfunction(Detected, newcclosure(function(Action, Info, NoCrash)
                            if Action ~= "_" then
                                if DEBUG then
                                    warn(`Adonis AntiCheat flagged\nMethod: {Action}\nInfo: {Info}`)
                                end
                            end
                            return true
                        end))

                        table.insert(Hooked, {func = Detected, original = Old})
                        foundFunctions.Detected = true
                    end

                    if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
                        Kill = KillFunc
                        OriginalFunctions.Kill = KillFunc
                        
                        local Old; Old = hookfunction(Kill, newcclosure(function(Info)
                            if DEBUG then
                                warn(`Adonis AntiCheat tried to kill: {Info}`)
                            end
                            return
                        end))

                        table.insert(Hooked, {func = Kill, original = Old})
                        foundFunctions.Kill = true
                    end
                    
                    if typeof(CheckFunc) == "function" then
                        local Old; Old = hookfunction(CheckFunc, newcclosure(function(...)
                            return true
                        end))
                        table.insert(Hooked, {func = CheckFunc, original = Old})
                        foundFunctions.Check = true
                    end
                    
                    if typeof(ScanFunc) == "function" then
                        local Old; Old = hookfunction(ScanFunc, newcclosure(function(...)
                            return
                        end))
                        table.insert(Hooked, {func = ScanFunc, original = Old})
                        foundFunctions.Scan = true
                    end
                    
                    if typeof(LogFunc) == "function" then
                        local Old; Old = hookfunction(LogFunc, newcclosure(function(...)
                            return
                        end))
                        table.insert(Hooked, {func = LogFunc, original = Old})
                        foundFunctions.Log = true
                    end
                end
            end
        end)
        
        return foundFunctions
    end

    local foundFunctions = deepScanForAdonis()

    success, err = pcall(function()
        if debug and debug.getinfo then
            local Old; Old = hookfunction(debug.getinfo, newcclosure(function(...)
                local args = {...}
                if #args < 1 then
                    return Old(...)
                end
                local LevelOrFunc = args[1]

                if Detected and LevelOrFunc == Detected then
                    if DEBUG then
                        warn(`Adonis bypass triggered for getinfo`)
                    end
                    return coroutine.yield(coroutine.running())
                end
                
                if Kill and LevelOrFunc == Kill then
                    if DEBUG then
                        warn(`Adonis kill function intercepted`)
                    end
                    return coroutine.yield(coroutine.running())
                end
                
                return Old(...)
            end))
            
            table.insert(Hooked, {func = debug.getinfo, original = Old})
        end
    end)

    success, err = pcall(function()
        if debug and debug.traceback then
            local Old; Old = hookfunction(debug.traceback, newcclosure(function(...)
                local args = {...}
                local result = Old(...)
                
                if type(result) == "string" then
                    result = string.gsub(result, "Detected", "")
                    result = string.gsub(result, "Kill", "")
                    result = string.gsub(result, "adonis", "")
                    result = string.gsub(result, "anticheat", "")
                end
                
                return result
            end))
            
            table.insert(Hooked, {func = debug.traceback, original = Old})
        end
    end)

    success, err = pcall(function()
        if getfenv then
            local Old; Old = hookfunction(getfenv, newcclosure(function(f)
                local env = Old(f)
                if env and env.script and env.script.Name then
                    local scriptName = string.lower(env.script.Name)
                    if string.find(scriptName, "adonis") or string.find(scriptName, "anticheat") then
                        return setmetatable({}, {
                            __index = function() return function() end end,
                            __newindex = function() end
                        })
                    end
                end
                return env
            end))
            
            table.insert(Hooked, {func = getfenv, original = Old})
        end
    end)

    success, err = pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local oldNamecall = mt.__namecall
            local oldIndex = mt.__index
            
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if method == "FireServer" or method == "InvokeServer" then
                    if self.Name == "Detected" or self.Name == "Kill" or self.Name == "Log" then
                        if DEBUG then
                            warn(`Blocked Adonis remote call: {method} on {self.Name}`)
                        end
                        return
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            mt.__index = newcclosure(function(self, key)
                if key == "Detected" or key == "Kill" or key == "Check" or key == "Scan" then
                    return function() return true end
                end
                return oldIndex(self, key)
            end)
        end
    end)

    task.spawn(function()
        while task.wait(5) do
            local newFunctions = deepScanForAdonis()
            if next(newFunctions) then
                if DEBUG then
                    warn("Re-scanned and found new Adonis functions")
                end
            end
        end
    end)

    success, err = pcall(function()
        setthreadidentity(7)
    end)
    if not success then
        warn("Failed to reset thread identity: " .. tostring(err))
    end
    
    if DEBUG then
        warn("Adonis bypass loaded successfully")
        for funcName, found in pairs(foundFunctions) do
            warn(`Hooked: {funcName}`)
        end
    end
end

local function runFallbackScript()
    local success = pcall(function()
        for i, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Detected") then
                v.Detected = function() return true end
            end
            if type(v) == "table" and rawget(v, "Kill") then
                v.Kill = function() end
            end
        end
        
        if debug and debug.getinfo then
            local old = debug.getinfo
            debug.getinfo = function(...)
                local result = old(...)
                if result and result.func then
                    local success, name = pcall(function()
                        return tostring(result.func)
                    end)
                    if success and (string.find(name:lower(), "detected") or string.find(name:lower(), "kill")) then
                        return nil
                    end
                end
                return result
            end
        end
    end)
    
    if not success then
        warn("Fallback script also failed")
    end
end

local success, err = pcall(runScript)
if not success then
    warn("Primary bypass failed: " .. tostring(err) .. ". Trying fallback.")
    pcall(runFallbackScript)
else
    if DEBUG then
        warn("Adonis bypass completed successfully")
    end
end
