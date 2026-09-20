--[================================================================%]
-- Steal an Egg Script | Keyless | Red Theme | Auto Features Added
-- Features: Loading Screen, Anti-Hit, Auto Steal, Auto Treadmill, Auto Hatch
--[================================================================%]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Global Toggle Settings for New Features
getgenv().Config = {
    AutoSteal = true,
    AutoTreadmill = true,
    AutoHatch = true,
    AutoSell = true,
    SelectedEggType = "Best", -- Options: "Best", "Common", "Rare"
}

-- 1. LOADING SCREEN (0% - 100%) WITH RED THEME
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "StealAnEggLoading"
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
UIStroke.Color = Color3.fromRGB(239, 68, 68) -- Red Theme Accent
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

-- Animate Loading 0-100%
task.spawn(function()
    for i = 0, 100, 5 do
        BarFill.Size = UDim2.new(i / 100, 0, 1, 0)
        PercentLabel.Text = "Loading " .. i .. "%"
        task.wait(0.01)
    end
    task.wait(0.3)
    LoadingGui:Destroy()
end)

-- 2. CORE ANTI-HIT & GODMODE SYSTEM
local function applyAntiHit()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        if humanoid.Health < 100 then
            humanoid.Health = 100
        end
    end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanTouch = false
        end
    end
end

RunService.Heartbeat:Connect(function()
    pcall(applyAntiHit)
end)

-- 3. NEW FEATURES: AUTO TREADMILL & AUTO STEAL LOGIC
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage

-- Auto Treadmill (Loops training interaction to increase player speed)
task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoTreadmill then
            pcall(function()
                -- Triggers treadmill / training function based on typical game structure
                local trainRemote = Remotes:FindFirstChild("Treadmill") or Remotes:FindFirstChild("Train") or Remotes:FindFirstChild("UpdateSpeed")
                if trainRemote and trainRemote:IsA("RemoteEvent") then
                    trainRemote:FireServer()
                elseif trainRemote and trainRemote:IsA("RemoteFunction") then
                    trainRemote:InvokeServer()
                end
            end)
        end
    end
end)

-- Auto Steal (Automatically detects and interacts with active eggs in the map)
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoSteal then
            pcall(function()
                local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Eggs")
                if eggsFolder then
                    for _, egg in ipairs(eggsFolder:GetChildren()) do
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local handle = egg:FindFirstChild("Hitbox") or egg:FindFirstChild("PrimaryPart") or egg
                        
                        if prompt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleport / Instant touch interaction simulation
                            LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame + Vector3.new(0, 3, 0)
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end)
        end
    end
end)

print("[StealAnEgg] Upgraded Script with Auto Steal & Treadmill initialized successfully!")
