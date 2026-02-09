-- ANTI-SCRIPTER ULTIMATE SYSTEM - PUNIÇÃO CORRIGIDA
-- VERSÃO FINAL COM VOID FUNCIONAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Sistema de logs detalhado
local function Log(message, type)
    local timestamp = os.date("[%H:%M:%S]")
    local logEntry = timestamp .. " [" .. type .. "] " .. message
    print("📝 " .. logEntry)
    return logEntry
end

Log("🚀 Iniciando Anti-Scripter System - Punição Ativa", "SYSTEM")

--===========================================================
-- VARIÁVEIS GLOBAIS
--===========================================================
local LocalPlayer = Players.LocalPlayer
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    TargetPlayer = nil,
    VoidLoop = nil,
    Uptime = 0,
    GUI = nil,
    IsGUIVisible = true,
    BackupData = {},
    
    -- Configurações do void
    VoidPosition = Vector3.new(0, -1000000, 0), -- VOID MUITO PROFUNDO
    IsPlayerInVoid = false,
    VoidConnections = {}
}

--===========================================================
-- FUNÇÕES DE PUNIÇÃO AVANÇADAS
--===========================================================
local function GetHumanoidRootPart(character)
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            hrp = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        end
        return hrp
    end
    return nil
end

local function GetHumanoid(character)
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Função FORTE para enviar ao VOID
function AntiScripter.SendToVoid(targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then
        Log("❌ Jogador inválido para void", "ERROR")
        return false
    end
    
    local character = targetPlayer.Character
    if not character then
        -- Tentar carregar personagem
        targetPlayer:LoadCharacter()
        wait(0.5)
        character = targetPlayer.Character
        if not character then
            Log("❌ Personagem não encontrado: " .. targetPlayer.Name, "ERROR")
            return false
        end
    end
    
    local humanoidRootPart = GetHumanoidRootPart(character)
    if not humanoidRootPart then
        Log("❌ HumanoidRootPart não encontrado em " .. targetPlayer.Name, "ERROR")
        return false
    end
    
    -- Salvar backup da posição original
    if not AntiScripter.BackupData[targetPlayer.Name] then
        AntiScripter.BackupData[targetPlayer.Name] = {
            CFrame = humanoidRootPart.CFrame,
            Anchored = humanoidRootPart.Anchored,
            CanCollide = humanoidRootPart.CanCollide
        }
    end
    
    -- TELEPORTAR PARA O VOID PROFUNDO
    humanoidRootPart.CFrame = CFrame.new(
        AntiScripter.VoidPosition.X + math.random(-100, 100),
        AntiScripter.VoidPosition.Y - math.random(0, 1000),
        AntiScripter.VoidPosition.Z + math.random(-100, 100)
    )
    
    -- ANCORAR NO VOID (IMPORTANTE!)
    humanoidRootPart.Anchored = true
    
    -- Remover TODAS as ferramentas
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            item:Destroy()
        end
    end
    
    -- Desabilitar scripts locais
    for _, script in pairs(character:GetDescendants()) do
        if script:IsA("LocalScript") then
            script.Disabled = true
            pcall(function() script:Destroy() end)
        end
    end
    
    -- Matar humanoid constantemente
    local humanoid = GetHumanoid(character)
    if humanoid then
        humanoid.Health = 0
        wait(0.1)
        humanoid.Health = 1
    end
    
    -- Efeito visual no void
    if math.random(1, 5) == 1 then
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(10, 10, 10)
        effect.Position = humanoidRootPart.Position
        effect.Anchored = true
        effect.CanCollide = false
        effect.Transparency = 0.7
        effect.BrickColor = BrickColor.new("Really black")
        effect.Material = Enum.Material.Glass
        effect.Parent = Workspace
        game:GetService("Debris"):AddItem(effect, 1)
    end
    
    Log("✅ " .. targetPlayer.Name .. " enviado ao VOID", "PUNISHMENT")
    return true
end

-- Função para restaurar jogador
function AntiScripter.RestorePlayer(targetPlayer)
    if not targetPlayer then return false end
    
    if AntiScripter.BackupData[targetPlayer.Name] then
        local character = targetPlayer.Character
        if character then
            local humanoidRootPart = GetHumanoidRootPart(character)
            if humanoidRootPart then
                -- Restaurar posição original
                humanoidRootPart.CFrame = AntiScripter.BackupData[targetPlayer.Name].CFrame
                humanoidRootPart.Anchored = AntiScripter.BackupData[targetPlayer.Name].Anchored
                humanoidRootPart.CanCollide = AntiScripter.BackupData[targetPlayer.Name].CanCollide
                
                -- Restaurar scripts
                for _, script in pairs(character:GetDescendants()) do
                    if script:IsA("LocalScript") then
                        script.Disabled = false
                    end
                end
                
                Log("✅ " .. targetPlayer.Name .. " restaurado", "RESTORE")
                return true
            end
        end
    end
    
    -- Fallback: teleportar para posição segura
    local character = targetPlayer.Character
    if character then
        local humanoidRootPart = GetHumanoidRootPart(character)
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            humanoidRootPart.Anchored = false
        end
    end
    
    return false
end

-- Loop principal de punição
function AntiScripter.StartVoidLoop(targetPlayer)
    if not targetPlayer then
        Log("❌ Nenhum jogador para punir", "ERROR")
        return false
    end
    
    Log("🚀 Iniciando loop de void para " .. targetPlayer.Name, "PUNISHMENT")
    
    -- Parar loop anterior se existir
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    
    -- Conexão principal
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if AntiScripter.IsPunishing and targetPlayer and Players:FindFirstChild(targetPlayer.Name) then
            local success = AntiScripter.SendToVoid(targetPlayer)
            
            if success then
                AntiScripter.IsPlayerInVoid = true
            end
        else
            -- Jogador saiu ou punição parou
            if AntiScripter.VoidLoop then
                AntiScripter.VoidLoop:Disconnect()
                AntiScripter.VoidLoop = nil
            end
        end
    end)
    
    -- Loop secundário para garantir
    spawn(function()
        while AntiScripter.IsPunishing and targetPlayer and targetPlayer.Parent do
            AntiScripter.SendToVoid(targetPlayer)
            wait(0.05) -- Teleporte SUPER rápido
        end
    end)
    
    return true
