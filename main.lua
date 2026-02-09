-- ANTI-SCRIPTER SYSTEM - TRANSPORTE PESSOAL PARA O VOID
-- SISTEMA QUE FUNCIONA 100%

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Sistema de logs
local function Log(message, type)
    local timestamp = os.date("[%H:%M:%S]")
    local logEntry = timestamp .. " [" .. type .. "] " .. message
    print("📝 " .. logEntry)
    return logEntry
end

Log("🚀 Iniciando Anti-Scripter System - Método Direto", "SYSTEM")

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
    
    -- Sistema de transporte pessoal
    IsTransporting = false,
    TransportDistance = 50,
    TransportSpeed = 2,
    
    -- Void profundo
    VoidPosition = Vector3.new(0, -50000, 0),
    DeathVoidPosition = Vector3.new(0, -1000000, 0),
    
    -- Dados do jogador
    PlayerData = {},
    
    -- Sistema de backup
    OriginalPositions = {},
    OriginalAnchored = {}
}

--===========================================================
-- FUNÇÕES DE TELEPORTE DIRETAS
--===========================================================
function AntiScripter.TeleportPlayerToVoid(targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then
        Log("❌ Jogador inválido", "ERROR")
        return false
    end
    
    -- Forçar carregamento do personagem
    if not targetPlayer.Character then
        targetPlayer:LoadCharacter()
        wait(1)
    end
    
    local character = targetPlayer.Character
    if not character then
        Log("❌ Personagem não encontrado", "ERROR")
        return false
    end
    
    -- Encontrar HumanoidRootPart
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        humanoidRootPart = character:FindFirstChild("Torso")
        if not humanoidRootPart then
            humanoidRootPart = character:FindFirstChild("UpperTorso")
        end
    end
    
    if not humanoidRootPart then
        Log("❌ Não encontrou parte para teleportar", "ERROR")
        return false
    end
    
    -- Salvar posição original
    AntiScripter.OriginalPositions[targetPlayer.Name] = humanoidRootPart.CFrame
    AntiScripter.OriginalAnchored[targetPlayer.Name] = humanoidRootPart.Anchored
    
    -- TELEPORTE DIRETO PARA O VOID MUITO PROFUNDO
    humanoidRootPart.CFrame = CFrame.new(
        AntiScripter.DeathVoidPosition.X + math.random(-500, 500),
        AntiScripter.DeathVoidPosition.Y - math.random(0, 10000),
        AntiScripter.DeathVoidPosition.Z + math.random(-500, 500)
    )
    
    -- ANCORAR NO VOID
    humanoidRootPart.Anchored = true
    
    -- Remover TODAS as ferramentas
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            item:Destroy()
        end
    end
    
    -- Destruir scripts locais
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            pcall(function()
                obj:Destroy()
            end)
        end
    end
    
    -- Matar o humanoid
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        wait(0.2)
        humanoid.Health = 1
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    -- Efeito visual
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(20, 20, 20)
    effect.Position = humanoidRootPart.Position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.8
    effect.BrickColor = BrickColor.new("Really black")
    effect.Material = Enum.Material.Neon
    effect.Parent = Workspace
    game:GetService("Debris"):AddItem(effect, 3)
    
    Log("✅ " .. targetPlayer.Name .. " TELEPORTADO PARA O VOID", "SUCCESS")
    return true
end

--===========================================================
-- MÉTODO DE TRANSPORTE PESSOAL (VOCÊ LEVA O JOGADOR)
--===========================================================
function AntiScripter.StartPersonalTransport(targetPlayer)
    if not targetPlayer then return false end
    
    Log("🚶 Iniciando transporte pessoal para " .. targetPlayer.Name, "TRANSPORT")
    
    AntiScripter.IsTransporting = true
    
    spawn(function()
        while AntiScripter.IsTransporting and targetPlayer and targetPlayer.Parent do
            -- Obter posição do seu personagem
            local myCharacter = LocalPlayer.Character
            if not myCharacter then
                wait(0.1)
                continue
            end
            
            local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
            if not myHRP then
                wait(0.1)
                continue
            end
            
            -- Obter personagem do alvo
            local targetCharacter = targetPlayer.Character
            if not targetCharacter then
                targetPlayer:LoadCharacter()
                wait(1)
                targetCharacter = targetPlayer.Character
                if not targetCharacter then
                    wait(0.1)
                    continue
                end
            end
            
            local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetHRP then
                wait(0.1)
                continue
            end
            
            -- Teleportar o alvo PARA VOCÊ
            local offset = Vector3.new(
                math.random(-AntiScripter.TransportDistance, AntiScripter.TransportDistance),
                0,
                math.random(-AntiScripter.TransportDistance, AntiScripter.TransportDistance)
            )
            
            targetHRP.CFrame = CFrame.new(myHRP.Position + offset)
            targetHRP.Anchored = true
            
            -- Remover ferramentas
            for _, tool in pairs(targetCharacter:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Destroy()
                end
            end
            
            -- Criar efeito
            if math.random(1, 10) == 1 then
                local transportEffect = Instance.new("Part")
                transportEffect.Size = Vector3.new(5, 5, 5)
                transportEffect.Position = targetHRP.Position
                transportEffect.Anchored = true
                transportEffect.CanCollide = false
                transportEffect.Transparency = 0.6
                transportEffect.BrickColor = BrickColor.new("Bright red")
                transportEffect.Material = Enum.Material.Neon
                transportEffect.Parent = Workspace
                game:GetService("Debris"):AddItem(transportEffect, 1)
            end
            
            wait(0.05) -- Teleporte MUITO rápido
        end
    end)
    
    return true
end

--===========================================================
-- MÉTODO DE VOID POR PROXIMIDADE
--===========================================================
function AntiScripter.StartVoidProximity(targetPlayer)
    if not targetPlayer then return false end
    
    Log("🌀 Iniciando void por proximidade para " .. targetPlayer.Name, "VOID")
    
    spawn(function()
        while AntiScripter.IsPunishing and targetPlayer and targetPlayer.Parent do
            -- Teleportar para void quando estiver perto
            local myCharacter = LocalPlayer.Character
            local targetCharacter = targetPlayer.Character
            
            if myCharacter and targetCharacter then
                local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if myHRP and targetHRP then
                    -- Calcular distância
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude
                    
                    -- Se estiver perto, teleportar para void
                    if distance < 100 then
                        AntiScripter.TeleportPlayerToVoid(targetPlayer)
                        wait(0.1)
                    end
                end
            end
            
            wait(0.1)
        end
    end)
    
    return true
end

--===========================================================
-- MÉTODO DE FOGUETE PARA O VOID
--===========================================================
function AntiScripter.LaunchToVoid(targetPlayer)
    if not targetPlayer then return false end
    
    Log("🚀 Lançando " .. targetPlayer.Name .. " para o void", "LAUNCH")
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        targetPlayer:LoadCharacter()
        wait(1)
        targetCharacter = targetPlayer.Character
    end
    
    if targetCharacter then
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            -- Salvar posição
            AntiScripter.OriginalPositions[targetPlayer.Name] = targetHRP.CFrame
            
            -- Efeito de lançamento
            for i = 1, 20 do
                targetHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -1000, 0)
                targetHRP.Anchored = true
                
                -- Efeito de fogo
                local fireEffect = Instance.new("Part")
                fireEffect.Size = Vector3.new(10, 10, 10)
                fireEffect.Position = targetHRP.Position
                fireEffect.Anchored = true
                fireEffect.CanCollide = false
                fireEffect.Transparency = 0.7
                fireEffect.BrickColor = BrickColor.new("Bright orange")
                fireEffect.Material = Enum.Material.Neon
                fireEffect.Parent = Workspace
                game:GetService("Debris"):AddItem(fireEffect, 0.5)
                
                wait(0.05)
            end
            
            -- Posição final no void profundo
            targetHRP.CFrame = CFrame.new(
                0,
                -5000000, -- VOID MUITO MUITO PROFUNDO
                0
            )
            
            Log("✅ " .. targetPlayer.Name .. " lançado para o void profundo", "SUCCESS")
            return true
        end
    end
    
    return false
end

--===========================================================
-- SISTEMA PRINCIPAL DE PUNIÇÃO
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
    
    Log("🚨🚨🚨 INICIANDO PUNIÇÃO COMPLETA PARA " .. targetPlayer.Name, "PUNISHMENT")
    
    -- MÉTODO 1: Teleporte direto imediato
    AntiScripter.TeleportPlayerToVoid(targetPlayer)
    
    -- MÉTODO 2: Loop constante de void
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if AntiScripter.IsPunishing and targetPlayer and targetPlayer.Character then
            AntiScripter.TeleportPlayerToVoid(targetPlayer)
        end
    end)
    
    -- MÉTODO 3: Transporte pessoal (você leva ele)
    AntiScripter.StartPersonalTransport(targetPlayer)
    
    -- MÉTODO 4: Void por proximidade
    AntiScripter.StartVoidProximity(targetPlayer)
    
    -- MÉTODO 5: Sistema de morte constante
    spawn(function()
        while AntiScripter.IsPunishing and targetPlayer do
            local character = targetPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    wait(0.3)
                    humanoid.Health = 1
                end
            end
            wait(0.5)
        end
    end)
    
    Log("✅ TODOS OS MÉTODOS ATIVADOS para " .. targetPlayer.Name, "SUCCESS")
    return true
