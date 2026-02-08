--==============================================================================
-- BLADE BALL ULTIMATE HUB v6.0 - SCRIPT PRINCIPAL
-- Hospedado em: https://raw.githubusercontent.com/gabriel1paiva23/scripts-roblox/refs/heads/main/main.lua
-- Comando: ;menu | Tecla: RightShift/M
--==============================================================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Estado
local State = {
    MenuVisible = false,
    ScreenGui = nil,
    MainMenu = nil,
    NotificationsContainer = nil,
    FlyEnabled = false,
    FlyKeys = {W = false, A = false, S = false, D = false, Space = false, LeftControl = false},
    RainbowHue = 0,
    ESPObjects = {},
    AimbotTarget = nil,
    Connections = {},
    AutoClickerActive = false,
    Noclip = false
}

-- Configurações
local Config = {
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothness = 0.2,
        TeamCheck = true,
        VisibleCheck = true,
        Prediction = 0.1,
        AutoShoot = false,
        AimPart = "Head",
        TriggerKey = "MouseButton2",
        HoldToAim = true
    },
    AutoParry = {
        Enabled = false,
        AutoClick = true,
        ParryDelay = 0.1,
        Prediction = 0.2,
        VisualAlert = true,
        SoundAlert = true
    },
    ESP = {
        Enabled = false,
        Boxes = true,
        Tracers = true,
        Names = true,
        Distance = true,
        Health = true,
        TeamColor = true,
        MaxDistance = 1000,
        ShowTeam = false,
        Chams = false,
        Outline = true
    },
    Movement = {
        Speed = false,
        SpeedValue = 30,
        Fly = false,
        FlySpeed = 40,
        JumpPower = false,
        JumpValue = 60,
        Noclip = false,
        Bhop = false,
        InfJump = false
    },
    Visuals = {
        FOVChanger = false,
        FOVValue = 100,
        FullBright = false,
        NoShadows = false,
        AmbientLighting = false,
        AmbientValue = Color3.new(1, 1, 1),
        RemoveEffects = false,
        RemoveParticles = false,
        TimeChanger = false,
        TimeValue = 12
    },
    Misc = {
        AntiAfk = true,
        RainbowCharacter = false,
        SpinBot = false,
        AutoFarm = false,
        AutoCollect = false,
        AutoClicker = false,
        ClickSpeed = 10,
        HitboxExpander = false,
        HitboxSize = 2,
        AntiStomp = false,
        ServerHop = false,
        ReJoin = false,
        AutoRespawn = false,
        AntiVoid = false
    },
    Combat = {
        SilentAim = false,
        HitChance = 100,
        Wallbang = false,
        AutoBlock = false,
        Reach = false,
        ReachDistance = 25,
        NoCooldown = false,
        NoRecoil = false,
        RapidFire = false,
        KillAura = false,
        KillAuraRange = 20
    }
}

-- Cache original
local OriginalSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    FOV = 70,
    Brightness = 1,
    GlobalShadows = true,
    Ambient = Lighting.Ambient
}

print("⚔️ BLADE BALL ULTIMATE HUB v6.0 CARREGADO DO GITHUB!")
print("📱 Sistema inicializando...")

--==============================================================================
-- FUNÇÕES UTILITÁRIAS
--==============================================================================

function IsAlive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

function CalculateDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and IsAlive(player) then
            if Config.Aimbot.TeamCheck and player.Team == Player.Team then
                continue
            end
            
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = CalculateDistance(HumanoidRootPart.Position, humanoidRootPart.Position)
                    
                    if distance < shortestDistance and distance <= Config.Aimbot.FOV * 5 then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function IsVisible(part)
    if not part then return false end
    
    local origin = Camera.CFrame.Position
    local target = part.Position
    local direction = (target - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    local hit, position = Workspace:FindPartOnRayWithIgnoreList(ray, {Character, Camera})
    
    if hit then
        return hit:IsDescendantOf(part.Parent)
    end
    return false
end

function CreateClick()
    if not Config.AutoParry.AutoClick then return end
    
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

--==============================================================================
-- SISTEMA DE AIMBOT
--==============================================================================

local Aimbot = {}

function Aimbot:Update()
    if not Config.Aimbot.Enabled then
        State.AimbotTarget = nil
        return
    end
    
    if Config.Aimbot.HoldToAim and not UserInputService:IsMouseButtonPressed(Enum.UserInputType[Config.Aimbot.TriggerKey]) then
        State.AimbotTarget = nil
        return
    end
    
    local target = GetClosestPlayer()
    if not target then
        State.AimbotTarget = nil
        return
    end
    
    State.AimbotTarget = target
    
    if Config.Aimbot.VisibleCheck and not IsVisible(target.Character:FindFirstChild(Config.Aimbot.AimPart) or target.Character.HumanoidRootPart) then
        return
    end
    
    local character = target.Character
    if not character then return end
    
    local aimPart = character:FindFirstChild(Config.Aimbot.AimPart) or character.HumanoidRootPart
    if not aimPart then return end
    
    local targetPosition = aimPart.Position
    
    -- Prediction
    if Config.Aimbot.Prediction > 0 then
        local velocity = aimPart.Velocity
        targetPosition = targetPosition + (velocity * Config.Aimbot.Prediction)
    end
    
    -- FOV Check
    local screenPoint = Camera:WorldToViewportPoint(targetPosition)
    local mousePos = UserInputService:GetMouseLocation()
    local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
    
    if distanceFromCenter > Config.Aimbot.FOV then
        State.AimbotTarget = nil
        return
    end
    
    -- Smooth aiming
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
    local newCFrame = currentCFrame:Lerp(targetCFrame, Config.Aimbot.Smoothness)
    
    Camera.CFrame = newCFrame
    
    -- Auto Shoot
    if Config.Aimbot.AutoShoot then
        CreateClick()
    end
end

--==============================================================================
-- SISTEMA DE ESP
--==============================================================================

local ESP = {}

function ESP:Create(player)
    if not player or player == Player then return end
    if State.ESPObjects[player] then return end
    
    local espObject = {
        Box = nil,
        Tracer = nil,
        Name = nil,
        Distance = nil,
        Health = nil,
        Chams = nil
    }
    
    State.ESPObjects[player] = espObject
    
    -- Box ESP
    if Config.ESP.Boxes then
        espObject.Box = Instance.new("Frame")
        espObject.Box.Name = "ESPBox"
        espObject.Box.BackgroundTransparency = 1
        espObject.Box.BorderSizePixel = 2
        espObject.Box.ZIndex = 10
        espObject.Box.Parent = State.ScreenGui
    end
    
    -- Tracer
    if Config.ESP.Tracers then
        espObject.Tracer = Instance.new("Frame")
        espObject.Tracer.Name = "ESPTracer"
        espObject.Tracer.BackgroundTransparency = 1
        espObject.Tracer.BorderSizePixel = 2
        espObject.Tracer.ZIndex = 9
        espObject.Tracer.Parent = State.ScreenGui
    end
    
    -- Name
    if Config.ESP.Names then
        espObject.Name = Instance.new("TextLabel")
        espObject.Name.Name = "ESPName"
        espObject.Name.BackgroundTransparency = 1
        espObject.Name.Text = player.Name
        espObject.Name.TextColor3 = Color3.new(1, 1, 1)
        espObject.Name.Font = Enum.Font.GothamBold
        espObject.Name.TextSize = 12
        espObject.Name.ZIndex = 11
        espObject.Name.Parent = State.ScreenGui
    end
    
    -- Distance
    if Config.ESP.Distance then
        espObject.Distance = Instance.new("TextLabel")
        espObject.Distance.Name = "ESPDistance"
        espObject.Distance.BackgroundTransparency = 1
        espObject.Distance.Font = Enum.Font.Gotham
        espObject.Distance.TextSize = 11
        espObject.Distance.ZIndex = 11
        espObject.Distance.Parent = State.ScreenGui
    end
    
    -- Health
    if Config.ESP.Health then
        espObject.Health = Instance.new("TextLabel")
        espObject.Health.Name = "ESPHealth"
        espObject.Health.BackgroundTransparency = 1
        espObject.Health.Font = Enum.Font.Gotham
        espObject.Health.TextSize = 11
        espObject.Health.ZIndex = 11
        espObject.Health.Parent = State.ScreenGui
    end
end

function ESP:Update(player)
    local espObject = State.ESPObjects[player]
    if not espObject then return end
    
    local character = player.Character
    if not character or not IsAlive(player) then
        self:Remove(player)
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local distance = CalculateDistance(HumanoidRootPart.Position, humanoidRootPart.Position)
    if distance > Config.ESP.MaxDistance then
        self:Hide(player)
        return
    end
    
    local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    if not onScreen then
        self:Hide(player)
        return
    end
    
    self:Show(player)
    
    -- Team color
    local color = Config.ESP.TeamColor and player.Team and player.Team.TeamColor.Color or Color3.new(1, 0, 0)
    
    -- Box ESP
    if espObject.Box and Config.ESP.Boxes then
        local size = Vector2.new(1000 / screenPoint.Z, 1500 / screenPoint.Z)
        espObject.Box.Size = UDim2.new(0, size.X, 0, size.Y)
        espObject.Box.Position = UDim2.new(0, screenPoint.X - size.X/2, 0, screenPoint.Y - size.Y/2)
        espObject.Box.BorderColor3 = color
        espObject.Box.Visible = true
    end
    
    -- Tracer
    if espObject.Tracer and Config.ESP.Tracers then
        espObject.Tracer.Size = UDim2.new(0, 2, 0, math.sqrt((screenPoint.X - Camera.ViewportSize.X/2)^2 + (screenPoint.Y - Camera.ViewportSize.Y)^2))
        espObject.Tracer.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
        espObject.Tracer.Rotation = math.deg(math.atan2(screenPoint.Y - Camera.ViewportSize.Y, screenPoint.X - Camera.ViewportSize.X/2)) + 90
        espObject.Tracer.BorderColor3 = color
        espObject.Tracer.Visible = true
    end
    
    -- Name
    if espObject.Name and Config.ESP.Names then
        espObject.Name.Text = player.Name
        espObject.Name.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 40)
        espObject.Name.TextColor3 = color
        espObject.Name.Visible = true
    end
    
    -- Distance
    if espObject.Distance and Config.ESP.Distance then
        espObject.Distance.Text = string.format("%.0f studs", distance)
        espObject.Distance.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 25)
        espObject.Distance.TextColor3 = color
        espObject.Distance.Visible = true
    end
    
    -- Health
    if espObject.Health and Config.ESP.Health then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
            espObject.Health.Text = string.format("%d%% HP", healthPercent)
            espObject.Health.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 55)
            espObject.Health.TextColor3 = Color3.new(1 - healthPercent/100, healthPercent/100, 0)
            espObject.Health.Visible = true
        end
    end
