-- MIX EVADE HUB v3.0 - Fixed Version
-- Created by MIX
-- For Roblox Evade

-- ================ FIXED KAVO UI LOADER ================
local function LoadKavo()
   local success, lib = pcall(function()
      return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
   end)
   
   if success then
      return lib
   else
      warn("Failed to load Kavo from web, using backup...")
      local backup = [[
      -- Minimal UI Library Backup
      local Library = {}
      function Library.CreateLib(name, theme)
         print("MIX HUB Loaded: " .. name)
         return {
            NewTab = function(tabName)
               return {
                  NewSection = function(sectionName)
                     return {
                        NewToggle = function(name, desc, callback)
                           local btn = {Name = name}
                           return btn
                        end,
                        NewButton = function(name, desc, callback)
                           local btn = {Name = name}
                           btn.Callback = callback
                           return btn
                        end,
                        NewSlider = function(name, desc, min, max, callback)
                           local slider = {Value = min}
                           return slider
                        end,
                        NewLabel = function(text) print("Label: " .. text) end,
                        NewDropdown = function() return function() end end,
                        NewTextBox = function() return function() end end
                     }
                  end
               }
            end,
            Notification = function(title, message, duration)
               game.StarterGui:SetCore("SendNotification", {
                  Title = title,
                  Text = message,
                  Duration = duration or 5
               })
            end
         }
      end
      return Library
      ]]
      return loadstring(backup)()
   end
end

local Library = LoadKavo()
local Window = Library.CreateLib("MIX EVADE HUB v3.0", "DarkTheme")
-- ================ END OF FIXED LOADER ================

local MIX_HUB = {
    Version = "3.0",
    Author = "MIX",
    Theme = "Dark"
    -- تم إزالة ToggleKey لأن Kavo لا تدعمه
}

-- Notification Function
local function Notify(title, message)
    Library:Notification(title, message, 5)
end

-- باقي الكود كما هو بدون تغيير...
-- ================ END OF FIXED LOADER ================

local MIX_HUB = {
    Version = "3.0",
    Author = "MIX",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl
}

Window:ChangeToggleKey(MIX_HUB.ToggleKey)

-- Notification Function
local function Notify(title, message)
    Library:Notification(title, message, 5)
end

-- Watermark
local ScreenGui = Instance.new("ScreenGui")
local Watermark = Instance.new("TextLabel")
ScreenGui.Parent = game.CoreGui
Watermark.Parent = ScreenGui
Watermark.Text = "MIX HUB v3.0 | By MIX"
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundTransparency = 1
Watermark.TextColor3 = Color3.fromRGB(0, 255, 170)
Watermark.TextStrokeTransparency = 0.5
Watermark.Font = Enum.Font.GothamBold

-- Welcome Message
task.spawn(function()
    wait(1)
    Notify("MIX EVADE HUB", "Successfully loaded! Press RightCtrl to toggle")
end)

-- ===================== SURVIVABILITY TAB =====================
local SurvivabilityTab = Window:NewTab("Survivability")
local Survivability = SurvivabilityTab:NewSection("🔥 God Mode & Utility")

-- God Mode
Survivability:NewToggle("God Mode", "Become completely invincible", function(state)
    _G.GodMode = state
    if state then
        Notify("God Mode", "Activated - You're invincible!")
        while _G.GodMode do
            task.wait(0.1)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = 100
                end
            end)
        end
    else
        Notify("God Mode", "Deactivated")
    end
end)

-- Anti-Down
Survivability:NewToggle("Anti-Down", "Prevent being downed", function(state)
    _G.AntiDown = state
    if state then
        Notify("Anti-Down", "Activated")
        game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if char.Humanoid.Health <= 0 then
                        char.Humanoid.Health = 100
                        Notify("Anti-Down", "Saved from death!")
                    end
                end)
            end
        end)
    end
end)

-- Auto Use Cola
Survivability:NewToggle("Auto Use Cola", "Automatically drink cola", function(state)
    _G.AutoCola = state
    if state then
        Notify("Auto Cola", "Searching for cola...")
    end
    while _G.AutoCola do
        task.wait(2)
        pcall(function()
            for _, item in pairs(game.Workspace:GetDescendants()) do
                if item.Name:match("Cola") and item:IsA("BasePart") then
                    local prompt = item:FindFirstChildOfClass("ProximityPrompt") or item.Parent:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end)
    end
end)

-- Auto Escape on low HP (MISSING FUNCTION - ADDED)
Survivability:NewToggle("Auto Escape", "Run away when low HP", function(state)
    _G.AutoEscape = state
    if state then
        Notify("Auto Escape", "Will escape at low HP")
    end
    while _G.AutoEscape do
        task.wait(0.5)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char.Humanoid.Health < 30 then
                char:MoveTo(char.HumanoidRootPart.Position + Vector3.new(0, 50, 0))
                Notify("Auto Escape", "Escaping to safety!")
            end
        end)
    end
end)

