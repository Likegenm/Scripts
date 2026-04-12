workspace.FallenPartsDestroyHeight = 0/0

game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum and hum.Health <= 0 then
        hum.Health = hum.MaxHealth
    end
end)

local p = Instance.new("Part")
p.Name = "VoidFloor"
p.Parent = workspace
p.Size = Vector3.new(2048, 5, 2048)
p.Position = Vector3.new(0, -5000, 0)
p.Anchored = true
p.Color = Color3.new(0, 0, 0)
p.Transparency = 0.7
p.CanCollide = true
