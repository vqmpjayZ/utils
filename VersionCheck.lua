return function(localVersion, discordInvite, versionUrl)
    task.spawn(function()
        local LOCAL_VERSION = localVersion
        local VERSION_URL = versionUrl
        local DISCORD_INVITE = discordInvite

        local function getLatestVersion()
            local success, result = pcall(function()
                return game:HttpGet(VERSION_URL)
            end)
            
            if success then
                return result:gsub("%s+", "")
            else
                warn("Failed to fetch latest version: " .. tostring(result))
                return nil
            end
        end

        local function compareVersions(current, latest)
            return current == latest
        end

        local function checkVersion()
            print("Current Version: " .. LOCAL_VERSION)
            print("Checking for updates...")
            
            local latestVersion = getLatestVersion()
            
            if not latestVersion then
                warn("Could not retrieve latest version. Continuing with current version.")
                return true
            end
            
            print("Latest Version: " .. latestVersion)
            
            if compareVersions(LOCAL_VERSION, latestVersion) then
                print("✅ You are running the latest version!")
                return true
            else
                print("❌ Version mismatch!")
                print("Please update to version " .. latestVersion)
                return false
            end
        end

        if not checkVersion() then
            if game.Players.LocalPlayer then
                game.Players.LocalPlayer:Kick("Version mismatch. Get the latest version at " .. DISCORD_INVITE)
                pcall(function()
                    local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
                    if AllClipboards then
                        AllClipboards("https://" .. DISCORD_INVITE)
                    end
                end)
            end
            return
        end

        print("Script is up to date. Continuing execution...")
    end)
end
