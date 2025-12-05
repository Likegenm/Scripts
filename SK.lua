local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Window = Library:CreateWindow({
    Title = "SK (Likegenm)",
    Center = true,
    AutoShow = true,
})

-- ВКЛАДКА "MAIN"
local MainTab = Window:AddTab("Player", "user")
local LeftGroup = MainTab:AddLeftGroupbox("Players")

LeftGroup:AddInput("WalkSpeedInput", {
    Default = "16",
    Numeric = true,
    Finished = false,
    Text = "Speedhack",
    Placeholder = "Inpur:",
    
    Callback = function(Value)
        if Value and tonumber(Value) then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = tonumber(Value)
            end
        end
    end
})

LeftGroup:AddToggle("InfJumpToggle", {
    Text = "Inf Jump",
    Default = false,
    
    Callback = function(Value)
        getgenv().InfJumpEnabled = Value
        local UserInputService = game:GetService("UserInputService")
        
        if Value then
            getgenv().InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                if getgenv().InfJumpEnabled then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState("Jumping")
                    end
                end
            end)
        else
            if getgenv().InfJumpConnection then
                getgenv().InfJumpConnection:Disconnect()
            end
        end
    end
})
