-- ============================================
--           🌙 luna.master
--      Blox Fruits | Mobile Ultimate
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local farming = false
local flying = false

-- Авто-респавн
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ============================================
--              ФУНКЦИИ
-- ============================================

-- Поиск ближайшего моба
local function getNearestMob()
    local nearest, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Health > 0 and obj.Parent ~= character then
            local root = obj.Parent:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (rootPart.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = obj.Parent
                end
            end
        end
    end
    return nearest, minDist
end

-- Телепорт к мобу
local function tpToMob(mob)
    local root = mob:FindFirstChild("HumanoidRootPart")
    if root then
        rootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, -3))
    end
end

-- Атака
local function attack()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local remote = tool:FindFirstChildOfClass("RemoteEvent")
        if remote then pcall(function() remote:FireServer() end) end
    end
    -- Симуляция клика
    pcall(function() mouse1press() task.wait(0.02) mouse1release() end)
end

-- Полёт
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = Vector3.zero

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
bg.P = 1e6

RunService.Heartbeat:Connect(function()
    if not rootPart then return end
    if flying then
        bv.Parent = rootPart
        bg.Parent = rootPart
        humanoid.PlatformStand = true
        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * 500
        bg.CFrame = cam.CFrame
    else
        bv.Parent = nil
        bg.Parent = nil
        if humanoid then humanoid.PlatformStand = false end
    end
end)

-- Быстрый автофарм
task.spawn(function()
    while true do
        task.wait(0.03)
        if farming and humanoid and humanoid.Health > 0 then
            local mob, dist = getNearestMob()
            if mob then
                if dist > 10 then
                    tpToMob(mob)
                    task.wait(0.05)
                end
                attack()
            else
                task.wait(0.5)
            end
        end
    end
end)

-- ============================================
--              GUI
-- ============================================

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player.PlayerGui

-- Водяной знак
local wm = Instance.new("Frame")
wm.Size = UDim2.new(0, 180, 0, 36)
wm.Position = UDim2.new(0.5, -90, 0, 12)
wm.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
wm.BackgroundTransparency = 0.2
wm.BorderSizePixel = 0
wm.Parent = gui
Instance.new("UICorner", wm).CornerRadius = UDim.new(0, 10)

local wmLabel = Instance.new("TextLabel")
wmLabel.Size = UDim2.new(1, 0, 1, 0)
wmLabel.BackgroundTransparency = 1
wmLabel.TextColor3 = Color3.fromRGB(180, 140, 255)
wmLabel.Font = Enum.Font.GothamBold
wmLabel.TextScaled = true
wmLabel.Text = "🌙 luna.master"
wmLabel.Parent = wm

-- Градиент водяного знака
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
})
grad.Parent = wmLabel

-- Панель кнопок
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 340, 0, 80)
panel.Position = UDim2.new(0.5, -170, 1, -100)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
panel.BackgroundTransparency = 0.3
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)
layout.Parent = panel

local function makeBtn(text, colorOn, colorOff, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 145, 0, 58)
    btn.BackgroundColor3 = colorOff
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text .. "\nOFF"
    btn.BorderSizePixel = 0
    btn.Parent = panel
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local state = false
    local function toggle()
        state = not state
        btn.Text = text .. (state and "\nON" or "\nOFF")
        btn.BackgroundColor3 = state and colorOn or colorOff
        callback(state)
    end

    btn.TouchTap:Connect(toggle)
    btn.MouseButton1Click:Connect(toggle)
    return btn
end

-- Кнопка AutoFarm
makeBtn("🌾 AutoFarm", Color3.fromRGB(50, 200, 80), Color3.fromRGB(150, 40, 40), function(state)
    farming = state
end)

-- Кнопка Полёт
makeBtn("✈️ Полёт", Color3.fromRGB(60, 140, 255), Color3.fromRGB(40, 40, 150), function(state)
    flying = state
end)

-- Кнопка Телепорт к мобу
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 145, 0, 58)
tpBtn.Position = UDim2.new(0.5, -72, 1, -175)
tpBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextScaled = true
tpBtn.Text = "⚡ ТП к мобу"
tpBtn.BorderSizePixel = 0
tpBtn.Parent = gui
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 10)

local function doTp()
    local mob = getNearestMob()
    if mob then
        tpToMob(mob)
    end
end
tpBtn.TouchTap:Connect(doTp)
tpBtn.MouseButton1Click:Connect(doTp)

print("[luna.master] Загружен ✅")