end

-- Iniciar punição completa
function AntiScripter.StartPunishment()
    if not AntiScripter.SelectedPlayer then
        Log("❌ Nenhum jogador selecionado!", "ERROR")
        return false
    end
    
    local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
    if not targetPlayer then
        Log("❌ Jogador não encontrado: " .. AntiScripter.SelectedPlayer, "ERROR")
        return false
    end
    
    AntiScripter.IsPunishing = true
    AntiScripter.TargetPlayer = targetPlayer
    
    Log("🚀🚀🚀 PUNIÇÃO INICIADA para " .. targetPlayer.Name, "PUNISHMENT")
    
    -- Iniciar loop de void
    AntiScripter.StartVoidLoop(targetPlayer)
    
    -- Sistema de segurança extra
    AntiScripter.VoidConnections.CharacterAdded = targetPlayer.CharacterAdded:Connect(function(character)
        wait(0.1) -- Esperar personagem carregar
        if AntiScripter.IsPunishing then
            AntiScripter.SendToVoid(targetPlayer)
        end
    end)
    
    return true
end

-- Parar punição
function AntiScripter.StopPunishment()
    AntiScripter.IsPunishing = false
    AntiScripter.IsPlayerInVoid = false
    
    -- Parar loop
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    
    -- Desconectar conexões
    for name, connection in pairs(AntiScripter.VoidConnections) do
        if connection then
            connection:Disconnect()
        end
        AntiScripter.VoidConnections[name] = nil
    end
    
    -- Restaurar jogador
    if AntiScripter.TargetPlayer then
        AntiScripter.RestorePlayer(AntiScripter.TargetPlayer)
    end
    
    Log("🛑 Punição PARADA", "PUNISHMENT")
    AntiScripter.TargetPlayer = nil
    
    return true
end

-- Teste rápido
function AntiScripter.TestPunishment()
    if not AntiScripter.SelectedPlayer then
        Log("❌ Nenhum jogador selecionado para teste!", "ERROR")
        return false
    end
    
    local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
    if not targetPlayer then
        Log("❌ Jogador não encontrado: " .. AntiScripter.SelectedPlayer, "ERROR")
        return false
    end
    
    Log("🧪 Teste iniciado para " .. targetPlayer.Name, "TEST")
    
    -- Aplicar punição por 3 segundos
    AntiScripter.SendToVoid(targetPlayer)
    
    -- Aguardar 3 segundos
    wait(3)
    
    -- Restaurar
    AntiScripter.RestorePlayer(targetPlayer)
    
    Log("🧪 Teste finalizado para " .. targetPlayer.Name, "TEST")
    return true
