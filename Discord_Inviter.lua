-- This no longer works because Discord recently (2025) decided to discontinue RPC which was needed to open the invite over roblox. This script is discontinued till they decide to rerun their API.
-- Old code:

local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
local discordInvite = "https://discord.gg/WDbJ5wE2cR"

local function openDiscordInvite()
    local httpService = game:GetService("HttpService")
    local request = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
    if request then
        request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com"
            },
            Body = httpService:JSONEncode({
                cmd = "INVITE_BROWSER",
                args = {
                    code = discordInvite:gsub("https://discord.gg/", "")
                },
                nonce = httpService:GenerateGUID(false)
            })
        })
    else
        AllClipboards(discordInvite)
        print("Discord invite copied to clipboard!")
    end
end

openDiscordInvite()
