-- Script by Likegenm for Build a Bunker
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "By Likegenm (Build a Bunker (BB))",
    Footer = "BB Hub",
    Icon = 127930288,
    ShowCustomCursor = true,
})

local Tabs = {
    Info = Window:AddTab("Info", "info"),
    LocalPlayer = Window:AddTab("LocalPlayer", "user"),
}

local InfoGroup = Tabs.Info:AddLeftGroupbox("Information")
InfoGroup:AddLabel("Build a Bunker script", true)
InfoGroup:AddButton("Copy Discord", function()
    setclipboard("https://discord.gg/M9ykzuB4")
end)

local AbilitiesGroup = Tabs.LocalPlayer:AddLeftGroupbox("Abilities")
local noclipEnabled = false
local noclipConnection

AbilitiesGroup:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        if noclipEnabled then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if noclipEnabled and game.Players.LocalPlayer.Character then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
            end
        end
    end  
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:SetFolder("BBHub")
ThemeManager:SetFolder("BBHub")

AbilitiesGroup:AddSlider("Speedhack", {
    Text = "Speedhack",
    Default = 16,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local infJumpEnabled = false
local infJumpConnection

AbilitiesGroup:AddToggle("InfJump", {
    Text = "Inf Jump",
    Default = false,
    Callback = function(Value)
        infJumpEnabled = Value
        if infJumpEnabled then
            infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
            end
        end
    end
})

local flyEnabled = false
local flyConnection
local bodyVelocity

AbilitiesGroup:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if flyEnabled then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if flyEnabled and character and character.HumanoidRootPart then
                    local moveDirection = Vector3.new(0, 0, 0)
                    
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + Vector3.new(0, 0, -1)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection + Vector3.new(0, 0, 1)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection + Vector3.new(-1, 0, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + Vector3.new(1, 0, 0)
                    end
                    
                    local camera = workspace.CurrentCamera
                    local velocity = camera.CFrame:VectorToWorldSpace(moveDirection) * 50
                    bodyVelocity.Velocity = velocity
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
})

local FloatPlatformGroup = Tabs.LocalPlayer:AddRightGroupbox("FloatPlatform")

local floatPlatformEnabled = false
local currentTween
local floatHeight = 0

FloatPlatformGroup:AddSlider("FloatHeight", {
    Text = "Float Height",
    Default = 0,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        floatHeight = Value
    end
})

FloatPlatformGroup:AddToggle("FloatPlatform", {
    Text = "Float Platform",
    Default = false,
    Callback = function(Value)
        floatPlatformEnabled = Value
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if floatPlatformEnabled then
                    local targetPosition = humanoidRootPart.Position + Vector3.new(0, floatHeight, 0)
                    local tweenService = game:GetService("TweenService")
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    currentTween = tweenService:Create(humanoidRootPart, tweenInfo, {Position = targetPosition})
                    currentTween:Play()
                else
                    if currentTween then
                        currentTween:Cancel()
                    end
                end
            end
        end
    end
})
