-- ============================================
--           🌙 luna.master v3.1
--      Blox Fruits | WIKI-FIXED AutoFarm
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local farming = false
local flying = false
local statusMsg = "Ожидание..."

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ============================================
-- ПРАВИЛЬНАЯ БАЗА КВЕСТОВ (по вики 2025-2026)
-- ============================================

local Quests = {
    -- ===== SEA 1 (Lv.1 - 700) =====
    {min=1,   max=14,   mob="Bandit",            island="Starter Island",      pos=Vector3.new(977,10,1430)},
    {min=15,  max=29,   mob="Monkey",            island="Jungle",              pos=Vector3.new(1234,10,1500)},
    {min=30,  max=59,   mob="Gorilla",           island="Jungle",              pos=Vector3.new(1400,10,1600)},
    {min=60,  max=89,   mob="Pirate",            island="Pirate Village",      pos=Vector3.new(1000,10,1200)},
    {min=90,  max=119,  mob="Tough Customer",    island="Pirate Village",      pos=Vector3.new(900,10,1100)},
    {min=120, max=149,  mob="Desert Bandit",     island="Desert",              pos=Vector3.new(600,10,700)},
    {min=150, max=174,  mob="Desert Officer",    island="Desert",              pos=Vector3.new(500,10,650)},
    {min=175, max=224,  mob="Snow Trooper",      island="Frozen Village",      pos=Vector3.new(200,10,300)},
    {min=225, max=274,  mob="Winter Warrior",    island="Frozen Village",      pos=Vector3.new(150,10,250)},
    {min=275, max=299,  mob="Snowman",           island="Frozen Village",      pos=Vector3.new(100,10,200)},
    {min=300, max=374,  mob="Fishman Warrior",   island="Underwater City",     pos=Vector3.new(-500,10,-400)},
    {min=375, max=449,  mob="Fishman Elder",     island="Underwater City",     pos=Vector3.new(-600,10,-500)},
    {min=450, max=524,  mob="Marine Lieutenant", island="Marine Fortress",     pos=Vector3.new(-700,10,-600)},
    {min=525, max=574,  mob="Marine Captain",    island="Marine Fortress",     pos=Vector3.new(-750,10,-650)},
    {min=575, max=624,  mob="Sky Bandit",        island="Sky Island",          pos=Vector3.new(-800,200,-700)},
    {min=625, max=699,  mob="Dark Master",       island="Sky Island",          pos=Vector3.new(-900,200,-800)},

    -- ===== SEA 2 (Lv.700 - 1500) =====
    {min=700, max=799,  mob="Raider",            island="Kingdom of Rose",     pos=Vector3.new(1000,10,-1000)},
    {min=800, max=874,  mob="Mercenary",         island="Kingdom of Rose",     pos=Vector3.new(1050,10,-1050)},
    {min=875, max=949,  mob="Swan Pirate",       island="Kingdom of Rose",     pos=Vector3.new(1100,10,-1100)},
    {min=950, max=999,  mob="Jungle Pirate",     island="Green Zone",          pos=Vector3.new(1150,10,-1150)},
    {min=1000,max=1049, mob="Zombie",            island="Graveyard",           pos=Vector3.new(1200,10,-1200)},
    {min=1050,max=1099, mob="Vampire",           island="Graveyard",           pos=Vector3.new(1250,10,-1250)},
    {min=1100,max=1199, mob="Snow Demon",        island="Snow Mountain",       pos=Vector3.new(1300,10,-1300)},
    {min=1200,max=1274, mob="Magma Ninja",       island="Hot and Cold",        pos=Vector3.new(1350,10,-1350)},
    {min=1275,max=1349, mob="Ice Demon",         island="Hot and Cold",        pos=Vector3.new(1400,10,-1400)},
    {min=1350,max=1424, mob="Factory Staff",     island="Cursed Ship",         pos=Vector3.new(1450,10,-1450)},
    {min=1425,max=1499, mob="Ship Deckhand",     island="Cursed Ship",         pos=Vector3.new(1500,10,-1500)},

    -- ===== SEA 3 (Lv.1500 - 2800) =====
    {min=1500,max=1574, mob="Forest Pirate",     island="Elf Island",          pos=Vector3.new(2000,10,2000)},
    {min=1575,max=1649, mob="Mythological Pirate",island="Great Tree",         pos=Vector3.new(2050,10,2050)},
    {min=1650,max=1699, mob="Toad",              island="Great Tree",          pos=Vector3.new(2100,10,2100)},
    {min=1700,max=1799, mob="Marine Commodore",  island="Great Tree",          pos=Vector3.new(2150,10,2150)},
    {min=1800,max=1874, mob="Kilo Admiral",      island="Great Tree",          pos=Vector3.new(2200,10,2200)},
    {min=1875,max=1999, mob="Cursed Pirate",     island="Floating Turtle",     pos=Vector3.new(2300,10,2300)},
    {min=2000,max=2074, mob="Demonic Soul",      island="Haunted Castle",      pos=Vector3.new(2400,10,2400)},
    {min=2075,max=2199, mob="Peanut Scout",      island="Sea of Treats",       pos=Vector3.new(2500,10,2500)},
    {min=2200,max=2299, mob="Cookie Crafter",    island="Sea of Treats",       pos=Vector3.new(2550,10,2550)},
    {min=2300,max=2399, mob="Cocoa Warrior",     island="Sea of Treats",       pos=Vector3.new(2600,10,2600)},
    {min=2400,max=2524, mob="Candy Pirate",      island="Sea of Treats",       pos=Vector3.new(2650,10,2650)},
    {min=2525,max=2624, mob="Isle Champion",     island="Tiki Outpost",        pos=Vector3.new(2700,10,2700)},
    {min=2625,max=2800, mob="Tiki Outpost Guard",island="Tiki Outpost",        pos=Vector3.new(2750,10,2750)},
}

