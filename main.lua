-- MIX WindUI Custom v1.0
-- Enhanced WindUI Script for MIX
-- Based on: https://raw.githubusercontent.com/Footagesus/WindUI/main/main_example.lua

local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/main_example.lua'))()

-- Create Window with MIX theme
local Window = WindUI:CreateWindow({
    Title = "🎮 MIX EVADE HUB",
    SubTitle = "Powered by WindUI | v2.0",
    MainColor = Color3.fromRGB(0, 255, 170), -- MIX Green color
    AccentColor = Color3.fromRGB(30, 30, 45),
    BackgroundColor = Color3.fromRGB(15, 15, 25),
    BackgroundTransparency = 0.1
})

-- ===================== MAIN TAB =====================
local MainTab = Window:CreateTab({
    Title = "🏠 الرئيسية",
    Icon = "home"
})

MainTab:AddSection("👤 معلومات اللاعب")

MainTab:AddLabel("🎮 مرحباً بك في MIX HUB")
MainTab:AddLabel("📅 الإصدار: 2.0 - WindUI Edition")
MainTab:AddLabel("👤 المطور: MIX")

MainTab:AddSection("⚡ إعدادات سريعة")

MainTab:AddToggle({
    Title = "وضع الإله (God Mode)",
    Description = "تصبح غير قابل للقتل",
    Default = false,
    Callback = function(state)
        _G.GodMode = state
        if state then
            WindUI:Notification({
                Title = "وضع الإله",
                Description = "✅ تم التفعيل! أنت الآن غير قابل للقتل",
                Duration = 3
            })
            spawn(function()
                while _G.GodMode do
                    wait(0.1)
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.Health = 100
                        end
                    end)
                end
            end)
        else
            WindUI:Notification({
                Title = "وضع الإله",
                Description = "❌ تم الإيقاف",
                Duration = 2
            })
        end
    end
})

MainTab:AddSlider({
    Title = "سرعة الحركة",
    Description = "تحكم في سرعة المشي",
    Default = 16,
    Min = 16,
    Max = 500,
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            WindUI:Notification({
                Title = "السرعة",
                Description = "⚡ تم تعيين السرعة إلى: " .. value,
                Duration = 2
            })
        end)
    end
})

MainTab:AddSlider({
    Title = "قوة القفز",
    Description = "تحكم في ارتفاع القفز",
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            WindUI:Notification({
                Title = "القفز",
                Description = "🦘 تم تعيين قوة القفز إلى: " .. value,
                Duration = 2
            })
        end)
    end
})

-- ===================== SURVIVABILITY TAB =====================
local SurvivalTab = Window:CreateTab({
    Title = "🛡️ البقاء",
    Icon = "shield"
})

SurvivalTab:AddSection("🔥 قدرات البقاء")

SurvivalTab:AddToggle({
    Title = "منع السقوط (Anti-Down)",
    Description = "تجنب حالة السقوط",
    Default = false,
    Callback = function(state)
        if state then
            WindUI:Notification({
                Title = "Anti-Down",
                Description = "✅ لن تسقط أبداً",
                Duration = 3
            })
            game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
                wait(0.5)
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if char.Humanoid.Health <= 0 then
                            char.Humanoid.Health = 100
                        end
                    end)
                end
            end)
        end
    end
})

