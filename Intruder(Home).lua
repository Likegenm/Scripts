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
        local speedValue = Value
    end    
})

local speedConnection
local currentSpeed = 16

SpeedSlider:Set(16)

game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            local moveDirection = humanoid.MoveDirection
            hrp.Velocity = Vector3.new(moveDirection.X * currentSpeed, hrp.Velocity.Y, moveDirection.Z * currentSpeed)
        end
    end
end)

SpeedSlider.Callback = function(Value)
    currentSpeed = Value
end

local NoclipToggle = MainTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Save = true,
    Flag = "Noclip",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if Value then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            local noclipConnection
            noclipConnection = character.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end)
            
            NoclipToggle.noclipConnection = noclipConnection
            
            OrionLib:MakeNotification({
                Name = "Noclip",
                Content = "Noclip enabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            if NoclipToggle.noclipConnection then
                NoclipToggle.noclipConnection:Disconnect()
            end
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            
            OrionLib:MakeNotification({
                Name = "Noclip",
                Content = "Noclip disabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})

OrionLib:Init()
