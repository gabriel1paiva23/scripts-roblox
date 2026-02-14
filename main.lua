--[[
================================================================================
                    UNIVERSAL SKIN COPIER - ROBLOX
                    Copie a skin de qualquer jogador!
================================================================================
Versão: 2.0.1
Funcionalidade: Botão "Copiar Skin" em cada jogador
Recursos: 
    - Botão individual por jogador
    - Copia TODOS os aspectos da skin
    - Funciona em QUALQUER jogo
    - CORRIGIDO: Bug de "copie primeiro"
================================================================================
]]

--==============================================================================
-- SERVIÇOS
--==============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

--==============================================================================
-- VARIÁVEIS PRINCIPAIS
--==============================================================================
local LocalPlayer = Players.LocalPlayer
local SkinCopier = {
    Version = "2.0.1",
    Active = true,
    GUI = nil,
    Buttons = {},
    CurrentTarget = nil,
    SkinData = {}, -- Tabela para armazenar skins copiadas
    DebugMode = false
}

--==============================================================================
-- FUNÇÕES DE LOG
--==============================================================================
local function Log(message, type)
    local prefix = "📋 "
    if type == "SUCCESS" then prefix = "✅ "
    elseif type == "ERROR" then prefix = "❌ "
    elseif type == "WARNING" then prefix = "⚠️ "
    end
    
    print(prefix .. "[SkinCopier] " .. message)
end

