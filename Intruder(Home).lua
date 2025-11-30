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
            local function SetHoldDurationToZero(Object)
                if Object then
                    for _, Child in pairs(Object:GetDescendants()) do
                        if Child.Name == "Data" and Child:IsA("Configuration") then
                            for _, AttributeName in pairs(Child:GetAttributes()) do
                                if string.lower(tostring(AttributeName)) == "holdduration" then
                                    Child:SetAttribute("HoldDuration", 0)
                                end
                            end
                        end
                    end
                end
            end

            if workspace:FindFirstChild("Map") then
                local Map = workspace.Map
                
                local ObjectsToModify = {
                    Map:FindFirstChild("LightSwitch"),
                    Map:FindFirstChild("Phone"),
                    Map:FindFirstChild("ClosetDoor")
                }
                
                for _, Object in pairs(ObjectsToModify) do
                    SetHoldDurationToZero(Object)
                end
            end
            
            OrionLib:MakeNotification({
                Name = "NoDuration",
                Content = "NoDuration Enabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "NoDuration", 
                Content = "NoDuration Disabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end    
})

OrionLib:Init()
