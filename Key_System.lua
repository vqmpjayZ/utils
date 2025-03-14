--[[
 __   __   ______     _____     ______     __     ______   ______   ______    
/\ \ / /  /\  __ \   /\  __-.  /\  == \   /\ \   /\  ___\ /\__  _\ /\  ___\   
\ \ \'/   \ \  __ \  \ \ \/\ \ \ \  __<   \ \ \  \ \  __\ \/_/\ \/ \ \___  \ 
 \ \__|    \ \_\ \_\  \ \____-  \ \_\ \_\  \ \_\  \ \_\      \ \_\  \/\_____\ 
  \/_/      \/_/\/_/   \/____/   \/_/ /_/   \/_/   \/_/       \/_/   \/_____/ 
                              dsc.gg/vadriftz
--]]
--v3.2.4

local KeySystem = {}

local function createUI(title, note, onCorrect, onIncorrect, key)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999999

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 180)
    frame.Position = UDim2.new(0.5, -250, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.ZIndex = 999999999

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 50, 1, 39)
    shadow.Position = UDim2.new(-0.02, -10, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 999999998
    shadow.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0.02, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 16
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    titleLabel.ZIndex = 999999999
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(1, -20, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 32)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    subtitleLabel.TextSize = 14
    subtitleLabel.Text = "Key System"
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = frame
    subtitleLabel.ZIndex = 999999999

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 50, 0, 20)
    keyLabel.Position = UDim2.new(0, 10, 0, 65)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.Gotham
    keyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    keyLabel.TextSize = 14
    keyLabel.Text = "Key"
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = frame
    keyLabel.ZIndex = 999999999

    local hideButton = Instance.new("ImageButton")
    hideButton.Size = UDim2.new(0, 20, 0, 20)
    hideButton.Position = UDim2.new(0, 40, 0, 65)
    hideButton.BackgroundTransparency = 1
    hideButton.Image = "rbxassetid://3926305904"
    hideButton.ImageRectOffset = Vector2.new(564, 564)
    hideButton.ImageRectSize = Vector2.new(36, 36)
    hideButton.Parent = frame
    hideButton.ZIndex = 999999999

    local keyBoxContainer = Instance.new("Frame")
    keyBoxContainer.Size = UDim2.new(0.65, -55, 0.03, 35)
    keyBoxContainer.Position = UDim2.new(0, 10, 0, 90)
    keyBoxContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyBoxContainer.BorderSizePixel = 0
    keyBoxContainer.Parent = frame
    keyBoxContainer.ZIndex = 999999999
    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 5)
    keyBoxCorner.Parent = keyBoxContainer

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, 0, 1, 0)
    keyBox.Position = UDim2.new(0, 0, 0, 0)
    keyBox.BackgroundTransparency = 1
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.TextSize = 14
    keyBox.PlaceholderText = "Enter key here..."
    keyBox.Text = ""
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = keyBoxContainer
    keyBox.ZIndex = 999999999

    local clearButton = Instance.new("TextButton")
    clearButton.Size = UDim2.new(0, 35, 0, 35)
    clearButton.Position = UDim2.new(0.65, -50, 0, 90)
    clearButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    clearButton.BorderSizePixel = 0
    clearButton.Font = Enum.Font.Gotham
    clearButton.TextColor3 = Color3.new(1, 1, 1)
    clearButton.TextSize = 14
    clearButton.Text = "🗑️"
    clearButton.Parent = frame
    clearButton.ZIndex = 999999999

    local clearButtonCorner = Instance.new("UICorner")
    clearButtonCorner.CornerRadius = UDim.new(0, 6)
    clearButtonCorner.Parent = clearButton

    local noteTitle = Instance.new("TextLabel")
    noteTitle.Size = UDim2.new(0, 50, 0, 20)
    noteTitle.Position = UDim2.new(0.65, 10, 0, 60)
    noteTitle.BackgroundTransparency = 1
    noteTitle.Font = Enum.Font.GothamBold
    noteTitle.TextColor3 = Color3.fromRGB(100, 100, 100)
    noteTitle.TextSize = 14
    noteTitle.Text = "Note"
    noteTitle.TextXAlignment = Enum.TextXAlignment.Left
    noteTitle.Parent = frame
    noteTitle.ZIndex = 999999999

    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(0.35, -20, 0, 60)
    noteLabel.Position = UDim2.new(0.65, 10, 0, 85)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    noteLabel.TextSize = 15
    noteLabel.Text = note
    noteLabel.TextWrapped = true
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.TextYAlignment = Enum.TextYAlignment.Top
    noteLabel.Parent = frame
    noteLabel.ZIndex = 999999999

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 28
    closeButton.Text = "X"
    closeButton.Parent = frame
    closeButton.ZIndex = 999999999

    local trademark = Instance.new("TextLabel")
    trademark.Size = UDim2.new(0, 100, 0, 20)
    trademark.Position = UDim2.new(0, 10, 1, -25)
    trademark.BackgroundTransparency = 1
    trademark.Font = Enum.Font.Gotham
    trademark.TextColor3 = Color3.fromRGB(80, 80, 80)
    trademark.TextSize = 12
    trademark.Text = "by Vadrifts"
    trademark.TextXAlignment = Enum.TextXAlignment.Left
    trademark.Parent = frame
    trademark.ZIndex = 999999999

    local actualText = ""
    local isHidden = false

    local function updateVisibleText()
        if isHidden then
            keyBox.Text = string.rep("•", #actualText)
        else
            keyBox.Text = actualText
        end
    end

    hideButton.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        updateVisibleText()
        if isHidden then
            hideButton.ImageRectOffset = Vector2.new(524, 564)
        else
            hideButton.ImageRectOffset = Vector2.new(564, 564)
        end
    end)

    clearButton.MouseButton1Click:Connect(function()
        actualText = ""
        keyBox.Text = ""
    end)

    keyBox.Focused:Connect(function()
        keyBox.Text = actualText
    end)

    local function fadeEffect(obj, startTransparency, endTransparency)
        local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        obj.BackgroundTransparency = startTransparency
        local tween = game:GetService("TweenService"):Create(obj, info, {BackgroundTransparency = endTransparency})
        tween:Play()
        return tween
    end

    local function shakeEffect()
        local originalPosition = frame.Position
        for i = 1, 3 do
            frame.Position = originalPosition + UDim2.new(0, math.random(-3, 3), 0, math.random(-3, 3))
            task.wait(0.05)
        end
        frame.Position = originalPosition
    end

    keyBox.FocusLost:Connect(function(enterPressed)
        actualText = keyBox.Text
        updateVisibleText()
        if enterPressed then
            if actualText == key then
                game.Players.LocalPlayer:SetAttribute("SavedKey", actualText)
                local tween = fadeEffect(frame, 0, 1)
                tween.Completed:Wait()
                screenGui:Destroy()
                onCorrect()
            else
                onIncorrect()
                shakeEffect()
            end
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        local tween = fadeEffect(frame, 0, 1)
        tween.Completed:Wait()
        screenGui:Destroy()
    end)

    fadeEffect(frame, 1, 0)

    return screenGui, keyBox, closeButton, function() return actualText end
