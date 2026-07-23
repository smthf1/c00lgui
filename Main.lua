local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local IYInvisRunning = false
local IYIsInvis = false
local IYInvisibleCharacter = nil
local IYInvisFixConnection = nil
local IYInvisDiedConnection = nil
local IYOriginalCharacter = nil

math.randomseed(os.time())
local character_set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

local string_sub = string.sub
local math_random = math.random
local table_concat = table.concat
local character_set_amount = #character_set
local number_one = 1
local default_length = 10

local function generate_string(length)
	local random_string = {}

	for int = number_one, length or default_length do
		local random_number = math_random(number_one, character_set_amount)
		local character = string_sub(character_set, random_number, random_number)

		random_string[#random_string + number_one] = character
	end

	return table_concat(random_string)
end

local gui = Instance.new("ScreenGui")
gui.Name = generate_string(math_random(1, 10))
gui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = CoreGui
elseif gethui then
    gui.Parent = gethui()
else
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local headerH, winW, winH = 30, 340, 240
local btnW, btnH = 72, 23
local scrollH = winH - headerH

local header = Instance.new("Frame")
header.Size = UDim2.new(0, winW, 0, headerH)
header.Position = UDim2.new(0.5, -winW/2, 0.5, -(winH + headerH)/2)
header.BackgroundColor3 = Color3.fromRGB(141, 0, 2)
header.BorderSizePixel = 0
header.Active = true
header.Parent = gui

local logo = Instance.new("ImageLabel")
logo.Name = generate_string(math_random(5, 10))
logo.BackgroundTransparency = 1
logo.Size = UDim2.new(1, 0, 0, 100)
logo.Position = UDim2.new(0, -5, 0, -100)
logo.Image = "rbxassetid://87486058304609"
logo.ScaleType = Enum.ScaleType.Fit
logo.ZIndex = 0 
logo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Team c00lkidd GUI v2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSans
title.TextSize = 20
title.TextWrapped = true
title.TextScaled = true
title.Parent = header

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0, winW, 0, scrollH)
scroll.Position = UDim2.new(0, 0, 1, 0)
scroll.AnchorPoint = Vector2.new(0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(102, 0, 2)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
scroll.Parent = header

local grid = Instance.new("UIGridLayout")
grid.Parent = scroll
grid.CellSize = UDim2.new(0, btnW, 0, btnH)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.CellPadding = UDim2.new(0, 5, 0, 3)

local pad = Instance.new("UIPadding")
pad.Parent = scroll
pad.PaddingTop = UDim.new(0, 5)
pad.PaddingLeft = UDim.new(0, 5)
pad.PaddingRight = UDim.new(0, 5)
pad.PaddingBottom = UDim.new(0, 5)

local tooltip = Instance.new("Frame")
tooltip.Size = UDim2.new(0, 150, 0, 30)
tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tooltip.BackgroundTransparency = 0.10
tooltip.BorderSizePixel = 0
tooltip.Visible = false
tooltip.ZIndex = 1000
tooltip.Parent = gui

local tooltipText = Instance.new("TextLabel")
tooltipText.Size = UDim2.new(1, -4, 1, -4)
tooltipText.Position = UDim2.new(0, 2, 0, 2)
tooltipText.BackgroundTransparency = 1
tooltipText.Text = ""
tooltipText.TextColor3 = Color3.new(255, 255, 255)
tooltipText.TextSize = 12
tooltipText.Font = Enum.Font.SourceSans
tooltipText.TextWrapped = true
tooltipText.TextScaled = true
tooltipText.Parent = tooltip

local currentTooltipBtn = nil
local tooltipConnection = nil

local function showTooltip(btn, text)
    if tooltipConnection then tooltipConnection:Disconnect() end
    currentTooltipBtn = btn
    tooltipText.Text = text
    tooltip.Visible = true
    tooltipConnection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            tooltip.Position = UDim2.new(0, mousePos.X + 15, 0, mousePos.Y + 15)
        end
    end)
end

