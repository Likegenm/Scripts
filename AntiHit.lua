-- BoosterSteal: Auto AntiHit
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoosterSteal"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
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

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.4, 0, 0, 25)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "ENABLED"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.4, 0, 0, 25)
statusLabel.Position = UDim2.new(0.55, 0, 0.15, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Text = "Status: ACTIVE"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Parent = mainFrame

-- Detection Range Slider
local rangeFrame = Instance.new("Frame")
rangeFrame.Size = UDim2.new(0.9, 0, 0, 40)
rangeFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
rangeFrame.BackgroundTransparency = 1
rangeFrame.Parent = mainFrame

local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(0.4, 0, 1, 0)
rangeLabel.Position = UDim2.new(0, 0, 0, 0)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
rangeLabel.Text = "Detection Range:"
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.TextSize = 11
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
rangeLabel.Parent = rangeFrame

local rangeValue = Instance.new("TextLabel")
rangeValue.Size = UDim2.new(0.15, 0, 1, 0)
rangeValue.Position = UDim2.new(0.85, 0, 0, 0)
rangeValue.BackgroundTransparency = 1
rangeValue.TextColor3 = Color3.fromRGB(0, 255, 255)
rangeValue.Text = "15"
rangeValue.Font = Enum.Font.GothamBold
rangeValue.TextSize = 12
rangeValue.TextXAlignment = Enum.TextXAlignment.Right
rangeValue.Parent = rangeFrame

local rangeSlider = Instance.new("TextButton")
rangeSlider.Size = UDim2.new(0.4, 0, 0.5, 0)
rangeSlider.Position = UDim2.new(0.4, 0, 0.25, 0)
rangeSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
rangeSlider.Text = ""
rangeSlider.Parent = rangeFrame

local rangeSliderCorner = Instance.new("UICorner")
rangeSliderCorner.CornerRadius = UDim.new(0, 4)
rangeSliderCorner.Parent = rangeSlider

local rangeSliderFill = Instance.new("Frame")
rangeSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
rangeSliderFill.Position = UDim2.new(0, 0, 0, 0)
rangeSliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
rangeSliderFill.BorderSizePixel = 0
rangeSliderFill.Parent = rangeSlider

local rangeFillCorner = Instance.new("UICorner")
rangeFillCorner.CornerRadius = UDim.new(0, 4)
rangeFillCorner.Parent = rangeSliderFill

-- Launch Height Slider
local heightFrame = Instance.new("Frame")
heightFrame.Size = UDim2.new(0.9, 0, 0, 40)
heightFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
heightFrame.BackgroundTransparency = 1
heightFrame.Parent = mainFrame

local heightLabel = Instance.new("TextLabel")
heightLabel.Size = UDim2.new(0.4, 0, 1, 0)
heightLabel.Position = UDim2.new(0, 0, 0, 0)
heightLabel.BackgroundTransparency = 1
heightLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
heightLabel.Text = "Launch Height:"
heightLabel.Font = Enum.Font.Gotham
heightLabel.TextSize = 11
heightLabel.TextXAlignment = Enum.TextXAlignment.Left
heightLabel.Parent = heightFrame

local heightValue = Instance.new("TextLabel")
heightValue.Size = UDim2.new(0.15, 0, 1, 0)
heightValue.Position = UDim2.new(0.85, 0, 0, 0)
heightValue.BackgroundTransparency = 1
heightValue.TextColor3 = Color3.fromRGB(255, 150, 0)
heightValue.Text = "40"
heightValue.Font = Enum.Font.GothamBold
heightValue.TextSize = 12
heightValue.TextXAlignment = Enum.TextXAlignment.Right
heightValue.Parent = heightFrame

local heightSlider = Instance.new("TextButton")
heightSlider.Size = UDim2.new(0.4, 0, 0.5, 0)
heightSlider.Position = UDim2.new(0.4, 0, 0.25, 0)
heightSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
heightSlider.Text = ""
heightSlider.Parent = heightFrame

local heightSliderCorner = Instance.new("UICorner")
heightSliderCorner.CornerRadius = UDim.new(0, 4)
heightSliderCorner.Parent = heightSlider

local heightSliderFill = Instance.new("Frame")
heightSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
heightSliderFill.Position = UDim2.new(0, 0, 0, 0)
heightSliderFill.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
heightSliderFill.BorderSizePixel = 0
heightSliderFill.Parent = heightSlider

local heightFillCorner = Instance.new("UICorner")
heightFillCorner.CornerRadius = UDim.new(0, 4)
heightFillCorner.Parent = heightSliderFill

-- Players Info
local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.new(0.9, 0, 0, 20)
playersLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
playersLabel.BackgroundTransparency = 1
playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
playersLabel.Text = "Nearby players: 0"
playersLabel.Font = Enum.Font.Gotham
playersLabel.TextSize = 10
playersLabel.Parent = mainFrame

-- Manual Launch button
local manualButton = Instance.new("TextButton")
manualButton.Size = UDim2.new(0.4, 0, 0, 25)
manualButton.Position = UDim2.new(0.55, 0, 0.8, 0)
manualButton.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
manualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
manualButton.Text = "MANUAL (M)"
manualButton.Font = Enum.Font.Gotham
manualButton.TextSize = 11
manualButton.Parent = mainFrame

local manualCorner = Instance.new("UICorner")
manualCorner.CornerRadius = UDim.new(0, 6)
manualCorner.Parent = manualButton

-- Variables
local character
local rootPart
local lastLaunchTime = 0
local antiHitEnabled = true
local DETECTION_RANGE = 15
local LAUNCH_HEIGHT = 40
local LAUNCH_COOLDOWN = 1

-- Update slider functions
local function updateRangeSlider(value)
    DETECTION_RANGE = value
    rangeValue.Text = tostring(value)
    local percentage = (value - 5) / 45 -- от 5 до 50
    rangeSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
end

local function updateHeightSlider(value)
    LAUNCH_HEIGHT = value
    heightValue.Text = tostring(value)
    local percentage = (value - 10) / 90 -- от 10 до 100
    heightSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
end

-- Slider dragging
local function setupSlider(slider, min, max, current, updateFunc)
    slider.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderAbsPos = slider.AbsolutePosition
            local sliderAbsSize = slider.AbsoluteSize
            
            local relativeX = math.clamp((mouse.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
            local newValue = math.floor(min + relativeX * (max - min))
            
            updateFunc(newValue)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
end

-- Initialize sliders
setupSlider(rangeSlider, 5, 50, DETECTION_RANGE, updateRangeSlider)
setupSlider(heightSlider, 10, 100, LAUNCH_HEIGHT, updateHeightSlider)

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
    if not getCharacter() then return false end
    
    -- Check cooldown
    local currentTime = tick()
    if currentTime - lastLaunchTime < LAUNCH_COOLDOWN then
        return false
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
    statusLabel.Text = "Status: LAUNCHED!"
    
    print("🚀 Auto AntiHit: Launched " .. LAUNCH_HEIGHT .. " studs up!")
    
    -- Reset status after 0.5 second
    wait(0.5)
    if antiHitEnabled then
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.Text = "Status: ACTIVE"
    else
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.Text = "Status: DISABLED"
    end
    
    return true
end

-- Toggle AntiHit
local function toggleAntiHit()
    antiHitEnabled = not antiHitEnabled
    
    if antiHitEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        toggleButton.Text = "ENABLED"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.Text = "Status: ACTIVE"
        print("🛡️ Auto AntiHit: ENABLED")
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        toggleButton.Text = "DISABLED"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.Text = "Status: DISABLED"
        print("🛡️ Auto AntiHit: DISABLED")
    end
end

-- Update players display and check for launches
local function updateAntiHit()
    if not antiHitEnabled then return end
    if not getCharacter() then return end
    
    local nearbyPlayers = getNearbyPlayers()
    playersLabel.Text = "Nearby players: " .. #nearbyPlayers
    
    -- Change color based on number of players
    if #nearbyPlayers > 0 then
        playersLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Auto launch if players detected
        launchUp()
    else
        playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    end
end

-- GUI button events
toggleButton.MouseButton1Click:Connect(function()
    toggleAntiHit()
end)

manualButton.MouseButton1Click:Connect(function()
    if getCharacter() then
        launchUp()
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        if getCharacter() then
            launchUp()
        end
    end
end)

-- Start automatic AntiHit system
RunService.Heartbeat:Connect(function()
    updateAntiHit()
end)

-- Auto character update
player.CharacterAdded:Connect(function()
    getCharacter()
    lastLaunchTime = 0
    if antiHitEnabled then
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.Text = "Status: ACTIVE"
    end
    playersLabel.Text = "Nearby players: 0"
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
end)

print("🛡️ BoosterSteal - Auto AntiHit LOADED!")
print("M - Manual launch")
print("Toggle button - Enable/Disable auto launch")
print("Sliders - Adjust detection range and launch height")
print("Рофл принт")
