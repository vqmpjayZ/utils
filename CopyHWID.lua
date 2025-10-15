local AllClipboards = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
AllClipboards(game:GetService("RbxAnalyticsService"):GetClientId())

game.Players.LocalPlayer:Kick("HWID has ben copied to your clipboard. Continue following the instructions.")
