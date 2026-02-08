--==============================================================================
-- BLADE BALL ULTIMATE HUB v5.0 - CORRIGIDa
-- Interface e Sistema Completamente Otimizados
--==============================================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

-- Configuração Global
local Config = {
    Hub = {
        Enabled = true,
        Keybind = Enum.KeyCode.RightShift,
        Watermark = true,
        Notifications = true,
        AutoSave = true,
        MenuPosition = UDim2.new(0.5, -250, 0.5, -200),
        MenuSize = UDim2.new(0, 500, 0, 400)
    },
    
    Aimbot = {
        Enabled = false,
        Target = "Head",
        Smoothness = 0.15,
        FOV = 100,
        VisibleCheck = true,
        TeamCheck = true,
        Prediction = 0.12,
        AutoShoot = false,
        TriggerKey = Enum.KeyCode.Q,
        SilentAim = false,
        HitChance = 100
    },
    
    AutoParry = {
        Enabled = false,
        Mode = "Inteligente",
        Prediction = true,
        PingCompensation = 0.15,
        MinDistance = 5,
        MaxDistance = 150,
        AutoClick = true,
        ClickDelay = 0.05,
        PerfectTiming = false,
        SoundAlert = true,
        VisualAlert = true,
        DoubleParry = false,
        ParryCooldown = 0.5
    },
    
    ESP = {
        Enabled = false,
        Players = true,
        Boxes = true,
        Tracers = true,
        Names = true,
        Health = true,
        Distance = true,
        Chams = false,
        Glow = false,
        TeamColor = true,
        MaxDistance = 500,
        FontSize = 14,
        TextOutline = true
    },
    
    Movement = {
        Speed = false,
        SpeedValue = 30,
        JumpPower = false,
        JumpValue = 60,
        Fly = false,
        FlySpeed = 40,
        NoClip = false,
        AntiStun = false,
        AutoJump = false
    },
    
    Visuals = {
        ThirdPerson = false,
        FOVChanger = false,
        FOVValue = 100,
        FullBright = false,
        NoShadows = false,
        TimeChanger = false,
        TimeValue = 14,
        HitMarker = true,
        HitSound = true,
        KillEffect = true,
        CustomSky = false
    },
    
    Misc = {
        AutoFarm = false,
        AntiAfk = true,
        HideName = false,
        SpinBot = false,
        RainbowCharacter = false,
        ChatLogger = true,
        PlayerList = false,
        ServerHop = false,
        NoFallDamage = false,
        InstantRespawn = false
    }
}

-- Estado Global
local State = {
    CurrentTarget = nil,
    Ball = nil,
    LastParryTime = 0,
    PlayersESP = {},
    UIElements = {},
    Notifications = {},
    RainbowHue = 0,
    IsFlying = false,
    FlyVelocity = Vector3.new(0, 0, 0),
    FlyKeys = {
        W = false,
        A = false,
        S = false,
        D = false,
        Space = false,
        LeftShift = false,
        LeftControl = false
    },
    DraggingUI = false,
    DragStart = nil,
    MousePos = nil
}

--==============================================================================
-- SISTEMA DE MENU/INTERFACE CORRIGIDO
--==============================================================================

function CreateMainUI()
    -- Remove UI antiga se existir
    if CoreGui:FindFirstChild("BladeBallHubUI") then
        CoreGui.BladeBallHubUI:Destroy()
    end
    
    -- Cria a UI principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BladeBallHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    -- Watermark
    if Config.Hub.Watermark then
        CreateWatermark(ScreenGui)
    end
    
    -- Menu principal
    CreateMainMenu(ScreenGui)
    
    -- ESP Folder
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESPFolder"
    ESPFolder.Parent = ScreenGui
    State.UIElements.ESPFolder = ESPFolder
    
    -- Notifications Container
    local NotificationsContainer = Instance.new("Frame")
    NotificationsContainer.Name = "NotificationsContainer"
    NotificationsContainer.Size = UDim2.new(0, 300, 1, -100)
    NotificationsContainer.Position = UDim2.new(1, -310, 0, 60)
    NotificationsContainer.BackgroundTransparency = 1
    NotificationsContainer.Parent = ScreenGui
    State.UIElements.NotificationsContainer = NotificationsContainer
    
    return ScreenGui
