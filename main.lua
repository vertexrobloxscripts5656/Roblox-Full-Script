-- [[ VERTEX PROJECT | UPDATED VERSION WITH KEYBIND ]]

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
    _G.InfJumpEnabled = false
    
    _G.ArsenalMaster = false
    _G.RageMode = false 
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

    -- --- INFINITE JUMP ---
    local upSpeed = 2 
    runService.Heartbeat:Connect(function()
        if _G.InfJumpEnabled and uis:IsKeyDown(Enum.KeyCode.Space) then
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
        
        if _G.ArsenalMaster then
            local isShooting = uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            if _G.RageMode or isShooting then
                local target = GetClosestTarget()
                if target then 
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) 
                end
            end
        end
    end)

    -- TABS
    local Tab1 = Window:CreateTab("🛡️ ADMIN", 4483362458)
    local Tab2 = Window:CreateTab("🔥 MAIN SCRIPTS", 4483362458)
    local Tab3 = Window:CreateTab("📁 FILE 3", 4483362458)
    local Tab4 = Window:CreateTab("⚙️ SETTINGS", 4483362458)

    -- TAB 1
    Tab1:CreateSection("👑 Admin Menus")
    Tab1:CreateButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})

    -- TAB 2
    Tab2:CreateSection("🏎️ Movement & Speed")
    Tab2:CreateToggle({Name = "Infinite Jump (Space)", CurrentValue = false, Callback = function(V) _G.InfJumpEnabled = V end})
    Tab2:CreateSlider({Name = "WalkSpeed Power", Range = {0.1, 2}, Increment = 0.1, CurrentValue = 0.5, Callback = function(V) _G.SpeedPower = V end})
    Tab2:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) noclip = V end})

    -- TAB 3 (GÜNCELLENMİŞ)
    Tab3:CreateSection("🔫 ARSENAL / COMBAT")
    Tab3:CreateToggle({
        Name = "AIMBOT + ESP (MASTER)",
        CurrentValue = false,
        Callback = function(v) _G.ArsenalMaster = v end
    })
    
    local RageToggle = Tab3:CreateToggle({
        Name = "Rage Mode (Auto Lock)", 
        CurrentValue = false, 
        Callback = function(v) _G.RageMode = v end
    })

    Tab3:CreateKeybind({
       Name = "Rage Mode Keybind",
       CurrentKeybind = "V",
       Callback = function()
           _G.RageMode = not _G.RageMode
           RageToggle:Set(_G.RageMode)
       end,
    })

    Tab3:CreateSlider({Name = "FOV Size", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) _G.FovRadius = v end})

    -- TAB 4
    Tab4:CreateButton({Name = "♻️ Restart Script", Callback = function() Rayfield:Destroy(); task.wait(0.3); _G.VertexScript() end})

    Window:ModifyTheme({["AccentColor"] = Color3.fromRGB(255, 0, 0)})
end

_G.VertexScript()
