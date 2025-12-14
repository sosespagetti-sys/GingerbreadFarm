
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
 

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")




local sg = Instance.new("ScreenGui")
sg.Name = "PenguinStumblerV4"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")



local MAINFRAME = Instance.new("Frame", sg)
MAINFRAME.Name = "MAINFRAME"
MAINFRAME.Size = UDim2.new(0, 440, 0, 360)
MAINFRAME.Position = UDim2.new(0.5, -170, 0.1, 0)
MAINFRAME.BackgroundColor3 = Color3.fromRGB(10,10,20)
MAINFRAME.Active = true; MAINFRAME.Draggable = true
Instance.new("UICorner", MAINFRAME).CornerRadius = UDim.new(0,12)

local frame = Instance.new("Frame", MAINFRAME)
frame.Size = UDim2.new(0, 240, 0, 100)
frame.Position = UDim2.new(1, -370, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,20)
 
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)



local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9,0,0,50)
btn.Position = UDim2.new(0.05,0,0.3,0)
btn.BackgroundColor3 = Color3.fromRGB(220,50,50)
btn.Text = " AUTO STRUMBLE (BIGGER HIT BOX)"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)




local running = false
local connection
local targetPenguin = nil


local function findPenguin()
    local best = nil
    local bestDist = math.huge
    for _, obj in workspace:GetDescendants() do
        if obj.Name == "Penguin" and obj:IsA("Model") then
            local root = obj:FindFirstChild("HumanoidRootPart", true) or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if root and root:IsA("BasePart") then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = {model = obj, root = root}
                end
            end
        end
    end
    return best
end