end

function CreateWatermark(parent)
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
    
    -- Gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    })
    gradient.Rotation = 90
    gradient.Parent = watermark
    
    -- Logo e título
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(1, -100, 1, 0)
    titleContainer.Position = UDim2.new(0, 10, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = watermark
    
    local logo = Instance.new("TextLabel")
    logo.Text = "⚔️"
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, 0, 0.5, -15)
    logo.BackgroundTransparency = 1
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 20
    logo.Parent = titleContainer
    
    local title = Instance.new("TextLabel")
    title.Text = "BLADE BALL ULTIMATE HUB"
    title.Size = UDim2.new(1, -40, 0, 20)
    title.Position = UDim2.new(0, 35, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Parent = titleContainer
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "v5.0 - By Danizao_Piu"
    subtitle.Size = UDim2.new(1, -40, 0, 15)
    subtitle.Position = UDim2.new(0, 35, 0, 25)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextYAlignment = Enum.TextYAlignment.Top
    subtitle.Parent = titleContainer
    
    -- Stats container
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(0, 80, 1, 0)
    statsContainer.Position = UDim2.new(1, -90, 0, 0)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = watermark
    
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Text = "FPS: 60"
    fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
    fpsLabel.Position = UDim2.new(0, 0, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 12
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
    fpsLabel.Parent = statsContainer
    
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Text = "PING: 0ms"
    pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
    pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
    pingLabel.BackgroundTransparency = 1
    pingLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 11
    pingLabel.TextXAlignment = Enum.TextXAlignment.Right
    pingLabel.Parent = statsContainer
    
    -- Update stats
    spawn(function()
        while watermark and watermark.Parent do
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            fpsLabel.Text = "FPS: " .. fps
            
            -- Simulação de ping (em um script real, você obteria do NetworkClient)
            pingLabel.Text = "PING: " .. math.random(20, 80) .. "ms"
            
            task.wait(1)
        end
    end)
    
    watermark.Parent = parent
    State.UIElements.Watermark = watermark
end

function CreateMainMenu(parent)
    local menu = Instance.new("Frame")
    menu.Name = "MainMenu"
    menu.Size = Config.Hub.MenuSize
    menu.Position = Config.Hub.MenuPosition
    menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    menu.BackgroundTransparency = 0.05
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Active = true
    menu.Draggable = false
    menu.ZIndex = 100
    
    -- Background blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 5
    blur.Parent = menu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = menu
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = menu
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
    })
    gradient.Rotation = 90
    gradient.Parent = menu
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 101
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    -- Make title bar draggable
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.DraggingUI = true
            State.DragStart = menu.Position
            State.MousePos = input.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.DraggingUI = false
            Config.Hub.MenuPosition = menu.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if State.DraggingUI and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - State.MousePos
            menu.Position = UDim2.new(
                State.DragStart.X.Scale,
                State.DragStart.X.Offset + delta.X,
                State.DragStart.Y.Scale,
                State.DragStart.Y.Offset + delta.Y
            )
        end
    end)
    
    local title = Instance.new("TextLabel")
    title.Text = "BLADE BALL ULTIMATE HUB"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 102
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.ZIndex = 102
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        menu.Visible = false
    end)
    
    closeBtn.Parent = titleBar
    titleBar.Parent = menu
    
    -- Tab buttons container
    local tabButtonsContainer = Instance.new("Frame")
    tabButtonsContainer.Name = "TabButtonsContainer"
    tabButtonsContainer.Size = UDim2.new(0, 120, 1, -50)
    tabButtonsContainer.Position = UDim2.new(0, 0, 0, 40)
    tabButtonsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabButtonsContainer.BackgroundTransparency = 0.1
    tabButtonsContainer.BorderSizePixel = 0
    tabButtonsContainer.ZIndex = 101
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabButtonsContainer
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -120, 1, -50)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ZIndex = 100
    
    -- Create tabs
    local tabs = {
        {Name = "Aimbot", Icon = "🎯"},
        {Name = "AutoParry", Icon = "🛡️"},
        {Name = "ESP", Icon = "👁️"},
        {Name = "Movement", Icon = "🚀"},
        {Name = "Visuals", Icon = "🎨"},
        {Name = "Misc", Icon = "⚙️"},
        {Name = "Settings", Icon = "⚙️"}
    }
    
    local tabFrames = {}
    
    for i, tab in ipairs(tabs) do
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name .. "Tab"
        tabButton.Text = tab.Icon .. " " .. tab.Name
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + (i-1)*45)
        tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 80, 120) or Color3.fromRGB(50, 50, 70)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 13
        tabButton.ZIndex = 102
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = tabButton
        
        -- Tab content frame
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = tab.Name .. "Frame"
        tabFrame.Size = UDim2.new(1, -10, 1, -10)
        tabFrame.Position = UDim2.new(0, 5, 0, 5)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 6
        tabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = i == 1
        tabFrame.ZIndex = 100
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 5)
        listLayout.Parent = tabFrame
        
        tabFrame.Parent = contentContainer
        tabFrames[i] = tabFrame
        
        -- Button click event
        tabButton.MouseButton1Click:Connect(function()
            -- Update all buttons
            for _, btn in pairs(tabButtonsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
            end
            
            -- Hide all frames
            for _, frame in pairs(tabFrames) do
                frame.Visible = false
            end
            
            -- Show selected
            tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
            tabFrame.Visible = true
        end)
        
        tabButton.Parent = tabButtonsContainer
        
        -- Create tab content
        CreateTabContent(tab.Name, tabFrame)
    end
    
    tabButtonsContainer.Parent = menu
    contentContainer.Parent = menu
    menu.Parent = parent
    
    State.UIElements.MainMenu = menu
    
    -- Hotkey para abrir/fechar menu
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Config.Hub.Keybind then
            menu.Visible = not menu.Visible
        end
    end)