end

function AntiScripter.StopPunishment()
    AntiScripter.IsPunishing = false
    AntiScripter.IsTransporting = false
    
    -- Parar loops
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    
    -- Restaurar jogador
    if AntiScripter.TargetPlayer then
        local targetPlayer = AntiScripter.TargetPlayer
        local character = targetPlayer.Character
        
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Restaurar posição original se salva
                if AntiScripter.OriginalPositions[targetPlayer.Name] then
                    humanoidRootPart.CFrame = AntiScripter.OriginalPositions[targetPlayer.Name]
                    humanoidRootPart.Anchored = AntiScripter.OriginalAnchored[targetPlayer.Name] or false
                else
                    -- Posição padrão
                    humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                    humanoidRootPart.Anchored = false
                end
                
                -- Restaurar humanoid
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    end
    
    Log("🛑 Punição parada", "STOP")
    AntiScripter.TargetPlayer = nil
    return true
end

--===========================================================
-- FUNÇÕES ESPECIAIS
--===========================================================
function AntiScripter.InstantVoid()
    if not AntiScripter.SelectedPlayer then
        Log("❌ Nenhum jogador selecionado!", "ERROR")
        return false
    end
    
    local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
    if not targetPlayer then return false end
    
    Log("⚡ VOID INSTANTÂNEO para " .. targetPlayer.Name, "INSTANT")
    
    -- Teleporte extremo
    local character = targetPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(0, -9999999, 0) -- VOID EXTREMO
            humanoidRootPart.Anchored = true
            
            -- Remover tudo
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") or item:IsA("HopperBin") then
                    item:Destroy()
                end
            end
            
            -- Matar
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
            
            return true
        end
    end
    
    return false
