-- Float
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ReseOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
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
title.Text = "🪂 SLOW DESCENT + HOLD JUMP"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 35)
toggleButton.Position = UDim2.new(0.05, 0, 0.25, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "🟢 ENABLE SLOW FALL"
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
infoLabel.Text = "X: Toggle | SPACE: Hold for bigger jump"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 10
infoLabel.Parent = mainFrame

-- Variables
local floatEnabled = false
local character
local humanoid
local rootPart
local spaceHeld = false
local holdStartTime = 0

-- Settings
local SLOW_FALL_SPEED = 3 -- 5x slower than normal fall
local MIN_JUMP_POWER = 30
local MAX_JUMP_POWER = 100
local HOLD_TIME_MAX = 1.0 -- Max hold time in seconds

-- Get character function
local function getCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
        return true
    end
    return false
end

-- Calculate jump power based on hold time
local function getJumpPower()
    local holdTime = tick() - holdStartTime
    local holdPercent = math.min(holdTime / HOLD_TIME_MAX, 1.0) -- 0 to 1
    
    -- Calculate jump power (linear from MIN to MAX)
    local jumpPower = MIN_JUMP_POWER + (MAX_JUMP_POWER - MIN_JUMP_POWER) * holdPercent
    
    return math.floor(jumpPower)
end

-- Inf Jump function with hold power
local function performInfJump()
    if not floatEnabled then return end
    if not getCharacter() then return end
    
    local jumpPower = getJumpPower()
    
    -- Jump with velocity based on hold time
    rootPart.Velocity = Vector3.new(
        rootPart.Velocity.X,
        jumpPower,
        rootPart.Velocity.Z
    )
    
    print("Jump power: " .. jumpPower)
end

-- Main float loop
local function floatLoop()
    while floatEnabled do
        if getCharacter() then
            -- Apply slow fall (5x slower)
            local currentVelocity = rootPart.Velocity
            
            -- Only slow down downward movement
            if currentVelocity.Y < -SLOW_FALL_SPEED then
                rootPart.Velocity = Vector3.new(
                    currentVelocity.X,
                    -SLOW_FALL_SPEED, -- Limited fall speed
                    currentVelocity.Z
                )
            end
        end
        wait(0.03) -- Fast update for smooth falling
    end
end

-- Toggle Float
local function toggleFloat()
    floatEnabled = not floatEnabled
    
    if floatEnabled then
        -- ENABLE
        spawn(floatLoop)
        
        toggleButton.Text = "🔴 DISABLE SLOW FALL"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        statusLabel.Text = "Status: ENABLED"
        
        print("SLOW FALL ENABLED - Hold SPACE for bigger jumps")
    else
        -- DISABLE
        toggleButton.Text = "🟢 ENABLE SLOW FALL"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "Status: DISABLED"
        
        print("SLOW FALL DISABLED")
    end
end

-- Event handlers for hold jump
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space and floatEnabled then
        spaceHeld = true
        holdStartTime = tick()
        
        -- Start showing hold power
        spawn(function()
            while spaceHeld and floatEnabled do
                local power = getJumpPower()
                infoLabel.Text = "Hold SPACE: " .. power .. " power"
                wait(0.1)
            end
        end)
    end
    
    if input.KeyCode == Enum.KeyCode.X then
        toggleFloat()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Space and spaceHeld and floatEnabled then
        spaceHeld = false
        performInfJump()
        infoLabel.Text = "X: Toggle | SPACE: Hold for bigger jump"
    end
end)

-- Auto character update
player.CharacterAdded:Connect(function()
    if floatEnabled then
        wait(1) -- Wait for character to load
    end
end)

-- GUI click handler
toggleButton.MouseButton1Click:Connect(toggleFloat)

print("✅ SLOW DESCENT + HOLD JUMP LOADED!")
print("X - Toggle Slow Fall")
print("SPACE - Hold for bigger jumps (30-100 power)")