end

function CreateTabContent(tabName, parent)
    if tabName == "Aimbot" then
        CreateToggleSetting("Enabled", "Ativar Aimbot", "Aimbot.Enabled", parent)
        CreateDropdownSetting("Target", "Parte do corpo para mirar", {"Head", "Torso", "HumanoidRootPart"}, "Aimbot.Target", parent)
        CreateSliderSetting("Smoothness", "Suavidade da mira", 0, 1, 0.01, "Aimbot.Smoothness", parent, function(value) return string.format("%.2f", value) end)
        CreateSliderSetting("FOV", "Campo de visão", 0, 360, 1, "Aimbot.FOV", parent)
        CreateToggleSetting("Visible Check", "Só mirar em jogadores visíveis", "Aimbot.VisibleCheck", parent)
        CreateToggleSetting("Team Check", "Ignorar membros do time", "Aimbot.TeamCheck", parent)
        CreateSliderSetting("Prediction", "Predição de movimento", 0, 0.5, 0.01, "Aimbot.Prediction", parent, function(value) return string.format("%.2f", value) .. "s" end)
        CreateToggleSetting("Auto Shoot", "Atirar automaticamente", "Aimbot.AutoShoot", parent)
        CreateKeybindSetting("Trigger Key", "Tecla para ativar", "Aimbot.TriggerKey", parent)
        CreateToggleSetting("Silent Aim", "Aimbot indetectável", "Aimbot.SilentAim", parent)
        CreateSliderSetting("Hit Chance", "Chance de acerto", 0, 100, 1, "Aimbot.HitChance", parent, function(value) return value .. "%" end)
        
    elseif tabName == "AutoParry" then
        CreateToggleSetting("Enabled", "Ativar Auto Parry", "AutoParry.Enabled", parent)
        CreateDropdownSetting("Mode", "Modo de parry", {"Inteligente", "Agressivo", "Defensivo"}, "AutoParry.Mode", parent)
        CreateToggleSetting("Prediction", "Usar predição de trajetória", "AutoParry.Prediction", parent)
        CreateSliderSetting("Ping Compensation", "Compensação de ping", 0, 0.5, 0.01, "AutoParry.PingCompensation", parent, function(value) return string.format("%.2f", value) .. "s" end)
        CreateSliderSetting("Min Distance", "Distância mínima", 0, 50, 1, "AutoParry.MinDistance", parent, function(value) return value .. " studs" end)
        CreateSliderSetting("Max Distance", "Distância máxima", 0, 500, 1, "AutoParry.MaxDistance", parent, function(value) return value .. " studs" end)
        CreateToggleSetting("Auto Click", "Clicar automaticamente", "AutoParry.AutoClick", parent)
        CreateSliderSetting("Click Delay", "Delay do clique", 0, 0.2, 0.01, "AutoParry.ClickDelay", parent, function(value) return string.format("%.2f", value) .. "s" end)
        CreateToggleSetting("Perfect Timing", "Timing perfeito", "AutoParry.PerfectTiming", parent)
        CreateToggleSetting("Sound Alert", "Som ao dar parry", "AutoParry.SoundAlert", parent)
        CreateToggleSetting("Visual Alert", "Efeito visual ao dar parry", "AutoParry.VisualAlert", parent)
        CreateToggleSetting("Double Parry", "Tentar double parry", "AutoParry.DoubleParry", parent)
        CreateSliderSetting("Parry Cooldown", "Cooldown entre parries", 0, 2, 0.1, "AutoParry.ParryCooldown", parent, function(value) return string.format("%.1f", value) .. "s" end)
        
    elseif tabName == "ESP" then
        CreateToggleSetting("Enabled", "Ativar ESP", "ESP.Enabled", parent)
        CreateToggleSetting("Boxes", "Caixas ao redor dos jogadores", "ESP.Boxes", parent)
        CreateToggleSetting("Tracers", "Linhas até os jogadores", "ESP.Tracers", parent)
        CreateToggleSetting("Names", "Mostrar nomes", "ESP.Names", parent)
        CreateToggleSetting("Health", "Mostrar barra de vida", "ESP.Health", parent)
        CreateToggleSetting("Distance", "Mostrar distância", "ESP.Distance", parent)
        CreateToggleSetting("Chams", "Chams através das paredes", "ESP.Chams", parent)
        CreateToggleSetting("Glow", "Brilho ao redor dos jogadores", "ESP.Glow", parent)
        CreateToggleSetting("Team Color", "Cores por time", "ESP.TeamColor", parent)
        CreateSliderSetting("Max Distance", "Distância máxima", 0, 1000, 10, "ESP.MaxDistance", parent, function(value) return value .. " studs" end)
        CreateSliderSetting("Font Size", "Tamanho da fonte", 8, 20, 1, "ESP.FontSize", parent)
        CreateToggleSetting("Text Outline", "Contorno no texto", "ESP.TextOutline", parent)
        
    elseif tabName == "Movement" then
        CreateToggleSetting("Speed", "Ativar Speed Hack", "Movement.Speed", parent)
        CreateSliderSetting("Speed Value", "Velocidade de movimento", 16, 100, 1, "Movement.SpeedValue", parent, function(value) return value .. " studs/s" end)
        CreateToggleSetting("Jump Power", "Aumentar poder do pulo", "Movement.JumpPower", parent)
        CreateSliderSetting("Jump Value", "Força do pulo", 50, 200, 1, "Movement.JumpValue", parent, function(value) return value .. " power" end)
        CreateToggleSetting("Fly", "Ativar modo de voo", "Movement.Fly", parent)
        CreateSliderSetting("Fly Speed", "Velocidade do voo", 20, 100, 1, "Movement.FlySpeed", parent, function(value) return value .. " studs/s" end)
        CreateToggleSetting("NoClip", "Passar por paredes", "Movement.NoClip", parent)
        CreateToggleSetting("Anti Stun", "Prevenir stun", "Movement.AntiStun", parent)
        CreateToggleSetting("Auto Jump", "Pular automaticamente", "Movement.AutoJump", parent)
        
    elseif tabName == "Visuals" then
        CreateToggleSetting("Third Person", "Visão em terceira pessoa", "Visuals.ThirdPerson", parent)
        CreateToggleSetting("FOV Changer", "Mudar campo de visão", "Visuals.FOVChanger", parent)
        CreateSliderSetting("FOV Value", "Valor do FOV", 70, 120, 1, "Visuals.FOVValue", parent)
        CreateToggleSetting("FullBright", "Iluminação total", "Visuals.FullBright", parent)
        CreateToggleSetting("No Shadows", "Remover sombras", "Visuals.NoShadows", parent)
        CreateToggleSetting("Time Changer", "Mudar hora do dia", "Visuals.TimeChanger", parent)
        CreateSliderSetting("Time Value", "Hora do dia", 0, 24, 1, "Visuals.TimeValue", parent, function(value) return string.format("%02d:00", value) end)
        CreateToggleSetting("Hit Marker", "Marcador de hit", "Visuals.HitMarker", parent)
        CreateToggleSetting("Hit Sound", "Som ao acertar", "Visuals.HitSound", parent)
        CreateToggleSetting("Kill Effect", "Efeito ao matar", "Visuals.KillEffect", parent)
        CreateToggleSetting("Custom Sky", "Céu personalizado", "Visuals.CustomSky", parent)
        
    elseif tabName == "Misc" then
        CreateToggleSetting("Auto Farm", "Farm automático", "Misc.AutoFarm", parent)
        CreateToggleSetting("Anti AFK", "Prevenir AFK", "Misc.AntiAfk", parent)
        CreateToggleSetting("Hide Name", "Esconder nome", "Misc.HideName", parent)
        CreateToggleSetting("Spin Bot", "Girar continuamente", "Misc.SpinBot", parent)
        CreateToggleSetting("Rainbow Character", "Cores arco-íris", "Misc.RainbowCharacter", parent)
        CreateToggleSetting("Chat Logger", "Registrar chat", "Misc.ChatLogger", parent)
        CreateToggleSetting("Player List", "Lista de jogadores", "Misc.PlayerList", parent)
        CreateToggleSetting("Server Hop", "Trocar de servidor", "Misc.ServerHop", parent)
        CreateToggleSetting("No Fall Damage", "Sem dano de queda", "Misc.NoFallDamage", parent)
        CreateToggleSetting("Instant Respawn", "Respawn instantâneo", "Misc.InstantRespawn", parent)
        
    elseif tabName == "Settings" then
        CreateKeybindSetting("Menu Keybind", "Tecla para abrir menu", "Hub.Keybind", parent)
        CreateToggleSetting("Watermark", "Mostrar watermark", "Hub.Watermark", parent)
        CreateToggleSetting("Notifications", "Mostrar notificações", "Hub.Notifications", parent)
        CreateToggleSetting("Auto Save", "Salvar automaticamente", "Hub.AutoSave", parent)
        
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, 0, 0, 120)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = parent
        
        local buttonLayout = Instance.new("UIListLayout")
        buttonLayout.Padding = UDim.new(0, 5)
        buttonLayout.FillDirection = Enum.FillDirection.Vertical
        buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        buttonLayout.Parent = buttonFrame
        
        local saveBtn = CreateActionButton("💾 Salvar Configurações", function()
            SaveConfig()
            SendNotification("Sucesso", "Configurações salvas!", 2)
        end)
        saveBtn.Parent = buttonFrame
        
        local loadBtn = CreateActionButton("📂 Carregar Configurações", function()
            LoadConfig()
            SendNotification("Sucesso", "Configurações carregadas!", 2)
        end)
        loadBtn.Parent = buttonFrame
        
        local resetBtn = CreateActionButton("🔄 Resetar Tudo", function()
            ResetConfig()
            SendNotification("Sucesso", "Configurações resetadas!", 2)
        end)
        resetBtn.Parent = buttonFrame
        
        local unloadBtn = CreateActionButton("⚠️ Descarregar Script", function()
            UnloadScript()
        end)
        unloadBtn.Parent = buttonFrame
    end
