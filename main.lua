-- Script para Natural Disaster Survival
-- Proteção contra scripters disruptivos

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Interface gráfica
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Anti-Scripter System - VOID PUNISHER", "Sentinel")

-- Tabela principal
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    VoidLoop = nil,
    VoidPosition = Vector3.new(0, -5000, 0), -- Posição mais profunda do void
    OriginalPositions = {},
    OriginalAnchored = {}
}

-- Página principal
local MainTab = Window:NewTab("Controle")
local MainSection = MainTab:NewSection("Seleção de Jogador")

-- Dropdown para selecionar jogadores
local PlayerDropdown
local PlayerDropdownCallback = function(selected)
    if selected ~= "Nenhum jogador encontrado" then
        AntiScripter.SelectedPlayer = selected
        print("[SISTEMA] Jogador selecionado: " .. selected)
    else
        AntiScripter.SelectedPlayer = nil
    end
end

-- Criar dropdown inicialmente vazio
PlayerDropdown = MainSection:NewDropdown(
    "Selecionar Jogador", 
    "Escolha o scripter problemático", 
    {}, 
    PlayerDropdownCallback
)

-- Atualizar lista de jogadores
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    
    -- Se não houver outros jogadores, adiciona uma opção vazia
    if #playerNames == 0 then
        table.insert(playerNames, "Nenhum jogador encontrado")
    end
    
    -- Atualiza o dropdown
    PlayerDropdown:Refresh(playerNames, true)
    
    return playerNames
end

