--Test
print("Test")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TestText"
textLabel.Size = UDim2.new(0, 200, 0, 50) -- Ширина 200, высота 50
textLabel.Position = UDim2.new(0.5, -100, 0.5, -25) -- Центр экрана
textLabel.AnchorPoint = Vector2.new(0.5, 0.5) -- Якорь в центре
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный фон
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
textLabel.Text = "TEST"
textLabel.TextScaled = true -- Автоматическое масштабирование текста
textLabel.Font = Enum.Font.GothamBold -- Жирный шрифт
textLabel.Parent = screenGui
textLabel.BackgroundTransparency = 0.5