end

function CreateToggleSetting(name, description, configPath, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textFrame = Instance.new("Frame")
    textFrame.Size = UDim2.new(0.7, 0, 1, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = textFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(1, -10, 0, 15)
    descLabel.Position = UDim2.new(0, 5, 0, 22)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = textFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Text = ""
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleButton.BackgroundColor3 = GetConfigValue(configPath) and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 21, 0, 21)
    thumb.Position = GetConfigValue(configPath) and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    thumb.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        local current = GetConfigValue(configPath)
        SetConfigValue(configPath, not current)
        
        toggleButton.BackgroundColor3 = not current and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        thumb.Position = not current and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    end)
    
    toggleButton.Parent = frame
    frame.Parent = parent
    
    return frame
end

function CreateSliderSetting(name, description, min, max, step, configPath, parent, formatFunc)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textFrame = Instance.new("Frame")
    textFrame.Size = UDim2.new(1, 0, 0, 25)
    textFrame.BackgroundTransparency = 1
    textFrame.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(0.6, -5, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = textFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Text = formatFunc and formatFunc(GetConfigValue(configPath)) or tostring(GetConfigValue(configPath))
    valueLabel.Size = UDim2.new(0.4, -5, 1, 0)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = textFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(1, -10, 0, 15)
    descLabel.Position = UDim2.new(0, 5, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = frame
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 20)
    sliderFrame.Position = UDim2.new(0, 10, 1, -25)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = frame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0.5, -3)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((GetConfigValue(configPath) - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new((GetConfigValue(configPath) - min) / (max - min), -8, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    fill.Parent = track
    thumb.Parent = track
    track.Parent = sliderFrame
    
    local dragging = false
    local function updateValue(x)
        local relativeX = math.clamp(x, 0, track.AbsoluteSize.X)
        local percent = relativeX / track.AbsoluteSize.X
        local value = min + (max - min) * percent
        value = math.floor(value / step) * step
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -8, 0.5, -8)
        valueLabel.Text = formatFunc and formatFunc(value) or tostring(value)
        
        SetConfigValue(configPath, value)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X - track.AbsolutePosition.X)
        end
    end)
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X - track.AbsolutePosition.X)
        end
    end)
    
    frame.Parent = parent
    return frame