btn.MouseButton1Click:Connect(function()
    running = not running
    btn.Text = running and "STOP STRUMBLE" or "START STRUMBLE"
    btn.BackgroundColor3 = running and Color3.fromRGB(0,200,0) or Color3.fromRGB(220,50,50)

    if running then
        targetPenguin = findPenguin()
        if not targetPenguin then
            status.Text = "❌ERROR!"
            status.TextColor3 = Color3.fromRGB(255,100,100)
            running = false
            btn.Text = "START STRUMBLE"
            btn.BackgroundColor3 = Color3.fromRGB(220,50,50)
            return
        end

   
        for _, part in targetPenguin.model:GetChildren() do
            if part:IsA("BasePart")  then
                part.Transparency = 1
                part.CanCollide = false
            elseif   part:IsA("Decal")then

		
              part.Transparency = 1
            end
        end


 
        connection = RunService.Heartbeat:Connect(function()
            if targetPenguin and targetPenguin.root and targetPenguin.root.Parent then
                targetPenguin.root.CFrame = hrp.CFrame * CFrame.new(0, -2, -1.5)  -- Direkt vor deine Füße (anpassen bei Bedarf)
            end
        end)

    else

        if connection then connection:Disconnect() end
        if targetPenguin then

            for _, part in targetPenguin.model:GetDescendants() do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
        status.TextColor3 = Color3.fromRGB(200,200,200)
        targetPenguin = nil
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-----------------------------------------------------------------------------------------------------------

repeat task.wait() until game:IsLoaded()

local PlayerGui = player:WaitForChild("PlayerGui", 10)

if _G.GfarmLoop then task.cancel(_G.GfarmLoop) end

_G.GingerbreadFarm = {active = false, waiting = false, farmingStarted = false}
local SAFE_CFRAME = CFrame.new(-287.3, 26.2, -1626.7)
local collected = 0
local lastRigCount = 0
local countLabel
local lastTextUpdate = 0


local function getRigs()
    local rigs = {}
    local christmas = workspace:FindFirstChild("Interiors") and workspace.Interiors:FindFirstChild("MainMap!Christmas")
    if christmas then
        for _, obj in christmas:GetChildren() do
            if obj.Name == "GingerbreadRig" and obj:IsA("Model") then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if root then
                    local offset = Vector3.new(math.random(-2,2), 3, math.random(-2,2))
                    table.insert(rigs, root.CFrame + offset ) 
                end
            end
        end
    end
    return rigs
end

local function tpTo(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

local function startWaitingAnim()
    spawn(function()
        while _G.GingerbreadFarm.waiting do
            for _, dots in {"", ".", "..", "..."} do
                if not _G.GingerbreadFarm.waiting then break end
                if tick() - lastTextUpdate >= 0.7 then
                    countLabel.Text = "Waiting for new Gingerbreads" .. dots
                    lastTextUpdate = tick()
                end
                task.wait(0.7)
            end
        end
    end)
end
--
--[[local co = coroutine.create(function()


	 task.wait(2)

end)]]



_G.GfarmLoop = task.spawn(function()
    while true do
        task.wait(0.15)
        if not _G.GingerbreadFarm.active or not _G.GingerbreadFarm.farmingStarted then continue end

        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
       hrp.Anchored = true

        local rigs = getRigs()
        local current = #rigs

      
        if current < lastRigCount then
            collected = collected + (lastRigCount - current)
        end
        lastRigCount = current

       
        if tick() - lastTextUpdate >= 0.7 then
            countLabel.Text = "Left: " .. current .. " | Collected: " .. collected
            lastTextUpdate = tick()
        end

        if current > 0 then
            _G.GingerbreadFarm.waiting = false
            local nearest = nil
            local best = math.huge
            for _, cf in rigs do
                local dist = (cf.Position - hrp.Position).Magnitude
                if dist < best then best = dist; nearest = cf end
            end
            if nearest then tpTo(nearest) end
        else
            if not _G.GingerbreadFarm.waiting then
 tpTo(SAFE_CFRAME)
			-- TpAndWait()            
                _G.GingerbreadFarm.waiting = true			
                startWaitingAnim()
            end
        end
    end
end)
--------------------------------------------------------------------------------
local TweenService = game:GetService("TweenService")

local frame = MAINFRAME

local isCollapsed = false
local isAnimating = false
local originalSize = frame.Size

local function setChildrenVisible(state)
    for _, obj in ipairs(frame:GetChildren()) do
        if obj:IsA("GuiObject") then
            obj.Visible = state
        end
    end
end


local closeE = Instance.new("TextButton", sg)
closeE.Size = UDim2.new(0, 50, 0, 50)
closeE.Position = UDim2.new(1, -480, 0, 76)
closeE.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeE.Text = "⬆️"
closeE.ZIndex = 1
closeE.TextSize = 20
closeE.Active = true; closeE.Draggable = true
closeE.TextColor3 = Color3.new(1,1,1)

local function AnimateFrame(isClosing)
    isAnimating = true

    local goal = {}

    if isClosing then
	closeE.Text = "⬇️"
	setChildrenVisible(false)
        originalSize = frame.Size
        goal.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 0)
    else
	closeE.Text = "⬆️"
        goal.Size = originalSize
    end

    local tween = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), goal)
    tween:Play()

    tween.Completed:Wait()


    if isClosing then
        setChildrenVisible(false)
    else
        setChildrenVisible(true)
    end

    isAnimating = false
end



closeE.MouseButton1Click:Connect(function()

    if isAnimating then
        return  
    end

    if not isCollapsed then

        AnimateFrame(true)
    else
    
        AnimateFrame(false)
    end

    isCollapsed = not isCollapsed
end)

local frame = Instance.new("Frame", MAINFRAME)
frame.Size = UDim2.new(0, 350, 0, 180)
frame.Position = UDim2.new(.9, -375, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(10,10,20)
frame.BorderSizePixel = 0
 
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", MAINFRAME)
title.Position = UDim2.new(0.4, -170, 0, 0)
title.Size = UDim2.new(.7,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(10,10,20)
title.Text = "GingerbreadFarm V1"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

local MADEBYME = Instance.new("TextLabel", MAINFRAME)
MADEBYME.Position = UDim2.new(0.5, -170, 0, 60)
MADEBYME.Size = UDim2.new(.7,0,0,35)
MADEBYME.BackgroundColor3 = Color3.fromRGB(10,10,20)
MADEBYME.Text = "Script made by m5t5"
MADEBYME.TextColor3 = Color3.new(1,1,1)
MADEBYME.TextScaled = true
MADEBYME.Font = Enum.Font.GothamBold
Instance.new("UICorner", MADEBYME).CornerRadius = UDim.new(0,12)

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0, 270, 0, 50)
startBtn.Position = UDim2.new(0.5, -135, 0, 45)
startBtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,10)