local function hideTooltip()
    if tooltipConnection then tooltipConnection:Disconnect() end
    tooltip.Visible = false
    currentTooltipBtn = nil
end

local function createSliderWindow(name, minVal, maxVal, currentVal, callback)
    if gui:FindFirstChild(name.."Slider") then gui[name.."Slider"]:Destroy() end

    local frame = Instance.new("Frame")
    frame.Name = generate_string(8)
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0.5, -25)
    frame.BackgroundColor3 = Color3.fromRGB(141, 0, 2)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true 
    frame.Parent = gui

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. currentVal
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14

    local sliderBar = Instance.new("Frame", frame)
    sliderBar.Size = UDim2.new(0, 180, 0, 5)
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    sliderBar.BorderSizePixel = 0

    local sliderBtn = Instance.new("TextButton", sliderBar)
    sliderBtn.Size = UDim2.new(0, 10, 0, 15)
    sliderBtn.Position = UDim2.new((currentVal - minVal)/(maxVal - minVal), -5, 0.5, -7.5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0

    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local barAbsPos = sliderBar.AbsolutePosition.X
            local barAbsSize = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
            
            sliderBtn.Position = UDim2.new(percent, -5, 0.5, -7.5)
            local val = math.floor(minVal + (maxVal - minVal) * percent)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
    
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -20, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

function createBtn(text, callback, isToggle, tooltipTextStr)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.BackgroundColor3 = Color3.fromRGB(135, 0, 4)
    btn.BorderSizePixel = 0
    btn.TextWrapped = true
    btn.TextScaled = true
    btn.Parent = scroll
    
    if tooltipTextStr then
        btn.MouseEnter:Connect(function() showTooltip(btn, tooltipTextStr) end)
        btn.MouseLeave:Connect(function() hideTooltip() end)
    end
    
    if callback then
        btn.MouseButton1Click:Connect(function()
            callback()
        end)
    end
    return btn
end

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    header.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = header.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

local currentPage = 1
local pages = {
    {name = "Utilities", buttons = {}},
    {name = "Trolling", buttons = {}},
    {name = "Visuals", buttons = {}},
    {name = "Extras", buttons = {}},
    {name = "ALL", buttons = {}}
}

local function loadPage(pageNum)
    currentPage = pageNum
    scroll:ClearAllChildren()
    
    local newGrid = Instance.new("UIGridLayout")
    newGrid.Parent = scroll
    newGrid.CellSize = UDim2.new(0, btnW, 0, btnH)
    newGrid.FillDirection = Enum.FillDirection.Horizontal
    newGrid.CellPadding = UDim2.new(0, 5, 0, 3)
    
    local newPad = Instance.new("UIPadding")
    newPad.Parent = scroll
    newPad.PaddingTop = UDim.new(0, 5)
    newPad.PaddingLeft = UDim.new(0, 5)
    newPad.PaddingRight = UDim.new(0, 5)
    newPad.PaddingBottom = UDim.new(0, 5)
    
    for _, btnData in ipairs(pages[pageNum].buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnW, 0, btnH)
        btn.Text = btnData.text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.Font = Enum.Font.SourceSans
        btn.BackgroundColor3 = Color3.fromRGB(135, 0, 4)
        btn.BorderSizePixel = 0
        btn.TextWrapped = true
        btn.TextScaled = true
        btn.Parent = scroll
        
        if btnData.tooltip then
            btn.MouseEnter:Connect(function() showTooltip(btn, btnData.tooltip) end)
            btn.MouseLeave:Connect(function() hideTooltip() end)
        end
        
        if btnData.callback then
            btn.MouseButton1Click:Connect(function()
                btnData.callback()
            end)
        end
    end
end

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0, 25, 0, 25)
prevBtn.Position = UDim2.new(0, 5, 1, -25)
prevBtn.Text = "<"
prevBtn.TextColor3 = Color3.new(1, 1, 1)
prevBtn.Font = Enum.Font.SourceSansBold
prevBtn.TextSize = 16
prevBtn.BackgroundColor3 = Color3.fromRGB(135, 0, 4)
prevBtn.BorderSizePixel = 0
prevBtn.BackgroundTransparency = 1
prevBtn.TextWrapped = true
prevBtn.TextScaled = true
prevBtn.Parent = header
prevBtn.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        loadPage(currentPage - 1)
    else
        loadPage(#pages)
    end
end)

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 25, 0, 25)
nextBtn.Position = UDim2.new(1, -25, 1, -25)
nextBtn.Text = ">"
nextBtn.TextColor3 = Color3.new(1, 1, 1)
nextBtn.Font = Enum.Font.SourceSansBold
nextBtn.TextSize = 16
nextBtn.BackgroundColor3 = Color3.fromRGB(135, 0, 4)
nextBtn.BorderSizePixel = 0
nextBtn.BackgroundTransparency = 1
nextBtn.TextWrapped = true
nextBtn.TextScaled = true
nextBtn.Parent = header
nextBtn.MouseButton1Click:Connect(function()
    if currentPage < #pages then
        loadPage(currentPage + 1)
    else
        loadPage(1)
    end
end)

