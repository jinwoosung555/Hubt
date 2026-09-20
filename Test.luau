--[================================================================%]
-- Steal an Egg Script | Keyless | Custom Built UI & Automation Hub
--[================================================================%]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Clean up any existing duplicates
if CoreGui:FindFirstChild("StealAnEggCustomHub") then 
    CoreGui.StealAnEggCustomHub:Destroy() 
end

-- Global Toggle Settings
getgenv().Config = {
    AutoSteal = false,
    AutoTreadmill = false,
    AutoHatch = false,
    AutoSell = false,
    AntiHit = true
}

-- 1. BUILD CUSTOM SCREEN GUI & WINDOW
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggCustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(239, 68, 68) -- Red Theme Accent
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- 2. TOP BAR (Draggable Area)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Fix bottom corners of top bar to look square inside rounded frame
local FixCorner = Instance.new("Frame")
FixCorner.Size = UDim2.new(1, 0, 0, 10)
FixCorner.Position = UDim2.new(0, 0, 1, -10)
FixCorner.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FixCorner.BorderSizePixel = 0
FixCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG HUB"
TitleLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Minimize / Close Button Logic
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize, CloseButton.Font = 14, Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make Window Draggable
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 3. CONTENT CONTAINER & SCROLLING LIST
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 270)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutIndex
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Helper function to generate clean toggle buttons
local function createCustomToggle(name, configKey)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Container

    local BCorners = Instance.new("UICorner")
    BCorners.CornerRadius = UDim.new(0, 8)
    BCorners.Parent = Button

    local BStroke = Instance.new("UIStroke")
    BStroke.Color = Color3.fromRGB(45, 45, 45)
    BStroke.Thickness = 1
    BStroke.Parent = Button

    local TextName = Instance.new("TextLabel")
    TextName.Size = UDim2.new(0.7, 0, 1, 0)
    TextName.Position = UDim2.new(0, 15, 0, 0)
    TextName.BackgroundTransparency = 1
    TextName.Text = name
    TextName.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextName.TextSize = 13
    TextName.Font = Enum.Font.GothamMedium
    TextName.TextXAlignment = Enum.TextXAlignment.Left
    TextName.Parent = Button

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.3, -15, 1, 0)
    StatusLabel.Position = UDim2.new(0.7, 0, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = Config[configKey] and "ON" or "OFF"
    StatusLabel.TextColor3 = Config[configKey] and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(120, 120, 120)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
    StatusLabel.Parent = Button

    Button.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            StatusLabel.Text = "ON"
            StatusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            BStroke.Color = Color3.fromRGB(239, 68, 68)
        else
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
            BStroke.Color = Color3.fromRGB(45, 45, 45)
        end
    end)
end

-- Generate UI Toggles
createCustomToggle("Auto Steal Eggs", "AutoSteal")
createCustomToggle("Auto Treadmill / Speed", "AutoTreadmill")
createCustomToggle("Auto Hatch Eggs", "AutoHatch")
createCustomToggle("Auto Sell Items", "AutoSell")
createCustomToggle("Anti-Hit / Godmode", "AntiHit")

-- 4. BACKGROUND AUTOMATION LOGIC LOOPS
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage

-- Anti-Hit / Godmode Loop
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

-- Auto Treadmill Loop
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

-- Auto Steal Loop
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

print("[StealAnEgg] Custom UI Script Loaded Successfully!")
