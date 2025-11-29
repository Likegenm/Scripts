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

local FlyToggle = MainTab:AddToggle({
    Name = "Fly",
    Default = false,
    Save = true,
    Flag = "Fly",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if Value then
            local flyConnection
            flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not FlyToggle.Value then
                    flyConnection:Disconnect()
                    return
                end
                
                local hrp = character.HumanoidRootPart
                local flySpeed = currentSpeed
                local moveDirection = Vector3.new(0, 0, 0)
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + hrp.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - hrp.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - hrp.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + hrp.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection + Vector3.new(0, -1, 0)
                end
                
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * flySpeed
                    hrp.CFrame = hrp.CFrame + moveDirection
                end
            end)
            
            OrionLib:MakeNotification({
                Name = "Fly",
                Content = "Fly включен! Используйте WASD, Space и Shift",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Fly",
                Content = "Fly выключен!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})
OrionLib:Init()