local closeGuiBtn = Instance.new("TextButton")
closeGuiBtn.Size = UDim2.new(0, winW, 0, headerH)
closeGuiBtn.Position = UDim2.new(0, 0, 1, scrollH)
closeGuiBtn.BackgroundColor3 = Color3.fromRGB(141, 0, 2)
closeGuiBtn.BorderSizePixel = 0
closeGuiBtn.Text = "Close"
closeGuiBtn.TextColor3 = Color3.new(1, 1, 1)
closeGuiBtn.Font = Enum.Font.SourceSans
closeGuiBtn.TextSize = 20
closeGuiBtn.Parent = header

closeGuiBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local function addBtnToPages(pageList, data)
    local addedToAll = false
    for _, pageName in ipairs(pageList) do
        local page = nil
        for _, p in ipairs(pages) do
            if p.name == pageName then page = p break end
        end
        if page then
            table.insert(page.buttons, data)
            if page.name ~= "ALL" and not addedToAll then
                table.insert(pages[5].buttons, data)
                addedToAll = true
            end
        end
    end
end

addBtnToPages({"Utilities"}, {text = "Server Hop", callback = function()
    local placeId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                break
            end
        end
    end
end, tooltip = "Hops to a different server"})

addBtnToPages({"Utilities"}, {text = "Infinite Jump", callback = function()
    if not _G.InfiniteJumpSetup then
        _G.InfiniteJumpSetup = true
        _G.InfiniteJump = false
        UserInputService.JumpRequest:Connect(function()
            if _G.InfiniteJump then
                local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
    _G.InfiniteJump = not _G.InfiniteJump
    return _G.InfiniteJump
end, isToggle = true, tooltip = "Basically flying but jumping"})

addBtnToPages({"Utilities"}, {text = "Checkpoint", callback = function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    _G.SavedPlayerPosition = root.CFrame
    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        local newRoot = newCharacter:WaitForChild("HumanoidRootPart")
        task.wait(0.2)
        if _G.SavedPlayerPosition then newRoot.CFrame = _G.SavedPlayerPosition end
    end)
end, tooltip = "Saves your character position on respawn."})

