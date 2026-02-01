-- Delta Hub - Enhanced Version with All Features
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabFrame = Instance.new("Frame")
local TabButtons = {}
local TabContents = {}
local CloseButton = Instance.new("TextButton")

-- إعدادات الشاشة
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "DeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true

-- تأثير الظل
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0, 5, 0, 5)
Shadow.Size = UDim2.new(1, 0, 1, 0)
Shadow.ZIndex = 1
Shadow.BackgroundTransparency = 0.7

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "DELTA HUB - ENHANCED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.ZIndex = 2

-- زر الإغلاق
CloseButton.Name = "CloseButton"
CloseButton.Parent = Title
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 7)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.ZIndex = 3
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- إطار التبويبات
TabFrame.Name = "TabFrame"
TabFrame.Parent = MainFrame
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TabFrame.BorderSizePixel = 0
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.Size = UDim2.new(1, 0, 0, 35)

-- إطار المحتوى
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 0, 0, 75)
ContentFrame.Size = UDim2.new(1, 0, 1, -75)

-- دالة إنشاء التبويبات
local function createTab(name, icon)
    -- زر التبويب
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabFrame
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0, 108, 1, 0)
    TabButton.Position = UDim2.new(0, #TabButtons * 108, 0, 0)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 11
    TabButton.ZIndex = 3
    
    -- تأثيرات الماوس
    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundColor3 == Color3.fromRGB(50, 50, 70) and not TabButton.Active then
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
    end)
    
    table.insert(TabButtons, TabButton)
    
    -- محتوى التبويب
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentFrame
    TabContent.Visible = (#TabButtons == 1)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 8
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    TabContent.ZIndex = 2
    
    table.insert(TabContents, TabContent)
    
    -- معالج النقر على التبويب
    TabButton.MouseButton1Click:Connect(function()
        -- إخفاء كل المحتويات
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        
        -- إعادة تعيين ألوان الأزرار
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
            button.Active = false
        end
        
        -- إظهار المحتوى المحدد
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Active = true
    end)
    
    return TabContent
end

-- دالة إنشاء الأزرار
local function createButton(parent, name, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.ZIndex = 2
    
    -- تأثيرات الماوس
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    -- تحديث حجم القماشة
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40)
    
    return btn
end

-- دالة إنشاء التقلبات (Toggles)
local function createToggle(parent, name, callback, defaultState)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.ZIndex = 2
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Text = defaultState and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.ZIndex = 3
    
    local state = defaultState
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    -- تحديث حجم القماشة
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40)
    
    return toggle, state
end

-- دالة إنشاء السلايدر
local function createSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 50)
    frame.ZIndex = 2
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    
    local slider = Instance.new("TextButton")
    slider.Parent = frame
    slider.Size = UDim2.new(0.8, 0, 0, 10)
    slider.Position = UDim2.new(0.1, 0, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    slider.BorderSizePixel = 0
    slider.Text = ""
    slider.ZIndex = 3
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = slider
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 4
    
    local value = default
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        relativeX = math.max(0, math.min(1, relativeX))
        value = min + (max - min) * relativeX
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        label.Text = name .. ": " .. math.floor(value)
        callback(value)
    end
    
    slider.MouseButton1Down:Connect(function()
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
        
        updateSlider(game:GetService("UserInputService"):GetMouseLocation())
    end)
    
    -- تحديث حجم القماشة
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40)
    
    return slider, value
end

-- دالة إنشاء حقل إدخال
local function createInput(parent, name, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.ZIndex = 2
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    
    local input = Instance.new("TextBox")
    input.Parent = frame
    input.Size = UDim2.new(0.6, 0, 0, 25)
    input.Position = UDim2.new(0.35, 0, 0.5, -12)
    input.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.ZIndex = 3
    
    input.FocusLost:Connect(function()
        callback(input.Text)
    end)
    
    -- تحديث حجم القماشة
    parent.CanvasSize = UDim2.new(0, 0, 0, #parent:GetChildren() * 40)
    
    return input
end

-- إنشاء التبويبات
local movementTab = createTab("Movement", "🏃")
local visualTab = createTab("Visuals", "👁️")
local combatTab = createTab("Combat", "⚔️")
local miscTab = createTab("Misc", "🔧")
local serverTab = createTab("Server", "🌐")
local uiTab = createTab("UI", "🖥️")

-- تفعيل أول تبويب
if TabButtons[1] then
    TabButtons[1].BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButtons[1].Active = true
end

-- قسم الحركة
createToggle(movementTab, "Fly (Touch)", function(state)
    _G.Flying = state
    if state then
        local p = game.Players.LocalPlayer
        local c = p.Character or p.CharacterAdded:Wait()
        local h = c:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", h)
        bv.MaxForce = Vector3.new(0,0,0)
        
        local uis = game:GetService("UserInputService")
        uis.TouchStarted:Connect(function() 
            if _G.Flying then 
                bv.MaxForce = Vector3.new(9e9,9e9,9e9) 
            end
        end)
        
        uis.TouchEnded:Connect(function() 
            if _G.Flying then 
                bv.MaxForce = Vector3.new(0,0,0) 
            end
        end)
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if _G.Flying then 
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50 
            end
        end)
    end
end, false)

createToggle(movementTab, "Noclip (Touch)", function(state)
    _G.Noclip = state
    if state then
        local noclip = false
        local p = game.Players.LocalPlayer
        
        game:GetService("UserInputService").InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                noclip = not noclip
            end
        end)
        
        game:GetService("RunService").Stepped:Connect(function()
            if _G.Noclip then
                for _,v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end, false)

createSlider(movementTab, "Walk Speed", 16, 200, 100, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end)

createToggle(movementTab, "Infinite Jump", function(state)
    _G.InfiniteJump = state
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end, false)

createToggle(movementTab, "Low Gravity", function(state)
    _G.LowGravity = state
    if state then
        local on = true
        game:GetService("UserInputService").InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                on = not on
                workspace.Gravity = on and 196.2 or 50
            end
        end)
    else
        workspace.Gravity = 196.2
    end
end, false)

