local KeySystem = {}

local function createUI(title, note)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 180)
    frame.Position = UDim2.new(0.5, -250, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 35, 1, 35)
    shadow.Position = UDim2.new(0, -17, 0, -17)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 22
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(1, -20, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 40)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    subtitleLabel.TextSize = 16
    subtitleLabel.Text = "Key System"
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = frame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.7, -15, 0, 35)
    keyBox.Position = UDim2.new(0, 10, 0, 70)
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
    keyBoxStroke.Color = Color3.fromRGB(60, 60, 60)
    keyBoxStroke.Thickness = 1
    keyBoxStroke.Parent = keyBox

    local hideButton = Instance.new("ImageButton")
    hideButton.Size = UDim2.new(0, 20, 0, 20)
    hideButton.Position = UDim2.new(0.7, -40, 0, 77)
    hideButton.BackgroundTransparency = 1
    hideButton.Image = "rbxassetid://3926305904"
    hideButton.ImageRectOffset = Vector2.new(564, 564)
    hideButton.ImageRectSize = Vector2.new(36, 36)
    hideButton.Parent = frame

    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(0.25, 0, 0, 60)
    noteLabel.Position = UDim2.new(0.75, 0, 0, 70)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    noteLabel.TextSize = 14
    noteLabel.Text = note
    noteLabel.TextWrapped = true
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.TextYAlignment = Enum.TextYAlignment.Top
    noteLabel.Parent = frame

    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.7, -15, 0, 35)
    submitButton.Position = UDim2.new(0, 10, 0, 115)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.BorderSizePixel = 0
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextSize = 14
    submitButton.Text = "Submit"
    submitButton.Parent = frame

    local submitButtonCorner = Instance.new("UICorner")
    submitButtonCorner.CornerRadius = UDim.new(0, 6)
    submitButtonCorner.Parent = submitButton

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 14
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

    return screenGui, keyBox, submitButton
end

function KeySystem.new(settings)
    local self = setmetatable({}, {__index = KeySystem})
    self.settings = settings
    return self
end

function KeySystem:Init()
    local gui, keyBox, submitButton = createUI(self.settings.Title, self.settings.Note)

    local function shakeEffect()
        local originalPosition = gui.Frame.Position
        for i = 1, 5 do
            gui.Frame.Position = originalPosition + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
            wait(0.05)
        end
        gui.Frame.Position = originalPosition
    end

    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = keyBox.Text:gsub("•", "")
        if enteredKey == self.settings.Key then
            gui:Destroy()
            self.settings.OnCorrect()
        else
            self.settings.OnIncorrect()
            shakeEffect()
        end
    end)
end

return KeySystem
