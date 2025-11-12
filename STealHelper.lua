-- HelperSteal: T Float + Jump
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HelperSteal"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
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
title.Text = "HelperSteal"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
statusLabel.Text = "Helper for Steal"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "Helper"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.Parent = mainFrame

-- Variables
local character
local rootPart
local floatEnabled = false
local floatConnection = nil

-- Settings
local JUMP_VELOCITY = 50 -- Jump power
local SLOW_FALL_MULTIPLIER = 0.01 -- 10x slower falling

-- Get character function
local function getCharacter()
    character = player.Character
    if character then
        rootPart = character:FindFirstChild("HumanoidRootPart")
        return rootPart ~= nil
    end
    return false
end

-- Jump function
local function jump()
    if not getCharacter() then return end
    
    -- Apply jump velocity
    rootPart.Velocity = Vector3.new(
        rootPart.Velocity.X,
        JUMP_VELOCITY,
        rootPart.Velocity.Z
    )
    
    print("Helper On")
end

-- Float function (10x slower falling)
local function applyFloat()
    if not getCharacter() then return end
    
    local currentVelocity = rootPart.Velocity
    
    -- 10x slower falling
    if currentVelocity.Y < 0 then
        rootPart.Velocity = Vector3.new(
            currentVelocity.X,
            currentVelocity.Y * SLOW_FALL_MULTIPLIER, -- 10x slower
            currentVelocity.Z
        )
    end
end

-- Toggle float and jump
local function toggleFloatAndJump()
    floatEnabled = not floatEnabled
    
    if floatEnabled then
        -- ENABLE Float + Auto jump
        floatConnection = RunService.Heartbeat:Connect(function()
            if floatEnabled then
                applyFloat()
            end
        end)
        
        -- Auto jump when enabling float
        jump()
        
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.Text = "Key = T"
        infoLabel.Text = "Helper ON"
        
        warn("JOIN OUR DISCORD")
    else
        -- DISABLE Float
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        statusLabel.Text = "Key = T"
        infoLabel.Text = "Helper OFF"
        
        print("OFF")
    end
end

-- Event handlers
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- T key to toggle float + auto jump
    if input.KeyCode == Enum.KeyCode.T then
        toggleFloatAndJump()
    end
    
    -- SPACE key for manual jump
    if input.KeyCode == Enum.KeyCode.Space then
        jump()
    end
end)

-- Auto character update and cleanup
player.CharacterAdded:Connect(function()
    getCharacter()
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    floatEnabled = false
    statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusLabel.Text = "Key = T"
    infoLabel.Text = "Helper OFF"
end)
