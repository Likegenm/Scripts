local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Настройки полета
local flySpeed = 50
local ascendSpeed = 35
local descendSpeed = 35

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Fly"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)  -- Увеличено для кнопок
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = mainFrame

-- Заголовок с кнопкой включения/выключения
local title = Instance.new("TextButton")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Fly OFF"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Кнопка поднятия (вверх)
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Size = UDim2.new(0, 60, 0, 30)
upButton.Position = UDim2.new(0.5, -65, 0.7, 0)
upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.Text = "UP ↑"
upButton.Font = Enum.Font.GothamBold
upButton.TextSize = 12
upButton.Visible = false  -- Скрыта по умолчанию
upButton.Parent = mainFrame

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 6)
upCorner.Parent = upButton

-- Кнопка спуска (вниз)
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Size = UDim2.new(0, 60, 0, 30)
downButton.Position = UDim2.new(0.5, 5, 0.7, 0)
downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.Text = "DOWN ↓"
downButton.Font = Enum.Font.GothamBold
downButton.TextSize = 12
downButton.Visible = false  -- Скрыта по умолчанию
downButton.Parent = mainFrame

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 6)
downCorner.Parent = downButton

-- Информационная метка
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 60)
infoLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Text = "J: Fly\nSPACE/↑: Up\nCTRL/↓: Down\nWASD: Move"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 10
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

-- Слайдер для скорости
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 20)
speedFrame.Position = UDim2.new(0.05, 0, 0.9, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Text = "Speed: 50"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 10
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0.6, 0, 1, 0)
speedSlider.Position = UDim2.new(0.4, 0, 0, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedSlider.Text = ""
speedSlider.Parent = speedFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)  -- Начальное значение 50%
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = sliderFill

-- Переменные для полета
local character
local rootPart
local humanoid
local flyEnabled = false
local flyConnection = nil
local isAscending = false
local isDescending = false

-- Функция для получения персонажа
local function getCharacter()
    character = player.Character
    if character then
        rootPart = character:FindFirstChild("HumanoidRootPart")
        humanoid = character:FindFirstChild("Humanoid")
        return rootPart ~= nil and humanoid ~= nil
    end
    return false
end

-- Функция для обновления скорости
local function updateFlySpeed(newSpeed)
    flySpeed = newSpeed
    ascendSpeed = newSpeed * 0.7
    descendSpeed = newSpeed * 0.7
    speedLabel.Text = "Speed: " .. math.floor(flySpeed)
    
    -- Анимация слайдера
    local percentage = (flySpeed - 10) / 90  -- от 10 до 100
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(percentage, 0, 1, 0)})
    tween:Play()
end

-- Обработка слайдера скорости
speedSlider.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local mouse = UserInputService:GetMouseLocation()
        local sliderAbsPos = speedSlider.AbsolutePosition
        local sliderAbsSize = speedSlider.AbsoluteSize
        
        local relativeX = math.clamp((mouse.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
        local newSpeed = math.floor(10 + relativeX * 90)  -- от 10 до 100
        
        updateFlySpeed(newSpeed)
    end)
    
    local function stopDragging()
        connection:Disconnect()
    end
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            stopDragging()
        end
    end)
end)

-- Функция применения полета
local function applyFly()
    if not getCharacter() then return end
    
    local camera = workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- Движение вперед/назад (W/S)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - lookVector
    end
    
    -- Движение влево/вправо (A/D)
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + rightVector
    end
    
    -- Нормализация направления
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flySpeed
    end
    
    -- Вертикальное движение
    local verticalSpeed = 0
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.Up) or isAscending then
        verticalSpeed = ascendSpeed
    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Down) or isDescending then
        verticalSpeed = -descendSpeed
    end
    
    -- Применение скорости
    rootPart.Velocity = Vector3.new(
        moveDirection.X,
        verticalSpeed,
        moveDirection.Z
    )
    
    -- Стабилизация когда не двигаемся
    if moveDirection.Magnitude == 0 and verticalSpeed == 0 then
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

-- Функция переключения полета
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyConnection = RunService.Heartbeat:Connect(function()
            if flyEnabled and getCharacter() then
                humanoid.PlatformStand = true
                applyFly()
            end
        end)
        
        title.Text = "Fly ON"
        title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        upButton.Visible = true
        downButton.Visible = true
        
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if getCharacter() then
            humanoid.PlatformStand = false
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
        
        title.Text = "Fly OFF"
        title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        upButton.Visible = false
        downButton.Visible = false
        isAscending = false
        isDescending = false
    end
end

-- Обработка кнопок
title.MouseButton1Click:Connect(function()
    toggleFly()
end)

upButton.MouseButton1Down:Connect(function()
    isAscending = true
    upButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
end)

upButton.MouseButton1Up:Connect(function()
    isAscending = false
    upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
end)

upButton.MouseLeave:Connect(function()
    isAscending = false
    upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
end)

downButton.MouseButton1Down:Connect(function()
    isDescending = true
    downButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
end)

downButton.MouseButton1Up:Connect(function()
    isDescending = false
    downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
end)

downButton.MouseLeave:Connect(function()
    isDescending = false
    downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
end)

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.J then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.Equals then
        -- Увеличить скорость (+)
        updateFlySpeed(math.min(flySpeed + 10, 100))
    elseif input.KeyCode == Enum.KeyCode.Minus then
        -- Уменьшить скорость (-)
        updateFlySpeed(math.max(flySpeed - 10, 10))
    end
end)

-- Сброс при смене персонажа
player.CharacterAdded:Connect(function()
    getCharacter()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    flyEnabled = false
    title.Text = "Fly OFF"
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    upButton.Visible = false
    downButton.Visible = false
    isAscending = false
    isDescending = false
end)

-- Индикация при нажатии кнопок
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flyEnabled then return end
    
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Up then
        upButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
    elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.Down then
        downButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed or not flyEnabled then return end
    
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Up then
        upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.Down then
        downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)

warn("FLY LIKEGENM AND JOIN MY SERVR DISCORD")
error("YOU NOT JOIN MY DISCORD")
print("Так что присоединись в дс и не пиздь скрипты")
