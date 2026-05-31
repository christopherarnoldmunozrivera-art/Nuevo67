local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local remoteUnit = rs.Remotes.Unit
local remoteUpgrade = rs.Remotes.Upgrade

-- DETECTOR
local currentID = nil

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if self == remoteUnit and method == "FireServer" then
        if args[1] == "buy" then
            currentID = args[2]
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

-- ==================== GUI PREMIUM ====================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 290)
frame.Position = UDim2.new(0.7, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Borde Rainbow Animado
local rainbowStroke = Instance.new("UIStroke", frame)
rainbowStroke.Thickness = 3.5
rainbowStroke.Color = Color3.fromRGB(0, 255, 255)

task.spawn(function()
    local hue = 0
    while task.wait(0.025) do
        hue = (hue + 2) % 360
        rainbowStroke.Color = Color3.fromHSV(hue/360, 1, 1)
    end
end)

-- Gradient
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 8, 25))
}
gradient.Rotation = 90

-- PARTÍCULAS MEJORADAS (Rainbow + más fluidas)
for i = 1, 16 do
    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.new(0, math.random(4,7), 0, math.random(4,7))
    dot.BackgroundTransparency = 0.4
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    
    task.spawn(function()
        while true do
            dot.Position = UDim2.new(math.random(-10,110)/100, 0, 1.1, 0)
            local randomColor = Color3.fromHSV(math.random(0,360)/360, 1, 1)
            dot.BackgroundColor3 = randomColor
            
            TweenService:Create(dot, TweenInfo.new(math.random(4,7), Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.random(-10,110)/100, 0, -0.2, 0),
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(math.random(1.2, 3.5))
        end
    end)
end

-- TÍTULO CON RAINBOW
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -80, 0, 40)
title.Position = UDim2.new(0, 18, 0, 10)
title.BackgroundTransparency = 1
title.Text = "⚡ MUÑOZ NEXUS"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Arcade
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 2
titleStroke.Color = Color3.fromRGB(255, 255, 255)

task.spawn(function()
    local hue = 0
    while task.wait(0.04) do
        hue = (hue + 3) % 360
        title.TextColor3 = Color3.fromHSV(hue/360, 1, 1)
        titleStroke.Color = title.TextColor3
    end
end)

-- Subtítulo
local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1, -80, 0, 18)
sub.Position = UDim2.new(0, 20, 0, 38)
sub.Text = "Private Build • v1.4"
sub.TextColor3 = Color3.fromRGB(170, 200, 255)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 12
sub.TextXAlignment = Enum.TextXAlignment.Left

-- Botones superiores mejorados
local function topBtn(txt, x)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(1, x, 0, 8)
    b.Text = txt
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(200, 220, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    
    local stroke = Instance.new("UIStroke", b)
    stroke.Thickness = 1.5
    
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0, 255, 200)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 255, 200)}):Play()
    end)
    
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 220, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(100, 120, 160)}):Play()
    end)
    
    return b
end

local close = topBtn("✕", -42)
local hide = topBtn("−", -78)

-- Minimizar circular
local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0, 58, 0, 58)
circle.Position = UDim2.new(0.08, 0, 0.45, 0)
circle.Text = "⚡"
circle.Visible = false
circle.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
circle.TextColor3 = Color3.fromRGB(0, 255, 200)
circle.TextSize = 26
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

local circleStroke = Instance.new("UIStroke", circle)
circleStroke.Thickness = 3

task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 2.5) % 360
        circleStroke.Color = Color3.fromHSV(hue/360, 1, 1)
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
hide.MouseButton1Click:Connect(function()
    frame.Visible = false
    circle.Visible = true
end)
circle.MouseButton1Click:Connect(function()
    frame.Visible = true
    circle.Visible = false
end)

-- TOGGLES MEJORADOS
local function createToggle(name, y)
    local holder = Instance.new("Frame", frame)
    holder.Size = UDim2.new(1, -24, 0, 38)
    holder.Position = UDim2.new(0, 12, 0, y)
    holder.BackgroundColor3 = Color3.fromRGB(18, 22, 42)
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(245, 245, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14.5
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", holder)
    toggleBtn.Size = UDim2.new(0, 48, 0, 24)
    toggleBtn.Position = UDim2.new(1, -62, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 85)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = false

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        }):Play()
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = state and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(50,55,85)
        }):Play()
    end)

    return function() return state end
end

local autoBuild = createToggle("Auto Construir", 62)
local upgradeOn = createToggle("Auto Mejorar", 105)
local sellOn = createToggle("Auto Vender", 148)
local attackOthers = createToggle("Eliminar Otras Bases", 191)
local helpOthers = createToggle("Mejorar Otras Bases", 234)

-- LOOP
task.spawn(function()
    while true do
        task.wait(0.6)
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
