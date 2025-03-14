--Debugging removed

local StarterGui = game:GetService("StarterGui")
local hasBlockedNotification = false

local originalSetCore = StarterGui.SetCore
if typeof(originalSetCore) ~= "function" then

    local function blockNextNotification()
 
        local env = getfenv(0)
        local oldSetCore = env.StarterGui.SetCore
        
        env.StarterGui.SetCore = function(self, notifType, data)
            if notifType == "SendNotification" and not hasBlockedNotification then
                hasBlockedNotification = true
                print("BLOCKED NOTIFICATION:", data.Title, data.Text)
                
                env.StarterGui.SetCore = oldSetCore
                return
            end
            
            return oldSetCore(self, notifType, data)
        end
    end
    
    pcall(blockNextNotification)
end

local function createFakeNotification()
    local originalSendNotification = StarterGui.SendNotification
    
    StarterGui.SendNotification = function(self, data)
        if not hasBlockedNotification then
            hasBlockedNotification = true
--            print("BLOCKED NOTIFICATION (SendNotification):", data.Title, data.Text)
            
            if originalSendNotification then
                StarterGui.SendNotification = originalSendNotification
            end
            return
        end
        
        if originalSendNotification then
            return originalSendNotification(self, data)
        end
    end
end

pcall(createFakeNotification)

local function interceptNotificationUI()
    local success, result = pcall(function()
        local CoreGui = game:GetService("CoreGui")
        if CoreGui:FindFirstChild("RobloxGui") then
            local RobloxGui = CoreGui.RobloxGui
            if RobloxGui:FindFirstChild("NotificationFrame") then
                local NotificationFrame = RobloxGui.NotificationFrame
                
                NotificationFrame.ChildAdded:Connect(function(child)
                    if not hasBlockedNotification then
                        hasBlockedNotification = true
--                        print("BLOCKED NOTIFICATION (UI):", child.Name)
                        child:Destroy()
                    end
                end)
                
                return true
            end
        end
        return false
    end)
    
    return success and result
end

pcall(interceptNotificationUI)

--print("Simple notification blocker initialized - Will try to block the next notification")

local function testBlocker()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Test Notification",
            Text = "This should be blocked",
            Duration = 5
        })
    end)
    
    wait(1)
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Second Notification",
            Text = "This should appear normally",
            Duration = 5
        })
    end)
end

return testBlocker
