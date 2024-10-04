local NotificationSystem = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotificationSystem"
ScreenGui.Parent = CoreGui

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 300, 1, 0)
NotificationFrame.Position = UDim2.new(1, -300, 0, 0)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotificationFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function CreateNotification(title, text, duration, buttonText, buttonCallback)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(1, 0, 0, buttonText and 90 or 70) -- Increase height if button is present
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.BackgroundTransparency = 1
    Notification.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Notification

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -10, 0, 25)
    TitleLabel.Position = UDim2.new(0, 5, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextTransparency = 1
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = title
    TitleLabel.Parent = Notification

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.Size = UDim2.new(1, -10, 0, buttonText and 35 or 45)
    TextLabel.Position = UDim2.new(0, 5, 0, 30)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.TextTransparency = 1
    TextLabel.TextSize = 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel.TextWrapped = true
    TextLabel.Text = text
    TextLabel.Parent = Notification

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.BackgroundTransparency = 1
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Notification

    if buttonText then
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Size = UDim2.new(0, 200, 0, 25)  -- Increased width to 200
        Button.Position = UDim2.new(0, 10, 1, -30)  -- Moved to the left
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- White background
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.Gotham
        Button.TextColor3 = Color3.fromRGB(0, 0, 0)  -- Black text
        Button.TextSize = 12
        Button.Text = buttonText
        Button.Parent = Notification

        local ButtonUICorner = Instance.new("UICorner")
        ButtonUICorner.CornerRadius = UDim.new(0, 5)
        ButtonUICorner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            if buttonCallback then
                buttonCallback()
            end
            -- Close the notification
            Notification:Destroy()
        end)
    end

    Notification.Parent = NotificationFrame

    -- Fade-in animation
    local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local fadeTween = TweenService:Create(Notification, fadeTweenInfo, {BackgroundTransparency = 0})
    local titleFadeTween = TweenService:Create(TitleLabel, fadeTweenInfo, {TextTransparency = 0})
    local textFadeTween = TweenService:Create(TextLabel, fadeTweenInfo, {TextTransparency = 0})
    local progressFadeTween = TweenService:Create(ProgressBar, fadeTweenInfo, {BackgroundTransparency = 0})
    
    fadeTween:Play()
    titleFadeTween:Play()
    textFadeTween:Play()
    progressFadeTween:Play()

    -- Progress bar animation
    local progressTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local progressTween = TweenService:Create(ProgressBar, progressTweenInfo, {Size = UDim2.new(0, 0, 0, 2)})
    progressTween:Play()

    -- Fade-out and destroy
    task.delay(duration, function()
        if not Notification.Parent then return end -- Check if notification still exists
        local fadeOutTween = TweenService:Create(Notification, fadeTweenInfo, {BackgroundTransparency = 1})
        local titleFadeOutTween = TweenService:Create(TitleLabel, fadeTweenInfo, {TextTransparency = 1})
        local textFadeOutTween = TweenService:Create(TextLabel, fadeTweenInfo, {TextTransparency = 1})
        local progressFadeOutTween = TweenService:Create(ProgressBar, fadeTweenInfo, {BackgroundTransparency = 1})
        
        fadeOutTween:Play()
        titleFadeOutTween:Play()
        textFadeOutTween:Play()
        progressFadeOutTween:Play()
        
        fadeOutTween.Completed:Wait()
        if Notification.Parent then
            Notification:Destroy()
        end
    end)
end

function NotificationSystem:Notify(title, text, duration, buttonText, buttonCallback)
    CreateNotification(title, text, duration, buttonText, buttonCallback)
end

return NotificationSystem
