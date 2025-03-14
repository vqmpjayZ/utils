-- Simple Notification Blocker - Blocks only the next notification
-- Works with StarterGui:SetCore("SendNotification", ...)
-- Compatible with basic executors

local StarterGui = game:GetService("StarterGui")

local hasBlockedNotification = false
e
local originalSetCore = StarterGui.SetCore
if originalSetCore then
    StarterGui.SetCore = function(self, notifType, data)
        if notifType == "SendNotification" and not hasBlockedNotification then
            hasBlockedNotification = true
            print("BLOCKED NOTIFICATION:", data.Title, data.Text)
            return
        end
        return originalSetCore(self, notifType, data)
    end
else

    local mt = getrawmetatable(game)
    local oldNameCall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "SetCore" and self == StarterGui and args[1] == "SendNotification" then
            if not hasBlockedNotification then
                hasBlockedNotification = true
                local notifData = args[2]
                print("BLOCKED NOTIFICATION:", notifData.Title, notifData.Text)
                return nil
            end
        end
        
        return oldNameCall(self, ...)
    end)
    
    setreadonly(mt, true)
end

local function testBlocker()
    StarterGui:SetCore("SendNotification", {
        Title = "Test Notification",
        Text = "This should be blocked",
        Duration = 5
    })
    
    wait(1)
    
    StarterGui:SetCore("SendNotification", {
        Title = "Second Notification",
        Text = "This should appear normally",
        Duration = 5
    })
end

print("Notification blocker initialized - The next notification will be blocked")
print("Run the testBlocker() function to test if it works")

return testBlocker
