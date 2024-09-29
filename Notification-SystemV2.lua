local NotifUI = Instance.new("ScreenGui")
local Holder = Instance.new("ScrollingFrame")
local Sorter = Instance.new("UIListLayout")

NotifUI.Name = "NotifUI"
NotifUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
NotifUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = NotifUI
Holder.Active = true
Holder.AnchorPoint = Vector2.new(1, 1)
Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Holder.BackgroundTransparency = 1.000
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1, -10, 1, -20)
Holder.Size = UDim2.new(0.3, 0, 1, 0)
Holder.CanvasSize = UDim2.new(0, 0, 0, 0)

Sorter.Name = "Sorter"
Sorter.Parent = Holder
Sorter.HorizontalAlignment = Enum.HorizontalAlignment.Center
Sorter.SortOrder = Enum.SortOrder.LayoutOrder
Sorter.VerticalAlignment = Enum.VerticalAlignment.Bottom
Sorter.Padding = UDim.new(0, 10)

local function SetDefault(v1, v2)
    v1 = v1 or {}
    local v3 = {}
    for i, v in next, v2 do
        v3[i] = v1[i] or v2[i]
    end
    return v3
end

local Notification = {}
local NotificationQueue = {}
local NotificationCount = 0
local GUI = Instance.new("ScreenGui")
GUI.Parent = game.CoreGui

local function CreateNotification(title, description)
    NotificationCount = NotificationCount + 1
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Size = UDim2.new(0, 300, 0, 100)
    NotificationHolder.Position = UDim2.new(1, -5, 1, -100 - (NotificationCount - 1) * 110)
    NotificationHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotificationHolder.BackgroundTransparency = 0.5
    NotificationHolder.Parent = GUI

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    TitleLabel.Position = UDim2.new(0, 0, 0, 10)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = NotificationHolder

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, 0, 0, 40)
    DescriptionLabel.Position = UDim2.new(0, 0, 0, 30)
    DescriptionLabel.Text = description
    DescriptionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Parent = NotificationHolder

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 0, 10)
    ProgressBar.Position = UDim2.new(0, 0, 0, 75)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.Parent = NotificationHolder

    local DismissButton = Instance.new("TextButton")
    DismissButton.Size = UDim2.new(0, 100, 0, 30)
    DismissButton.Position = UDim2.new(0.5, -50, 0.8, 0)
    DismissButton.Text = "Dismiss"
    DismissButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DismissButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DismissButton.Parent = NotificationHolder

    DismissButton.MouseButton1Click:Connect(function()
        NotificationHolder:Destroy()
        NotificationCount = NotificationCount - 1
        for i = 1, #NotificationQueue do
            local queuedNotification = NotificationQueue[i]
            queuedNotification.Position = UDim2.new(1, -5, 1, -100 - (i - 1) * 110)
        end
    end)

    table.insert(NotificationQueue, NotificationHolder)
    
    NotificationHolder:TweenPosition(UDim2.new(1, -5, 1, -100), "Out", "Quad", 0.5)
    wait(5)
    NotificationHolder:TweenPosition(UDim2.new(1, -5, 1, -100 - (NotificationCount - 1) * 110), "Out", "Quad", 0.5)
end

function Notification:Notify(title, description)
    createNotification(title, description)
end

return CreateNotification

