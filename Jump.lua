-- Custom High Jump with GUI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 250)
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
title.Text = "🚀 CUSTOM HIGH JUMP"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 35)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "🟢 ENABLE HIGH JUMP"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Power Display
local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(0.9, 0, 0, 20)
powerLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
powerLabel.BackgroundTransparency = 1
powerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
powerLabel.Text = "Jump Power: 100"
powerLabel.Font = Enum.Font.Gotham
powerLabel.TextSize = 12
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.Parent = mainFrame

-- Input Frame
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(0.9, 0, 0, 60)
inputFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
inputFrame.BackgroundTransparency = 1
inputFrame.Parent = mainFrame

local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.Position = UDim2.new(0, 0, 0, 0)
inputLabel.BackgroundTransparency = 1
inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
inputLabel.Text = "Enter power (50-500):"
inputLabel.Font = Enum.Font.Gotham
inputLabel.TextSize = 11
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = inputFrame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.6, 0, 0, 30)
textBox.Position = UDim2.new(0, 0, 0, 25)
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textBox.PlaceholderText = "Enter number..."
textBox.Text = "100"
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 12
textBox.TextXAlignment = Enum.TextXAlignment.Center
textBox.Parent = inputFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

local setButton = Instance.new("TextButton")
setButton.Size = UDim2.new(0.35, 0, 0, 30)
setButton.Position = UDim2.new(0.65, 0, 0, 25)
setButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
setButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setButton.Text = "SET"
setButton.Font = Enum.Font.Gotham
setButton.TextSize = 12
setButton.Parent = inputFrame

local setButtonCorner = Instance.new("UICorner")
setButtonCorner.CornerRadius = UDim.new(0, 6)
setButtonCorner.Parent = setButton

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: DISABLED"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = mainFrame

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "C: Toggle | Enter: Set Power | SPACE: Jump"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.Parent = mainFrame

-- Variables
local jumpEnabled = false
local character
local rootPart
local jumpPower = 100

-- Get character function
local function getCharacter()
    character = player.Character
    if character then
        rootPart = character:FindFirstChild("HumanoidRootPart")
        return rootPart ~= nil
    end
    return false
end

-- High Jump function
local function performHighJump()
    if not jumpEnabled then return end
    if not getCharacter() then return end
    
    -- High jump with custom power
    rootPart.Velocity = Vector3.new(
        rootPart.Velocity.X,
        jumpPower,
        rootPart.Velocity.Z
    )
    
    print("Jump power: " .. jumpPower)
end

-- Update power display
local function updatePowerDisplay()
    powerLabel.Text = "Jump Power: " .. jumpPower
    textBox.Text = tostring(jumpPower)
end

-- Set jump power
local function setJumpPower(newPower)
    jumpPower = math.clamp(newPower, 50, 500)
    updatePowerDisplay()
    print("Jump power set to: " .. jumpPower)
end

-- Validate and set power from text input
local function setPowerFromInput()
    local inputText = textBox.Text
    local number = tonumber(inputText)
    
    if number then
        setJumpPower(number)
        textBox.Text = tostring(jumpPower)
    else
        textBox.Text = tostring(jumpPower)
        print("Please enter a valid number!")
    end
end

-- Toggle Jump
local function toggleJump()
    jumpEnabled = not jumpEnabled
    
    if jumpEnabled then
        -- ENABLE
        toggleButton.Text = "🔴 DISABLE HIGH JUMP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        statusLabel.Text = "Status: ENABLED"
        
        print("HIGH JUMP ENABLED - Power: " .. jumpPower)
    else
        -- DISABLE
        toggleButton.Text = "🟢 ENABLE HIGH JUMP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "Status: DISABLED"
        
        print("HIGH JUMP DISABLED")
    end
end

-- Event handlers
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space and jumpEnabled then
        performHighJump()
    end
    
    -- C to toggle jump on/off
    if input.KeyCode == Enum.KeyCode.C then
        toggleJump()
    end
    
    -- Enter to set power from textbox
    if input.KeyCode == Enum.KeyCode.Return then
        setPowerFromInput()
    end
end)

-- GUI click handlers
toggleButton.MouseButton1Click:Connect(toggleJump)

setButton.MouseButton1Click:Connect(setPowerFromInput)

-- Textbox focus handling
textBox.Focused:Connect(function()
    textBox.Text = ""
end)

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        setPowerFromInput()
    else
        textBox.Text = tostring(jumpPower)
    end
end)

-- Auto character update
player.CharacterAdded:Connect(function()
    getCharacter()
end)

-- Initialize
updatePowerDisplay()

print("✅ CUSTOM HIGH JUMP WITH INPUT LOADED!")
print("C - Toggle High Jump On/Off")
print("Enter number in box - Set exact power (50-500)")
print("SPACE - Jump with current power")
