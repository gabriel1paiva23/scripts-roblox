--[[
    Script de Teleporte com 6 Pontos e Loop (SEM LIMITES)
    Criado para Xeno - Agora com 6 loops simultâneos!
]]

-- Criando a interface
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

-- Criando arrays para os pontos
local pointButtons = {}
local pointStatus = {}
local teleportPoints = {} -- Array para armazenar os 6 pontos

-- Controle de loops
local loopStatus = {} -- Status do loop para cada ponto
local loopCoroutines = {} -- Armazenar as coroutines para controle

-- Configurando a GUI
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TeleportScript6PontosLoop"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Frame principal
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -250, 0.5, -250)
Frame.Size = UDim2.new(0, 500, 0, 500)
Frame.Active = true
Frame.Draggable = true
Frame.Selectable = true

-- Título
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "🚀 TELEPORTE MANAGER - 6 PONTOS (SEM LIMITE DE LOOPS)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

-- Função para criar botões de ponto
local function criarBotoesPonto()
    local cores = {
        Color3.fromRGB(255, 70, 70),    -- Vermelho
        Color3.fromRGB(70, 255, 70),    -- Verde
        Color3.fromRGB(70, 70, 255),    -- Azul
        Color3.fromRGB(255, 255, 70),   -- Amarelo
        Color3.fromRGB(255, 70, 255),   -- Rosa
        Color3.fromRGB(70, 255, 255)    -- Ciano
    }
    
    -- Configuração do grid (2 colunas, 3 linhas)
    for i = 1, 6 do
        local linha = math.floor((i - 1) / 2)
        local coluna = (i - 1) % 2
        
        -- Frame para o ponto
        local pointFrame = Instance.new("Frame")
        pointFrame.Parent = Frame
        pointFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        pointFrame.BorderSizePixel = 0
        pointFrame.Position = UDim2.new(0.03 + (coluna * 0.485), 0, 0.1 + (linha * 0.27), 0)
        pointFrame.Size = UDim2.new(0.47, 0, 0.25, 0)
        pointFrame.ClipsDescendants = true
        
        -- Título do ponto
        local pointTitle = Instance.new("TextLabel")
        pointTitle.Parent = pointFrame
        pointTitle.BackgroundColor3 = cores[i]
        pointTitle.Size = UDim2.new(1, 0, 0, 20)
        pointTitle.Font = Enum.Font.GothamBold
        pointTitle.Text = "PONTO " .. i
        pointTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
        pointTitle.TextSize = 12
        
        -- Botão DEFINIR PONTO
        local setBtn = Instance.new("TextButton")
        setBtn.Parent = pointFrame
        setBtn.BackgroundColor3 = cores[i]
        setBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
        setBtn.Size = UDim2.new(0.4, 0, 0, 20)
        setBtn.Font = Enum.Font.Gotham
        setBtn.Text = "DEFINIR"
        setBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        setBtn.TextSize = 9
        setBtn.TextScaled = true
        
        -- Botão TP
        local tpBtn = Instance.new("TextButton")
        tpBtn.Parent = pointFrame
        tpBtn.BackgroundColor3 = cores[i]
        tpBtn.Position = UDim2.new(0.55, 0, 0.25, 0)
        tpBtn.Size = UDim2.new(0.4, 0, 0, 20)
        tpBtn.Font = Enum.Font.Gotham
        tpBtn.Text = "TP"
        tpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        tpBtn.TextSize = 10
        tpBtn.TextScaled = true
        
        -- Botão LOOP
        local loopBtn = Instance.new("TextButton")
        loopBtn.Parent = pointFrame
        loopBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        loopBtn.Position = UDim2.new(0.3, 0, 0.5, 0)
        loopBtn.Size = UDim2.new(0.4, 0, 0, 20)
        loopBtn.Font = Enum.Font.Gotham
        loopBtn.Text = "LOOP OFF"
        loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loopBtn.TextSize = 9
        loopBtn.TextScaled = true
        
        -- Status do ponto
        local status = Instance.new("TextLabel")
        status.Parent = pointFrame
        status.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        status.Position = UDim2.new(0.05, 0, 0.75, 0)
        status.Size = UDim2.new(0.9, 0, 0, 18)
        status.Font = Enum.Font.Gotham
        status.Text = "⚫ Não definido"
        status.TextColor3 = Color3.fromRGB(200, 200, 200)
        status.TextSize = 8
        status.TextScaled = true
        
        -- Armazenando referências
        table.insert(pointButtons, {
            set = setBtn,
            tp = tpBtn,
            loop = loopBtn,
            status = status,
            index = i,
            frame = pointFrame,
            cor = cores[i]
        })
        
        -- Inicializando
        teleportPoints[i] = nil
        loopStatus[i] = false
        loopCoroutines[i] = nil
    end
