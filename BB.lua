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
local MODELS, OPTIONS = {}, {}
local SEARCH = ""

local function buildSnapshot()
    MODELS = {}
    if lootFolder then
        for _, obj in ipairs(lootFolder:GetChildren()) do
            if obj:IsA("Model") then
                table.insert(MODELS, obj)
            end
        end
        table.sort(MODELS, function(a,b) return a.Name:lower() < b.Name:lower() end)
    end
end

local function rebuildOptions()
    local seen, list = {}, {}
    for _, m in ipairs(MODELS) do
        if SEARCH == "" or string.find(m.Name:lower(), SEARCH, 1, true) then
            if not seen[m.Name] then
                table.insert(list, m.Name)
                seen[m.Name] = true
            end
        end
    end
    OPTIONS = list
end

local function bringAllByName(itemName)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not (hrp and lootFolder) then return end

    for _, obj in ipairs(lootFolder:GetChildren()) do
        if obj:IsA("Model") and obj.Name == itemName then
            local target = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if target then
                obj:PivotTo(hrp.CFrame + Vector3.new(math.random(-4,4), 2, math.random(-4,4)))
            end
        end
    end
end

buildSnapshot()
rebuildOptions()

BringGroup:AddInput("SearchLoot", {
    Text = "Search Loot",
    Default = "",
    Placeholder = "Type to filter...",
    Callback = function(text)
        SEARCH = text:lower()
        rebuildOptions()
        lootDropdown:SetValues(OPTIONS)
    end
})

local lootDropdown = BringGroup:AddDropdown("BringDropdown", {
    Values = OPTIONS,
    Default = 1,
    Text = "Select Item to Bring",
    Callback = function(Value)
        bringAllByName(Value)
    end
})

BringGroup:AddButton("Refresh Loot List", function()
    buildSnapshot()
    rebuildOptions()
    lootDropdown:SetValues(OPTIONS)
end)

if lootFolder then
    lootFolder.ChildAdded:Connect(function()
        task.wait(0.2)
        buildSnapshot()
        rebuildOptions()
        lootDropdown:SetValues(OPTIONS)
    end)
    
    lootFolder.ChildRemoved:Connect(function()
        task.wait(0.2)
        buildSnapshot()
        rebuildOptions()
        lootDropdown:SetValues(OPTIONS)
    end)
end

local VisualTab = Window:AddTab("Visual", "eye")

local EspGroup = VisualTab:AddLeftGroupbox("ESP")
local AmbientGroup = VisualTab:AddRightGroupbox("Ambient")

-- ESP Variables
local espEnabled = false
local espConnection
local espHighlights = {}
local espTypes = {
    Npc = false,
    Item = false,
    Players = false
}
local showNames = false
local showTracers = false

-- ESP Functions
local function createESP(object, objectType)
    if espHighlights[object] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    
    if objectType == "Players" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    else
        -- Rainbow color for NPCs and Items
        local hue = tick() % 5 / 5
        highlight.FillColor = Color3.fromHSV(hue, 1, 1)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
    
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Adornee = object
    highlight.Parent = object
    
    espHighlights[object] = highlight
    
    -- Name ESP
    if showNames then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Adornee = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel")
        label.Text = object.Name
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = billboard
        
        billboard.Parent = object
    end
    
    -- Tracers
    if showTracers then
        local tracer = Instance.new("Beam")
        tracer.Name = "ESP_Tracer"
        tracer.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
        tracer.Width0 = 1
        tracer.Width1 = 1
        tracer.FaceCamera = true
        
        local attachment0 = Instance.new("Attachment")
        attachment0.Position = Vector3.new(0, 0, 0)
        attachment0.Parent = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        
        tracer.Attachment0 = attachment0
        tracer.Attachment1 = attachment1
        tracer.Parent = object
    end
end