end

function ESP:Show(player)
    local espObject = State.ESPObjects[player]
    if not espObject then return end
    
    for _, obj in pairs(espObject) do
        if obj and obj:IsA("GuiObject") then
            obj.Visible = true
        end
    end
end

function ESP:Hide(player)
    local espObject = State.ESPObjects[player]
    if not espObject then return end
    
    for _, obj in pairs(espObject) do
        if obj and obj:IsA("GuiObject") then
            obj.Visible = false
        end
    end
end

function ESP:Remove(player)
    local espObject = State.ESPObjects[player]
    if not espObject then return end
    
    for _, obj in pairs(espObject) do
        if obj then
            obj:Destroy()
        end
    end
    
    State.ESPObjects[player] = nil
end

function ESP:UpdateAll()
    if not Config.ESP.Enabled then return end
    if not State.ScreenGui or not State.ScreenGui.Parent then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and IsAlive(player) then
            if not State.ESPObjects[player] then
                self:Create(player)
            end
            self:Update(player)
        else
            self:Remove(player)
        end
    end
end

--==============================================================================
-- SISTEMA DE AUTO PARRY
--==============================================================================

local AutoParry = {}

function AutoParry:CheckBall()
    for _, part in pairs(Workspace:GetChildren()) do
        if part.Name:lower():find("ball") or part.Name:lower():find("sphere") then
            local distance = CalculateDistance(HumanoidRootPart.Position, part.Position)
            if distance < 20 then
                if Config.AutoParry.VisualAlert then
                    ShowNotification("⚡ PARRY!", "Bola detectada próxima!", 1)
                end
                
                if Config.AutoParry.AutoClick then
                    task.spawn(function()
                        task.wait(Config.AutoParry.ParryDelay)
                        CreateClick()
                    end)
                end
                
                return true
            end
        end
    end
    return false
end

--==============================================================================
-- SISTEMA DE AUTOCLICKER
--==============================================================================

local AutoClicker = {}

function AutoClicker:Start()
    State.AutoClickerActive = true
    while State.AutoClickerActive and Config.Misc.AutoClicker do
        CreateClick()
        task.wait(1 / Config.Misc.ClickSpeed)
    end
end

function AutoClicker:Stop()
    State.AutoClickerActive = false
end

--==============================================================================
-- SISTEMA DE NO CLIP
--==============================================================================

function UpdateNoclip()
    if Config.Movement.Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

--==============================================================================
-- SISTEMA DE INFINITE JUMP
--==============================================================================

local InfiniteJump = {}

