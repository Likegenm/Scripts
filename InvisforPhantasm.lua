local key = Enum.KeyCode.Z

local invis_on = false
local defaultSpeed = 16
local boostedSpeed = 48
local isSpeedBoosted = false

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
local toggleButton = Instance.new("TextButton", frame)
local closeButton = Instance.new("TextButton", frame)
local signatureLabel = Instance.new("TextLabel", frame)
local speedButton = Instance.new("TextButton", frame)

screenGui.ResetOnSpawn = false

frame.Size = UDim2.new(0, 100, 0, 110)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true

toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 30)
toggleButton.Text = "invisible"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.RobotoMono
toggleButton.TextScaled = true

closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 123, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.RobotoMono
closeButton.TextSize = 18

signatureLabel.Size = UDim2.new(0, 100, 0, 10)
signatureLabel.Position = UDim2.new(0, 0, 0.9, 0)
signatureLabel.Text = "by Likegenm!"
signatureLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
signatureLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
signatureLabel.Font = Enum.Font.RobotoMono
signatureLabel.TextScaled = true
signatureLabel.Transparency = 0.3

speedButton.Size = UDim2.new(0, 80, 0, 30)
speedButton.Position = UDim2.new(0, 10, 0, 65)
speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedButton.Text = "speed!"
speedButton.TextScaled = true
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.RobotoMono

local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
sound.SoundId = "rbxassetid://942127495"
sound.Volume = 1

local invisX = 99999999
local invisY = -99999999
local invisZ = 99999999

local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

local function teleportToInvisLocation()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(invisX, invisY, invisZ)
    end
end

local function toggleInvisibility()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    invis_on = not invis_on
    sound:Play()

    if invis_on then
        local savedpos = character.HumanoidRootPart.CFrame

        task.wait()

        teleportToInvisLocation()

        task.wait(0.15)

        local Seat = Instance.new('Seat', game.Workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(invisX, invisY, invisZ)

        local Weld = Instance.new("Weld", Seat)
        local torso = character:FindFirstChild("Torso") or 
                      character:FindFirstChild("UpperTorso")
        if torso then
            Weld.Part0 = Seat
            Weld.Part1 = torso
        end

        task.wait()

        Seat.CFrame = savedpos

        setTransparency(character, 0.5)

        game.StarterGui:SetCore("SendNotification", {
            Title = "turned on invis!",
            Duration = 3,
            Text = string.format("X: %.0f, Y: %.0f, Z: %.0f", invisX, invisY, invisZ)
        })
    else
        local invisChair = workspace:FindFirstChild('invischair')
        if invisChair then
            invisChair:Destroy()
        end
        setTransparency(character, 0)
        game.StarterGui:SetCore("SendNotification", {
            Title = "turned off invis!",
            Duration = 3,
            Text = "!"
        })
    end
end

local function toggleSpeedBoost()
    isSpeedBoosted = not isSpeedBoosted
    sound:Play()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if isSpeedBoosted then
            humanoid.WalkSpeed = boostedSpeed
            speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Speed Boost (on)",
                Duration = 3,
                Text = "Speed: " .. boostedSpeed
            })
        else
            humanoid.WalkSpeed = defaultSpeed
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Speed Boost (off)",
                Duration = 3,
                Text = "Speed: " .. defaultSpeed
            })
        end
    end
end

toggleButton.MouseButton1Click:Connect(toggleInvisibility)
speedButton.MouseButton1Click:Connect(toggleSpeedBoost)
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

player.CharacterAdded:Connect(function(character)
    isSpeedBoosted = false
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = defaultSpeed
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)

local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == key then
        toggleInvisibility()
    end
end)