local function removeESP(object)
    if espHighlights[object] then
        espHighlights[object]:Destroy()
        espHighlights[object] = nil
    end
    
    if object:FindFirstChild("ESP_Name") then
        object.ESP_Name:Destroy()
    end
    
    if object:FindFirstChild("ESP_Tracer") then
        object.ESP_Tracer:Destroy()
    end
end

local function updateESP()
    for object, highlight in pairs(espHighlights) do
        if not object or not object.Parent then
            removeESP(object)
        elseif highlight and highlight:IsA("Highlight") then
            if highlight.FillColor ~= Color3.fromRGB(255, 0, 0) then
                local hue = tick() % 5 / 5
                highlight.FillColor = Color3.fromHSV(hue, 1, 1)
            end
        end
    end
    
    if espTypes.Npc and workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc:IsA("Model") then
                createESP(npc, "Npc")
            end
        end
    end
    
    if espTypes.Item and workspace:FindFirstChild("Loot") then
        for _, item in pairs(workspace.Loot:GetChildren()) do
            if item:IsA("Model") then
                createESP(item, "Item")
            end
        end
    end
    
    if espTypes.Players then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                createESP(player.Character, "Players")
            end
        end
    end
end

-- ESP Controls
EspGroup:AddSlider("ESPRange", {
    Text = "ESP Range",
    Default = 100,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        -- Range logic can be added here
    end
})

EspGroup:AddToggle("NPCESP", {
    Text = "NPC ESP",
    Default = false,
    Callback = function(Value)
        espTypes.Npc = Value
    end
})

EspGroup:AddToggle("ItemESP", {
    Text = "Item ESP",
    Default = false,
    Callback = function(Value)
        espTypes.Item = Value
    end
})

EspGroup:AddToggle("PlayerESP", {
    Text = "Players ESP",
    Default = false,
    Callback = function(Value)
        espTypes.Players = Value
    end
})

EspGroup:AddToggle("NameESP", {
    Text = "Name ESP",
    Default = false,
    Callback = function(Value)
        showNames = Value
    end
})

EspGroup:AddToggle("TracersESP", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        showTracers = Value
    end
})

EspGroup:AddToggle("ESPEnabled", {
    Text = "ESP Enabled",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            espConnection = game:GetService("RunService").Heartbeat:Connect(updateESP)
        else
            if espConnection then
                espConnection:Disconnect()
            end
            for object, _ in pairs(espHighlights) do
                removeESP(object)
            end
            table.clear(espHighlights)
        end
    end
})

-- Ambient Controls
AmbientGroup:AddColorPicker("CustomAmbient", {
    Default = Color3.new(1, 1, 1),
    Title = "Custom Ambient",
    Callback = function(Value)
        game.Lighting.Ambient = Value
    end
})

local rainbowEnabled = false
local rainbowConnection

AmbientGroup:AddToggle("RainbowAmbient", {
    Text = "Rainbow Ambient",
    Default = false,
    Callback = function(Value)
        rainbowEnabled = Value
        if rainbowEnabled then
            rainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local hue = tick() % 5 / 5
                game.Lighting.Ambient = Color3.fromHSV(hue, 1, 1)
            end)
        else
            if rainbowConnection then
                rainbowConnection:Disconnect()
            end
        end
    end
})

AmbientGroup:AddButton("Third Person", function()
    game.Players.LocalPlayer.CameraMaxZoomDistance = 10000
    game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
end)

AmbientGroup:AddButton("First Person", function()
    game.Players.LocalPlayer.CameraMaxZoomDistance = 0
    game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end)

BringGroup:AddButton("Bring All Items", function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and lootFolder then
            for _, obj in pairs(lootFolder:GetChildren()) do
                if obj:IsA("Model") then
                    local target = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if target then
                        obj:PivotTo(humanoidRootPart.CFrame + Vector3.new(math.random(-4,4), 2, math.random(-4,4)))
                    end
                end
            end
        end
    end
end)