function InfiniteJump:Connect()
    UserInputService.JumpRequest:Connect(function()
        if Config.Movement.InfJump and Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

--==============================================================================
-- SISTEMA DE BHOP
--==============================================================================

local Bhop = {}

function Bhop:Update()
    if not Config.Movement.Bhop or not Humanoid then return end
    
    if Humanoid.FloorMaterial ~= Enum.Material.Air then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

--==============================================================================
-- SISTEMA DE COMBATE
--==============================================================================

local Combat = {}

function Combat:KillAura()
    if not Config.Combat.KillAura then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and IsAlive(player) then
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = CalculateDistance(HumanoidRootPart.Position, humanoidRootPart.Position)
                    if distance <= Config.Combat.KillAuraRange then
                        CreateClick()
                    end
                end
            end
        end
    end
end

--==============================================================================
-- SISTEMA DE ANTI VOID
--==============================================================================

local AntiVoid = {}

function AntiVoid:Check()
    if not Config.Misc.AntiVoid then return end
    
    if HumanoidRootPart.Position.Y < -100 then
        HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        ShowNotification("🛡️ Anti-Void", "Teleportado para segurança!", 2)
    end
end

--==============================================================================
-- SISTEMA DE SERVER HOP
--==============================================================================

local ServerHop = {}

function ServerHop:Execute()
    if not Config.Misc.ServerHop then return end
    
    local TeleportService = game:GetService("TeleportService")
    
    local servers = {}
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    end)
    
    if success and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        end
    end
end

--==============================================================================
-- INTERFACE COMPLETA
--==============================================================================