countLabel = Instance.new("TextLabel", frame)
countLabel.Size = UDim2.new(1,0,0,35)
countLabel.Position = UDim2.new(0,0,1,-60)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Press START to begin"
countLabel.TextColor3 = Color3.fromRGB(100,255,100)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.GothamSemibold

local close = Instance.new("TextButton", MAINFRAME)
close.Size = UDim2.new(0,50,0,50)
close.Position = UDim2.new(1,-55,0,5)
close.BackgroundColor3 = Color3.fromRGB(220,50,50)
close.Text = "X"
close.ZIndex = 5
close.TextSize = 	20
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,10)

local infoBtn = Instance.new("TextButton", MAINFRAME)
infoBtn.Size = UDim2.new(0,50,0,50)
infoBtn.Position = UDim2.new(1,-115,0,5)
infoBtn.BackgroundColor3 = Color3.fromRGB(50,50,220)
infoBtn.Text = "?"
infoBtn.TextSize = 	20
infoBtn.ZIndex = 5
infoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infoBtn).CornerRadius = UDim.new(0,10)

local info = Instance.new("Frame", sg)
info.Size = UDim2.new(0, 480, 0, 390)
info.Position = UDim2.new(0.5,-260,0.5,-230)
info.BackgroundColor3 = Color3.fromRGB(10,10,10)
info.Visible = false
info.Active = true
info.ZIndex = 7
info.Draggable = true
Instance.new("UICorner", info).CornerRadius = UDim.new(0,12)

local infotitle = Instance.new("TextLabel", info)
infotitle.Size = UDim2.new(1,0,0,40)
infotitle.BackgroundColor3 = Color3.fromRGB(30,30,40)
infotitle.Text = "Changelog / Features"
infotitle.TextColor3 = Color3.new(1,1,1)
infotitle.TextScaled = true
infotitle.ZIndex = 8
infotitle.Font = Enum.Font.GothamBold
Instance.new("UICorner", infotitle).CornerRadius = UDim.new(0,12)

local changelog = Instance.new("TextLabel", info)
changelog.Size = UDim2.new(1,-20,1,-50)
changelog.Position = UDim2.new(0,10,0,45)
changelog.ZIndex = 8
changelog.BackgroundTransparency = 1
changelog.Text = [[
	-------------------------------------
    [  -Autofarm Gingerbreads-]
    -------------------------------------
   • 10k - 11k per hour
   • Activate auto Strumbler for 
    bigger hit box!!
   
Dont press start at any other place  then the adoption island!!!
     ------------------------------------]]
changelog.TextColor3 = Color3.new(1,1,1)
changelog.TextScaled = true
changelog.TextXAlignment = Enum.TextXAlignment.Left
changelog.TextYAlignment = Enum.TextYAlignment.Top
changelog.Font = Enum.Font.Gotham

local running = false
startBtn.MouseButton1Click:Connect(function()
    running = not running
    _G.GingerbreadFarm.active = running
    startBtn.Text = running and "STOP" or "START"
    startBtn.BackgroundColor3 = running and Color3.fromRGB(50,220,50) or Color3.fromRGB(220,50,50)

    if running then
        tpTo(SAFE_CFRAME)
        task.wait(1)
        for i = 4, 1, -1 do
            countLabel.Text = "Farm starts in " .. i .. "s..."
            task.wait(0.5)
        end
        collected = 0 
        lastRigCount = #getRigs()
		 _G.GingerbreadFarm.waiting = false
        _G.GingerbreadFarm.farmingStarted = true

  
        lastTextUpdate = tick()
    else
        _G.GingerbreadFarm.farmingStarted = false
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
        
    end
end)

close.MouseButton1Click:Connect(function() sg:Destroy() end)
infoBtn.MouseButton1Click:Connect(function() info.Visible = not info.Visible end)
infoclose.MouseButton1Click:Connect(function() info.Visible = false end)

print("Gingerbread Farm lOADED !")