local function getLevel()
    for _, child in ipairs(player:GetChildren()) do
        local lvl = child:FindFirstChild("Level") or child:FindFirstChild("Lvl")
        if lvl then return lvl.Value end
    end
    -- Запасной вариант
    local data = player:FindFirstChild("Data")
        or player:FindFirstChild("leaderstats")
        or player:FindFirstChild("PlayerData")
    if data then
        local lvl = data:FindFirstChild("Level") or data:FindFirstChild("Lvl")
        if lvl then return lvl.Value end
    end
    return 1
end

local function getQuest(lvl)
    for _, q in ipairs(Quests) do
        if lvl >= q.min and lvl <= q.max then return q end
    end
    return Quests[#Quests]
end

-- ============================================
--           БОЕВЫЕ ФУНКЦИИ
-- ============================================

local function findMob(name)
    local nearest, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                if string.lower(obj.Name):find(string.lower(name), 1, true) then
                    local dist = (rootPart.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest, minDist
end

-- Плавный телепорт через Tween
local function tweenTo(target)
    if not rootPart then return end
    local tween = TweenService:Create(
        rootPart,
        TweenInfo.new(0.15, Enum.EasingStyle.Linear),
        {CFrame = target}
    )
    tween:Play()
    tween.Completed:Wait()
end

-- Melee атака (правильная)
local function meleeAttack(mob)
    if not mob or not rootPart then return end
    local root = mob:FindFirstChild("HumanoidRootPart")
    if root then
        -- Поворот к мобу
        rootPart.CFrame = CFrame.lookAt(
            rootPart.Position,
            Vector3.new(root.Position.X, rootPart.Position.Y, root.Position.Z)
        )
    end
    -- M1 удар (ближний бой)
    pcall(function()
        mouse1press()
        task.wait(0.04)
        mouse1release()
    end)
end

-- ============================================
--           ИСПРАВЛЕННЫЙ ПОЛЁТ
-- ============================================

local flyBody = nil
local flyGyro = nil

local function enableFlight()
    if flyBody then return end
    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBody.Velocity = Vector3.zero
    flyBody.Parent = rootPart

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyGyro.P = 1e6
    flyGyro.D = 100
    flyGyro.Parent = rootPart

    humanoid.PlatformStand = true
end

local function disableFlight()
    if flyBody then flyBody:Destroy() flyBody = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    if humanoid then humanoid.PlatformStand = false end
end

RunService.Heartbeat:Connect(function()
    if not rootPart or not humanoid then return end
    if flying then
        if not flyBody then enableFlight() end
        local cf = camera.CFrame
        local dir = cf.LookVector
        flyBody.Velocity = dir * 200
        flyGyro.CFrame = cf
    else
        if flyBody then disableFlight() end
    end
end)

-- ============================================
--           АВТОФАРМ ЦИКЛ (ИСПРАВЛЕН)
-- ============================================

task.spawn(function()
    while true do
        task.wait(0.05)

        if not farming then
            statusMsg = "⏸ Ожидание..."
            continue
        end

        -- Проверка жизни
        if not humanoid or humanoid.Health <= 0 then
            statusMsg = "💀 Умер, жду..."
            task.wait(3)
            continue
        end

        local lvl = getLevel()
        local quest = getQuest(lvl)
        statusMsg = "⚔️ Lv."..lvl.." | "..quest.mob

        -- Ищем моба
        local mob, dist = findMob(quest.mob)

        if mob then
            local root = mob:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            -- Телепорт если далеко
            if dist > 15 then
                tweenTo(CFrame.new(
                    root.Position + Vector3.new(0, 2, -4)
                ))
                task.wait(0.1)
            end

            -- Проверяем что моб ещё жив
            local hum = mob:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                meleeAttack(mob)
            end

        else
            -- Мобов нет — телепорт в зону острова
            statusMsg = "🗺️ Ищу: "..quest.island
            rootPart.CFrame = CFrame.new(quest.pos)
            task.wait(1.5)
        end
    end
end)

-- ============================================
--                   GUI
-- ============================================

pcall(function()
    local old = player.PlayerGui:FindFirstChild("LunaMaster")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LunaMaster"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = player.PlayerGui

-- Главное окно
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 310, 0, 430)
win.Position = UDim2.new(0.5,-155,0.5,-215)
win.BackgroundColor3 = Color3.fromRGB(6,6,18)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = gui
Instance.new("UICorner",win).CornerRadius = UDim.new(0,20)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(120,50,255)
mainStroke.Thickness = 2
mainStroke.Parent = win

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(12,6,30)
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = win
Instance.new("UICorner",header).CornerRadius = UDim.new(0,20)

local hGrad = Instance.new("UIGradient")
hGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(120,30,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(60,60,220)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(30,130,255)),
})
hGrad.Parent = header

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1,-55,1,0)
titleLbl.Position = UDim2.new(0,12,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3 = Color3.new(1,1,1)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextScaled = true
titleLbl.Text = "🌙 luna.master v3.1"
titleLbl.ZIndex = 3
titleLbl.Parent = header

-- Кнопка закрыть
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,34,0,34)
closeBtn.Position = UDim2.new(1,-42,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(210,40,60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 5
closeBtn.Parent = win
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,8)
local function closeWin() win.Visible = false end
closeBtn.MouseButton1Click:Connect(closeWin)
closeBtn.TouchTap:Connect(closeWin)

-- Кнопка открыть
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(0,6,0.5,-25)
openBtn.BackgroundColor3 = Color3.fromRGB(100,30,220)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.Text = "🌙"
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0
openBtn.ZIndex = 5
openBtn.Parent = gui
Instance.new("UICorner",openBtn).CornerRadius = UDim.new(1,0)
local function openWin() win.Visible = true end
openBtn.MouseButton1Click:Connect(openWin)
openBtn.TouchTap:Connect(openWin)

-- ТАБ-ПАНЕЛЬ
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,-16,0,40)
tabBar.Position = UDim2.new(0,8,0,60)
tabBar.BackgroundColor3 = Color3.fromRGB(16,8,36)
tabBar.BorderSizePixel = 0
tabBar.Parent = win
Instance.new("UICorner",tabBar).CornerRadius = UDim.new(0,12)

