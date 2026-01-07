local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 2147483647
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 75)
frame.Position = UDim2.new(1, -310, 1, -110)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.ZIndex = 2147483647
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "IntruderPos:"
title.Size = UDim2.new(1, 0, 0.5, 0)
title.ZIndex = 2147483647
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Name = "ValueLabel"
subtitle.Text = "Waiting..."
subtitle.Size = UDim2.new(1, 0, 0.5, 0)
subtitle.Position = UDim2.new(0, 0, 0.5, 0)
subtitle.ZIndex = 2147483647
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.new(1, 1, 1)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 20
subtitle.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.new(1, 1, 1)
frameStroke.Thickness = 3
frameStroke.Transparency = 0.5
frameStroke.Parent = frame

RunService.Heartbeat:Connect(function()
    local value = game.workspace.Values.intruderPos.Value
    subtitle.Text = tostring(value)
end)

local isDragging = false
local dragOffset = Vector2.new(0, 0)

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        local framePos = frame.AbsolutePosition
        local mousePos = input.Position
        dragOffset = Vector2.new(framePos.X - mousePos.X, framePos.Y - mousePos.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isDragging then
        local mousePos = UserInputService:GetMouseLocation()
        frame.Position = UDim2.new(0, mousePos.X + dragOffset.X, 0, mousePos.Y + dragOffset.Y)
    end
end)