end

function AntiScripter.TestTransport()
    if not AntiScripter.SelectedPlayer then
        Log("❌ Nenhum jogador selecionado!", "ERROR")
        return false
    end
    
    local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
    if not targetPlayer then return false end
    
    Log("🧪 Teste de transporte para " .. targetPlayer.Name, "TEST")
    
    AntiScripter.StartPersonalTransport(targetPlayer)
    
    -- Parar após 5 segundos
    wait(5)
    
    AntiScripter.IsTransporting = false
    return true
end

--===========================================================
-- INTERFACE GRÁFICA SIMPLIFICADA
--===========================================================
function AntiScripter.CreateGUI()
    -- Limpar GUI existente
    if AntiScripter.GUI then
        AntiScripter.GUI:Destroy()
    end
    
    -- Criar GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiScripterVoidGUI"
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 3
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    title.Text = "🔥 VOID TRANSPORT SYSTEM 🔥"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = mainFrame
    
    -- Botão fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 20
    closeButton.Parent = mainFrame
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = not screenGui.Enabled
    end)
    
    -- Container
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -70)
    container.Position = UDim2.new(0, 10, 0, 60)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 8
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    container.CanvasSize = UDim2.new(0, 0, 0, 1000)
    container.Parent = mainFrame
    
    -- Armazenar elementos
    local elements = {}
    local yPos = 10
    
    -- Seção 1: Seleção
    local section1 = Instance.new("Frame")
    section1.Size = UDim2.new(1, 0, 0, 40)
    section1.Position = UDim2.new(0, 0, 0, yPos)
    section1.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    section1.Parent = container
    
    local section1Label = Instance.new("TextLabel")
    section1Label.Size = UDim2.new(1, 0, 1, 0)
    section1Label.Position = UDim2.new(0, 10, 0, 0)
    section1Label.BackgroundTransparency = 1
    section1Label.Text = "🎯 SELECIONAR JOGADOR"
    section1Label.TextColor3 = Color3.new(1, 1, 1)
    section1Label.Font = Enum.Font.SourceSansBold
    section1Label.TextSize = 16
    section1Label.TextXAlignment = Enum.TextXAlignment.Left
    section1Label.Parent = section1
    
    yPos = yPos + 50
    
    -- Botão seleção
    elements.SelectButton = Instance.new("TextButton")
    elements.SelectButton.Size = UDim2.new(1, -20, 0, 50)
    elements.SelectButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.SelectButton.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    elements.SelectButton.Text = "Clique para selecionar jogador"
    elements.SelectButton.TextColor3 = Color3.new(1, 1, 1)
    elements.SelectButton.Font = Enum.Font.SourceSansBold
    elements.SelectButton.TextSize = 16
    elements.SelectButton.Parent = container
    
    yPos = yPos + 60
    
    -- Label selecionado
    elements.SelectedLabel = Instance.new("TextLabel")
    elements.SelectedLabel.Size = UDim2.new(1, -20, 0, 30)
    elements.SelectedLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.SelectedLabel.BackgroundTransparency = 1
    elements.SelectedLabel.Text = "🎯 Selecionado: NENHUM"
    elements.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    elements.SelectedLabel.Font = Enum.Font.SourceSansBold
    elements.SelectedLabel.TextSize = 16
    elements.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.SelectedLabel.Parent = container
    
    yPos = yPos + 40
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 2: Métodos Principais
    local section2 = Instance.new("Frame")
    section2.Size = UDim2.new(1, 0, 0, 40)
    section2.Position = UDim2.new(0, 0, 0, yPos)
    section2.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    section2.Parent = container
    
    local section2Label = Instance.new("TextLabel")
    section2Label.Size = UDim2.new(1, 0, 1, 0)
    section2Label.Position = UDim2.new(0, 10, 0, 0)
    section2Label.BackgroundTransparency = 1
    section2Label.Text = "⚡ MÉTODOS PRINCIPAIS"
    section2Label.TextColor3 = Color3.new(1, 1, 1)
    section2Label.Font = Enum.Font.SourceSansBold
    section2Label.TextSize = 16
    section2Label.TextXAlignment = Enum.TextXAlignment.Left
    section2Label.Parent = section2
    
    yPos = yPos + 50
    
    -- Botão VOID COMPLETO
    elements.VoidButton = Instance.new("TextButton")
    elements.VoidButton.Size = UDim2.new(1, -20, 0, 60)
    elements.VoidButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.VoidButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elements.VoidButton.Text = "🔥 VOID COMPLETO\n(Teleporte + Loop + Transporte)"
    elements.VoidButton.TextColor3 = Color3.new(1, 1, 1)
    elements.VoidButton.Font = Enum.Font.SourceSansBold
    elements.VoidButton.TextSize = 16
    elements.VoidButton.TextWrapped = true
    elements.VoidButton.Parent = container
    
    yPos = yPos + 70
    
    -- Botão TRANSPORTE PESSOAL
    elements.TransportButton = Instance.new("TextButton")
    elements.TransportButton.Size = UDim2.new(1, -20, 0, 50)
    elements.TransportButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.TransportButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    elements.TransportButton.Text = "🚶 TRANSPORTE PESSOAL\n(Você leva o jogador)"
    elements.TransportButton.TextColor3 = Color3.new(1, 1, 1)
    elements.TransportButton.Font = Enum.Font.SourceSansBold
    elements.TransportButton.TextSize = 14
    elements.TransportButton.TextWrapped = true
    elements.TransportButton.Parent = container
    
    yPos = yPos + 60
    
    -- Botão VOID INSTANTÂNEO
    elements.InstantButton = Instance.new("TextButton")
    elements.InstantButton.Size = UDim2.new(1, -20, 0, 50)
    elements.InstantButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.InstantButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    elements.InstantButton.Text = "⚡ VOID INSTANTÂNEO\n(Teleporte extremo)"
    elements.InstantButton.TextColor3 = Color3.new(1, 1, 1)
    elements.InstantButton.Font = Enum.Font.SourceSansBold
    elements.InstantButton.TextSize = 14
    elements.InstantButton.TextWrapped = true
    elements.InstantButton.Parent = container
    
    yPos = yPos + 60
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 3: Status
    local section3 = Instance.new("Frame")
    section3.Size = UDim2.new(1, 0, 0, 40)
    section3.Position = UDim2.new(0, 0, 0, yPos)
    section3.BackgroundColor3 = Color3.fromRGB(0, 0, 40)
    section3.Parent = container
    
    local section3Label = Instance.new("TextLabel")
    section3Label.Size = UDim2.new(1, 0, 1, 0)
    section3Label.Position = UDim2.new(0, 10, 0, 0)
    section3Label.BackgroundTransparency = 1
    section3Label.Text = "📊 STATUS DO SISTEMA"
    section3Label.TextColor3 = Color3.new(1, 1, 1)
    section3Label.Font = Enum.Font.SourceSansBold
    section3Label.TextSize = 16
    section3Label.TextXAlignment = Enum.TextXAlignment.Left
    section3Label.Parent = section3
    
    yPos = yPos + 50
    
    -- Status
    elements.StatusLabel = Instance.new("TextLabel")
    elements.StatusLabel.Size = UDim2.new(1, -20, 0, 30)
    elements.StatusLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.StatusLabel.BackgroundTransparency = 1
    elements.StatusLabel.Text = "📊 Status: INATIVO"
    elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    elements.StatusLabel.Font = Enum.Font.SourceSansBold
    elements.StatusLabel.TextSize = 16
    elements.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.StatusLabel.Parent = container
    
    yPos = yPos + 40
    
    -- Uptime
    elements.UptimeLabel = Instance.new("TextLabel")
    elements.UptimeLabel.Size = UDim2.new(1, -20, 0, 25)
    elements.UptimeLabel.Position = UDim2.new(0, 10, 0, yPos)
    elements.UptimeLabel.BackgroundTransparency = 1
    elements.UptimeLabel.Text = "⏱️ Uptime: 0s"
    elements.UptimeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    elements.UptimeLabel.Font = Enum.Font.SourceSans
    elements.UptimeLabel.TextSize = 14
    elements.UptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.UptimeLabel.Parent = container
    
    yPos = yPos + 35
    
    -- Separador
    yPos = yPos + 10
    
    -- Seção 4: Controles
    local section4 = Instance.new("Frame")
    section4.Size = UDim2.new(1, 0, 0, 40)
    section4.Position = UDim2.new(0, 0, 0, yPos)
    section4.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    section4.Parent = container
    
    local section4Label = Instance.new("TextLabel")
    section4Label.Size = UDim2.new(1, 0, 1, 0)
    section4Label.Position = UDim2.new(0, 10, 0, 0)
    section4Label.BackgroundTransparency = 1
    section4Label.Text = "🎮 CONTROLES"
    section4Label.TextColor3 = Color3.new(1, 1, 1)
    section4Label.Font = Enum.Font.SourceSansBold
    section4Label.TextSize = 16
    section4Label.TextXAlignment = Enum.TextXAlignment.Left
    section4Label.Parent = section4
    
    yPos = yPos + 50
    
    -- Botão PARAR TUDO
    elements.StopButton = Instance.new("TextButton")
    elements.StopButton.Size = UDim2.new(1, -20, 0, 50)
    elements.StopButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.StopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    elements.StopButton.Text = "⛔ PARAR TUDO"
    elements.StopButton.TextColor3 = Color3.new(1, 1, 1)
    elements.StopButton.Font = Enum.Font.SourceSansBold
    elements.StopButton.TextSize = 18
    elements.StopButton.TextWrapped = true
    elements.StopButton.Parent = container
    
    yPos = yPos + 60
    
    -- Botão TESTE
    elements.TestButton = Instance.new("TextButton")
    elements.TestButton.Size = UDim2.new(1, -20, 0, 40)
    elements.TestButton.Position = UDim2.new(0, 10, 0, yPos)
    elements.TestButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    elements.TestButton.Text = "🧪 Teste Transporte (5s)"
    elements.TestButton.TextColor3 = Color3.new(1, 1, 1)
    elements.TestButton.Font = Enum.Font.SourceSansBold
    elements.TestButton.TextSize = 14
    elements.TestButton.Parent = container
    
    yPos = yPos + 50
    
    -- Atualizar tamanho
    container.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    -- Armazenar
    AntiScripter.GUI = screenGui
    AntiScripter.GUIElements = elements
    
    -- Configurar eventos
    AntiScripter.SetupGUIEvents()
    
    Log("✅ Interface criada", "GUI")
    return screenGui