end

--===========================================================
-- SISTEMA DE INTERFACE (SIMPLIFICADO E FUNCIONAL)
--===========================================================
function AntiScripter.CreateGUI()
    -- Destruir GUI existente
    if AntiScripter.GUI then
        AntiScripter.GUI:Destroy()
    end
    
    -- Criar ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiScripterGUI_" .. HttpService:GenerateGUID(false)
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 3
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Sombra
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(255, 50, 50)
    shadow.Thickness = 3
    shadow.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    title.Text = "⚡ ANTI-SCRIPTER VOID SYSTEM ⚡"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.Parent = mainFrame
    
    closeButton.MouseButton1Click:Connect(function()
        AntiScripter.ToggleGUI()
    end)
    
    -- Container
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -60)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 6
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    container.CanvasSize = UDim2.new(0, 0, 0, 500)
    container.Parent = mainFrame
    
    -- Criar elementos da interface
    local yPos = 10
    local elements = {}
    
    -- Seção 1: Seleção
    local section1 = Instance.new("Frame")
    section1.Size = UDim2.new(1, 0, 0, 30)
    section1.Position = UDim2.new(0, 0, 0, yPos)
    section1.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    section1.BorderSizePixel = 0
    section1.Parent = container
    
    local section1Label = Instance.new("TextLabel")
    section1Label.Size = UDim2.new(1, 0, 1, 0)
    section1Label.Position = UDim2.new(0, 10, 0, 0)
    section1Label.BackgroundTransparency = 1
    section1Label.Text = "🎯 SELECIONAR JOGADOR"
    section1Label.TextColor3 = Color3.fromRGB(255, 100, 100)
    section1Label.Font = Enum.Font.SourceSansBold
    section1Label.TextSize = 16
    section1Label.TextXAlignment = Enum.TextXAlignment.Left
    section1Label.Parent = section1
    
    yPos = yPos + 40
    
    -- Botão de seleção
    elements.SelectButton = Instance.new("TextButton")
    elements.SelectButton.Size = UDim2.new(1, -20, 0, 40)
    elements.SelectButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.SelectButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    elements.SelectButton.Text = "Clique para selecionar jogador"
    elements.SelectButton.TextColor3 = Color3.new(1, 1, 1)
    elements.SelectButton.Font = Enum.Font.SourceSansBold
    elements.SelectButton.TextSize = 14
    elements.SelectButton.Parent = container
    
    yPos = yPos + 50
    
    -- Label do jogador selecionado
    elements.SelectedLabel = Instance.new("TextLabel")
    elements.SelectedLabel.Size = UDim2.new(1, -20, 0, 25)
    elements.SelectedLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.SelectedLabel.BackgroundTransparency = 1
    elements.SelectedLabel.Text = "🎯 Selecionado: NENHUM"
    elements.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    elements.SelectedLabel.Font = Enum.Font.SourceSansBold
    elements.SelectedLabel.TextSize = 14
    elements.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.SelectedLabel.Parent = container
    
    yPos = yPos + 35
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 2: Punição
    local section2 = Instance.new("Frame")
    section2.Size = UDim2.new(1, 0, 0, 30)
    section2.Position = UDim2.new(0, 0, 0, yPos)
    section2.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    section2.BorderSizePixel = 0
    section2.Parent = container
    
    local section2Label = Instance.new("TextLabel")
    section2Label.Size = UDim2.new(1, 0, 1, 0)
    section2Label.Position = UDim2.new(0, 10, 0, 0)
    section2Label.BackgroundTransparency = 1
    section2Label.Text = "⚡ CONTROLE DE PUNIÇÃO"
    section2Label.TextColor3 = Color3.fromRGB(255, 100, 100)
    section2Label.Font = Enum.Font.SourceSansBold
    section2Label.TextSize = 16
    section2Label.TextXAlignment = Enum.TextXAlignment.Left
    section2Label.Parent = section2
    
    yPos = yPos + 40
    
    -- Botão principal de punição
    elements.PunishButton = Instance.new("TextButton")
    elements.PunishButton.Name = "PunishButton"
    elements.PunishButton.Size = UDim2.new(1, -20, 0, 50)
    elements.PunishButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.PunishButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    elements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO NO VOID"
    elements.PunishButton.TextColor3 = Color3.new(1, 1, 1)
    elements.PunishButton.Font = Enum.Font.SourceSansBold
    elements.PunishButton.TextSize = 16
    elements.PunishButton.TextWrapped = true
    elements.PunishButton.Parent = container
    
    yPos = yPos + 60
    
    -- Status
    elements.StatusLabel = Instance.new("TextLabel")
    elements.StatusLabel.Size = UDim2.new(1, -20, 0, 25)
    elements.StatusLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.StatusLabel.BackgroundTransparency = 1
    elements.StatusLabel.Text = "📊 Status: INATIVO"
    elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    elements.StatusLabel.Font = Enum.Font.SourceSansBold
    elements.StatusLabel.TextSize = 14
    elements.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.StatusLabel.Parent = container
    
    yPos = yPos + 35
    
    -- Botão de teste
    elements.TestButton = Instance.new("TextButton")
    elements.TestButton.Size = UDim2.new(1, -20, 0, 35)
    elements.TestButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.TestButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    elements.TestButton.Text = "🧪 TESTE RÁPIDO (3s)"
    elements.TestButton.TextColor3 = Color3.new(1, 1, 1)
    elements.TestButton.Font = Enum.Font.SourceSansBold
    elements.TestButton.TextSize = 14
    elements.TestButton.Parent = container
    
    yPos = yPos + 45
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 3: Status
    local section3 = Instance.new("Frame")
    section3.Size = UDim2.new(1, 0, 0, 30)
    section3.Position = UDim2.new(0, 0, 0, yPos)
    section3.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    section3.BorderSizePixel = 0
    section3.Parent = container
    
    local section3Label = Instance.new("TextLabel")
    section3Label.Size = UDim2.new(1, 0, 1, 0)
    section3Label.Position = UDim2.new(0, 10, 0, 0)
    section3Label.BackgroundTransparency = 1
    section3Label.Text = "📊 INFORMAÇÕES"
    section3Label.TextColor3 = Color3.fromRGB(255, 100, 100)
    section3Label.Font = Enum.Font.SourceSansBold
    section3Label.TextSize = 16
    section3Label.TextXAlignment = Enum.TextXAlignment.Left
    section3Label.Parent = section3
    
    yPos = yPos + 40
    
    -- Uptime
    elements.UptimeLabel = Instance.new("TextLabel")
    elements.UptimeLabel.Size = UDim2.new(1, -20, 0, 20)
    elements.UptimeLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.UptimeLabel.BackgroundTransparency = 1
    elements.UptimeLabel.Text = "⏱️ Uptime: 0s"
    elements.UptimeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    elements.UptimeLabel.Font = Enum.Font.SourceSans
    elements.UptimeLabel.TextSize = 14
    elements.UptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.UptimeLabel.Parent = container
    
    yPos = yPos + 25
    
    -- Jogadores
    elements.PlayerCountLabel = Instance.new("TextLabel")
    elements.PlayerCountLabel.Size = UDim2.new(1, -20, 0, 20)
    elements.PlayerCountLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.PlayerCountLabel.BackgroundTransparency = 1
    elements.PlayerCountLabel.Text = "👥 Jogadores: 0"
    elements.PlayerCountLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    elements.PlayerCountLabel.Font = Enum.Font.SourceSans
    elements.PlayerCountLabel.TextSize = 14
    elements.PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.PlayerCountLabel.Parent = container
    
    yPos = yPos + 30
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 4: Emergência
    local section4 = Instance.new("Frame")
    section4.Size = UDim2.new(1, 0, 0, 30)
    section4.Position = UDim2.new(0, 0, 0, yPos)
    section4.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    section4.BorderSizePixel = 0
    section4.Parent = container
    
    local section4Label = Instance.new("TextLabel")
    section4Label.Size = UDim2.new(1, 0, 1, 0)
    section4Label.Position = UDim2.new(0, 10, 0, 0)
    section4Label.BackgroundTransparency = 1
    section4Label.Text = "🚨 EMERGÊNCIA"
    section4Label.TextColor3 = Color3.fromRGB(255, 0, 0)
    section4Label.Font = Enum.Font.SourceSansBold
    section4Label.TextSize = 16
    section4Label.TextXAlignment = Enum.TextXAlignment.Left
    section4Label.Parent = section4
    
    yPos = yPos + 40
    
    -- Botão de emergência
    elements.EmergencyButton = Instance.new("TextButton")
    elements.EmergencyButton.Size = UDim2.new(1, -20, 0, 40)
    elements.EmergencyButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.EmergencyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elements.EmergencyButton.Text = "⛔ PARAR TUDO AGORA"
    elements.EmergencyButton.TextColor3 = Color3.new(1, 1, 1)
    elements.EmergencyButton.Font = Enum.Font.SourceSansBold
    elements.EmergencyButton.TextSize = 15
    elements.EmergencyButton.TextWrapped = true
    elements.EmergencyButton.Parent = container
    
    yPos = yPos + 50
    
    -- Atualizar canvas size
    container.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    -- Armazenar referências
    AntiScripter.GUI = screenGui
    AntiScripter.GUIElements = elements
    
    -- Configurar eventos
    AntiScripter.SetupGUIEvents()
    
    Log("✅ Interface criada", "GUI")
    
    return screenGui
