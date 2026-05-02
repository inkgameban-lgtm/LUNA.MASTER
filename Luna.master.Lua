-- ============================================
--           🌙 luna.master v2.0
--      Blox Fruits | Quest AutoFarm
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local farming = false
local flying = false
local currentTab = "farm"

-- Авто-респавн
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ============================================
--         БАЗА КВЕСТОВ ПО УРОВНЯМ
-- ============================================

local QuestData = {
    -- Sea 1
    { minLvl = 1,   maxLvl = 14,  mob = "Bandit",            quest = "Bandit",          pos = Vector3.new(977, 10, 1430)  },
    { minLvl = 15,  maxLvl = 29,  mob = "Monkey",            quest = "Monkey",          pos = Vector3.new(1234, 10, 1500) },
    { minLvl = 30,  maxLvl = 59,  mob = "Gorilla",           quest = "Gorilla",         pos = Vector3.new(1400, 10, 1600) },
    { minLvl = 60,  maxLvl = 89,  mob = "Pirate",            quest = "Pirate",          pos = Vector3.new(1000, 10, 1200) },
    { minLvl = 90,  maxLvl = 119, mob = "Tough Customer",    quest = "Tough Customer",  pos = Vector3.new(800,  10, 900)  },
    { minLvl = 120, maxLvl = 149, mob = "Desert Bandit",     quest = "Desert Bandit",   pos = Vector3.new(600,  10, 700)  },
    { minLvl = 150, maxLvl = 174, mob = "Desert Officer",    quest = "Desert Officer",  pos = Vector3.new(500,  10, 600)  },
    { minLvl = 175, maxLvl = 224, mob = "Snow Trooper",      quest = "Snow Trooper",    pos = Vector3.new(200,  10, 300)  },
    { minLvl = 225, maxLvl = 299, mob = "Winter Warrior",    quest = "Winter Warrior",  pos = Vector3.new(100,  10, 200)  },
    { minLvl = 300, maxLvl = 374, mob = "Fishman Warrior",   quest = "Fishman Warrior", pos = Vector3.new(-500, 10, -400) },
    { minLvl = 375, maxLvl = 449, mob = "Fishman Elder",     quest = "Fishman Elder",   pos = Vector3.new(-600, 10, -500) },
    { minLvl = 450, maxLvl = 524, mob = "Marine",            quest = "Marine",          pos = Vector3.new(-700, 10, -600) },
    { minLvl = 525, maxLvl = 624, mob = "Sky Bandit",        quest = "Sky Bandit",      pos = Vector3.new(-800, 50, -700) },
    { minLvl = 625, maxLvl = 699, mob = "Dark Master",       quest = "Dark Master",     pos = Vector3.new(-900, 50, -800) },
    -- Sea 2
    { minLvl = 700, maxLvl = 774, mob = "Punk Hazard",       quest = "Punk Hazard",     pos = Vector3.new(1000, 10, -1000)},
    { minLvl = 775, maxLvl = 849, mob = "Magma Ninja",       quest = "Magma Ninja",     pos = Vector3.new(1100, 10, -1100)},
    { minLvl = 850, maxLvl = 924, mob = "Dragon Crew",       quest = "Dragon Crew",     pos = Vector3.new(1200, 10, -1200)},
    { minLvl = 925, maxLvl = 999, mob = "Zombie",            quest = "Zombie",          pos = Vector3.new(1300, 10, -1300)},
    -- Sea 3
    { minLvl = 1000, maxLvl = 1099, mob = "Forest Pirate",   quest = "Forest Pirate",   pos = Vector3.new(2000, 10, 2000) },
    { minLvl = 1100, maxLvl = 1199, mob = "Jungle Pirate",   quest = "Jungle Pirate",   pos = Vector3.new(2100, 10, 2100) },
    { minLvl = 1200, maxLvl = 1299, mob = "Musketeer",       quest = "Musketeer",       pos = Vector3.new(2200, 10, 2200) },
    { minLvl = 1300, maxLvl = 1499, mob = "Wysper",          quest = "Wysper",          pos = Vector3.new(2300, 10, 2300) },
    { minLvl = 1500, maxLvl = 1699, mob = "Ice Admiral",     quest = "Ice Admiral",     pos = Vector3.new(2400, 10, 2400) },
    { minLvl = 1700, maxLvl = 1999, mob = "Cursed Pirate",   quest = "Cursed Pirate",   pos = Vector3.new(2500, 10, 2500) },
    { minLvl = 2000, maxLvl = 2299, mob = "Demonic Soul",    quest = "Demonic Soul",    pos = Vector3.new(2600, 10, 2600) },
    { minLvl = 2300, maxLvl = 9999, mob = "Pirate Officer",  quest = "Pirate Officer",  pos = Vector3.new(2700, 10, 2700) },
}