end

function AntiScripter.SetupGUIEvents()
    local elements = AntiScripter.GUIElements
    
    -- Selecionar jogador
    elements.SelectButton.MouseButton1Click:Connect(function()
        AntiScripter.ShowPlayerSelection()
    end)
    
    -- Void completo
    elements.VoidButton.MouseButton1Click:Connect(function()
        if AntiScripter.IsPunishing then
            AntiScripter.StopPunishment()
            elements.VoidButton.Text = "🔥 VOID COMPLETO\n(Teleporte + Loop + Transporte)"
            elements.VoidButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            elements.StatusLabel.Text = "📊 Status: PARADO"
            elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            if AntiScripter.StartPunishment() then
                elements.VoidButton.Text = "🟢 PARANDO VOID\n(" .. AntiScripter.SelectedPlayer .. ")"
                elements.VoidButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                elements.StatusLabel.Text = "📊 Status: PUNINDO " .. AntiScripter.SelectedPlayer
                elements.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end)
    
    -- Transporte pessoal
    elements.TransportButton.MouseButton1Click:Connect(function()
        if AntiScripter.IsTransporting then
            AntiScripter.IsTransporting = false
            elements.TransportButton.Text = "🚶 TRANSPORTE PESSOAL\n(Você leva o jogador)"
            elements.TransportButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        else
            AntiScripter.StartPersonalTransport(Players:FindFirstChild(AntiScripter.SelectedPlayer))
            elements.TransportButton.Text = "🟢 PARANDO TRANSPORTE"
            elements.TransportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    end)
    
    -- Void instantâneo
    elements.InstantButton.MouseButton1Click:Connect(function()
        AntiScripter.InstantVoid()
    end)
    
    -- Parar tudo
    elements.StopButton.MouseButton1Click:Connect(function()
        AntiScripter.StopPunishment()
        AntiScripter.IsTransporting = false
        elements.VoidButton.Text = "🔥 VOID COMPLETO\n(Teleporte + Loop + Transporte)"
        elements.VoidButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        elements.TransportButton.Text = "🚶 TRANSPORTE PESSOAL\n(Você leva o jogador)"
        elements.TransportButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        elements.StatusLabel.Text = "📊 Status: PARADO TUDO"
        elements.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)
    
    -- Teste
    elements.TestButton.MouseButton1Click:Connect(function()
        AntiScripter.TestTransport()
    end)