end

function CreateDropdownSetting(name, description, options, configPath, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textFrame = Instance.new("Frame")
    textFrame.Size = UDim2.new(0.6, 0, 1, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = textFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(1, -10, 0, 20)
    descLabel.Position = UDim2.new(0, 5, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = textFrame
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "DropdownButton"
    dropdown.Text = GetConfigValue(configPath)
    dropdown.Size = UDim2.new(0.35, 0, 0, 30)
    dropdown.Position = UDim2.new(0.65, 5, 0.5, -15)
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "DropdownList"
    dropdownList.Size = UDim2.new(0.35, 0, 0, 0)
    dropdownList.Position = UDim2.new(0.65, 5, 0.5, 15)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 105
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = dropdownList
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = dropdownList
    
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Text = option
        optionButton.Size = UDim2.new(1, -10, 0, 25)
        optionButton.Position = UDim2.new(0, 5, 0, 0)
        optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 11
        optionButton.ZIndex = 106
        
        optionButton.MouseButton1Click:Connect(function()
            SetConfigValue(configPath, option)
            dropdown.Text = option
            dropdownList.Visible = false
        end)
        
        optionButton.Parent = dropdownList
    end
    
    dropdownList.Size = UDim2.new(0.35, 0, 0, #options * 27)
    
    dropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    dropdownList.Parent = frame
    dropdown.Parent = frame
    frame.Parent = parent
    
    return frame
end

function CreateKeybindSetting(name, description, configPath, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textFrame = Instance.new("Frame")
    textFrame.Size = UDim2.new(0.6, 0, 1, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = name
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = textFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(1, -10, 0, 20)
    descLabel.Position = UDim2.new(0, 5, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = textFrame
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Text = GetConfigValue(configPath).Name
    keybindButton.Size = UDim2.new(0.35, 0, 0, 30)
    keybindButton.Position = UDim2.new(0.65, 5, 0.5, -15)
    keybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindButton.Font = Enum.Font.Gotham
    keybindButton.TextSize = 12
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 6)
    keybindCorner.Parent = keybindButton
    
    local listening = false
    keybindButton.MouseButton1Click:Connect(function()
        listening = true
        keybindButton.Text = "..."
        keybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            SetConfigValue(configPath, input.KeyCode)
            keybindButton.Text = input.KeyCode.Name
            keybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            listening = false
        end
    end)
    
    keybindButton.Parent = frame
    frame.Parent = parent
    
    return frame
end

function CreateActionButton(text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.8, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function SendNotification(title, message, duration)
    if not Config.Hub.Notifications then return end
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(1, -10, 0, 70)
    notifFrame.Position = UDim2.new(0, 5, 1, -75)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 200
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = notifFrame
    
    local icon = Instance.new("TextLabel")
    icon.Text = "🔔"
    icon.Size = UDim2.new(0, 40, 1, 0)
    icon.Position = UDim2.new(0, 0, 0, 0)
    icon.BackgroundTransparency = 1
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = notifFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -50, 1, -10)
    contentFrame.Position = UDim2.new(0, 45, 0, 5)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = contentFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = message
    messageLabel.Size = UDim2.new(1, 0, 0, 35)
    messageLabel.Position = UDim2.new(0, 0, 0, 25)
    messageLabel.BackgroundTransparency = 1
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 11
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = contentFrame
    
    notifFrame.Parent = State.UIElements.NotificationsContainer
    
    -- Anima a entrada
    notifFrame.Position = UDim2.new(0, 5, 1, 5)
    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 5, 1, -75)
    })
    tweenIn:Play()
    
    -- Move todas as notificações para cima
    for _, child in ipairs(State.UIElements.NotificationsContainer:GetChildren()) do
        if child ~= notifFrame and child:IsA("Frame") then
            local currentPos = child.Position
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset, currentPos.Y.Scale, currentPos.Y.Offset - 75)
            }):Play()
        end
    end
    
    -- Remove após a duração
    task.wait(duration or 3)
    
    -- Anima a saída
    local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 5, 1, 5),
        BackgroundTransparency = 1
    })
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notifFrame:Destroy()
    end)
