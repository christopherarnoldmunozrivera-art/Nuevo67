local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local remoteUnit = rs.Remotes.Unit
local remoteUpgrade = rs.Remotes.Upgrade

-- DETECTOR
local detectedIDs = {}
local currentID = nil

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if self == remoteUnit and method == "FireServer" then
        if args[1] == "buy" then
            local id = args[2]
            detectedIDs[id] = true
            currentID = id
        end
    end

    return old(self, ...)
end)

-- BASE
local function getMyBase()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local closest, dist = nil, math.huge
    for _, base in pairs(workspace.Bases:GetChildren()) do
        if base:FindFirstChild("Tiles") then
            local part = base:FindFirstChildWhichIsA("BasePart")
            if part then
                local d = (part.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = base
                end
            end
        end
    end
    return closest
end

local myBase = getMyBase()

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,260)
frame.Position = UDim2.new(0.7,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(8,10,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- GRADIENTE
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,40,80))
}

-- BORDE ANIMADO
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2

local strokeGrad = Instance.new("UIGradient", stroke)
strokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}

task.spawn(function()
    while true do
        TweenService:Create(strokeGrad, TweenInfo.new(2, Enum.EasingStyle.Linear), {
            Rotation = 360
        }):Play()
        task.wait(2)
        strokeGrad.Rotation = 0
    end
end)

-- PARTICULAS
for i = 1,12 do
    local dot = Instance.new("Frame", frame)
    local size = math.random(2,6)
dot.Size = UDim2.new(0,size,0,size)
    dot.BackgroundColor3 = Color3.fromRGB(0,200,255)
task.spawn(function()
	while dot.Parent do
		dot.BackgroundColor3 = Color3.fromRGB(0,255,255)
		task.wait(0.4)

		dot.BackgroundColor3 = Color3.fromRGB(0,100,255)
		task.wait(0.4)

		dot.BackgroundColor3 = Color3.fromRGB(180,0,255)
		task.wait(0.4)

		dot.BackgroundColor3 = Color3.fromRGB(255,0,180)
		task.wait(0.4)
	end
end)

    dot.BackgroundTransparency = 0.3
    Instance.new("UICorner", dot)
local glow = Instance.new("UIStroke")
glow.Parent = dot
glow.Thickness = 1
glow.Transparency = 0.5


    task.spawn(function()
        while true do
            dot.Position = UDim2.new(math.random(),0,1,0)
            TweenService:Create(dot, TweenInfo.new(math.random(3,5)), {
                Position = UDim2.new(math.random(),0,0,0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(math.random(2,4))
            dot.BackgroundTransparency = 0.3
        end
    end)
end

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-60,0,30)
title.Position = UDim2.new(0,10,0,0)
title.Text = "⚡ MUÑOZ NEXUS"
local orb = Instance.new("Frame", frame)
orb.Size = UDim2.new(0,8,0,8)
orb.Position = UDim2.new(0,5,0,12)
orb.BackgroundColor3 = Color3.fromRGB(0,255,255)
orb.BackgroundTransparency = 0.2

Instance.new("UICorner", orb).CornerRadius = UDim.new(1,0)

title.TextColor3 = Color3.fromRGB(0,220,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left



task.spawn(function()
	while true do
		TweenService:Create(title,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(0,255,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(title,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(0,100,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(title,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(180,0,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(title,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(255,0,180)
		}):Play()
		task.wait(0.8)
	end
end)
task.spawn(function()
	while true do
		TweenService:Create(orb,TweenInfo.new(1),{
			Size = UDim2.new(0,14,0,14),
			BackgroundTransparency = 0.8
		}):Play()

		task.wait(1)

		orb.Size = UDim2.new(0,8,0,8)
		orb.BackgroundTransparency = 0.2
	end
end)


local titleStroke = Instance.new("UIStroke")
titleStroke.Parent = title
titleStroke.Thickness = 1.5
titleStroke.Transparency = 0.3



-- SUBTEXTO
local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1,-60,0,15)
sub.Position = UDim2.new(0,10,0,22)
sub.Text = "Private Build v1.0"
sub.TextColor3 = Color3.fromRGB(120,140,180)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 11
sub.TextXAlignment = Enum.TextXAlignment.Left

-- BOTONES
local function topBtn(txt, x)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0,24,0,24)
    b.Position = UDim2.new(1,x,0,6)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(20,25,40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(0,170,255)
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(20,25,40)
        }):Play()
    end)

    return b
end

local close = topBtn("X",-28)
local hide = topBtn("-", -55)

-- MINIMIZAR
local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0,55,0,55)
circle.Position = UDim2.new(0.1,0,0.5,0)
circle.Text = "⚡"
circle.Visible = false
circle.BackgroundColor3 = Color3.fromRGB(15,20,35)
circle.TextColor3 = Color3.fromRGB(0,200,255)
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

hide.MouseButton1Click:Connect(function()
    frame.Visible = false
    circle.Visible = true
end)

circle.MouseButton1Click:Connect(function()
    frame.Visible = true
    circle.Visible = false
end)

-- TOGGLES
local function createToggle(name, y)
    local holder = Instance.new("Frame", frame)
    holder.Size = UDim2.new(1,-20,0,30)
    holder.Position = UDim2.new(0,10,0,y)
    holder.BackgroundColor3 = Color3.fromRGB(18,22,40)
    Instance.new("UICorner", holder)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.6,0,1,0)
    label.Position = UDim2.new(0,8,0,0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13

    local toggleBtn = Instance.new("TextButton", holder)
    toggleBtn.Size = UDim2.new(0,40,0,18)
    toggleBtn.Position = UDim2.new(1,-45,0.5,-9)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60,70,100)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn)

    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new(0,1,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(0,200,255)
    Instance.new("UICorner", knob)

    local state = false

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state

        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1,-17,0.5,-8) or UDim2.new(0,1,0.5,-8)
        }):Play()

        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,70,100)
        }):Play()
