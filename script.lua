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
sub.Size = UDim2.new(1, -80, 0, 18