-- قسم الرؤية
createToggle(visualTab, "Player Highlights", function(state)
    _G.PlayerHighlights = state
    if state then
        local lp = game.Players.LocalPlayer
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255,0,0)
            end
            p.CharacterAdded:Connect(function(c)
                if _G.PlayerHighlights then
                    Instance.new("Highlight", c).FillColor = Color3.fromRGB(255,0,0)
                end
            end)
        end
    else
        for _,h in pairs(workspace:GetDescendants()) do
            if h:IsA("Highlight") then
                h:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Fullbright", function(state)
    _G.Fullbright = state
    if state then
        local l = game.Lighting
        l.Brightness = 2
        l.Ambient = Color3.new(1,1,1)
        l.FogEnd = 1e5
    else
        local l = game.Lighting
        l.Brightness = 1
        l.Ambient = Color3.new(0,0,0)
        l.FogEnd = 1000
    end
end, false)

createToggle(visualTab, "Name ESP", function(state)
    _G.NameESP = state
    if state then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local b = Instance.new("BillboardGui", p.Character.Head)
                b.Size = UDim2.new(0,100,0,40)
                b.AlwaysOnTop = true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0)
                t.Text = p.Name
                t.TextColor3 = Color3.new(1,1,1)
                t.BackgroundTransparency = 1
            end
        end
    else
        for _,b in pairs(workspace:GetDescendants()) do
            if b:IsA("BillboardGui") and b:FindFirstChildWhichIsA("TextLabel") then
                b:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Health Bar ESP", function(state)
    _G.HealthESP = state
    if state then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local h = p.Character.Humanoid
                local b = Instance.new("BillboardGui", p.Character.HumanoidRootPart)
                b.Size = UDim2.new(0,100,0,20)
                b.AlwaysOnTop = true
                local f = Instance.new("Frame", b)
                f.Size = UDim2.new(h.Health/h.MaxHealth,0,1,0)
                f.BackgroundColor3 = Color3.fromRGB(0,255,0)
            end
        end
    else
        for _,b in pairs(workspace:GetDescendants()) do
            if b:IsA("BillboardGui") and b:FindFirstChildWhichIsA("Frame") then
                b:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Chams", function(state)
    _G.Chams = state
    if state then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineColor = Color3.fromRGB(255,255,255)
                h.FillTransparency = 0.7
            end
        end
    else
        for _,h in pairs(workspace:GetDescendants()) do
            if h:IsA("Highlight") and h.FillTransparency == 0.7 then
                h:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Tracers", function(state)
    _G.Tracers = state
    if state then
        local cam = workspace.CurrentCamera
        local lp = game.Players.LocalPlayer
        local lines = {}
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if not _G.Tracers then
                for _,line in pairs(lines) do
                    line:Remove()
                end
                lines = {}
                return
            end
            
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                    line.To = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    line.Color = Color3.fromRGB(255,0,0)
                    line.Thickness = 2
                    line.Visible = true
                    table.insert(lines, line)
                end
            end
        end)
    end
end, false)

