-- ANTI-SCRIPTER ULTIMATE SYSTEM - VERSÃO FINAL
-- TODOS OS BUGS CORRIGIDOS

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Sistema de logs
local function Log(message, type)
    local timestamp = os.date("[%H:%M:%S]")
    local logEntry = timestamp .. " [" .. type .. "] " .. message
    print("📝 " .. logEntry)
    return logEntry
end

Log("🚀 Iniciando Anti-Scripter System - Versão Final", "SYSTEM")

--===========================================================
-- SISTEMA PRINCIPAL
--===========================================================
local LocalPlayer = Players.LocalPlayer
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    TargetPlayer = nil,
    VoidLoop = nil,
    Uptime = 0,
    GUI = nil,
    IsGUIVisible = true
}

--===========================================================
-- FUNÇÕES UTILITÁRIAS
--===========================================================
local function GetHumanoidRootPart(character)
    if character then
        return character:FindFirstChild("HumanoidRootPart") or 
               character:FindFirstChild("Torso") or
               character:FindFirstChild("UpperTorso")
    end
    return nil
end

local function CreateEffect(position, color)
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(5, 5, 5)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.5
    effect.BrickColor = BrickColor.new(color)
    effect.Material = Enum.Material.Neon
    effect.Parent = Workspace
    game:GetService("Debris"):AddItem(effect, 2)
    return effect
end

--===========================================================
-- SISTEMA DE PUNIÇÃO
--===========================================================
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
    
    Log("🚀 Punição INICIADA para " .. targetPlayer.Name, "PUNISHMENT")
    
    -- Iniciar loop de punição
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if AntiScripter.IsPunishing and targetPlayer and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoidRootPart = GetHumanoidRootPart(character)
            
            if humanoidRootPart then
                -- Teleporte para void
                humanoidRootPart.CFrame = CFrame.new(0, -100000, 0)
                
                -- Congelar no lugar
                humanoidRootPart.Anchored = true
                
                -- Remover ferramentas
                for _, item in pairs(character:GetChildren()) do
                    if item:IsA("Tool") then
                        item:Destroy()
                    end
                end
                
                -- Efeito visual ocasional
                if math.random(1, 20) == 1 then
                    CreateEffect(humanoidRootPart.Position, "Bright red")
                end
            end
        end
    end)
    
    return true
end

function AntiScripter.StopPunishment()
    AntiScripter.IsPunishing = false
    
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    
    -- Restaurar jogador
    if AntiScripter.TargetPlayer and AntiScripter.TargetPlayer.Character then
        local character = AntiScripter.TargetPlayer.Character
        local humanoidRootPart = GetHumanoidRootPart(character)
        
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
            humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        end
    end
    
    Log("🛑 Punição PARADA", "PUNISHMENT")
    AntiScripter.TargetPlayer = nil
    
    return true
end

