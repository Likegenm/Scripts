game:GetService("Workspace"):FindFirstChild("Lobby"):FIndFirstChild("Worker"):FindFirstChild("Torso"):FindFirstChild("ProximityPrompt"):FindFirstChild("HoldDuration") = 0
game:GetService("Workspace"):FindFirstChild("Lobby"):FIndFirstChild("Doors"):FindFirstChild("SecretDoor"):FindFirstChild("Handle"):FindFirstChild("ProximityPrompt"):FindFirstChild("HoldDuration") = 0
game.workspace:WaitForChild("HotelRoom")
if game.workspace.HotelRoom then
  game.workspace.HotelRoom.LightSwitch.DownSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.HotelRoom.LightSwitch.UpSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.HotelRoom.BathroomDoor.handle.ProximityPrompt.HoldDuration = 0