function CreateUI()
    print("🖥️ Criando interface do usuário...")
    
    -- Remove UI antiga
    if CoreGui:FindFirstChild("BladeBallHubUI") then
        CoreGui.BladeBallHubUI:Destroy()
    end
    
    -- Cria ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BladeBallHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    State.ScreenGui = ScreenGui
    
    -- 1. WATERMARK
    local watermark = Instance.new("Frame")
    watermark.Name = "Watermark"
    watermark.Size = UDim2.new(0, 350, 0, 50)
    watermark.Position = UDim2.new(0, 10, 0, 10)
    watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    watermark.BackgroundTransparency = 0.1
    watermark.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = watermark
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = watermark
    
    local title = Instance.new("TextLabel")
    title.Text = "⚔️ BLADE BALL ULTIMATE HUB v6.0"
    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = watermark
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "GITHUB EDITION | ;menu | RightShift/M"
    subtitle.Size = UDim2.new(1, -10, 0, 20)
    subtitle.Position = UDim2.new(0, 10, 0, 28)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = watermark
    
    watermark.Parent = ScreenGui
    
    -- 2. MENU PRINCIPAL
    local menu = Instance.new("Frame")
    menu.Name = "MainMenu"
    menu.Size = UDim2.new(0, 550, 0, 500)
    menu.Position = UDim2.new(0.5, -275, 0.5, -250)
    menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    menu.BackgroundTransparency = 0.05
    menu.BorderSizePixel = 0
    menu.Visible = false
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 15)
    menuCorner.Parent = menu
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = Color3.fromRGB(100, 100, 255)
    menuStroke.Thickness = 2
    menuStroke.Parent = menu
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = menu
    
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 15)
    titleBarCorner.Parent = titleBar
    
    local menuTitle = Instance.new("TextLabel")
    menuTitle.Text = "BLADE BALL ULTIMATE HUB (GITHUB)"
    menuTitle.Size = UDim2.new(1, -50, 1, 0)
    menuTitle.Position = UDim2.new(0, 15, 0, 0)
    menuTitle.BackgroundTransparency = 1
    menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuTitle.Font = Enum.Font.GothamBold
    menuTitle.TextSize = 16
    menuTitle.TextXAlignment = Enum.TextXAlignment.Left
    menuTitle.Parent = titleBar
    
    -- Botão de fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
        State.MenuVisible = false
    end)
    
    closeBtn.Parent = titleBar
    
    -- Container de abas
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(0, 130, 1, -50)
    tabsContainer.Position = UDim2.new(0, 0, 0, 40)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = menu
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabsContainer
    
    -- Container de conteúdo
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -130, 1, -50)
    contentContainer.Position = UDim2.new(0, 130, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = menu
    
    -- Conteúdo rolável
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -10, 1, -10)
    contentFrame.Position = UDim2.new(0, 5, 0, 5)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Parent = contentContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = contentFrame
    
    -- Função para criar toggle
    local function CreateToggle(name, configCategory, configKey, defaultValue)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        toggleFrame.BackgroundTransparency = 0.1
        toggleFrame.BorderSizePixel = 0
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Text = name
        toggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Text = Config[configCategory][configKey] and "ON" or "OFF"
        toggleButton.Size = UDim2.new(0, 60, 0, 25)
        toggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
        toggleButton.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 12
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            Config[configCategory][configKey] = not Config[configCategory][configKey]
            toggleButton.Text = Config[configCategory][configKey] and "ON" or "OFF"
            toggleButton.BackgroundColor3 = Config[configCategory][configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            
            -- Ações específicas
            if configKey == "AutoClicker" then
                if Config[configCategory][configKey] then
                    AutoClicker:Start()
                else
                    AutoClicker:Stop()
                end
            elseif configKey == "ESP" then
                if Config[configCategory][configKey] then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= Player then
                            ESP:Create(player)
                        end
                    end
                else
                    for player, _ in pairs(State.ESPObjects) do
                        ESP:Remove(player)
                    end
                end
            end
            
            ShowNotification(name, "Definido para: " .. toggleButton.Text, 2)
        end)
        
        toggleButton.Parent = toggleFrame
        return toggleFrame
    end
    
    -- Função para criar slider
    local function CreateSlider(name, configCategory, configKey, minValue, maxValue, defaultValue)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        sliderFrame.BackgroundTransparency = 0.1
        sliderFrame.BorderSizePixel = 0
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 8)
        sliderCorner.Parent = sliderFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Text = name .. ": " .. Config[configCategory][configKey]
        sliderLabel.Size = UDim2.new(1, -10, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, -20, 0, 5)
        slider.Position = UDim2.new(0, 10, 1, -20)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        slider.BorderSizePixel = 0
        
        local sliderCorner2 = Instance.new("UICorner")
        sliderCorner2.CornerRadius = UDim.new(1, 0)
        sliderCorner2.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((Config[configCategory][configKey] - minValue) / (maxValue - minValue), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        fill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local thumb = Instance.new("Frame")
        thumb.Size = UDim2.new(0, 15, 0, 15)
        thumb.Position = UDim2.new((Config[configCategory][configKey] - minValue) / (maxValue - minValue), -7.5, 0.5, -7.5)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(1, 0)
        thumbCorner.Parent = thumb
        
        fill.Parent = slider
        thumb.Parent = slider
        
        local dragging = false
        
        local function updateSlider(input)
            local pos = UDim2.new(
                math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1),
                0,
                0.5,
                -7.5
            )
            thumb.Position = pos
            
            local value = math.floor(minValue + (pos.X.Scale * (maxValue - minValue)))
            Config[configCategory][configKey] = value
            sliderLabel.Text = name .. ": " .. value
        end
        
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        thumb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        slider.Parent = sliderFrame
        return sliderFrame
    end
    
    -- Criar abas e conteúdo
    local tabs = {
        {Name = "Aimbot", Icon = "🎯", Content = function()
            contentFrame:ClearAllChildren()
            
            local aimbotToggle = CreateToggle("Aimbot", "Aimbot", "Enabled", false)
            aimbotToggle.Parent = contentFrame
            
            local autoShootToggle = CreateToggle("Auto Shoot", "Aimbot", "AutoShoot", false)
            autoShootToggle.Parent = contentFrame
            
            local teamCheckToggle = CreateToggle("Team Check", "Aimbot", "TeamCheck", true)
            teamCheckToggle.Parent = contentFrame
            
            local visibleCheckToggle = CreateToggle("Visible Check", "Aimbot", "VisibleCheck", true)
            visibleCheckToggle.Parent = contentFrame
            
            local fovSlider = CreateSlider("FOV", "Aimbot", "FOV", 10, 500, 100)
            fovSlider.Parent = contentFrame
            
            local smoothnessSlider = CreateSlider("Smoothness", "Aimbot", "Smoothness", 0, 1, 0.2)
            smoothnessSlider.Parent = contentFrame
        end},
        
        {Name = "AutoParry", Icon = "🛡️", Content = function()
            contentFrame:ClearAllChildren()
            
            local autoParryToggle = CreateToggle("Auto Parry", "AutoParry", "Enabled", false)
            autoParryToggle.Parent = contentFrame
            
            local autoClickToggle = CreateToggle("Auto Click", "AutoParry", "AutoClick", true)
            autoClickToggle.Parent = contentFrame
            
            local visualAlertToggle = CreateToggle("Visual Alert", "AutoParry", "VisualAlert", true)
            visualAlertToggle.Parent = contentFrame
            
            local parryDelaySlider = CreateSlider("Parry Delay", "AutoParry", "ParryDelay", 0, 1, 0.1)
            parryDelaySlider.Parent = contentFrame
        end},
        
        {Name = "ESP", Icon = "👁️", Content = function()
            contentFrame:ClearAllChildren()
            
            local espToggle = CreateToggle("ESP", "ESP", "Enabled", false)
            espToggle.Parent = contentFrame
            
            local boxToggle = CreateToggle("Box ESP", "ESP", "Boxes", true)
            boxToggle.Parent = contentFrame
            
            local tracerToggle = CreateToggle("Tracers", "ESP", "Tracers", true)
            tracerToggle.Parent = contentFrame
            
            local nameToggle = CreateToggle("Names", "ESP", "Names", true)
            nameToggle.Parent = contentFrame
            
            local distanceToggle = CreateToggle("Distance", "ESP", "Distance", true)
            distanceToggle.Parent = contentFrame
            
            local healthToggle = CreateToggle("Health", "ESP", "Health", true)
            healthToggle.Parent = contentFrame
            
            local maxDistanceSlider = CreateSlider("Max Distance", "ESP", "MaxDistance", 100, 5000, 1000)
            maxDistanceSlider.Parent = contentFrame
        end},
        
        {Name = "Movement", Icon = "🚀", Content = function()
            contentFrame:ClearAllChildren()
            
            local speedToggle = CreateToggle("Speed Hack", "Movement", "Speed", false)
            speedToggle.Parent = contentFrame
            
            local speedSlider = CreateSlider("Speed Value", "Movement", "SpeedValue", 16, 200, 30)
            speedSlider.Parent = contentFrame
            
            local flyToggle = CreateToggle("Fly", "Movement", "Fly", false)
            flyToggle.Parent = contentFrame
            
            local flySpeedSlider = CreateSlider("Fly Speed", "Movement", "FlySpeed", 10, 200, 40)
            flySpeedSlider.Parent = contentFrame
            
            local jumpToggle = CreateToggle("Jump Power", "Movement", "JumpPower", false)
            jumpToggle.Parent = contentFrame
            
            local jumpSlider = CreateSlider("Jump Value", "Movement", "JumpValue", 50, 500, 60)
            jumpSlider.Parent = contentFrame
            
            local noclipToggle = CreateToggle("Noclip", "Movement", "Noclip", false)
            noclipToggle.Parent = contentFrame
            
            local bhopToggle = CreateToggle("Bunny Hop", "Movement", "Bhop", false)
            bhopToggle.Parent = contentFrame
            
            local infJumpToggle = CreateToggle("Infinite Jump", "Movement", "InfJump", false)
            infJumpToggle.Parent = contentFrame
        end},
        
        {Name = "Visuals", Icon = "🎨", Content = function()
            contentFrame:ClearAllChildren()
            
            local fovToggle = CreateToggle("FOV Changer", "Visuals", "FOVChanger", false)
            fovToggle.Parent = contentFrame
            
            local fovSlider = CreateSlider("FOV Value", "Visuals", "FOVValue", 70, 120, 100)
            fovSlider.Parent = contentFrame
            
            local fullbrightToggle = CreateToggle("FullBright", "Visuals", "FullBright", false)
            fullbrightToggle.Parent = contentFrame
            
            local noShadowsToggle = CreateToggle("No Shadows", "Visuals", "NoShadows", false)
            noShadowsToggle.Parent = contentFrame
            
            local rainbowCharToggle = CreateToggle("Rainbow Character", "Misc", "RainbowCharacter", false)
            rainbowCharToggle.Parent = contentFrame
            
            local spinbotToggle = CreateToggle("Spin Bot", "Misc", "SpinBot", false)
            spinbotToggle.Parent = contentFrame
        end},
        
        {Name = "Misc", Icon = "⚙️", Content = function()
            contentFrame:ClearAllChildren()
            
            local antiAfkToggle = CreateToggle("Anti-AFK", "Misc", "AntiAfk", true)
            antiAfkToggle.Parent = contentFrame
            
            local autoClickerToggle = CreateToggle("Auto Clicker", "Misc", "AutoClicker", false)
            autoClickerToggle.Parent = contentFrame
            
            local clickSpeedSlider = CreateSlider("Click Speed", "Misc", "ClickSpeed", 1, 100, 10)
            clickSpeedSlider.Parent = contentFrame
            
            local antiVoidToggle = CreateToggle("Anti Void", "Misc", "AntiVoid", false)
            antiVoidToggle.Parent = contentFrame
            
            -- Botão para servidor hop
            local serverHopBtn = Instance.new("TextButton")
            serverHopBtn.Text = "🔄 Server Hop Agora"
            serverHopBtn.Size = UDim2.new(1, -10, 0, 35)
            serverHopBtn.Position = UDim2.new(0, 5, 0, 5)
            serverHopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            serverHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            serverHopBtn.Font = Enum.Font.GothamBold
            serverHopBtn.TextSize = 14
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = serverHopBtn
            
            serverHopBtn.MouseButton1Click:Connect(function()
                ServerHop:Execute()
                ShowNotification("Server Hop", "Trocando de servidor...", 3)
            end)
            
            serverHopBtn.Parent = contentFrame
        end}
    }
    
    -- Criar botões de abas
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name .. "Tab"
        tabButton.Text = tab.Icon .. " " .. tab.Name
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + (i-1)*45)
        tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 80, 120) or Color3.fromRGB(50, 50, 70)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 13
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = tabButton
        
        tabButton.MouseButton1Click:Connect(function()
            -- Resetar cores de todas as abas
            for _, otherTab in pairs(tabsContainer:GetChildren()) do
                if otherTab:IsA("TextButton") then
                    otherTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
            end
            
            -- Destacar aba atual
            tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
            
            -- Carregar conteúdo
            if tab.Content then
                tab.Content()
            end
        end)
        
        tabButton.Parent = tabsContainer
    end
    
    -- Carregar primeira aba
    if #tabs > 0 and tabs[1].Content then
        tabs[1].Content()
        tabsContainer:FindFirstChild(tabs[1].Name .. "Tab").BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end
    
    menu.Parent = ScreenGui
    State.MainMenu = menu
    
    -- 3. CONTAINER DE NOTIFICAÇÕES
    local notifContainer = Instance.new("Frame")
    notifContainer.Name = "NotificationsContainer"
    notifContainer.Size = UDim2.new(0, 300, 1, -100)
    notifContainer.Position = UDim2.new(1, -310, 0, 60)
    notifContainer.BackgroundTransparency = 1
    notifContainer.Parent = ScreenGui
    State.NotificationsContainer = notifContainer
    
    print("✅ Interface criada com sucesso!")
    return ScreenGui