createToggle(visualTab, "Box ESP", function(state)
    _G.BoxESP = state
    if state then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                for _,v in pairs(p.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        local a = Instance.new("BoxHandleAdornment", v)
                        a.Size = v.Size
                        a.Adornee = v
                        a.Color3 = Color3.fromRGB(255,255,255)
                        a.AlwaysOnTop = true
                        a.ZIndex = 5
                        a.Transparency = 0.5
                    end
                end
            end
        end
    else
        for _,a in pairs(workspace:GetDescendants()) do
            if a:IsA("BoxHandleAdornment") then
                a:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Item ESP", function(state)
    _G.ItemESP = state
    if state then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") or v.Name == "Item" then
                local h = Instance.new("Highlight", v)
                h.FillColor = Color3.fromRGB(255,255,0)
                h.OutlineColor = Color3.fromRGB(255,255,255)
            end
        end
    else
        for _,h in pairs(workspace:GetDescendants()) do
            if h:IsA("Highlight") and h.FillColor == Color3.fromRGB(255,255,0) then
                h:Destroy()
            end
        end
    end
end, false)

createToggle(visualTab, "Alternative Fullbright", function(state)
    _G.AltFullbright = state
    if state then
        local l = game.Lighting
        l.Brightness = 3
        l.Ambient = Color3.fromRGB(178,255,178)
    else
        local l = game.Lighting
        l.Brightness = 1
        l.Ambient = Color3.new(0,0,0)
    end
end, false)

createToggle(visualTab, "Head Hitbox Expander", function(state)
    _G.HeadHitbox = state
    if state then
        local lp = game.Players.LocalPlayer
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    else
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                p.Character.HumanoidRootPart.Transparency = 0
                p.Character.HumanoidRootPart.CanCollide = true
            end
        end
    end
end, false)

createSlider(visualTab, "FOV", 70, 120, 90, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

-- قسم القتال
createToggle(combatTab, "Aimbot", function(state)
    _G.Aimbot = state
    if state then
        local cam = workspace.CurrentCamera
        local lp = game.Players.LocalPlayer
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if not _G.Aimbot then return end
            
            local closest, dist = nil, math.huge
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (cam.CFrame.Position - p.Character.Head.Position).Magnitude
                    if d < dist then 
                        closest = p.Character.Head 
                        dist = d 
                    end
                end
            end
            if closest then 
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position) 
            end
        end)
    end
end, false)

createToggle(combatTab, "Auto Clicker", function(state)
    _G.AutoClicker = state
    if state then
        local lp = game.Players.LocalPlayer
        local mouse = lp:GetMouse()
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if not _G.AutoClicker then return end
            
            if mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
                mouse1press()
                wait(0.1)
                mouse1release()
            end
        end)
    end
end, false)

createButton(combatTab, "Shoot Event Exploit", function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == "FireServer" and self.Name == "ShootEvent" then
            local closest = nil
            for _,p in pairs(game.Players:GetPlayers()) do
                if p.Character then 
                    closest = p.Character.Head 
                end
            end
            args[2] = closest.Position
            return old(self, unpack(args))
        end
        return old(self, ...)
    end)
end, Color3.fromRGB(200, 50, 50))

createToggle(combatTab, "Tap to Aim", function(state)
    _G.TapAim = state
    if state then
        local cam = workspace.CurrentCamera
        local uis = game:GetService("UserInputService")
        
        uis.TouchTap:Connect(function()
            if not _G.TapAim then return end
            
            local closest, dist = nil, math.huge
            for _,p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local d = (cam.CFrame.Position - p.Character.Head.Position).Magnitude
                    if d < dist then 
                        closest = p.Character.Head 
                        dist = d 
                    end
                end
            end
            if closest then 
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position) 
            end
        end)
    end
end, false)

createInput(combatTab, "Kill Player", "PlayerName", function(text)
    local target = game.Players:FindFirstChild(text)
    if target and target.Character then
        target.Character.Humanoid.Health = 0
    end
end)

-- قسم الأدوات المساعدة
createToggle(miscTab, "Camera Movement", function(state)
    _G.CameraMovement = state
    if state then
        local cam = workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Scriptable
        local uis = game:GetService("UserInputService")
        
        uis.InputBegan:Connect(function(i)
            if not _G.CameraMovement then return end
            
            if i.KeyCode == Enum.KeyCode.W then
                cam.CFrame = cam.CFrame * CFrame.new(0,0,-5)
            end
        end)
    else
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end, false)

createToggle(miscTab, "Anti-AFK", function(state)
    _G.AntiAFK = state
    if state then
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            if not _G.AntiAFK then return end
            
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end, true)

createButton(miscTab, "Server Hop", function()
    local ts = game:GetService("TeleportService")
    local servers = ts:GetPublicServers(game.PlaceId, 0)
    for _,s in pairs(servers:GetChildren()) do
        if s.Playing < s.MaxPlayers then
            ts:TeleportToPlaceInstance(game.PlaceId, s.Guid)
            break
        end
    end
end, Color3.fromRGB(100, 100, 255))

createToggle(miscTab, "Chat Spam", function(state)
    _G.ChatSpam = state
    if state then
        spawn(function()
            while _G.ChatSpam do
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Message", "All")
                wait(1)
            end
        end)
    end
end, false)