end

-- Função para contar loops ativos
local function contarLoopsAtivos()
    local count = 0
    for i = 1, 6 do
        if loopStatus[i] then
            count = count + 1
        end
    end
    return count
end

-- Função para atualizar cores dos botões de loop
local function atualizarCoresLoop()
    for i = 1, 6 do
        if loopStatus[i] then
            pointButtons[i].loop.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde quando ativo
            pointButtons[i].loop.Text = "LOOP ON"
            pointButtons[i].status.TextColor3 = Color3.fromRGB(0, 255, 255) -- Ciano quando em loop
        else
            pointButtons[i].loop.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Cinza quando inativo
            pointButtons[i].loop.Text = "LOOP OFF"
            if teleportPoints[i] then
                pointButtons[i].status.TextColor3 = Color3.fromRGB(0, 255, 0) -- Verde quando definido
            else
                pointButtons[i].status.TextColor3 = Color3.fromRGB(200, 200, 200) -- Cinza quando não definido
            end
        end
    end
end

-- Função para definir ponto específico
local function definirPonto(index)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        teleportPoints[index] = character.HumanoidRootPart.Position
        local ponto = teleportPoints[index]
        pointButtons[index].status.Text = string.format("📍 (%.0f,%.0f,%.0f)", ponto.X, ponto.Y, ponto.Z)
        pointButtons[index].status.TextColor3 = Color3.fromRGB(0, 255, 0)
        print(string.format("✅ Ponto %d definido em: (%.1f, %.1f, %.1f)", index, ponto.X, ponto.Y, ponto.Z))
    else
        pointButtons[index].status.Text = "❌ Erro!"
        pointButtons[index].status.TextColor3 = Color3.fromRGB(255, 0, 0)
        wait(1)
        pointButtons[index].status.Text = "⚫ Não definido"
        pointButtons[index].status.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Função para teleportar para ponto específico
local function teleportarParaPonto(index)
    if teleportPoints[index] then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Teleport suave
            character.HumanoidRootPart.CFrame = CFrame.new(teleportPoints[index])
            -- Feedback visual rápido
            pointButtons[index].status.TextColor3 = Color3.fromRGB(255, 255, 0)
            wait(0.05)
            if loopStatus[index] then
                pointButtons[index].status.TextColor3 = Color3.fromRGB(0, 255, 255)
            else
                pointButtons[index].status.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end
end

-- Função para iniciar loop de teleporte
local function iniciarLoop(index)
    if loopCoroutines[index] then
        -- Se já existe um loop, não criar outro
        return
    end
    
    loopCoroutines[index] = coroutine.create(function()
        while loopStatus[index] and teleportPoints[index] do
            teleportarParaPonto(index)
            wait(0.3) -- Intervalo entre teleportes (ajustável)
        end
        loopCoroutines[index] = nil
    end)
    
    coroutine.resume(loopCoroutines[index])
end

-- Função para parar loop
local function pararLoop(index)
    loopStatus[index] = false
    if loopCoroutines[index] then
        loopCoroutines[index] = nil
    end
    if teleportPoints[index] then
        pointButtons[index].status.Text = string.format("📍 (%.0f,%.0f,%.0f)", 
            teleportPoints[index].X, teleportPoints[index].Y, teleportPoints[index].Z)
        pointButtons[index].status.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
    atualizarCoresLoop()
end

-- Função para gerenciar loop (SEM LIMITES!)
local function toggleLoop(index)
    if not teleportPoints[index] then
        -- Se o ponto não está definido, avisar
        pointButtons[index].status.Text = "⚠️ Defina primeiro!"
        pointButtons[index].status.TextColor3 = Color3.fromRGB(255, 255, 0)
        wait(0.5)
        pointButtons[index].status.Text = "⚫ Não definido"
        pointButtons[index].status.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    if loopStatus[index] then
        -- Desativar loop deste ponto
        pararLoop(index)
        print(string.format("⏹️ Loop do ponto %d desativado", index))
    else
        -- Ativar loop (SEM VERIFICAÇÃO DE LIMITE!)
        loopStatus[index] = true
        pointButtons[index].status.Text = string.format("📍 (%.0f,%.0f,%.0f) - Loop ON 🔄", 
            teleportPoints[index].X, teleportPoints[index].Y, teleportPoints[index].Z)
        pointButtons[index].status.TextColor3 = Color3.fromRGB(0, 255, 255)
        atualizarCoresLoop()
        print(string.format("🔄 Loop do ponto %d ativado", index))
        
        -- Iniciar loop
        iniciarLoop(index)
    end
