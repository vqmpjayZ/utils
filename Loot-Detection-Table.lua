--[[
FOR SURVIVE THE KILLER IN ROBLOX
 __   __   ______     _____     ______     __     ______   ______   ______  
/\ \ / /  /\  __ \   /\  __-.  /\  == \   /\ \   /\  ___\ /\__  _\ /\  ___\ 
\ \ \'/   \ \  __ \  \ \ \/\ \ \ \  __<   \ \ \  \ \  __\ \/_/\ \/ \ \___  \
 \ \__|    \ \_\ \_\  \ \____-  \ \_\ \_\  \ \_\  \ \_\      \ \_\  \/\_____\
  \/_/      \/_/\/_/   \/____/   \/_/ /_/   \/_/   \/_/       \/_/   \/_____/
]]

return {
    rarities = {
        Common = {
            name = "Common",
            color = Color3.fromRGB(255, 255, 255),
            coins = 2
        },
        Uncommon = {
            name = "Uncommon",
            color = Color3.fromRGB(0, 255, 0),
            coins = 5
        },
        Rare = {
            name = "Rare",
            color = Color3.fromRGB(0, 112, 255),
            coins = 7
        },
        Legendary = {
            name = "Legendary",
            color = Color3.fromRGB(255, 0, 255),
            coins = 20
        },
        Immortal = {
            name = "Immortal",
            color = Color3.fromRGB(255, 215, 0),
            coins = 40
        },
        Spectrum = {
            name = "Spectrum",
            color = Color3.fromRGB(255, 0, 0),
            coins = 150
        }
    },
    loot = {
        {
            name = "Broken Bottle",
            rarity = "Common",
            check = function(model)
                return model:FindFirstChild("Meshes/aBrokenBottle") ~= nil
            end
        },
        {
            name = "Rusty Lantern",
            rarity = "Common",
            check = function(model)
                local frame = model:FindFirstChild("Frame")
                return frame and frame:IsA("Part") and frame.BrickColor.Name == "Rust"
            end
        },
        {
            name = "Broken Lightbulb",
            rarity = "Common",
            check = function(model)
                return model:FindFirstChild("Light") ~= nil
            end
        },
        {
            name = "Rusty Screwdriver",
            rarity = "Common",
            check = function(model)
                local meshCount = 0
                local hasDeepBlue = false
                local hasReallyDark = false
                
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("MeshPart") or (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh")) then
                        meshCount = meshCount + 1
                        
                        if part.BrickColor.Name == "Deep blue" then
                            hasDeepBlue = true
                        elseif part.BrickColor.Name == "Really black" then
                            hasReallyDark = true
                        end
                    end
                end
                
                return meshCount == 2 and hasDeepBlue and hasReallyDark
            end
        },
        {
            name = "Glass Bottle",
            rarity = "Common",
            check = function(model)
                return model:FindFirstChild("Glass Bottle 1a") ~= nil
            end
        },
        {
            name = "Gasoline Canister",
            rarity = "Common",
            check = function(model)
                return model:FindFirstChild("GasolineCanister") ~= nil
            end
        },
        {
            name = "Shattered Glasses",
            rarity = "Common",
            check = function(model)
                local handleCount = 0
                for _, child in pairs(model:GetChildren()) do
                    if child.Name == "Handle" then
                        handleCount = handleCount + 1
                    end
                end
                return handleCount == 1 and model:FindFirstChild("Handle") ~= nil
            end
        },
        {
            name = "Rusty Kitchen Knife",
            rarity = "Uncommon",
            check = function(model)
                local meshCount = 0
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("MeshPart") then
                        meshCount = meshCount + 1
                    end
                end
                return meshCount == 3
            end
        },
        {
            name = "Tire/Wheel",
            rarity = "Uncommon",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("MeshPart") and part.Name == "MeshPart" then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Rusty Pipe",
            rarity = "Uncommon",
            check = function(model)
                local mesh = model:FindFirstChild("Mesh")
                return mesh and mesh:IsA("Part") and
                        mesh.BrickColor.Name == "Institutional white" and
                        mesh.Material == Enum.Material.CorrodedMetal
            end
        },
        {
            name = "Boombox",
            rarity = "Uncommon",
            check = function(model)
                local handle = model:FindFirstChild("Handle")
                return handle and handle:IsA("MeshPart") and handle.MeshId == "http://www.roblox.com/asset/?id=319536754"
            end
        },
        {
            name = "Engine",
            rarity = "Uncommon",
            check = function(model)
                return model:FindFirstChild("Engine") ~= nil
            end
        },
        {
            name = "Pickaxe",
            rarity = "Uncommon",
            check = function(model)
                local handle = model:FindFirstChild("Handle")
                return handle and handle:IsA("MeshPart") and handle.MeshId == "http://www.roblox.com/asset/?id=22147051"
            end
        },
        {
            name = "Wrist Watch",
            rarity = "Rare",
            check = function(model)
                local mesh = model:FindFirstChild("Mesh")
                return mesh and mesh:IsA("Part") and
                        mesh.BrickColor.Name == "Institutional white" and
                        mesh.Material == Enum.Material.SmoothPlastic
            end
        },
        {
            name = "Binoculars",
            rarity = "Rare",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if (part:IsA("MeshPart") or part:IsA("Part")) and
                        ((part:IsA("MeshPart") and part.MeshId == "http://www.roblox.com/asset/?id=81700098") or
                        (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                          part:FindFirstChildOfClass("SpecialMesh").MeshId == "http://www.roblox.com/asset/?id=81700098")) then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Mobile Phone",
            rarity = "Rare",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                        part:FindFirstChildOfClass("SpecialMesh").MeshId == "http://www.roblox.com/asset/?id=268471347" then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Laptop",
            rarity = "Rare",
            check = function(model)
                local innerModel = model:FindFirstChild("Model")
                return innerModel and innerModel:FindFirstChild("Screen") ~= nil
            end
        },
        {
            name = "Welding Goggles",
            rarity = "Rare",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("MeshPart") and part.MeshId == "http://www.roblox.com/asset/?id=81700098" then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Trophy",
            rarity = "Rare",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if (part:IsA("MeshPart") and part.MeshId == "rbxassetid://6719139437") or
                       (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                         part:FindFirstChildOfClass("SpecialMesh").MeshId == "rbxassetid://6719139437") then
                        return true
                    end
                end

                local mesh = model:FindFirstChild("Mesh")
                return mesh and mesh:IsA("Part") and mesh.BrickColor.Name == "Bright yellow"
            end
        },
        {
            name = "Golden Compass",
            rarity = "Legendary",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if (part:IsA("MeshPart") and part.MeshId == "http://www.roblox.com/asset/?id=14655367") or
                       (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                         part:FindFirstChildOfClass("SpecialMesh").MeshId == "http://www.roblox.com/asset/?id=14655367") then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Gold Pocket Watch",
            rarity = "Legendary",
            check = function(model)
                return model:FindFirstChild("ConductorsPocketwatch") ~= nil
            end
        },
        {
            name = "Apocalypse Helmet",
            rarity = "Legendary",
            check = function(model)
                for _, part in pairs(model:GetDescendants()) do
                    if (part:IsA("MeshPart") and part.MeshId == "rbxassetid://4770107066") or
                       (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                         part:FindFirstChildOfClass("SpecialMesh").MeshId == "rbxassetid://4770107066") then
                        return true
                    end
                end
                return false
            end
        },
        {
            name = "Redcliff Necklace",
            rarity = "Immortal",
            check = function(model)
                return model:FindFirstChild("RedcliffNecklace") ~= nil
            end
        },
        {
            name = "Gold Bar",
            rarity = "Immortal",
            check = function(model)
                if model:FindFirstChild("Gold Bar") then
                    return true
                end

                local children = model:GetChildren()
                if #children >= 2 then
                    local possibleGoldBar = children[2]
                    if possibleGoldBar:IsA("Part") or possibleGoldBar:IsA("MeshPart") then
                        local isGoldColored = possibleGoldBar.BrickColor.Name:lower():find("yellow") or
                                              possibleGoldBar.BrickColor.Name:lower():find("gold")
                        return isGoldColored
                    end
                end
                return false
            end
        },
        {
            name = "Treasure Chest", --No idea if this works, correct me if it doesn't work please
            rarity = "Spectrum",
            check = function(model)
              local meshIds = {
              "rbxassetid://123781273",
              "rbxassetid://4799316239",
              "rbxassetid://144474705"
        }
        
        for _, meshId in ipairs(meshIds) do
            for _, part in pairs(model:GetDescendants()) do
                if (part:IsA("MeshPart") and part.MeshId == meshId) or
                   (part:IsA("Part") and part:FindFirstChildOfClass("SpecialMesh") and
                     part:FindFirstChildOfClass("SpecialMesh").MeshId == meshId) then
                            return true
                        end
                    end
                end
                return false
            end
        }
    }
}
