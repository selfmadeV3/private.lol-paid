-- Makes the lib work
_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

-- Load Hawk library
local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHanki/HawkHUB/main/LibSources/HawkLib.lua", true))()

-- Creating Main Window
local Window = Hawk:Window({
    ScriptName = "Private.lol (paid)",
    DestroyIfExists = true,
    Theme = "Dark"
})

-- Creating Minimize and Close Buttons
Window:Close({
    visibility = true,
    Callback = function()
        Window:Destroy()
    end,
})

Window:Minimize({
    visibility = true,
    OpenButton = true,
    Callback = function() end,
})

-- Creating Tabs
local magsTab = Window:Tab("Mags")
local uiColorTab = Window:Tab("Change UI Color")
local throwingTab = Window:Tab("Throwing")
local miscTab = Window:Tab("Misc")
local automaticsTab = Window:Tab("Automatics")
local playerTab = Window:Tab("Player")
local creditsTab = Window:Tab("Credits")

-- Creating Sections
local magsSection = magsTab:Section("Mag Controls")
local uiColorSection = uiColorTab:Section("UI Color Controls")
local throwingSection = throwingTab:Section("Throwing Controls")
local miscSection = miscTab:Section("Miscellaneous")
local automaticsSection = automaticsTab:Section("Automatics Controls")
local playerSection = playerTab:Section("Player Controls")
local creditsSection = creditsTab:Section("Credits")

-- Mags Tab Elements
magsSection:Button("Copy Discord to Clipboard", function()
    setclipboard("https://discord.gg/cz9yGFt2MF")
end)

local magSlider = magsSection:Slider("Mag Value", 0, 100, function(rValue)
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local CatchRight = Character:WaitForChild("CatchRight")

    local MagPower = rValue
    local MagsEnabled = true

    RunService.Heartbeat:Connect(function()
        if not MagsEnabled or not CatchRight then return end

        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and v.Name == "Football" then
                local distance = (CatchRight.Position - v.Position).Magnitude
                if distance <= MagPower then
                    firetouchinterest(CatchRight, v, 0)
                    firetouchinterest(CatchRight, v, 1)
                    task.wait()
                    firetouchinterest(CatchRight, v, 0)
                    firetouchinterest(CatchRight, v, 1)
                end
            end
        end
    end)
end)

local magValue = 10 -- Default value for Mag Hitbox
magsSection:Button("Mag Hitbox", function()
    local size = magValue
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Football" and v:IsA("BasePart") then
            v.Size = Vector3.new(size, size, size)
            showHitbox(v, size)
        end
    end
    print("Football hitbox size adjusted to:", size)
end)

