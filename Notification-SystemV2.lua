local NotifUI = Instance.new("ScreenGui")
local Holder = Instance.new("ScrollingFrame")
local Sorter = Instance.new("UIListLayout")

NotifUI.Name = "NotifUI"
NotifUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
NotifUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = NotifUI
Holder.Active = true
Holder.AnchorPoint = Vector2.new(1, 0)
Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Holder.BackgroundTransparency = 1.000
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1, -20, 0, 0)
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

function CreateNotification(Options)
    local Default = {
        Buttons = {
            [1] = {
                Title = 'Dismiss',
                ClosesUI = true,
                Callback = function() end
            }
        },
        Title = 'Notification Title',
        Content = 'Placeholder notification content',
        Length = 5,
        NeverExpire = false
    }
    Options = SetDefault(Options, Default)

    local Dismiss = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TextLabel = Instance.new("TextLabel")
    local TextLabel_2 = Instance.new("TextLabel")
    local TextButton = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")

    Dismiss.Name = "Notification"
    Dismiss.Parent = Holder
    Dismiss.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Dismiss.BackgroundTransparency = 0.300
    Dismiss.BorderSizePixel = 0
    Dismiss.Position = UDim2.new(1, 300, 0.55, 0)
    Dismiss.Size = UDim2.new(0, 350, 0, 150)
    Dismiss.Visible = false

    UICorner.Parent = Dismiss

    TextLabel.Parent = Dismiss
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    TextLabel.Size = UDim2.new(0, 300, 0, 29)
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.Text = Options.Title
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 16.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    TextLabel_2.Parent = Dismiss
    TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.BackgroundTransparency = 1.000
    TextLabel_2.Position = UDim2.new(0.05, 0, 0.3, 0)
    TextLabel_2.Size = UDim2.new(0, 300, 0, 52)
    TextLabel_2.Font = Enum.Font.Gotham
    TextLabel_2.Text = Options.Content
    TextLabel_2.TextColor3 = Color3.fromRGB(234, 234, 234)
    TextLabel_2.TextSize = 14.000
    TextLabel_2.TextWrapped = true
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = Dismiss
    ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0.05, -5, 0.9, 0)
    ProgressBar.Size = UDim2.new(0.9, 0, 0.03, 0)

    ProgressFill.Name = "ProgressFill"
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)

    if Options.Buttons[1] then
        TextButton.Parent = Dismiss
        TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.Position = UDim2.new(0.05, 0, 0.7, 0)
        TextButton.Size = UDim2.new(0, 300, 0, 29)
        TextButton.Font = Enum.Font.GothamMedium
        TextButton.Text = Options.Buttons[1].Title or "Dismiss"
        TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextButton.TextSize = 16.000
        UICorner_2.CornerRadius = UDim.new(0, 6)
        UICorner_2.Parent = TextButton
        TextButton.MouseButton1Click:Connect(function()
            if Options.Buttons[1].Callback then
                task.spawn(Options.Buttons[1].Callback)
            end
            if Options.Buttons[1].ClosesUI then
                Dismiss:Destroy()
            end
        end)
    end

    Dismiss.Visible = true

    local TweenService = game:GetService("TweenService")

    TweenService:Create(Dismiss, TweenInfo.new(0.5), {Position = UDim2.new(1, -20, 0.55, 0)}):Play()

    if not Options.NeverExpire then
        local timeRemaining = Options.Length or 5
        TweenService:Create(ProgressFill, TweenInfo.new(timeRemaining, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

        task.delay(timeRemaining, function()
            Dismiss:Destroy()
        end)
    end
end

return CreateNotification