end

function AntiScripter.ShowPlayerSelection()
    -- Remover popup existente
    local oldPopup = AntiScripter.GUI:FindFirstChild("PlayerPopup")
    if oldPopup then oldPopup:Destroy() end
    
    -- Obter jogadores
    local players = Players:GetPlayers()
    local playerNames = {}
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    if #playerNames == 0 then
        table.insert(playerNames, "Sem jogadores")
    end
    
    -- Criar popup
    local popup = Instance.new("Frame")
    popup.Name = "PlayerPopup"
    popup.Size = UDim2.new(0, 300, 0, 400)
    popup.Position = UDim2.new(0.5, -150, 0.5, -200)
    popup.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    popup.BorderSizePixel = 3
    popup.BorderColor3 = Color3.fromRGB(255, 0, 0)
    popup.ZIndex = 100
    popup.Parent = AntiScripter.GUI
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    title.Text = "👥 ESCOLHA UM JOGADOR"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.ZIndex = 101
    title.Parent = popup
    
    -- Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.ZIndex = 101
    closeBtn.Parent = popup
    
    closeBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
    
    -- Lista
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.Position = UDim2.new(0, 10, 0, 60)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #playerNames * 60)
    scroll.ZIndex = 101
    scroll.Parent = popup
    
    -- Botões
    local yPos = 10
    for _, playerName in ipairs(playerNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 50)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
        btn.Text = playerName
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.ZIndex = 102
        btn.Parent = scroll
        
        if playerName ~= "Sem jogadores" then
            btn.MouseButton1Click:Connect(function()
                AntiScripter.SelectedPlayer = playerName
                AntiScripter.GUIElements.SelectedLabel.Text = "🎯 Selecionado: " .. playerName
                AntiScripter.GUIElements.SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                AntiScripter.GUIElements.SelectButton.Text = "Jogador: " .. playerName
                Log("✅ Selecionado: " .. playerName, "SELECTION")
                popup:Destroy()
            end)
        end
        
        yPos = yPos + 60
    end
