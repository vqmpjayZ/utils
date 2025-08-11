local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/laboratory/refs/heads/main/ArrayField/Key/AKS.lua"))()
KeySystem:CreateKeyUI({
    Title = "Vadrifts Key System",
    Subtitle = "This script is protected with a key system.",
    Note = "If your executor doesn't have a workspace folder you may need to save your key.",
    Keys = {},
    SaveKey = true,
    FileName = "Vadrifts_GAGkey",
    GrabKeyFromSite = {
        Enabled = true,
        KeyDestination = "https://vadrifts-key-system.onrender.com/create?hwid="
    },
    VIP = {
        Enabled = true,
        PastebinURL = "https://pastebin.com/raw/72e29gbA",
        LocalList = {}
    },
    Action = {
        Link = "https://vadrifts-key-system.onrender.com",
    },
    Callback = function()
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/vqmpjayZ/laboratory/refs/heads/main/ArrayFieldGen2.lua'))()
local playerName = game.Players.LocalPlayer.Name
local Window = Rayfield:CreateWindow({
    Name = "Vadrifts Grow a Garden｜dsc.gg/vadriftz｜v1",
    LoadingTitle = "Vadrifts Grow a Garden",
    LoadingSubtitle = "Welcome " .. playerName .. "!",
    OldTabLayout = true,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Big Hub",
    },
    Discord = {
        Enabled = true,
        Invite = "dsc.gg/vadriftz",
        RememberJoins = true,
    },
    KeySystem = false,
    KeySettings = {
        Title = "key at:",
        Subtitle = "https://dsc.gg/vadriftz",
        Note = "The key changes every 2 decades or so!",
        FileName = "SiriusKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "TalkingBen2",
    },
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local character = player.Character or player.CharacterAdded:Wait()

local Home = Window:CreateTab("Home", "home")
local Section = Home:CreateSection("▶ Welcome", false)

local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

Home:CreateButton({
    Name = "Welcome " .. playerName .. " Join our discord: dsc.gg/vadriftz",
    Interact = "Copy Discord",
    SectionParent= Section,
    Callback = function()
AllClipboards("https://discord.gg/WDbJ5wE2cR")
    end
})

Home:CreateButton({
    Name = "Discord | Click To Copy",
    Interact = "Copy",
    SectionParent= Section,
    Callback = function()
        Rayfield:Notify({
            Title = "Are you sure you want to copy our discord link?",
            Content = "Just checking ykyk ;)",
            Duration = 6.5,
            Image = 12967561554,
            Actions = {
                Execute = {
                    Name = "yhyh",
                    Callback = function()
                        AllClipboards("https://discord.gg/WDbJ5wE2cR")
                        Rayfield:Notify({
                            Title = "Copwied to youw cwipwoad!!! XD OwO",
                            Content = "Discord link has been copied to your clipboard.",
                            Duration = 3.5,
                            Image = 12967561554
                        })
                    end
                },
                Ignore = {
                    Name = "nah",
                    Callback = function()
                        AllClipboards("https://discord.gg/WDbJ5wE2cR")
                        Rayfield:Notify({
                            Title = "Fuck you. i'll copy it anyways.",
                            Content = "Discord link has been copied to your clipboard.",
                            Duration = 3.5,
                            Image = 12967561554
                        })
                    end
                },
            },
        })
    end
})

local Section1 = Home:CreateSection("▶ Interface", false)

Home:CreateButton({
    Name = "Close Interface",
    Interact = "Destroy",
    SectionParent= Section1,
    Callback = function()
        Rayfield:Destroy()
    end
})

local Credits = Home:CreateSection("▶ Credits", false)
Home:CreateLabel("[+] vqmpjay - Script Owner & Developer", Credits)

local Main = Window:CreateTab("Client", "user")
local SecTools = Main:CreateSection("Tools", false)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

Main:CreateButton({
    Name = "[CLIENT] Obtain Recall Wrench (No cooldown + ∞ Uses)",
    Interact = "Obtain",
    SectionParent= SecTools,
    Callback = function()
        if player.Backpack:FindFirstChild("Recall Wrench [∞x Uses]") or (player.Character and player.Character:FindFirstChild("Recall Wrench [∞x Uses]")) then
            Rayfield:Notify({
                Title = "You already hav this.",
                Content = "You already have this item in your inventory.",
                Duration = 6.5,
                Image = "shield-alert"
            })
            return
        end

        local tool = Instance.new("Tool")
        tool.Name = "Recall Wrench [∞x Uses]"
        tool.ToolTip = "Teleports to gear shop"
        tool.RequiresHandle = true
        tool.CanBeDropped = false

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.Transparency = 1
        handle.CanCollide = false
        handle.Parent = tool

        tool.Activated:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(-285, 3, -14) * CFrame.Angles(0, -4.7, 0)
            end
        end)

        tool.Parent = player.Backpack
    end
})

Main:CreateButton({
    Name = "Click to TP tool",
    Interact = "Obtain",
    SectionParent= SecTools,
    Callback = function()
        if player.Backpack:FindFirstChild("Teleport tool") or (player.Character and player.Character:FindFirstChild("Teleport tool")) then
            Rayfield:Notify({
                Title = "You already hav this.",
                Content = "You already have this item in your inventory.",
                Duration = 6.5,
                Image = "shield-alert"
            })
            return
        end

        local mouse = player:GetMouse()

        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Teleport tool"
        tool.ToolTip = "Click anywhere to teleport there"

        local function teleportToPosition(position)
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local camera = workspace.CurrentCamera
                local lookDirection = (position - camera.CFrame.Position).Unit
                local newCFrame = CFrame.lookAt(Vector3.new(position.X, position.Y + 2.5, position.Z), Vector3.new(position.X, position.Y + 2.5, position.Z) + Vector3.new(lookDirection.X, 0, lookDirection.Z))
                player.Character.HumanoidRootPart.CFrame = newCFrame
            end
        end

        tool.Activated:Connect(function()
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                local camera = workspace.CurrentCamera
                local unitRay = camera:ScreenPointToRay(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {player.Character}

                local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
                if raycastResult then
                    teleportToPosition(raycastResult.Position)
                end
            else
                teleportToPosition(mouse.Hit.Position)
            end
        end)

        tool.Parent = player.Backpack
    end
})

local LP = Main:CreateSection("Player modifications", false)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

Main:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    SectionParent = LP,
    Callback = function(Value)
        if Value and not _G.AntiAFKConnection then
            _G.AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        elseif not Value and _G.AntiAFKConnection then
            _G.AntiAFKConnection:Disconnect()
            _G.AntiAFKConnection = nil
        end
    end,
})

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid", 2)
end

local humanoid = getHumanoid()
if humanoid then
    local defaultWalkSpeed = humanoid.WalkSpeed
    local defaultJumpPower = humanoid.JumpPower

    Main:CreateSlider({
        Name = "WalkSpeed",
        Info = "Set the character's walking speed.",
        Range = {defaultWalkSpeed, 350},
        SectionParent = LP,
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = defaultWalkSpeed,
        Flag = "WalkSpeedSlider",
        Callback = function(Value)
            humanoid.WalkSpeed = Value
        end    
    })

    Main:CreateSlider({
        Name = "JumpPower",
        Info = "Set the character's jump power.",
        Range = {defaultJumpPower, 350},
        SectionParent = LP,
        Increment = 1,
        Suffix = "JumpPower",
        CurrentValue = defaultJumpPower,
        Flag = "JumpPowerSlider",
        Callback = function(Value)
            humanoid.JumpPower = Value
        end    
    })
else
    warn("Humanoid not found.")
end

-- Sell stuff

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Leaderstats = LocalPlayer.leaderstats
local Backpack = LocalPlayer.Backpack
local ShecklesCount = Leaderstats.Sheckles
local GameEvents = ReplicatedStorage.GameEvents

local IsSelling = false
local AutoSellEnabled = false
local SellThreshold = 15

local function GetSeedInfo(Seed)
    local PlantName = Seed:FindFirstChild("Plant_Name")
    local Count = Seed:FindFirstChild("Numbers")
    if not PlantName then return end
    
    return PlantName.Value, Count.Value
end

local function CollectCropsFromParent(Parent, Crops)
    for _, Tool in next, Parent:GetChildren() do
        local Name = Tool:FindFirstChild("Item_String")
        if not Name then continue end
        
        table.insert(Crops, Tool)
    end
end

local function GetInvCrops()
    local Character = LocalPlayer.Character
    
    local Crops = {}
    CollectCropsFromParent(Backpack, Crops)
    CollectCropsFromParent(Character, Crops)
    
    return Crops
end

local function SellInventory()
    local Character = LocalPlayer.Character
    local Previous = Character:GetPivot()
    local PreviousSheckles = ShecklesCount.Value
    
    if IsSelling then return end
    IsSelling = true
    
    Character:PivotTo(CFrame.new(90, 4, 0))
    while wait() do
        if ShecklesCount.Value ~= PreviousSheckles then break end
        GameEvents.Sell_Inventory:FireServer()
    end
    Character:PivotTo(Previous)
    
    wait(0.04)
    IsSelling = false
end

local function AutoSellCheck()
    local crops = GetInvCrops()
    local CropCount = #crops
    
    if not AutoSellEnabled then return end
    if CropCount < SellThreshold then return end

    SellInventory()
end

local Selling = Window:CreateTab("Sell", "dollar-sign")
local Sells = Selling:CreateSection("-Auto Sell-", false)

Selling:CreateButton({
    Name = "Sell Inventory",
    Interact = "Sell",
    SectionParent = Sells,
    Callback = function()
        local crops = GetInvCrops()
        if crops and #crops > 0 then
            SellInventory()
        end
    end
})


Selling:CreateToggle({
    Name = "Auto-Sell",
    CurrentValue = false,
    SectionParent = Sells,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        AutoSellEnabled = Value
    end
})

Selling:CreateSlider({
    Name = "Crops Threshold",
    Range = {1, 199},
    Increment = 1,
    CurrentValue = 15,
    SectionParent = Sells,
    Description = "The amount of crops you'll have in your inventory before auto selling",
    Flag = "SellThresholdSlider",
    Callback = function(Value)
        SellThreshold = Value
    end
})

Backpack.ChildAdded:Connect(AutoSellCheck)
local SellArea = Selling:CreateSection("-Insta Sell-", false)

local SellStand = workspace.NPCS["Sell Stands"]
local RegionPart
local lastTouch = 0
local extension = 4

local function CreateSellArea()
    if RegionPart then RegionPart:Destroy() end
    if not SellStand then return end
    local cf, size = SellStand:GetBoundingBox()
    size = size + Vector3.new(0, 0, extension)
    RegionPart = Instance.new("Part")
    RegionPart.Name = "AutoSellZone"
    RegionPart.Size = size
    RegionPart.Anchored = true
    RegionPart.CanCollide = false
    RegionPart.Transparency = 0.6
    RegionPart.Color = Color3.fromRGB(255, 255, 0)
    RegionPart.Parent = workspace
    local forward = cf.LookVector
    local offset = -forward * (extension / 2)
    RegionPart.CFrame = cf + offset
    RegionPart.Touched:Connect(function(hit)
        if not AutoSellEnabled then return end
        if tick() - lastTouch < 1 then return end
        local char = LocalPlayer.Character
        if not char then return end
        if not hit or not hit:IsDescendantOf(char) then return end
        local crops = GetInvCrops()
        if not crops or #crops == 0 then return end
        lastTouch = tick()
        task.delay(0.15, function()
            GameEvents.Sell_Inventory:FireServer()
        end)
    end)
end

Selling:CreateToggle({
    Name = "Auto Sell Zone",
    CurrentValue = false,
    SectionParent = SellArea,
    Flag = "AutoSellZone",
    Description = "Spawns an area around the Sell Stand which when you're inside of it you sell your inventory.",
    Callback = function(state)
        AutoSellEnabled = state
        if state then
            CreateSellArea()
        else
            if RegionPart then
                RegionPart:Destroy()
                RegionPart = nil
            end
        end
    end,
})

local StockBotTab = Window:CreateTab("Stock Bot", "trending-up")
local WebhookSection = StockBotTab:CreateSection("Webhook Settings", false)
local NotificationSection = StockBotTab:CreateSection("Local Notifications", false)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

if isfile("webhook_url.txt") then
    local SavedWebhook = readfile("webhook_url.txt")
    _G.StockBotConfig = {
        WebhookEnabled = false,
        WebhookURL = SavedWebhook,
        LocalNotifications = false,
        WeatherReporting = false,
        AlertLayouts = {
            ["Weather"] = {
                EmbedColor = Color3.fromRGB(42, 109, 255),
            },
            ["SeedsAndGears"] = {
                EmbedColor = Color3.fromRGB(56, 238, 23),
                Layout = {
                    ["ROOT/SeedStock/Stocks"] = "SEEDS STOCK",
                    ["ROOT/GearStock/Stocks"] = "GEAR STOCK"
                }
            },
            ["EventShop"] = {
                EmbedColor = Color3.fromRGB(212, 42, 255),
                Layout = {
                    ["ROOT/EventShopStock/Stocks"] = "EVENT STOCK"
                }
            },
            ["Eggs"] = {
                EmbedColor = Color3.fromRGB(251, 255, 14),
                Layout = {
                    ["ROOT/PetEggStock/Stocks"] = "EGG STOCK"
                }
            },
            ["CosmeticStock"] = {
                EmbedColor = Color3.fromRGB(255, 106, 42),
                Layout = {
                    ["ROOT/CosmeticStock/ItemStocks"] = "COSMETIC ITEMS STOCK"
                }
            }
        }
    }
else
    _G.StockBotConfig = {
        WebhookEnabled = false,
        WebhookURL = "",
        LocalNotifications = false,
        WeatherReporting = false,
        AlertLayouts = {
            ["Weather"] = {
                EmbedColor = Color3.fromRGB(42, 109, 255),
            },
            ["SeedsAndGears"] = {
                EmbedColor = Color3.fromRGB(56, 238, 23),
                Layout = {
                    ["ROOT/SeedStock/Stocks"] = "SEEDS STOCK",
                    ["ROOT/GearStock/Stocks"] = "GEAR STOCK"
                }
            },
            ["EventShop"] = {
                EmbedColor = Color3.fromRGB(212, 42, 255),
                Layout = {
                    ["ROOT/EventShopStock/Stocks"] = "EVENT STOCK"
                }
            },
            ["Eggs"] = {
                EmbedColor = Color3.fromRGB(251, 255, 14),
                Layout = {
                    ["ROOT/PetEggStock/Stocks"] = "EGG STOCK"
                }
            },
            ["CosmeticStock"] = {
                EmbedColor = Color3.fromRGB(255, 106, 42),
                Layout = {
                    ["ROOT/CosmeticStock/ItemStocks"] = "COSMETIC ITEMS STOCK"
                }
            }
        }
    }
end

local function PlayNotificationSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

local function ConvertColor3ToHex(Color)
    local Hex = Color:ToHex()
    return tonumber(Hex, 16)
end

local function GetDataPacket(Data, Target)
    for _, Packet in Data do
        local Name = Packet[1]
        local Content = Packet[2]
        if Name == Target then
            return Content
        end
    end
    return nil
end

local function MakeStockString(Stock)
    local String = ""
    for Name, Data in Stock do 
        local Amount = Data.Stock
        local EggName = Data.EggName 
        Name = EggName or Name
        String = String .. Name .. " x" .. Amount .. "\n"
    end
    return String
end

local function SendWebhook(Type, Fields)
    if not _G.StockBotConfig.WebhookEnabled or _G.StockBotConfig.WebhookURL == "" then return end
    
    local Layout = _G.StockBotConfig.AlertLayouts[Type]
    local Color = ConvertColor3ToHex(Layout.EmbedColor)
    
    local TimeStamp = DateTime.now():ToIsoDate()
    local Body = {
        embeds = {
            {
                color = Color,
                fields = Fields,
                footer = {
                    text = "Stock Bot"
                },
                timestamp = TimeStamp
            }
        }
    }
    
    local RequestData = {
        Url = _G.StockBotConfig.WebhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(Body)
    }
    
    task.spawn(function()
        pcall(function()
            request(RequestData)
        end)
    end)
end

local function SendLocalNotification(Title, Content)
    if not _G.StockBotConfig.LocalNotifications then return end
    
    PlayNotificationSound()
    Rayfield:Notify({
        Title = Title,
        Content = Content,
        Duration = 5,
        Image = "trending-up"
    })
end

local function ProcessStockPacket(Data, Type, Layout)
    local Fields = {}
    local FieldsLayout = Layout.Layout
    if not FieldsLayout then return end
    
    for Packet, Title in FieldsLayout do 
        local Stock = GetDataPacket(Data, Packet)
        if not Stock then return end
        
        local StockString = MakeStockString(Stock)
        local Field = {
            name = Title,
            value = StockString,
            inline = true
        }
        table.insert(Fields, Field)
    end
    
    SendWebhook(Type, Fields)
    if #Fields > 0 then
        SendLocalNotification("Stock Restock", "Items have been restocked in the shop!")
    end
end

StockBotTab:CreateInput({
    Name = "Discord Webhook URL",
    PlaceholderText = "https://discord.com/api/webhooks/...",
    RemoveTextAfterFocusLost = false,
    SectionParent = WebhookSection,
    Callback = function(Text)
        _G.StockBotConfig.WebhookURL = Text
        writefile("webhook_url.txt", Text)
        
        if Text ~= "" and not Text:match("^https://discord%.com/api/webhooks/%d+/[%w%-_]+$") then
            Rayfield:Notify({
                Title = "Invalid Webhook",
                Content = "Please enter a valid Discord webhook URL.",
                Duration = 4,
                Image = "x-circle"
            })
        end
    end,
})

StockBotTab:CreateToggle({
    Name = "Enable Webhook",
    CurrentValue = false,
    SectionParent = WebhookSection,
    Callback = function(Value)
        if Value then
            if _G.StockBotConfig.WebhookURL == "" then
                Rayfield:Notify({
                    Title = "No Webhook URL",
                    Content = "Please enter a Discord webhook URL first.",
                    Duration = 4,
                    Image = "alert-triangle"
                })
                return
            end
            
            if not _G.StockBotConfig.WebhookURL:match("^https://discord%.com/api/webhooks/%d+/[%w%-_]+$") then
                Rayfield:Notify({
                    Title = "Invalid Webhook",
                    Content = "Please enter a valid Discord webhook URL.",
                    Duration = 4,
                    Image = "x-circle"
                })
                return
            end
        end
        
        _G.StockBotConfig.WebhookEnabled = Value
        
        if Value then
            if _G.StockBotActive then return end
            _G.StockBotActive = true
            
            local DataStream = ReplicatedStorage:FindFirstChild("GameEvents") and ReplicatedStorage.GameEvents:FindFirstChild("DataStream")
            local WeatherEventStarted = ReplicatedStorage:FindFirstChild("GameEvents") and ReplicatedStorage.GameEvents:FindFirstChild("WeatherEventStarted")
            
            if DataStream then
                _G.DataStreamConnection = DataStream.OnClientEvent:Connect(function(Type, Profile, Data)
                    if Type ~= "UpdateData" then return end
                    if not Profile:find(LocalPlayer.Name) then return end
                    
                    for Name, Layout in _G.StockBotConfig.AlertLayouts do
                        ProcessStockPacket(Data, Name, Layout)
                    end
                end)
            end
            
            if WeatherEventStarted and _G.StockBotConfig.WeatherReporting then
                _G.WeatherConnection = WeatherEventStarted.OnClientEvent:Connect(function(Event, Length)
                    local ServerTime = math.round(workspace:GetServerTimeNow())
                    local EndUnix = ServerTime + Length
                    
                    SendWebhook("Weather", {
                        {
                            name = "WEATHER",
                            value = Event .. "\nEnds:<t:" .. EndUnix .. ":R>",
                            inline = true
                        }
                    })
                    
                    SendLocalNotification("Weather Event", Event .. " event started!")
                end)
            end
        else
            _G.StockBotActive = false
            if _G.DataStreamConnection then
                _G.DataStreamConnection:Disconnect()
                _G.DataStreamConnection = nil
            end
            if _G.WeatherConnection then
                _G.WeatherConnection:Disconnect()
                _G.WeatherConnection = nil
            end
        end
    end,
})

StockBotTab:CreateToggle({
    Name = "Weather Reporting",
    CurrentValue = false,
    SectionParent = WebhookSection,
    Callback = function(Value)
        _G.StockBotConfig.WeatherReporting = Value
    end,
})

StockBotTab:CreateToggle({
    Name = "Local Notifications",
    CurrentValue = false,
    SectionParent = NotificationSection,
    Callback = function(Value)
        _G.StockBotConfig.LocalNotifications = Value
    end,
})

StockBotTab:CreateButton({
    Name = "Test Webhook",
    Interact = "Test",
    SectionParent = WebhookSection,
    Callback = function()
        if _G.StockBotConfig.WebhookURL == "" then
            Rayfield:Notify({
                Title = "No Webhook URL",
                Content = "Please enter a Discord webhook URL first.",
                Duration = 4,
                Image = "alert-triangle"
            })
            return
        end
        
        if not _G.StockBotConfig.WebhookURL:match("^https://discord%.com/api/webhooks/%d+/[%w%-_]+$") then
            Rayfield:Notify({
                Title = "Invalid Webhook",
                Content = "Please enter a valid Discord webhook URL.",
                Duration = 4,
                Image = "x-circle"
            })
            return
        end
        
        local TestFields = {
            {
                name = "TEST MESSAGE",
                value = "Webhook test successful!",
                inline = true
            }
        }
        
        SendWebhook("SeedsAndGears", TestFields)
        
        Rayfield:Notify({
            Title = "Webhook Test Sent",
            Content = "Test message sent successfully to Discord.",
            Duration = 4,
            Image = "check"
        })
    end,
})

StockBotTab:CreateButton({
    Name = "Test Local Notification",
    Interact = "Test",
    SectionParent = NotificationSection,
    Callback = function()
        SendLocalNotification("Test Notification", "Local notification test successful!")
    end,
})

local Teleports = Window:CreateTab("Teleportation", "users")
local TP = Teleports:CreateSection("Player Teleporter")

Teleports:CreateInput({
    Name = "Player User/Display:",
    PlaceholderText = "Username or Display name",
    RemoveTextAfterFocusLost = false,
    SectionParent = TP,
    Callback = function(Text)
        playerName = Text
    end,
})

local function teleportToPlayer(targetPlayer)
    if LocalPlayer and targetPlayer then
        local targetCharacter = targetPlayer.Character
        if character and targetCharacter then
            character:MoveTo(targetCharacter.PrimaryPart.Position)
        end
    end
end

local function findPlayer(name)
    local lowerName = string.lower(name)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lowerName) or string.find(string.lower(player.DisplayName), lowerName) then
            return player
        end
    end
    return nil
