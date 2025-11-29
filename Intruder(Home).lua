local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "The Intruder script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "IntruderConfig",
    IntroEnabled = true,
    IntroText = "The Intruder script",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MainLoadButton = MainTab:AddButton({
    Name = "Main load",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Main.lua"))()
    end    
})

OrionLib:Init()
