-- GGHub Premium (Optimized for Solar V3)
-- Owner / Owner Status: tumy7287
-- Fully compatible with Solar execution environment

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Створення інтерфейсу всередині PlayerGui для повної сумісності з Solar V3
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGHub_SolarEdition"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

_G.SpeedValue = 16
_G.FlyEnabled = false
_G.EspEnabled = false
_G.UI_Color = Color3.fromRGB(0, 255, 170) -- Наш фірмовий неоновий колір

-- МАЛЕНЬКЕ МЕНЮ (Кнопка запуску)
local MiniMenu = Instance.new("TextButton")
MiniMenu.Size = UDim2.new(0, 100, 0, 45)
MiniMenu.Position = UDim2.new(0.1, 0, 0.2, 0)
MiniMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MiniMenu.TextColor3 = _G.UI_Color
MiniMenu.Text = "⚡ GGHub"
MiniMenu.Font = Enum.Font.SourceSansBold
MiniMenu.TextSize = 18
MiniMenu.Active = true
MiniMenu.Draggable = true -- Вбудоване перетягування, яке Solar чудово обробляє
MiniMenu.Parent = ScreenGui
Instance.new("UICorner", MiniMenu).CornerRadius = UDim.new(0, 8)

-- ГОЛОВНЕ МЕНЮ
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 360, 0, 260)
MainMenu.Position = UDim2.new(0.5, -180, 0.5, -130)
MainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Parent = ScreenGui
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

-- Заголовок з твоїм ніком
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золотий статус овнера
Header.Text = "👑 OWNER: tumy7287 | GGHub"
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.Parent = MainMenu

-- Контейнер для кнопок функцій
local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 15, 0, 55)
Content.Size = UDim2.new(1, -30, 1, -70)
Content.BackgroundTransparency = 1
Content.Parent = MainMenu

local uiList = Instance.new("UIListLayout", Content)
uiList.Padding = UDim.new(0, 10)

-- Конструктор кнопок для Solar V3
local function createFeatureToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [OFF]"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and _G.UI_Color or Color3.fromRGB(255, 255, 255)
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- ==================== НАЛАШТУВАННЯ ЧІТІВ ====================

-- 1. Спідхак (Працює через постійний цикл Heartbeat)
createFeatureToggle("Швидкість бігу (Speedhack)", function(state)
    _G.SpeedValue = state and 75 or 16
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
    end
end)

-- 2. Стабільний Політ (Fly) для телефонів
createFeatureToggle("Політ (Fly Mode)", function(state)
    _G.FlyEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if _G.FlyEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "Solar_FlyVelocity"
        bv.MaxForce = Vector3.new(1, 1, 1) * 9e9
        bv.Velocity = Vector3.new(0, 25, 0) -- Плавний підйом вгору, щоб не кікав античіт Ohio
        bv.Parent = hrp
    else
        if hrp:FindFirstChild("Solar_FlyVelocity") then hrp.Solar_FlyVelocity:Destroy() end
    end
end)

-- 3. ESP (Бачення крізь стіни за допомогою Highlight)
createFeatureToggle("Бачення гравців (ESP)", function(state)
    _G.EspEnabled = state
    if not _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Solar_Highlight") then 
                p.Character.Solar_Highlight:Destroy() 
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Solar_Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "Solar_Highlight"
                hl.FillColor = _G.UI_Color
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.Parent = p.Character
            end
        end
    end
end)

-- Логіка відкриття/закриття інтерфейсу
MiniMenu.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)
