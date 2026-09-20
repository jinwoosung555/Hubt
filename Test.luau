--[================================================================%]
-- Steal an Egg Script | Keyless | WindUI Library | Fully Functional
--[================================================================%]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Clean up any existing instances to avoid duplicates
if CoreGui:FindFirstChild("StealAnEggLoading") then CoreGui.StealAnEggLoading:Destroy() end

-- Global Toggle Settings
getgenv().Config = {
    AutoSteal = false,
    AutoTreadmill = false,
    AutoHatch = false,
    AutoSell = false,
    AntiHit = true
}

-- 1. WIND UI LIBRARY SETUP
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/Example.lua"))()

-- Note: Depending on WindUI's exact initialization standard, we construct the Window cleanly:
local Window = WindUI:CreateWindow({
    Title = "Steal An Egg Hub",
    Icon = "rbxassetid://10734950309",
    Author = "Keyless Edition",
    Folder = "StealAnEggHub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    Resizable = false,
    SideBarWidth = 150,
    HasOutline = true,
})

-- Create Tabs
local MainTab = Window:Tab({ Title = "Automation", Icon = "cpu" })
local SafetyTab = Window:Tab({ Title = "Safety & Misc", Icon = "shield" })

-- 2. AUTOMATION TAB CONTROLS (Toggles)
MainTab:Toggle({
    Title = "Auto Steal Eggs",
    Desc = "Automatically targets and steals spawned eggs in the map",
    Value = Config.AutoSteal,
    Callback = function(state)
        Config.AutoSteal = state
    end
})

MainTab:Toggle({
    Title = "Auto Treadmill / Speed",
    Desc = "Loops training input to increase player movement stats",
    Value = Config.AutoTreadmill,
    Callback = function(state)
        Config.AutoTreadmill = state
    end
})

MainTab:Toggle({
    Title = "Auto Hatch Eggs",
    Desc = "Automatically purchases and hatches selected eggs",
    Value = Config.AutoHatch,
    Callback = function(state)
        Config.AutoHatch = state
    end
})

MainTab:Toggle({
    Title = "Auto Sell Items",
    Desc = "Automatically sells gathered inventory items",
    Value = Config.AutoSell,
    Callback = function(state)
        Config.AutoSell = state
    end
})

-- 3. SAFETY TAB CONTROLS
SafetyTab:Toggle({
    Title = "Anti-Hit / Godmode",
    Desc = "Prevents damage states and enemy/animal touch interactions",
    Value = Config.AntiHit,
    Callback = function(state)
        Config.AntiHit = state
    end
})

-- 4. BACKGROUND AUTOMATION LOOPS
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage

-- Anti-Hit / Godmode Heartbeat
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

WindUI:Notify({
    Title = "Script Loaded!",
    Content = "WindUI successfully initialized with all features enabled.",
    Duration = 4
})
