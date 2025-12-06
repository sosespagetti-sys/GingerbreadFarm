local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 10)
local function TeleportSequence()
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 10)
local humanoid = char:WaitForChild("Humanoid", 10)  
if not hrp or not humanoid then
warn("X Character/Humanoid nicht gefunden! Respawn und versuche erneut.")
return
end      
hrp.CFrame = CFrame.new(-287.2, 27.4, -1626.0)  
task.wait(0.8)
end
local function WaitText()
while true do
countLabel.Text = " No Gingerbread Found Waiting for next day. "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day.. "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day... "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day. "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day.. "
task.wait(1)
countLabel.Text = " No Gingerbread Found Waiting for next day... "
end
end
for _, gui in ipairs(PlayerGui:GetChildren()) do
if gui.Name == "GingerbreadFarmGui" then
gui:Destroy()
end
end
if _G.GfarmLoop then
coroutine.close(_G.GfarmLoop)
end
_G.GingerbreadFarm = _G.GingerbreadFarm or {active = false, waiting = false, wait_start = 0}
local SAFE_CFRAME = CFrame.new(-286.3, 40.5, -1628.2)
local function getRigs()
local rigs = {}
local interiors = workspace:FindFirstChild("Interiors")
if interiors then
local christmas = interiors:FindFirstChild("MainMap!Christmas")
if christmas then
for _, child in ipairs(christmas:GetChildren()) do
if child.Name == "GingerbreadRig" and child:IsA("Model") then
local hrp = child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart
if hrp and hrp:IsA("BasePart") then
local offset = Vector3.new(math.random(-2, 2), 3, math.random(-2, 2))
table.insert(rigs, hrp.CFrame + offset)
end end end end end
return rigs end
local function tpTo(cf)
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 5)
if hrp then
hrp.CFrame = cf end end
local loopCo = coroutine.create(function()
while true do
wait(0.2)
local state = _G.GingerbreadFarm
if not state.active then continue end
local char = player.Character
if not char then continue end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local pos = hrp.Position
local rigs = getRigs()
if countLabel then
countLabel.Text = "Left: " .. #rigs
end
if #rigs > 0 then
countLabel.Text = "Left: " .. #rigs 
state.waiting = false
local nearest_cf = nil
local min_dist = math.huge
for _, rig_cf in ipairs(rigs) do
local dist = (rig_cf.Position - pos).Magnitude
if dist < min_dist then
min_dist = dist
nearest_cf = rig_cf end end
if nearest_cf then
tpTo(nearest_cf)
end
else
if not state.waiting then
WaitText()
tpTo(SAFE_CFRAME)
state.waiting = true
state.wait_start = tick()
startWaitingAnimation()
end
if tick() - state.wait_start >= 5 then
state.waiting = false
end
end
end
end)
_G.GfarmLoop = loopCo
coroutine.resume(loopCo)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GingerbreadFarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Position = UDim2.new(0.5,251, -0, 410, 1)
Frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
Frame.BorderSizePixel = 0
Frame.ZIndex = 4
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.BorderSizePixel = 0
Title.Text = "GingerbreadFarm V.1"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.ZIndex = 4
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title
local Button = Instance.new("TextButton")
Button.Name = "ToggleButton"
Button.Size = UDim2.new(0, 240, 0, 50)
Button.Position = UDim2.new(0.5, -120, 0, 50)
Button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Button.BorderSizePixel = 0
Button.Text = "START"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextScaled = true
Button.Font = Enum.Font.GothamBold
Button.ZIndex = 4
Button.Parent = Frame
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = Button
countLabel = Instance.new("TextLabel")
countLabel.Name = "CountLabel"
countLabel.Size = UDim2.new(1, 0, 0, 25)
countLabel.Position = UDim2.new(0, 0, 1, -30)
countLabel.BackgroundTransparency = 1
countLabel.Text = "..."
countLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
countLabel.TextScaled = true
countLabel.ZIndex = 4
countLabel.Font = Enum.Font.GothamSemibold
countLabel.Parent = Frame
local ButtonInfo1 = Instance.new("TextButton")
ButtonInfo1.Name = "ToggleButton"
ButtonInfo1.Size = UDim2.new(0, 30, 0, 27)
ButtonInfo1.Position = UDim2.new(0.8,35, 0, 0, 1)
ButtonInfo1.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ButtonInfo1.BorderSizePixel = 0
ButtonInfo1.Text = "X"
ButtonInfo1.TextColor3 = Color3.new(1, 1, 1)
ButtonInfo1.TextScaled = true
ButtonInfo1.ZIndex = 4
ButtonInfo1.Font = Enum.Font.GothamBold
ButtonInfo1.Parent = Frame
local ButtonCorner1 = Instance.new("UICorner")
ButtonCorner1.CornerRadius = UDim.new(0, 10)
ButtonCorner1.Parent = ButtonInfo1
local FrameInfo = Instance.new("Frame")
FrameInfo.Name = "MainFrameInfo"
FrameInfo.Size = UDim2.new(0, 520, 0, 520)
FrameInfo.Position = UDim2.new(0.5,141, -0, 99, 1)
FrameInfo.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
FrameInfo.BorderSizePixel = 0
FrameInfo.Parent = ScreenGui
FrameInfo.Active = true
FrameInfo.Draggable = true
local ButtonInfo = Instance.new("TextButton")
ButtonInfo.Name = "ToggleButton"
ButtonInfo.Size = UDim2.new(0, 34, 0, 34)
ButtonInfo.Position = UDim2.new(0.9,18, -0, 0, 0)
ButtonInfo.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ButtonInfo.BorderSizePixel = 0
ButtonInfo.Text = "X"
ButtonInfo.TextColor3 = Color3.new(1, 1, 1)
ButtonInfo.TextScaled = true
ButtonInfo.ZIndex = 3
ButtonInfo.Font = Enum.Font.GothamBold
ButtonInfo.Parent = FrameInfo
local TitleInfo = Instance.new("TextLabel")
TitleInfo.Size = UDim2.new(1, 0, 0, 35)
TitleInfo.Position = UDim2.new(0, 0, 0, 0)
TitleInfo.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleInfo.BorderSizePixel = 0
TitleInfo.ZIndex = 2
TitleInfo.Text = "Features and Changelog V.1   "
TitleInfo.TextColor3 = Color3.new(1, 1, 1)
TitleInfo.TextScaled = true
TitleInfo.Font = Enum.Font.GothamBold
TitleInfo.Parent = FrameInfo
local FeaturesInfo = Instance.new("TextLabel")
FeaturesInfo.Size = UDim2.new(0, 520, 0, 50)
FeaturesInfo.Position = UDim2.new(0,  0,  0,55)
FeaturesInfo.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
FeaturesInfo.BorderSizePixel = 0
FeaturesInfo.TextSize = 20
FeaturesInfo.Text = "  AutoFarm 10k-11k Gingerbreads per hour  "
FeaturesInfo.TextColor3 = Color3.new(1, 1, 1)
FeaturesInfo.TextScaled = true
FeaturesInfo.Font = Enum.Font.GothamBold
FeaturesInfo.Parent = FrameInfo
local FeaturesInfo = Instance.new("TextLabel")
FeaturesInfo.Size = UDim2.new(0, 520, 0, 54)
FeaturesInfo.Position = UDim2.new(0,  0,  0,115)
FeaturesInfo.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
FeaturesInfo.BorderSizePixel = 0
FeaturesInfo.TextSize = 20
FeaturesInfo.Text = " Go to Adoption Island and press Start!!              [Wont work at House Island , in Houses or Shops]"
FeaturesInfo.TextColor3 = Color3.new(1, 1, 1)
FeaturesInfo.TextScaled = true
FeaturesInfo.Font = Enum.Font.GothamBold
FeaturesInfo.Parent = FrameInfo
local FeaturesInfo = Instance.new("TextLabel")
FeaturesInfo.Size = UDim2.new(0, 520, 0, 50)
FeaturesInfo.Position = UDim2.new(0,  0,  0,200)
FeaturesInfo.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
FeaturesInfo.BorderSizePixel = 0
FeaturesInfo.TextSize = 20
FeaturesInfo.Text = " Soon:    - Gingerbread Collected Counter - "
FeaturesInfo.TextColor3 = Color3.new(1, 1, 1)
FeaturesInfo.TextScaled = true
FeaturesInfo.Font = Enum.Font.GothamBold
FeaturesInfo.Parent = FrameInfo
ButtonInfo.MouseButton1Click:Connect(function()
FrameInfo:Destroy()
end)
Button.MouseButton1Click:Connect(function()
TeleportSequence()
local state = _G.GingerbreadFarm			
state.active = not state.active
if state.active then
hrp.Anchored = true
Button.Text = "STOPP"		
Button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
state.waiting = false  -- Reset wait bei Start	
else	
hrp.Anchored = false
Button.Text = "START"	
Button.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
end
end)
ButtonInfo1.MouseButton1Click:Connect(function()
ScreenGui:Destroy()
end)
spawn(function()
wait(1)
local rigs = getRigs()
if countLabel then
countLabel.Text = "Left: " .. #rigs
end
end)
print("GingerbreadFarm Loaded!  Clicke START!")