addBtnToPages({"Utilities"}, {text = "Part Orbit", callback = function()
    if _G.OrbitConnection then
        _G.OrbitConnection:Disconnect()
        _G.OrbitConnection = nil
        if _G.CleanOrbitConnections then _G.CleanOrbitConnections() end
        return false
    end
    
    if not getgenv().Network then
        getgenv().Network = {
            BaseParts = {},
            Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
        }
        Network.RetainPart = function(Part)
            if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
                table.insert(Network.BaseParts, Part)
                pcall(function()
                    Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                    Part.CanCollide = false
                end)
            end
        end
        local function EnablePartControl()
            LocalPlayer.ReplicationFocus = Workspace
            RunService.Heartbeat:Connect(function()
                pcall(function()
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                end)
                for _, Part in pairs(Network.BaseParts) do
                    if Part:IsDescendantOf(Workspace) then
                        Part.AssemblyLinearVelocity = Network.Velocity
                    end
                end
            end)
        end
        EnablePartControl()
    end

    _G.OrbitRadius = 50
    _G.OrbitHeight = 100
    _G.OrbitSpeed = 1
    _G.OrbitAttraction = 1000

    local function RetainPart(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
                return false
            end
            pcall(function()
                Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                Part.CanCollide = false
            end)
            return true
        end
        return false
    end

    local parts = {}
    local function addPart(part)
        if RetainPart(part) then
            if not table.find(parts, part) then
                table.insert(parts, part)
            end
        end
    end

    local function removePart(part)
        local index = table.find(parts, part)
        if index then
            table.remove(parts, index)
        end
    end

    for _, part in pairs(Workspace:GetDescendants()) do
        addPart(part)
    end

    local dAdd = Workspace.DescendantAdded:Connect(addPart)
    local dRem = Workspace.DescendantRemoving:Connect(removePart)

    _G.OrbitConnection = RunService.Heartbeat:Connect(function()
        local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local tornadoCenter = humanoidRootPart.Position
            for _, part in pairs(parts) do
                if part.Parent then
                    local pos = part.Position
                    local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                    local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                    local newAngle = angle + math.rad(_G.OrbitSpeed)
                    local targetPos = Vector3.new(
                        tornadoCenter.X + math.cos(newAngle) * math.min(_G.OrbitRadius, distance),
                        tornadoCenter.Y + (_G.OrbitHeight * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / _G.OrbitHeight)))),
                        tornadoCenter.Z + math.sin(newAngle) * math.min(_G.OrbitRadius, distance)
                    )
                    local directionToTarget = (targetPos - part.Position).Unit
                    part.AssemblyLinearVelocity = directionToTarget * _G.OrbitAttraction
                end
            end
        end
    end)

    _G.CleanOrbitConnections = function()
        pcall(function()
            dAdd:Disconnect()
            dRem:Disconnect()
        end)
    end
    
    return true 
end, isToggle = true, tooltip = "Super ring"})

addBtnToPages({"Utilities"}, {text = "Simplespy", callback = function()
    loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
end, tooltip = "Smart ass 💔"})

addBtnToPages({"Utilities"}, {text = "Save Pos", callback = function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    _G.SavedPlayerPosition = root.CFrame
end, tooltip = "Checkpoint"})

addBtnToPages({"Utilities"}, {text = "Load Pos", callback = function()
    if _G.SavedPlayerPosition then
        local character = LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = _G.SavedPlayerPosition
            end
        end
    end
end, tooltip = "I ALWAYS COME BACK"})

addBtnToPages({"Utilities"}, {text = "Noclip", callback = function()
    _G.NoclipEnabled = not (_G.NoclipEnabled or false)
    
    if _G.NoclipEnabled then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
    end
    
    return _G.NoclipEnabled
end, isToggle = true, tooltip = "just got wall hacks"})