--==============================================================================
-- FUNÇÃO PARA COPIAR SKIN COMPLETA
--==============================================================================
function SkinCopier:CopySkinFromPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        Log("Jogador ou personagem inválido!", "ERROR")
        return false
    end
    
    Log("Copiando skin de: " .. targetPlayer.Name, "INFO")
    
    local character = targetPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then
        Log("Humanoid não encontrado!", "ERROR")
        return false
    end
    
    -- CRIAR TABELA COMPLETA COM TODOS OS DADOS DA SKIN
    local skinData = {
        -- Dados básicos do humanoid
        Humanoid = {
            BodyTypeScale = humanoid.BodyTypeScale,
            BodyWidthScale = humanoid.BodyWidthScale,
            BodyDepthScale = humanoid.BodyDepthScale,
            BodyHeightScale = humanoid.BodyHeightScale,
            BodyProportionScale = humanoid.BodyProportionScale,
            HeadScale = humanoid.HeadScale,
            
            -- Cores
            HeadColor = humanoid.HeadColor,
            TorsoColor = humanoid.TorsoColor,
            LeftArmColor = humanoid.LeftArmColor,
            RightArmColor = humanoid.RightArmColor,
            LeftLegColor = humanoid.LeftLegColor,
            RightLegColor = humanoid.RightLegColor,
            
            -- Equipamentos
            ShirtGraphic = humanoid.ShirtGraphic,
            ShirtTemplate = humanoid.ShirtTemplate,
            PantsTemplate = humanoid.PantsTemplate,
        },
        
        -- COPIAR ROUPAS (Shirt, Pants, etc)
        Clothing = {
            Shirt = nil,
            Pants = nil,
            Graphic = nil
        },
        
        -- COPIAR ACESSÓRIOS COMPLETOS
        Accessories = {},
        
        -- COPIAR CORES EXATAS
        Colors = {
            Head = humanoid.HeadColor,
            Torso = humanoid.TorsoColor,
            LeftArm = humanoid.LeftArmColor,
            RightArm = humanoid.RightArmColor,
            LeftLeg = humanoid.LeftLegColor,
            RightLeg = humanoid.RightLegColor
        },
        
        -- Nome do jogador de origem
        SourcePlayer = targetPlayer.Name
    }
    
    -- COPIAR ROUPAS
    local shirt = character:FindFirstChildOfClass("Shirt")
    if shirt then
        skinData.Clothing.Shirt = shirt.ShirtTemplate
    end
    
    local pants = character:FindFirstChildOfClass("Pants")
    if pants then
        skinData.Clothing.Pants = pants.PantsTemplate
    end
    
    local graphic = character:FindFirstChildOfClass("Graphic")
    if graphic then
        skinData.Clothing.Graphic = graphic.Graphic
    end
    
    -- COPIAR ACESSÓRIOS
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            -- Criar uma cópia segura do acessório
            local accessoryData = {
                Name = accessory.Name,
                HandleCFrame = accessory.Handle and accessory.Handle.CFrame or CFrame.new(),
                AccessoryType = accessory.AccessoryType,
                AttachmentPoint = accessory.AttachmentPoint,
                
                -- Salvar dados do handle
                Handle = {
                    BrickColor = accessory.Handle and accessory.Handle.BrickColor or BrickColor.new("White"),
                    Material = accessory.Handle and accessory.Handle.Material or Enum.Material.Plastic,
                    Size = accessory.Handle and accessory.Handle.Size or Vector3.new(1, 1, 1),
                    MeshId = accessory.Handle and accessory.Handle.MeshId or "",
                    TextureId = accessory.Handle and accessory.Handle.TextureId or ""
                }
            }
            
            table.insert(skinData.Accessories, accessoryData)
            Log("Acessório copiado: " .. accessory.Name, "DEBUG")
        end
    end
    
    -- SALVAR DADOS DA SKIN usando o nome do jogador como chave
    self.SkinData[targetPlayer.Name] = skinData
    self.CurrentTarget = targetPlayer.Name
    
    Log("✅ Skin de " .. targetPlayer.Name .. " copiada com sucesso!", "SUCCESS")
    Log(string.format("📊 Dados coletados: %d acessórios", #skinData.Accessories), "INFO")
    
    return skinData
end

--==============================================================================
-- FUNÇÃO PARA APLICAR SKIN EM SI MESMO
--==============================================================================
function SkinCopier:ApplySkinToMe(sourcePlayerName)
    -- Verificar se existe skin salva para este jogador
    local skinData = self.SkinData[sourcePlayerName]
    
    if not skinData then
        Log("Nenhuma skin salva para: " .. sourcePlayerName, "ERROR")
        return false, "NO_SKIN"
    end
    
    Log("Aplicando skin de " .. sourcePlayerName .. " em você...", "INFO")
    
    -- Garantir que o personagem existe
    if not LocalPlayer.Character then
        LocalPlayer:LoadCharacter()
        wait(1)
    end
    
    local myCharacter = LocalPlayer.Character
    local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")
    
    if not myHumanoid then
        Log("Seu humanoid não encontrado!", "ERROR")
        return false, "NO_HUMANOID"
    end
    
    -- 1. REMOVER ACESSÓRIOS ANTIGOS
    Log("Removendo acessórios antigos...", "DEBUG")
    for _, child in ipairs(myCharacter:GetChildren()) do
        if child:IsA("Accessory") then
            child:Destroy()
        end
    end
    
    -- 2. REMOVER ROUPAS ANTIGAS
    local oldShirt = myCharacter:FindFirstChildOfClass("Shirt")
    local oldPants = myCharacter:FindFirstChildOfClass("Pants")
    local oldGraphic = myCharacter:FindFirstChildOfClass("Graphic")
    
    if oldShirt then oldShirt:Destroy() end
    if oldPants then oldPants:Destroy() end
    if oldGraphic then oldGraphic:Destroy() end
    
    -- 3. APLICAR NOVAS ROUPAS
    if skinData.Clothing.Shirt then
        local newShirt = Instance.new("Shirt")
        newShirt.ShirtTemplate = skinData.Clothing.Shirt
        newShirt.Parent = myCharacter
        Log("Roupa (camisa) aplicada", "DEBUG")
    end
    
    if skinData.Clothing.Pants then
        local newPants = Instance.new("Pants")
        newPants.PantsTemplate = skinData.Clothing.Pants
        newPants.Parent = myCharacter
        Log("Roupa (calça) aplicada", "DEBUG")
    end
    
    if skinData.Clothing.Graphic then
        local newGraphic = Instance.new("Graphic")
        newGraphic.Graphic = skinData.Clothing.Graphic
        newGraphic.Parent = myCharacter
        Log("Graphic aplicado", "DEBUG")
    end
    
    -- 4. APLICAR CORES
    myHumanoid.HeadColor = skinData.Colors.Head
    myHumanoid.TorsoColor = skinData.Colors.Torso
    myHumanoid.LeftArmColor = skinData.Colors.LeftArm
    myHumanoid.RightArmColor = skinData.Colors.RightArm
    myHumanoid.LeftLegColor = skinData.Colors.LeftLeg
    myHumanoid.RightLegColor = skinData.Colors.RightLeg
    
    -- 5. APLICAR ESCALAS DO CORPO
    myHumanoid.BodyTypeScale = skinData.Humanoid.BodyTypeScale
    myHumanoid.BodyWidthScale = skinData.Humanoid.BodyWidthScale
    myHumanoid.BodyDepthScale = skinData.Humanoid.BodyDepthScale
    myHumanoid.BodyHeightScale = skinData.Humanoid.BodyHeightScale
    myHumanoid.BodyProportionScale = skinData.Humanoid.BodyProportionScale
    myHumanoid.HeadScale = skinData.Humanoid.HeadScale
    
    -- 6. APLICAR ACESSÓRIOS
    Log("Aplicando " .. #skinData.Accessories .. " acessórios...", "INFO")
    for _, accData in ipairs(skinData.Accessories) do
        -- Criar novo acessório
        local accessory = Instance.new("Accessory")
        accessory.Name = accData.Name
        accessory.AccessoryType = accData.AccessoryType
        accessory.AttachmentPoint = accData.AttachmentPoint
        accessory.Parent = myCharacter
        
        -- Criar handle para o acessório
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.BrickColor = accData.Handle.BrickColor
        handle.Material = accData.Handle.Material
        handle.Size = accData.Handle.Size
        handle.Anchored = false
        handle.CanCollide = false
        handle.Parent = accessory
        
        -- Aplicar mesh se existir
        if accData.Handle.MeshId and accData.Handle.MeshId ~= "" then
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshId = accData.Handle.MeshId
            mesh.TextureId = accData.Handle.TextureId
            mesh.Parent = handle
        end
        
        -- Posicionar o acessório
        if myCharacter:FindFirstChild("HumanoidRootPart") then
            handle.CFrame = myCharacter.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
        end
    end
    
    Log("✅ Skin de " .. sourcePlayerName .. " aplicada em você com sucesso!", "SUCCESS")
    return true, "SUCCESS"
end

--==============================================================================
-- CRIAÇÃO DA INTERFACE (Botões nos jogadores)
--==============================================================================
function SkinCopier:CreateGUI()
    Log("Criando interface...", "INFO")
    
    -- Remover GUI antiga
    if self.GUI then
        self.GUI:Destroy()
        self.GUI = nil
    end
    
    -- Criar ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SkinCopierGUI"
    screenGui.DisplayOrder = 9999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    self.GUI = screenGui
    
    -- Frame principal para botões
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 400)
    mainFrame.Position = UDim2.new(0.02, 0, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    title.Text = "📋 SKIN COPIER v" .. self.Version
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 16
    closeBtn.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = not screenGui.Enabled
    end)
    
    -- Botão minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.TextSize = 16
    minimizeBtn.Parent = mainFrame
    
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Size = mainFrame.Size == UDim2.new(0, 250, 0, 400) and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 400)
    end)
    
    -- Container para botões dos jogadores
    local container = Instance.new("ScrollingFrame")
    container.Name = "PlayerList"
    container.Size = UDim2.new(1, -10, 1, -50)
    container.Position = UDim2.new(0, 5, 0, 45)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BackgroundTransparency = 0.5
    container.ScrollBarThickness = 8
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Parent = mainFrame
    
    self.Container = container
    
    Log("Interface criada, iniciando monitoramento de jogadores...", "SUCCESS")
    
    -- Iniciar atualização da lista
    self:UpdatePlayerList()
