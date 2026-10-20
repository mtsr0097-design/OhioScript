-- GGHub Ultimate PC Edition (Fixed & Re-connected)
-- Owner: tumy7287
-- Fully Dedicated for Solar on PC

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Очищення старого інтерфейсу
if LocalPlayer.PlayerGui:FindFirstChild("GGHub_PC_Final") then 
    LocalPlayer.PlayerGui.GGHub_PC_Final:Destroy() 
end

-- Створення GUI в PlayerGui (найбільш стабільний варіант)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGHub_PC_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

_G.SpeedValue = 16
_G.InfJump = false
_G.EspEnabled = false
_G.UI_Color = Color3.fromRGB(0, 255, 170)

-- ГОЛОВНЕ МЕНЮ
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 350, 0, 250)
MainMenu.Position = UDim2.new(0.5, -175, 0.5, -125)
MainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Parent = ScreenGui
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 10)

-- Заголовок
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.TextColor3 = Color3.fromRGB(255, 215, 0)
Header.Text = "👑 OWNER: tumy7287 | GGHub PC"
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.Parent = MainMenu

local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 15, 0, 55)
Content.Size = UDim2.new(1, -30, 1, -70)
Content.BackgroundTransparency = 1
Content.Parent = MainMenu

local uiList = Instance.new("UIListLayout", Content)
uiList.Padding = UDim.new(0, 8)

-- Функція побудови кнопок
local function addCheat(name, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [" .. key .. "] : OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    local function toggle()
        state = not state
        btn.TextColor3 = state and _G.UI_Color or Color3.fromRGB(255, 255, 255)
        btn.Text = name .. " [" .. key .. "] : " .. (state and "ON" or "OFF")
        callback(state)
    end

    btn.MouseButton1Click:Connect(toggle)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode[key] then toggle() end
    end)
end

-- Кнопки читів
addCheat("Спідхак (Швидкість)", "X", function(state)
    _G.SpeedValue = state and 70 or 16
end)

addCheat("Нескінченні Стрибки", "C", function(state)
    _G.InfJump = state
end)

addCheat("Бачення гравців (ESP)", "E", function(state)
    _G.EspEnabled = state
    if not _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("GGHub_Highlight") then 
                p.Character.GGHub_Highlight:Destroy() 
            end
        end
    end
end)

-- Фонова логіка
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
    end
    
    if _G.EspEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("GGHub_Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "GGHub_Highlight"
                hl.FillColor = _G.UI_Color
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Відкрити/Закрити меню на кнопку INSERT або RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
        MainMenu.Visible = not MainMenu.Visible
    end
end)
