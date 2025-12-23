--[[
    Project: MIX-N4X PRO HUB | ULTIMATE
    Library: RedzLib V5 (Modern Edition)
    Bypass: Metatable Hooking v2
]]

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()

local Window = redzlib:MakeWindow({
    Title = "🛡️ MIX-N4X PRO HUB",
    SubTitle = "EVADE ULTIMATE EDITION",
    SaveFolder = "MIXN4X_Config"
})

-- [ نظام تخطي الحماية المتقدم ]
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__index
mt.__index = newcclosure(function(t, k)
    if not checkcaller() and (k == "WalkSpeed" or k == "JumpPower") then return 16 end
    return old(t, k)
end)

-- [ التبويبات الرئيسية ]
local MainTab = Window:MakeTab({"🌾 Auto Farm", "home"})
local PlayerTab = Window:MakeTab({"👤 Player", "user"})
local VisualsTab = Window:MakeTab({"👁️ Visuals", "eye"})
local AutoTab = Window:MakeTab({"🤖 Automation", "cpu"})
local ServerTab = Window:MakeTab({"⚙️ Server", "settings"})

--- [ 1. Auto Farm Section ] ---
MainTab:AddSection({"Currency & XP"})
MainTab:AddToggle({Name = "Auto Farm XP / Cash", Callback = function(v) _G.Farm = v end})
MainTab:AddToggle({Name = "Auto Farm Candy", Callback = function(v) _G.Candy = v end})
MainTab:AddToggle({Name = "Auto Respawn", Callback = function(v) _G.Respawn = v end})

--- [ 2. Player Section ] ---
PlayerTab:AddSection({"Movement Physics"})
PlayerTab:AddSlider({Name = "Walk Speed", Min = 16, Max = 300, Default = 16, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end})
PlayerTab:AddSlider({Name = "Jump Power", Min = 50, Max = 500, Default = 50, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end})
PlayerTab:AddSlider({Name = "Field of View", Min = 70, Max = 120, Default = 70, Callback = function(v) workspace.CurrentCamera.FieldOfView = v end})
PlayerTab:AddToggle({Name = "Infinite Jump", Callback = function(v) _G.InfJump = v end})
PlayerTab:AddToggle({Name = "No Clip", Callback = function(v) _G.NoClip = v end})
PlayerTab:AddToggle({Name = "Bhop (Bunny Hop)", Callback = function(v) _G.Bhop = v end})

--- [ 3. Visuals Section ] ---
VisualsTab:AddSection({"ESP & Lighting"})
VisualsTab:AddToggle({Name = "Monsters ESP", Callback = function(v) _G.MonESP = v end})
VisualsTab:AddToggle({Name = "Downed Players ESP", Callback = function(v) _G.DownESP = v end})
VisualsTab:AddToggle({Name = "Candy ESP", Callback = function(v) _G.CanESP = v end})
VisualsTab:AddButton({Name = "Full Bright (Remove Darkness)", Callback = function() 
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
end})

--- [ 4. Automation Section ] ---
AutoTab:AddSection({"Auto Actions"})
AutoTab:AddToggle({Name = "Auto Instant Revive", Callback = function(v) _G.Revive = v end})
AutoTab:AddToggle({Name = "Auto Use Cola", Callback = function(v) _G.Cola = v end})
AutoTab:AddToggle({Name = "Auto Interact Doors", Callback = function(v) _G.Doors = v end})
AutoTab:AddDropdown({Name = "Auto Vote", Options = {"Easy", "Normal", "Hard", "Expert", "Random"}, Callback = function(v) _G.Vote = v end})

--- [ 5. Server Section ] ---
ServerTab:AddButton({Name = "Server Hop", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end})
ServerTab:AddButton({Name = "FPS Boost", Callback = function() setfpscap(999) end})
ServerTab:AddButton({Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer) end})
