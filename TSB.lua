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
    Title = "New script",
    Desc = "script",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF0000"),
})

local MainSection = PlayerTab:Section({
    Title = "Script"
})

MainSection:Button({
        Title = "Script load",
        Color = Color3.fromHex("#FF0000"),
        Justify = "Center",
        IconAlign = "Left",
        Icon = "skull",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/TSB.lua"))()
        end
    })
