return function(localVersion, discordInvite, versionUrl)
    local LOCAL_VERSION = localVersion
    local VERSION_URL = versionUrl
    local DISCORD_INVITE = discordInvite

    local DEV_HWID = "56A21F95-D3B9-4723-8BC4-7B85B971A12F"
    local CLIENT_HWID = game:GetService("RbxAnalyticsService"):GetClientId()

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

        if CLIENT_HWID == DEV_HWID then
            print("🛠️ Dev mode detected — version check bypassed.")
            return true
        end

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
        pcall(function()
            local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
            if AllClipboards then
                AllClipboards("https://" .. DISCORD_INVITE)
            end
        end)

        if game.Players.LocalPlayer then
            game.Players.LocalPlayer:Kick("Version mismatch. Get the latest version at " .. DISCORD_INVITE)
        end

        error("❌ OUTDATED VERSION - Please update from " .. DISCORD_INVITE)
    end

    print("Script is up to date. Continuing execution...")
end