-- Получить квест по уровню
local function getQuestForLevel(lvl)
    for _, data in ipairs(QuestData) do
        if lvl >= data.minLvl and lvl <= data.maxLvl then
            return data
        end
    end
    return QuestData[#QuestData]
end

-- Получить уровень игрока
local function getLevel()
    local stats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Data")
    if stats then
        local lvl = stats:FindFirstChild("Level") or stats:FindFirstChild("Lvl")
        if lvl then return lvl.Value end
    end
    return 1
end

-- ============================================
--              БОЕВЫЕ ФУНКЦИИ
-- ============================================

-- Ближний бой (melee)
local function meleeAttack()
    -- Симуляция клика (ближний бой)
    pcall(function()
        mouse1press()
        task.wait(0.03)
        mouse1release()
    end)
end

-- Поиск моба по имени
local function findMobByName(name)
    local nearest, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Health > 0 and obj.Parent ~= character then
            if string.find(obj.Parent.Name, name) or name == "any" then
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

-- Телепорт к позиции
local function tpToPos(pos)
    rootPart.CFrame = CFrame.new(pos)
end

-- Принять квест (поиск NPC квеста)
local function acceptQuest(questName)
    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and string.find(npc.Name, "Quest") then
            local root = npc:FindFirstChild("HumanoidRootPart")
            if root then
                rootPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, -4))
                task.wait(0.3)
                -- Взаимодействие с NPC
                local clickDetector = root:FindFirstChildOfClass("ClickDetector")
                    or npc:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    pcall(function() fireclickdetector(clickDetector) end)
                end
                break
            end
        end
    end
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

-- Главный цикл квест-фарма
local statusText = ""
task.spawn(function()
    while true do
        task.wait(0.03)
        if farming and humanoid and humanoid.Health > 0 then
            local lvl = getLevel()
            local quest = getQuestForLevel(lvl)
            statusText = "Lv."..lvl.." → "..quest.mob

            local mob, dist = findMobByName(quest.mob)

            if mob then
                if dist > 10 then
                    tpToMob(mob)
                    task.wait(0.05)
                end
                meleeAttack()
            else
                -- Мобов нет — телепорт в зону
                tpToPos(quest.pos)
                task.wait(0.5)
            end
        else
            statusText = "Ожидание..."
        end
    end
end)

-- ============================================
--              GUI ДИЗАЙН
-- ============================================

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player.PlayerGui

-- Фон главного окна
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Обводка
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(120, 60, 220)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- Шапка
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(14, 8, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 100, 255)),
})
grad.Rotation = 90
grad.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Text = "🌙 luna.master"
title.Parent = header

-- Кнопка закрыть
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -42, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
closeBtn.TouchTap:Connect(function() mainFrame.Visible = false end)

-- Открыть снова
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 44, 0, 44)
openBtn.Position = UDim2.new(0, 10, 0.5, -22)
openBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 220)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.Text = "🌙"
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true end)
openBtn.TouchTap:Connect(function() mainFrame.Visible = true end)

-- Таб-кнопки
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 58)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 12, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 10)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabFrame

-- Контент-панели
local pages = {}

local function makePage()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 300)
    f.Position = UDim2.new(0, 10, 0, 105)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.Parent = mainFrame
    return f
end

local function makeTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 88, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 18, 55)
    btn.TextColor3 = Color3.fromRGB(180, 150, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = icon.." "..name
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local page = makePage()
    pages[name] = {btn = btn, page = page}
    return btn, page
end

local function switchTab(name)
    currentTab = name
    for k, v in pairs(pages) do
        if k == name then
            v.btn.BackgroundColor3 = Color3.fromRGB(100, 40, 220)
            v.btn.TextColor3 = Color3.new(1,1,1)
            v.page.Visible = true
        else
            v.btn.BackgroundColor3 = Color3.fromRGB(30, 18, 55)
            v.btn.TextColor3 = Color3.fromRGB(180, 150, 255)
            v.page.Visible = false
        end
    end
end

local farmBtn, farmPage = makeTab("Farm", "🌾")
local flyBtn2, flyPage = makeTab("Fly", "✈️")
local tpBtn2, tpPage = makeTab("TP", "⚡")

farmBtn.MouseButton1Click:Connect(function() switchTab("Farm") end)
farmBtn.TouchTap:Connect(function() switchTab("Farm") end)
flyBtn2.MouseButton1Click:Connect(function() switchTab("Fly") end)
flyBtn2.TouchTap:Connect(function() switchTab("Fly") end)
tpBtn2.MouseButton1Click:Connect(function() switchTab("TP") end)
tpBtn2.TouchTap:Connect(function() switchTab("TP") end)

-- Утилита: большая кнопка
local function bigToggle(parent, text, onColor, offColor, yPos, onToggle)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 56)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = offColor
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text.."\nOFF"
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local state = false
    local function toggle()
        state = not state
        btn.Text = text..(state and "\nON ✅" or "\nOFF")
        btn.BackgroundColor3 = state and onColor or offColor
        onToggle(state)
    end
    btn.MouseButton1Click:Connect(toggle)
    btn.TouchTap:Connect(toggle)
    return btn