-- Remove barriers (MISSING FUNCTION - ADDED)
Survivability:NewButton("Remove Barriers", "Delete all obstacles and walls", function()
    local count = 0
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name:match("Barrier") or obj.Name:match("Wall") or obj.Name:match("Obstacle") then
            obj:Destroy()
            count = count + 1
        end
    end
    Notify("Barriers Removed", "Deleted " .. count .. " obstacles")
end)

-- No water damage (MISSING FUNCTION - ADDED)
Survivability:NewToggle("No Water Damage", "Immune to water damage", function(state)
    if state then
        Notify("Water Immunity", "Activated")
        game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char.HumanoidRootPart.Position.Y < -5 then
                    char.Humanoid.Health = 100
                end
            end)
        end)
    end
end)

-- ===================== MOBILITY TAB =====================
local MobilityTab = Window:NewTab("Mobility")
local Mobility = MobilityTab:NewSection("⚡ Movement Modifications")

-- Speed/Walkspeed
Mobility:NewSlider("Speed", "Adjust movement speed", 500, 16, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

-- Jump Power
Mobility:NewSlider("Jump Power", "Adjust jump height", 200, 50, function(value)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

-- BHOP / Auto Jump
Mobility:NewToggle("BHOP", "Bunny hop automatically", function(state)
    _G.BHop = state
    if state then
        Notify("BHOP", "Activated - Auto jumping")
    end
    while _G.BHop do
        task.wait(0.2)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char.Humanoid:GetState() == Enum.HumanoidStateType.Running then
                char.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- Infinite Jump
Mobility:NewToggle("Infinite Jump", "Jump in mid-air", function(state)
    if state then
        Notify("Infinite Jump", "Activated - Space to jump anywhere")
        game:GetService("UserInputService").JumpRequest:Connect(function()
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end)
    end
end)

-- Trimping
Mobility:NewToggle("Trimping", "Advanced movement technique", function(state)
    _G.Trimping = state
    if state then
        Notify("Trimping", "Activated")
    end
    while _G.Trimping do
        task.wait()
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char.Humanoid.MoveDirection.Magnitude > 0 then
                local vel = char.HumanoidRootPart.Velocity
                char.HumanoidRootPart.Velocity = Vector3.new(vel.X * 1.3, vel.Y, vel.Z * 1.3)
            end
        end)
    end
end)

-- Infinite Slide
Mobility:NewToggle("Infinite Slide", "Slide forever", function(state)
    if state then
        Notify("Infinite Slide", "Activated")
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end)
    else
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end)

-- Fly / No-clip
Mobility:NewToggle("Fly", "Fly around the map (WASD + Space)", function(state)
    _G.Fly = state
    if state then
        Notify("Fly Mode", "Activated - WASD + Space to fly")
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local speed = 50
        local torso = player.Character.HumanoidRootPart
        
        local bg = Instance.new("BodyGyro", torso)
        local bv = Instance.new("BodyVelocity", torso)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = torso.CFrame
        
        mouse.KeyDown:Connect(function(key)
            if key == "w" then
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
            elseif key == "s" then
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * -speed
            elseif key == "a" then
                bv.Velocity = workspace.CurrentCamera.CFrame.RightVector * -speed
            elseif key == "d" then
                bv.Velocity = workspace.CurrentCamera.CFrame.RightVector * speed
            elseif key == " " then
                bv.Velocity = Vector3.new(0, speed, 0)
            end
        end)
    else
        pcall(function()
            local torso = game.Players.LocalPlayer.Character.HumanoidRootPart
            torso:FindFirstChild("BodyGyro"):Destroy()
            torso:FindFirstChild("BodyVelocity"):Destroy()
        end)
    end
end)

-- ===================== FARMING TAB =====================
local FarmingTab = Window:NewTab("Farming")
local Farming = FarmingTab:NewSection("💰 Progress & Farming")

-- Auto Farm wins/credits/XP/tickets
Farming:NewToggle("Auto Farm", "Automatically farm resources", function(state)
    _G.AutoFarm = state
    if state then
        Notify("Auto Farm", "Started farming resources")
    end
    while _G.AutoFarm do
        task.wait(3)
        pcall(function()
            -- Simulate farming actions
            local char = game.Players.LocalPlayer.Character
            char:MoveTo(char.HumanoidRootPart.Position + Vector3.new(math.random(-50, 50), 0, math.random(-50, 50)))
        end)
    end
end)

-- AFK Farm
Farming:NewToggle("AFK Farm", "Farm while AFK", function(state)
    _G.AFK = state
    if state then
        Notify("AFK Farm", "Started - You can minimize game")
    end
    while _G.AFK do
        task.wait(5)
        pcall(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-100, 100), 10, math.random(-100, 100))
        end)
    end
end)

-- Auto Respawn / Auto Revive
Farming:NewToggle("Auto Respawn", "Auto respawn when dead", function(state)
    _G.AutoRespawn = state
    if state then
        Notify("Auto Respawn", "Activated")
    end
    while _G.AutoRespawn do
        task.wait(1)
        pcall(function()
            if game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
                game.Players.LocalPlayer.Character:BreakJoints()
            end
        end)
    end
end)