createInput(miscTab, "Loadstring", "Script URL", function(text)
    if text and text ~= "" then
        loadstring(game:HttpGet(text))()
    end
end)

-- قسم الخادم
createButton(serverTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end, Color3.fromRGB(100, 100, 255))

createButton(serverTab, "Join Random Server", function()
    local ts = game:GetService("TeleportService")
    local servers = ts:GetPublicServers(game.PlaceId, 0)
    if #servers:GetChildren() > 0 then
        local randomServer = servers:GetChildren()[math.random(1, #servers:GetChildren())]
        ts:TeleportToPlaceInstance(game.PlaceId, randomServer.Guid)
    end
end, Color3.fromRGB(100, 100, 255))

-- قسم الواجهة
createButton(uiTab, "Show Controls", function()
    local sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    sg.Name = "Controls"
    local t = Instance.new("TextLabel", sg)
    t.Size = UDim2.new(0,200,0,100)
    t.Position = UDim2.new(0,10,0,10)
    t.Text = "Q - Fly\nE - Noclip\nX - Speed"
    t.TextColor3 = Color3.new(1,1,1)
    t.BackgroundTransparency = 0.5
    
    game:GetService("Debris"):AddItem(sg, 5)
end, Color3.fromRGB(100, 100, 255))

createButton(uiTab, "Toggle UI", function()
    local state = not ScreenGui.Enabled
    ScreenGui.Enabled = state
    for _,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("ScreenGui") and v.Name ~= "Controls" then
            v.Enabled = state
        end
    end
end, Color3.fromRGB(100, 100, 255))

createButton(uiTab, "Brain Rot UI", function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Create UI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainRotUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    title.Text = "Brain Rot UI"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame

    -- Sky Button
    local skyBtn = Instance.new("TextButton")
    skyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    skyBtn.Position = UDim2.new(0.05, 0, 0, 50)
    skyBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
    skyBtn.Text = "⬆ Teleport to Sky"
    skyBtn.TextColor3 = Color3.new(1, 1, 1)
    skyBtn.Font = Enum.Font.GothamBold
    skyBtn.TextSize = 16
    skyBtn.Parent = mainFrame

    skyBtn.MouseButton1Click:Connect(function()
        if humanoidRootPart then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 1000, 0)
        end
    end)

    -- ESP Toggle
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(0.9, 0, 0, 40)
    espBtn.Position = UDim2.new(0.05, 0, 0, 100)
    espBtn.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
    espBtn.Text = "ESP: OFF"
    espBtn.TextColor3 = Color3.new(1, 1, 1)
    espBtn.Font = Enum.Font.GothamBold
    espBtn.TextSize = 16
    espBtn.Parent = mainFrame

    local espEnabled = false
    local espHighlights = {}

    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
        
        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    if not espHighlights[plr] then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = plr.Character
                        espHighlights[plr] = highlight
                    end
                end
            end
        else
            for _, highlight in pairs(espHighlights) do
                highlight:Destroy()
            end
            espHighlights = {}
        end
    end)

    -- Player List
    local playerList = Instance.new("ScrollingFrame")
    playerList.Size = UDim2.new(0.9, 0, 0, 200)
    playerList.Position = UDim2.new(0.05, 0, 0, 150)
    playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    playerList.BorderSizePixel = 0
    playerList.ScrollBarThickness = 6
    playerList.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = playerList

    -- Update player list
    local function updatePlayerList()
        for _, child in pairs(playerList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = playerList

                btn.MouseButton1Click:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        humanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                    end
                end)
            end
        end

        playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end

    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    updatePlayerList()

    -- Make draggable
    local dragging, dragInput, dragStart, startPos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end, Color3.fromRGB(100, 100, 255))

createButton(uiTab, "Custom UI", function()
    local sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0,150,0,200)
    f.Position = UDim2.new(0.9,0,0.3,0)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1,0,0,40)
    b.Text = "Fly"
    b.TextColor3 = Color3.new(1,1,1)
    
    b.MouseButton1Click:Connect(function()
        -- Fly functionality here
    end)
end, Color3.fromRGB(100, 100, 255))

-- رسالة ترحيب
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Parent = MainFrame
WelcomeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WelcomeLabel.BackgroundTransparency = 0.5
WelcomeLabel.BorderSizePixel = 0
WelcomeLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
WelcomeLabel.Size = UDim2.new(0, 300, 0, 50)
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.Text = "Delta Hub Enhanced Loaded!"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.TextSize = 16
WelcomeLabel.ZIndex = 10

-- إخفاء رسالة الترحيب بعد 3 ثواني
task.wait(3)
WelcomeLabel:TweenPosition(UDim2.new(0.5, -150, 0.5, -100), "Out", "Quad", 0.5, true)
task.wait(0.5)
WelcomeLabel:Destroy()

print("Delta Hub Enhanced - Successfully Loaded!")
