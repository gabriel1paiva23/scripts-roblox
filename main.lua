-- ANTI-SCRIPTER ULTIMATE SYSTEM - INTERFACE CORRIGIDA
-- SISTEMA COMPLETO COM INTERFACE FUNCIONAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Vamos criar nossa PRÓPRIA interface para garantir que funcione
local LocalPlayer = Players.LocalPlayer

-- Sistema de logs
local function Log(message, type)
    local timestamp = os.date("[%H:%M:%S]")
    local logEntry = timestamp .. " [" .. type .. "] " .. message
    print("📝 " .. logEntry)
    return logEntry
end

Log("🚀 Iniciando Anti-Scripter Ultimate System", "SYSTEM")

--===========================================================
-- SISTEMA DE INTERFACE MANUAL 100% FUNCIONAL
--===========================================================
local Interface = {
    MainGUI = nil,
    IsOpen = true,
    Elements = {}
}

-- Criar interface principal
function Interface.Create()
    Log("Criando interface manual...", "INTERFACE")
    
    -- Remover GUIs antigas
    if Interface.MainGUI then
        Interface.MainGUI:Destroy()
    end
    
    -- Criar ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiScripterUltimateGUI"
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Selectable = true
    mainFrame.Parent = screenGui
    
    -- Sombreamento
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 150, 255)
    shadow.Thickness = 3
    shadow.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
    title.Text = "⚡ ANTI-SCRIPTER ULTIMATE SYSTEM ⚡"
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
        Interface.Toggle()
    end)
    
    -- Container para abas
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -20, 1, -60)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    -- Botões de abas
    local tabButtons = {}
    local tabs = {}
    
    -- Aba 1: Controle
    local controlTab = Instance.new("ScrollingFrame")
    controlTab.Name = "ControlTab"
    controlTab.Size = UDim2.new(1, 0, 1, 0)
    controlTab.Position = UDim2.new(0, 0, 0, 0)
    controlTab.BackgroundTransparency = 1
    controlTab.ScrollBarThickness = 6
    controlTab.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    controlTab.CanvasSize = UDim2.new(0, 0, 2, 0)
    controlTab.Visible = true
    controlTab.Parent = tabContainer
    
    tabs.Control = controlTab
    
    -- Aba 2: Monitor
    local monitorTab = Instance.new("ScrollingFrame")
    monitorTab.Name = "MonitorTab"
    monitorTab.Size = UDim2.new(1, 0, 1, 0)
    monitorTab.Position = UDim2.new(0, 0, 0, 0)
    monitorTab.BackgroundTransparency = 1
    monitorTab.ScrollBarThickness = 6
    monitorTab.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    monitorTab.CanvasSize = UDim2.new(0, 0, 2, 0)
    monitorTab.Visible = false
    monitorTab.Parent = tabContainer
    
    tabs.Monitor = monitorTab
    
    -- Aba 3: Config
    local configTab = Instance.new("ScrollingFrame")
    configTab.Name = "ConfigTab"
    configTab.Size = UDim2.new(1, 0, 1, 0)
    configTab.Position = UDim2.new(0, 0, 0, 0)
    configTab.BackgroundTransparency = 1
    configTab.ScrollBarThickness = 6
    configTab.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    configTab.CanvasSize = UDim2.new(0, 0, 2, 0)
    configTab.Visible = false
    configTab.Parent = tabContainer
    
    tabs.Config = configTab
    
    -- Botões de navegação
    local navFrame = Instance.new("Frame")
    navFrame.Name = "Navigation"
    navFrame.Size = UDim2.new(1, -20, 0, 40)
    navFrame.Position = UDim2.new(0, 10, 0, 45)
    navFrame.BackgroundTransparency = 1
    navFrame.Parent = mainFrame
    
    local function createTabButton(name, position, tab)
        local button = Instance.new("TextButton")
        button.Name = name .. "Button"
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        button.Text = name
        button.TextColor3 = Color3.fromRGB(200, 200, 255)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = navFrame
        
        button.MouseButton1Click:Connect(function()
            -- Esconder todas as abas
            for _, t in pairs(tabs) do
                t.Visible = false
            end
            
            -- Mostrar aba selecionada
            tab.Visible = true
            
            -- Atualizar aparência dos botões
            for _, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
                btn.TextColor3 = Color3.fromRGB(200, 200, 255)
            end
            
            -- Destacar botão ativo
            button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            button.TextColor3 = Color3.new(1, 1, 1)
        end)
        
        table.insert(tabButtons, button)
        return button
    end
    
    -- Criar botões das abas
    createTabButton("🎮 CONTROLE", UDim2.new(0, 0, 0, 0), controlTab)
    createTabButton("📊 MONITOR", UDim2.new(0.33, 0, 0, 0), monitorTab)
    createTabButton("⚙️ CONFIG", UDim2.new(0.66, 0, 0, 0), configTab)
    
    -- Ativar primeira aba
    tabButtons[1]:MouseButton1Click()
    
    -- Armazenar referências
    Interface.MainGUI = screenGui
    Interface.MainFrame = mainFrame
    Interface.Tabs = tabs
    Interface.TabButtons = tabButtons
    
    -- Criar conteúdo das abas
    Interface.CreateControlTab(controlTab)
    Interface.CreateMonitorTab(monitorTab)
    Interface.CreateConfigTab(configTab)
    
    Log("Interface criada com sucesso!", "SUCCESS")
    
    return screenGui