end

-- Инфо-лейбл
local function infoLabel(parent, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 36)
    lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 12, 40)
    lbl.TextColor3 = Color3.fromRGB(200, 180, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextScaled = true
    lbl.Text = "..."
    lbl.BorderSizePixel = 0
    lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
    return lbl
end

-- === TAB: FARM ===
local statusLbl = infoLabel(farmPage, 0)
bigToggle(farmPage, "🌾 Quest AutoFarm",
    Color3.fromRGB(50, 200, 80),
    Color3.fromRGB(120, 30, 30),
    44, function(state) farming = state end)

local questLbl = infoLabel(farmPage, 108)
questLbl.Text = "Квест: ожидание..."

-- Обновление статуса
RunService.Heartbeat:Connect(function()
    if statusLbl then
        statusLbl.Text = "⚔️ "..statusText
    end
    if questLbl then
        local lvl = getLevel()
        local q = getQuestForLevel(lvl)
        questLbl.Text = "📋 "..q.quest.." (Lv."..q.minLvl.."-"..q.maxLvl..")"
    end
end)

-- === TAB: FLY ===
bigToggle(flyPage, "✈️ Полёт 150",
    Color3.fromRGB(60, 140, 255),
    Color3.fromRGB(30, 40, 120),
    0, function(state) flying = state end)

local flyInfo = infoLabel(flyPage, 64)
flyInfo.Text = "Лети по направлению камеры"

-- === TAB: TP ===
local tpInfo = infoLabel(tpPage, 0)
tpInfo.Text = "Телепорт к ближайшему мобу"

local tpNow = Instance.new("TextButton")
tpNow.Size = UDim2.new(1, 0, 0, 56)
tpNow.Position = UDim2.new(0, 0, 0, 44)
tpNow.BackgroundColor3 = Color3.fromRGB(120, 40, 220)
tpNow.TextColor3 = Color3.new(1,1,1)
tpNow.Font = Enum.Font.GothamBold
tpNow.TextScaled = true
tpNow.Text = "⚡ ТП к мобу"
tpNow.BorderSizePixel = 0
tpNow.Parent = tpPage
Instance.new("UICorner", tpNow).CornerRadius = UDim.new(0, 12)

local doTp = function()
    local lvl = getLevel()
    local q = getQuestForLevel(lvl)
    local mob = findMobByName(q.mob)
    if mob then tpToMob(mob)
    else tpToPos(q.pos) end
end
tpNow.MouseButton1Click:Connect(doTp)
tpNow.TouchTap:Connect(doTp)

local tpZone = Instance.new("TextButton")
tpZone.Size = UDim2.new(1, 0, 0, 56)
tpZone.Position = UDim2.new(0, 0, 0, 108)
tpZone.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
tpZone.TextColor3 = Color3.new(1,1,1)
tpZone.Font = Enum.Font.GothamBold
tpZone.TextScaled = true
tpZone.Text = "🗺️ ТП в зону квеста"
tpZone.BorderSizePixel = 0
tpZone.Parent = tpPage
Instance.new("UICorner", tpZone).CornerRadius = UDim.new(0, 12)

tpZone.MouseButton1Click:Connect(function()
    local lvl = getLevel()
    local q = getQuestForLevel(lvl)
    tpToPos(q.pos)
end)
tpZone.TouchTap:Connect(function()
    local lvl = getLevel()
    local q = getQuestForLevel(lvl)
    tpToPos(q.pos)
end)

-- Активировать таб Farm по умолчанию
switchTab("Farm")

print("[luna.master v2.0] Загружен ✅")
