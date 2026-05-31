local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

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

-- ==================== GUI PREMIUM ====================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0.72, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Glow + Shadow
local glow = Instance.new("UIStroke", frame)
glow.Thickness = 3
glow.Transparency = 0.4
glow.Color = Color3.fromRGB(0, 255, 255)

local innerGlow = Instance.new("UIStroke", frame)
innerGlow.Thickness = 1
innerGlow.Transparency = 0.7
innerGlow.Color = Color3.fromRGB(255, 255, 255)

-- Rainbow Border
local rainbowStroke = Instance.new("UIStroke", frame)
rainbowStroke.Thickness = 2.5
rainbowStroke.Color = Color3.fromRGB(255, 0, 255)

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = (hue + 0.8) % 360
        rainbowStroke.Color = Color3.fromHSV(hue/360, 1, 1)
    end
end)

-- Gradient Background
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 8, 25))
}
gradient.Rotation = 45

-- Floating Particles (mejorados)
for i = 1, 18 do
    local particle = Instance.new("Frame", frame)
    particle.Size = UDim2.new(0, math.random(3,6), 0, math.random(3,6))
    particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
    particle.BackgroundTransparency = 0.6
    Instance.new("UICorner", particle).CornerRadius = UDim.new(1,0)
    
    task.spawn(function()
        while true do
            particle.Position = UDim2.new(math.random(-20,120)/100, 0, 1.1, 0)
            particle.BackgroundTransparency = 0.6
            
            TweenService:Create(particle, TweenInfo.new(math.random(4,7), Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.random(-20,120)/100, 0, -0.2, 0),
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(math.random(1,3))
        end
    end)
end

-- Título con Glow
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 40)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.Text = "⚡ MUÑOZ NEXUS"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Arcade
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local titleGlow = Instance.new("UIStroke", title)
titleGlow.Thickness = 1.5
titleGlow.Color = Color3.fromRGB(0, 255, 255)

-- Rainbow Title
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = (hue + 3) % 360
        title.TextColor3 = Color3.fromHSV(hue/360, 1, 1)
        titleGlow.Color = title.TextColor3
    end
end)

local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1, -70, 0, 16)
sub.Position = UDim2.new(0, 16, 0, 32)
sub.Text = "Private Build • v1.2"
sub.TextColor3 = Color3.fromRGB(140, 160, 200)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 11
sub.TextXAlignment = Enum.TextXAlignment.Left

-- Botones superiores
local function topBtn(txt, posX)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 28, 0, 28)
    b.Position = UDim2.new(1, posX, 0, 8)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    
    local stroke = Instance.new("UIStroke", b)
    stroke.Thickness = 1.5
    
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255,255,255)}):Play()
    end)
    
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15,20,40)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,80,100)}):Play()
    end)
    
    return b
end

local close = topBtn("✕", -38)
local hide = topBtn("−", -72)

-- Minimizar
local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0, 60, 0, 60)
circle.Position = UDim2.new(0.1, 0, 0.5, 0)
circle.Visible = false
circle.Text = "⚡"
circle.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
circle.TextColor3 = Color3.fromRGB(0, 255, 255)
circle.TextSize = 28
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

local circleStroke = Instance.new("UIStroke", circle)
circleStroke.Thickness = 3

task.spawn(function()
    local h = 0
    while task.wait() do
        h = (h + 2) % 360
        circleStroke.Color = Color3.fromHSV(h/360, 1, 1)
    end
end)

-- Toggles Mejorados
local function createToggle(name, y)
    local holder = Instance.new("Frame", frame)
    holder.Size = UDim2.new(1, -24, 0, 36)
    holder.Position = UDim2.new(0, 12, 0, y)
    holder.BackgroundColor3 = Color3.fromRGB(15, 18, 38)
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)
    
    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton", holder)
    toggle.Size = UDim2.new(0, 48, 0, 22)
    toggle.Position = UDim2.new(1, -58, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 55, 80)
    toggle.Text = ""
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
    
    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    
    local state = false
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        TweenService:Create(toggle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = state and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(50,55,80)
        }):Play()
    end)
    
    return function() return state end
end

local autoBuild   = createToggle("Auto Construir", 55)
local autoUpgrade = createToggle("Auto Mejorar", 95)
local autoSell    = createToggle("Auto Vender", 135)
local attackBase  = createToggle("Eliminar Otras Bases", 175)
local helpBase    = createToggle("Mejorar Otras Bases", 215)

-- Cerrar y Minimizar
close.MouseButton1Click:Connect(function() gui:Destroy() end)

hide.MouseButton1Click:Connect(function()
    frame.Visible = false
    circle.Visible = true
end)

circle.MouseButton1Click:Connect(function()
    frame.Visible = true
    circle.Visible = false
end)

-- ==================== MAIN LOOP ====================
task.spawn(function()
    while true do
        task.wait(0.6) -- Más rápido pero controlado
        
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
                if autoUpgrade() then remoteUpgrade:FireServer("upgrade", obj) end
                if autoSell() then remoteUpgrade:FireServer("sell", obj) end
            end
        end
        
        for _, base in pairs(workspace.Bases:GetChildren()) do
            if base ~= myBase then
                for _, obj in pairs(base:GetDescendants()) do
                    if obj:IsA("Model") then
                        if attackBase() then remoteUpgrade:FireServer("sell", obj) end
                        if helpBase() then remoteUpgrade:FireServer("upgrade", obj) end
                    end
                end
            end
        end
    end
end)