end

local KeySystem = {}

function KeySystem.new(settings)
    local self = setmetatable({}, {__index = KeySystem})
    self.settings = settings
    return self
end

function KeySystem:Init()
    local FileHandler = {
        SaveKeyToFile = function(key)
            local baseFilePath = "VadriftsKeySystem/Key"
            local filePath = baseFilePath
            local counter = 1
            
            if not isfolder("VadriftsKeySystem") then
                makefolder("VadriftsKeySystem")
            end
            
            while isfile(filePath) do
                filePath = baseFilePath .. counter
                counter = counter + 1
            end
            
            writefile(filePath, key)
            return filePath
        end,
        
        ReadKeyFromFile = function()
            local baseFilePath = "VadriftsKeySystem/Key"
            local filePath = baseFilePath
            local counter = 1
            
            while true do
                filePath = counter == 1 and baseFilePath or baseFilePath .. counter
                if isfile(filePath) then
                    local content = readfile(filePath)
                    if content == self.settings.Key then
                        return content
                    end
                else
                    if counter > 1 then
                        break
                    end
                end
                counter = counter + 1
            end
            return nil
        end
    }
    
    local savedKey = FileHandler.ReadKeyFromFile()
    if savedKey and savedKey == self.settings.Key then
        self.settings.OnCorrect()
        return
    end

    local gui, keyBox, closeButton, getActualText = createUI(
        self.settings.Title,
        self.settings.Note,
        function()
            FileHandler.SaveKeyToFile(self.settings.Key)
            self.settings.OnCorrect()
        end,
        self.settings.OnIncorrect,
        self.settings.Key
    )

    self.getActualText = getActualText
end

return KeySystem
