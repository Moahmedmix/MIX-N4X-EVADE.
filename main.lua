-- MIX-N4X HUB V1.5
-- Single-file Roblox exploit script
-- Load via raw GitHub

-- ================== HUB INFO ==================
local HUB = {
    Version = "1.5.0",
    Author = "Moahmedmix",
    Enabled = true
}

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- ================== UTILS ==================
local function Log(msg, t)
    print(("["..(t or "INFO").."] "..msg))
end

-- ================== FULLBRIGHT ==================
local FullBright = {Enabled = false, Original = {}}

function FullBright:Enable()
    if self.Enabled then return end
    self.Enabled = true
    self.Original = {
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient
    }
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1,1,1)
    Lighting.OutdoorAmbient = Color3.new(1,1,1)
end

function FullBright:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    for i,v in pairs(self.Original) do
        Lighting[i] = v
    end
end

-- ================== MOVEMENT ==================
local Movement = {
    Speed = 1,
    Connection = nil
}

function Movement:Apply(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16 * self.Speed
    end
end

function Movement:Enable()
    if self.Connection then return end
    self.Connection = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character then
            self:Apply(LocalPlayer.Character)
        end
    end)
end

function Movement:Disable()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end

-- Auto reapply after death
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Movement.Connection then
        Movement:Apply(char)
    end
end)

-- ================== ESP ==================
local ESP = {Enabled = false, Tags = {}}

function ESP:Clear()
    for _,v in pairs(self.Tags) do
        if v then v:Destroy() end
    end
    self.Tags = {}
end

function ESP:Enable()
    if self.Enabled then return end
    self.Enabled = true

    RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if not self.Tags[plr] then
                    local bb = Instance.new("BillboardGui", plr.Character.Head)
                    bb.Size = UDim2.new(0,200,0,50)
                    bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(0,255,0)
                    txt.TextScaled = true
                    self.Tags[plr] = bb
                end
                local dist = (plr.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
                self.Tags[plr].TextLabel.Text = plr.Name.." ["..math.floor(dist).."]"
            end
        end
    end)
end

function ESP:Disable()
    self.Enabled = false
    self:Clear()
end

-- ================== UI ==================
task.spawn(function()
    local DrRay = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"
    ))()

    local Window = DrRay:Load("MIX-N4X HUB v"..HUB.Version, "Default")
    local UIVisible = true

    -- Keybind RightShift
    UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightShift then
            UIVisible = not UIVisible
            Window:SetVisible(UIVisible)
        end
    end)

    local PlayerTab = Window.newTab("Player")
    local VisualTab = Window.newTab("Visual")
    local ESPTab = Window.newTab("ESP")
    local SettingsTab = Window.newTab("Settings")

    PlayerTab.newToggle("Speed Boost", "", false, function(v)
        if v then Movement:Enable() else Movement:Disable() end
    end)

    PlayerTab.newSlider("Speed", "", 0.5, 5, 1, function(v)
        Movement.Speed = v
    end)

    VisualTab.newToggle("FullBright", "", false, function(v)
        if v then FullBright:Enable() else FullBright:Disable() end
    end)

    ESPTab.newToggle("ESP", "", false, function(v)
        if v then ESP:Enable() else ESP:Disable() end
    end)

    SettingsTab.newButton("Rejoin", "", function()
        TeleportService:Teleport(game.PlaceId)
    end)

    SettingsTab.newButton("Destroy UI", "", function()
        Window:Destroy()
    end)

    Log("UI Loaded", "UI")
end)

return HUB
