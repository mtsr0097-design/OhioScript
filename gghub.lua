-- GGHub PC Master Edition (Optimized for Solar on PC/Emulator)
-- Owner: tumy7287
-- Premium Desktop Interface with Keyboard Keybinds

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Очищення старих копій скрипта
if CoreGui:FindFirstChild("GGHub_PC_Edition") then CoreGui.GGHub_PC_Edition:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild("GGHub_PC_Edition") then LocalPlayer.PlayerGui.GGHub_PC_Edition:Destroy() end

-- Створення GUI з автоматичним вибором безпечного контейнера
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGHub_PC_Edition"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Глобальні змінні
_G.SpeedValue = 16
_G.FlyEnabled = false
_G.EspEnabled = false
_G.InfJump = false
_G.UI_Color = Color3.fromRGB(0, 255, 170)

-- ГОЛОВНЕ ПК-МЕНЮ
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 400, 0, 280)
MainMenu.Position = UDim2.new(0.5, -200, 0.5, -140)
MainMenu.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainMenu.Active = true
MainMenu.Draggable = true -- Ідеально працює з мишкою на ПК
MainMenu.Parent = ScreenGui
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 10)

-- Верхня панель (Заголовок)
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Header.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золотий нікнейм Власника
Header.Text = "👑 OWNER: tumy7287 | GGHub Premium PC"
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.Parent = MainMenu

-- Текст-підказка внизу меню
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Footer.TextColor3 = Color3.fromRGB(130, 130, 130)
Footer.Text = "[Натисни клавішу INSERT або RSHIFT, щоб сховати/відкрити меню]"
Footer.Font = Enum.Font.SourceSansItalic
Footer.TextSize = 12
Footer.Parent = MainMenu

-- Контейнер для списку функцій
local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 15, 0, 50)
Content.Size = UDim2.new(1, -30, 1, -85)
Content.BackgroundTransparency = 1
Content.Parent = MainMenu

local uiList = Instance.new("UIListLayout", Content)
uiList.Padding = UDim.new(0, 8)

-- Зручний конструктор ПК-кнопок
local function addPCFeature(name, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [" .. key .. "] — [ВИМКН]"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    local function toggle()
        state = not state
        btn.TextColor3 = state and _G.UI_Color or Color3.fromRGB(255, 255, 255)
        btn.Text = name .. " [" .. key .. "] — " .. (state and "[УВІМКН]" or "[ВИМКН]")
        callback(state)
    end

    btn.MouseButton1Click:Connect(toggle)
    
    -- Активація через клавіатуру ПК
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode[key] then toggle() end
    end)
end

-- ==================== НАЛАШТУВАННЯ ФУНКЦІЙ ДЛЯ ПК ====================

-- 1. Спідхак (Клавіша X)
addPCFeature("Швидкість бігу (Speedhack)", "X", function(state)
    _G.SpeedValue = state and 75 or 16
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
    end
end)

-- 2. Нескінченні стрибки (Клавіша C)
addPCFeature("Нескінченні стрибки (InfJump)", "C", function(state)
    _G.InfJump = state
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 3. Повноцінний ESP / Бачення крізь стіни (Клавіша E)
addPCFeature("Бачення гравців крізь стіни (ESP)", "E", function(state)
    _G.EspEnabled = state
    if not _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PC_ESP") then p.Character.PC_ESP:Destroy() end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("PC_ESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "PC_ESP"
                hl.FillColor = _G.UI_Color
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.Parent = p.Character
            end
        end
    end
end)

-- ХОТКЕЙ ДЛЯ ЗГОРТАННЯ МЕНЮ (Натисни Insert або RightShift)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
        MainMenu.Visible = not MainMenu.Visible
    end
end)
