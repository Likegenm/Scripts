local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 75)
frame.Position = UDim2.new(1, -310, 1, -110)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "IntruderPos:"
title.Size = UDim2.new(1, 0, 0.5, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Name = "ValueLabel"
subtitle.Text = "Loading..."
subtitle.Size = UDim2.new(1, 0, 0.5, 0)
subtitle.Position = UDim2.new(0, 0, 0.5, 0)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.new(1, 1, 1)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 20
subtitle.Parent = frame

local topDragBar = Instance.new("Frame")
topDragBar.Size = UDim2.new(1, 0, 0, 15)
topDragBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
topDragBar.BackgroundTransparency = 0.8
topDragBar.BorderSizePixel = 0
topDragBar.Parent = frame

local bottomDragBar = Instance.new("Frame")
bottomDragBar.Size = UDim2.new(1, 0, 0, 15)
bottomDragBar.Position = UDim2.new(0, 0, 1, -15)
bottomDragBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
bottomDragBar.BackgroundTransparency = 0.8
bottomDragBar.BorderSizePixel = 0
bottomDragBar.Parent = frame

local leftDragBar = Instance.new("Frame")
leftDragBar.Size = UDim2.new(0, 15, 1, -30)
leftDragBar.Position = UDim2.new(0, 0, 0, 15)
leftDragBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
leftDragBar.BackgroundTransparency = 0.8
leftDragBar.BorderSizePixel = 0
leftDragBar.Parent = frame

local rightDragBar = Instance.new("Frame")
rightDragBar.Size = UDim2.new(0, 15, 1, -30)
rightDragBar.Position = UDim2.new(1, -15, 0, 15)
rightDragBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
rightDragBar.BackgroundTransparency = 0.8
rightDragBar.BorderSizePixel = 0
rightDragBar.Parent = frame

local isDragging = false
local dragOffset = Vector2.new(0, 0)

local function startDragging(input)
    isDragging = true
    local framePos = frame.AbsolutePosition
    local mousePos = input.Position
    dragOffset = Vector2.new(framePos.X - mousePos.X, framePos.Y - mousePos.Y)
end

local dragBars = {topDragBar, bottomDragBar, leftDragBar, rightDragBar}
for _, dragBar in pairs(dragBars) do
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDragging(input)
        end
    end)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDragging(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
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

local function updateValue()
    local intruderPos = game.workspace.Values.intruderPos.Value
    if intruderPos then
        subtitle.Text = tostring(intruderPos)
    else
        subtitle.Text = "Not Found"
    end
end

while true do
    updateValue()
    task.wait(1)
end
