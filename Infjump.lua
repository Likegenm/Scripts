-- Inf Jump with Big Invisible Platform
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfJumpControl"
ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "🚀 INF JUMP + PLATFORM"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 35)
toggleButton.Position = UDim2.new(0.05, 0, 0.25, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "🟢 ENABLE INF JUMP"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: DISABLED"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = mainFrame

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "Hotkey: F | Big platform below"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 10
infoLabel.Parent = mainFrame

-- Variables
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local infJumpEnabled = false
local platformPart = nil
local platformConnection = nil
local jumpCooldown = false

-- Create big platform
local function createBigPlatform()
    if platformPart then
        platformPart:Destroy()
        platformPart = nil
    end
    
    platformPart = Instance.new("Part")
    platformPart.Name = "InfJumpPlatform"
    platformPart.Size = Vector3.new(50, 2, 50) -- Big platform
    platformPart.Anchored = true
    platformPart.CanCollide = true
    platformPart.Transparency = 1 -- Invisible
    platformPart.Material = Enum.Material.SmoothPlastic
    platformPart.Parent = workspace
    platformPart.Locked = true
    
    return platformPart
end

-- Update platform position
local function updatePlatformPosition()
    if not platformPart or not rootPart then return end
    
    local playerPos = rootPart.Position
    platformPart.Position = Vector3.new(
        playerPos.X, 
        playerPos.Y - 10, -- 10 studs below player
        playerPos.Z
    )
end

-- Inf Jump function
local function performInfJump()
    if not infJumpEnabled or jumpCooldown then return end
    if not character or not rootPart then return end
    
    -- Jump with velocity
    rootPart.Velocity = Vector3.new(
        rootPart.Velocity.X,
        50, -- Jump power
        rootPart.Velocity.Z
    )
    
    -- Cooldown
    jumpCooldown = true
    wait(0.3)
    jumpCooldown = false
end

-- Cleanup function
local function cleanup()
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
    end
    
    if platformPart then
        platformPart:Destroy()
        platformPart = nil
    end
    
    infJumpEnabled = false
    jumpCooldown = false
end

-- Toggle Inf Jump
local function toggleInfJump()
    if infJumpEnabled then
        -- DISABLE Inf Jump
        cleanup()
        
        -- Update GUI
        toggleButton.Text = "🟢 ENABLE INF JUMP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "Status: DISABLED"
        
        print("INF JUMP DISABLED - Platform removed")
    else
        -- ENABLE Inf Jump
        infJumpEnabled = true
        createBigPlatform()
        updatePlatformPosition()
        
        -- Platform follow
        platformConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
        
        -- Update GUI
        toggleButton.Text = "🔴 DISABLE INF JUMP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        statusLabel.Text = "Status: ENABLED"
        
        print("INF JUMP ENABLED - Big platform created")
    end
end

-- Event handlers
toggleButton.MouseButton1Click:Connect(toggleInfJump)

-- Spacebar for jumping
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        performInfJump()
    end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleInfJump()
    end
end)

-- Auto-update on respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if infJumpEnabled then
        cleanup()
        wait(0.5)
        toggleInfJump() -- Re-enable with new character
    end
end)

-- Cleanup when script is destroyed
mainFrame.Destroying:Connect(cleanup)

print("🚀 INF JUMP script loaded!")
print("F - Toggle Inf Jump")
print("SPACE - Jump in air")
print("Big invisible platform follows player")
