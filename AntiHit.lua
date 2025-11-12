-- BoosterSteal: Auto AntiHit
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoosterSteal"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 130)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "🚀 BoosterSteal - Auto AntiHit"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Text = "Auto AntiHit: ACTIVE"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = mainFrame

-- Players Info
local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.new(0.9, 0, 0, 20)
playersLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
playersLabel.BackgroundTransparency = 1
playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
playersLabel.Text = "Nearby players: 0"
playersLabel.Font = Enum.Font.Gotham
playersLabel.TextSize = 10
playersLabel.Parent = mainFrame

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "Auto launch 40 studs if player within 15"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.Parent = mainFrame

-- Variables
local character
local rootPart
local lastLaunchTime = 0

-- Settings
local LAUNCH_HEIGHT = 40 -- Studs up
local DETECTION_RANGE = 15 -- Studs range to detect players
local LAUNCH_COOLDOWN = 1 -- Seconds between launches

-- Get character function
local function getCharacter()
    character = player.Character
    if character then
        rootPart = character:FindFirstChild("HumanoidRootPart")
        return rootPart ~= nil
    end
    return false
end

-- Find nearby players
local function getNearbyPlayers()
    if not getCharacter() then return {} end
    
    local nearbyPlayers = {}
    local myPosition = rootPart.Position
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (otherRoot.Position - myPosition).Magnitude
                if distance <= DETECTION_RANGE then
                    table.insert(nearbyPlayers, {
                        player = otherPlayer,
                        distance = distance
                    })
                end
            end
        end
    end
    
    return nearbyPlayers
end

-- Launch up function
local function launchUp()
    if not getCharacter() then return end
    
    -- Check cooldown
    local currentTime = tick()
    if currentTime - lastLaunchTime < LAUNCH_COOLDOWN then
        return
    end
    
    -- Apply upward velocity
    rootPart.Velocity = Vector3.new(
        rootPart.Velocity.X,
        LAUNCH_HEIGHT * 2.2,
        rootPart.Velocity.Z
    )
    
    lastLaunchTime = currentTime
    
    -- Visual feedback
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.Text = "Auto AntiHit: LAUNCHED!"
    playersLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    
    print("🚀 Auto AntiHit: Launched " .. LAUNCH_HEIGHT .. " studs up!")
    
    -- Reset status after 0.5 second
    wait(0.5)
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusLabel.Text = "Auto AntiHit: ACTIVE"
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
end

-- Update players display and check for launches
local function updateAntiHit()
    if not getCharacter() then return end
    
    local nearbyPlayers = getNearbyPlayers()
    playersLabel.Text = "Nearby players: " .. #nearbyPlayers
    
    -- Change color based on number of players
    if #nearbyPlayers > 0 then
        playersLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red when players nearby
        
        -- Auto launch if players detected within 15 studs
        launchUp()
    else
        playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255) -- Blue when no players
    end
end

-- Start automatic AntiHit system
RunService.Heartbeat:Connect(function()
    updateAntiHit()
end)

-- Auto character update
player.CharacterAdded:Connect(function()
    getCharacter()
    lastLaunchTime = 0
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusLabel.Text = "Auto AntiHit: ACTIVE"
    playersLabel.Text = "Nearby players: 0"
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
end)

print("🛡️ BoosterSteal - Auto AntiHit LOADED!")
print("Automatically launches 40 studs when players within 15 studs")
print("Always active - no manual input needed")