end

--==============================================================================
-- SISTEMA DE NOTIFICAÇÕES
--==============================================================================

function ShowNotification(title, message, duration)
    if not State.NotificationsContainer then return end
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(1, -10, 0, 70)
    notif.Position = UDim2.new(0, 5, 1, -75)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.ZIndex = 200
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Text = message
    msgLabel.Size = UDim2.new(1, -10, 0, 35)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 12
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.TextWrapped = true
    msgLabel.Parent = notif
    
    notif.Parent = State.NotificationsContainer
    
    -- Animação de entrada
    notif.Position = UDim2.new(0, 5, 1, 5)
    TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(0, 5, 1, -75)
    }):Play()
    
    -- Remove depois da duração
    task.spawn(function()
        task.wait(duration or 3)
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(0, 5, 1, 5),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

--==============================================================================
-- FUNÇÃO PRINCIPAL - ALTERNAR MENU
--==============================================================================

function ToggleMenu()
    if not State.ScreenGui or not State.ScreenGui.Parent then
        CreateUI()
    end
    
    if State.MainMenu then
        State.MenuVisible = not State.MenuVisible
        State.MainMenu.Visible = State.MenuVisible
        
        ShowNotification("Menu " .. (State.MenuVisible and "Aberto" or "Fechado"), 
            "Comando: ;menu", 2)
    end
end

--==============================================================================
-- SISTEMA DE CHAT
--==============================================================================

Player.Chatted:Connect(function(message)
    local cleanMsg = string.lower(string.gsub(message, "%s+", ""))
    
    if cleanMsg == ";menu" then
        ToggleMenu()
    elseif cleanMsg == ";esp" then
        Config.ESP.Enabled = not Config.ESP.Enabled
        ShowNotification("ESP", Config.ESP.Enabled and "Ativado" or "Desativado", 2)
    elseif cleanMsg == ";aimbot" then
        Config.Aimbot.Enabled = not Config.Aimbot.Enabled
        ShowNotification("Aimbot", Config.Aimbot.Enabled and "Ativado" or "Desativado", 2)
    elseif cleanMsg == ";fly" then
        Config.Movement.Fly = not Config.Movement.Fly
        ShowNotification("Fly", Config.Movement.Fly and "Ativado" or "Desativado", 2)
    elseif cleanMsg == ";speed" then
        Config.Movement.Speed = not Config.Movement.Speed
        ShowNotification("Speed", Config.Movement.Speed and "Ativado" or "Desativado", 2)
    elseif cleanMsg == ";help" then
        ShowNotification("Comandos disponíveis", 
            ";menu - Abrir menu\n" ..
            ";esp - Toggle ESP\n" ..
            ";aimbot - Toggle Aimbot\n" ..
            ";fly - Toggle Fly\n" ..
            ";speed - Toggle Speed\n" ..
            ";help - Esta mensagem", 5)
    end
end)

--==============================================================================
-- SISTEMA DE TECLAS
--==============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- Teclas para abrir menu
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.M then
            ToggleMenu()
        end
        
        -- Controles de voo
        local key = input.KeyCode.Name
        if key == "W" then State.FlyKeys.W = true end
        if key == "A" then State.FlyKeys.A = true end
        if key == "S" then State.FlyKeys.S = true end
        if key == "D" then State.FlyKeys.D = true end
        if key == "Space" then State.FlyKeys.Space = true end
        if key == "LeftControl" then State.FlyKeys.LeftControl = true end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name
    if key == "W" then State.FlyKeys.W = false end
    if key == "A" then State.FlyKeys.A = false end
    if key == "S" then State.FlyKeys.S = false end
    if key == "D" then State.FlyKeys.D = false end
    if key == "Space" then State.FlyKeys.Space = false end
    if key == "LeftControl" then State.FlyKeys.LeftControl = false end
end)

