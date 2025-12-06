-- LocalScript в StarterPlayerScripts
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ========== КОНФИГУРАЦИЯ ==========
local CONFIG = {
    AddToExplorerKey = Enum.KeyCode.R,      -- Добавить объект в Explorer
    ExplorerKey = Enum.KeyCode.T,           -- Открыть/закрыть Explorer
    ClearExplorerKey = Enum.KeyCode.Y,      -- Очистить все объекты
    NextObjectKey = Enum.KeyCode.RightBracket,  -- Следующий объект
    PrevObjectKey = Enum.KeyCode.LeftBracket,   -- Предыдущий объект
    ExplorerWidth = 400,
    MaxObjects = 20,                        -- Макс объектов в Explorer
    HighlightColor = Color3.new(0, 1, 0),
    SelectedColor = Color3.fromRGB(255, 100, 100),
}

-- ========== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ==========
local explorerGUI
local selectedObjects = {}                  -- Все выбранные объекты
local currentObjectIndex = 1                -- Текущий объект в просмотре
local objectMarkers = {}                    -- Маркеры для выбранных объектов
local isExplorerOpen = false

-- ========== СОЗДАНИЕ EXPLORER СО СПИСКОМ ОБЪЕКТОВ ==========
local function createMultiObjectExplorer()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MultiObjectExplorerGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Основной контейнер
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ExplorerPanel"
    mainFrame.Size = UDim2.new(0, CONFIG.ExplorerWidth, 1, -40)
    mainFrame.Position = UDim2.new(0, 10, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Заголовок с количеством объектов
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Name = "TitleLabel"
    title.Text = "📁 MULTI-OBJECT EXPLORER (0)"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Parent = titleBar
    
    -- Панель списка объектов
    local objectsListFrame = Instance.new("Frame")
    objectsListFrame.Name = "ObjectsList"
    objectsListFrame.Size = UDim2.new(1, -20, 0, 200)
    objectsListFrame.Position = UDim2.new(0, 10, 0, 50)
    objectsListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    objectsListFrame.BorderSizePixel = 1
    objectsListFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
    objectsListFrame.Parent = mainFrame
    
    local listTitle = Instance.new("TextLabel")
    listTitle.Text = "📋 ВЫБРАННЫЕ ОБЪЕКТЫ"
    listTitle.Size = UDim2.new(1, 0, 0, 25)
    listTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    listTitle.TextColor3 = Color3.new(1, 1, 1)
    listTitle.Font = Enum.Font.SourceSansSemibold
    listTitle.Parent = objectsListFrame
    
    local objectsScroll = Instance.new("ScrollingFrame")
    objectsScroll.Name = "ObjectsScroll"
    objectsScroll.Size = UDim2.new(1, -10, 1, -35)
    objectsScroll.Position = UDim2.new(0, 5, 0, 30)
    objectsScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    objectsScroll.ScrollBarThickness = 8
    objectsScroll.Parent = objectsListFrame
    
    local objectsLayout = Instance.new("UIListLayout")
    objectsLayout.Padding = UDim.new(0, 3)
    objectsLayout.Parent = objectsScroll
    
    -- Информация о текущем объекте
    local currentInfoFrame = Instance.new("Frame")
    currentInfoFrame.Name = "CurrentObjectInfo"
    currentInfoFrame.Size = UDim2.new(1, -20, 0, 180)
    currentInfoFrame.Position = UDim2.new(0, 10, 0, 260)
    currentInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    currentInfoFrame.BorderSizePixel = 1
    currentInfoFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
    currentInfoFrame.Parent = mainFrame
    
    local currentTitle = Instance.new("TextLabel")
    currentTitle.Name = "CurrentTitle"
    currentTitle.Text = "🎯 ТЕКУЩИЙ ОБЪЕКТ: 0/0"
    currentTitle.Size = UDim2.new(1, 0, 0, 25)
    currentTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    currentTitle.TextColor3 = Color3.new(1, 1, 1)
    currentTitle.Font = Enum.Font.SourceSansSemibold
    currentTitle.Parent = currentInfoFrame
    
    local objNameLabel = Instance.new("TextLabel")
    objNameLabel.Name = "ObjectName"
    objNameLabel.Text = "📛 Имя: -"
    objNameLabel.Size = UDim2.new(1, -10, 0, 20)
    objNameLabel.Position = UDim2.new(0, 5, 0, 30)
    objNameLabel.BackgroundTransparency = 1
    objNameLabel.TextColor3 = Color3.new(1, 1, 1)
    objNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    objNameLabel.Parent = currentInfoFrame
    
    local objClassLabel = Instance.new("TextLabel")
    objClassLabel.Name = "ObjectClass"
    objClassLabel.Text = "🏷️ Класс: -"
    objClassLabel.Size = UDim2.new(1, -10, 0, 20)
    objClassLabel.Position = UDim2.new(0, 5, 0, 50)
    objClassLabel.BackgroundTransparency = 1
    objClassLabel.TextColor3 = Color3.new(1, 1, 1)
    objClassLabel.TextXAlignment = Enum.TextXAlignment.Left
    objClassLabel.Parent = currentInfoFrame
    
    local objPosLabel = Instance.new("TextLabel")
    objPosLabel.Name = "ObjectPosition"
    objPosLabel.Text = "📍 Позиция: -"
    objPosLabel.Size = UDim2.new(1, -10, 0, 40)
    objPosLabel.Position = UDim2.new(0, 5, 0, 75)
    objPosLabel.BackgroundTransparency = 1
    objPosLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    objPosLabel.TextXAlignment = Enum.TextXAlignment.Left
    objPosLabel.TextWrapped = true
    objPosLabel.Parent = currentInfoFrame
    
    local objPathLabel = Instance.new("TextLabel")
    objPathLabel.Name = "ObjectPath"
    objPathLabel.Text = "📁 Путь: -"
    objPathLabel.Size = UDim2.new(1, -10, 0, 50)
    objPathLabel.Position = UDim2.new(0, 5, 0, 120)
    objPathLabel.BackgroundTransparency = 1
    objPathLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    objPathLabel.TextXAlignment = Enum.TextXAlignment.Left
    objPathLabel.TextWrapped = true
    objPathLabel.Parent = currentInfoFrame
    
    -- Кнопки навигации
    local navFrame = Instance.new("Frame")
    navFrame.Name = "NavigationPanel"
    navFrame.Size = UDim2.new(1, -20, 0, 40)
    navFrame.Position = UDim2.new(0, 10, 0, 450)
    navFrame.BackgroundTransparency = 1
    navFrame.Parent = mainFrame
    
    local btnPrev = Instance.new("TextButton")
    btnPrev.Text = "◀ Предыдущий"
    btnPrev.Size = UDim2.new(0.48, 0, 1, 0)
    btnPrev.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
    btnPrev.TextColor3 = Color3.new(1, 1, 1)
    btnPrev.Parent = navFrame
    
    local btnNext = Instance.new("TextButton")
    btnNext.Text = "Следующий ▶"
    btnNext.Size = UDim2.new(0.48, 0, 1, 0)
    btnNext.Position = UDim2.new(0.52, 0, 0, 0)
    btnNext.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
    btnNext.TextColor3 = Color3.new(1, 1, 1)
    btnNext.Parent = navFrame
    
    -- Кнопки действий
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Name = "ActionsPanel"
    actionsFrame.Size = UDim2.new(1, -20, 0, 80)
    actionsFrame.Position = UDim2.new(0, 10, 1, -90)
    actionsFrame.BackgroundTransparency = 1
    actionsFrame.Parent = mainFrame
    
    local btnTeleport = Instance.new("TextButton")
    btnTeleport.Text = "🚀 Телепорт к объекту"
    btnTeleport.Size = UDim2.new(1, 0, 0, 35)
    btnTeleport.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    btnTeleport.TextColor3 = Color3.new(1, 1, 1)
    btnTeleport.Parent = actionsFrame
    
    local btnRemove = Instance.new("TextButton")
    btnRemove.Text = "🗑️ Удалить из списка"
    btnRemove.Size = UDim2.new(1, 0, 0, 35)
    btnRemove.Position = UDim2.new(0, 0, 0, 40)
    btnRemove.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    btnRemove.TextColor3 = Color3.new(1, 1, 1)
    btnRemove.Parent = actionsFrame
    
    -- Мини-инфо
    local miniInfo = Instance.new("Frame")
    miniInfo.Name = "MiniInfo"
    miniInfo.Size = UDim2.new(0, 350, 0, 120)
    miniInfo.Position = UDim2.new(1, -360, 1, -130)
    miniInfo.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    miniInfo.BackgroundTransparency = 0.3
    miniInfo.BorderSizePixel = 1
    miniInfo.BorderColor3 = Color3.fromRGB(80, 80, 100)
    miniInfo.Visible = true
    miniInfo.Parent = screenGui
    
    local miniTitle = Instance.new("TextLabel")
    miniTitle.Text = "🎯 ВЫБРАННЫХ ОБЪЕКТОВ: 0"
    miniTitle.Name = "MiniTitle"
    miniTitle.Size = UDim2.new(1, 0, 0, 25)
    miniTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    miniTitle.TextColor3 = Color3.new(1, 1, 1)
    miniTitle.Font = Enum.Font.SourceSansSemibold
    miniTitle.Parent = miniInfo
    
    local miniCurrentLabel = Instance.new("TextLabel")
    miniCurrentLabel.Name = "MiniCurrent"
    miniCurrentLabel.Text = "Текущий: -"
    miniCurrentLabel.Size = UDim2.new(1, -10, 0, 25)
    miniCurrentLabel.Position = UDim2.new(0, 5, 0, 30)
    miniCurrentLabel.BackgroundTransparency = 1
    miniCurrentLabel.TextColor3 = Color3.new(1, 1, 1)
    miniCurrentLabel.TextXAlignment = Enum.TextXAlignment.Left
    miniCurrentLabel.Parent = miniInfo
    
    local miniPosLabel = Instance.new("TextLabel")
    miniPosLabel.Name = "MiniPosition"
    miniPosLabel.Text = "Позиция: --"
    miniPosLabel.Size = UDim2.new(1, -10, 0, 30)
    miniPosLabel.Position = UDim2.new(0, 5, 0, 55)
    miniPosLabel.BackgroundTransparency = 1
    miniPosLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    miniPosLabel.TextXAlignment = Enum.TextXAlignment.Left
    miniPosLabel.TextSize = 12
    miniPosLabel.TextWrapped = true
    miniPosLabel.Parent = miniInfo
    
    local miniHint = Instance.new("TextLabel")
    miniHint.Text = "R - добавить объект | T - Explorer | Y - очистить"
    miniHint.Size = UDim2.new(1, -10, 0, 20)
    miniHint.Position = UDim2.new(0, 5, 0, 95)
    miniHint.BackgroundTransparency = 1
    miniHint.TextColor3 = Color3.fromRGB(180, 180, 255)
    miniHint.TextXAlignment = Enum.TextXAlignment.Left
    miniHint.TextSize = 11
    miniHint.Parent = miniInfo
    
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        CloseBtn = closeBtn,
        TitleLabel = title,
        ObjectsScroll = objectsScroll,
        CurrentTitle = currentTitle,
        ObjectName = objNameLabel,
        ObjectClass = objClassLabel,
        ObjectPosition = objPosLabel,
        ObjectPath = objPathLabel,
        BtnPrev = btnPrev,
        BtnNext = btnNext,
        BtnTeleport = btnTeleport,
        BtnRemove = btnRemove,
        MiniInfo = miniInfo,
        MiniTitle = miniTitle,
        MiniCurrent = miniCurrentLabel,
        MiniPosition = miniPosLabel,
        MiniHint = miniHint
    }