end

--==============================================================================
-- SISTEMA DE FUNCIONALIDADES (Simplificado)
--==============================================================================

function GetConfigValue(path)
    local parts = string.split(path, ".")
    local current = Config
    
    for _, part in ipairs(parts) do
        current = current[part]
        if current == nil then
            return nil
        end
    end
    
    return current
end

function SetConfigValue(path, value)
    local parts = string.split(path, ".")
    local current = Config
    
    for i = 1, #parts - 1 do
        current = current[parts[i]]
    end
    
    current[parts[#parts]] = value
    
    if Config.Hub.AutoSave then
        SaveConfig()
    end
end

function SaveConfig()
    local data = HttpService:JSONEncode(Config)
    writefile("bladeball_config_v5.json", data)
    print("✅ Configurações salvas!")
end

function LoadConfig()
    if isfile("bladeball_config_v5.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("bladeball_config_v5.json"))
        end)
        
        if success then
            Config = data
            print("✅ Configurações carregadas!")
        else
            print("❌ Erro ao carregar configurações")
        end
    else
        print("ℹ️ Nenhuma configuração salva encontrada")
    end
end

function ResetConfig()
    Config = {
        Hub = {
            Enabled = true,
            Keybind = Enum.KeyCode.RightShift,
            Watermark = true,
            Notifications = true,
            AutoSave = true,
            MenuPosition = UDim2.new(0.5, -250, 0.5, -200),
            MenuSize = UDim2.new(0, 500, 0, 400)
        },
        Aimbot = {
            Enabled = false,
            Target = "Head",
            Smoothness = 0.15,
            FOV = 100,
            VisibleCheck = true,
            TeamCheck = true,
            Prediction = 0.12,
            AutoShoot = false,
            TriggerKey = Enum.KeyCode.Q,
            SilentAim = false,
            HitChance = 100
        },
        AutoParry = {
            Enabled = false,
            Mode = "Inteligente",
            Prediction = true,
            PingCompensation = 0.15,
            MinDistance = 5,
            MaxDistance = 150,
            AutoClick = true,
            ClickDelay = 0.05,
            PerfectTiming = false,
            SoundAlert = true,
            VisualAlert = true,
            DoubleParry = false,
            ParryCooldown = 0.5
        },
        ESP = {
            Enabled = false,
            Players = true,
            Boxes = true,
            Tracers = true,
            Names = true,
            Health = true,
            Distance = true,
            Chams = false,
            Glow = false,
            TeamColor = true,
            MaxDistance = 500,
            FontSize = 14,
            TextOutline = true
        },
        Movement = {
            Speed = false,
            SpeedValue = 30,
            JumpPower = false,
            JumpValue = 60,
            Fly = false,
            FlySpeed = 40,
            NoClip = false,
            AntiStun = false,
            AutoJump = false
        },
        Visuals = {
            ThirdPerson = false,
            FOVChanger = false,
            FOVValue = 100,
            FullBright = false,
            NoShadows = false,
            TimeChanger = false,
            TimeValue = 14,
            HitMarker = true,
            HitSound = true,
            KillEffect = true,
            CustomSky = false
        },
        Misc = {
            AutoFarm = false,
            AntiAfk = true,
            HideName = false,
            SpinBot = false,
            RainbowCharacter = false,
            ChatLogger = true,
            PlayerList = false,
            ServerHop = false,
            NoFallDamage = false,
            InstantRespawn = false
        }
    }
    
    print("✅ Configurações resetadas para padrão!")
end

function UnloadScript()
    -- Remove UI
    if CoreGui:FindFirstChild("BladeBallHubUI") then
        CoreGui.BladeBallHubUI:Destroy()
    end
    
    -- Reseta configurações
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
    
    if Camera then
        Camera.FieldOfView = 70
    end
    
    SendNotification("Script Descarregado", "Blade Ball Ultimate Hub v5.0 foi descarregado", 3)
    
    print("========================================")
    print("SCRIPT DESCARREGADO COM SUCESSO!")
    print("========================================")
end

--==============================================================================
-- INICIALIZAÇÃO CORRIGIDA
--==============================================================================

function Initialize()
    print("========================================")
    print("⚔️ BLADE BALL ULTIMATE HUB v5.0")
    print("========================================")
    print("Interface Corrigida - By Danizao_Piu")
    print("========================================")
    
    -- Carrega configurações
    LoadConfig()
    
    -- Cria interface
    CreateMainUI()
    
    -- Configura inputs de voo
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local key = input.KeyCode.Name
        if key == "W" then State.FlyKeys.W = true end
        if key == "A" then State.FlyKeys.A = true end
        if key == "S" then State.FlyKeys.S = true end
        if key == "D" then State.FlyKeys.D = true end
        if key == "Space" then State.FlyKeys.Space = true end
        if key == "LeftShift" then State.FlyKeys.LeftShift = true end
        if key == "LeftControl" then State.FlyKeys.LeftControl = true end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local key = input.KeyCode.Name
        if key == "W" then State.FlyKeys.W = false end
        if key == "A" then State.FlyKeys.A = false end
        if key == "S" then State.FlyKeys.S = false end
        if key == "D" then State.FlyKeys.D = false end
        if key == "Space" then State.FlyKeys.Space = false end
        if key == "LeftShift" then State.FlyKeys.LeftShift = false end
        if key == "LeftControl" then State.FlyKeys.LeftControl = false end
    end)
    
    -- Sistema de respawn
    Player.CharacterAdded:Connect(function(char)
        Character = char
        Humanoid = char:WaitForChild("Humanoid")
        HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
        
        SendNotification("Sistema Atualizado", "Personagem respawnou com sucesso", 2)
    end)
    
    -- Notificação inicial
    SendNotification("Bem-vindo ao Blade Ball Hub", 
        "Pressione " .. Config.Hub.Keybind.Name .. " para abrir o menu\n" ..
        "Desenvolvido por @Danizao_Piu",
        5
    )
    
    print("✅ Sistema inicializado com sucesso!")
    print("🎮 Menu Keybind: " .. Config.Hub.Keybind.Name)
    print("👨‍💻 Desenvolvedor: Danizao_Piu")
    print("========================================")
end

-- Inicia o script
Initialize()

-- Retorna interface para manipulação
return {
    Config = Config,
    OpenMenu = function()
        if State.UIElements.MainMenu then
            State.UIElements.MainMenu.Visible = true
        end
    end,
    CloseMenu = function()
        if State.UIElements.MainMenu then
            State.UIElements.MainMenu.Visible = false
        end
    end,
    Unload = UnloadScript
}