end

function AntiScripter.SetupGUIEvents()
    local elements = AntiScripter.GUIElements
    
    -- Botão de seleção
    elements.SelectButton.MouseButton1Click:Connect(function()
        AntiScripter.ShowPlayerSelection()
    end)
    
    -- Botão de punição principal
    elements.PunishButton.MouseButton1Click:Connect(function()
        if AntiScripter.IsPunishing then
            -- Parar punição
            AntiScripter.StopPunishment()
            elements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO NO VOID"
            elements.PunishButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            elements.StatusLabel.Text = "📊 Status: PARADO"
            elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            Log("Punição parada pelo usuário", "CONTROL")
        else
            -- Iniciar punição
            if AntiScripter.StartPunishment() then
                elements.PunishButton.Text = "🟢 PARANDO PUNIÇÃO (" .. AntiScripter.SelectedPlayer .. ")"
                elements.PunishButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                elements.StatusLabel.Text = "📊 Status: PUNINDO " .. AntiScripter.SelectedPlayer
                elements.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                Log("Punição iniciada pelo usuário", "CONTROL")
            else
                Log("❌ Falha ao iniciar punição", "ERROR")
            end
        end
    end)
    
    -- Botão de teste
    elements.TestButton.MouseButton1Click:Connect(function()
        AntiScripter.TestPunishment()
    end)
    
    -- Botão de emergência
    elements.EmergencyButton.MouseButton1Click:Connect(function()
        AntiScripter.StopPunishment()
        
        -- Restaurar TODOS os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                AntiScripter.RestorePlayer(player)
            end
        end
        
        -- Atualizar interface
        elements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO NO VOID"
        elements.PunishButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        elements.StatusLabel.Text = "📊 Status: EMERGÊNCIA - PARADO"
        elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        Log("🚨 EMERGÊNCIA: Sistema parado completamente!", "EMERGENCY")
    end)