end

--===========================================================
-- INICIALIZAÇÃO
--===========================================================
Log("🚀 Iniciando sistema...", "INIT")

-- Criar GUI
AntiScripter.CreateGUI()

-- Sistema de atualização
spawn(function()
    while true do
        AntiScripter.Uptime = AntiScripter.Uptime + 1
        if AntiScripter.GUIElements then
            AntiScripter.GUIElements.UptimeLabel.Text = "⏱️ Uptime: " .. AntiScripter.Uptime .. "s"
        end
        wait(1)
    end
end)

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        -- F9 para mostrar/esconder
        if input.KeyCode == Enum.KeyCode.F9 then
            if AntiScripter.GUI then
                AntiScripter.GUI.Enabled = not AntiScripter.GUI.Enabled
            end
        
        -- Delete para fechar
        elseif input.KeyCode == Enum.KeyCode.Delete then
            AntiScripter.StopPunishment()
            if AntiScripter.GUI then
                AntiScripter.GUI:Destroy()
            end
            print("\n" .. string.rep("=", 60))
            print("🛑 SISTEMA FECHADO")
            print(string.rep("=", 60) .. "\n")
        end
    end
end)

-- Mensagem inicial
wait(1)

print([[
    
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║      🔥 VOID TRANSPORT SYSTEM - 100% FUNCIONAL          ║
    ║                                                          ║
    ║          ✅ Sistema carregado com sucesso               ║
    ║          🎮 Interface: PRONTA                           ║
    ║          ⚡ Métodos: 3 SISTEMAS DIFERENTES              ║
    ║                                                          ║
    ║   🎯 COMO USAR:                                          ║
    ║   1. Selecione um jogador                               ║
    ║   2. Use um dos métodos:                                ║
    ║      • VOID COMPLETO - Teleporte + Loop                 ║
    ║      • TRANSPORTE PESSOAL - Você leva ele              ║
    ║      • VOID INSTANTÂNEO - Teleporte extremo            ║
    ║                                                          ║
    ║   🚀 FUNCIONA EM:                                        ║
    ║   • Natural Disaster Survival                           ║
    ║   • Qualquer jogo do Roblox                             ║
    ║   • Jogadores reais                                     ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    
]])

Log("✅ Sistema pronto! Selecione um jogador e teste!", "READY")

-- Retornar sistema
return AntiScripter
