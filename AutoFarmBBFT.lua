local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gravityNormal = workspace.Gravity
local isRunning = false
local speed = 375
local currentTween = nil

local destinations = {
    CFrame.new(-43.6134491, 62.1137619, 672.744934, -0.999842644, -0.00183729955, 0.017645346, 0, 0.994622767, 0.103564225, -0.0177407414, 0.103547923, -0.994466245),
    CFrame.new(-60.1504707, 97.4659729, 8767.91406, -0.99889338, 0.000705028593, 0.0470264405, 0, 0.999887645, -0.0149902813, -0.047031723, -0.0149736926, -0.998781145),
    CFrame.new(-54.331871, -345.398346, 9488.60645, -0.98221302, 0, 0.187770084, 0, 1, 0, -0.187770084, 0, -0.98221302),
}

local function moveTo(targetCFrame, setGravity)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed

    currentTween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()

    local reached = false
    currentTween.Completed:Connect(function()
        reached = true
    end)

    if setGravity then
        workspace.Gravity = gravityNormal
    else
        workspace.Gravity = 0
    end

    while not reached and isRunning do
        RunService.Heartbeat:Wait()
    end
end

task.spawn(function()
    while true do
        task.wait(10)
        if isRunning then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, game)
        end
    end
end)

local function autoFarmLoop()
    while isRunning do
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end

        for i, cf in ipairs(destinations) do
            if not isRunning then return end
            moveTo(cf, i == #destinations)
        end

        repeat task.wait(1) until not isRunning or not player.Character
    end
end

local function startAutoFarm()
    if isRunning then return end
    isRunning = true
    task.spawn(autoFarmLoop)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AutoFarm",
        Text = "Started",
        Duration = 2
    })
end

local function stopAutoFarm()
    isRunning = false
    workspace.Gravity = gravityNormal
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AutoFarm",
        Text = "Stopped",
        Duration = 2
    })
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.R then
        if isRunning then
            stopAutoFarm()
        else
            startAutoFarm()
        end
    end
end)

player.CharacterAdded:Connect(function()
    if isRunning then
        task.wait(1)
        task.spawn(autoFarmLoop)
    end
end)
