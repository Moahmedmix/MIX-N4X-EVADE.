-- MIX-N4X HUB V1
-- Single-file Roblox exploit script with multiple modules
-- Load via: loadstring(game:HttpGet('https://raw.githubusercontent.com/Moahmedmix/MIX-N4X/main/main.lua'))() 

local HUB = {}
HUB.Version = "1.0.0"
HUB.Author = "Moahmedmix"
HUB.Enabled = true

-- ===== UTILITY FUNCTIONS =====
local function Log(message, logType)
    logType = logType or "INFO"
    local timestamp = os.date("%H:%M:%S")
    print("[" .. timestamp .. "] [" .. logType .. "] " .. message)
end

local function Notify(title, message, duration)
    duration = duration or 3
    print("[NOTIFICATION] " .. title .. ": " .. message)
end

-- ===== MODULE: FULLBRIGHT =====
local FullBright = {}
FullBright.Enabled = false
FullBright.OriginalLighting = {}

function FullBright:Enable()
    if self.Enabled then return end
    self.Enabled = true
    
    local Lighting = game:GetService("Lighting")
    
    -- Store original values
    self.OriginalLighting.Brightness = Lighting.Brightness
    self.OriginalLighting.Ambient = Lighting.Ambient
    self.OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    
    -- Apply fullbright
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    
    Log("FullBright enabled", "MODULE")
    Notify("FullBright", "Lighting enabled", 2)
end

function FullBright:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    
    local Lighting = game:GetService("Lighting")
    
    -- Restore original values
    Lighting.Brightness = self.OriginalLighting.Brightness
    Lighting.Ambient = self.OriginalLighting.Ambient
    Lighting.OutdoorAmbient = self.OriginalLighting.OutdoorAmbient
    
    Log("FullBright disabled", "MODULE")
    Notify("FullBright", "Lighting disabled", 2)
end

function FullBright:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- ===== MODULE: MOVEMENT =====
local Movement = {}
Movement.Speed = 1
Movement.MaxSpeed = 3
Movement.Connection = nil

function Movement:SetSpeed(speed)
    speed = math.clamp(speed, 0.1, self.MaxSpeed)
    self.Speed = speed
    Log("Movement speed set to " .. speed, "MODULE")
    Notify("Movement", "Speed: " .. speed, 1)
end

function Movement:GetSpeed()
    return self.Speed
end

function Movement:EnableSpeedBoost()
    if self.Connection then return end
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    if not player or not player.Character then return end
    
    self.Connection = game:GetService("RunService").RenderStepped:Connect(function()
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Boost speed by increasing humanoid speed
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 * self.Speed
            end
        end
    end)
    
    Log("Movement speed boost enabled", "MODULE")
    Notify("Movement", "Speed boost active", 2)
end

function Movement:DisableSpeedBoost()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
        Log("Movement speed boost disabled", "MODULE")
        Notify("Movement", "Speed boost disabled", 2)
    end
end

-- ===== MODULE: ESP =====
local ESP = {}
ESP.Enabled = false
ESP.ShowPlayers = true
ESP.ShowDistance = true
ESP.BoxColor = Color3.fromRGB(0, 255, 0)
ESP.Drawables = {}

function ESP:Enable()
    if self.Enabled then return end
    self.Enabled = true
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    
    if self.Connection then self.Connection:Disconnect() end
    
    self.Connection = RunService.RenderStepped:Connect(function()
        local localPlayer = Players.LocalPlayer
        if not localPlayer then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart then
                    -- Calculate distance
                    local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    -- Log player info (in real implementation, would render on screen)
                    -- For now, we just track that ESP is working
                end
            end
        end
    end)
    
    Log("ESP enabled", "MODULE")
    Notify("ESP", "Player tracking enabled", 2)
end

function ESP:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    Log("ESP disabled", "MODULE")
    Notify("ESP", "Player tracking disabled", 2)
end

function ESP:Toggle()
    if self.Enabled then
        self:Disable()
    else
        self:Enable()
    end
end

-- ===== COMMAND SYSTEM =====
local Commands = {}

function Commands:Register(name, description, callback)
    if not self[name] then
        self[name] = {
            Description = description,
            Callback = callback
        }
        Log("Command registered: " .. name, "COMMAND")
    end
end

function Commands:Execute(commandString)
    local parts = {}
    for part in commandString:gmatch("%S+") do
        table.insert(parts, part)
    end
    
    if #parts == 0 then return end
    
    local command = parts[1]:lower()
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end
    
    if self[command] and self[command].Callback then
        local success, result = pcall(self[command].Callback, args)
        if success then
            Log("Command executed: " .. command, "COMMAND")
        else
            Log("Command error: " .. tostring(result), "ERROR")
        end
    else
        Log("Unknown command: " .. command, "WARNING")
    end