end

-- ========== ДОБАВИТЬ ОБЪЕКТ В EXPLORER ==========
local function addObjectToExplorer(object)
    if not object then return false end
    
    -- Проверяем, не добавлен ли уже
    for i, obj in ipairs(selectedObjects) do
        if obj == object then
            print("⚠️ Объект уже в списке!")
            currentObjectIndex = i
            updateExplorerDisplay()
            return false
        end
    end
    
    -- Проверяем лимит
    if #selectedObjects >= CONFIG.MaxObjects then
        print("❌ Достигнут лимит объектов (" .. CONFIG.MaxObjects .. ")")
        return false
    end
    
    -- Добавляем объект
    table.insert(selectedObjects, object)
    currentObjectIndex = #selectedObjects
    
    -- Создаем маркер для объекта
    createObjectMarker(object, #selectedObjects)
    
    print("✅ Добавлен объект: " .. object.Name .. " (" .. #selectedObjects .. "/" .. CONFIG.MaxObjects .. ")")
    
    -- Обновляем отображение
    updateExplorerDisplay()
    
    return true
end

-- ========== СОЗДАТЬ МАРКЕР ДЛЯ ОБЪЕКТА ==========
local function createObjectMarker(object, index)
    local posData = getObjectPosition(object)
    if not posData then return nil end
    
    local position = posData.Position
    
    -- Создаем маркер с номером
    local marker = Instance.new("Part")
    marker.Name = "ExplorerMarker_" .. object.Name
    marker.Size = Vector3.new(2, 2, 2)
    marker.Position = position + Vector3.new(0, 5, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 0.4
    
    -- Цвет в зависимости от индекса
    local colors = {
        BrickColor.new("Bright red"),
        BrickColor.new("Bright blue"),
        BrickColor.new("Bright green"),
        BrickColor.new("Bright yellow"),
        BrickColor.new("Bright violet"),
        BrickColor.new("Bright orange"),
    }
    
    local colorIndex = ((index - 1) % #colors) + 1
    marker.BrickColor = colors[colorIndex]
    marker.Material = Enum.Material.Neon
    marker.Shape = Enum.PartType.Ball
    marker.Parent = workspace
    
    -- Номер объекта
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.Adornee = marker
    billboard.AlwaysOnTop = true
    billboard.Parent = marker
    
    local numberLabel = Instance.new("TextLabel")
    numberLabel.Text = tostring(index)
    numberLabel.Size = UDim2.new(1, 0, 1, 0)
    numberLabel.BackgroundTransparency = 1
    numberLabel.TextColor3 = Color3.new(1, 1, 1)
    numberLabel.TextScaled = true
    numberLabel.Font = Enum.Font.SourceSansBold
    numberLabel.Parent = billboard
    
    objectMarkers[object] = marker
    
    return marker
end

-- ========== УДАЛИТЬ ОБЪЕКТ ИЗ EXPLORER ==========
local function removeObjectFromExplorer(index)
    if index < 1 or index > #selectedObjects then return false end
    
    local object = selectedObjects[index]
    
    -- Удаляем маркер
    if objectMarkers[object] then
        objectMarkers[object]:Destroy()
        objectMarkers[object] = nil
    end
    
    -- Удаляем из списка
    table.remove(selectedObjects, index)
    
    -- Корректируем текущий индекс
    if currentObjectIndex > #selectedObjects then
        currentObjectIndex = math.max(1, #selectedObjects)
    end
    
    -- Обновляем номера маркеров
    for i, obj in ipairs(selectedObjects) do
        if objectMarkers[obj] then
            objectMarkers[obj]:Destroy()
            createObjectMarker(obj, i)
        end
    end
    
    print("🗑️ Удален объект из списка. Осталось: " .. #selectedObjects)
    
    updateExplorerDisplay()
    return true
end

-- ========== ПОЛУЧИТЬ ПОЗИЦИЮ ОБЪЕКТА ==========
local function getObjectPosition(object)
    if not object then return nil end
    
    if object:IsA("BasePart") then
        return {
            Position = object.Position,
            Size = object.Size,
            Rotation = object.Orientation
        }
    elseif object:IsA("Model") then
        local pivot = object:GetPivot()
        return {
            Position = pivot.Position,
            Size = object:GetExtentsSize(),
            Rotation = pivot.Rotation
        }
    end
    
    return nil
end

-- ========== ПОЛУЧИТЬ ПУТЬ ОБЪЕКТА ==========
local function getObjectPath(object)
    if not object then return "Неизвестно" end
    
    local pathParts = {}
    local current = object
    
    while current and current ~= game do
        table.insert(pathParts, 1, current.Name)
        current = current.Parent
    end
    
    return table.concat(pathParts, " → ")
end

-- ========== ОБНОВИТЬ ОТОБРАЖЕНИЕ EXPLORER ==========
local function updateExplorerDisplay()
    if not explorerGUI then return end
    
    -- Обновляем заголовок
    local count = #selectedObjects
    explorerGUI.TitleLabel.Text = "📁 MULTI-OBJECT EXPLORER (" .. count .. ")"
    explorerGUI.MiniTitle.Text = "🎯 ВЫБРАННЫХ ОБЪЕКТОВ: " .. count
    
    -- Очищаем список
    for _, child in ipairs(explorerGUI.ObjectsScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Заполняем список объектов
    for i, object in ipairs(selectedObjects) do
        local isCurrent = (i == currentObjectIndex)
        
        local itemButton = Instance.new("TextButton")
        itemButton.Name = "ObjectItem_" .. i
        itemButton.Text = "#" .. i .. "   " .. object.Name .. " (" .. object.ClassName .. ")"
        itemButton.Size = UDim2.new(1, 0, 0, 35)
        itemButton.BackgroundColor3 = isCurrent and CONFIG.SelectedColor or Color3.fromRGB(50, 50, 70)
        itemButton.TextColor3 = Color3.new(1, 1, 1)
        itemButton.TextXAlignment = Enum.TextXAlignment.Left
        itemButton.Parent = explorerGUI.ObjectsScroll
        
        -- Клик - выбираем этот объект
        itemButton.MouseButton1Click:Connect(function()
            currentObjectIndex = i
            updateExplorerDisplay()
        end)
        
        -- Правый клик - удаляем
        itemButton.MouseButton2Click:Connect(function()
            removeObjectFromExplorer(i)
        end)
    end
    
    -- Обновляем текущий объект
    if count > 0 and currentObjectIndex >= 1 and currentObjectIndex <= count then
        local currentObject = selectedObjects[currentObjectIndex]
        local posData = getObjectPosition(currentObject)
        
        explorerGUI.CurrentTitle.Text = "🎯 ТЕКУЩИЙ ОБЪЕКТ: " .. currentObjectIndex .. "/" .. count
        explorerGUI.ObjectName.Text = "📛 Имя: " .. currentObject.Name
        explorerGUI.ObjectClass.Text = "🏷️ Класс: " .. currentObject.ClassName
        explorerGUI.ObjectPath.Text = "📁 Путь: " .. getObjectPath(currentObject)
        
        if posData then
            local pos = posData.Position
            explorerGUI.ObjectPosition.Text = string.format("📍 X: %.2f  Y: %.2f  Z: %.2f", 
                pos.X, pos.Y, pos.Z)
            
            -- Мини-инфо
            explorerGUI.MiniCurrent.Text = "Текущий: #" .. currentObjectIndex .. " - " .. currentObject.Name
            explorerGUI.MiniPosition.Text = string.format("X:%.1f Y:%.1f Z:%.1f", pos.X, pos.Y, pos.Z)
        else
            explorerGUI.ObjectPosition.Text = "📍 Позиция недоступна"
            explorerGUI.MiniCurrent.Text = "Текущий: #" .. currentObjectIndex .. " - " .. currentObject.Name
            explorerGUI.MiniPosition.Text = "Позиция: --"
        end
        
        -- Подсвечиваем текущий объект
        highlightCurrentObject(currentObject)
    else
        explorerGUI.CurrentTitle.Text = "🎯 ТЕКУЩИЙ ОБЪЕКТ: 0/0"
        explorerGUI.ObjectName.Text = "📛 Имя: -"
        explorerGUI.ObjectClass.Text = "🏷️ Класс: -"
        explorerGUI.ObjectPosition.Text = "📍 Позиция: -"
        explorerGUI.ObjectPath.Text = "📁 Путь: -"
        
        explorerGUI.MiniCurrent.Text = "Текущий: -"
        explorerGUI.MiniPosition.Text = "Позиция: --"
    end
    
    -- Обновляем размер скролла
    task.wait()
    explorerGUI.ObjectsScroll.CanvasSize = UDim2.new(0, 0, 0, 
        explorerGUI.ObjectsScroll.UIListLayout.AbsoluteContentSize.Y)
end

-- ========== ПОДСВЕТИТЬ ТЕКУЩИЙ ОБЪЕКТ ==========
local function highlightCurrentObject(object)
    -- Убираем старую подсветку
    for _, obj in ipairs(selectedObjects) do
        if obj ~= object and obj:FindFirstChild("CurrentHighlight") then
            obj.CurrentHighlight:Destroy()
        end
    end
    
    -- Создаем подсветку для текущего объекта
    if object and not object:FindFirstChild("CurrentHighlight") then
        local highlight = Instance.new("SelectionBox")
        highlight.Name = "CurrentHighlight"
        highlight.Adornee = object
        highlight.Color3 = CONFIG.HighlightColor
        highlight.LineThickness = 0.15
        highlight.Transparency = 0.3
        highlight.Parent = object
    end
end

-- ========== ПЕРЕЙТИ К СЛЕДУЮЩЕМУ ОБЪЕКТУ ==========
local function goToNextObject()
    if #selectedObjects == 0 then return end
    
    currentObjectIndex = currentObjectIndex + 1
    if currentObjectIndex > #selectedObjects then
        currentObjectIndex = 1
    end
    
    updateExplorerDisplay()
    print("➡️ Перешел к объекту #" .. currentObjectIndex)
end

-- ========== ПЕРЕЙТИ К ПРЕДЫДУЩЕМУ ОБЪЕКТУ ==========
local function goToPrevObject()
    if #selectedObjects == 0 then return end
    
    currentObjectIndex = currentObjectIndex - 1
    if currentObjectIndex < 1 then
        currentObjectIndex = #selectedObjects
    end
    
    updateExplorerDisplay()
    print("⬅️ Перешел к объекту #" .. currentObjectIndex)
end

-- ========== ТЕЛЕПОРТ К ТЕКУЩЕМУ ОБЪЕКТУ ==========
local function teleportToCurrentObject()
    if #selectedObjects == 0 then return end
    
    local object = selectedObjects[currentObjectIndex]
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local posData = getObjectPosition(object)
    if not posData then return end
    
    local position = posData.Position + Vector3.new(0, 5, 5)
    
    local tween = TweenService:Create(humanoidRootPart,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {CFrame = CFrame.new(position)}
    )
    tween:Play()
    
    print("🚀 Телепорт к объекту #" .. currentObjectIndex .. ": " .. object.Name)
end

-- ========== ОЧИСТИТЬ ВСЕ ОБЪЕКТЫ ==========
local function clearAllObjects()
    -- Удаляем все маркеры
    for object, marker in pairs(objectMarkers) do
        if marker then
            marker:Destroy()
        end
    end
    
    objectMarkers = {}
    selectedObjects = {}
    currentObjectIndex = 1
    
    -- Убираем подсветки
    for _, obj in pairs(game:GetDescendants()) do
        if obj:FindFirstChild("CurrentHighlight") then
            obj.CurrentHighlight:Destroy()
        end
    end
    
    print("🧹 Все объекты удалены из Explorer")
    updateExplorerDisplay()
end

-- ========== ПОДСВЕТКА ПРИ НАВЕДЕНИИ ==========
local lastTarget = nil
RunService.Heartbeat:Connect(function()
    local target = mouse.Target
    
    if target ~= lastTarget then
        -- Удаляем старую подсветку наведения
        if lastTarget and lastTarget:FindFirstChild("HoverHighlight") then
            lastTarget.HoverHighlight:Destroy()
        end
        
        lastTarget = target
        
        -- Создаем подсветку наведения
        if target then
            local highlight = Instance.new("SelectionBox")
            highlight.Name = "HoverHighlight"
            highlight.Adornee = target
            highlight.Color3 = Color3.new(1, 0.5, 0) -- Оранжевый
            highlight.LineThickness = 0.05
            highlight.Transparency = 0.7
            highlight.Parent = target
        end
    end
end)

-- ========== ИНИЦИАЛИЗАЦИЯ ==========
explorerGUI = createMultiObjectExplorer()

-- Обработчики кнопок
explorerGUI.CloseBtn.MouseButton1Click:Connect(function()
    explorerGUI.MainFrame.Visible = false
    isExplorerOpen = false
end)

explorerGUI.BtnPrev.MouseButton1Click:Connect(goToPrevObject)
explorerGUI.BtnNext.MouseButton1Click:Connect(goToNextObject)
explorerGUI.BtnTeleport.MouseButton1Click:Connect(teleportToCurrentObject)

explorerGUI.BtnRemove.MouseButton1Click:Connect(function()
    if #selectedObjects > 0 then
        removeObjectFromExplorer(currentObjectIndex)
    end
end)

-- ========== ОБРАБОТКА КЛАВИШ ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- R - Добавить объект под курсором в Explorer
    if input.KeyCode == CONFIG.AddToExplorerKey then
        local target = mouse.Target
        if target then
            addObjectToExplorer(target)
            
            -- Автоматически открываем Explorer если он закрыт
            if not isExplorerOpen then
                explorerGUI.MainFrame.Visible = true
                isExplorerOpen = true
            end
        end
    end
    
    -- T - Открыть/закрыть Explorer
    if input.KeyCode == CONFIG.ExplorerKey then
        isExplorerOpen = not isExplorerOpen
        explorerGUI.MainFrame.Visible = isExplorerOpen
        
        if isExplorerOpen then
            updateExplorerDisplay()
        end
    end
    
    -- Y - Очистить все объекты
    if input.KeyCode == CONFIG.ClearExplorerKey then
        clearAllObjects()
    end
    
    -- [ - Предыдущий объект
    if input.KeyCode == CONFIG.PrevObjectKey then
        goToPrevObject()
    end
    
    -- ] - Следующий объект
    if input.KeyCode == CONFIG.NextObjectKey then
        goToNextObject()
    end
    
    -- Ctrl+R - Быстро добавить несколько объектов подряд
    if input.KeyCode == CONFIG.AddToExplorerKey and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local target = mouse.Target
        if target then
            -- Добавляем объект и всех его детей
            local added = 0
            local function addChildren(parent)
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("BasePart") or child:IsA("Model") then
                        if addObjectToExplorer(child) then
                            added = added + 1
                        end
                    end
                    addChildren(child)
                end
            end
            
            addObjectToExplorer(target)
            addChildren(target)
            
            print("📦 Добавлено " .. added .. " дочерних объектов")
        end
    end
end)

-- ========== ИНФОРМАЦИЯ ДЛЯ ПОЛЬЗОВАТЕЛЯ ==========
print("🎮 MULTI-OBJECT EXPLORER АКТИВИРОВАН!")
print("========================================")
print("   R - Добавить объект под курсором в Explorer")
print("   T - Открыть/закрыть Explorer")
print("   Y - Очистить все объекты")
print("   [ - Предыдущий объект")
print("   ] - Следующий объект")
print("   Ctrl+R - Добавить объект и всех его детей")
print("========================================")
print("В Explorer:")
print("  • Все выбранные объекты в одном списке")
print("  • Цветные маркеры с номерами в мире")
print("  • Легкое переключение между объектами")
print("  • Телепорт к любому объекту")
print("  • Удаление объектов из списка")
print("========================================")