end

Teleports:CreateButton({
    Name = "Teleport",
    Interact = "Teleport",
    SectionParent = TP,
    Callback = function()
        local targetPlayer = findPlayer(playerName)
        if targetPlayer then
            teleportToPlayer(targetPlayer)
        else
        Rayfield:Notify({
            Title = "Error",
            Content = "Player not found.",
            Duration = 6.5,
            Image = 12967561554
        })
        end
    end,
})

local FarmTP = Teleports:CreateSection("Farm Teleportation", false)

local farmDropdown
local farmData = {}

local function getFarmOwnerInfo(username)
    if username == "" or username == nil then
        return nil, nil
    end
    
    local ownerPlayer = Players:FindFirstChild(username)
    if ownerPlayer then
        return username, ownerPlayer.DisplayName
    else
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)
        
        if success and userId then
            local success2, playerInfo = pcall(function()
                return Players:GetNameFromUserIdAsync(userId)
            end)
            
            if success2 then
                return username, username
            end
        end
        
        return username, username
    end
end

local function updateFarmList()
    local farms = workspace.Farm:GetChildren()
    local newFarmData = {}
    local dropdownOptions = {}
    
    for _, farm in pairs(farms) do
        if farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data") and farm.Important.Data:FindFirstChild("Owner") then
            local ownerUsername = farm.Important.Data.Owner.Value
            
            if ownerUsername and ownerUsername ~= "" then
                local username, displayName = getFarmOwnerInfo(ownerUsername)
                
                if username then
                    local farmLabel = username
                    
                    if displayName and displayName ~= username then
                        farmLabel = displayName .. " (@" .. username .. ")"
                    end
                    
                    newFarmData[farmLabel] = {
                        farm = farm,
                        username = username,
                        displayName = displayName or username
                    }
                    
                    table.insert(dropdownOptions, farmLabel)
                end
            end
        end
    end
    
    farmData = newFarmData
    
    if farmDropdown and #dropdownOptions > 0 then
        farmDropdown:Refresh(dropdownOptions)
    elseif farmDropdown then
        farmDropdown:Refresh({"No farms available"})
    end
end

local function teleportToFarm(farmObject)
    if farmObject and farmObject:FindFirstChild("Spawn_Point") then
        local spawnPoint = farmObject.Spawn_Point
        local teleportCFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = teleportCFrame})
            
            tween:Play()
        end
    end
end

farmDropdown = Teleports:CreateDropdown({
    Name = "Select farm to teleport to:",
    Options = {},
    SectionParent = FarmTP,
    CurrentOption = "None",
    Callback = function(selectedOption)
        if selectedOption ~= "No farms available" and farmData[selectedOption] then
            teleportToFarm(farmData[selectedOption].farm)
        end
    end,
})

updateFarmList()

spawn(function()
    while true do
        wait(2)
        updateFarmList()
    end
end)
    end
})