end

function Commands:ListCommands()
    local list = "\n=== Available Commands ===\n"
    for name, data in pairs(self) do
        if data.Description then
            list = list .. name .. " - " .. data.Description .. "\n"
        end
    end
    print(list)
end

-- ===== REGISTER COMMANDS =====
Commands:Register("fullbright", "Toggle fullbright mode", function(args)
    FullBright:Toggle()
end)

Commands:Register("speed", "Set movement speed (0.1-3)", function(args)
    if args[1] then
        local speed = tonumber(args[1])
        if speed then
            Movement:SetSpeed(speed)
            Movement:EnableSpeedBoost()
        end
    end
end)

Commands:Register("speedoff", "Disable speed boost", function(args)
    Movement:DisableSpeedBoost()
end)

Commands:Register("esp", "Toggle ESP", function(args)
    ESP:Toggle()
end)

Commands:Register("help", "Show all commands", function(args)
    Commands:ListCommands()
end)

Commands:Register("status", "Show hub status", function(args)
    print("\n=== HUB Status ===")
    print("Version: " .. HUB.Version)
    print("FullBright: " .. (FullBright.Enabled and "ON" or "OFF"))
    print("Speed Boost: " .. (Movement.Connection ~= nil and "ON" or "OFF"))
    print("ESP: " .. (ESP.Enabled and "ON" or "OFF"))
    print("==================")
end)

-- ===== CONSOLE UI =====
local UI = {}

function UI:Init()
    Log("=== MIX-N4X HUB V" .. HUB.Version .. " ===", "SYSTEM")
    Log("Type 'help' to see all commands", "SYSTEM")
    Log("Type 'status' to check hub status", "SYSTEM")
    
    -- Create input detection
    local UserInputService = game:GetService("UserInputService")
    
    -- Keyboard shortcut: F6 to toggle console
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- F6 to open command palette
        if input.KeyCode == Enum.KeyCode.F6 then
            Commands:ListCommands()
        end
    end)
end

function UI:PrintWelcome()
    local welcome = [[  
╔═══════════════════════════════════╗
║      MIX-N4X HUB V1              ║
║     by Moahmedmix                ║
║                                   ║
║  Commands:                        ║
║  - fullbright   (Toggle)          ║
║  - speed <num>  (0.1-3)           ║
║  - speedoff     (Disable)         ║
║  - esp          (Toggle)          ║
║  - help         (Show all)        ║
║  - status       (Check)           ║
╚═══════════════════════════════════╝
]]
    print(welcome)
end

-- ===== INITIALIZATION =====
function HUB:Init()
    UI:PrintWelcome()
    UI:Init()
    Log("HUB initialized successfully", "SYSTEM")
end

function HUB:Execute(command)
    Commands:Execute(command)
end

-- ===== MAIN ENTRY POINT =====
if not getfenv then
    warn("This script requires a Roblox exploit environment")
    return
end

HUB:Init()

-- Expose globals for command execution
_G.MIX_N4X = HUB
_G.MIX_N4X_EXECUTE = function(cmd)
    Commands:Execute(cmd)
end

print("\n>> Type: _G.MIX_N4X_EXECUTE('help') for commands")

-- ===== ADD MODERN UI (NON-DESTRUCTIVE) =====
task.spawn(function()
    -- تحميل UI Library
    local DrRay = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"
    ))()

    local Window = DrRay:Load("MIX-N4X HUB", "Default")

    local PlayerTab = Window.newTab("Player", "rbxassetid://4483345998")
    local VisualTab = Window.newTab("Visual", "rbxassetid://4483345998")
    local ESPTab    = Window.newTab("ESP", "rbxassetid://4483345998")

    PlayerTab.newToggle("Speed Boost", "Enable Speed Boost", false, function(v)
        if v then
            Movement:EnableSpeedBoost()
        else
            Movement:DisableSpeedBoost()
        end
    end)

    PlayerTab.newSlider("Speed", "Change Walk Speed", 0.1, 3, 1, function(v)
        Movement:SetSpeed(v)
    end)

    VisualTab.newToggle("FullBright", "Toggle FullBright", false, function(v)
        if v then
            FullBright:Enable()
        else
            FullBright:Disable()
        end
    end)

    ESPTab.newToggle("ESP", "Toggle Player ESP", false, function(v)
        if v then
            ESP:Enable()
        else
            ESP:Disable()
        end
    end)

    Log("UI loaded successfully", "UI")
end)

return HUB