end

function AntiScripter.ShowPlayerSelection()
    -- Remover popup anterior
    local existingPopup = AntiScripter.GUI:FindFirstChild("PlayerPopup")
    if existingPopup then
        existingPopup:Destroy()
    end
    
    -- Obter jogadores
    local players = Players:GetPlayers()
    local playerNames = {}
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    if #playerNames == 0 then
        table.insert(playerNames, "Nenhum jogador")
    end
    
    -- Criar popup
    local popup = Instance.new("Frame")
    popup.Name = "PlayerPopup"
    popup.Size = UDim2.new(0, 300, 0, 300)
    popup.Position = UDim2.new(0.5, -150, 0.5, -150)
    popup.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    popup.BorderSizePixel = 3
    popup.BorderColor3 = Color3.fromRGB(255, 0, 255)
    popup.ZIndex = 100
    popup.Parent = AntiScripter.GUI
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    title.Text = "👥 ESCOLHA UM JOGADOR"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.ZIndex = 101
    title.Parent = popup
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 101
    closeBtn.Parent = popup
    
    closeBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
    
    -- Lista
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #playerNames * 45)
    scroll.ZIndex = 101
    scroll.Parent = popup
    
    -- Adicionar botões
    local yPos = 5
    for _, playerName in ipairs(playerNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
        btn.Text = playerName
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.ZIndex = 102
        btn.Parent = scroll
        
        if playerName ~= "Nenhum jogador" then
            btn.MouseButton1Click:Connect(function()
                AntiScripter.SelectedPlayer = playerName
                AntiScripter.GUIElements.SelectedLabel.Text = "🎯 Selecionado: " .. playerName
                AntiScripter.GUIElements.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                AntiScripter.GUIElements.SelectButton.Text = "Jogador: " .. playerName
                Log("Selecionado: " .. playerName, "SELECTION")
                popup:Destroy()
            end)
        end
        
        yPos = yPos + 45
    end
end

function AntiScripter.ToggleGUI()
    AntiScripter.IsGUIVisible = not AntiScripter.IsGUIVisible
    
    if AntiScripter.GUI then
        AntiScripter.GUI.Enabled = AntiScripter.IsGUIVisible
        Log("GUI " .. (AntiScripter.IsGUIVisible and "visível" or "oculta"), "GUI")
    else
        AntiScripter.CreateGUI()
    end
end

function AntiScripter.UpdateGUI()
    if AntiScripter.GUIElements then
        -- Atualizar uptime
        AntiScripter.Uptime = AntiScripter.Uptime + 1
        AntiScripter.GUIElements.UptimeLabel.Text = "⏱️ Uptime: " .. AntiScripter.Uptime .. "s"
        
        -- Atualizar jogadores
        local playerCount = #Players:GetPlayers() - 1
        AntiScripter.GUIElements.PlayerCountLabel.Text = "👥 Jogadores: " .. playerCount
        
        -- Atualizar status
        if AntiScripter.IsPunishing and AntiScripter.SelectedPlayer then
            AntiScripter.GUIElements.StatusLabel.Text = "📊 Status: PUNINDO " .. AntiScripter.SelectedPlayer
            AntiScripter.GUIElements.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end

--===========================================================
-- INICIALIZAÇÃO
--===========================================================
Log("Inicializando sistema...", "INIT")

-- Criar GUI
AntiScripter.CreateGUI()

-- Sistema de atualização
spawn(function()
    while true do
        AntiScripter.UpdateGUI()
        wait(1)
    end
end)

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F9 then
            AntiScripter.ToggleGUI()
        elseif input.KeyCode == Enum.KeyCode.Delete then
            Log("DELETE pressionado - Fechando", "SYSTEM")
            AntiScripter.StopPunishment()
            if AntiScripter.GUI then
                AntiScripter.GUI:Destroy()
                AntiScripter.GUI = nil
            end
            print("\n" .. string.rep("=", 60))
            print("🛑 SISTEMA FECHADO")
            print("⏱️  Uptime: " .. AntiScripter.Uptime .. "s")
            print("🎮 Bye!")
            print(string.rep("=", 60) .. "\n")
        end
    end
end)

