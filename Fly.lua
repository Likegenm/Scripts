local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Fly"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

local title = Instance.new("TextButton")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Fly OFF"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 50)
infoLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "J: Fly\nSPACE: Up\nCTRL: Down"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

local character
local rootPart
local humanoid
local flyEnabled = false
local flyConnection = nil

local function getCharacter()
    character = player.Character
    if character then
        rootPart = character:FindFirstChild("HumanoidRootPart")
        humanoid = character:FindFirstChild("Humanoid")
        return rootPart ~= nil and humanoid ~= nil
    end
    return false
end

local function applyFly()
    if not getCharacter() then return end
    
    local currentVelocity = rootPart.Velocity
    local walkSpeed = humanoid.WalkSpeed
    local targetYVelocity = 0
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        targetYVelocity = walkSpeed
    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        targetYVelocity = -walkSpeed
    else
        if currentVelocity.Y < 0 then
            targetYVelocity = currentVelocity.Y * 0.1
        else
            targetYVelocity = walkSpeed * 0.1
        end
    end
    
    rootPart.Velocity = Vector3.new(
        currentVelocity.X,
        targetYVelocity,
        currentVelocity.Z
    )
end

local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyConnection = RunService.Heartbeat:Connect(function()
            if flyEnabled then
                applyFly()
            end
        end)
        
        title.Text = "Fly ON"
        title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        title.Text = "Fly OFF"
        title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end

title.MouseButton1Click:Connect(function()
    toggleFly()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.J then
        toggleFly()
    end
end)

player.CharacterAdded:Connect(function()
    getCharacter()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    flyEnabled = false
    title.Text = "Fly OFF"
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

warn("FLY LIKEGENM AND JOIN MY SERVR DISCORD")
error("YOU NOT JOIN MY DICORD")
print("Так что присоеденись в дс и не пиздь скрипты")
