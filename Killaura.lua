-- Загрузка библиотеки Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "Likegenm Hub",
   LoadingTitle = "SBHub",
   LoadingSubtitle = "by Likegenm",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "LikegenmHub",
      FileName = "LikegenmConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "ppCF95m5h",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Создание вкладок
local MainTab = Window:CreateTab("Main", 0) -- Scripts
local HelperTab = Window:CreateTab("Helper", 0) -- Steal Helper
local SettingsTab = Window:CreateTab("Settings", 0) -- Configuration

-- Уведомление при загрузке
Rayfield:Notify({
   Title = "Likegenm Hub Loaded",
   Content = "Welcome to LikeGenm Hub!",
   Duration = 3,
   Image = 0,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function()
            print("User acknowledged notification")
         end
      },
   },
})

-- Вкладка MAIN
local MainSection = MainTab:CreateSection("Movement Scripts")

-- Speed Hack
local speedHackEnabled = false
local SpeedToggle = MainTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedHackToggle",
   Callback = function(Value)
      speedHackEnabled = Value
      if Value then
         local player = game.Players.LocalPlayer
         local rebirths = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Rebirths")
         
         if rebirths and rebirths.Value >= 3 then
            local shop = game.Workspace:FindFirstChild("Shop")
            if shop then
               local shopNPC = shop:FindFirstChild("ShopNPCCash")
               if shopNPC then
                  local openInterface = shopNPC:FindFirstChild("OpenInterface")
                  if openInterface then
                     local maxDistance = openInterface:FindFirstChild("MaxActivationDistance")
                     if maxDistance then
                        maxDistance.Value = 1000000
                        
                        Rayfield:Notify({
                           Title = "Buy for speed",
                           Content = "Buy Grapple Hook for Speed Hack to work",
                           Duration = 5,
                        })
                        
                        spawn(function()
                           while speedHackEnabled do
                              local backpack = player:FindFirstChild("Backpack")
                              if backpack then
                                 local grapple = backpack:FindFirstChild("Grapple Hook")
                                 if grapple then
                                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                    if humanoid then
                                       humanoid:EquipTool(grapple)
                                       
                                       for i = 1, 100 do
                                          if not speedHackEnabled then break end
                                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                          wait(0.01)
                                       end
                                    end
                                 end
                              end
                              wait(0.1)
                           end
                        end)
                     end
                  end
               end
            end
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "Need at least 3 rebirths for Speed Hack",
               Duration = 5,
            })
            SpeedToggle:Set(false)
         end
      end
   end,
})

-- Infinite Jump
MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Infjump.lua"))()
      Rayfield:Notify({
         Title = "Infinite Jump",
         Content = "Script loaded! Press Space to jump infinitely",
         Duration = 4,
      })
   end,
})

-- Float
MainTab:CreateButton({
   Name = "Float",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/float.lua"))()
      Rayfield:Notify({
         Title = "Float",
         Content = "Float script loaded!",
         Duration = 3,
      })
   end,
})

-- High Jump
MainTab:CreateButton({
   Name = "High Jump",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Jump.lua"))()
      Rayfield:Notify({
         Title = "High Jump",
         Content = "High Jump script loaded!",
         Duration = 3,
      })
   end,
})

-- Fly
MainTab:CreateButton({
   Name = "Fly",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Fly.lua"))()
      Rayfield:Notify({
         Title = "Fly",
         Content = "Fly script loaded! Press Z to toggle",
         Duration = 4,
      })
   end,
})

-- Разделитель
MainTab:CreateSection("Scripts Loader")

-- Вкладка HELPER
local HelperSection = HelperTab:CreateSection("Helper Scripts")

-- Steal Helper
HelperTab:CreateButton({
   Name = "Steal Helper",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/STealHelper.lua"))()
      Rayfield:Notify({
         Title = "Steal Helper",
         Content = "Steal Helper script loaded!",
         Duration = 3,
      })
   end,
})

-- Anti Hit
HelperTab:CreateButton({
   Name = "Anti Hit",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/AntiHit.lua"))()
      Rayfield:Notify({
         Title = "Anti Hit",
         Content = "Anti Hit script loaded!",
         Duration = 3,
      })
   end,
})

-- Вкладка SETTINGS
local ThemeSection = SettingsTab:CreateSection("UI Settings")

-- Выбор темы
local themes = {
   "Dark",
   "Light", 
   "Midnight",
   "Sunset",
   "Ocean",
   "Forest",
   "Crimson",
   "Amethyst",
   "Emerald",
   "Ruby",
   "Sapphire",
   "Gold",
   "Silver",
   "Cyber",
   "Neon"
}

SettingsTab:CreateDropdown({
   Name = "UI Theme",
   Options = themes,
   CurrentOption = {"Dark"},
   MultipleOptions = false,
   Flag = "UITheme",
   Callback = function(Option)
      Rayfield:Notify({
         Title = "Theme Changed",
         Content = "Applied: " .. Option[1],
         Duration = 3,
      })
   end,
})

-- Keybind для интерфейса
SettingsTab:CreateKeybind({
   Name = "UI Toggle Key",
   CurrentKeybind = "RightControl",
   HoldToInteract = false,
   Flag = "UIToggleKey",
   Callback = function(Keybind)
      Rayfield:Notify({
         Title = "Keybind Set",
         Content = "UI Toggle: " .. Keybind,
         Duration = 3,
      })
   end,
})

-- Информационная секция
local InfoSection = SettingsTab:CreateSection("Information")

-- Параграф с информацией
SettingsTab:CreateParagraph({
   Title = "LikeGenm Hub v1.0", 
   Content = "Script by LikeGenm\nJoin my Discord: discord.gg/ppCF95m5h"
})

-- Кнопка для копирования Discord
SettingsTab:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
      setclipboard("https://discord.gg/ppCF95m5h")
      Rayfield:Notify({
         Title = "Copied!",
         Content = "Discord link copied to clipboard",
         Duration = 3,
      })
   end,
})

-- Функция для остановки всех скриптов при закрытии
game:GetService("Players").PlayerRemoving:Connect(function(player)
   if player == game.Players.LocalPlayer then
      speedHackEnabled = false
   end
end)

-- Уведомление об успешной загрузке
wait(1)
Rayfield:Notify({
   Title = "Hub Ready",
   Content = "All features loaded successfully!",
   Duration = 4,
})
