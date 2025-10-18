-- ENHANCED HWID WHITELIST SYSTEM
-- Advanced protection with clean UI

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Anti-tamper checks to prevent basic bypasses
local function securityCheck()
    local checks = {
        game:GetService("RbxAnalyticsService"),
        game:GetService("HttpService"),
        LocalPlayer
    }
    for _, service in ipairs(checks) do
        if not service then return false end
    end
    return true
end

-- Get HWID with validation
local function getHWID()
    if not securityCheck() then return nil end
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

-- Fetch whitelist with retry logic and cache busting
local function fetchWhitelist(url)
    for attempt = 1, 3 do
        local success, result = pcall(function()
            return game:HttpGet(url .. "?v=" .. os.time())
        end)
        
        if success then
            local parseSuccess, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if parseSuccess and type(data) == "table" then
                return data, nil
            end
        end
        task.wait(0.5)
    end
    return nil, "Failed to fetch whitelist"
end

-- Create beautiful UI
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    local Blur = Instance.new("BlurEffect")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local Shadow = Instance.new("Frame")
    local ShadowCorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Subtitle = Instance.new("TextLabel")
    local Divider = Instance.new("Frame")
    local Status = Instance.new("TextLabel")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")
    local BarCorner = Instance.new("UICorner")
    local FillCorner = Instance.new("UICorner")
    local HWIDContainer = Instance.new("Frame")
    local ContainerCorner = Instance.new("UICorner")
    local HWIDText = Instance.new("TextLabel")
    local CopyBtn = Instance.new("TextButton")
    local CopyCorner = Instance.new("UICorner")
    local ActionBtn = Instance.new("TextButton")
    local ActionCorner = Instance.new("UICorner")
    
    ScreenGui.Name = "HWIDVerify_" .. math.random(1000, 9999)
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Blur.Parent = game.Lighting
    Blur.Size = 0
    
    Shadow.Name = "Shadow"
    Shadow.Parent = ScreenGui
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.6
    Shadow.Position = UDim2.new(0.5, -205, 0.5, -165)
    Shadow.Size = UDim2.new(0, 410, 0, 330)
    ShadowCorner.CornerRadius = UDim.new(0, 14)
    ShadowCorner.Parent = Shadow
    
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Main.Position = UDim2.new(0.5, -200, 0.5, -170)
    Main.Size = UDim2.new(0, 400, 0, 340)
    Main.Active = true
    Main.Draggable = true
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main
    UIStroke.Color = Color3.fromRGB(70, 70, 90)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = Main
    
    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🔒 HWID VERIFICATION"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    
    Subtitle.Parent = Main
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 0, 0, 55)
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Verifying your access permissions..."
    Subtitle.TextColor3 = Color3.fromRGB(170, 170, 190)
    Subtitle.TextSize = 13
    
    Divider.Parent = Main
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 25, 0, 85)
    Divider.Size = UDim2.new(1, -50, 0, 1)
    
    ProgressBar.Parent = Main
    ProgressBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ProgressBar.Position = UDim2.new(0, 25, 0, 95)
    ProgressBar.Size = UDim2.new(1, -50, 0, 4)
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = ProgressBar
    
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = ProgressFill
    
    Status.Parent = Main
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 25, 0, 110)
    Status.Size = UDim2.new(1, -50, 0, 25)
    Status.Font = Enum.Font.GothamMedium
    Status.Text = "⏳ Initializing..."
    Status.TextColor3 = Color3.fromRGB(255, 200, 100)
    Status.TextSize = 14
    Status.TextXAlignment = Enum.TextXAlignment.Left
    
    HWIDContainer.Parent = Main
    HWIDContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    HWIDContainer.Position = UDim2.new(0, 25, 0, 145)
    HWIDContainer.Size = UDim2.new(1, -50, 0, 100)
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = HWIDContainer
    
    HWIDText.Parent = HWIDContainer
    HWIDText.BackgroundTransparency = 1
    HWIDText.Position = UDim2.new(0, 12, 0, 12)
    HWIDText.Size = UDim2.new(1, -24, 1, -56)
    HWIDText.Font = Enum.Font.Code
    HWIDText.Text = ""
    HWIDText.TextColor3 = Color3.fromRGB(140, 140, 160)
    HWIDText.TextSize = 11
    HWIDText.TextXAlignment = Enum.TextXAlignment.Left
    HWIDText.TextYAlignment = Enum.TextYAlignment.Top
    HWIDText.TextWrapped = true
    
    CopyBtn.Parent = HWIDContainer
    CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    CopyBtn.Position = UDim2.new(0, 10, 1, -36)
    CopyBtn.Size = UDim2.new(1, -20, 0, 30)
    CopyBtn.Font = Enum.Font.GothamMedium
    CopyBtn.Text = "📋 Copy HWID"
    CopyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    CopyBtn.TextSize = 12
    CopyBtn.Visible = false
    CopyCorner.CornerRadius = UDim.new(0, 6)
    CopyCorner.Parent = CopyBtn
    
    ActionBtn.Parent = Main
    ActionBtn.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
    ActionBtn.Position = UDim2.new(0.5, -75, 1, -50)
    ActionBtn.Size = UDim2.new(0, 150, 0, 38)
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.Text = "Close"
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.TextSize = 14
    ActionBtn.Visible = false
    ActionCorner.CornerRadius = UDim.new(0, 8)
    ActionCorner.Parent = ActionBtn
    
    -- Hover effects
    local function addHover(btn, normal, hover)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hover}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normal}):Play()
        end)
    end
    
    addHover(CopyBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(55, 55, 75))
    addHover(ActionBtn, Color3.fromRGB(88, 166, 255), Color3.fromRGB(98, 176, 255))
    
    -- Copy functionality
    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            local hwid = HWIDText.Text:match("HWID: ([^\n]+)")
            if hwid then
                setclipboard(hwid)
                CopyBtn.Text = "✅ Copied!"
                task.wait(1.5)
                CopyBtn.Text = "📋 Copy HWID"
            end
        end
    end)
    
    -- Close button
    ActionBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        TweenService:Create(Main, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -200, 1.5, 0)}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
        Blur:Destroy()
    end)
    
    -- Entrance animation
    Main.Position = UDim2.new(0.5, -200, -0.5, 0)
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 12}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -200, 0.5, -170)
    }):Play()
    
    return {
        GUI = ScreenGui,
        Status = Status,
        HWIDText = HWIDText,
        CopyBtn = CopyBtn,
        ActionBtn = ActionBtn,
        ProgressFill = ProgressFill,
        Blur = Blur,
        Main = Main
    }
