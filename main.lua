--=====================================================================
-- DELTA X ULTIMATE UI FRAMEWORK (LUA)
--=====================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

-- متغيرات الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Delta_X_Ultimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- الألوان والتصميم
local Colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 122, 212), -- Delta Blue
    Text = Color3.fromRGB(255, 255, 255),
    Green = Color3.fromRGB(0, 200, 0),
    Red = Color3.fromRGB(200, 0, 0)
}

--=====================================================================
-- بناء الواجهة الرئيسية (UI Construction)
--=====================================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Colors.Main
MainFrame.Parent = ScreenGui
MainFrame.BorderSizePixel = 0

-- تقريب الحواف
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 50)

-- منطقة السحب (Drag)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Colors.Accent
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

-- تصحيح الزوايا السفلية للشريط
local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingBottom = UDim.new(0, 10)
TitlePadding.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DELTA X // ULTIMATE"
TitleLabel.TextColor3 = Colors.Text
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- منطقة التخطيط (Layout)
local LayoutFrame = Instance.new("Frame")
LayoutFrame.Size = UDim2.new(1, 0, 1, -40)
LayoutFrame.Position = UDim2.new(0, 0, 0, 40)
LayoutFrame.BackgroundTransparency = 1
LayoutFrame.Parent = MainFrame

-- الشريط الجانبي (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Colors.Secondary
Sidebar.Parent = LayoutFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- منطقة المحتوى (Content Area)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -150, 1, -10)
ContentFrame.Position = UDim2.new(0, 145, 0, 5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = LayoutFrame

-- قائمة التبويبات
local TabsList = {
    {Name = "Auto Farm", Icon = "🌾"},
    {Name = "Player", Icon = "🏃"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "Server", Icon = "🌐"}
}

local ActiveTab = nil

--=====================================================================
-- وظائف مساعدة لإنشاء العناصر (UI Builders)
--=====================================================================

local function CreateToggle(Parent, Text, Callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 35)
    Container.BackgroundColor3 = Colors.Main
    Container.BorderSizePixel = 0
    Container.Parent = Parent
    Container.LayoutOrder = Parent:GetChildren()[1] and Parent:GetChildren()[1].LayoutOrder + 1 or 0

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Colors.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    local State = false
    
    Btn.MouseButton1Click:Connect(function()
        State = not State
        Btn.BackgroundColor3 = State and Colors.Green or Color3.fromRGB(60, 60, 60)
        Callback(State)
    end)
end

local function CreateButton(Parent, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 30)
    Btn.BackgroundColor3 = Colors.Accent
    Btn.TextColor3 = Colors.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Text = Text
    Btn.Parent = Parent
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    Btn.MouseButton1Click:Connect(function()
        Callback()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play()
    end)
end

local function CreateSection(Parent, Title)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 25)
    Section.BackgroundTransparency = 1
    Section.Text = Title
    Section.TextColor3 = Colors.Accent
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 15
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = Parent
    return Section
end

--=====================================================================
-- إعداد التبويبات والمحتوى
--=====================================================================

-- وظيفة إنشاء التبويب
local function SetupTab(index, tabName, icon)
    -- زر التبويب في القائمة الجانبية
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.Position = UDim2.new(0, 0, 0, (index-1)*42)
    Btn.BackgroundTransparency = 1
    Btn.Text = "  "..icon.." "..tabName
    Btn.TextColor3 = Colors.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Sidebar

    -- المحتوى الخاص بالتبويب
    local TabContent = Instance.new("Frame")
    TabContent.Name = tabName
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = ContentFrame

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentFrame:GetChildren()) do v.Visible = false end
        TabContent.Visible = true
        ActiveTab = TabContent
        -- تحديث لون الزر النشط
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Colors.Text end
        end
        Btn.TextColor3 = Colors.Accent
    end)

    return TabContent
end

-- إنشاء التبويبات
local TabFarm = SetupTab(1, "Auto Farm", "🌾")
local TabPlayer = SetupTab(2, "Player", "🏃")
local TabVisuals = SetupTab(3, "Visuals", "👁️")
local TabServer = SetupTab(4, "Server", "🌐")

-- تعيين التبويب الافتراضي
ActiveTab = TabFarm
TabFarm.Visible = true
Sidebar:GetChildren()[2].TextColor3 = Colors.Accent -- تحديث لون أول زر

--=====================================================================
-- تعبئة المحتوى (Populating Content)
--=====================================================================

-- === 1. AUTO FARM TAB ===
CreateSection(TabFarm, "Automation")
CreateToggle(TabFarm, "Auto Farm XP", function(v) print("Auto Farm XP:", v) end)
CreateToggle(TabFarm, "Auto Farm Cash", function(v) print("Auto Farm Cash:", v) end)
CreateToggle(TabFarm, "Auto Farm Collectables", function(v) print("Auto Farm Collectables:", v) end)

