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

local SafeZoneGroup = Tabs.LocalPlayer:AddRightGroupbox("SafeZone")

local safeZonePlatform
local isInSafeZone = false

SafeZoneGroup:AddButton("Go to SafeZone", function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = CFrame.new(133.97, -210, 896.53)
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            
            if safeZonePlatform then
                safeZonePlatform:Destroy()
            end
            
            safeZonePlatform = Instance.new("Part")
            safeZonePlatform.Name = "SafeZonePlatform"
            safeZonePlatform.Anchored = true
            safeZonePlatform.CanCollide = true
            safeZonePlatform.Transparency = 0
            safeZonePlatform.Size = Vector3.new(20, 1, 20)
            safeZonePlatform.Material = Enum.Material.Neon
            safeZonePlatform.BrickColor = BrickColor.new("Bright green")
            safeZonePlatform.Position = Vector3.new(133.97, -215, 896.53)
            safeZonePlatform.Parent = workspace
            
            isInSafeZone = true
        end
    end
end)

SafeZoneGroup:AddButton("Return Back", function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = CFrame.new(133.97, -15.00, 896.53)
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            
            if safeZonePlatform then
                safeZonePlatform:Destroy()
                safeZonePlatform = nil
            end
            
            isInSafeZone = false
        end
    end
end)

local TeleportsGroup = Tabs.LocalPlayer:AddRightGroupbox("Teleports")

local teleportEnabled = false
local offsetX = 0
local offsetY = 0
local offsetZ = 0

TeleportsGroup:AddSlider("OffsetX", {
    Text = "Offset X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        offsetX = Value
    end
})

TeleportsGroup:AddSlider("OffsetY", {
    Text = "Offset Y", 
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        offsetY = Value
    end
})

TeleportsGroup:AddSlider("OffsetZ", {
    Text = "Offset Z",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        offsetZ = Value
    end
})

TeleportsGroup:AddToggle("Teleport", {
    Text = "Apply Teleport",
    Default = false,
    Callback = function(Value)
        teleportEnabled = Value
        if teleportEnabled then
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local currentCFrame = humanoidRootPart.CFrame
                    local targetPosition = currentCFrame.Position + Vector3.new(offsetX, offsetY, offsetZ)
                    local tweenService = game:GetService("TweenService")
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {
                        CFrame = CFrame.new(targetPosition, currentCFrame.LookVector * 10000)
                    })
                    tween:Play()
                end
            end
        end
    end
})

local BringTab = Window:AddTab("Bring", "users")
local BringGroup = BringTab:AddLeftGroupbox("Bring Items")

local lootFolder = workspace:FindFirstChild("Loot")
local lootItems = {}
local lootDropdown

local function updateLootList()
    lootItems = {}
    if lootFolder then
        for _, item in pairs(lootFolder:GetChildren()) do
            if item:IsA("Model") then
                if not table.find(lootItems, item.Name) then
                    table.insert(lootItems, item.Name)
                end
            end
        end
    end
end

local function createDropdown()
    if lootDropdown then
        BringGroup:RemoveObject(lootDropdown)
    end
    
    lootDropdown = BringGroup:AddDropdown("LootSelect", {
        Values = lootItems,
        Default = 1,
        Text = "Select Loot",
        Callback = function(Value)
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and lootFolder then
                    for _, obj in pairs(lootFolder:GetChildren()) do
                        if obj.Name == Value then
                            local target = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if target then
                                obj:PivotTo(humanoidRootPart.CFrame + Vector3.new(math.random(-4,4), 2, math.random(-4,4)))
                            end
                        end
                    end
                end
            end
        end
    })
end

updateLootList()
createDropdown()

BringGroup:AddButton("Refresh Loot List", function()
    updateLootList()
    createDropdown()
end)

-- Автообновление
game:GetService("RunService").Heartbeat:Connect(function()
    updateLootList()
    createDropdown()
end)
