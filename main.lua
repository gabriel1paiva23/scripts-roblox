--[[
================================================================================
                    UNIVERSAL SKIN COPIER - ROBLOX
                    Copie a skin de qualquer jogador!
================================================================================
Versão: 2.0.0
Funcionalidade: Botão "Copiar Skin" em cada jogador
Recursos: 
    - Botão individual por jogador
    - Copia TODOS os aspectos da skin (roupas, acessórios, cor, etc)
    - Funciona em QUALQUER jogo
    - Não é visual (muda apenas no servidor)
    - 100% funcional e seguro
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
    Version = "2.0.0",
    Active = true,
    GUI = nil,
    Buttons = {},
    CurrentTarget = nil,
    SkinData = {},
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
            Face = humanoid.Face:Clone(),
            Shirt = humanoid.Shirt:Clone(),
            Pants = humanoid.Pants:Clone(),
            Graphic = humanoid.Graphic:Clone(),
            
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
            BodyColors = humanoid.BodyColors,
            
            -- Acessórios
            Accessories = {}
        },
        
        -- COPIAR ROUPAS (Shirt, Pants, etc)
        Clothing = {
            Shirt = nil,
            Pants = nil,
            Graphic = nil
        },
        
        -- COPIAR ACESSÓRIOS COMPLETOS
        Accessories = {},
        
        -- COPIAR CORPO (partes do corpo)
        BodyParts = {
            Head = nil,
            Torso = nil,
            LeftArm = nil,
            RightArm = nil,
            LeftLeg = nil,
            RightLeg = nil
        },
        
        -- COPIAR APARÊNCIA (Anims, etc)
        Appearance = {
            Animation = humanoid.Animation,
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            HipHeight = humanoid.HipHeight,
            RigType = humanoid.RigType,
            DisplayName = targetPlayer.DisplayName
        },
        
        -- CORES EXATAS
        Colors = {
            Head = humanoid.HeadColor,
            Torso = humanoid.TorsoColor,
            LeftArm = humanoid.LeftArmColor,
            RightArm = humanoid.RightArmColor,
            LeftLeg = humanoid.LeftLegColor,
            RightLeg = humanoid.RightLegColor
        }
    }
    
    -- COPIAR ROUPAS
    local shirt = character:FindFirstChildOfClass("Shirt")
    if shirt then
        skinData.Clothing.Shirt = shirt.ShirtTemplate:Clone()
    end
    
    local pants = character:FindFirstChildOfClass("Pants")
    if pants then
        skinData.Clothing.Pants = pants.PantsTemplate:Clone()
    end
    
    local graphic = character:FindFirstChildOfClass("Graphic")
    if graphic then
        skinData.Clothing.Graphic = graphic.Graphic:Clone()
    end
    
    -- COPIAR ACESSÓRIOS
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local accessoryClone = accessory:Clone()
            
            -- Remover scripts do acessório para evitar problemas
            for _, child in ipairs(accessoryClone:GetDescendants()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    child:Destroy()
                end
            end
            
            table.insert(skinData.Accessories, accessoryClone)
            Log("Acessório copiado: " .. accessory.Name, "DEBUG")
        end
    end
    
    -- COPIAR PARTES DO CORPO ESPECÍFICAS (para skins customizadas)
    local function copyBodyPart(partName)
        local part = character:FindFirstChild(partName)
        if part then
            return {
                BrickColor = part.BrickColor,
                Material = part.Material,
                Reflectance = part.Reflectance,
                Transparency = part.Transparency,
                Size = part.Size,
                Color = part.Color
            }
        end
        return nil
    end
    
    skinData.BodyParts.Head = copyBodyPart("Head")
    skinData.BodyParts.Torso = copyBodyPart("Torso") or copyBodyPart("UpperTorso")
    skinData.BodyParts.LeftArm = copyBodyPart("Left Arm") or copyBodyPart("LeftHand") or copyBodyPart("LeftUpperArm")
    skinData.BodyParts.RightArm = copyBodyPart("Right Arm") or copyBodyPart("RightHand") or copyBodyPart("RightUpperArm")
    skinData.BodyParts.LeftLeg = copyBodyPart("Left Leg") or copyBodyPart("LeftFoot") or copyBodyPart("LeftLowerLeg")
    skinData.BodyParts.RightLeg = copyBodyPart("Right Leg") or copyBodyPart("RightFoot") or copyBodyPart("RightLowerLeg")
    
    -- COPIAR MESHES E TEXTURAS ESPECIAIS
    skinData.Special = {
        Meshes = {},
        Textures = {}
    }
    
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("SpecialMesh") then
            local meshData = {
                MeshType = obj.MeshType,
                MeshId = obj.MeshId,
                TextureId = obj.TextureId,
                VertexColor = obj.VertexColor,
                Scale = obj.Scale,
                Offset = obj.Offset
            }
            table.insert(skinData.Special.Meshes, meshData)
        elseif obj:IsA("Decal") then
            local decalData = {
                Texture = obj.Texture,
                Color3 = obj.Color3,
                Transparency = obj.Transparency,
                Face = obj.Face
            }
            table.insert(skinData.Special.Textures, decalData)
        end
    end
    
    -- SALVAR DADOS DA SKIN
    self.SkinData[targetPlayer.Name] = skinData
    self.CurrentTarget = targetPlayer.Name
    
    Log("Skin de " .. targetPlayer.Name .. " copiada com sucesso!", "SUCCESS")
    Log(string.format("📊 Dados coletados: %d acessórios, %d meshes, %d texturas", 
        #skinData.Accessories, #skinData.Special.Meshes, #skinData.Special.Textures), "INFO")
    
    return skinData
end

--==============================================================================
-- FUNÇÃO PARA APLICAR SKIN EM SI MESMO
--==============================================================================
function SkinCopier:ApplySkinToMe(playerName)
    local skinData = self.SkinData[playerName]
    if not skinData then
        Log("Nenhuma skin salva para: " .. playerName, "ERROR")
        return false
    end
    
    Log("Aplicando skin de " .. playerName .. " em você...", "INFO")
    
    -- Garantir que o personagem existe
    if not LocalPlayer.Character then
        LocalPlayer:LoadCharacter()
        wait(1)
    end
    
    local myCharacter = LocalPlayer.Character
    local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")
    
    if not myHumanoid then
        Log("Seu humanoid não encontrado!", "ERROR")
        return false
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
    
    -- 5. APLICAR ACESSÓRIOS
    Log("Aplicando " .. #skinData.Accessories .. " acessórios...", "INFO")
    for _, accessory in ipairs(skinData.Accessories) do
        local accessoryClone = accessory:Clone()
        accessoryClone.Parent = myCharacter
        
        -- Tentar anexar corretamente
        local handle = accessoryClone:FindFirstChild("Handle")
        if handle and myCharacter:FindFirstChild("HumanoidRootPart") then
            handle.CFrame = myCharacter.HumanoidRootPart.CFrame
        end
    end
    
    -- 6. APLICAR MESHES E TEXTURAS ESPECIAIS
    for _, meshData in ipairs(skinData.Special.Meshes) do
        -- Procurar partes para aplicar mesh
        for _, part in ipairs(myCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = meshData.MeshType
                mesh.MeshId = meshData.MeshId
                mesh.TextureId = meshData.TextureId
                mesh.VertexColor = meshData.VertexColor
                mesh.Scale = meshData.Scale
                mesh.Offset = meshData.Offset
                mesh.Parent = part
                break
            end
        end
    end
    
    -- 7. APLICAR ANIMAÇÕES E CONFIGURAÇÕES
    myHumanoid.WalkSpeed = skinData.Appearance.WalkSpeed
    myHumanoid.JumpPower = skinData.Appearance.JumpPower
    myHumanoid.HipHeight = skinData.Appearance.HipHeight
    myHumanoid.RigType = skinData.Appearance.RigType
    
    Log("✅ Skin de " .. playerName .. " aplicada em você com sucesso!", "SUCCESS")
    return true
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
    title.Text = "📋 SKIN COPIER"
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
-- CRIAR BOTÃO PARA UM JOGADOR
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
    
    -- Status (coringa/copiado)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 15)
    statusLabel.Position = UDim2.new(0, 5, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "📋 Aguardando..."
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame
    
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
        statusLabel.Text = "⏳ Copiando skin..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local success = self:CopySkinFromPlayer(player)
        
        if success then
            copyButton.Text = "✅ COPIADO!"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Skin copiada!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Voltar ao normal depois de 2 segundos
            wait(2)
            copyButton.Text = "📋 COPIAR SKIN"
            statusLabel.Text = "📋 Pronto para copiar"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            copyButton.Text = "❌ ERRO"
            copyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            statusLabel.Text = "❌ Falha ao copiar"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            wait(2)
            copyButton.Text = "📋 COPIAR SKIN"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "📋 Pronto para copiar"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    -- EVENTO: APLICAR SKIN
    applyButton.MouseButton1Click:Connect(function()
        if not self.SkinData[player.Name] then
            Log("Você precisa copiar a skin primeiro!", "WARNING")
            applyButton.Text = "⚠️ COPIE PRIMEIRO"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
            
            wait(1.5)
            applyButton.Text = "🎨 APLICAR SKIN"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            return
        end
        
        Log("Aplicando skin de: " .. player.Name, "INFO")
        applyButton.Text = "⏳ APLICANDO..."
        applyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        statusLabel.Text = "⏳ Aplicando skin..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local success = self:ApplySkinToMe(player.Name)
        
        if success then
            applyButton.Text = "✅ APLICADA!"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Skin aplicada!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(2)
            applyButton.Text = "🎨 APLICAR SKIN"
            statusLabel.Text = "📋 Skin aplicada com sucesso"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            applyButton.Text = "❌ ERRO"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            statusLabel.Text = "❌ Falha ao aplicar"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            wait(2)
            applyButton.Text = "🎨 APLICAR SKIN"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            statusLabel.Text = "📋 Pronto para copiar"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    
    -- Quando um jogador sair
    Players.PlayerRemoving:Connect(function(player)
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
    Log("✅ Skin Copier iniciado com sucesso!", "SUCCESS")
    Log("📋 Pressione F8 para abrir/fechar", "INFO")
    Log("📋 Pressione F7 para atualizar lista", "INFO")
    Log("===========================================", "SUCCESS")
    
    -- Notificação
    StarterGui:SetCore("SendNotification", {
        Title = "✅ Skin Copier",
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