end

-- Criar aba de Controle
function Interface.CreateControlTab(tab)
    Log("Criando aba de Controle...", "INTERFACE")
    
    local yPosition = 10
    
    -- Seção: Seleção de Jogador
    local section1 = Interface.CreateSection("👥 SELEÇÃO DE JOGADOR", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Label de instrução
    local instruction = Instance.new("TextLabel")
    instruction.Name = "Instruction"
    instruction.Size = UDim2.new(1, -20, 0, 30)
    instruction.Position = UDim2.new(0, 10, 0, yPosition)
    instruction.BackgroundTransparency = 1
    instruction.Text = "Selecione um jogador para punir:"
    instruction.TextColor3 = Color3.fromRGB(200, 200, 255)
    instruction.Font = Enum.Font.SourceSans
    instruction.TextSize = 14
    instruction.TextXAlignment = Enum.TextXAlignment.Left
    instruction.Parent = tab
    yPosition = yPosition + 35
    
    -- Dropdown de jogadores (simulado com botão)
    Interface.Elements.PlayerDropdown = Instance.new("TextButton")
    Interface.Elements.PlayerDropdown.Name = "PlayerDropdown"
    Interface.Elements.PlayerDropdown.Size = UDim2.new(1, -20, 0, 35)
    Interface.Elements.PlayerDropdown.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    Interface.Elements.PlayerDropdown.Text = "Clique para selecionar jogador"
    Interface.Elements.PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
    Interface.Elements.PlayerDropdown.Font = Enum.Font.SourceSansBold
    Interface.Elements.PlayerDropdown.TextSize = 14
    Interface.Elements.PlayerDropdown.Parent = tab
    yPosition = yPosition + 45
    
    -- Label do jogador selecionado
    Interface.Elements.SelectedPlayerLabel = Instance.new("TextLabel")
    Interface.Elements.SelectedPlayerLabel.Name = "SelectedPlayerLabel"
    Interface.Elements.SelectedPlayerLabel.Size = UDim2.new(1, -20, 0, 25)
    Interface.Elements.SelectedPlayerLabel.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.SelectedPlayerLabel.BackgroundTransparency = 1
    Interface.Elements.SelectedPlayerLabel.Text = "🎯 Jogador selecionado: NENHUM"
    Interface.Elements.SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    Interface.Elements.SelectedPlayerLabel.Font = Enum.Font.SourceSansBold
    Interface.Elements.SelectedPlayerLabel.TextSize = 14
    Interface.Elements.SelectedPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    Interface.Elements.SelectedPlayerLabel.Parent = tab
    yPosition = yPosition + 35
    
    -- Botão para atualizar lista
    local updateButton = Instance.new("TextButton")
    updateButton.Name = "UpdateButton"
    updateButton.Size = UDim2.new(1, -20, 0, 30)
    updateButton.Position = UDim2.new(0, 10, 0, yPosition)
    updateButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    updateButton.Text = "🔄 Atualizar Lista de Jogadores"
    updateButton.TextColor3 = Color3.new(1, 1, 1)
    updateButton.Font = Enum.Font.SourceSansBold
    updateButton.TextSize = 14
    updateButton.Parent = tab
    yPosition = yPosition + 40
    
    -- Separador
    yPosition = yPosition + 10
    
    -- Seção: Sistema de Punição
    local section2 = Interface.CreateSection("⚡ SISTEMA DE PUNIÇÃO", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Botão PRINCIPAL de punição
    Interface.Elements.MainPunishButton = Instance.new("TextButton")
    Interface.Elements.MainPunishButton.Name = "MainPunishButton"
    Interface.Elements.MainPunishButton.Size = UDim2.new(1, -20, 0, 50)
    Interface.Elements.MainPunishButton.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.MainPunishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Interface.Elements.MainPunishButton.Text = "🔴 INICIAR PUNIÇÃO COMPLETA"
    Interface.Elements.MainPunishButton.TextColor3 = Color3.new(1, 1, 1)
    Interface.Elements.MainPunishButton.Font = Enum.Font.SourceSansBold
    Interface.Elements.MainPunishButton.TextSize = 16
    Interface.Elements.MainPunishButton.TextWrapped = true
    Interface.Elements.MainPunishButton.Parent = tab
    yPosition = yPosition + 60
    
    -- Status da punição
    Interface.Elements.PunishmentStatus = Instance.new("TextLabel")
    Interface.Elements.PunishmentStatus.Name = "PunishmentStatus"
    Interface.Elements.PunishmentStatus.Size = UDim2.new(1, -20, 0, 30)
    Interface.Elements.PunishmentStatus.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.PunishmentStatus.BackgroundTransparency = 1
    Interface.Elements.PunishmentStatus.Text = "📊 Status: INATIVO"
    Interface.Elements.PunishmentStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    Interface.Elements.PunishmentStatus.Font = Enum.Font.SourceSansBold
    Interface.Elements.PunishmentStatus.TextSize = 14
    Interface.Elements.PunishmentStatus.TextXAlignment = Enum.TextXAlignment.Left
    Interface.Elements.PunishmentStatus.Parent = tab
    yPosition = yPosition + 35
    
    -- Botão de teste
    local testButton = Instance.new("TextButton")
    testButton.Name = "TestButton"
    testButton.Size = UDim2.new(1, -20, 0, 35)
    testButton.Position = UDim2.new(0, 10, 0, yPosition)
    testButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    testButton.Text = "🧪 TESTE RÁPIDO (Camada 1)"
    testButton.TextColor3 = Color3.new(1, 1, 1)
    testButton.Font = Enum.Font.SourceSansBold
    testButton.TextSize = 14
    testButton.Parent = tab
    yPosition = yPosition + 45
    
    -- Ajustar canvas size
    tab.CanvasSize = UDim2.new(0, 0, 0, yPosition + 50)
end

-- Criar aba de Monitoramento
function Interface.CreateMonitorTab(tab)
    Log("Criando aba de Monitoramento...", "INTERFACE")
    
    local yPosition = 10
    
    -- Seção: Status do Sistema
    local section1 = Interface.CreateSection("🖥️ STATUS DO SISTEMA", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Status labels
    Interface.Elements.SystemStatus = Instance.new("TextLabel")
    Interface.Elements.SystemStatus.Name = "SystemStatus"
    Interface.Elements.SystemStatus.Size = UDim2.new(1, -20, 0, 25)
    Interface.Elements.SystemStatus.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.SystemStatus.BackgroundTransparency = 1
    Interface.Elements.SystemStatus.Text = "🟢 Sistema: ATIVO"
    Interface.Elements.SystemStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    Interface.Elements.SystemStatus.Font = Enum.Font.SourceSansBold
    Interface.Elements.SystemStatus.TextSize = 14
    Interface.Elements.SystemStatus.TextXAlignment = Enum.TextXAlignment.Left
    Interface.Elements.SystemStatus.Parent = tab
    yPosition = yPosition + 30
    
    Interface.Elements.UptimeLabel = Instance.new("TextLabel")
    Interface.Elements.UptimeLabel.Name = "UptimeLabel"
    Interface.Elements.UptimeLabel.Size = UDim2.new(1, -20, 0, 25)
    Interface.Elements.UptimeLabel.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.UptimeLabel.BackgroundTransparency = 1
    Interface.Elements.UptimeLabel.Text = "⏱️ Uptime: 0 segundos"
    Interface.Elements.UptimeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    Interface.Elements.UptimeLabel.Font = Enum.Font.SourceSans
    Interface.Elements.UptimeLabel.TextSize = 14
    Interface.Elements.UptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    Interface.Elements.UptimeLabel.Parent = tab
    yPosition = yPosition + 30
    
    Interface.Elements.PlayerCountLabel = Instance.new("TextLabel")
    Interface.Elements.PlayerCountLabel.Name = "PlayerCountLabel"
    Interface.Elements.PlayerCountLabel.Size = UDim2.new(1, -20, 0, 25)
    Interface.Elements.PlayerCountLabel.Position = UDim2.new(0, 10, 0, yPosition)
    Interface.Elements.PlayerCountLabel.BackgroundTransparency = 1
    Interface.Elements.PlayerCountLabel.Text = "👥 Jogadores: Carregando..."
    Interface.Elements.PlayerCountLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    Interface.Elements.PlayerCountLabel.Font = Enum.Font.SourceSans
    Interface.Elements.PlayerCountLabel.TextSize = 14
    Interface.Elements.PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    Interface.Elements.PlayerCountLabel.Parent = tab
    yPosition = yPosition + 40
    
    -- Separador
    yPosition = yPosition + 10
    
    -- Seção: Status das Camadas
    local section2 = Interface.CreateSection("🔧 STATUS DAS CAMADAS", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Labels para cada camada
    Interface.Elements.LayerStatus = {}
    local layers = {
        "1️⃣ VOID PRIMÁRIO",
        "2️⃣ VOID SECUNDÁRIO",
        "3️⃣ VOID TERCIÁRIO",
        "4️⃣ VOID QUATERNÁRIO",
        "5️⃣ VOID QUINTÁRIO",
        "6️⃣ VOID SEXTÁRIO",
        "7️⃣ VOID SEPTENÁRIO",
        "8️⃣ VOID OCTONÁRIO",
        "9️⃣ VOID NONÁRIO",
        "🔟 VOID DÉCIMO"
    }
    
    for i, layerName in ipairs(layers) do
        local layerLabel = Instance.new("TextLabel")
        layerLabel.Name = "Layer" .. i
        layerLabel.Size = UDim2.new(1, -20, 0, 20)
        layerLabel.Position = UDim2.new(0, 10, 0, yPosition)
        layerLabel.BackgroundTransparency = 1
        layerLabel.Text = layerName .. ": 🔴 INATIVO"
        layerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        layerLabel.Font = Enum.Font.SourceSans
        layerLabel.TextSize = 13
        layerLabel.TextXAlignment = Enum.TextXAlignment.Left
        layerLabel.Parent = tab
        
        Interface.Elements.LayerStatus[i] = layerLabel
        yPosition = yPosition + 25
    end
    
    yPosition = yPosition + 10
    
    -- Ajustar canvas size
    tab.CanvasSize = UDim2.new(0, 0, 0, yPosition + 50)
end

-- Criar aba de Configurações
function Interface.CreateConfigTab(tab)
    Log("Criando aba de Configurações...", "INTERFACE")
    
    local yPosition = 10
    
    -- Seção: Configurações
    local section1 = Interface.CreateSection("⚙️ CONFIGURAÇÕES", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Toggles
    Interface.Elements.Toggles = {}
    
    local toggleSettings = {
        {"Auto-atualizar Lista", true},
        {"Modo Extremo", true},
        {"Mostrar Debug", true},
        {"Anti-Anti-Script", true}
    }
    
    for i, setting in ipairs(toggleSettings) do
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle" .. i
        toggleFrame.Size = UDim2.new(1, -20, 0, 30)
        toggleFrame.Position = UDim2.new(0, 10, 0, yPosition)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = tab
        
        local toggleText = Instance.new("TextLabel")
        toggleText.Name = "ToggleText"
        toggleText.Size = UDim2.new(0.7, 0, 1, 0)
        toggleText.Position = UDim2.new(0, 0, 0, 0)
        toggleText.BackgroundTransparency = 1
        toggleText.Text = setting[1]
        toggleText.TextColor3 = Color3.fromRGB(200, 200, 255)
        toggleText.Font = Enum.Font.SourceSans
        toggleText.TextSize = 14
        toggleText.TextXAlignment = Enum.TextXAlignment.Left
        toggleText.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggleButton.BackgroundColor3 = setting[2] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleButton.Text = setting[2] and "ON" or "OFF"
        toggleButton.TextColor3 = Color3.new(1, 1, 1)
        toggleButton.Font = Enum.Font.SourceSansBold
        toggleButton.TextSize = 12
        toggleButton.Parent = toggleFrame
        
        Interface.Elements.Toggles[setting[1]] = {button = toggleButton, state = setting[2]}
        
        toggleButton.MouseButton1Click:Connect(function()
            local currentState = Interface.Elements.Toggles[setting[1]].state
            local newState = not currentState
            
            Interface.Elements.Toggles[setting[1]].state = newState
            toggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            toggleButton.Text = newState and "ON" or "OFF"
            
            Log("Configuração '" .. setting[1] .. "' alterada para: " .. (newState and "ON" or "OFF"), "CONFIG")
        end)
        
        yPosition = yPosition + 35
    end
    
    yPosition = yPosition + 20
    
    -- Seção: Ferramentas
    local section2 = Interface.CreateSection("🔧 FERRAMENTAS", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Botão para ver jogadores
    local viewPlayersButton = Instance.new("TextButton")
    viewPlayersButton.Name = "ViewPlayersButton"
    viewPlayersButton.Size = UDim2.new(1, -20, 0, 35)
    viewPlayersButton.Position = UDim2.new(0, 10, 0, yPosition)
    viewPlayersButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    viewPlayersButton.Text = "📋 Ver Todos os Jogadores (Console)"
    viewPlayersButton.TextColor3 = Color3.new(1, 1, 1)
    viewPlayersButton.Font = Enum.Font.SourceSansBold
    viewPlayersButton.TextSize = 14
    viewPlayersButton.Parent = tab
    yPosition = yPosition + 45
    
    -- Botão para limpar efeitos
    local clearEffectsButton = Instance.new("TextButton")
    clearEffectsButton.Name = "ClearEffectsButton"
    clearEffectsButton.Size = UDim2.new(1, -20, 0, 35)
    clearEffectsButton.Position = UDim2.new(0, 10, 0, yPosition)
    clearEffectsButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    clearEffectsButton.Text = "🧹 Limpar Todos os Efeitos"
    clearEffectsButton.TextColor3 = Color3.new(1, 1, 1)
    clearEffectsButton.Font = Enum.Font.SourceSansBold
    clearEffectsButton.TextSize = 14
    clearEffectsButton.Parent = tab
    yPosition = yPosition + 50
    
    -- Seção: Emergência
    local section3 = Interface.CreateSection("🚨 EMERGÊNCIA", yPosition, tab)
    yPosition = yPosition + 50
    
    -- Botão de parar tudo
    local emergencyButton = Instance.new("TextButton")
    emergencyButton.Name = "EmergencyButton"
    emergencyButton.Size = UDim2.new(1, -20, 0, 40)
    emergencyButton.Position = UDim2.new(0, 10, 0, yPosition)
    emergencyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    emergencyButton.Text = "⛔ PARAR TUDO IMEDIATAMENTE"
    emergencyButton.TextColor3 = Color3.new(1, 1, 1)
    emergencyButton.Font = Enum.Font.SourceSansBold
    emergencyButton.TextSize = 16
    emergencyButton.TextWrapped = true
    emergencyButton.Parent = tab
    yPosition = yPosition + 50
    
    -- Ajustar canvas size
    tab.CanvasSize = UDim2.new(0, 0, 0, yPosition + 50)
end

-- Função auxiliar para criar seções
function Interface.CreateSection(title, yPosition, parent)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. string.gsub(title, "[^%w]", "")
    section.Size = UDim2.new(1, -20, 0, 40)
    section.Position = UDim2.new(0, 10, 0, yPosition)
    section.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, 0, 1, 0)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
    sectionTitle.Font = Enum.Font.SourceSansBold
    sectionTitle.TextSize = 16
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    return section
end

-- Alternar visibilidade da interface
function Interface.Toggle()
    Interface.IsOpen = not Interface.IsOpen
    
    if Interface.MainGUI then
        Interface.MainGUI.Enabled = Interface.IsOpen
        Log("Interface " .. (Interface.IsOpen and "aberta" or "fechada"), "INTERFACE")
    else
        Interface.Create()
    end
end

-- Atualizar label
function Interface.UpdateLabel(labelName, text, color)
    if Interface.Elements[labelName] then
        Interface.Elements[labelName].Text = text
        if color then
            Interface.Elements[labelName].TextColor3 = color
        end
    end
end

-- Atualizar status da camada
function Interface.UpdateLayerStatus(layerIndex, isActive)
    if Interface.Elements.LayerStatus and Interface.Elements.LayerStatus[layerIndex] then
        local layerLabel = Interface.Elements.LayerStatus[layerIndex]
        if isActive then
            layerLabel.Text = string.gsub(layerLabel.Text, ": 🔴 INATIVO", ": 🟢 ATIVO")
            layerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            layerLabel.Text = string.gsub(layerLabel.Text, ": 🟢 ATIVO", ": 🔴 INATIVO")
            layerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end

-- Criar popup de seleção de jogadores
function Interface.CreatePlayerSelection()
    local players = Players:GetPlayers()
    local playerNames = {}
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    if #playerNames == 0 then
        playerNames = {"Nenhum jogador disponível"}
    end
    
    -- Criar popup
    local popup = Instance.new("Frame")
    popup.Name = "PlayerSelectionPopup"
    popup.Size = UDim2.new(0, 300, 0, 400)
    popup.Position = UDim2.new(0.5, -150, 0.5, -200)
    popup.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    popup.BorderSizePixel = 2
    popup.BorderColor3 = Color3.fromRGB(0, 255, 255)
    popup.Parent = Interface.MainGUI
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
    title.Text = "👥 SELECIONAR JOGADOR"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = popup
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.Parent = popup
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerNames * 40)
    scrollFrame.Parent = popup
    
    local yPos = 5
    for _, playerName in ipairs(playerNames) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, -10, 0, 35)
        playerButton.Position = UDim2.new(0, 5, 0, yPos)
        playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
        playerButton.Text = playerName
        playerButton.TextColor3 = Color3.new(1, 1, 1)
        playerButton.Font = Enum.Font.SourceSans
        playerButton.TextSize = 14
        playerButton.Parent = scrollFrame
        
        playerButton.MouseButton1Click:Connect(function()
            if playerName ~= "Nenhum jogador disponível" then
                Interface.UpdateLabel("SelectedPlayerLabel", "🎯 Jogador selecionado: " .. playerName, Color3.fromRGB(255, 255, 100))
                Interface.Elements.PlayerDropdown.Text = "Jogador: " .. playerName
                AntiScripter.SelectedPlayer = playerName
                Log("Jogador selecionado: " .. playerName, "SELECTION")
            end
            popup:Destroy()
        end)
        
        yPos = yPos + 40
    end
    
    closeButton.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
end

-- Inicializar interface
Interface.Create()

--===========================================================
-- SISTEMA DE PUNIÇÃO - SIMPLIFICADO MAS EFETIVO
--===========================================================
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    TargetPlayer = nil,
    VoidLoop = nil,
    Layers = {},
    Uptime = 0
}

-- Sistema de camadas simplificado
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
    
    -- Atualizar interface
    Interface.UpdateLabel("PunishmentStatus", "📊 Status: 🔴 PUNINDO " .. targetPlayer.Name, Color3.fromRGB(255, 0, 0))
    Interface.Elements.MainPunishButton.Text = "🟢 PARAR PUNIÇÃO (" .. targetPlayer.Name .. ")"
    Interface.Elements.MainPunishButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    
    -- Iniciar todas as camadas
    for i = 1, 10 do
        Interface.UpdateLayerStatus(i, true)
    end
    
    Log("🚀 Punição INICIADA para " .. targetPlayer.Name, "PUNISHMENT")
    
    -- Iniciar loop principal
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if AntiScripter.IsPunishing and targetPlayer and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or 
                                     character:FindFirstChild("Torso") or
                                     character:FindFirstChild("UpperTorso")
            
            if humanoidRootPart then
                -- CAMADA 1: Teleporte para void profundo
                humanoidRootPart.CFrame = CFrame.new(0, -100000, 0)
                
                -- CAMADA 2: Congelar no lugar
                humanoidRootPart.Anchored = true
                
                -- CAMADA 3: Remover ferramentas
                for _, item in pairs(character:GetChildren()) do
                    if item:IsA("Tool") then
                        item:Destroy()
                    end
                end
                
                -- CAMADA 4: Desabilitar scripts
                for _, script in pairs(character:GetDescendants()) do
                    if script:IsA("LocalScript") then
                        script.Disabled = true
                    end
                end
                
                -- CAMADA 5: Efeito visual
                if math.random(1, 10) == 1 then
                    local effect = Instance.new("Part")
                    effect.Size = Vector3.new(5, 5, 5)
                    effect.Position = humanoidRootPart.Position
                    effect.Anchored = true
                    effect.CanCollide = false
                    effect.Transparency = 0.5
                    effect.BrickColor = BrickColor.new("Bright red")
                    effect.Material = Enum.Material.Neon
                    effect.Parent = Workspace
                    game:GetService("Debris"):AddItem(effect, 1)
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
    
    -- Restaurar jogador se ainda estiver no jogo
    if AntiScripter.TargetPlayer and AntiScripter.TargetPlayer.Character then
        local character = AntiScripter.TargetPlayer.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or 
                                 character:FindFirstChild("Torso") or
                                 character:FindFirstChild("UpperTorso")
        
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
            humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        end
    end
    
    -- Atualizar interface
    Interface.UpdateLabel("PunishmentStatus", "📊 Status: 🟢 INATIVO", Color3.fromRGB(0, 255, 0))
    Interface.Elements.MainPunishButton.Text = "🔴 INICIAR PUNIÇÃO COMPLETA"
    Interface.Elements.MainPunishButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    
    -- Desativar todas as camadas
    for i = 1, 10 do
        Interface.UpdateLayerStatus(i, false)
    end
    
    Log("🛑 Punição PARADA", "PUNISHMENT")
    
    AntiScripter.TargetPlayer = nil
    return true
end

--===========================================================
-- CONFIGURAR EVENTOS DA INTERFACE
--===========================================================
Log("Configurando eventos da interface...", "INTERFACE")

-- Botão dropdown de jogadores
Interface.Elements.PlayerDropdown.MouseButton1Click:Connect(function()
    Interface.CreatePlayerSelection()
end)

-- Botão de atualizar lista
local updateButton = Interface.Elements.PlayerDropdown.Parent:FindFirstChild("UpdateButton")
if updateButton then
    updateButton.MouseButton1Click:Connect(function()
        Interface.CreatePlayerSelection()
    end)
end

-- Botão principal de punição
Interface.Elements.MainPunishButton.MouseButton1Click:Connect(function()
    if AntiScripter.IsPunishing then
        AntiScripter.StopPunishment()
    else
        AntiScripter.StartPunishment()
    end
end)

-- Botão de teste
local testButton = Interface.Elements.MainPunishButton.Parent:FindFirstChild("TestButton")
if testButton then
    testButton.MouseButton1Click:Connect(function()
        if AntiScripter.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.CFrame = CFrame.new(0, -50000, 0)
                    humanoidRootPart.Anchored = true
                    Log("🧪 Teste realizado em " .. targetPlayer.Name, "TEST")
                    
                    -- Restaurar após 3 segundos
                    task.wait(3)
                    humanoidRootPart.Anchored = false
                    humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                end
            end
        end
    end)
end

-- Botão de ver jogadores
local viewPlayersButton = Interface.Tabs.Config:FindFirstChild("ViewPlayersButton")
if viewPlayersButton then
    viewPlayersButton.MouseButton1Click:Connect(function()
        print("\n" .. string.rep("=", 50))
        print("👥 LISTA DE JOGADORES:")
        print(string.rep("-", 50))
        
        local count = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                print("👤 " .. player.Name .. " (ID: " .. player.UserId .. ")")
                count = count + 1
            end
        end
        
        print(string.rep("-", 50))
        print("Total: " .. count .. " jogador(es)")
        print(string.rep("=", 50) .. "\n")
        
        Log("Lista de jogadores exibida no console", "INFO")
    end)
end

-- Botão de limpar efeitos
local clearEffectsButton = Interface.Tabs.Config:FindFirstChild("ClearEffectsButton")
if clearEffectsButton then
    clearEffectsButton.MouseButton1Click:Connect(function()
        AntiScripter.StopPunishment()
        Log("🧹 Todos os efeitos foram limpos", "CLEANUP")
    end)
end

-- Botão de emergência
local emergencyButton = Interface.Tabs.Config:FindFirstChild("EmergencyButton")
if emergencyButton then
    emergencyButton.MouseButton1Click:Connect(function()
        AntiScripter.StopPunishment()
        
        -- Restaurar todos os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or 
                                         character:FindFirstChild("Torso")
                
                if humanoidRootPart then
                    humanoidRootPart.Anchored = false
                    humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                end
            end
        end
        
        Log("🚨 EMERGÊNCIA: Todas as punições paradas!", "EMERGENCY")
    end)
end

--===========================================================
-- SISTEMA DE ATUALIZAÇÃO EM TEMPO REAL
--===========================================================
Log("Iniciando sistema de atualização...", "SYSTEM")

spawn(function()
    while true do
        -- Atualizar uptime
        AntiScripter.Uptime = AntiScripter.Uptime + 1
        Interface.UpdateLabel("UptimeLabel", "⏱️ Uptime: " .. AntiScripter.Uptime .. " segundos")
        
        -- Atualizar contagem de jogadores
        local playerCount = #Players:GetPlayers() - 1
        Interface.UpdateLabel("PlayerCountLabel", "👥 Jogadores: " .. playerCount)
        
        -- Atualizar status do sistema
        local systemStatus = AntiScripter.IsPunishing and "🔴 PUNINDO" or "🟢 ATIVO"
        local statusColor = AntiScripter.IsPunishing and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        Interface.UpdateLabel("SystemStatus", "🖥️ Sistema: " .. systemStatus, statusColor)
        
        task.wait(1)
    end
end)

--===========================================================
-- CONTROLES DE TECLADO
--===========================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        -- F9 para alternar interface
        if input.KeyCode == Enum.KeyCode.F9 then
            Interface.Toggle()
        
        -- Delete para fechar tudo
        elseif input.KeyCode == Enum.KeyCode.Delete then
            Log("DELETE pressionado - Fechando sistema...", "SYSTEM")
            
            -- Parar punições
            AntiScripter.StopPunishment()
            
            -- Fechar interface
            if Interface.MainGUI then
                Interface.MainGUI:Destroy()
            end
            
            -- Mensagem final
            print("\n" .. string.rep("=", 60))
            print("🛑 ANTI-SCRIPTER SYSTEM FECHADO")
            print("⏱️ Tempo ativo: " .. AntiScripter.Uptime .. " segundos")
            print("👤 Jogador atual: " .. LocalPlayer.Name)
            print(string.rep("=", 60) .. "\n")
        end
    end
end)

--===========================================================
-- MENSAGEM DE INICIALIZAÇÃO
--===========================================================
task.wait(1)

print([[
    
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║      🚀 ANTI-SCRIPTER ULTIMATE SYSTEM                   ║
    ║                                                          ║
    ║          ✅ Sistema carregado com sucesso!               ║
    ║          👤 Seu nome: ]] .. LocalPlayer.Name .. [[                      ║
    ║          🔧 Interface: PRONTA (F9 para abrir/fechar)     ║
    ║          🎮 Controles:                                  ║
    ║            • F9 = Abrir/Fechar menu                     ║
    ║            • DELETE = Fechar sistema                    ║
    ║                                                          ║
    ║   📋 INSTRUÇÕES:                                        ║
    ║   1. Abra o menu (F9)                                   ║
    ║   2. Clique em "Clique para selecionar jogador"         ║
    ║   3. Selecione um jogador na lista                      ║
    ║   4. Clique em "INICIAR PUNIÇÃO COMPLETA"               ║
    ║   5. Para parar, clique novamente no botão              ║
    ║                                                          ║
    ║   ⚠️  USE ESTE PODER COM RESPONSABILIDADE!              ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    
]])

Log("Sistema totalmente inicializado e funcional!", "SUCCESS")
Log("Pressione F9 para abrir/fechar o menu", "INFO")
Log("Pressione DELETE para fechar o sistema", "INFO")

-- Retornar instância do sistema
return {
    Interface = Interface,
    System = AntiScripter,
    Log = Log
}
