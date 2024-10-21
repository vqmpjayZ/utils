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
        setclipboard(discordInvite)
        print("Discord invite copied to clipboard!")
    end
end

openDiscordInvite()