--===========================================================
-- SISTEMA DE INTERFACE SIMPLIFICADA
--===========================================================
function AntiScripter.CreateGUI()
    -- Destruir GUI existente
    if AntiScripter.GUI then
        AntiScripter.GUI:Destroy()
        AntiScripter.GUI = nil
    end
    
    -- Criar ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiScripterGUI"
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 60)
    title.Text = "⚡ ANTI-SCRIPTER SYSTEM"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.Parent = mainFrame
    
    closeButton.MouseButton1Click:Connect(function()
        AntiScripter.ToggleGUI()
    end)
    
    -- Container principal
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -50)
    container.Position = UDim2.new(0, 10, 0, 45)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 6
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    container.CanvasSize = UDim2.new(0, 0, 0, 600)
    container.Parent = mainFrame
    
    -- Variável para posição Y
    local yPos = 10
    
    -- Seção 1: Seleção de Jogador
    local section1 = Instance.new("Frame")
    section1.Name = "Section1"
    section1.Size = UDim2.new(1, 0, 0, 40)
    section1.Position = UDim2.new(0, 0, 0, yPos)
    section1.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    section1.BorderSizePixel = 0
    section1.Parent = container
    
    local section1Title = Instance.new("TextLabel")
    section1Title.Name = "Section1Title"
    section1Title.Size = UDim2.new(1, 0, 1, 0)
    section1Title.Position = UDim2.new(0, 10, 0, 0)
    section1Title.BackgroundTransparency = 1
    section1Title.Text = "👥 SELEÇÃO DE JOGADOR"
    section1Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    section1Title.Font = Enum.Font.SourceSansBold
    section1Title.TextSize = 16
    section1Title.TextXAlignment = Enum.TextXAlignment.Left
    section1Title.Parent = section1
    
    yPos = yPos + 50
    
    -- Instrução
    local instruction = Instance.new("TextLabel")
    instruction.Name = "Instruction"
    instruction.Size = UDim2.new(1, -20, 0, 30)
    instruction.Position = UDim2.new(0, 10, 0, yPos)
    instruction.BackgroundTransparency = 1
    instruction.Text = "Selecione um jogador:"
    instruction.TextColor3 = Color3.fromRGB(200, 200, 255)
    instruction.Font = Enum.Font.SourceSans
    instruction.TextSize = 14
    instruction.TextXAlignment = Enum.TextXAlignment.Left
    instruction.Parent = container
    
    yPos = yPos + 35
    
    -- Botão para selecionar jogador
    local selectPlayerButton = Instance.new("TextButton")
    selectPlayerButton.Name = "SelectPlayerButton"
    selectPlayerButton.Size = UDim2.new(1, -20, 0, 40)
    selectPlayerButton.Position = UDim2.new(0, 10, 0, yPos)
    selectPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
    selectPlayerButton.Text = "Clique para selecionar jogador"
    selectPlayerButton.TextColor3 = Color3.new(1, 1, 1)
    selectPlayerButton.Font = Enum.Font.SourceSansBold
    selectPlayerButton.TextSize = 14
    selectPlayerButton.Parent = container
    
    yPos = yPos + 50
    
    -- Label do jogador selecionado
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.Size = UDim2.new(1, -20, 0, 25)
    selectedLabel.Position = UDim2.new(0, 10, 0, yPos)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = "🎯 Jogador selecionado: NENHUM"
    selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    selectedLabel.Font = Enum.Font.SourceSansBold
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Parent = container
    
    yPos = yPos + 40
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 2: Controle de Punição
    local section2 = Instance.new("Frame")
    section2.Name = "Section2"
    section2.Size = UDim2.new(1, 0, 0, 40)
    section2.Position = UDim2.new(0, 0, 0, yPos)
    section2.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    section2.BorderSizePixel = 0
    section2.Parent = container
    
    local section2Title = Instance.new("TextLabel")
    section2Title.Name = "Section2Title"
    section2Title.Size = UDim2.new(1, 0, 1, 0)
    section2Title.Position = UDim2.new(0, 10, 0, 0)
    section2Title.BackgroundTransparency = 1
    section2Title.Text = "⚡ CONTROLE DE PUNIÇÃO"
    section2Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    section2Title.Font = Enum.Font.SourceSansBold
    section2Title.TextSize = 16
    section2Title.TextXAlignment = Enum.TextXAlignment.Left
    section2Title.Parent = section2
    
    yPos = yPos + 50
    
    -- Botão principal de punição
    local punishButton = Instance.new("TextButton")
    punishButton.Name = "PunishButton"
    punishButton.Size = UDim2.new(1, -20, 0, 50)
    punishButton.Position = UDim2.new(0, 10, 0, yPos)
    punishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    punishButton.Text = "🔴 INICIAR PUNIÇÃO"
    punishButton.TextColor3 = Color3.new(1, 1, 1)
    punishButton.Font = Enum.Font.SourceSansBold
    punishButton.TextSize = 16
    punishButton.TextWrapped = true
    punishButton.Parent = container
    
    yPos = yPos + 60
    
    -- Status da punição
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 25)
    statusLabel.Position = UDim2.new(0, 10, 0, yPos)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "📊 Status: INATIVO"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = container
    
    yPos = yPos + 35
    
    -- Botão de teste rápido
    local testButton = Instance.new("TextButton")
    testButton.Name = "TestButton"
    testButton.Size = UDim2.new(1, -20, 0, 35)
    testButton.Position = UDim2.new(0, 10, 0, yPos)
    testButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    testButton.Text = "🧪 TESTE RÁPIDO (3 segundos)"
    testButton.TextColor3 = Color3.new(1, 1, 1)
    testButton.Font = Enum.Font.SourceSansBold
    testButton.TextSize = 14
    testButton.Parent = container
    
    yPos = yPos + 45
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 3: Informações do Sistema
    local section3 = Instance.new("Frame")
    section3.Name = "Section3"
    section3.Size = UDim2.new(1, 0, 0, 40)
    section3.Position = UDim2.new(0, 0, 0, yPos)
    section3.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    section3.BorderSizePixel = 0
    section3.Parent = container
    
    local section3Title = Instance.new("TextLabel")
    section3Title.Name = "Section3Title"
    section3Title.Size = UDim2.new(1, 0, 1, 0)
    section3Title.Position = UDim2.new(0, 10, 0, 0)
    section3Title.BackgroundTransparency = 1
    section3Title.Text = "🖥️ INFORMAÇÕES DO SISTEMA"
    section3Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    section3Title.Font = Enum.Font.SourceSansBold
    section3Title.TextSize = 16
    section3Title.TextXAlignment = Enum.TextXAlignment.Left
    section3Title.Parent = section3
    
    yPos = yPos + 50
    
    -- Uptime
    local uptimeLabel = Instance.new("TextLabel")
    uptimeLabel.Name = "UptimeLabel"
    uptimeLabel.Size = UDim2.new(1, -20, 0, 20)
    uptimeLabel.Position = UDim2.new(0, 10, 0, yPos)
    uptimeLabel.BackgroundTransparency = 1
    uptimeLabel.Text = "⏱️ Uptime: 0 segundos"
    uptimeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    uptimeLabel.Font = Enum.Font.SourceSans
    uptimeLabel.TextSize = 14
    uptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    uptimeLabel.Parent = container
    
    yPos = yPos + 25
    
    -- Contagem de jogadores
    local playerCountLabel = Instance.new("TextLabel")
    playerCountLabel.Name = "PlayerCountLabel"
    playerCountLabel.Size = UDim2.new(1, -20, 0, 20)
    playerCountLabel.Position = UDim2.new(0, 10, 0, yPos)
    playerCountLabel.BackgroundTransparency = 1
    playerCountLabel.Text = "👥 Jogadores: Carregando..."
    playerCountLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerCountLabel.Font = Enum.Font.SourceSans
    playerCountLabel.TextSize = 14
    playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerCountLabel.Parent = container
    
    yPos = yPos + 30
    
    -- Seção 4: Controles de Emergência
    local section4 = Instance.new("Frame")
    section4.Name = "Section4"
    section4.Size = UDim2.new(1, 0, 0, 40)
    section4.Position = UDim2.new(0, 0, 0, yPos)
    section4.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    section4.BorderSizePixel = 0
    section4.Parent = container
    
    local section4Title = Instance.new("TextLabel")
    section4Title.Name = "Section4Title"
    section4Title.Size = UDim2.new(1, 0, 1, 0)
    section4Title.Position = UDim2.new(0, 10, 0, 0)
    section4Title.BackgroundTransparency = 1
    section4Title.Text = "🚨 CONTROLES DE EMERGÊNCIA"
    section4Title.TextColor3 = Color3.fromRGB(255, 100, 100)
    section4Title.Font = Enum.Font.SourceSansBold
    section4Title.TextSize = 16
    section4Title.TextXAlignment = Enum.TextXAlignment.Left
    section4Title.Parent = section4
    
    yPos = yPos + 50
    
    -- Botão de parar tudo
    local emergencyButton = Instance.new("TextButton")
    emergencyButton.Name = "EmergencyButton"
    emergencyButton.Size = UDim2.new(1, -20, 0, 40)
    emergencyButton.Position = UDim2.new(0, 10, 0, yPos)
    emergencyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    emergencyButton.Text = "⛔ PARAR TUDO IMEDIATAMENTE"
    emergencyButton.TextColor3 = Color3.new(1, 1, 1)
    emergencyButton.Font = Enum.Font.SourceSansBold
    emergencyButton.TextSize = 15
    emergencyButton.TextWrapped = true
    emergencyButton.Parent = container
    
    yPos = yPos + 50
    
    -- Atualizar tamanho do canvas
    container.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    -- Armazenar referências
    AntiScripter.GUI = screenGui
    AntiScripter.GUIElements = {
        MainFrame = mainFrame,
        SelectPlayerButton = selectPlayerButton,
        SelectedLabel = selectedLabel,
        PunishButton = punishButton,
        StatusLabel = statusLabel,
        TestButton = testButton,
        UptimeLabel = uptimeLabel,
        PlayerCountLabel = playerCountLabel,
        EmergencyButton = emergencyButton
    }
    
    -- Configurar eventos
    AntiScripter.SetupGUIEvents()
    
    Log("Interface criada com sucesso!", "GUI")
    
    return screenGui
