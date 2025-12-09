local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "TSB Script",
    Author = "Likegenm",
    Folder = "ftgshub",
    Icon = "Code",
    IconSize = 44,
    NewElements = true,
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Desc = "LocalPlayer Settings",
    Icon = "user",
    IconColor = Color3.fromHex("#FF0000"),
})

local MainSection = PlayerTab:Section({
    Title = "Player Modifications"
})

-- Speed Hack
local speedHackEnabled = false
local speedValue = 50
local speedThread

MainSection:Toggle({
    Title = "Speed Hack",
    Desc = "Toggle speed hack",
    Icon = "zap",
    Callback = function(state)
        speedHackEnabled = state
        if speedThread then
            speedThread = nil
        end
        if state then
            speedThread = task.spawn(function()
                while speedHackEnabled and task.wait(0.1) do
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid.WalkSpeed = speedValue
                    end
                end
            end)
        end
    end
})

MainSection:Slider({
    Title = "Speed Value",
    Desc = "Adjust walk speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        speedValue = value
        if speedHackEnabled then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = value
            end
        end
    end
})

-- Infinite Jump
local infJumpEnabled = false
local jumpThread

MainSection:Toggle({
    Title = "Infinite Jump",
    Desc = "Toggle infinite jumping",
    Icon = "arrow-up",
    Callback = function(state)
        infJumpEnabled = state
        if jumpThread then
            jumpThread = nil
        end
        if state then
            jumpThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                
                while infJumpEnabled and task.wait() do
                    local character = player.Character
                    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            local currentVelocity = character.HumanoidRootPart.Velocity
                            character.HumanoidRootPart.Velocity = Vector3.new(
                                currentVelocity.X,
                                50,
                                currentVelocity.Z
                            )
                        end
                    end
                end
            end)
        end
    end
})

-- Fly Hack
local flyEnabled = false
local flySpeed = 80
local flyThread

MainSection:Toggle({
    Title = "Fly Hack",
    Desc = "Toggle flying (Press H to toggle in-game)",
    Icon = "bird",
    Callback = function(state)
        flyEnabled = state
        if flyThread then
            flyThread = nil
        end
        if state then
            flyThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                local RunService = game:GetService("RunService")
                
                local flying = false
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.H then
                        flying = not flying
                    end
                end)
                
                while flyEnabled and RunService.Heartbeat:Wait() do
                    if not flying then continue end
                    
                    local character = player.Character
                    if not character then continue end
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then continue end
                    
                    local camera = workspace.CurrentCamera
                    local lookVector = camera.CFrame.LookVector
                    local rightVector = camera.CFrame.RightVector
                    
                    local velocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - lookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - rightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + rightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        velocity = velocity + Vector3.new(0, -1, 0)
                    end
                    
                    if velocity.Magnitude > 0 then
                        velocity = velocity.Unit * flySpeed
                    end
                    
                    humanoidRootPart.Velocity = velocity
                end
            end)
        end
    end
})

MainSection:Slider({
    Title = "Fly Speed",
    Desc = "Adjust flying speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 200,
        Default = 80,
    },
    Callback = function(value)
        flySpeed = value
    end
})

MainSection:Space()

-- Player Exploits Section
local ExploitsSection = PlayerTab:Section({
    Title = "Player Exploits"
})

-- Anti-Freeze
local antiFreezeEnabled = false
local antiFreezeThread

ExploitsSection:Toggle({
    Title = "Anti-Freeze",
    Desc = "Prevents freeze effects",
    Icon = "snowflake",
    Callback = function(state)
        antiFreezeEnabled = state
        if antiFreezeThread then
            antiFreezeThread = nil
        end
        if state then
            antiFreezeThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiFreezeEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local freeze = character:FindFirstChild("Freeze")
                        if freeze then
                            freeze:Destroy()
                        end
                    end
                end
            end)
        end
    end
})

-- Anti-Slow
local antiSlowEnabled = false
local antiSlowThread

ExploitsSection:Toggle({
    Title = "Anti-Slow",
    Desc = "Prevents slow effects",
    Icon = "turtle",
    Callback = function(state)
        antiSlowEnabled = state
        if antiSlowThread then
            antiSlowThread = nil
        end
        if state then
            antiSlowThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiSlowEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local slowed = character:FindFirstChild("Slowed")
                        if slowed then
                            slowed:Destroy()
                        end
                    end
                end
            end)
        end
    end
})