end

-- Main verification
local function verify(config)
    config = config or {}
    local url = config.WhitelistURL or "https://pastebin.com/raw/YOUR_PASTE"
    local discord = config.Discord or "your-server"
    
    local ui = createUI()
    
    local function updateProgress(progress)
        TweenService:Create(ui.ProgressFill, TweenInfo.new(0.3), {
            Size = UDim2.new(progress, 0, 1, 0)
        }):Play()
    end
    
    task.wait(0.6)
    
    -- Step 1: Security
    ui.Status.Text = "🔍 Running security checks..."
    updateProgress(0.25)
    task.wait(0.4)
    
    if not securityCheck() then
        ui.Status.Text = "❌ Security check failed"
        ui.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        ui.ActionBtn.Visible = true
        ui.ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        task.wait(3)
        LocalPlayer:Kick("Security violation detected")
        return false
    end
    
    -- Step 2: HWID
    ui.Status.Text = "🔑 Retrieving HWID..."
    updateProgress(0.5)
    task.wait(0.4)
    
    local hwid = getHWID()
    if not hwid then
        ui.Status.Text = "❌ Failed to get HWID"
        ui.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        ui.ActionBtn.Visible = true
        ui.ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        task.wait(3)
        LocalPlayer:Kick("HWID error")
        return false
    end
    
    ui.HWIDText.Text = "HWID: " .. hwid
    
    -- Step 3: Fetch
    ui.Status.Text = "📡 Connecting to server..."
    updateProgress(0.75)
    task.wait(0.4)
    
    local whitelist, err = fetchWhitelist(url)
    if not whitelist then
        ui.Status.Text = "❌ " .. (err or "Connection failed")
        ui.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        ui.ActionBtn.Visible = true
        ui.ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        task.wait(3)
        LocalPlayer:Kick("Server error: " .. (err or "Unknown"))
        return false
    end
    
    -- Step 4: Verify
    ui.Status.Text = "🔐 Verifying access..."
    updateProgress(0.9)
    task.wait(0.5)
    
    local whitelisted = false
    for _, id in ipairs(whitelist) do
        if tostring(id):lower() == tostring(hwid):lower() then
            whitelisted = true
            break
        end
    end
    
    updateProgress(1)
    
    if whitelisted then
        ui.Status.Text = "✅ Access Granted!"
        ui.Status.TextColor3 = Color3.fromRGB(100, 255, 150)
        ui.ProgressFill.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        task.wait(1.2)
        
        TweenService:Create(ui.Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        TweenService:Create(ui.Main, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -200, -0.5, 0)
        }):Play()
        task.wait(0.3)
        
        ui.GUI:Destroy()
        ui.Blur:Destroy()
        return true
    else
        ui.Status.Text = "❌ Access Denied"
        ui.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        ui.ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        ui.HWIDText.Text = ui.HWIDText.Text .. "\n\n⚠️ Not whitelisted\nCopy your HWID and submit it\n\n🔗 Discord: discord.gg/" .. discord
        ui.CopyBtn.Visible = true
        ui.ActionBtn.Visible = true
        ui.ActionBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        ui.ActionBtn.Text = "Get Whitelisted"
        
        ui.ActionBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("discord.gg/" .. discord)
            end
        end)
        
        task.wait(12)
        LocalPlayer:Kick("Not whitelisted. Discord: discord.gg/" .. discord)
        return false
    end
end

return {
    Verify = verify,
    GetHWID = getHWID
}