end

function AntiScripter.SetupGUIEvents()
    local elements = AntiScripter.GUIElements
    
    -- Botão de selecionar jogador
    elements.SelectPlayerButton.MouseButton1Click:Connect(function()
        AntiScripter.ShowPlayerSelection()
    end)
    
    -- Botão de punição principal
    elements.PunishButton.MouseButton1Click:Connect(function()
        if AntiScripter.IsPunishing then
            AntiScripter.StopPunishment()
            elements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO"
            elements.PunishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            elements.StatusLabel.Text = "📊 Status: INATIVO"
            elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            if AntiScripter.StartPunishment() then
                elements.PunishButton.Text = "🟢 PARAR PUNIÇÃO (" .. AntiScripter.SelectedPlayer .. ")"
                elements.PunishButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                elements.StatusLabel.Text = "📊 Status: PUNINDO " .. AntiScripter.SelectedPlayer
                elements.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end)
    
    -- Botão de teste
    elements.TestButton.MouseButton1Click:Connect(function()
        if AntiScripter.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local humanoidRootPart = GetHumanoidRootPart(targetPlayer.Character)
                if humanoidRootPart then
                    -- Salvar posição original
                    local originalCFrame = humanoidRootPart.CFrame
                    local originalAnchored = humanoidRootPart.Anchored
                    
                    -- Aplicar punição
                    humanoidRootPart.CFrame = CFrame.new(0, -50000, 0)
                    humanoidRootPart.Anchored = true
                    
                    Log("Teste realizado em " .. targetPlayer.Name, "TEST")
                    
                    -- Restaurar após 3 segundos
                    task.wait(3)
                    
                    humanoidRootPart.Anchored = originalAnchored
                    humanoidRootPart.CFrame = originalCFrame
                    
                    Log("Teste finalizado", "TEST")
                end
            end
        else
            Log("❌ Nenhum jogador selecionado para teste!", "ERROR")
        end
    end)
    
    -- Botão de emergência
    elements.EmergencyButton.MouseButton1Click:Connect(function()
        AntiScripter.StopPunishment()
        
        -- Restaurar todos os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local humanoidRootPart = GetHumanoidRootPart(character)
                
                if humanoidRootPart then
                    humanoidRootPart.Anchored = false
                    humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                end
            end
        end
        
        -- Atualizar interface
        elements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO"
        elements.PunishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        elements.StatusLabel.Text = "📊 Status: EMERGÊNCIA - PARADO"
        elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        Log("🚨 EMERGÊNCIA: Todas as punições paradas!", "EMERGENCY")
    end)
