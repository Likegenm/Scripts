local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "SK (Likegenm)",
    Center = true,
    AutoShow = true,
})

-- ВКЛАДКА "MAIN"
local MainTab = Window:AddTab("Player", "user")
local LeftGroup = MainTab:AddLeftGroupbox("Players")

LeftGroup:AddInput("WalkSpeedInput", {
    Default = "16",
    Numeric = true,
    Finished = false,
    Text = "Speedhack",
    Placeholder = "Inpur:",
    
    Callback = function(Value)
        if Value and tonumber(Value) then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = tonumber(Value)
            end
        end
    end
})

LeftGroup:AddToggle("InfJumpToggle", {
    Text = "Inf Jump",
    Default = false,
    
    Callback = function(Value)
        getgenv().InfJumpEnabled = Value
        local UserInputService = game:GetService("UserInputService")
        
        if Value then
            getgenv().InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                if getgenv().InfJumpEnabled then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState("Jumping")
                    end
                end
            end)
        else
            if getgenv().InfJumpConnection then
                getgenv().InfJumpConnection:Disconnect()
            end
        end
    end
})

LeftGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    
    Callback = function(Value)
        getgenv().FlyEnabled = Value
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        
        if Value then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local root = character:WaitForChild("HumanoidRootPart")
            
            local flySpeed = 50
            local flyConnection
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().FlyEnabled then
                    flyConnection:Disconnect()
                    return
                end
                
                local velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + root.CFrame.LookVector * flySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - root.CFrame.LookVector * flySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - root.CFrame.RightVector * flySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + root.CFrame.RightVector * flySpeed
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, flySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - Vector3.new(0, flySpeed, 0)
                end
                
                root.Velocity = velocity
                humanoid.PlatformStand = true
            end)
            
            getgenv().FlyConnection = flyConnection
        else
            if getgenv().FlyConnection then
                getgenv().FlyConnection:Disconnect()
            end
            
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.PlatformStand = false
            end
        end
    end
})