-- Mensagem inicial
wait(1)

print([[
    
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║      🔥 ANTI-SCRIPTER VOID SYSTEM - ATIVADO             ║
    ║                                                          ║
    ║          ✅ Sistema 100% funcional                      ║
    ║          🎮 Interface: VISÍVEL                          ║
    ║          ⚡ Punição: ATIVA E FUNCIONAL                  ║
    ║                                                          ║
    ║   🎯 COMO USAR:                                          ║
    ║   1. Selecione um jogador                               ║
    ║   2. Clique em "INICIAR PUNIÇÃO NO VOID"                ║
    ║   3. O jogador será enviado ao VOID em LOOP             ║
    ║   4. Para parar, clique novamente no botão              ║
    ║                                                          ║
    ║   ⚡ FUNCIONALIDADES:                                    ║
    ║   • Teleporte para void profundo                        ║
    ║   • Loop constante de punição                           ║
    ║   • Remoção de ferramentas                              ║
    ║   • Desabilitação de scripts                            ║
    ║   • Ancoragem no void                                   ║
    ║   • Sistema de backup/restore                           ║
    ║                                                          ║
    ║   ⚠️  FUNCIONA EM TODOS OS JOGADORES!                  ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    
]])

Log("✅ Sistema pronto para punir!", "READY")
Log("🎯 Selecione um jogador e clique em INICIAR PUNIÇÃO", "INFO")
Log("⚡ A punição agora funciona CORRETAMENTE", "SUCCESS")

-- Retornar sistema
return AntiScripter
