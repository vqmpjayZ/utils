if not _G.__ANTI_HTTP_SPY_ACTIVE then
    _G.__ANTI_HTTP_SPY_ACTIVE = true

    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")

    _G.__CAPTURED_DATA = {}
    local capturedData = _G.__CAPTURED_DATA

    local function kickPlayer()
        lp:Kick("Unexpected Error Occurred (Logger can't run with this script).")
        error("Script execution terminated", 0)
    end

    local function storeData(data)
        if not data or type(data) ~= "string" then return end
        local trimmed = data:match("^%s*(.-)%s*$")
        if trimmed == "" or #trimmed < 5 then return end
        if not trimmed:find("https?://") and not trimmed:find("%w+%.%w+") then return end
        capturedData[trimmed] = true
        capturedData[trimmed:lower()] = true
        if #trimmed > 50 then
            for i = 1, #trimmed - 25, 15 do
                local chunk = trimmed:sub(i, i + 24)
                if #chunk >= 15 then
                    capturedData[chunk] = true
                    capturedData[chunk:lower()] = true
                end
            end
        end
        for url in trimmed:gmatch("https?://[%w%-_%.%%%?%&%=%#%+%/]+") do
            if #url > 10 then
                capturedData[url] = true
                capturedData[url:lower()] = true
                local domain = url:match("https?://([^/]+)")
                if domain then
                    capturedData[domain] = true
                    capturedData[domain:lower()] = true
                end
            end
        end
    end

    local function scanExistingGlobals()
        local function scanValue(value, depth)
            if depth > 3 then return end
            if type(value) == "string" then
                storeData(value)
            elseif type(value) == "table" then
                for k, v in pairs(value) do
                    if type(k) == "string" then
                        storeData(k)
                    end
                    scanValue(v, depth + 1)
                end
            end
        end
        
        for k, v in pairs(_G) do
            if type(k) == "string" then
                storeData(k)
            end
            scanValue(v, 0)
        end
        
        if getgenv then
            for k, v in pairs(getgenv()) do
                if type(k) == "string" then
                    storeData(k)
                end
                scanValue(v, 0)
            end
        end
    end

    local function isBlocked(content)
        if not content or type(content) ~= "string" then return false end
        local lower = content:lower()
        for stored in pairs(capturedData) do
            if #stored > 8 and (stored:find("https?://") or stored:find("%w+%.%w+")) then
                if content:find(stored, 1, true) or lower:find(stored, 1, true) then
                    return true
                end
            end
        end
        return false
    end

    local function aggressiveHttpHook()
        local function createHook(originalFunc)
            return function(...)
                local args = {...}
                for _, arg in pairs(args) do
                    if type(arg) == "string" then
                        storeData(arg)
                    elseif type(arg) == "table" then
                        for _, v in pairs(arg) do
                            if type(v) == "string" then
                                storeData(v)
                            end
                        end
                    end
                end
                local success, result = pcall(originalFunc, ...)
                if success and result then
                    if type(result) == "string" then
                        storeData(result)
                    elseif type(result) == "table" and result.Body then
                        storeData(result.Body)
                    end
                end
                return result
            end
        end

        local function hookAndPatch(name, target)
            if target then
                local hooked = createHook(target)
                getgenv()[name] = hooked
                _G[name] = hooked
                return hooked
            end
        end

        spawn(function()
            pcall(function()
                if game.HttpGet then
                    local orig = game.HttpGet
                    local hooked = createHook(function(self, ...) return orig(self, ...) end)
                    game.HttpGet = hooked
                end
            end)
            pcall(function()
                if game.HttpGetAsync then
                    local orig = game.HttpGetAsync
                    local hooked = createHook(function(self, ...) return orig(self, ...) end)
                    game.HttpGetAsync = hooked
                end
            end)
            pcall(function()
                if game.HttpPost then
                    local orig = game.HttpPost
                    local hooked = createHook(function(self, ...) return orig(self, ...) end)
                    game.HttpPost = hooked
                end
            end)
            pcall(function()
                if game.HttpPostAsync then
                    local orig = game.HttpPostAsync
                    local hooked = createHook(function(self, ...) return orig(self, ...) end)
                    game.HttpPostAsync = hooked
                end
            end)
        end)

        spawn(function()
            local httpFunctions = {"request", "http_request", "HttpRequest", "httpRequest"}
            for _, name in pairs(httpFunctions) do
                pcall(function()
                    if _G[name] then hookAndPatch(name, _G[name]) end
                    if getgenv and getgenv()[name] then hookAndPatch(name, getgenv()[name]) end
                end)
            end
            
            pcall(function()
                if http and http.request then http.request = createHook(http.request) end
            end)
            pcall(function()
                if syn and syn.request then syn.request = createHook(syn.request) end
            end)
        end)

        spawn(function()
            for i = 1, 15 do
                wait(i * 0.3)
                local executors = {"fluxus", "Electron", "Oxygen", "Solara", "Xeno", "Krnl", "Delta", "Script-Ware", "JJSploit", "ProtoSmasher"}
                for _, name in pairs(executors) do
                    pcall(function()
                        local executor = getgenv()[name] or _G[name]
                        if executor and type(executor) == "table" then
                            for funcName, func in pairs(executor) do
                                if type(func) == "function" and funcName:lower():find("request") then
                                    executor[funcName] = createHook(func)
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end

    local function hookDetections()
        spawn(function()
            local origPrint = print
            local origWarn = warn
            print = function(...)
                for _, arg in pairs({...}) do
                    if isBlocked(tostring(arg)) then
                        kickPlayer()
                        return
                    end
                end
                return origPrint(...)
            end
            warn = function(...)
                for _, arg in pairs({...}) do
                    if isBlocked(tostring(arg)) then
                        kickPlayer()
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
        end)

        spawn(function()
            local rconsole_funcs = {"rconsoleprint", "rconsolelog", "rconsoleinfo", "rconsoleerr", "rconsoleclear", "rconsolename", "rconsoleinput", "rconsoleclose", "rconsolecreate", "rconsoledestroy"}
            for _, funcName in pairs(rconsole_funcs) do
                pcall(function()
                    if getgenv and getgenv()[funcName] then
                        local orig = getgenv()[funcName]
                        getgenv()[funcName] = function(content, ...)
                            if content and isBlocked(tostring(content)) then
                                kickPlayer()
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
                            if content and isBlocked(tostring(content)) then
                                kickPlayer()
                                return
                            end
                            return orig(content, ...)
                        end
                    end
                end)
            end
        end)

        spawn(function()
            local clipboards = {"setclipboard", "toclipboard", "set_clipboard", "copyClipboard", "copy"}
            for _, name in pairs(clipboards) do
                pcall(function()
                    if getgenv and getgenv()[name] then
                        local orig = getgenv()[name]
                        getgenv()[name] = function(content)
                            if isBlocked(tostring(content or "")) then
                                kickPlayer()
                            end
                            return orig(content)
                        end
                    end
                end)
                pcall(function()
                    if _G[name] then
                        local orig = _G[name]
                        _G[name] = function(content)
                            if isBlocked(tostring(content or "")) then
                                kickPlayer()
                            end
                            return orig(content)
                        end
                    end
                end)
            end
        end)

        spawn(function()
            local files = {"writefile", "appendfile", "makefolder", "delfolder", "delfile"}
            for _, name in pairs(files) do
                pcall(function()
                    if getgenv and getgenv()[name] then
                        local orig = getgenv()[name]
                        getgenv()[name] = function(path, content, ...)
                            if content and isBlocked(tostring(content)) then
                                kickPlayer()
                            end
                            if path and isBlocked(tostring(path)) then
                                kickPlayer()
                            end
                            return orig(path, content, ...)
                        end
                    end
                end)
                pcall(function()
                    if _G[name] then
                        local orig = _G[name]
                        _G[name] = function(path, content, ...)
                            if content and isBlocked(tostring(content)) then
                                kickPlayer()
                            end
                            if path and isBlocked(tostring(path)) then
                                kickPlayer()
                            end
                            return orig(path, content, ...)
                        end
                    end
                end)
            end
        end)
    end

    local function constantMonitoring()
        spawn(function()
            while wait(0.1) do
                pcall(function()
                    if getclipboard then
                        local clip = getclipboard()
                        if isBlocked(clip) then
                            kickPlayer()
                        end
                    end
                end)
            end
        end)
        
        spawn(function()
            while wait(2) do
                pcall(function()
                    for k, v in pairs(getgenv()) do
                        if type(k) == "string" and (k:lower():find("request") or k:lower():find("http")) and type(v) == "function" then
                            local orig = v
                            getgenv()[k] = function(...)
                                local args = {...}
                                for _, arg in pairs(args) do
                                    storeData(tostring(arg))
                                end
                                local result = orig(...)
                                storeData(tostring(result))
                                return result
                            end
                        end
                    end
                end)
                
                pcall(function()
                    for k, v in pairs(_G) do
                        if type(k) == "string" and (k:lower():find("request") or k:lower():find("http")) and type(v) == "function" then
                            local orig = v
                            _G[k] = function(...)
                                local args = {...}
                                for _, arg in pairs(args) do
                                    storeData(tostring(arg))
                                end
                                local result = orig(...)
                                storeData(tostring(result))
                                return result
                            end
                        end
                    end
                end)
            end
        end)
    end

    local function uiDetection()
        local function isMaliciousText(text)
            return isBlocked(text)
        end
        local function hookTextChanged(obj)
            if not (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel")) then
                return
            end
            pcall(function()
                local txt = obj.Text
                if isMaliciousText(txt) then
                    local root = obj:FindFirstAncestorWhichIsA("ScreenGui") or obj:FindFirstAncestorWhichIsA("Folder")
                    if root then root:Destroy() end
                    lp:Kick("HTTP logger GUI detected.")
                    error("HTTP logger GUI blocked")
                    return
                end
                obj:GetPropertyChangedSignal("Text"):Connect(function()
                    local newTxt = obj.Text
                    if isMaliciousText(newTxt) then
                        local root = obj:FindFirstAncestorWhichIsA("ScreenGui") or obj:FindFirstAncestorWhichIsA("Folder")
                        if root then root:Destroy() end
                        lp:Kick("HTTP logger GUI detected.")
                        error("HTTP logger GUI blocked")
                        return
                    end
                end)
            end)
        end
        local function watchGui(root)
            if not root or not root:IsA("Instance") then return end
            for _, obj in ipairs(root:GetDescendants()) do
                hookTextChanged(obj)
            end
            root.DescendantAdded:Connect(hookTextChanged)
        end
        local function isRobloxGuiReal(robloxGui)
            if not robloxGui then return false end
            return robloxGui:FindFirstChild("EmotesMenu") ~= nil
        end
        local function getPriorityGuiRoot()
            local possibleHuiNames = {"HUI", "HiddenUI", "HiddenGUI"}
            for _, name in ipairs(possibleHuiNames) do
                local folder = CoreGui:FindFirstChild(name)
                if folder and folder:IsA("Folder") then
                    return folder
                end
            end
            local robloxGui = CoreGui:FindFirstChild("RobloxGui")
            if robloxGui and robloxGui:IsA("Folder") then
                if not isRobloxGuiReal(robloxGui) then
                    return robloxGui
                end
            end
            return CoreGui
        end
        local rootToWatch = getPriorityGuiRoot()
        watchGui(rootToWatch)
        spawn(function()
            while wait(1) do
                pcall(function()
                    local newRoot = getPriorityGuiRoot()
                    if newRoot ~= rootToWatch then
                        rootToWatch = newRoot
                        watchGui(rootToWatch)
                    end
                end)
            end
        end)
        spawn(function()
            CoreGui.ChildAdded:Connect(function(child)
                wait(0.1)
                watchGui(child)
            end)
        end)
    end

    scanExistingGlobals()
    uiDetection()
    aggressiveHttpHook()
    hookDetections()
    constantMonitoring()
else
    spawn(function()
        if _G.__CAPTURED_DATA and isBlocked then
            local Players = game:GetService("Players")
            local lp = Players.LocalPlayer
            local CoreGui = game:GetService("CoreGui")
            local function isMaliciousText(text)
                return isBlocked(text)
            end
            local function hookTextChanged(obj)
                if not (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") or obj:IsA("RichTextLabel")) then
                    return
                end
                pcall(function()
                    local txt = obj.Text
                    if isMaliciousText(txt) then
                        local root = obj:FindFirstAncestorWhichIsA("ScreenGui") or obj:FindFirstAncestorWhichIsA("Folder")
                        if root then root:Destroy() end
                        lp:Kick("HTTP logger GUI detected.")
                        error("HTTP logger GUI blocked")
                        return
                    end
                    obj:GetPropertyChangedSignal("Text"):Connect(function()
                        local newTxt = obj.Text
                        if isMaliciousText(newTxt) then
                            local root = obj:FindFirstAncestorWhichIsA("ScreenGui") or obj:FindFirstAncestorWhichIsA("Folder")
                            if root then root:Destroy() end
                            lp:Kick("HTTP logger GUI detected.")
                            error("HTTP logger GUI blocked")
                            return
                        end
                    end)
                end)
            end
            local function watchGui(root)
                if not root or not root:IsA("Instance") then return end
                for _, obj in ipairs(root:GetDescendants()) do
                    hookTextChanged(obj)
                end
                root.DescendantAdded:Connect(hookTextChanged)
            end
            watchGui(CoreGui)
        end
    end)
end