SurvivalTab:AddToggle({
    Title = "شرب الكولا تلقائياً",
    Description = "يشرب الكولا تلقائياً",
    Default = false,
    Callback = function(state)
        _G.AutoCola = state
        if state then
            WindUI:Notification({
                Title = "Auto Cola",
                Description = "🥤 يبحث عن كولا...",
                Duration = 3
            })
            spawn(function()
                while _G.AutoCola do
                    wait(2)
                    pcall(function()
                        for _, item in pairs(workspace:GetDescendants()) do
                            if item.Name:lower():find("cola") and item:IsA("BasePart") then
                                local prompt = item:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

SurvivalTab:AddButton({
    Title = "إزالة الحواجز",
    Description = "يزيل كل الجدران والعوائق",
    Callback = function()
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:match("Barrier") or obj.Name:match("Wall") or obj.Name:match("Obstacle") then
                pcall(function() obj:Destroy() end)
                count = count + 1
            end
        end
        WindUI:Notification({
            Title = "الحواجز",
            Description = "🗑️ تم حذف " .. count .. " عائق",
            Duration = 3
        })
    end
})

-- ===================== MOVEMENT TAB =====================
local MovementTab = Window:CreateTab({
    Title = "⚡ الحركة",
    Icon = "zap"
})

MovementTab:AddSection("🚀 تعديلات الحركة")

MovementTab:AddToggle({
    Title = "قفز لا نهائي",
    Description = "القفز في الهواء",
    Default = false,
    Callback = function(state)
        if state then
            WindUI:Notification({
                Title = "قفز لا نهائي",
                Description = "🦘 تم التفعيل! اضغط Space للقفز",
                Duration = 3
            })
            game:GetService("UserInputService").JumpRequest:Connect(function()
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end)
            end)
        end
    end
})

MovementTab:AddToggle({
    Title = "وضع الطيران",
    Description = "الطيران في الخريطة (WASD + Space)",
    Default = false,
    Callback = function(state)
        _G.FlyEnabled = state
        if state then
            WindUI:Notification({
                Title = "الطيران",
                Description = "✈️ تم التفعيل! استخدم WASD للتحكم",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        else
            WindUI:Notification({
                Title = "الطيران",
                Description = "❌ تم الإيقاف",
                Duration = 2
            })
        end
    end
})

MovementTab:AddToggle({
    Title = "No Clip",
    Description = "المشي عبر الجدران",
    Default = false,
    Callback = function(state)
        _G.NoClip = state
        if state then
            WindUI:Notification({
                Title = "No Clip",
                Description = "👻 تم التفعيل! يمكنك المشي عبر الجدران",
                Duration = 3
            })
            spawn(function()
                while _G.NoClip do
                    wait(0.1)
                    pcall(function()
                        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                end
            end)
        else
            pcall(function()
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
})

-- ===================== VISUAL TAB =====================
local VisualTab = Window:CreateTab({
    Title = "👁️ الرؤية",
    Icon = "eye"
})

VisualTab:AddSection("🎨 تحسينات بصرية")

VisualTab:AddToggle({
    Title = "ESP (رؤية اللاعبين)",
    Description = "رؤية اللاعبين عبر الجدران",
    Default = false,
    Callback = function(state)
        _G.ESP = state
        if state then
            WindUI:Notification({
                Title = "ESP",
                Description = "👁️ تم التفعيل! يمكنك رؤية اللاعبين",
                Duration = 3
            })
            spawn(function()
                while _G.ESP do
                    wait(1)
                    pcall(function()
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player ~= game.Players.LocalPlayer then
                                local char = player.Character
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    local highlight = char:FindFirstChild("MIX_Highlight") or Instance.new("Highlight")
                                    highlight.Name = "MIX_Highlight"
                                    highlight.FillColor = Color3.fromRGB(0, 255, 170) -- MIX Green
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.Parent = char
                                end
                            end
                        end
                    end)
                end
            end)
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("MIX_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
})

VisualTab:AddToggle({
    Title = "إضاءة كاملة",
    Description = "إزالة كل الظلام",
    Default = false,
    Callback = function(state)
        if state then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
            WindUI:Notification({
                Title = "إضاءة كاملة",
                Description = "💡 تم التفعيل! كل شيء مضيء",
                Duration = 3
            })
        else
            game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            game.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            game.Lighting.Brightness = 1
            game.Lighting.GlobalShadows = true
        end
    end
})

VisualTab:AddToggle({
    Title = "تحسين الأداء (FPS)",
    Description = "تحسين أداء اللعبة",
    Default = false,
    Callback = function(state)
        if state then
            local settings = game:GetService("UserGameSettings")
            settings.SavedQualityLevel = 1
            settings.MasterVolume = 0
            settings.GraphicsQualityLevel = 1
            
            WindUI:Notification({
                Title = "تحسين الأداء",
                Description = "⚡ تم تحسين الأداء! FPS أعلى",
                Duration = 3
            })
        else
            local settings = game:GetService("UserGameSettings")
            settings.SavedQualityLevel = 10
            settings.MasterVolume = 1
            settings.GraphicsQualityLevel = 10
        end
    end
})

-- ===================== FARMING TAB =====================
local FarmingTab = Window:CreateTab({
    Title = "💰 التطوير",
    Icon = "dollar-sign"
})

FarmingTab:AddSection("🌾 الفارم الآلي")

FarmingTab:AddToggle({
    Title = "فارم انتصارات آلي",
    Description = "يفرم الانتصارات تلقائياً",
    Default = false,
    Callback = function(state)
        _G.AutoFarmWins = state
        if state then
            WindUI:Notification({
                Title = "فارم آلي",
                Description = "🤖 بدأ الفارم الآلي",
                Duration = 3
            })
            spawn(function()
                while _G.AutoFarmWins do
                    wait(5)
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        local randomPos = Vector3.new(
                            math.random(-200, 200),
                            20,
                            math.random(-200, 200)
                        )
                        char:MoveTo(randomPos)
                    end)
                end
            end)
        end
    end
})

FarmingTab:AddToggle({
    Title = "فارم AFK",
    Description = "يفرم وأنت بعيد",
    Default = false,
    Callback = function(state)
        _G.AFKFarm = state
        if state then
            WindUI:Notification({
                Title = "AFK Farm",
                Description = "😴 يمكنك ترك اللعبة مفتوحة",
                Duration = 3
            })
            spawn(function()
                while _G.AFKFarm do
                    wait(10)
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                            math.random(-300, 300),
                            30,
                            math.random(-300, 300)
                        )
                    end)
                end
            end)
        end
    end
})

FarmingTab:AddButton({
    Title = "جمع كل العناصر",
    Description = "يجمع كل الهدايا والعملات",
    Callback = function()
        local collected = 0
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name:match("Gift") or item.Name:match("Box") or item.Name:match("Coin") then
                if item:IsA("BasePart") then
                    local prompt = item:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        collected = collected + 1
                    end
                end
            end
        end
        WindUI:Notification({
            Title = "العناصر",
            Description = "🎁 تم جمع " .. collected .. " عنصر",
            Duration = 3
        })
    end
})

-- ===================== UTILITIES TAB =====================
local UtilTab = Window:CreateTab({
    Title = "⚙️ أدوات",
    Icon = "settings"
})

UtilTab:AddSection("🔧 أدوات مساعدة")

UtilTab:AddButton({
    Title = "إعادة الانضمام للسيرفر",
    Description = "إعادة دخول السيرفر الحالي",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
        WindUI:Notification({
            Title = "إعادة الانضمام",
            Description = "🔄 يعيد الاتصال...",
            Duration = 3
        })
    end
})

UtilTab:AddButton({
    Title = "نسخ الديسكورد",
    Description = "نسخ رابط ديسكورد MIX",
    Callback = function()
        setclipboard("MIX#0001")
        WindUI:Notification({
            Title = "الديسكورد",
            Description = "📋 تم النسخ: MIX#0001",
            Duration = 3
        })
    end
})

UtilTab:AddToggle({
    Title = "منع الطرد (Anti-AFK)",
    Description = "يمنع طردك بسبب الخمول",
    Default = false,
    Callback = function(state)
        if state then
            WindUI:Notification({
                Title = "Anti-AFK",
                Description = "🛡️ لن تطرد بسبب الخمول",
                Duration = 3
            })
            spawn(function()
                while wait(30) do
                    pcall(function()
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)
        end
    end
})

-- ===================== CREDITS TAB =====================
local CreditsTab = Window:CreateTab({
    Title = "👑 الاعتمادات",
    Icon = "award"
})

CreditsTab:AddSection("🎮 MIX EVADE HUB")

CreditsTab:AddLabel("المطور: MIX")
CreditsTab:AddLabel("الإصدار: 2.0 WindUI")
CreditsTab:AddLabel("الواجهة: WindUI Library")
CreditsTab:AddLabel("©️ 2024 جميع الحقوق محفوظة")

CreditsTab:AddButton({
    Title = "نسخ رابط السكربت",
    Description = "نسخ رابط هذا السكربت",
    Callback = function()
        setclipboard("https://raw.githubusercontent.com/Footagesus/WindUI/main/main_example.lua")
        WindUI:Notification({
            Title = "الرابط",
            Description = "📋 تم نسخ رابط WindUI",
            Duration = 3
        })
    end
})

CreditsTab:AddButton({
    Title = "تحديث السكربت",
    Description = "تحقق من التحديثات",
    Callback = function()
        WindUI:Notification({
            Title = "التحديث",
            Description = "🔄 يجري التحقق من التحديثات...",
            Duration = 3
        })
    end
})

-- ===================== INITIALIZATION =====================
-- Wait a moment then show welcome
wait(1)

WindUI:Notification({
    Title = "🎉 MIX EVADE HUB",
    Description = "✅ تم تحميل السكربت بنجاح!\n👤 المطور: MIX\n🎮 استمتع باللعبة!",
    Duration = 5
})

-- Print to console
print("\n" .. string.rep("=", 50))
print("🎮 MIX WindUI HUB v2.0")
print("👤 Developer: MIX")
print("🎨 UI: WindUI Library")
print("🔥 Features: 20+ Amazing Features")
print(string.rep("=", 50))

-- Success message
print("[MIX HUB] WindUI script loaded successfully!")