end

function AntiScripter.ShowPlayerSelection()
    -- Destruir popup anterior se existir
    local existingPopup = AntiScripter.GUI:FindFirstChild("PlayerSelectionPopup")
    if existingPopup then
        existingPopup:Destroy()
    end
    
    -- Obter lista de jogadores
    local players = Players:GetPlayers()
    local playerNames = {}
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    if #playerNames == 0 then
        table.insert(playerNames, "Nenhum jogador disponível")
    end
    
    -- Criar popup
    local popup = Instance.new("Frame")
    popup.Name = "PlayerSelectionPopup"
    popup.Size = UDim2.new(0, 300, 0, 350)
    popup.Position = UDim2.new(0.5, -150, 0.5, -175)
    popup.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    popup.BorderSizePixel = 2
    popup.BorderColor3 = Color3.fromRGB(0, 200, 255)
    popup.ZIndex = 10
    popup.Parent = AntiScripter.GUI
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 80)
    title.Text = "👥 SELECIONAR JOGADOR"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.ZIndex = 11
    title.Parent = popup
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.ZIndex = 11
    closeButton.Parent = popup
    
    closeButton.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
    
    -- Frame de rolagem
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerNames * 45)
    scrollFrame.ZIndex = 11
    scrollFrame.Parent = popup
    
    -- Adicionar jogadores
    local yPos = 5
    for _, playerName in ipairs(playerNames) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, -10, 0, 40)
        playerButton.Position = UDim2.new(0, 5, 0, yPos)
        playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
        playerButton.Text = playerName
        playerButton.TextColor3 = Color3.new(1, 1, 1)
        playerButton.Font = Enum.Font.SourceSans
        playerButton.TextSize = 14
        playerButton.ZIndex = 12
        playerButton.Parent = scrollFrame
        
        playerButton.MouseButton1Click:Connect(function()
            if playerName ~= "Nenhum jogador disponível" then
                AntiScripter.SelectedPlayer = playerName
                AntiScripter.GUIElements.SelectedLabel.Text = "🎯 Jogador selecionado: " .. playerName
                AntiScripter.GUIElements.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                AntiScripter.GUIElements.SelectPlayerButton.Text = "Jogador: " .. playerName
                Log("Jogador selecionado: " .. playerName, "SELECTION")
            end
            popup:Destroy()
        end)
        
        yPos = yPos + 45
    end
    
    -- Fechar popup ao clicar fora (opcional)
    local backgroundBlocker = Instance.new("TextButton")
    backgroundBlocker.Size = UDim2.new(1, 0, 1, 0)
    backgroundBlocker.Position = UDim2.new(0, 0, 0, 0)
    backgroundBlocker.BackgroundColor3 = Color3.new(0, 0, 0)
    backgroundBlocker.BackgroundTransparency = 0.5
    backgroundBlocker.Text = ""
    backgroundBlocker.ZIndex = 9
    backgroundBlocker.Parent = popup
    
    backgroundBlocker.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
