    --[================================================================%]
-- Steal an Egg Script | Keyless | Red Theme UI | Stable Loading & GUI
--[================================================================%]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Clean up any existing instances to avoid duplicates
if CoreGui:FindFirstChild("StealAnEggLoading") then CoreGui.StealAnEggLoading:Destroy() end
if CoreGui:FindFirstChild("StealAnEggHub") then CoreGui.StealAnEggHub:Destroy() end

-- Global Toggle Settings
getgenv().Config = {
    AutoSteal = false,
    AutoTreadmill = false,
    AutoHatch = false,
    AutoSell = false,
    AntiHit = true
}

-- 1. CREATE MAIN GUI INTERFACE (Hidden initially)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui

local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 300, 0, 340)
Window.Position = UDim2.new(0.5, -150, 0.5, -170)
Window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Color3.fromRGB(239, 68, 68)
WindowStroke.Thickness = 2
WindowStroke.Parent = Window

local TopBar = Instance.new("TextLabel")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.Text = "  Steal An Egg Hub"
TopBar.TextColor3 = Color3.fromRGB(239, 68, 68)
TopBar.TextSize = 15
TopBar.Font = Enum.Font.GothamBold
TopBar.TextXAlignment = Enum.TextXAlignment.Left
TopBar.Parent = Window

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 260)
Container.ScrollBarThickness = 4
Container.Parent = Window

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutIndex
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

local function createToggle(name, configKey)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 0, 45)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleButton.Text = "  " .. name .. ": OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleButton.TextSize = 13
    ToggleButton.Font = Enum.Font.GothamMedium
    ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
    ToggleButton.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 50, 50)
    Stroke.Thickness = 1
    Stroke.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            ToggleButton.Text = "  " .. name .. ": ON"
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            Stroke.Color = Color3.fromRGB(239, 68, 68)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        else
            ToggleButton.Text = "  " .. name .. ": OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            Stroke.Color = Color3.fromRGB(50, 50, 50)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
    end)
end

createToggle("Auto Steal Eggs", "AutoSteal")
createToggle("Auto Treadmill / Speed", "AutoTreadmill")
createToggle("Auto Hatch Eggs", "AutoHatch")
createToggle("Auto Sell Items", "AutoSell")
createToggle("Anti-Hit / Godmode", "AntiHit")

-- 2. LOADING SCREEN (0% - 100%)
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "StealAnEggLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 130)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoadingGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(239, 68, 68)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "STEAL AN EGG - PRO HUB"
Title.TextColor3 = Color3.fromRGB(239, 68, 68)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0, 320, 0, 18)
BarBackground.Position = UDim2.new(0.5, -160, 0.6, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 6)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 6)
FillCorner.Parent = BarFill

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0.82, 0)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "Loading 0%"
PercentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PercentLabel.TextSize = 13
PercentLabel.Font = Enum.Font.GothamMedium
PercentLabel.Parent = MainFrame

-- Async Loading Loop to prevent thread locking
task.spawn(function()
    for i = 0, 100, 5 do
        BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
        PercentLabel.Text = "Loading " .. i .. "%"
        task.wait(0.02)
    end
    task.wait(0.2)
    LoadingGui:Destroy()
    ScreenGui.Enabled = true
end)

-- 3. BACKGROUND LOGIC LOOPS
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage

RunService.Heartbeat:Connect(function()
    if not Config.AntiHit then return end
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if humanoid.Health < 100 then humanoid.Health = 100 end
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanTouch = false
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoTreadmill then
            pcall(function()
                local trainRemote = Remotes:FindFirstChild("Treadmill") or Remotes:FindFirstChild("Train") or Remotes:FindFirstChild("UpdateSpeed")
                if trainRemote and trainRemote:IsA("RemoteEvent") then
                    trainRemote:FireServer()
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoSteal then
            pcall(function()
                local eggsFolder = workspace:FindFirstChild("Eggs") or (workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Eggs"))
                if eggsFolder then
                    for _, egg in ipairs(eggsFolder:GetChildren()) do
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local handle = egg:FindFirstChild("Hitbox") or egg:FindFirstChild("PrimaryPart") or egg
                        if prompt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end)
        end
    end
end)

print("[StealAnEgg] GitHub Script Loaded Successfully!")
