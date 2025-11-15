local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Likegenm Scripts",
   LoadingTitle = "IHub",
   LoadingSubtitle = "by Likegenm",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "IHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

local SpeedhackToggle = false
local SpeedhackValue = 50

local FlyToggle = false
local FlySpeed = 50
local FlyUpSpeed = 50
local FlyDownSpeed = 50

local FullBrightToggle = false

local FovChangerToggle = false
local FovValue = 70

local NoclipToggle = false

local Section = Tab:CreateSection("Movement")

local SpeedToggle = Tab:CreateToggle({
   Name = "Speedhack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedhackToggle = Value
      if SpeedhackToggle then
          while SpeedhackToggle and wait() do
              if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                  game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedhackValue
              end
          end
      else
          if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
              game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
          end
      end
   end,
})

local SpeedSlider = Tab:CreateSlider({
   Name = "Speed Value",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "SpeedSlider",
   Callback = function(Value)
      SpeedhackValue = Value
      if SpeedhackToggle and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedhackValue
      end
   end,
})

local FlyToggleBtn = Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      FlyToggle = Value
      if FlyToggle then
          local player = game.Players.LocalPlayer
          local character = player.Character or player.CharacterAdded:Wait()
          local humanoid = character:WaitForChild("Humanoid")
          
          local bodyVelocity = Instance.new("BodyVelocity")
          bodyVelocity.Name = "FlyBodyVelocity"
          bodyVelocity.Parent = character.HumanoidRootPart
          bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
          
          while FlyToggle and wait() do
              if character and character.HumanoidRootPart then
                  local cam = workspace.CurrentCamera
                  local moveDirection = Vector3.new()
                  
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                      moveDirection = moveDirection + cam.CFrame.LookVector
                  end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                      moveDirection = moveDirection - cam.CFrame.LookVector
                  end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                      moveDirection = moveDirection - cam.CFrame.RightVector
                  end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                      moveDirection = moveDirection + cam.CFrame.RightVector
                  end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                      moveDirection = moveDirection + Vector3.new(0, FlyUpSpeed/50, 0)
                  end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                      moveDirection = moveDirection - Vector3.new(0, FlyDownSpeed/50, 0)
                  end
                  
                  bodyVelocity.Velocity = moveDirection * FlySpeed
              end
          end
          
          if bodyVelocity then
              bodyVelocity:Destroy()
          end
      else
          local character = game.Players.LocalPlayer.Character
          if character then
              local bodyVelocity = character.HumanoidRootPart:FindFirstChild("FlyBodyVelocity")
              if bodyVelocity then
                  bodyVelocity:Destroy()
              end
          end
      end
   end,
})

local FlySpeedSlider = Tab:CreateSlider({
   Name = "Fly Speed",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value)
      FlySpeed = Value
   end,
})

local FlyUpSlider = Tab:CreateSlider({
   Name = "Fly Up Speed",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlyUpSlider",
   Callback = function(Value)
      FlyUpSpeed = Value
   end,
})

local FlyDownSlider = Tab:CreateSlider({
   Name = "Fly Down Speed",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlyDownSlider",
   Callback = function(Value)
      FlyDownSpeed = Value
   end,
})

local Section2 = Tab:CreateSection("Visual")

local FullBrightBtn = Tab:CreateToggle({
   Name = "FullBright",
   CurrentValue = false,
   Flag = "FullBrightToggle",
   Callback = function(Value)
      FullBrightToggle = Value
      if FullBrightToggle then
          game:GetService("Lighting").GlobalShadows = false
          game:GetService("Lighting").Brightness = 2
      else
          game:GetService("Lighting").GlobalShadows = true
          game:GetService("Lighting").Brightness = 1
      end
   end,
})

local FovToggle = Tab:CreateToggle({
   Name = "FOV Changer",
   CurrentValue = false,
   Flag = "FovToggle",
   Callback = function(Value)
      FovChangerToggle = Value
      if FovChangerToggle then
          while FovChangerToggle and wait() do
              if workspace.CurrentCamera then
                  workspace.CurrentCamera.FieldOfView = FovValue
              end
          end
      else
          if workspace.CurrentCamera then
              workspace.CurrentCamera.FieldOfView = 70
          end
      end
   end,
})

local FovSlider = Tab:CreateSlider({
   Name = "FOV Value",
   Range = {1, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FovSlider",
   Callback = function(Value)
      FovValue = Value
      if FovChangerToggle and workspace.CurrentCamera then
          workspace.CurrentCamera.FieldOfView = FovValue
      end
   end,
})

local Section3 = Tab:CreateSection("Other")

local NoclipBtn = Tab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      NoclipToggle = Value
      if NoclipToggle then
          local player = game.Players.LocalPlayer
          local character = player.Character or player.CharacterAdded:Wait()
          
          for _, part in pairs(character:GetDescendants()) do
              if part:IsA("BasePart") then
                  part.CanCollide = false
              end
          end
          
          character.DescendantAdded:Connect(function(part)
              if part:IsA("BasePart") then
                  part.CanCollide = false
              end
          end)
      else
          local character = game.Players.LocalPlayer.Character
          if character then
              for _, part in pairs(character:GetDescendants()) do
                  if part:IsA("BasePart") then
                      part.CanCollide = true
                  end
              end
          end
      end
   end,
})

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Main tab has been successfully loaded!",
   Duration = 3,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay",
         Callback = function()
         print("User acknowledged notification")
      end
   },
},
})

print("Likegenm scripts Main loading")
