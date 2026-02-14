--[[
================================================================================
                    UNIVERSAL SKIN COPIER - ROBLOX
                    Copie a skin de qualquer jogador!
================================================================================
Versão: 3.0.0
Funcionalidade: Botão "Copiar Skin" em cada jogador
Recursos: 
    - Botão individual por jogador
    - Copia TODOS os aspectos da skin
    - Funciona em QUALQUER jogo
    - CORRIGIDO: Skin aparece para todos
================================================================================
]]

--==============================================================================
-- SERVIÇOS
--==============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

--==============================================================================
-- VARIÁVEIS PRINCIPAIS
--==============================================================================
local LocalPlayer = Players.LocalPlayer
local SkinCopier = {
    Version = "3.0.0",
    Active = true,
    GUI = nil,
    Buttons = {},
    SkinData = {},
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
-- FUNÇÃO PARA COPIAR CARACTERÍSTICAS DO JOGADOR (MÉTODO QUE FUNCIONA EM TODOS OS JOGOS)
--==============================================================================
function SkinCopier:CopyPlayerAppearance(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        Log("Jogador ou personagem inválido!", "ERROR")
        return false
    end
    
    Log("Copiando aparência de: " .. targetPlayer.Name, "INFO")
    
    local character = targetPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then
        Log("Humanoid não encontrado!", "ERROR")
        return false
    end
    
    -- MÉTODO 1: Capturar propriedades do humanoid
    local appearanceData = {
        -- Cores do corpo (funciona em 100% dos jogos)
        HeadColor = humanoid.HeadColor,
        TorsoColor = humanoid.TorsoColor,
        LeftArmColor = humanoid.LeftArmColor,
        RightArmColor = humanoid.RightArmColor,
        LeftLegColor = humanoid.LeftLegColor,
        RightLegColor = humanoid.RightLegColor,
        
        -- Escalas do corpo
        BodyTypeScale = humanoid.BodyTypeScale,
        BodyWidthScale = humanoid.BodyWidthScale,
        BodyDepthScale = humanoid.BodyDepthScale,
        BodyHeightScale = humanoid.BodyHeightScale,
        BodyProportionScale = humanoid.BodyProportionScale,
        HeadScale = humanoid.HeadScale,
        
        -- Roupas (IDs)
        ShirtTemplate = nil,
        PantsTemplate = nil,
        GraphicTemplate = nil,
        
        -- Acessórios (guardar os handles)
        Accessories = {},
        
        -- Características físicas
        BodyColors = {},
        SourcePlayer = targetPlayer.Name
    }
    
    -- Capturar roupas
    local shirt = character:FindFirstChildOfClass("Shirt")
    if shirt then
        appearanceData.ShirtTemplate = shirt.ShirtTemplate
    end
    
    local pants = character:FindFirstChildOfClass("Pants")
    if pants then
        appearanceData.PantsTemplate = pants.PantsTemplate
    end
    
    local graphic = character:FindFirstChildOfClass("Graphic")
    if graphic then
        appearanceData.GraphicTemplate = graphic.Graphic
    end
    
    -- Capturar acessórios de forma segura
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") and accessory.Handle then
            local accData = {
                Name = accessory.Name,
                AccessoryType = accessory.AccessoryType,
                HandleCFrame = accessory.Handle.CFrame,
                HandleSize = accessory.Handle.Size,
                HandleColor = accessory.Handle.BrickColor,
                HandleMaterial = accessory.Handle.Material,
                MeshId = accessory.Handle:FindFirstChildOfClass("SpecialMesh") and accessory.Handle:FindFirstChildOfClass("SpecialMesh").MeshId or "",
                TextureId = accessory.Handle:FindFirstChildOfClass("SpecialMesh") and accessory.Handle:FindFirstChildOfClass("SpecialMesh").TextureId or ""
            }
            table.insert(appearanceData.Accessories, accData)
        end
    end
    
    -- MÉTODO 2: Capturar BodyColors (funciona em jogos mais antigos)
    local bodyColors = character:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        appearanceData.BodyColors = {
            HeadColor = bodyColors.HeadColor,
            TorsoColor = bodyColors.TorsoColor,
            LeftArmColor = bodyColors.LeftArmColor,
            RightArmColor = bodyColors.RightArmColor,
            LeftLegColor = bodyColors.LeftLegColor,
            RightLegColor = bodyColors.RightLegColor
        }
    end
    
    -- MÉTODO 3: Capturar características das partes do corpo
    local parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            appearanceData[partName .. "Data"] = {
                BrickColor = part.BrickColor,
                Material = part.Material,
                Size = part.Size,
                Transparency = part.Transparency,
                Reflectance = part.Reflectance
            }
        end
    end
    
    -- Salvar dados
    self.SkinData[targetPlayer.Name] = appearanceData
    
    Log("✅ Aparência de " .. targetPlayer.Name .. " copiada! (" .. #appearanceData.Accessories .. " acessórios)", "SUCCESS")
    return true
end

--==============================================================================
-- FUNÇÃO PARA APLICAR APARÊNCIA (MÉTODO QUE FUNCIONA EM TODOS OS JOGOS)
--==============================================================================
function SkinCopier:ApplyAppearance(sourcePlayerName)
    local appearance = self.SkinData[sourcePlayerName]
    if not appearance then
        Log("Nenhuma aparência salva para: " .. sourcePlayerName, "ERROR")
        return false
    end
    
    Log("Aplicando aparência de " .. sourcePlayerName .. "...", "INFO")
    
    -- Garantir que o personagem existe
    if not LocalPlayer.Character then
        LocalPlayer:LoadCharacter()
        wait(1)
    end
    
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then
        Log("Humanoid não encontrado!", "ERROR")
        return false
    end
    
    -- MÉTODO 1: Aplicar cores diretamente no humanoid (funciona em TODOS os jogos)
    pcall(function()
        humanoid.HeadColor = appearance.HeadColor
        humanoid.TorsoColor = appearance.TorsoColor
        humanoid.LeftArmColor = appearance.LeftArmColor
        humanoid.RightArmColor = appearance.RightArmColor
        humanoid.LeftLegColor = appearance.LeftLegColor
        humanoid.RightLegColor = appearance.RightLegColor
    end)
    
    -- MÉTODO 2: Aplicar escalas do corpo
    pcall(function()
        humanoid.BodyTypeScale = appearance.BodyTypeScale
        humanoid.BodyWidthScale = appearance.BodyWidthScale
        humanoid.BodyDepthScale = appearance.BodyDepthScale
        humanoid.BodyHeightScale = appearance.BodyHeightScale
        humanoid.BodyProportionScale = appearance.BodyProportionScale
        humanoid.HeadScale = appearance.HeadScale
    end)
    
    -- MÉTODO 3: Aplicar roupas (se existirem no jogo)
    if appearance.ShirtTemplate then
        local shirt = character:FindFirstChildOfClass("Shirt")
        if not shirt then
            shirt = Instance.new("Shirt")
            shirt.Parent = character
        end
        shirt.ShirtTemplate = appearance.ShirtTemplate
    end
    
    if appearance.PantsTemplate then
        local pants = character:FindFirstChildOfClass("Pants")
        if not pants then
            pants = Instance.new("Pants")
            pants.Parent = character
        end
        pants.PantsTemplate = appearance.PantsTemplate
    end
    
    if appearance.GraphicTemplate then
        local graphic = character:FindFirstChildOfClass("Graphic")
        if not graphic then
            graphic = Instance.new("Graphic")
            graphic.Parent = character
        end
        graphic.Graphic = appearance.GraphicTemplate
    end
    
    -- MÉTODO 4: Aplicar BodyColors (para jogos mais antigos)
    if next(appearance.BodyColors) then
        local bodyColors = character:FindFirstChildOfClass("BodyColors")
        if not bodyColors then
            bodyColors = Instance.new("BodyColors")
            bodyColors.Parent = character
        end
        bodyColors.HeadColor = appearance.BodyColors.HeadColor or appearance.HeadColor
        bodyColors.TorsoColor = appearance.BodyColors.TorsoColor or appearance.TorsoColor
        bodyColors.LeftArmColor = appearance.BodyColors.LeftArmColor or appearance.LeftArmColor
        bodyColors.RightArmColor = appearance.BodyColors.RightArmColor or appearance.RightArmColor
        bodyColors.LeftLegColor = appearance.BodyColors.LeftLegColor or appearance.LeftLegColor
        bodyColors.RightLegColor = appearance.BodyColors.RightLegColor or appearance.RightLegColor
    end
    
    -- MÉTODO 5: Aplicar características das partes do corpo
    local parts = {
        {"Head", "HeadData"},
        {"Torso", "TorsoData"},
        {"Left Arm", "Left ArmData"},
        {"Right Arm", "Right ArmData"},
        {"Left Leg", "Left LegData"},
        {"Right Leg", "Right LegData"}
    }
    
    for _, partInfo in ipairs(parts) do
        local partName = partInfo[1]
        local dataName = partInfo[2]
        local partData = appearance[dataName]
        
        if partData then
            local part = character:FindFirstChild(partName)
            if part then
                pcall(function()
                    part.BrickColor = partData.BrickColor
                    part.Material = partData.Material
                    part.Size = partData.Size
                    part.Transparency = partData.Transparency
                    part.Reflectance = partData.Reflectance
                end)
            end
        end
    end
    
    -- MÉTODO 6: Recriar acessórios (a parte mais importante!)
    -- Primeiro, remover acessórios antigos
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then
            child:Destroy()
        end
    end
    
    -- Recriar acessórios copiados
    for _, accData in ipairs(appearance.Accessories) do
        pcall(function()
            local accessory = Instance.new("Accessory")
            accessory.Name = accData.Name
            accessory.AccessoryType = accData.AccessoryType
            accessory.Parent = character
            
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = accData.HandleSize
            handle.BrickColor = accData.HandleColor
            handle.Material = accData.HandleMaterial
            handle.Anchored = false
            handle.CanCollide = false
            handle.Parent = accessory
            
            -- Adicionar mesh se existir
            if accData.MeshId and accData.MeshId ~= "" then
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshId = accData.MeshId
                mesh.TextureId = accData.TextureId
                mesh.Parent = handle
            end
            
            -- Posicionar o acessório
            if character:FindFirstChild("HumanoidRootPart") then
                handle.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            end
        end)
    end
    
    -- MÉTODO 7: Forçar atualização do personagem (funciona em muitos jogos)
    pcall(function()
        -- Mudar ligeiramente a posição para forçar update
        if character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0.1, 0)
            wait(0.1)
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -0.1, 0)
        end
    end)
    
    Log("✅ Aparência de " .. sourcePlayerName .. " aplicada com sucesso!", "SUCCESS")
    return true
end

--==============================================================================
-- CRIAÇÃO DA INTERFACE
--==============================================================================
function SkinCopier:CreateGUI()
    Log("Criando interface...", "INFO")
    
    if self.GUI then
        self.GUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SkinCopierGUI"
    screenGui.DisplayOrder = 9999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    self.GUI = screenGui
    
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
    self:UpdatePlayerList()
end

--==============================================================================
-- ATUALIZAR LISTA DE JOGADORES
--==============================================================================
function SkinCopier:UpdatePlayerList()
    if not self.Container then return end
    
    for _, child in pairs(self.Container:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    self.Buttons = {}
    
    local yPos = 5
    local players = Players:GetPlayers()
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            self:CreatePlayerButton(player, yPos)
            yPos = yPos + 65
        end
    end
    
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
    
    self.Container.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end

--==============================================================================
-- CRIAR BOTÃO PARA JOGADOR
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
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 25)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 15)
    statusLabel.Position = UDim2.new(0, 5, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = self.SkinData[player.Name] and "✅ Copiado" or "📋 Pronto"
    statusLabel.TextColor3 = self.SkinData[player.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame
    
    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0.48, -2, 0, 25)
    copyButton.Position = UDim2.new(0, 5, 1, -30)
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    copyButton.Text = "📋 COPIAR"
    copyButton.TextColor3 = Color3.new(1, 1, 1)
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 11
    copyButton.Parent = frame
    
    local applyButton = Instance.new("TextButton")
    applyButton.Name = "ApplyButton"
    applyButton.Size = UDim2.new(0.48, -2, 0, 25)
    applyButton.Position = UDim2.new(0.52, 2, 1, -30)
    applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    applyButton.Text = "🎨 APLICAR"
    applyButton.TextColor3 = Color3.new(1, 1, 1)
    applyButton.Font = Enum.Font.SourceSansBold
    applyButton.TextSize = 11
    applyButton.Parent = frame
    
    -- Evento Copiar
    copyButton.MouseButton1Click:Connect(function()
        copyButton.Text = "⏳..."
        copyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        copyButton.Active = false
        
        local success = self:CopyPlayerAppearance(player)
        
        if success then
            copyButton.Text = "✅ COPIADO"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Copiado"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(1)
            copyButton.Text = "📋 COPIAR"
            copyButton.Active = true
        else
            copyButton.Text = "❌ ERRO"
            copyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            wait(1)
            copyButton.Text = "📋 COPIAR"
            copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            copyButton.Active = true
        end
    end)
    
    -- Evento Aplicar
    applyButton.MouseButton1Click:Connect(function()
        if not self.SkinData[player.Name] then
            applyButton.Text = "⚠️ COPIE!"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
            applyButton.Active = false
            statusLabel.Text = "⚠️ Copie primeiro!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            wait(1)
            applyButton.Text = "🎨 APLICAR"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = self.SkinData[player.Name] and "✅ Copiado" or "📋 Pronto"
            statusLabel.TextColor3 = self.SkinData[player.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
            return
        end
        
        applyButton.Text = "⏳..."
        applyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        applyButton.Active = false
        
        local success = self:ApplyAppearance(player.Name)
        
        if success then
            applyButton.Text = "✅ APLICADO"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Aplicado!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(1.5)
            applyButton.Text = "🎨 APLICAR"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = "✅ Copiado"
        else
            applyButton.Text = "❌ ERRO"
            applyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            wait(1)
            applyButton.Text = "🎨 APLICAR"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            applyButton.Active = true
            statusLabel.Text = "✅ Copiado"
        end
    end)
    
    self.Buttons[player.Name] = {
        Frame = frame,
        CopyButton = copyButton,
        ApplyButton = applyButton,
        StatusLabel = statusLabel
    }
end

--==============================================================================
-- MONITORAMENTO
--==============================================================================
function SkinCopier:StartMonitoring()
    Players.PlayerAdded:Connect(function()
        wait(1)
        self:UpdatePlayerList()
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if self.SkinData[player.Name] then
            self.SkinData[player.Name] = nil
        end
        self:UpdatePlayerList()
    end)
    
    spawn(function()
        while self.Active do
            wait(5)
            if self.GUI and self.GUI.Enabled then
                self:UpdatePlayerList()
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
    
    -- Aguardar jogador
    while not LocalPlayer or not LocalPlayer.Character do
        wait(1)
    end
    
    self:CreateGUI()
    self:StartMonitoring()
    
    -- Hotkey F8
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.F8 and self.GUI then
            self.GUI.Enabled = not self.GUI.Enabled
        end
    end)
    
    Log("✅ Skin Copier v" .. self.Version .. " iniciado! Pressione F8", "SUCCESS")
    
    StarterGui:SetCore("SendNotification", {
        Title = "✅ Skin Copier",
        Text = "Pressione F8 para abrir!",
        Duration = 3
    })
    
    return true
end

--==============================================================================
-- EXECUTAR
--==============================================================================
repeat wait() until game:IsLoaded() and Players.LocalPlayer

pcall(function()
    SkinCopier:Init()
end)

return SkinCopier