TweenService:Create(label, TweenInfo.new(0.2), {
    TextColor3 = state
        and Color3.fromRGB(0,255,255)
        or Color3.fromRGB(255,255,255)
}):Play()

knob.BackgroundColor3 = state
    and Color3.fromRGB(0,255,255)
    or Color3.fromRGB(180,180,180)
    end)

    return function()
        return state
    end
end

local autoBuild = createToggle("Auto Construir", 45)
local upgradeOn = createToggle("Auto Mejorar", 80)
local sellOn = createToggle("Auto Vender", 115)
local attackOthers = createToggle("Eliminar Otras Bases", 150)
local helpOthers = createToggle("Mejorar Otras Bases", 185)
-- MINI CRONOMETRO RAINBOW NEON
local timerFrame = Instance.new("Frame", frame)
timerFrame.Size = UDim2.new(0,110,0,22)
timerFrame.Position = UDim2.new(0.5,-55,1,-30)
timerFrame.BackgroundColor3 = Color3.fromRGB(18,22,40)
timerFrame.BackgroundTransparency = 0.08
Instance.new("UICorner", timerFrame).CornerRadius = UDim.new(0,9)





local timerText = Instance.new("TextLabel", timerFrame)
timerText.Size = UDim2.new(1,0,1,0)
timerText.BackgroundTransparency = 1
timerText.Font = Enum.Font.GothamBold
timerText.TextSize = 11
timerText.Text = "✨ 00:00:00"
timerText.TextColor3 = Color3.fromRGB(255,255,255)
local timerStroke = Instance.new("UIStroke")
timerStroke.Parent = timerText
timerStroke.Thickness = 1
timerStroke.Transparency = 0.4

local startTime = tick()

task.spawn(function()
	while true do
		local elapsed = math.floor(tick() - startTime)

		local h = math.floor(elapsed / 3600)
		local m = math.floor((elapsed % 3600) / 60)
		local s = elapsed % 60

		timerText.Text = string.format("✨ %02d:%02d:%02d", h, m, s)

		task.wait(1)
	end
end)


task.spawn(function()
	while true do
		TweenService:Create(timerText,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(0,255,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(timerText,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(0,100,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(timerText,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(180,0,255)
		}):Play()
		task.wait(0.8)

		TweenService:Create(timerText,TweenInfo.new(0.8),{
			TextColor3 = Color3.fromRGB(255,0,180)
		}):Play()
		task.wait(0.8)
	end
end)



-- LOOP
task.spawn(function()
    while true do
        task.wait(1)

        if not myBase then continue end

        if currentID and autoBuild() then
            for _, tile in pairs(myBase.Tiles:GetDescendants()) do
                if tile:IsA("Part") and #tile:GetChildren() == 0 then
                    remoteUnit:FireServer("buy", currentID, tile)
                end
            end
        end

        for _, obj in pairs(myBase:GetDescendants()) do
            if obj:IsA("Model") then
                if upgradeOn() then remoteUpgrade:FireServer("upgrade", obj) end
                if sellOn() then remoteUpgrade:FireServer("sell", obj) end
            end
        end

        for _, base in pairs(workspace.Bases:GetChildren()) do
            if base ~= myBase then
                for _, obj in pairs(base:GetDescendants()) do
                    if obj:IsA("Model") then
                        if attackOthers() then remoteUpgrade:FireServer("sell", obj) end
                        if helpOthers() then remoteUpgrade:FireServer("upgrade", obj) end
                    end
                end
            end
        end
    end
end)

