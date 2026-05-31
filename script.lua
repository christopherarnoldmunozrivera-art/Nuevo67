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
frame.Size = UDim2.new(0, 355, 0, 310)
frame.Position = UDim2.new(0.72, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(12, 14, 32)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Borde Neon Verde/Cyan (como en tu imagen)
local border = Instance.new("UIStroke", frame)
border.Thickness = 5
border.Color = Color3.fromRGB(0, 255, 200)

-- Inner glow
local inner = Instance.new("UIStroke", frame)
inner.Thickness = 1
inner.Transparency = 0.6
inner.Color = Color3.fromRGB(0, 255, 255)

-- Gradient suave
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 24, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 28))
}
gradient.Rotation = 85

-- TÍTULO (como en la imagen)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -100, 0, 40)
title.Position = UDim2.new(0, 20, 0, 12)
title.BackgroundTransparency = 1
title.Text = "⚡ MUÑOZ NEXUS"
title.TextColor3 = Color3.fromRGB(0, 255, 220)
title.Font = Enum.Font.Arcade
title.TextSize = 23
title.TextXAlignment = Enum.TextXAlignment.Left

local titleGlow = Instance.new("UIStroke", title)
titleGlow.Thickness = 2.5
titleGlow.Color = Color3.fromRGB(0, 255, 255)

-- Subtítulo
local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1, -100, 0, 18)
sub.Position = UDim2.new(0, 22, 0, 38)
sub.Text = "Private Build • v1.3"
sub.TextColor3 = Color3.fromRGB(160, 200, 230)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 12
sub.TextXAlignment = Enum.TextXAlignment.Left

-- Botones superiores (limpios)
local function createTopButton(text, x)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, x, 0, 10)
    btn.Text = text
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.fromRGB(180, 200, 230)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 255, 200)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 200, 230)}):Play()
    end)
    
    return btn
end

local minimizeBtn = createTopButton("–", -45)
local closeBtn = createTopButton("×", -78)

-- Toggle Function (más parecido a tu imagen)
local function createToggle(name, yPos)
    local holder = Instance.new("Frame", frame)
    holder.Size = UDim2.new(1, -30, 0, 46)
    holder.Position = UDim2.new(0, 15, 0, yPos)
    holder.BackgroundColor3 = Color3.fromRGB(22, 26, 48)
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 245, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", holder)
    toggleBtn.Size = UDim2.new(0, 50, 0, 26)
    toggleBtn.Position = UDim2.new(1, -65, 0.5, -13)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 2, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(200, 205, 220)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local enabled = false

    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        }):Play()
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 240, 180) or Color3.fromRGB(40,45,70)
        }):Play()
    end)

    return function() return enabled end
end

-- Crear toggles
local autoBuild   = createToggle("Auto Construir", 72)
local autoUpgrade = createToggle("Auto Mejorar", 122)
local autoSell    = createToggle("Auto Vender", 172)
local attackBase  = createToggle("Eliminar Otras Bases", 222)
local helpBase    = createToggle("Mejorar Otras Bases", 272)

-- Acciones
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
minimizeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

-- LOOP
task.spawn(function()
    while true do
        task.wait(0.5)
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
