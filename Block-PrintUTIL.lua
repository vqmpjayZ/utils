local originalPrint = print
local originalWarn = warn
local originalError = error

getgenv().print = function(...)

    local args = {...}
    local containsObscura = false
    
    for i, v in ipairs(args) do
        if tostring(v):find("Obscura") then
            containsObscura = true
            break
        end
    end

    if containsObscura then
        return
    end
    
    return originalPrint(...)
end

getgenv().warn = function(...)
    local args = {...}
    local containsObscura = false
    
    for i, v in ipairs(args) do
        if tostring(v):find("Obscura") then
            containsObscura = true
            break
        end
    end
    
    if containsObscura then
        return
    end

    return originalWarn(...)
end

getgenv().error = function(...)
    local args = {...}
    local containsObscura = false
    
    for i, v in ipairs(args) do
        if tostring(v):find("Obscura") then
            containsObscura = true
            break
        end
    end
    
    if containsObscura then
        return
    end
    
    return originalError(...)
end

if rconsoleprint then
    local originalRconsolePrint = rconsoleprint
    getgenv().rconsoleprint = function(text)
        if tostring(text):find("Obscura") then
            return
        end
        return originalRconsolePrint(text)
    end
end

if rconsolewarn then
    local originalRconsoleWarn = rconsolewarn
    getgenv().rconsolewarn = function(text)
        if tostring(text):find("Obscura") then
            return
        end
        return originalRconsoleWarn(text)
    end
end

if rconsoleerror then
    local originalRconsoleError = rconsoleerror
    getgenv().rconsoleerror = function(text)
        if tostring(text):find("Obscura") then
            return
        end
        return originalRconsoleError(text)
    end
end

print("Console message blocker initialized - Messages containing 'Obscura' will be blocked")
local function testBlocker()
    print("Normal message - should appear")
    print("Message with Obscura - should be blocked")
    warn("Warning with Obscura - should be blocked")
    print("Another normal message - should appear")
    
    print("Message with " .. "Obscura" .. " split - should be blocked")
    
    print("Table test:", {name = "Obscura Test"})
end

return testBlocker