magsSection:Button("Pull Vector", function()
    local function regPull()
        local dist = 25
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Football" and v:IsA("BasePart") then
                local distance = (v.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= dist then
                    localPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                    return
                end
            end
        end
    end
    regPull()
    print("Pull Vector activated.")
end)

-- Throwing Tab Button
throwingSection:Button("QB Aimbot", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/selfmadeV3/Erm/main/qb", true))()
end)

-- Misc Tab Elements
local isAntiJamEnabled = false

miscSection:Toggle("AntiJam", false, function(Enabled)
    isAntiJamEnabled = Enabled
end)

local function updateCollisionState()
    while true do
        local playerChar = game:GetService("Players").LocalPlayer.Character
        if playerChar and playerChar:FindFirstChild("Head") then
            local torso = playerChar:FindFirstChild("Torso") or playerChar:FindFirstChild("UpperTorso")
            if torso then
                torso.CanCollide = not isAntiJamEnabled
            end
            playerChar.Head.CanCollide = not isAntiJamEnabled
        end
        task.wait()
    end
end

spawn(updateCollisionState)

local predictionColor = Color3.fromRGB(255, 255, 255) -- Default color is white
local eventConnection

miscSection:Toggle("Football landing predictions", false, function()
    local function beamProjectile(g, v0, x0, t1)
        local c = 0.5 * 0.5 * 0.5
        local p3 = 0.5 * g * t1 * t1 + v0 * t1 + x0
        local p2 = p3 - (g * t1 * t1 + v0 * t1) / 3
        local p1 = (c * g * t1 * t1 + 0.5 * v0 * t1 + x0 - c * (x0 + p3)) / (3 * c) - p2

        local curve0 = (p1 - x0).magnitude
        local curve1 = (p2 - p3).magnitude

        local b = (x0 - p3).unit
        local r1 = (p1 - x0).unit
        local u1 = r1:Cross(b).unit
        local r2 = (p2 - p3).unit
        local u2 = r2:Cross(b).unit
        b = u1:Cross(r1).unit

        local cf1 = CFrame.new(
            x0.x, x0.y, x0.z,
            r1.x, u1.x, b.x,
            r1.y, u1.y, b.y,
            r1.z, u1.z, b.z
        )

        local cf2 = CFrame.new(
            p3.x, p3.y, p3.z,
            r2.x, u2.x, b.x,
            r2.y, u2.y, b.y,
            r2.z, u2.z, b.z
        )

        return curve0, -curve1, cf1, cf2
    end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local RunService = game:GetService("RunService")

    eventConnection = workspace.ChildAdded:Connect(function(b)
        if b.Name == "Football" and b:IsA("BasePart") then
            task.wait()
            local vel = b.Velocity
            local pos = b.Position
            local c0, c1, cf1, cf2 = beamProjectile(Vector3.new(0, -28, 0), vel, pos, 10)
            local beam = Instance.new("Beam")
            local a0 = Instance.new("Attachment")
            local a1 = Instance.new("Attachment")
            beam.Color = ColorSequence.new(predictionColor)
            beam.Transparency = NumberSequence.new(0, 0)
            beam.CurveSize0 = c0
            beam.CurveSize1 = c1
            beam.Name = "Hitbox"
            beam.Parent = workspace.Terrain
            beam.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.01, 0),
                NumberSequenceKeypoint.new(1, 0),
                NumberSequenceKeypoint.new(1, 0.01),
            })
            beam.Segments = 1750
            a0.Parent = workspace.Terrain
            a1.Parent = workspace.Terrain
            a0.CFrame = a0.Parent.CFrame:Inverse() * cf1
            a1.CFrame = a1.Parent.CFrame:Inverse() * cf2
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Width0 = 1
            beam.Width1 = 1
            
            local landedConnection
            landedConnection = RunService.Heartbeat:Connect(function()
                if b.Velocity.magnitude < 1 then  
                    beam:Destroy()
                    a0:Destroy()
                    a1:Destroy()
                    landedConnection:Disconnect()
                end
            end)
            
            repeat task.wait() until b.Parent ~= workspace
            beam:Destroy()
            a0:Destroy()
            a1:Destroy()
        end
    end)
end)

miscSection:Dropdown("Prediction Color", {"White", "Blue", "Red", "Pink", "Green"}, "White", function(v)
    if v == "White" then
        predictionColor = Color3.fromRGB(255, 255, 255)
    elseif v == "Blue" then
        predictionColor = Color3.fromRGB(0, 212, 255)
    elseif v == "Pink" then
        predictionColor = Color3.fromRGB(253, 137, 245)
    elseif v == "Red" then
        predictionColor = Color3.fromRGB(255, 0, 0)
    elseif v == "Green" then
        predictionColor = Color3.fromRGB(0, 255, 115)
    end
end)

-- Player Tab Elements
playerSection:Slider("WalkSpeed", 16, 100, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

playerSection:Slider("JumpPower", 50, 150, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

playerSection:Button("Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

playerSection:Button("Teleport to Spawn", function()
    local player = game.Players.LocalPlayer
    local spawnLocation = workspace.SpawnLocation.Position
    player.Character:SetPrimaryPartCFrame(CFrame.new(spawnLocation))
end)

playerSection:Button("Low Textures", function()
    removeTextures()
    print("All textures removed.")
end)

playerSection:Button("FPS Boost", function()
    boostFPS()
    print("FPS boosted.")
end)

-- Automatics Tab Elements
automaticsSection:Button("Follow Ball Carrier", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local function findOpponentFootball()
        local nearestFootball = nil
        local shortestDistance = math.huge
        local myTeam = player.Team

        if not myTeam then
            print("No opposite team detected")
            return nil
        end

        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "Football" then
                local carrier = v.Parent
                if carrier:IsA("Model") and carrier:FindFirstChild("Humanoid") and carrier:FindFirstChild("HumanoidRootPart") and carrier ~= character then
                    if carrier.Team ~= myTeam then
                        local distance = (hrp.Position - v.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestFootball = carrier
                        end
                    end
                end
            end
        end

        return nearestFootball
    end

    while true do
        local opponentFootball = findOpponentFootball()
        if opponentFootball then
            hrp.CFrame = CFrame.new(opponentFootball.HumanoidRootPart.Position + Vector3.new(0, 0, -2))
        end
        task.wait()
    end
end)

-- Credits Tab Elements
creditsSection:Button("Copy Discord to Clipboard", function()
    setclipboard("https://discord.gg/cz9yGFt2MF")
end)

creditsSection:Label("Developers: narcisst, Ghost")
creditsSection:Label("UI Lib: Bloodball")
creditsSection:Label("Founders: Kol and Nett")
creditsSection:Label("Thanks for using our script!")