local tLayout = Instance.new("UIListLayout")
tLayout.FillDirection = Enum.FillDirection.Horizontal
tLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tLayout.Padding = UDim.new(0,6)
tLayout.Parent = tabBar

local pages = {}

local function newPage()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-16,0,310)
    f.Position = UDim2.new(0,8,0,106)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = win
    return f
end

local function switchTab(name)
    for k,v in pairs(pages) do
        local on = k==name
        v.btn.BackgroundColor3 = on
            and Color3.fromRGB(110,40,240)
            or  Color3.fromRGB(22,12,48)
        v.btn.TextColor3 = on
            and Color3.new(1,1,1)
            or  Color3.fromRGB(150,120,210)
        v.page.Visible = on
    end
end

local function addTab(icon, name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,88,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(22,12,48)
    btn.TextColor3 = Color3.fromRGB(150,120,210)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = icon.." "..name
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
    local pg = newPage()
    pages[name] = {btn=btn, page=pg}
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    btn.TouchTap:Connect(function() switchTab(name) end)
    return pg
end

local farmPage = addTab("🌾","Farm")
local flyPage  = addTab("✈️","Fly")
local tpPage   = addTab("⚡","TP")

-- УТИЛИТЫ UI
local function mkCard(p, y, h)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h or 48)
    f.Position = UDim2.new(0,0,0,y)
    f.BackgroundColor3 = Color3.fromRGB(16,8,36)
    f.BorderSizePixel = 0
    f.Parent = p
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,10)
    return f