--==============================================================================
-- LOOP PRINCIPAL
--==============================================================================

RunService.Heartbeat:Connect(function()
    -- Aimbot
    if Config.Aimbot.Enabled then
        Aimbot:Update()
    end
    
    -- ESP
    if Config.ESP.Enabled then
        ESP:UpdateAll()
    end
    
    -- Auto Parry
    if Config.AutoParry.Enabled then
        AutoParry:CheckBall()
    end
    
    -- Speed Hack
    if Humanoid and Config.Movement.Speed then
        Humanoid.WalkSpeed = Config.Movement.SpeedValue
    elseif Humanoid then
        Humanoid.WalkSpeed = OriginalSettings.WalkSpeed
    end
    
    -- Jump Power
    if Humanoid and Config.Movement.JumpPower then
        Humanoid.JumpPower = Config.Movement.JumpValue
    elseif Humanoid then
        Humanoid.JumpPower = OriginalSettings.JumpPower
    end
    
    -- Fly System
    if Config.Movement.Fly and Character and HumanoidRootPart then
        Humanoid.PlatformStand = true
        
        local forward = 0
        local right = 0
        local up = 0
        
        if State.FlyKeys.W then forward = forward + 1 end
        if State.FlyKeys.S then forward = forward - 1 end
        if State.FlyKeys.D then right = right + 1 end
        if State.FlyKeys.A then right = right - 1 end
        if State.FlyKeys.Space then up = up + 1 end
        if State.FlyKeys.LeftControl then up = up - 1 end
        
        local camera = Workspace.CurrentCamera
        if camera then
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            local upVector = Vector3.new(0, 1, 0)
            
            local moveVector = (lookVector * forward + rightVector * right + upVector * up).Unit
            HumanoidRootPart.Velocity = moveVector * Config.Movement.FlySpeed
        end
    elseif Humanoid then
        Humanoid.PlatformStand = false
    end
    
    -- FOV Changer
    if Camera and Config.Visuals.FOVChanger then
        Camera.FieldOfView = Config.Visuals.FOVValue
    elseif Camera then
        Camera.FieldOfView = OriginalSettings.FOV
    end
    
    -- FullBright
    if Config.Visuals.FullBright then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
    else
        Lighting.GlobalShadows = OriginalSettings.GlobalShadows
        Lighting.Brightness = OriginalSettings.Brightness
    end
    
    -- Rainbow Character
    if Config.Misc.RainbowCharacter and Character then
        State.RainbowHue = (State.RainbowHue + 1) % 360
        local color = Color3.fromHSV(State.RainbowHue / 360, 1, 1)
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = color
            end
        end
    end
    
    -- Spin Bot
    if Config.Misc.SpinBot and HumanoidRootPart then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
    end
    
    -- Kill Aura
    Combat:KillAura()
    
    -- Bhop
    Bhop:Update()
    
    -- Noclip
    UpdateNoclip()
    
    -- Anti Void
    AntiVoid:Check()
end)

