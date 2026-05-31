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

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 335, 0, 295)
frame.Position = UDim2.new(0.7,0,0.22,0)
frame.BackgroundColor3 = Color3.fromRGB(9,11,26)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Borde Rainbow
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3.5

local strokeGrad = Instance.new("UIGradient", stroke)
strokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,200))
}

task.spawn(function()
    local rot = 0
    while true do
        rot = rot + 2
        strokeGrad.Rotation = rot
        task.wait(0.03)
    end
end)

-- Gradient
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15,18,38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(7,9,24))
}

-- Partículas
for i = 1, 14 do
    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.new(0,5,0,5)
    dot.BackgroundTransparency = 0.45
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    task.spawn(function()
        while true do
            dot.BackgroundColor3 = Color3.fromHSV(math.random()/2, 1, 1)
            dot.Position = UDim2.new(math.random(-10,110)/100, 0, 1.1, 0)
            TweenService:Create(dot, TweenInfo.new(math.random(4,7), Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.random(-10,110)/100, 0, -0.2, 0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(math.random(1.5,4))
        end
    end)
end

-- TÍTULO (más legible)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-90,0,42)
title.Position = UDim2.new(0,18,0,10)
title.Text = "⚡ MUÑOZ NEXUS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Arcade
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 1.2   -- Reducido para que se lea bien
titleStroke.Color = Color3.fromRGB(0, 255, 220)

-- Subtítulo
local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1,-90,0,18)
sub.Position = UDim2.new(0,20,0,38)
sub.Text = "Private Build v1.4"
sub.TextColor3 = Color3.fromRGB(180, 210, 255)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 12.5
sub.TextXAlignment = Enum.TextXAlignment.Left

-- Botones superiores
local function topBtn(txt, x)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0,32,0,32)
    b.Position = UDim2.new(1,x,0,9)
    b.Text = txt
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(210,220,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    
    local s = Instance.new("UIStroke", b)
    s.Thickness = 1.2

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0,255,220)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(210,220,255)}):Play()
    end)
    return b
end

local close = topBtn("✕", -45)
local hide = topBtn("−", -82)

-- Minimizar
local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0,55,0,55)
circle.Position = UDim2.new(0.1,0,0.5,0)
circle.Text = "⚡"
circle.Visible = false
circle.BackgroundColor3 = Color3.fromRGB(15,20,35)
circle.TextColor3 = Color3.fromRGB(0,200,255)
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
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
    holder.Size = UDim2.new(1,-28,0,42)
    holder.Position = UDim2.new(0,14,0,y)
    holder.BackgroundColor3 = Color3.fromRGB(20,24,45)
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,11)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.68,0,1,0)
    label.Position = UDim2.new(0,16,0,0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(245, 250, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", holder)
    toggleBtn.Size = UDim2.new(0,52,0,26)
    toggleBtn.Position = UDim2.new(1,-68,0.5,-13)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45,50,75)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.new(0,22,0,22)
    knob.Position = UDim2.new(0,2,0.5,-11)
    knob.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = false

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = state and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11)
        }):Play()
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = state and Color3.fromRGB(0, 230, 180) or Color3.fromRGB(45,50,75)
        }):Play()
    end)

    return function() return state end
end

local autoBuild = createToggle("Auto Construir", 65)
local upgradeOn = createToggle("Auto Mejorar", 112)
local sellOn = createToggle("Auto Vender", 159)
local attackOthers = createToggle("Eliminar Otras Bases", 206)
local helpOthers = createToggle("Mejorar Otras Bases", 253)

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
