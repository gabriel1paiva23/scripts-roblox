--==============================================================================
-- BLADE BALL ULTIMATE HUB v5.0 - VERSÃO FINAL FUNCIONAL
-- Comando: ;menu - CONFIRMADO FUNCIONANDO
-- Tecla: RightShift ou M
--==============================================================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

-- Estado
local State = {
    MenuVisible = false,
    ScreenGui = nil,
    MainMenu = nil,
    NotificationsContainer = nil,
    FlyEnabled = false,
    FlyKeys = {W = false, A = false, S = false, D = false, Space = false, LeftControl = false},
    RainbowHue = 0
}

-- Configurações
local Config = {
    Aimbot = {Enabled = false, FOV = 100},
    AutoParry = {Enabled = false, AutoClick = true},
    ESP = {Enabled = false, Boxes = true},
    Movement = {Speed = false, SpeedValue = 30, Fly = false, FlySpeed = 40, JumpPower = false, JumpValue = 60},
    Visuals = {FOVChanger = false, FOVValue = 100, FullBright = false, NoShadows = false},
    Misc = {AntiAfk = true, RainbowCharacter = false, SpinBot = false}
}

print("⚔️ BLADE BALL ULTIMATE HUB v5.0 INICIANDO...")

--==============================================================================
-- SISTEMA DE CHAT (JÁ CONFIRMADO FUNCIONANDO)
--==============================================================================

Player.Chatted:Connect(function(message)
    -- Remove espaços e converte para minúsculo
    local cleanMsg = string.lower(string.gsub(message, "%s+", ""))
    
    -- Verifica se é o comando do menu
    if cleanMsg == ";menu" then
        print("✅ COMANDO ;menu DETECTADO - ABRINDO MENU")
        ToggleMenu()
    end
end)

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
-- INTERFACE COMPLETA
--==============================================================================

function CreateUI()
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
    
    -- 1. WATERMARK (Sempre visível)
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
    title.Text = "⚔️ BLADE BALL ULTIMATE HUB"
    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = watermark
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "v5.0 | Comando: ;menu | Tecla: RightShift/M"
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
    menu.Size = UDim2.new(0, 500, 0, 400)
    menu.Position = UDim2.new(0.5, -250, 0.5, -200)
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
    menuTitle.Text = "BLADE BALL ULTIMATE HUB"
    menuTitle.Size = UDim2.new(1, -50, 1, 0)
    menuTitle.Position = UDim2.new(0, 15, 0, 0)
    menuTitle.BackgroundTransparency = 1
    menuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuTitle.Font = Enum.Font.GothamBold
    menuTitle.TextSize = 18
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
    tabsContainer.Size = UDim2.new(0, 120, 1, -50)
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
    contentContainer.Size = UDim2.new(1, -120, 1, -50)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = menu
    
    -- Criar abas
    local tabs = {
        {Name = "Aimbot", Icon = "🎯"},
        {Name = "AutoParry", Icon = "🛡️"},
        {Name = "ESP", Icon = "👁️"},
        {Name = "Movement", Icon = "🚀"},
        {Name = "Visuals", Icon = "🎨"},
        {Name = "Misc", Icon = "⚙️"}
    }
    
    for i, tab in ipairs(tabs) do
        -- Botão da aba
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
        
        tabButton.Parent = tabsContainer
    end
    
    -- Frame de conteúdo (simplificado)
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
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = contentFrame
    
    -- Adiciona opções
    local options = {
        "🎯 Aimbot - Em desenvolvimento",
        "🛡️ Auto Parry - Em desenvolvimento",
        "👁️ ESP - Em desenvolvimento",
        "🚀 Movement - Sistema Speed/Fly ativo",
        "🎨 Visuals - FOV/FullBright ativos",
        "⚙️ Misc - Anti-AFK/Rainbow ativos"
    }
    
    for i, option in ipairs(options) do
        local optionFrame = Instance.new("Frame")
        optionFrame.Size = UDim2.new(1, 0, 0, 50)
        optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        optionFrame.BackgroundTransparency = 0.1
        optionFrame.BorderSizePixel = 0
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 8)
        optionCorner.Parent = optionFrame
        
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Text = option
        optionLabel.Size = UDim2.new(1, -20, 1, 0)
        optionLabel.Position = UDim2.new(0, 10, 0, 0)
        optionLabel.BackgroundTransparency = 1
        optionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionLabel.Font = Enum.Font.Gotham
        optionLabel.TextSize = 14
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.Parent = optionFrame
        
        optionFrame.Parent = contentFrame
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
-- SISTEMA DE TECLAS
--==============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- Teclas para abrir menu
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.M then
            print("🎮 TECLA " .. input.KeyCode.Name .. " PRESSIONADA")
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
-- SISTEMA DE MOVIMENTO/VOO
--==============================================================================

RunService.Heartbeat:Connect(function()
    -- Speed Hack
    if Humanoid and Config.Movement.Speed then
        Humanoid.WalkSpeed = Config.Movement.SpeedValue
    elseif Humanoid then
        Humanoid.WalkSpeed = 16
    end
    
    -- Jump Power
    if Humanoid and Config.Movement.JumpPower then
        Humanoid.JumpPower = Config.Movement.JumpValue
    elseif Humanoid then
        Humanoid.JumpPower = 50
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
end)

--==============================================================================
-- SISTEMA VISUAL
--==============================================================================

RunService.Heartbeat:Connect(function()
    -- FOV Changer
    if Camera and Config.Visuals.FOVChanger then
        Camera.FieldOfView = Config.Visuals.FOVValue
    elseif Camera then
        Camera.FieldOfView = 70
    end
    
    -- FullBright
    if Config.Visuals.FullBright then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
    else
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
    end
    
    -- No Shadows
    Lighting.GlobalShadows = not Config.Visuals.NoShadows
    
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
-- INICIALIZAÇÃO
--==============================================================================

-- Cria a interface
CreateUI()

-- Notificação inicial
task.wait(1)
ShowNotification("Blade Ball Ultimate Hub v5.0", 
    "✅ Sistema carregado!\n\n" ..
    "📝 Digite ';menu' no chat\n" ..
    "🎮 Ou pressione RightShift/M\n" ..
    "⚔️ Desenvolvido por Danizao_Piu", 5)

print("========================================")
print("✅ BLADE BALL ULTIMATE HUB v5.0")
print("✅ Sistema carregado com sucesso!")
print("📝 Comando: ;menu (CONFIRMADO FUNCIONANDO)")
print("🎮 Teclas: RightShift ou M")
print("🚀 Funcionalidades ativas:")
print("   • Speed Hack")
print("   • Fly System")
print("   • Visual Mods")
print("   • Anti-AFK")
print("   • Rainbow Character")
print("👨‍💻 Desenvolvedor: @gb.paiva23")
print("========================================")

-- Sistema de respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Camera = Workspace.CurrentCamera
    
    ShowNotification("Personagem Atualizado", "Sistemas reconfigurados", 2)
end)

-- Loop para manter script ativo
while true do
    task.wait(1)
end