CreateSection(TabFarm, "Game Actions")
CreateToggle(TabFarm, "Auto Instant Revive", function(v) print("Auto Revive:", v) end)
CreateToggle(TabFarm, "Auto Carry", function(v) print("Auto Carry:", v) end)
CreateToggle(TabFarm, "Auto Respawn", function(v) print("Auto Respawn:", v) end)
CreateToggle(TabFarm, "Auto Interact", function(v) print("Auto Interact:", v) end)
CreateToggle(TabFarm, "Auto Use Cola", function(v) print("Auto Use Cola:", v) end)
CreateToggle(TabFarm, "Auto Whistling", function(v) print("Auto Whistling:", v) end)

CreateSection(TabFarm, "Game Info")
local lblStatus = Instance.new("TextLabel")
lblStatus.Size = UDim2.new(1,0,0,30); lblStatus.BackgroundColor3=Colors.Secondary; lblStatus.Text="Status: Waiting..."
lblStatus.TextColor3=Colors.Text; lblStatus.Parent=TabFarm; Instance.new("UICorner", lblStatus).CornerRadius=UDim.new(0,4)
-- محاكاة تحديث الحالة
spawn(function() while true do wait(1) lblStatus.Text = "Round Time: "..tick().. " | Game Status: Active" end end)

-- === 2. PLAYER TAB ===
CreateSection(TabPlayer, "Movement Modifiers")
CreateToggle(TabPlayer, "Fly", function(v) 
    -- منطق الطيران البسيط (مثال)
    local char = LocalPlayer.Character
    if v and char then
        -- هنا يضع المستخدم كود الطيران الكامل
    end
    print("Fly:", v)
end)
CreateToggle(TabPlayer, "Bhop (Bunny Hop)", function(v) print("Bhop:", v) end)
CreateToggle(TabPlayer, "Infinite Jump", function(v) 
    if v then
        UserInputService.JumpRequest:connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)
CreateToggle(TabPlayer, "No Clip", function(v) print("No Clip:", v) end)

CreateSection(TabPlayer, "Attributes")
CreateButton(TabPlayer, "Max WalkSpeed", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)
CreateButton(TabPlayer, "Max JumpPower", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 200
    end
end)
CreateButton(TabPlayer, "Set Hip Height", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.HipHeight = 10
    end
end)

-- === 3. VISUALS TAB ===
CreateSection(TabVisuals, "Performance")
CreateButton(TabVisuals, "FPS Boost (Low Graphics)", function()
    settings()["Rendering"].QualityLevel = 1
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    print("FPS Boost Activated")
end)
CreateToggle(TabVisuals, "No Camera Shake", function(v) 
    -- تعديل إعدادات الكاميرا يتطلب تغيير CameraShake
    print("No Shake:", v) 
end)
CreateToggle(TabVisuals, "No Light Flicker", function(v) print("No Flicker:", v) end)

CreateSection(TabVisuals, "World")
CreateToggle(TabVisuals, "Full Bright", function(v)
    if v then
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = 1 -- أو الإعدادات الافتراضية
    end
end)
CreateToggle(TabVisuals, "Remove Darkness", function(v) Lighting.ClockTime = 12 end)
CreateToggle(TabVisuals, "Remove Fog", function(v) Lighting.FogEnd = 999999 end)

CreateSection(TabVisuals, "ESP System")
CreateToggle(TabVisuals, "ESP Boxes", function(v) print("ESP Boxes:", v) end)
CreateToggle(TabVisuals, "ESP Names", function(v) print("ESP Names:", v) end)
CreateToggle(TabVisuals, "ESP Health", function(v) print("ESP Health:", v) end)
CreateToggle(TabVisuals, "ESP Tool", function(v) print("ESP Tool:", v) end)
CreateToggle(TabVisuals, "Players Highlight", function(v) print("Highlight:", v) end)
CreateToggle(TabVisuals, "Rainbow Highlight", function(v) print("Rainbow:", v) end)

-- === 4. SERVER TAB ===
CreateSection(TabServer, "Utilities")
CreateToggle(TabServer, "Show Global Chat", function(v) print("Global Chat:", v) end)
CreateToggle(TabServer, "Auto Random Vote", function(v) print("Auto Vote:", v) end)

CreateSection(TabServer, "Actions")
CreateButton(TabServer, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
CreateButton(TabServer, "Server Hop", function()
    -- كود ServerHop يتطلب قائمة سيرفرات
    print("Server Hopping...")
end)
CreateButton(TabServer, "Redeem All Codes", function()
    print("Redeeming codes... (Game Specific)")
end)
CreateButton(TabServer, "Save Config", function() print("Config Saved") end)

--=====================================================================
-- منطق السحب (Draggable Logic) - نفس السابق
--=====================================================================
local dragToggle, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and TitleBar:IsAncestorOf(input) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- تحديث حجم الـ Content Frame بناء على المحتوى
local function updateCanvasSize()
    for _, tab in pairs(ContentFrame:GetChildren()) do
        local y = 0
        for _, child in pairs(tab:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                y = y + child.AbsoluteSize.Y + 5
            end
        end
        tab.CanvasSize = UDim2.new(0, 0, 0, y)
    end
end
spawn(function() while wait(1) do updateCanvasSize() end end)