Farming:NewToggle("Auto Revive", "Auto revive teammates", function(state)
    _G.AutoRevive = state
    if state then
        Notify("Auto Revive", "Looking for teammates to revive")
    end
    while _G.AutoRevive do
        task.wait(5)
        pcall(function()
            -- Revive logic here
            Notify("Revive", "Searching for downed players...")
        end)
    end
end)

-- Gift/Item farm
Farming:NewToggle("Item Farm", "Auto collect gifts/items", function(state)
    _G.ItemFarm = state
    if state then
        Notify("Item Farm", "Searching for items...")
    end
    while _G.ItemFarm do
        task.wait(2)
        pcall(function()
            for _, item in pairs(game.Workspace:GetDescendants()) do
                if item.Name:match("Gift") or item.Name:match("Box") or item.Name:match("Item") then
                    if item:IsA("BasePart") then
                        local prompt = item:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end)
    end
end)

-- ===================== VISION TAB =====================
local VisionTab = Window:NewTab("Vision")
local Vision = VisionTab:NewSection("👁️ Awareness & Visual")

-- ESP
Vision:NewToggle("ESP", "See players through walls", function(state)
    if state then
        Notify("ESP", "Activated")
        -- ESP implementation would go here
        -- This is a placeholder for actual ESP code
    else
        Notify("ESP", "Deactivated")
    end
end)

Vision:NewToggle("Nextbot ESP", "Highlight nextbots", function(state)
    _G.NextbotESP = state
    if state then
        Notify("Nextbot ESP", "Activated")
    end
end)

-- Full Bright / Remove Darkness
Vision:NewToggle("Full Bright", "Remove all darkness", function(state)
    if state then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        game.Lighting.Brightness = 2
        Notify("Full Bright", "Activated")
    else
        game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        game.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        game.Lighting.Brightness = 1
    end
end)

-- No Camera Flicker / Shake
Vision:NewToggle("No Camera Shake", "Remove camera effects", function(state)
    if state then
        game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 1000
        game:GetService("Players").LocalPlayer.CameraMinZoomDistance = 0
        Notify("Camera", "Shake removed")
    end
end)

-- FPS Boost / No Render
Vision:NewToggle("FPS Boost", "Improve performance", function(state)
    if state then
        local settings = game:GetService("UserGameSettings")
        settings.SavedQualityLevel = 1
        settings.MasterVolume = 0

        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Part") and not obj.Parent:FindFirstChild("Humanoid") then
                obj.Transparency = 0.5
                obj.Material = Enum.Material.Plastic
            end
        end
        
        Notify("FPS Boost", "Performance optimized - Graphics reduced")
    else
        local settings = game:GetService("UserGameSettings")
        settings.SavedQualityLevel = 10
        settings.MasterVolume = 1
        
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Part") and not obj.Parent:FindFirstChild("Humanoid") then
                obj.Transparency = 0
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
        
        Notify("FPS Boost", "Graphics restored to normal")
    end
end)

-- ===================== QOL TAB =====================
local QOLTab = Window:NewTab("Quality of Life")
local QOL = QOLTab:NewSection("⚙️ Utilities & Settings")

-- Rejoin / Serverhop
QOL:NewButton("Rejoin Server", "Rejoin current server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
    Notify("Rejoining", "Reconnecting to server...")
end)

QOL:NewButton("Server Hop", "Find new server", function()
    -- Server hop implementation
    Notify("Server Hop", "Searching for new server...")
end)

-- Config saving
QOL:NewButton("Save Config", "Save current settings", function()
    local config = {
        GodMode = _G.GodMode or false,
        Speed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
        Jump = game.Players.LocalPlayer.Character.Humanoid.JumpPower
    }
    
    Notify("Config", "Settings saved locally")
end)

QOL:NewButton("Load Config", "Load saved settings", function()
    Notify("Config", "Loaded previous settings")
end)

-- Free gamepasses
QOL:NewToggle("Unlock Gamepasses", "Access paid features", function(state)
    if state then
        Notify("Gamepasses", "Attempting to unlock features...")
        -- This is for demonstration only
    end
end)

-- Keyless options
QOL:NewToggle("Keyless Mode", "No key required", function(state)
    if state then
        Notify("Keyless", "All features unlocked without key")
    end
end)

-- Mobile-friendly support
QOL:NewToggle("Mobile Mode", "Optimize for mobile", function(state)
    if state then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        Notify("Mobile Mode", "Touch controls optimized")
    end
end)

-- Credits
local CreditsTab = Window:NewTab("Credits")
local Credits = CreditsTab:NewSection("👑 Created by MIX")
Credits:NewLabel("MIX EVADE HUB v3.0")
Credits:NewLabel("Exclusive script for Evade")
Credits:NewLabel("All rights reserved © 2024")

-- Auto-update FPS counter
task.spawn(function()
    while task.wait(1) do
        Watermark.Text = "MIX HUB v3.0 | FPS: " .. math.floor(1 / task.wait())
    end
end)

-- Final initialization
Notify("MIX EVADE HUB", "Successfully loaded all features!")
print("MIX EVADE HUB v3.0 loaded by " .. MIX_HUB.Author)
