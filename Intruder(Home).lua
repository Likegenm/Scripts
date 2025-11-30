local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "The Intruder script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "IntruderConfig",
    IntroEnabled = true,
    IntroText = "The Intruder script",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MainLoadButton = MainTab:AddButton({
    Name = "Main load",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Main.lua"))()
    end    
})

local NoDurationTab = Window:MakeTab({
    Name = "NoDuration",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local NoDurationToggle = NoDurationTab:AddToggle({
    Name = "NoDuration",
    Default = false,
    Save = true,
    Flag = "NoDuration",
    Callback = function(Value)
        if Value then
            if workspace:FindFirstChild("Map") then
                local map = workspace.Map
                
                if map:FindFirstChild("LightSwitch") then
                    local lightSwitch = map.LightSwitch
                    
                    if lightSwitch:FindFirstChild("DownSwitch") then
                        local downSwitch = lightSwitch.DownSwitch
                        if downSwitch:FindFirstChild("ProximityPrompt") then
                            local prompt = downSwitch.ProximityPrompt
                            if prompt:FindFirstChild("Data") then
                                prompt.Data.HoldDuration = 0
                            end
                        end
                    end
                    
                    if lightSwitch:FindFirstChild("UpSwitch") then
                        local upSwitch = lightSwitch.UpSwitch
                        if upSwitch:FindFirstChild("ProximityPrompt") then
                            local prompt = upSwitch.ProximityPrompt
                            if prompt:FindFirstChild("Data") then
                                prompt.Data.HoldDuration = 0
                            end
                        end
                    end
                end
                
                if map:FindFirstChild("Phone") then
                    local phone = map.Phone
                    if phone:FindFirstChild("Speaker") then
                        local speaker = phone.Speaker
                        
                        local prompts = {
                            "AnswerGuide",
                            "AnswerGuide2", 
                            "CallPolice",
                            "FixPhone"
                        }
                        
                        for _, promptName in pairs(prompts) do
                            if speaker:FindFirstChild(promptName) then
                                local prompt = speaker[promptName]
                                if prompt:FindFirstChild("Data") then
                                    prompt.Data.HoldDuration = 0
                                end
                            end
                        end
                    end
                end
                
                if map:FindFirstChild("ClosetDoor") then
                    local closetDoor = map.ClosetDoor
                    if closetDoor:FindFirstChild("Handle") then
                        local handle = closetDoor.Handle
                        
                        local actions = {"Close", "Open"}
                        
                        for _, action in pairs(actions) do
                            if handle:FindFirstChild(action) then
                                local actionPart = handle[action]
                                if actionPart:FindFirstChild("Data") then
                                    actionPart.Data.HoldDuration = 0
                                end
                            end
                        end
                    end
                end
            end
            
            OrionLib:MakeNotification({
                Name = "NoDuration",
                Content = "NoDuration enabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "NoDuration", 
                Content = "NoDuration disabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})

OrionLib:Init()