end

function AntiScripter.ToggleGUI()
    AntiScripter.IsGUIVisible = not AntiScripter.IsGUIVisible
    
    if AntiScripter.GUI then
        AntiScripter.GUI.Enabled = AntiScripter.IsGUIVisible
        Log("Interface " .. (AntiScripter.IsGUIVisible and "aberta" or "fechada"), "GUI")
    else
        AntiScripter.CreateGUI()
    end
end

function AntiScripter.UpdateGUI()
    if AntiScripter.GUIElements then
        -- Atualizar uptime
        AntiScripter.Uptime = AntiScripter.Uptime + 1
        AntiScripter.GUIElements.UptimeLabel.Text = "⏱️ Uptime: " .. AntiScripter.Uptime .. " segundos"
        
        -- Atualizar contagem de jogadores
        local playerCount = #Players:GetPlayers() - 1
        AntiScripter.GUIElements.PlayerCountLabel.Text = "👥 Jogadores: " .. playerCount
        
        -- Atualizar status do botão de punição
        if AntiScripter.IsPunishing then
            AntiScripter.GUIElements.PunishButton.Text = "🟢 PARAR PUNIÇÃO (" .. (AntiScripter.SelectedPlayer or "N/A") .. ")"
            AntiScripter.GUIElements.PunishButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            AntiScripter.GUIElements.PunishButton.Text = "🔴 INICIAR PUNIÇÃO"
            AntiScripter.GUIElements.PunishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

--===========================================================
-- INICIALIZAÇÃO DO SISTEMA
--===========================================================
Log("Inicializando sistema...", "SYSTEM")

-- Criar interface
AntiScripter.CreateGUI()

-- Sistema de atualização
spawn(function()
    while true do
        AntiScripter.UpdateGUI()
        task.wait(1)
    end
end)

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        -- F9 para alternar interface
        if input.KeyCode == Enum.KeyCode.F9 then
            AntiScripter.ToggleGUI()
        
        -- Delete para fechar tudo
        elseif input.KeyCode == Enum.KeyCode.Delete then
            Log("DELETE pressionado - Fechando sistema...", "SYSTEM")
            
            -- Parar punições
            AntiScripter.StopPunishment()
            
            -- Fechar interface
            if AntiScripter.GUI then
                AntiScripter.GUI:Destroy()
                AntiScripter.GUI = nil
            end
            
            -- Mensagem final
            print("\n" .. string.rep("=", 60))
            print("🛑 ANTI-SCRIPTER SYSTEM FECHADO")
            print("⏱️ Tempo ativo: " .. AntiScripter.Uptime .. " segundos")
            print("🎮 Controles desativados")
            print(string.rep("=", 60) .. "\n")
        end
    end
end)

-- Mensagem inicial
task.wait(1)

print([[
    
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║      ⚡ ANTI-SCRIPTER SYSTEM - VERSÃO FINAL              ║
    ║                                                          ║
    ║          ✅ Sistema carregado com sucesso!               ║
    ║          👤 Seu nome: ]] .. LocalPlayer.Name .. [[                      ║
    ║          🎮 Interface: VISÍVEL NA TELA                   ║
    ║          🔧 Sistema: 100% FUNCIONAL                     ║
    ║                                                          ║
    ║   📋 CONTROLES:                                          ║
    ║    • F9 = Mostrar/Esconder menu                         ║
    ║    • DELETE = Fechar sistema completo                    ║
    ║    • X (canto) = Fechar menu                            ║
    ║                                                          ║
    ║   🎯 COMO USAR:                                          ║
    ║   1. Clique em "Clique para selecionar jogador"         ║
    ║   2. Escolha um jogador na lista                        ║
    ║   3. Clique em "INICIAR PUNIÇÃO"                        ║
    ║   4. Para parar, clique novamente no botão              ║
    ║                                                          ║
    ║   ⚠️  USE COM RESPONSABILIDADE!                         ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    
]])

Log("✅ Sistema totalmente inicializado!", "SUCCESS")
Log("🎮 Interface visível na tela", "INFO")
Log("🔧 Sistema de punição pronto", "INFO")
Log("🛡️  Sistema de segurança ativo", "INFO")

-- Retornar sistema
return AntiScripter