end

-- Criar os botões
criarBotoesPonto()

-- Conectar eventos
for i = 1, 6 do
    local btnSet = pointButtons[i].set
    local btnTP = pointButtons[i].tp
    local btnLoop = pointButtons[i].loop
    local index = i
    
    btnSet.MouseButton1Click:Connect(function()
        definirPonto(index)
    end)
    
    btnTP.MouseButton1Click:Connect(function()
        teleportarParaPonto(index)
    end)
    
    btnLoop.MouseButton1Click:Connect(function()
        toggleLoop(index)
    end)
end

-- Frame para controles globais
local controlFrame = Instance.new("Frame")
controlFrame.Parent = Frame
controlFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
controlFrame.BorderSizePixel = 0
controlFrame.Position = UDim2.new(0.03, 0, 0.85, 0)
controlFrame.Size = UDim2.new(0.94, 0, 0, 50)

-- Label de status global (agora SEM limite!)
local globalStatus = Instance.new("TextLabel")
globalStatus.Parent = controlFrame
globalStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
globalStatus.Position = UDim2.new(0.02, 0, 0.1, 0)
globalStatus.Size = UDim2.new(0.96, 0, 0, 25)
globalStatus.Font = Enum.Font.GothamBold
globalStatus.Text = "LOOPS ATIVOS: 0/6 (SEM LIMITES)"
globalStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
globalStatus.TextSize = 11

-- Botão Reset Todos
local resetBtn = Instance.new("TextButton")
resetBtn.Parent = controlFrame
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
resetBtn.Position = UDim2.new(0.02, 0, 0.6, 0)
resetBtn.Size = UDim2.new(0.3, 0, 0, 25)
resetBtn.Font = Enum.Font.Gotham
resetBtn.Text = "RESETAR"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextSize = 10

-- Botão Parar Todos Loops
local stopLoopsBtn = Instance.new("TextButton")
stopLoopsBtn.Parent = controlFrame
stopLoopsBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
stopLoopsBtn.Position = UDim2.new(0.35, 0, 0.6, 0)
stopLoopsBtn.Size = UDim2.new(0.3, 0, 0, 25)
stopLoopsBtn.Font = Enum.Font.Gotham
stopLoopsBtn.Text = "PARAR LOOPS"
stopLoopsBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
stopLoopsBtn.TextSize = 9

-- Botão Fechar
CloseBtn.Parent = controlFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.Position = UDim2.new(0.68, 0, 0.6, 0)
CloseBtn.Size = UDim2.new(0.3, 0, 0, 25)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Text = "FECHAR"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 10

-- Atualizar status global periodicamente
spawn(function()
    while true do
        local ativos = contarLoopsAtivos()
        globalStatus.Text = string.format("LOOPS ATIVOS: %d/6 (SEM LIMITES)", ativos)
        
        -- Mudar cor baseado na quantidade
        if ativos == 0 then
            globalStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
        elseif ativos <= 3 then
            globalStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            globalStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        wait(0.5)
    end
end)

-- Função resetar todos os pontos
resetBtn.MouseButton1Click:Connect(function()
    -- Desativar todos os loops primeiro
    for i = 1, 6 do
        if loopStatus[i] then
            pararLoop(i)
        end
    end
    
    for i = 1, 6 do
        teleportPoints[i] = nil
        pointButtons[i].status.Text = "⚫ Não definido"
        pointButtons[i].status.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    atualizarCoresLoop()
    print("🗑️ Todos os pontos foram resetados")
end)

-- Parar todos os loops
stopLoopsBtn.MouseButton1Click:Connect(function()
    for i = 1, 6 do
        if loopStatus[i] then
            pararLoop(i)
        end
    end
    print("⏹️ Todos os loops foram parados")
end)

-- Fechar GUI
CloseBtn.MouseButton1Click:Connect(function()
    -- Desativar todos os loops antes de fechar
    for i = 1, 6 do
        loopStatus[i] = false
    end
    ScreenGui:Destroy()
end)

-- Função para tornar a janela arrastável
local dragging
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

print([[
╔══════════════════════════════════════════╗
║    TELEPORTE MANAGER - 6 PONTOS LOOP     ║
╠══════════════════════════════════════════╣
║  🚀 AGORA SEM LIMITE DE LOOPS!           ║
║  🔄 6 LOOPS SIMULTÂNEOS                   ║
║  ⚡ Intervalo: 0.3s                        ║
║  🎯 Todos os pontos podem estar em loop   ║
╚══════════════════════════════════════════╝
]])
