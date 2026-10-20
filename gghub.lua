-- GGHub Direct Super-Light Edition
-- Owner: tumy7287
-- Direct Execution for Solar V3 (No Loadstring)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Видаляємо старі копії меню, якщо вони були
if LocalPlayer.PlayerGui:FindFirstChild("GGHub_Direct") then
    LocalPlayer.PlayerGui.GGHub_Direct:Destroy()
end

-- Створення GUI прямо в екран
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGHub_Direct"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

_G.SpeedValue = 16
_G.InfJump = false

-- МАЛЕНЬКА КНОПКА (⚡ GGHub)
local MiniMenu = Instance.new("TextButton")
MiniMenu.Size = UDim2.new(0, 100, 0, 45)
MiniMenu.Position = UDim2.new(0.1, 0, 0.2, 0)
MiniMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniMenu.TextColor3 = Color3.fromRGB(0, 255, 170)
MiniMenu.Text = "⚡ GGHub"
MiniMenu.Font = Enum.Font.SourceSansBold
MiniMenu.TextSize = 18
MiniMenu.Parent = ScreenGui

local Corner1 = Instance.new("UICorner", MiniMenu)
Corner1.CornerRadius = UDim.new(0, 8)

-- ГОЛОВНЕ МЕНЮ
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 300, 0, 200)
MainMenu.Position = UDim2.new(0.5, -150, 0.5, -100)
MainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainMenu.Visible = false
MainMenu.Parent = ScreenGui

local Corner2 = Instance.new("UICorner", MainMenu)
Corner2.CornerRadius = UDim.new(0, 12)

-- Напис Власника
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.TextColor3 = Color3.fromRGB(255, 215, 0)
Header.Text = "👑 OWNER: tumy7287"
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.Parent = MainMenu

-- КНОПКА 1: ШВИДКІСТЬ
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Text = "Спідхак: ВЫМКН"
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.TextSize = 14
SpeedBtn.Parent = MainMenu
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0, 6)

local speedState = false
SpeedBtn.MouseButton1Click:Connect(function()
    speedState = not speedState
    _G.SpeedValue = speedState and 75 or 16
    SpeedBtn.Text = speedState and "Спідхак: УВІМКН" or "Спідхак: ВЫМКН"
    SpeedBtn.TextColor3 = speedState and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(255, 255, 255)
end)

-- КНОПКА 2: НЕСКІНЧЕННИЙ СТРИБОК
local JumpBtn = Instance.new("TextButton")
JumpBtn.Size = UDim2.new(0.9, 0, 0, 40)
JumpBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
JumpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBtn.Text = "Нескінченний стрибок: ВЫМКН"
JumpBtn.Font = Enum.Font.SourceSansBold
JumpBtn.TextSize = 14
JumpBtn.Parent = MainMenu
Instance.new("UICorner", JumpBtn).CornerRadius = UDim.new(0, 6)

JumpBtn.MouseButton1Click:Connect(function()
    _G.InfJump = not _G.InfJump
    JumpBtn.Text = _G.InfJump and "Нескінченний стрибок: УВІМКН" or "Нескінченний стрибок: ВЫМКН"
    JumpBtn.TextColor3 = _G.InfJump and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(255, 255, 255)
end)

-- Логіка Спідхаку
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
    end
end)

-- Логіка Стрибків
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Відкриття/Закриття меню
MiniMenu.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)
