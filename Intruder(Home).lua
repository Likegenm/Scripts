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

local FlyToggle = MainTab:AddToggle({
    Name = "Fly",
    Default = false,
    Save = true,
    Flag = "Fly",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        if Value then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlyVelocity"
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            local flyConnection
            flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not FlyToggle.Value then
                    flyConnection:Disconnect()
                    return
                end
                
                local hrp = character.HumanoidRootPart
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    bodyVelocity.Velocity = hrp.CFrame.LookVector * 50
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    bodyVelocity.Velocity = -hrp.CFrame.LookVector * 50
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    bodyVelocity.Velocity = -hrp.CFrame.RightVector * 50
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    bodyVelocity.Velocity = hrp.CFrame.RightVector * 50
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                end
            end)
            
            OrionLib:MakeNotification({
                Name = "Fly",
                Content = "Fly включен! Используйте WASD, Space и Shift",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            if character.HumanoidRootPart:FindFirstChild("FlyVelocity") then
                character.HumanoidRootPart.FlyVelocity:Destroy()
            end
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