end

--==============================================================================
-- ATUALIZAR LISTA DE JOGADORES (COM BOTÕES)
--==============================================================================
function SkinCopier:UpdatePlayerList()
    if not self.Container then return end
    
    -- Limpar botões antigos
    for _, child in pairs(self.Container:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    self.Buttons = {}
    
    local yPos = 5
    local players = Players:GetPlayers()
    
    -- Criar botão para cada jogador (exceto você)
    for i, player in ipairs(players) do
        if player ~= LocalPlayer then
            self:CreatePlayerButton(player, yPos)
            yPos = yPos + 65
        end
    end
    
    -- Se não houver outros jogadores
    if yPos == 5 then
        local noPlayersLabel = Instance.new("TextLabel")
        noPlayersLabel.Size = UDim2.new(1, -10, 0, 50)
        noPlayersLabel.Position = UDim2.new(0, 5, 0, 10)
        noPlayersLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        noPlayersLabel.Text = "❌ Nenhum outro jogador na partida"
        noPlayersLabel.TextColor3 = Color3.new(1, 1, 1)
        noPlayersLabel.Font = Enum.Font.SourceSans
        noPlayersLabel.TextSize = 14
        noPlayersLabel.TextWrapped = true
        noPlayersLabel.Parent = self.Container
        yPos = yPos + 60
    end
    
    -- Ajustar tamanho do canvas
    self.Container.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

--==============================================================================
-- CRIAR BOTÃO PARA UM JOGADOR (CORRIGIDO)
--==============================================================================
function SkinCopier:CreatePlayerButton(player, yPos)
    local frame = Instance.new("Frame")
    frame.Name = "Player_" .. player.Name
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    frame.Parent = self.Container
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name .. " (" .. (player.DisplayName or player.Name) .. ")"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame
    
    -- Status (mostra se já copiou)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 15)
    statusLabel.Position = UDim2.new(0, 5, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "📋 Pronto para copiar"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame
    
    -- Verificar se já tem skin copiada deste jogador
    local hasSkin = self.SkinData[player.Name] ~= nil
    if hasSkin then
        statusLabel.Text = "✅ Skin copiada! Pronto para aplicar"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
    
    -- BOTÃO COPIAR SKIN (VERDE)
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0.48, -2, 0, 25)
    copyButton.Position = UDim2.new(0, 5, 1, -30)
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    copyButton.Text = "📋 COPIAR SKIN"
    copyButton.TextColor3 = Color3.new(1, 1, 1)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 11
    copyButton.Parent = frame
    
    -- BOTÃO APLICAR SKIN (AZUL)
    local applyButton = Instance.new("TextButton")
    applyButton.Name = "ApplyButton"
    applyButton.Size = UDim2.new(0.48, -2, 0, 25)
    applyButton.Position = UDim2.new(0.52, 2, 1, -30)
    applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    applyButton.Text = "🎨 APLICAR SKIN"
    applyButton.TextColor3 = Color3.new(1, 1, 1)
    applyButton.Font = Enum.Font.SourceSansBold
    applyButton.TextSize = 11
    applyButton.Parent = frame
    
    -- EVENTO: COPIAR SKIN
    copyButton.MouseButton1Click:Connect(function()
        Log("Copiando skin de: " .. player.Name, "INFO")
        copyButton.Text = "⏳ COPIANDO..."
        copyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        copyButton.Active = false -- Desabilitar botão durante cópia
        statusLabel.Text = "⏳ Copiando skin..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local success = self:CopySkinFromPlayer(player)
        
        if success then
            copyButton.Text = "✅ COPIADO!"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Skin copiada! Pronto para aplicar"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Voltar ao normal depois de 2 segundos (mas mantendo o texto)
            wait(2)
            copyButton.Text = "📋 COPIAR SKIN"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            copyButton.Active = true
        else
            copyButton.Text = "❌ ERRO"
            copyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            statusLabel.Text = "❌ Falha ao copiar"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            wait(2)
            copyButton.Text = "📋 COPIAR SKIN"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            copyButton.Active = true
            statusLabel.Text = "📋 Pronto para copiar"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    -- EVENTO: APLICAR SKIN (CORRIGIDO)
    applyButton.MouseButton1Click:Connect(function()
        -- Verificar se existe skin salva para este jogador
        if not self.SkinData[player.Name] then
            Log("Você precisa copiar a skin de " .. player.Name .. " primeiro!", "WARNING")
            applyButton.Text = "⚠️ COPIE PRIMEIRO"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
            applyButton.Active = false
            
            statusLabel.Text = "⚠️ Copie a skin primeiro!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            wait(1.5)
            applyButton.Text = "🎨 APLICAR SKIN"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = self.SkinData[player.Name] and "✅ Skin copiada! Pronto para aplicar" or "📋 Pronto para copiar"
            statusLabel.TextColor3 = self.SkinData[player.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
            return
        end
        
        Log("Aplicando skin de: " .. player.Name, "INFO")
        applyButton.Text = "⏳ APLICANDO..."
        applyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        applyButton.Active = false
        statusLabel.Text = "⏳ Aplicando skin..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local success, result = self:ApplySkinToMe(player.Name)
        
        if success then
            applyButton.Text = "✅ APLICADA!"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Skin aplicada com sucesso!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(2)
            applyButton.Text = "🎨 APLICAR SKIN"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = "✅ Skin copiada! Pronto para aplicar"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            applyButton.Text = "❌ ERRO"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            statusLabel.Text = "❌ Falha ao aplicar"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            wait(2)
            applyButton.Text = "🎨 APLICAR SKIN"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = "✅ Skin copiada! Pronto para aplicar"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
    
    -- Salvar referência
    self.Buttons[player.Name] = {
        Frame = frame,
        CopyButton = copyButton,
        ApplyButton = applyButton,
        StatusLabel = statusLabel
    }
end

--==============================================================================
-- MONITORAR MUDANÇAS NA LISTA DE JOGADORES
--==============================================================================
function SkinCopier:StartMonitoring()
    Log("Iniciando monitoramento de jogadores...", "INFO")
    
    -- Quando um jogador entrar
    Players.PlayerAdded:Connect(function(player)
        wait(1)
        self:UpdatePlayerList()
    end)
    
    -- Quando um jogador sair (limpar dados dele)
    Players.PlayerRemoving:Connect(function(player)
        -- Limpar skin data do jogador que saiu
        if self.SkinData[player.Name] then
            self.SkinData[player.Name] = nil
        end
        wait(0.5)
        self:UpdatePlayerList()
    end)
    
    -- Atualizar a lista periodicamente
    spawn(function()
        while self.Active do
            wait(5) -- Atualizar a cada 5 segundos
            if self.GUI and self.GUI.Enabled then
                self:UpdatePlayerList()
            end
        end
    end)
end

--==============================================================================
-- CONTROLES DE TECLADO
--==============================================================================
function SkinCopier:SetupHotkeys()
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            -- F8 para abrir/fechar
            if input.KeyCode == Enum.KeyCode.F8 then
                if self.GUI then
                    self.GUI.Enabled = not self.GUI.Enabled
                    Log("GUI " .. (self.GUI.Enabled and "aberta" or "fechada"), "INFO")
                end
            
            -- F7 para atualizar lista manualmente
            elseif input.KeyCode == Enum.KeyCode.F7 then
                self:UpdatePlayerList()
                Log("Lista atualizada manualmente", "INFO")
            end
        end
    end)
end

--==============================================================================
-- INICIALIZAÇÃO
--==============================================================================
function SkinCopier:Init()
    Log("===========================================", "INFO")
    Log("Iniciando Universal Skin Copier v" .. self.Version, "INFO")
    Log("===========================================", "INFO")
    
    -- Verificar se o jogador carregou
    if not LocalPlayer then
        Log("Aguardando jogador local...", "WARNING")
        LocalPlayer = Players.LocalPlayer
        while not LocalPlayer do
            wait(1)
            LocalPlayer = Players.LocalPlayer
        end
    end
    
    -- Aguardar personagem
    if not LocalPlayer.Character then
        Log("Aguardando personagem...", "WARNING")
        LocalPlayer.CharacterAdded:Wait()
        wait(1)
    end
    
    -- Criar interface
    self:CreateGUI()
    
    -- Iniciar monitoramento
    self:StartMonitoring()
    
    -- Configurar hotkeys
    self:SetupHotkeys()
    
    -- Mensagem de sucesso
    Log("===========================================", "SUCCESS")
    Log("✅ Skin Copier v" .. self.Version .. " iniciado com sucesso!", "SUCCESS")
    Log("📋 Pressione F8 para abrir/fechar", "INFO")
    Log("📋 Pressione F7 para atualizar lista", "INFO")
    Log("===========================================", "SUCCESS")
    
    -- Notificação
    StarterGui:SetCore("SendNotification", {
        Title = "✅ Skin Copier v" .. self.Version,
        Text = "Pressione F8 para abrir o menu!",
        Duration = 3
    })
    
    return true
end

--==============================================================================
-- EXECUTAR
--==============================================================================

-- Aguardar carga completa
repeat wait() until game:IsLoaded() and Players.LocalPlayer

-- Inicializar
local success, errorMsg = pcall(function()
    SkinCopier:Init()
end)

if not success then
    warn("❌ Erro ao iniciar Skin Copier:")
    warn(errorMsg)
    
    -- Tentar novamente após 5 segundos
    wait(5)
    pcall(function()
        SkinCopier:Init()
    end)
end

-- Retornar objeto para uso externo
return SkinCopier