-- Always Block
local alwaysBlockEnabled = false
local alwaysBlockThread

ExploitsSection:Toggle({
    Title = "Always Block",
    Desc = "Always allows blocking",
    Icon = "shield",
    Callback = function(state)
        alwaysBlockEnabled = state
        if alwaysBlockThread then
            alwaysBlockThread = nil
        end
        if state then
            alwaysBlockThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while alwaysBlockEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local NB = character:FindFirstChild("NoBlock")
                        if NB then
                            NB:Destroy()
                        end
                    end
                end
            end)
        end
    end
})

-- Anti-Debris
local antiDebrisEnabled = false
local antiDebrisThread

ExploitsSection:Toggle({
    Title = "Anti-Debris",
    Desc = "Removes small debris",
    Icon = "trash",
    Callback = function(state)
        antiDebrisEnabled = state
        if antiDebrisThread then
            antiDebrisThread = nil
        end
        if state then
            antiDebrisThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiDebrisEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local AD = character:FindFirstChild("Small Debris")
                        if AD then
                            AD:Destroy()
                        end
                    end
                end
            end)
        end
    end
})

-- Lag Hack
local lagHackEnabled = false
local lagHackThread

ExploitsSection:Toggle({
    Title = "Lag Hack",
    Desc = "Random effects and teleportation",
    Icon = "wifi-off",
    Callback = function(state)
        lagHackEnabled = state
        if lagHackThread then
            lagHackThread = nil
        end
        if state then
            lagHackThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local TeleportService = game:GetService("TeleportService")
                
                while lagHackEnabled do
                    -- Ждем случайное время (13-75 секунд)
                    local waitTime = math.random(13, 75)
                    task.wait(waitTime)
                    
                    if not lagHackEnabled then break end
                    
                    -- Выбираем случайный эффект
                    local effects = {"AntiFreeze", "AntiSlow", "AntiDebris"}
                    local randomEffect = effects[math.random(1, 3)]
                    
                    -- Включаем эффект на 12-24 секунды
                    local effectDuration = math.random(12, 24)
                    local effectStart = tick()
                    
                    while tick() - effectStart < effectDuration and lagHackEnabled do
                        local character = player.Character
                        if character then
                            if randomEffect == "AntiFreeze" then
                                local freeze = character:FindFirstChild("Freeze")
                                if freeze then freeze:Destroy() end
                            elseif randomEffect == "AntiSlow" then
                                local slowed = character:FindFirstChild("Slowed")
                                if slowed then slowed:Destroy() end
                            elseif randomEffect == "AntiDebris" then
                                local AD = character:FindFirstChild("Small Debris")
                                if AD then AD:Destroy() end
                            end
                        end
                        task.wait(0.01)
                    end
                    
                    if not lagHackEnabled then break end
                    
                    -- Сохраняем позицию для телепортации
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local savedPosition = character.HumanoidRootPart.Position
                        
                        -- Случайное количество телепортаций (20-50 раз)
                        local teleportCount = math.random(20, 50)
                        
                        for i = 1, teleportCount do
                            if not lagHackEnabled then break end
                            
                            -- Ждем 1-3 секунды
                            task.wait(math.random(1, 3))
                            
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                -- Телепортируем на сохраненную позицию
                                character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
                            end
                        end
                    end
                end
            end)
        end
    end
})

ExploitsSection:Space()

-- Кнопка для отключения всех эксплоитов
ExploitsSection:Button({
    Title = "Disable All",
    Icon = "power",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        -- Отключаем все тогглы
        speedHackEnabled = false
        if speedThread then speedThread = nil end
        
        infJumpEnabled = false
        if jumpThread then jumpThread = nil end
        
        flyEnabled = false
        if flyThread then flyThread = nil end
        
        antiFreezeEnabled = false
        if antiFreezeThread then antiFreezeThread = nil end
        
        antiSlowEnabled = false
        if antiSlowThread then antiSlowThread = nil end
        
        alwaysBlockEnabled = false
        if alwaysBlockThread then alwaysBlockThread = nil end
        
        antiDebrisEnabled = false
        if antiDebrisThread then antiDebrisThread = nil end
        
        lagHackEnabled = false
        if lagHackThread then lagHackThread = nil end
        
        -- Восстанавливаем стандартную скорость
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
        
        WindUI:Notify({
            Title = "All Features Disabled",
            Content = "All player modifications have been disabled!",
            Icon = "check"
        })
    end
})
