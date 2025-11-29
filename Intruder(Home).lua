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

local SpeedSlider = MainTab:AddSlider({
    Name = "Speedhack",
    Min = 1,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local moveDirection = hrp.CFrame.LookVector
            hrp.CFrame = hrp.CFrame + moveDirection * (Value / 10)
        end
    end    
})

OrionLib:Init()