-- Função FORTE para enviar jogador ao VOID
local function SendToVoid(player)
    if not player then return end
    
    local character = player.Character
    if not character then
        -- Tenta carregar o character
        player:LoadCharacter()
        task.wait(1)
        character = player.Character
        if not character then return end
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not humanoidRootPart then return end
    
    -- Salva posição original apenas uma vez
    if not AntiScripter.OriginalPositions[player.Name] then
        AntiScripter.OriginalPositions[player.Name] = humanoidRootPart.CFrame
        AntiScripter.OriginalAnchored[player.Name] = humanoidRootPart.Anchored
    end
    
    -- Forçar teleportação imediata para o VOID profundo
    humanoidRootPart.CFrame = CFrame.new(
        AntiScripter.VoidPosition.X + math.random(-50, 50),
        AntiScripter.VoidPosition.Y - math.random(0, 100),
        AntiScripter.VoidPosition.Z + math.random(-50, 50)
    )
    
    -- Ancorar no void
    humanoidRootPart.Anchored = true
    
    -- Remover todas as ferramentas e armas
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            item:Destroy()
        end
    end
    
    -- Tentar remover scripts locais
    for _, script in ipairs(character:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("Script") then
            script.Disabled = true
            script:Destroy()
        end
    end
    
    -- Matar o humanoid (opcional, mas eficaz)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
        task.wait(0.1)
        humanoid.Health = 1
    end
    
    -- Congelar o personagem
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 0.7
        end
    end
    
    return true
end

-- Função para RESTAURAR jogador
local function RestorePlayer(player)
    if not player then return end
    
    local character = player.Character
    if not character then
        player:LoadCharacter()
        task.wait(1)
        character = player.Character
    end
    
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if humanoidRootPart then
            -- Restaurar para posição original
            if AntiScripter.OriginalPositions[player.Name] then
                humanoidRootPart.CFrame = AntiScripter.OriginalPositions[player.Name]
            else
                -- Se não tem posição salva, teleportar para o spawn
                humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            end
            
            -- Restaurar propriedades
            humanoidRootPart.Anchored = AntiScripter.OriginalAnchored[player.Name] or false
            
            -- Restaurar transparência e colisão
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
    
    -- Limpar dados salvos
    AntiScripter.OriginalPositions[player.Name] = nil
    AntiScripter.OriginalAnchored[player.Name] = nil
end

-- Botão de punição
local PunishButton = MainSection:NewButton(
    "Punir Jogador Selecionado", 
    "Envia o scripter para o void em loop", 
    function()
        if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador encontrado" then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            
            if targetPlayer then
                AntiScripter.IsPunishing = not AntiScripter.IsPunishing
                
                if AntiScripter.IsPunishing then
                    PunishButton:UpdateText("PARAR Punição (" .. targetPlayer.Name .. ")")
                    Library:CreateNotification("INICIANDO PUNIÇÃO", 
                        "Jogador: " .. targetPlayer.Name .. "\n" ..
                        "Status: ENVIANDO PARA O VOID...", 
                        "OK"
                    )
                    
                    -- Iniciar loop de punição
                    StartVoidLoop(targetPlayer)
                    
                else
                    PunishButton:UpdateText("Punir Jogador Selecionado")
                    Library:CreateNotification("PUNIÇÃO INTERROMPIDA", 
                        "Jogador: " .. targetPlayer.Name .. "\n" ..
                        "Status: RESTAURANDO...", 
                        "OK"
                    )
                    
                    -- Parar loop e restaurar jogador
                    StopVoidLoop()
                    RestorePlayer(targetPlayer)
                end
            else
                Library:CreateNotification("ERRO", "Jogador não encontrado!", "OK")
            end
        else
            Library:CreateNotification("AVISO", "Selecione um jogador primeiro!", "OK")
        end
    end
)

-- Página de monitoramento
local MonitorTab = Window:NewTab("Monitor")
local MonitorSection = MonitorTab:NewSection("Status do Sistema")

-- Labels de status
local StatusLabel = MonitorSection:NewLabel("Status: AGUARDANDO")
local TargetLabel = MonitorSection:NewLabel("Alvo: NENHUM")
local LoopStatus = MonitorSection:NewLabel("Loop: INATIVO")

-- Loop do void - VERSÃO CORRIGIDA
function StartVoidLoop(targetPlayer)
    if not targetPlayer then return end
    
    -- Parar qualquer loop existente
    StopVoidLoop()
    
    print("[VOID LOOP] Iniciando punição para: " .. targetPlayer.Name)
    
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function(deltaTime)
        if targetPlayer and Players:FindFirstChild(targetPlayer.Name) then
            local success = SendToVoid(targetPlayer)
            
            if success then
                StatusLabel:UpdateLabel("Status: PUNINDO 🔥")
                TargetLabel:UpdateLabel("Alvo: " .. targetPlayer.Name)
                LoopStatus:UpdateLabel("Loop: ATIVO (VOID)")
            end
        else
            -- Jogador saiu do jogo
            StatusLabel:UpdateLabel("Status: JOGADOR SAIU")
            TargetLabel:UpdateLabel("Alvo: DESCONECTADO")
            LoopStatus:UpdateLabel("Loop: PARADO")
            StopVoidLoop()
            PunishButton:UpdateText("Punir Jogador Selecionado")
            AntiScripter.IsPunishing = false
        end
    end)
    
    -- Também usar um loop separado para garantir
    spawn(function()
        while AntiScripter.IsPunishing and targetPlayer do
            SendToVoid(targetPlayer)
            task.wait(0.1) -- Teleporte muito rápido
        end
    end)
end

function StopVoidLoop()
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    AntiScripter.IsPunishing = false
    
    StatusLabel:UpdateLabel("Status: INATIVO")
    LoopStatus:UpdateLabel("Loop: PARADO")
end

-- Página de configurações
local SettingsTab = Window:NewTab("Configurações")
local SettingsSection = SettingsTab:NewSection("Opções do Sistema")

-- Botão para atualizar lista
SettingsSection:NewButton(
    "Atualizar Lista de Jogadores", 
    "Recarrega a lista de jogadores online", 
    function()
        local players = UpdatePlayerList()
        if #players > 0 and players[1] ~= "Nenhum jogador encontrado" then
            Library:CreateNotification("LISTA ATUALIZADA", 
                "Total: " .. #players .. " jogadores\n" ..
                "Pronto para selecionar!", 
                "OK"
            )
        else
            Library:CreateNotification("INFO", "Nenhum outro jogador na partida", "OK")
        end
    end
)

-- Toggle para auto-atualização
local AutoRefresh = true
SettingsSection:NewToggle(
    "Auto-atualizar Lista", 
    "Atualiza automaticamente a lista de jogadores", 
    function(state)
        AutoRefresh = state
        Library:CreateNotification("CONFIGURAÇÃO", "Auto-atualização: " .. (state and "✅ LIGADA" or "❌ DESLIGADA"), "OK")
    end
):Set(AutoRefresh)