end

local function mkLabel(p, txt, size, col, bold)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-8,1,0)
    l.Position = UDim2.new(0,4,0,0)
    l.BackgroundTransparency = 1
    l.TextColor3 = col or Color3.new(1,1,1)
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = size or 13
    l.Text = txt
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = p
    return l
end

local function mkToggle(p, y, txt, onC, offC, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,54)
    btn.Position = UDim2.new(0,0,0,y)
    btn.BackgroundColor3 = offC
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = txt.."  OFF"
    btn.BorderSizePixel = 0
    btn.Parent = p
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)
    local s = false
    local function tog()
        s = not s
        btn.Text = txt..(s and "  ✅ ON" or "  OFF")
        btn.BackgroundColor3 = s and onC or offC
        cb(s)
    end
    btn.MouseButton1Click:Connect(tog)
    btn.TouchTap:Connect(tog)
    return btn
end

local function mkAction(p, y, txt, col, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,54)
    btn.Position = UDim2.new(0,0,0,y)
    btn.BackgroundColor3 = col
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = txt
    btn.BorderSizePixel = 0
    btn.Parent = p
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)
    btn.MouseButton1Click:Connect(cb)
    btn.TouchTap:Connect(cb)
    return btn
end

-- ========== FARM TAB ==========
local statusCard = mkCard(farmPage, 0, 40)
local statusLbl  = mkLabel(statusCard, "⏸ Ожидание...", 13,
    Color3.fromRGB(200,180,255), false)

local questCard = mkCard(farmPage, 46, 40)
local questLbl  = mkLabel(questCard, "📋 Квест: —", 12,
    Color3.fromRGB(140,210,255), false)

local islandCard = mkCard(farmPage, 92, 40)
local islandLbl  = mkLabel(islandCard, "🏝 Остров: —", 12,
    Color3.fromRGB(140,255,180), false)

mkToggle(farmPage, 138, "🌾 Quest AutoFarm",
    Color3.fromRGB(35,175,65),
    Color3.fromRGB(130,30,30),
    function(s) farming = s end)

local infoCard = mkCard(farmPage, 200, 52)
mkLabel(infoCard,
    "Melee фарм по уровню\nАвто-квест Sea 1→2→3",
    12, Color3.fromRGB(140,140,180), false)

-- Обновление инфо каждый кадр
RunService.Heartbeat:Connect(function()
    pcall(function()
        statusLbl.Text = "  "..statusMsg
        local lvl = getLevel()
        local q = getQuest(lvl)
        questLbl.Text = "  📋 "..q.mob.."  (Lv."..q.min.."-"..q.max..")"
        islandLbl.Text = "  🏝 "..q.island
    end)
end)

-- ========== FLY TAB ==========
mkToggle(flyPage, 0, "✈️ Полёт 200",
    Color3.fromRGB(35,120,240),
    Color3.fromRGB(25,35,120),
    function(s) flying = s end)

local flyCard = mkCard(flyPage, 62, 52)
mkLabel(flyCard,
    "Скорость: 200\nНаправление по камере\nBodyVelocity + BodyGyro",
    12, Color3.fromRGB(130,175,255), false)

-- ========== TP TAB ==========
mkAction(tpPage, 0, "⚡ ТП к мобу",
    Color3.fromRGB(115,35,220),
    function()
        local mob = findMob(getQuest(getLevel()).mob)
        if mob then
            local r = mob:FindFirstChild("HumanoidRootPart")
            if r then
                tweenTo(CFrame.new(r.Position + Vector3.new(0,2,-4)))
            end
        end
    end)

mkAction(tpPage, 62, "🗺️ ТП в зону квеста",
    Color3.fromRGB(35,95,200),
    function()
        local q = getQuest(getLevel())
        rootPart.CFrame = CFrame.new(q.pos)
    end)

local tpCard = mkCard(tpPage, 124, 40)
local tpInfoLbl = mkLabel(tpCard,"","",Color3.fromRGB(200,200,200),false)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local q = getQuest(getLevel())
        tpInfoLbl.Text = "  📍 "..q.island.." → "..q.mob
    end)
end)

-- Активируем Farm таб
switchTab("Farm")

print("[🌙 luna.master v3.1] Загружен ✅  |  Wiki-fixed")