addBtnToPages({"Utilities", "Trolling"}, {text = "Fly", callback = function()
    _G.FlyEnabled = not (_G.FlyEnabled == true)
    
    local mouse = LocalPlayer:GetMouse()
    local camera = workspace.CurrentCamera
    
    if _G.FlyEnabled then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")
        
        local maxSpeed = 50 
        local speed = 0
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        bg.Parent = rootPart
        
        local bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = rootPart
        
        _G.FlyKeyDown = mouse.KeyDown:Connect(function(key)
            if key:lower() == "w" then ctrl.f = 1
            elseif key:lower() == "s" then ctrl.b = -1
            elseif key:lower() == "a" then ctrl.l = -1
            elseif key:lower() == "d" then ctrl.r = 1
            end
        end)
        
        _G.FlyKeyUp = mouse.KeyUp:Connect(function(key)
            if key:lower() == "w" then ctrl.f = 0
            elseif key:lower() == "s" then ctrl.b = 0
            elseif key:lower() == "a" then ctrl.l = 0
            elseif key:lower() == "d" then ctrl.r = 0
            end
        end)
        
        _G.FlyLoop = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            humanoid.PlatformStand = true
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed + 2
                if speed > maxSpeed then speed = maxSpeed end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed - 2
                if speed < 0 then speed = 0 end
            end
            
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((camera.CFrame.lookVector * (ctrl.f + ctrl.b)) + ((camera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).Position) - camera.CFrame.Position)) * speed
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
            bg.cframe = camera.CFrame
        end)
    else
        if _G.FlyKeyDown then _G.FlyKeyDown:Disconnect() end
        if _G.FlyKeyUp then _G.FlyKeyUp:Disconnect() end
        if _G.FlyLoop then _G.FlyLoop:Disconnect() end
        
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            if rootPart then
                for _, mover in ipairs(rootPart:GetChildren()) do
                    if mover:IsA("BodyGyro") or mover:IsA("BodyVelocity") or mover:IsA("LinearVelocity") or mover:IsA("AlignPosition") then
                        mover:Destroy()
                    end
                end
            end
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
    
    return _G.FlyEnabled
end, isToggle = true, tooltip = "Take to the skies"})

addBtnToPages({"Utilities"}, {text = "Sit", callback = function()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = true
        end
    end
end, tooltip = "Take a seat"})

addBtnToPages({"Utilities", "Trolling"}, {text = "Jump up", callback = function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 350
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end, tooltip = "its a bird its a plane its a skid?"})

addBtnToPages({"Utilities", "Trolling"}, {text = "TP to Mouse", callback = function()
    local mouse = LocalPlayer:GetMouse()
    if mouse.Target then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end, tooltip = "BROKEN"})

addBtnToPages({"Trolling"}, {text = "Dark Dex", callback = function()
    loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
end, tooltip = "Take a peek under the hood"})

addBtnToPages({"Trolling"}, {text = "Backflip", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibxi/BackflipGoAndFlip/refs/heads/main/N0tAC00lgui"))()
end, tooltip = "Look what i can do"})

addBtnToPages({"Trolling"}, {text = "Fly Gui", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end, tooltip = "Credits to the orginal creator"})

addBtnToPages({"Trolling"}, {text = "Part Orbit GUI", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/chesslovers69/Super-ring-parts-v6/refs/heads/main/Bylukaslol"))()
end, tooltip = "Better orbit"})

addBtnToPages({"Trolling"}, {text = "Backdoor", callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script'))()
end, tooltip = "Best and fast scanner"})

addBtnToPages({"Trolling"}, {text = "Admin", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end, tooltip = "I just got admin gng"})

addBtnToPages({"Trolling"}, {text = "Decal Spam", callback = function()
    local decalID = "rbxassetid://8408806737"
    local skyID = "rbxassetid://10560525674"
    local count = 0
    
    local lighting = game:GetService("Lighting")
    local sky = lighting:FindFirstChildOfClass("Sky")
    
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = lighting
    end
    
    sky.SkyboxBk = skyID
    sky.SkyboxDn = skyID
    sky.SkyboxFt = skyID
    sky.SkyboxLf = skyID
    sky.SkyboxRt = skyID
    sky.SkyboxUp = skyID
    
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                if not part:FindFirstChild("c00lDecal") then
                    for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                        local decal = Instance.new("Decal")
                        decal.Name = "c00lDecal"
                        decal.Texture = decalID
                        decal.Face = face
                        decal.Parent = part
                    end
                end
            end)
            
            count = count + 1
            if count % 100 == 0 then
                task.wait()
            end
        end
    end
end, tooltip = "NOT FE"})

addBtnToPages({"Visuals"}, {text = "Dance", callback = function()
    if not _G.AnimationTrack then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://27789359"
        _G.AnimationTrack = animator:LoadAnimation(animation)
        _G.AnimationPlaying = false
    end
    _G.AnimationPlaying = not _G.AnimationPlaying
    if _G.AnimationPlaying then
        _G.AnimationTrack:Play()
    else
        _G.AnimationTrack:Stop()
    end
    return _G.AnimationPlaying
end, isToggle = true, tooltip = "Dancing here!"})

