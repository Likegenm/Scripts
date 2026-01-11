game:GetService("Workspace"):FindFirstChild("Lobby"):FIndFirstChild("Worker"):FindFirstChild("Torso"):FindFirstChild("ProximityPrompt"):FindFirstChild("HoldDuration") = 0
game:GetService("Workspace"):FindFirstChild("Lobby"):FIndFirstChild("Doors"):FindFirstChild("SecretDoor"):FindFirstChild("Handle"):FindFirstChild("ProximityPrompt"):FindFirstChild("HoldDuration") = 0
game.workspace:WaitForChild("HotelRoom")
if game.workspace.HotelRoom then
  game.workspace.HotelRoom.LightSwitcher.DownSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.HotelRoom.LightSwitcher.UpSwitch.ProximityPrompt.HoldDuration = 0