-- Botão de teste do void
SettingsSection:NewButton(
    "TESTE VOID", 
    "Testa a função de void no jogador selecionado", 
    function()
        if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador encontrado" then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if targetPlayer then
                local success = SendToVoid(targetPlayer)
                if success then
                    Library:CreateNotification("TESTE BEM-SUCEDIDO", 
                        targetPlayer.Name .. " enviado ao VOID!\n" ..
                        "Posição: " .. tostring(AntiScripter.VoidPosition), 
                        "OK"
                    )
                end
            end
        end
    end
)

-- Botão de emergência para PARAR TUDO
SettingsSection:NewButton(
    "🚨 PARAR TODAS AS PUNIÇÕES", 
    "Para imediatamente todas as punições ativas", 
    function()
        StopVoidLoop()
        PunishButton:UpdateText("Punir Jogador Selecionado")
        AntiScripter.IsPunishing = false
        
        -- Restaurar todos os jogadores
        for playerName, _ in pairs(AntiScripter.OriginalPositions) do
            local player = Players:FindFirstChild(playerName)
            if player then
                RestorePlayer(player)
            end
        end
        
        Library:CreateNotification("🚨 EMERGÊNCIA", 
            "Todas as punições foram interrompidas!\n" ..
            "Todos os jogadores foram restaurados.", 
            "OK"
        )
    end
)

-- Atualização automática da lista de jogadores
spawn(function()
    while true do
        if AutoRefresh then
            UpdatePlayerList()
        end
        task.wait(5)
    end
end)

-- Eventos para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if AutoRefresh and player ~= Players.LocalPlayer then
        task.wait(2)
        UpdatePlayerList()
        Library:CreateNotification("👤 NOVO JOGADOR", player.Name .. " entrou na partida", "OK")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if AutoRefresh then
        task.wait(1)
        UpdatePlayerList()
        
        -- Se o jogador punido saiu, parar punição
        if AntiScripter.SelectedPlayer == player.Name then
            AntiScripter.SelectedPlayer = nil
            StopVoidLoop()
            PunishButton:UpdateText("Punir Jogador Selecionado")
            AntiScripter.IsPunishing = false
            
            Library:CreateNotification("JOGADOR SAIU", 
                player.Name .. " saiu da partida\n" ..
                "Punição automática interrompida.", 
                "OK"
            )
        end
    end
end)

-- Inicialização
task.wait(2) -- Aguardar carregamento completo
UpdatePlayerList()

Library:CreateNotification("ANTI-SCRIPTER SYSTEM", 
    "✅ SISTEMA CARREGADO COM SUCESSO!\n\n" ..
    "📊 Jogadores na partida: " .. #Players:GetPlayers() .. "\n" ..
    "🎯 Selecione um jogador para punir\n" ..
    "🗑️ Pressione DELETE para fechar\n\n" ..
    "⚠️ Use com responsabilidade!", 
    "OK"
)

-- Limpeza ao fechar
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        StopVoidLoop()
        
        -- Restaurar todos os jogadores antes de fechar
        for playerName, _ in pairs(AntiScripter.OriginalPositions) do
            local player = Players:FindFirstChild(playerName)
            if player then
                RestorePlayer(player)
            end
        end
        
        Window:Destroy()
        Library:DestroyNotification()
        
        print("========================================")
        print("Sistema Anti-Scripter FECHADO!")
        print("Todos os jogadores foram restaurados.")
        print("========================================")
    end
end)

-- Mensagem de inicialização no console
print([[
========================================
   ANTI-SCRIPTER SYSTEM - VOID PUNISHER
========================================
✅ Sistema carregado com sucesso!
👥 Jogadores: ]] .. #Players:GetPlayers() .. [[
🎯 Instruções:
   1. Selecione um jogador no dropdown
   2. Clique em 'Punir Jogador Selecionado'
   3. Para parar, clique novamente no botão
   4. Pressione DELETE para fechar o menu
   
⚠️  Use este poder com responsabilidade!
========================================
]])

-- Garantir que o loop seja parado se o script for interrompido
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    StopVoidLoop()
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    StopVoidLoop()
end)