addBtnToPages({"Visuals"}, {text = "Scare Closest", callback = function()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local closestPlayer
    local closestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (root.Position - otherRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local originalPosition = root.CFrame
            local scarePos = (targetRoot.CFrame * CFrame.new(0, 0, -3)).Position
            root.CFrame = CFrame.lookAt(scarePos, targetRoot.Position)
            task.wait(0.15)
            root.CFrame = originalPosition
        end
    end
end, tooltip = "Fnaf refence"})

addBtnToPages({"Trolling"}, {text = "WAAPP Hub", callback = function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Work%20at%20a%20pizza%20place'),true))()
end, tooltip = "Work at a pizza place 2014"})

addBtnToPages({"Visuals"}, {text = "ESP", callback = function()
    _G.ESPEnabled = not (_G.ESPEnabled or false)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                if _G.ESPEnabled then
                    if not head:FindFirstChild("NameESP") then
                        local espGui = Instance.new("BillboardGui")
                        espGui.Name = "NameESP"
                        espGui.Size = UDim2.new(0, 200, 0, 50)
                        espGui.StudsOffset = Vector3.new(0, 3, 0)
                        espGui.AlwaysOnTop = true
                        espGui.Parent = head
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = plr.Name
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = true
                        text.TextWrapped = true
                        text.Parent = espGui
                    end
                else
                    local esp = head:FindFirstChild("NameESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
    return _G.ESPEnabled
end, isToggle = true, tooltip = "Cooked i just got wall hacks"})

addBtnToPages({"Visuals"}, {text = "VC Unban", callback = function()
    pcall(function()
        game:GetService("VoiceChatService"):JoinVoice()
    end)
end, tooltip = "unban"})

addBtnToPages({"Visuals"}, {text = "IY Invis", callback = function()
    local Player = LocalPlayer
    
    if IYIsInvis then
        if IYInvisFixConnection then IYInvisFixConnection:Disconnect() end
        if IYInvisDiedConnection then IYInvisDiedConnection:Disconnect() end
        
        local currentCam = workspace.CurrentCamera
        local currentCF = currentCam.CFrame
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local cloneCF = Player.Character.HumanoidRootPart.CFrame
            if IYOriginalCharacter and IYOriginalCharacter:FindFirstChild("HumanoidRootPart") then
                IYOriginalCharacter.HumanoidRootPart.CFrame = cloneCF
            end
        end
        
        if IYInvisibleCharacter then IYInvisibleCharacter:Destroy() end
        
        if IYOriginalCharacter then
            IYOriginalCharacter.Parent = workspace
            Player.Character = IYOriginalCharacter
        end
        
        IYIsInvis = false
        
        if Player.Character and Player.Character:FindFirstChild("Animate") then
            Player.Character.Animate.Disabled = true
            Player.Character.Animate.Disabled = false
        end
        
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            IYInvisDiedConnection = Player.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
                IYIsInvis = false
                IYInvisRunning = false
                if IYInvisDiedConnection then IYInvisDiedConnection:Disconnect() end
            end)
        end
        
        IYInvisRunning = false
        return false
    end

    if IYInvisRunning then return end
    IYInvisRunning = true
    
    IYOriginalCharacter = Player.Character
    if not IYOriginalCharacter or not IYOriginalCharacter:FindFirstChild("HumanoidRootPart") then 
        IYInvisRunning = false 
        return false 
    end
    
    IYOriginalCharacter.Archivable = true
    IYInvisibleCharacter = IYOriginalCharacter:Clone()
    IYInvisibleCharacter.Parent = game:GetService("Lighting")
    
    local VoidHeight = workspace.FallenPartsDestroyHeight
    IYInvisibleCharacter.Name = generate_string(6)
    
    local function SafeRespawn()
        IYIsInvis = false
        IYInvisRunning = false
        if IYInvisFixConnection then IYInvisFixConnection:Disconnect() end
        if IYInvisDiedConnection then IYInvisDiedConnection:Disconnect() end
        
        pcall(function()
            Player.Character = IYOriginalCharacter
            task.wait()
            IYOriginalCharacter.Parent = workspace
            local hum = IYOriginalCharacter:FindFirstChildOfClass("Humanoid")
            if hum then hum:Destroy() end
            if IYInvisibleCharacter then IYInvisibleCharacter.Parent = nil end
        end)
    end

    IYInvisFixConnection = RunService.Stepped:Connect(function()
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.RootPart then
                local currentY = Player.Character.Humanoid.RootPart.Position.Y
                local isNegativeVoid = tostring(VoidHeight):find("-") and true or false
                
                if isNegativeVoid then
                    if currentY <= VoidHeight then SafeRespawn() end
                else
                    if currentY >= VoidHeight then SafeRespawn() end
                end
            end
        end)
    end)

    for _, v in ipairs(IYInvisibleCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "HumanoidRootPart" then
                v.Transparency = 1
            else
                v.Transparency = 0.5
            end
        end
    end

    if IYInvisibleCharacter:FindFirstChildOfClass("Humanoid") then
        IYInvisDiedConnection = IYInvisibleCharacter:FindFirstChildOfClass("Humanoid").Died:Connect(function()
            SafeRespawn()
        end)
    end

    IYIsInvis = true
    local originalCF = IYOriginalCharacter.HumanoidRootPart.CFrame
    
    IYOriginalCharacter:MoveTo(Vector3.new(0, math.pi * 1000000, 0))
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    task.wait(0.2)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    
    IYOriginalCharacter.Parent = game:GetService("Lighting")
    IYInvisibleCharacter.Parent = workspace
    
    if IYInvisibleCharacter:FindFirstChild("HumanoidRootPart") then
        IYInvisibleCharacter.HumanoidRootPart.CFrame = originalCF
    end
    
    Player.Character = IYInvisibleCharacter
    
    pcall(function()
        workspace.CurrentCamera.CameraSubject = IYInvisibleCharacter:FindFirstChildOfClass("Humanoid")
    end)
    
    if Player.Character:FindFirstChild("Animate") then
        Player.Character.Animate.Disabled = true
        Player.Character.Animate.Disabled = false
    end
    
    return true
end, isToggle = true, tooltip = "Credits to IY"})

addBtnToPages({"Extras"}, {text = "Chat GUI", callback = function()
    loadstring(game:HttpGet("https://github.com/codzal/rbxscripts/raw/refs/heads/main/chatgui.lua", true))()
end, tooltip = "Credits to the orginal creator"})

addBtnToPages({"Extras"}, {text = "Noclip GUI", callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/RV2jb0hn"))()
end, tooltip = "Didn't even need this but whatever"})

addBtnToPages({"Extras"}, {text = "Invis GUI", callback = function()
    loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
end, tooltip = "Credits to the orginal creator"})

addBtnToPages({"Extras"}, {text = "c00lclan v1", callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/cfsmi2/c00lguiv1/refs/heads/main/Main.lua'))()
end, tooltip = "More scripts"})

addBtnToPages({"Extras"}, {text = "Fling GUI", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/FlingPlayers/main/FlingGUI"))()
end, tooltip = "Needs collision to work"})

addBtnToPages({"Extras"}, {text = "Server admin", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ONEReverseCard/My-Scripts/main/Netless%20Server%20Admin.md"))()
end, tooltip = "Hats needed"})

addBtnToPages({"Extras"}, {text = "Walkspeed slider", callback = function()
    createSliderWindow("WalkSpeed", 16, 250, 16, function(val)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
        end
    end)
end, tooltip = "Gotta go fast!"})

addBtnToPages({"Extras"}, {text = "Jumppower slider", callback = function()
    createSliderWindow("JumpPower", 50, 400, 50, function(val)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").UseJumpPower = true
            char:FindFirstChildOfClass("Humanoid").JumpPower = val
        end
    end)
end, tooltip = "It's a me mario!"})

loadPage(5)
