-- [[ VERTEX PROJECT | UPDATED VERSION ]]

_G.VertexScript = function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
       Name = "🚀 VERTEX | ELITE PANEL",
       LoadingTitle = "⚡ VERTEX PROJECT ⚡", 
       KeySystem = false 
    })

    -- VARIABLES
    local player = game.Players.LocalPlayer
    local runService = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local Mouse = player:GetMouse()
    
    local noclip, flying, flyspeed = false, false, 50
    _G.HeadSize = 20
    _G.HitboxEnabled, _G.SpeedActive, _G.SpeedPower = false, false, 0.5
    
    -- ARSENAL SYSTEM STATUS
    _G.ArsenalMaster = false
    _G.FovRadius = 150
    _G.WallCheck = true
    _G.AimPart = "Head"
    _G.TeamCheck = true 

    -- FOV CIRCLE
    local FovCircle = Drawing.new("Circle")
    FovCircle.Visible = false
    FovCircle.Radius = _G.FovRadius
    FovCircle.Color = Color3.fromRGB(255, 255, 255)
    FovCircle.Thickness = 1

    -- --- GO UP WITH SPACE ---
    local upSpeed = 2 
    runService.Heartbeat:Connect(function()
        if uis:IsKeyDown(Enum.KeyCode.Space) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Velocity = Vector3.new(
                    player.Character.HumanoidRootPart.Velocity.X, 
                    upSpeed * 25, 
                    player.Character.HumanoidRootPart.Velocity.Z
                )
            end
        end
    end)

    -- --- AIMBOT & ESP SYSTEM ---
    local function IsNotBehindWall(targetPart)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {player.Character, targetPart.Parent}
        local rayDirection = (targetPart.Position - Camera.CFrame.Position).Unit * (targetPart.Position - Camera.CFrame.Position).Magnitude
        local raycastResult = workspace:Raycast(Camera.CFrame.Position, rayDirection, rayParams)
        return raycastResult == nil
    end

    local function GetClosestTarget()
        local target = nil
        local shortestDistance = _G.FovRadius
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild(_G.AimPart) then
                if _G.TeamCheck and p.Team == player.Team then continue end
                
                local part = p.Character[_G.AimPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance < shortestDistance then
                        if not _G.WallCheck or IsNotBehindWall(part) then
                            shortestDistance = distance
                            target = part
                        end
                    end
                end
            end
        end
        return target
    end

    local highlights = {}
    local function UpdateESP()
        for _, p in pairs(Players:GetPlayers()) do
            if _G.ArsenalMaster and p ~= player and p.Character then
                if not highlights[p] then
                    local h = Instance.new("Highlight")
                    h.FillTransparency = 0.5
                    h.OutlineTransparency = 0
                    highlights[p] = h
                end
                highlights[p].Parent = p.Character
                highlights[p].FillColor = (p.Team == player.Team) and Color3.new(0,0,1) or Color3.new(1,0,0)
            else
                if highlights[p] then highlights[p].Parent = nil end
            end
        end
    end

    -- MAIN LOOP
    runService.RenderStepped:Connect(function()
        FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FovCircle.Radius = _G.FovRadius
        FovCircle.Visible = _G.ArsenalMaster
        UpdateESP()
        
        -- Aimbot
        if _G.ArsenalMaster and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local target = GetClosestTarget()
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
        end
    end)

    -- TABS
    local Tab1 = Window:CreateTab("🛡️ ADMIN", 4483362458)
    local Tab2 = Window:CreateTab("🔥 MAIN SCRIPTS", 4483362458)
    local Tab3 = Window:CreateTab("📁 FILE 3", 4483362458)
    local Tab4 = Window:CreateTab("⚙️ SETTINGS", 4483362458)

    -- --- TAB 1: ADMIN ---
    Tab1:CreateSection("👑 Admin Menus")
    Tab1:CreateButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})
    Tab1:CreateButton({Name = "Nameless Admin", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end})

    -- --- TAB 2: MAIN SCRIPTS ---
    Tab2:CreateSection("🏎️ Movement & Speed")
    Tab2:CreateButton({
        Name = "⚡ SMOOTH SPEED PANEL",
        Callback = function()
            if game.CoreGui:FindFirstChild("HasanSmoothSpeed") then game.CoreGui.HasanSmoothSpeed:Destroy() end
            local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "HasanSmoothSpeed"
            local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 160, 0, 75); main.Position = UDim2.new(0.02, 0, 0.2, 0); main.BackgroundColor3 = Color3.new(0,0,0); main.Draggable = true; main.Active = true
            local btn = Instance.new("TextButton", main); btn.Size = UDim2.new(0.9, 0, 0, 45); btn.Position = UDim2.new(0.05, 0, 0.2, 0); btn.Text = "SPEED: OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.BackgroundColor3 = Color3.new(0,0,0)
            btn.MouseButton1Click:Connect(function() _G.SpeedActive = not _G.SpeedActive; btn.Text = _G.SpeedActive and "SPEED: ON" or "SPEED: OFF" end)
            runService.Heartbeat:Connect(function() if _G.SpeedActive and player.Character then player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (player.Character.Humanoid.MoveDirection * _G.SpeedPower) end end)
        end
    })
    Tab2:CreateSlider({Name = "WalkSpeed Power", Range = {0.1, 2}, Increment = 0.1, CurrentValue = 0.5, Callback = function(V) _G.SpeedPower = V end})
    
    Tab2:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) 
        noclip = V 
        runService.Stepped:Connect(function() if noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
    end})

    Tab2:CreateKeybind({
        Name = "Fly (F)", 
        CurrentKeybind = "F", 
        Callback = function()
            flying = not flying
            local char = player.Character
            if flying then
                local bv = Instance.new("BodyVelocity", char.HumanoidRootPart); bv.Name = "HasoFlyVelocity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                local bg = Instance.new("BodyGyro", char.HumanoidRootPart); bg.Name = "HasoFlyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                task.spawn(function()
                    while flying and char:FindFirstChild("HumanoidRootPart") do
                        local cam, moveDir = workspace.CurrentCamera, Vector3.new(0,0,0)
                        if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                        if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                        if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                        if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                        bv.Velocity = moveDir * flyspeed; bg.CFrame = cam.CFrame; runService.RenderStepped:Wait()
                    end
                    bv:Destroy(); bg:Destroy()
                end)
            end
        end
    })
    Tab2:CreateSlider({Name = "Fly Speed Setting", Range = {10, 300}, Increment = 5, CurrentValue = 50, Callback = function(V) flyspeed = V end})

    Tab2:CreateSection("🎯 Combat & Visuals")
    Tab2:CreateToggle({Name = "Hitbox Active", CurrentValue = false, Callback = function(V)
        _G.HitboxEnabled = V
        task.spawn(function()
            while _G.HitboxEnabled do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        pcall(function() v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize); v.Character.HumanoidRootPart.Transparency = 0.7; v.Character.HumanoidRootPart.CanCollide = false end)
                    end
                end
                task.wait(1)
            end
        end)
    end})
    Tab2:CreateSlider({Name = "Hitbox Level", Range = {2, 100}, Increment = 1, CurrentValue = 20, Callback = function(V) _G.HeadSize = V end})
    
    Tab2:CreateButton({Name = "Invisibility", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kixdev/roblox-invisible-hybrid-script/refs/heads/main/main.lua"))() end})
    Tab2:CreateButton({Name = "ESP", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/vylerascripts/vylera-scripts/main/vylerabladeball.lua"))() end})

    Tab2:CreateSection("📍 Special Menus")
    Tab2:CreateButton({
        Name = "OPEN SPINBOT & TP MENU 😎", 
        Callback = function()
            if game.CoreGui:FindFirstChild("VertexMinimal") then game.CoreGui.VertexMinimal:Destroy() end
            _G.SpinbotEnabled = false
            _G.SpinSpeed = 50
            local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "VertexMinimal"
            local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 180, 0, 220); main.Position = UDim2.new(0.05, 0, 0.3, 0); main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); main.BorderSizePixel = 2; main.BorderColor3 = Color3.fromRGB(255, 0, 0); main.Active = true; main.Draggable = true
            local title = Instance.new("TextLabel", main); title.Size = UDim2.new(1, 0, 0, 30); title.BackgroundColor3 = Color3.fromRGB(150, 0, 0); title.Text = "VERTEX LITE 😎"; title.TextColor3 = Color3.new(1, 1, 1); title.TextSize = 14
            local spinBtn = Instance.new("TextButton", main); spinBtn.Size = UDim2.new(0.9, 0, 0, 35); spinBtn.Position = UDim2.new(0.05, 0, 0.18, 0); spinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); spinBtn.Text = "Spinbot: OFF"; spinBtn.TextColor3 = Color3.new(1, 1, 1)
            spinBtn.MouseButton1Click:Connect(function() _G.SpinbotEnabled = not _G.SpinbotEnabled; spinBtn.Text = _G.SpinbotEnabled and "Spinbot: ON" or "Spinbot: OFF"; spinBtn.BackgroundColor3 = _G.SpinbotEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(40, 40, 40) end)
            local speedLabel = Instance.new("TextLabel", main); speedLabel.Size = UDim2.new(0.9, 0, 0, 20); speedLabel.Position = UDim2.new(0.05, 0, 0.38, 0); speedLabel.BackgroundTransparency = 1; speedLabel.Text = "Spin Speed: " .. _G.SpinSpeed; speedLabel.TextColor3 = Color3.new(1, 1, 1)
            local addSpeed = Instance.new("TextButton", main); addSpeed.Size = UDim2.new(0.4, 0, 0, 30); addSpeed.Position = UDim2.new(0.05, 0, 0.48, 0); addSpeed.Text = "Speed +"; addSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60); addSpeed.TextColor3 = Color3.new(1,1,1)
            local subSpeed = Instance.new("TextButton", main); subSpeed.Size = UDim2.new(0.4, 0, 0, 30); subSpeed.Position = UDim2.new(0.55, 0, 0.48, 0); subSpeed.Text = "Speed -"; subSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60); subSpeed.TextColor3 = Color3.new(1,1,1)
            addSpeed.MouseButton1Click:Connect(function() _G.SpinSpeed = _G.SpinSpeed + 10 speedLabel.Text = "Spin Speed: " .. _G.SpinSpeed end)
            subSpeed.MouseButton1Click:Connect(function() _G.SpinSpeed = math.max(10, _G.SpinSpeed - 10) speedLabel.Text = "Spin Speed: " .. _G.SpinSpeed end)
            local tpTitle = Instance.new("TextLabel", main); tpTitle.Size = UDim2.new(1, 0, 0, 25); tpTitle.Position = UDim2.new(0, 0, 0.65, 0); tpTitle.BackgroundColor3 = Color3.fromRGB(40, 0, 0); tpTitle.Text = "TP TO PLAYER"; tpTitle.TextColor3 = Color3.new(1,1,1)
            local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(0.9, 0, 0.25, 0); scroll.Position = UDim2.new(0.05, 0, 0.77, 0); scroll.CanvasSize = UDim2.new(0, 0, 5, 0); scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20); local layout = Instance.new("UIListLayout", scroll)
            local function updateTPList() for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for _, p in pairs(game.Players:GetPlayers()) do if p ~= player then local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1, -5, 0, 25); btn.Text = p.Name; btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); btn.TextColor3 = Color3.new(0.8, 0.8, 0.8); btn.MouseButton1Click:Connect(function() if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then player.Character:PivotTo(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)) end end) end end end
            runService.RenderStepped:Connect(function() if _G.SpinbotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0) end end)
            task.spawn(function() while task.wait(5) and sg.Parent do updateTPList() end end)
            updateTPList()
        end
    })

    -- --- TAB 3: FILE 3 ---
    Tab3:CreateSection("🔪 MM2")
    Tab3:CreateButton({Name = "💉 VERTEX SCRIPT", Callback = function() loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))() end})
    
    Tab3:CreateSection("🔫 ARSENAL")
    Tab3:CreateToggle({
        Name = "AIMBOT + ESP (ON/OFF)",
        CurrentValue = false,
        Callback = function(v) 
            _G.ArsenalMaster = v
            Rayfield:Notify({Title = "Arsenal Mod", Content = v and "Aimbot and ESP Active!" or "System Closed.", Duration = 2})
        end
    })
    Tab3:CreateToggle({Name = "Team Check", CurrentValue = true, Callback = function(v) _G.TeamCheck = v end})
    Tab3:CreateSlider({Name = "FOV Size", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) _G.FovRadius = v end})
    
    Tab3:CreateButton({
        Name = "Fps Game Rage 🎉", 
        Callback = function() 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/blackowl1231/Z3US/refs/heads/main/main.lua"))() 
        end
    })

    Tab3:CreateSection("🌳 Ormanda 99 Gece (Nights in the Forest 2)")
    Tab3:CreateButton({
        Name = "Voidware 🎉 (Nights/English)", 
        Callback = function() 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest2.lua"))() 
        end
    })

    Tab3:CreateSection("🦁 Savannah Life")
    Tab3:CreateButton({Name = "🚫 DELETE GRASS", Callback = function() for _, obj in pairs(game.Workspace:GetDescendants()) do if obj.Name:find("Grass") then obj:Destroy() end end end})
    Tab3:CreateToggle({Name = "🔦 Night Vision", CurrentValue = false, Callback = function(V) if V then lighting.Ambient = Color3.new(1,1,1); lighting.Brightness = 2 else lighting.Ambient = Color3.fromRGB(127,127,127); lighting.Brightness = 1 end end})

    -- --- TAB 4: SETTINGS ---
    Tab4:CreateSection("🎨 Appearance")
    Tab4:CreateColorPicker({Name = "Theme Color", Color = Color3.fromRGB(255, 0, 0), Callback = function(Value) Window:ModifyTheme({["AccentColor"] = Value}) end})
    
    Tab4:CreateSection("🌐 Language / Dil")
    Tab4:CreateDropdown({
        Name = "Select Language",
        Options = {"English", "Türkçe"},
        CurrentOption = {"Türkçe"},
        MultipleOptions = false,
        Callback = function(Option)
            if Option[1] == "Türkçe" then
                Rayfield:Notify({Title = "Dil Değişti", Content = "Script dili Türkçe olarak ayarlandı!", Duration = 3})
            else
                Rayfield:Notify({Title = "Language Changed", Content = "Script language set to English!", Duration = 3})
            end
        end,
    })

    Tab4:CreateSection("⚡ System")
    Tab4:CreateButton({Name = "🚀 FPS Booster", Callback = function() lighting.GlobalShadows = false settings().Rendering.QualityLevel = "Level01" for _, v in pairs(game:GetDescendants()) do if v:IsA("Part") then v.Material = "Plastic" end end end})
    Tab4:CreateButton({Name = "📈 OPEN FPS COUNTER", Callback = function()
        if game.CoreGui:FindFirstChild("HasanFPS_Pro") then game.CoreGui.HasanFPS_Pro:Destroy() end
        local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "HasanFPS_Pro"
        local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 75, 0, 25); main.Position = UDim2.new(0, 10, 0, 10); main.BackgroundColor3 = Color3.new(0,0,0); main.BackgroundTransparency = 0.3; main.Draggable = true; main.Active = true
        local label = Instance.new("TextLabel", main); label.Size = UDim2.new(1,0,1,0); label.TextColor3 = Color3.new(1,1,1); label.Text = "FPS: ..."
        task.spawn(function() local lastUpdate = tick(); local frames = 0 while sg.Parent do frames = frames + 1 if tick() - lastUpdate >= 1 then label.Text = "FPS: " .. frames; frames = 0; lastUpdate = tick() end runService.RenderStepped:Wait() end end)
    end})
    Tab4:CreateButton({Name = "♻️ Restart Script", Callback = function() Rayfield:Destroy(); task.wait(0.3); _G.VertexScript() end})

    Window:ModifyTheme({["AccentColor"] = Color3.fromRGB(255, 0, 0)})
end

_G.VertexScript()
