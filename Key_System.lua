local KeySystem = {} --hi

local function createUI(title, note)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 180)
    frame.Position = UDim2.new(0.5, -250, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 45, 1, 45)
    shadow.Position = UDim2.new(0, -22, 0, -22)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 20
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(1, -20, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 35)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    subtitleLabel.TextSize = 14
    subtitleLabel.Text = "Key System"
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = frame

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 50, 0, 20)
    keyLabel.Position = UDim2.new(0, 10, 0, 65)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    keyLabel.TextSize = 14
    keyLabel.Text = "Key"
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = frame

    local hideButton = Instance.new("ImageButton")
    hideButton.Size = UDim2.new(0, 20, 0, 20)
    hideButton.Position = UDim2.new(0, 40, 0, 65)
    hideButton.BackgroundTransparency = 1
    hideButton.Image = "rbxassetid://3926305904"
    hideButton.ImageRectOffset = Vector2.new(564, 564)
    hideButton.ImageRectSize = Vector2.new(36, 36)
    hideButton.Parent = frame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.65, -15, 0, 35)
    keyBox.Position = UDim2.new(0, 10, 0, 90)
    keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyBox.BorderSizePixel = 0
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.TextSize = 14
    keyBox.PlaceholderText = "Enter key here..."
    keyBox.Parent = frame

    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 6)
    keyBoxCorner.Parent = keyBox

    local keyBoxStroke = Instance.new("UIStroke")
    keyBoxStroke.Color = Color3.fromRGB(255, 255, 255)
    keyBoxStroke.Thickness = 1
    keyBoxStroke.Transparency = 0.9
    keyBoxStroke.Parent = keyBox

    local noteTitle = Instance.new("TextLabel")
    noteTitle.Size = UDim2.new(0, 50, 0, 20)
    noteTitle.Position = UDim2.new(0.65, 10, 0, 65)
    noteTitle.BackgroundTransparency = 1
    noteTitle.Font = Enum.Font.GothamBold
    noteTitle.TextColor3 = Color3.fromRGB(100, 100, 100)
    noteTitle.TextSize = 14
    noteTitle.Text = "Note"
    noteTitle.TextXAlignment = Enum.TextXAlignment.Left
    noteTitle.Parent = frame

    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(0.35, -20, 0, 60)
    noteLabel.Position = UDim2.new(0.65, 10, 0, 90)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    noteLabel.TextSize = 15
    noteLabel.Text = note
    noteLabel.TextWrapped = true
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.TextYAlignment = Enum.TextYAlignment.Top
    noteLabel.Parent = frame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 24
    closeButton.Text = "X"
    closeButton.Parent = frame

    local isHidden = false
    hideButton.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        if isHidden then
            keyBox.Text = string.rep("•", #keyBox.Text)
            hideButton.ImageRectOffset = Vector2.new(524, 564)
        else
            keyBox.Text = keyBox.Text:gsub("•", "")
            hideButton.ImageRectOffset = Vector2.new(564, 564)
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return screenGui, keyBox
end

function KeySystem.new(settings)
    local self = setmetatable({}, {__index = KeySystem})
    self.settings = settings
    return self
end

function KeySystem:Init()
    local gui, keyBox = createUI(self.settings.Title, self.settings.Note)

    local function fadeEffect(obj, goal)
        local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local tween = game:GetService("TweenService"):Create(obj, info, {BackgroundTransparency = goal})
        tween:Play()
    end

    fadeEffect(gui.Frame, 0)

    local function shakeEffect()
        local originalPosition = gui.Frame.Position
        for i = 1, 3 do
            gui.Frame.Position = originalPosition + UDim2.new(0, math.random(-3, 3), 0, math.random(-3, 3))
            wait(0.05)
        end
        gui.Frame.Position = originalPosition
    end

    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local enteredKey = keyBox.Text:gsub("•", "")
            if enteredKey == self.settings.Key then
                fadeEffect(gui.Frame, 1)
                wait(0.3)
                gui:Destroy()
                self.settings.OnCorrect()
            else
                self.settings.OnIncorrect()
                shakeEffect()
            end
        end
    end)

    gui.Frame.CloseButton.MouseButton1Click:Connect(function()
        fadeEffect(gui.Frame, 1)
        wait(0.3)
        gui:Destroy()
    end)
end

return KeySystem
