-- GGHub Ultra Premium Pack (Draggable Edition)
-- Owner: tumy7287
-- Fully Supports Dragging on PC & Mobile

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Створення інтерфейсу
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGHub_Ultimate_Draggable"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

_G.SpeedValue = 16
_G.FlyEnabled = false
_G.AuraEnabled = false
_G.EspEnabled = false
_G.UI_Color = Color3.fromRGB(0, 255, 170)

-- УНІВЕРСАЛЬНА ФУНКЦІЯ ДЛЯ ПЕРЕТЯГУВАННЯ (Працює ідеально на ПК та Смартфонах)
local function makeDraggable(frame, dragHandle)
    local slot = dragHandle or frame
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    slot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    slot.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- МАЛЕНЬКЕ МЕНЮ (GGHub Кнопка-Активатор)
local MiniMenu = Instance.new("TextButton")
MiniMenu.Size = UDim2.new(0, 90, 0, 40)
MiniMenu.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MiniMenu.TextColor3 = _G.UI_Color
MiniMenu.Text = "⚡ GGHub"
MiniMenu.Font = Enum.Font.SourceSansBold
MiniMenu.TextSize = 16
MiniMenu.Parent = ScreenGui
Instance.new("UICorner", MiniMenu).CornerRadius = UDim.new(0, 8)
makeDraggable(MiniMenu) -- Робимо кнопку рухомою!

-- ГОЛОВНЕ МЕНЮ
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 480, 0, 320)
MainMenu.Position = UDim2.new(0.5, -240, 0.5, -160)
MainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Parent = ScreenGui
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

-- Заголовок меню (За нього можна тягнути меню)
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.TextColor3 = Color3.fromRGB(255, 215, 0)
Header.Text = "👑 OWNER: tumy7287 | GGHub Premium"
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 15
Header.Active = true
Header.Parent = MainMenu
makeDraggable(MainMenu, Header) -- Робимо велике меню рухомим за верхню панель!

-- Контент функцій
local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.new(0, 10, 0, 45)
Content.Size = UDim2.new(1, -20, 1, -55)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Content.ScrollBarThickness = 4
Content.Parent = MainMenu

-- Контейнер мобільних кнопок (Стрілочки польоту)
local MobileControlsFrame = Instance.new("Frame")
MobileControlsFrame.Size = UDim2.new(0, 150, 0, 150)
MobileControlsFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
MobileControlsFrame.BackgroundTransparency = 0.8
MobileControlsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MobileControlsFrame.Visible = false
MobileControlsFrame.Active = true
MobileControlsFrame.Parent = ScreenGui
Instance.new("UICorner", MobileControlsFrame).CornerRadius = UDim.new(0, 10)
makeDraggable(MobileControlsFrame) -- Можна рухати навіть панель зі стрілочками!

-- Мобільні кнопки керування
local function createMobileButton(text, pos, callback)
    local mBtn = Instance.new("TextButton")
    mBtn.Size = UDim2.new(0, 45, 0, 45)
    mBtn.Position = pos
    mBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mBtn.TextColor3 = _G.UI_Color
    mBtn.Text = text
    mBtn.Font = Enum.Font.SourceSansBold
    mBtn.TextSize = 18
    mBtn.Parent = MobileControlsFrame
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 8)
    mBtn.MouseButton1Down:Connect(callback)
    return mBtn
end

createMobileButton("▲", UDim2.new(0.35, 0, 0.05, 0), function()
    if _G.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
    end
end)
createMobileButton("▼", UDim2.new(0.35, 0, 0.55, 0), function()
    if _G.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -6, 0)
    end
end)

-- Додавання функцій у меню
local function addCheatFunction(name, keyText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = Content
    
    local uiList = Content:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", Content)
    uiList.Padding = UDim.new(0, 5)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [OFF]"
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 150, 1, 0)
    infoLabel.Position = UDim2.new(0, 260, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoLabel.Text = "Клавіша ПК: " .. keyText
    infoLabel.Font = Enum.Font.SourceSansItalic
    infoLabel.TextSize = 13
    infoLabel.Parent = frame

    local state = defaultState
    local function toggle()
        state = not state
        btn.TextColor3 = state and _G.UI_Color or Color3.fromRGB(255, 255, 255)
        btn.Text = name .. (state and " [УВІМКНЕНО]" or " [ВИМКНЕНО]")
        callback(state)
    end

    btn.MouseButton1Click:Connect(toggle)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[keyText] then toggle() end
    end)
end

-- Логіка функцій
addCheatFunction("Швидкий біг (Speedhack)", "X", false, function(state)
    _G.SpeedValue = state and 65 or 16
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
    end
end)

addCheatFunction("Політ (Fly Mode)", "F", false, function(state)
    _G.FlyEnabled = state
    MobileControlsFrame.Visible = state
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if _G.FlyEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "GGHub_Velocity"
        bv.MaxForce = Vector3.new(1, 1, 1) * 9e9
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        
        task.spawn(function()
            while _G.FlyEnabled and char:FindFirstChild("HumanoidRootPart") do
                local cam = Workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                bv.Velocity = dir * 60
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        if hrp:FindFirstChild("GGHub_Velocity") then hrp.GGHub_Velocity:Destroy() end
    end
end)

addCheatFunction("Райдужна Аура (Visual)", "Z", false, function(state)
    _G.AuraEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if _G.AuraEnabled then
        local p = Instance.new("ParticleEmitter")
        p.Name = "GGHub_Aura"
        p.Texture = "rbxassetid://241793716"
        p.Size = NumberSequence.new(1.5)
        p.Rate = 45
        p.Speed = NumberRange.new(2, 4)
        p.Parent = char.HumanoidRootPart
        
        task.spawn(function()
            local hue = 0
            while _G.AuraEnabled and p.Parent do
                hue = (hue + 1) % 360
                p.Color = ColorSequence.new(Color3.fromHSV(hue/360, 1, 1))
                task.wait(0.05)
            end
            if p then p:Destroy() end
        end)
    else
        if char.HumanoidRootPart:FindFirstChild("GGHub_Aura") then char.HumanoidRootPart.GGHub_Aura:Destroy() end
    end
end)

addCheatFunction("Бачення гравців (ESP)", "E", false, function(state)
    _G.EspEnabled = state
    if not _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
    end
end)