--==============================================================================
-- ANTI-AFK
--==============================================================================

if Config.Misc.AntiAfk then
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end

--==============================================================================
-- INFINITE JUMP
--==============================================================================

InfiniteJump:Connect()

--==============================================================================
-- INICIALIZAÇÃO
--==============================================================================

-- Criar a interface
CreateUI()

-- Conectar ESP para jogadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Player then
        ESP:Create(player)
    end
end

-- Notificação inicial
task.wait(2)
ShowNotification("Blade Ball Ultimate Hub v6.0", 
    "✅ Sistema carregado do GitHub!\n\n" ..
    "📝 Comandos disponíveis:\n" ..
    "• ;menu - Abrir menu\n" ..
    "• ;esp - Toggle ESP\n" ..
    "• ;aimbot - Toggle Aimbot\n" ..
    "• ;fly - Toggle Fly\n" ..
    "• ;speed - Toggle Speed\n" ..
    "• ;help - Mostrar ajuda\n\n" ..
    "🎮 Teclas: RightShift ou M\n" ..
    "⚔️ Hospedado no GitHub", 8)

print("========================================")
print("✅ BLADE BALL ULTIMATE HUB v6.0 (GITHUB)")
print("✅ Sistema carregado com sucesso!")
print("📁 Script carregado do GitHub")
print("📝 Comandos: ;menu, ;esp, ;aimbot, ;fly, ;speed, ;help")
print("🎮 Teclas: RightShift ou M")
print("🚀 Sistema universal para todos os jogos")
print("👨‍💻 Desenvolvedor: Danizao_Piu")
print("========================================")

-- Loop para manter script ativo
while true do
    task.wait(1)
end
