-- Script para Natural Disaster Survival - ANTI-SCRIPTER SYSTEM
-- Versão Corrigida e Funcional

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Carregar interface Kavo UI
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ERRO",
        Text = "Falha ao carregar interface gráfica",
        Duration = 5
    })
    return
end

local Window = Library.CreateLib("Anti-Scripter VOID System", "DarkTheme")

-- Variáveis globais
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    VoidLoop = nil,
    TargetPlayer = nil,
    VoidPosition = Vector3.new(0, -10000, 0) -- VOID PROFUNDO
}

-- Função para criar notificação
local function Notify(title, text, duration)
    Library:CreateNotification(title, text, "OK")
end

-- Página PRINCIPAL
local MainTab = Window:NewTab("Controle Principal")
local MainSection = MainTab:NewSection("Selecionar e Punir")

-- DROPDOWN de jogadores
local PlayerDropdown = MainSection:NewDropdown(
    "Selecionar Jogador", 
    "Clique para escolher quem punir", 
    {"Carregando..."}, 
    function(value)
        if value and value ~= "Nenhum jogador" then
            AntiScripter.SelectedPlayer = value
            print("[SISTEMA] Jogador selecionado: " .. value)
            Notify("Jogador Selecionado", value .. " selecionado!", 3)
        end
    end
)

-- Atualizar lista de jogadores
local function UpdatePlayerList()
    local playerList = {}
    local playerCount = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
            playerCount = playerCount + 1
        end
    end
    
    if #playerList == 0 then
        table.insert(playerList, "Nenhum jogador")
    end
    
    PlayerDropdown:Refresh(playerList)
    return playerList
end

-- Função PRINCIPAL para enviar ao VOID
local function SendPlayerToVoid(player)
    if not player or not player:IsA("Player") then
        print("[ERRO] Jogador inválido")
        return false
    end
    
    local character = player.Character
    if not character then
        -- Tenta forçar carregamento do personagem
        player:LoadCharacter()
        wait(1)
        character = player.Character
        if not character then
            print("[ERRO] Personagem não encontrado: " .. player.Name)
            return false
        end
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        -- Tenta encontrar torso como fallback
        humanoidRootPart = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    
    if humanoidRootPart then
        -- TELEPORTAR PARA O VOID (MUITO MAIS EFETIVO)
        humanoidRootPart.CFrame = CFrame.new(
            AntiScripter.VoidPosition.X + math.random(-100, 100),
            AntiScripter.VoidPosition.Y - math.random(0, 500),
            AntiScripter.VoidPosition.Z + math.random(-100, 100)
        )
        
        -- ANCORAR no lugar (IMPORTANTE!)
        humanoidRootPart.Anchored = true
        
        -- Remover ferramentas/armas
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") or item:IsA("HopperBin") then
                item:Destroy()
            end
        end
        
        -- Desabilitar scripts locais
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("LocalScript") or obj:IsA("Script") then
                obj.Disabled = true
            end
        end
        
        -- Garantir que está no void
        character:SetPrimaryPartCFrame(CFrame.new(AntiScripter.VoidPosition))
        
        return true
    else
        print("[ERRO] Não encontrou HumanoidRootPart em " .. player.Name)
        return false
    end
end

-- Função para RESTAURAR jogador
local function RestorePlayer(player)
    if not player then return end
    
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or 
                                 character:FindFirstChild("Torso") or 
                                 character:FindFirstChild("UpperTorso")
        
        if humanoidRootPart then
            -- Teleportar para posição segura
            humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            -- Liberar ancoragem
            humanoidRootPart.Anchored = false
            
            -- Reativar scripts
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("LocalScript") or obj:IsA("Script") then
                    obj.Disabled = false
                end
            end
        end
    end
end

-- BOTÃO PRINCIPAL DE PUNIÇÃO
local punishButtonText = "🚀 PUNIR JOGADOR SELECIONADO"
local PunishButton = MainSection:NewButton(
    punishButtonText, 
    "Clique para punir/parar punição", 
    function()
        if not AntiScripter.SelectedPlayer or AntiScripter.SelectedPlayer == "Nenhum jogador" then
            Notify("ERRO", "Selecione um jogador primeiro!", 3)
            return
        end
        
        local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
        if not targetPlayer then
            Notify("ERRO", "Jogador não encontrado!", 3)
            return
        end
        
        AntiScripter.IsPunishing = not AntiScripter.IsPunishing
        
        if AntiScripter.IsPunishing then
            -- INICIAR PUNIÇÃO
            PunishButton:UpdateText("⛔ PARAR PUNIÇÃO (" .. targetPlayer.Name .. ")")
            AntiScripter.TargetPlayer = targetPlayer
            
            Notify("PUNIÇÃO INICIADA", 
                "Jogador: " .. targetPlayer.Name .. "\n" ..
                "Status: ENVIANDO PARA O VOID...", 
                3
            )
            
            -- Iniciar loop AGORA
            StartVoidLoop()
            
        else
            -- PARAR PUNIÇÃO
            PunishButton:UpdateText(punishButtonText)
            
            Notify("PUNIÇÃO PARADA", 
                "Jogador: " .. targetPlayer.Name .. "\n" ..
                "Status: RESTAURANDO...", 
                3
            )
            
            -- Parar loop e restaurar
            StopVoidLoop()
            RestorePlayer(targetPlayer)
            AntiScripter.TargetPlayer = nil
        end
    end
)

-- Página de MONITORAMENTO
local MonitorTab = Window:NewTab("Monitor ao Vivo")
local MonitorSection = MonitorTab:NewSection("Status do Sistema")

local StatusLabel = MonitorSection:NewLabel("🟢 Status: AGUARDANDO")
local PlayerLabel = MonitorSection:NewLabel("🎯 Alvo: NENHUM")
local LoopLabel = MonitorSection:NewLabel("🔄 Loop: INATIVO")

-- LOOP DO VOID (SIMPLIFICADO E FUNCIONAL)
function StartVoidLoop()
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
    end
    
    print("[LOOP] Iniciando punição para: " .. AntiScripter.SelectedPlayer)
    
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if AntiScripter.TargetPlayer and AntiScripter.IsPunishing then
            local success = SendPlayerToVoid(AntiScripter.TargetPlayer)
            
            if success then
                StatusLabel:UpdateLabel("🔴 Status: PUNINDO AGORA")
                PlayerLabel:UpdateLabel("🎯 Alvo: " .. AntiScripter.TargetPlayer.Name)
                LoopLabel:UpdateLabel("🔄 Loop: ATIVO (" .. tick() .. ")")
            end
        end
    end)
    
    -- Loop adicional para garantir
    spawn(function()
        while AntiScripter.IsPunishing and AntiScripter.TargetPlayer do
            SendPlayerToVoid(AntiScripter.TargetPlayer)
            wait(0.05) -- Teleporte SUPER rápido
        end
    end)
end

function StopVoidLoop()
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    
    AntiScripter.IsPunishing = false
    StatusLabel:UpdateLabel("🟢 Status: PARADO")
    LoopLabel:UpdateLabel("🔄 Loop: INATIVO")
end

-- Página de CONFIGURAÇÕES
local ConfigTab = Window:NewTab("Configurações")
local ConfigSection = ConfigTab:NewSection("Opções")

-- Botão para ATUALIZAR lista manualmente
ConfigSection:NewButton(
    "🔄 Atualizar Lista de Jogadores", 
    "Clique para atualizar a lista", 
    function()
        local players = UpdatePlayerList()
        local count = #players
        if count > 0 and players[1] ~= "Nenhum jogador" then
            Notify("Lista Atualizada", 
                "Total: " .. (count - 1) .. " jogadores\n" ..
                "Pronto para selecionar!", 
                3
            )
        end
    end
)

-- Botão de TESTE RÁPIDO
ConfigSection:NewButton(
    "🧪 TESTE RÁPIDO DO VOID", 
    "Testa a punição no jogador selecionado", 
    function()
        if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador" then
            local target = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if target then
                local success = SendPlayerToVoid(target)
                if success then
                    Notify("TESTE BEM-SUCEDIDO", 
                        target.Name .. " enviado ao VOID!\n" ..
                        "Posição: Y = " .. AntiScripter.VoidPosition.Y, 
                        3
                    )
                end
            end
        else
            Notify("ERRO", "Selecione um jogador primeiro!", 3)
        end
    end
)

-- Botão de EMERGÊNCIA
ConfigSection:NewButton(
    "🚨 PARAR TUDO (EMERGÊNCIA)", 
    "Para todas as punições imediatamente", 
    function()
        StopVoidLoop()
        PunishButton:UpdateText(punishButtonText)
        
        -- Restaurar todos os jogadores possíveis
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                RestorePlayer(player)
            end
        end
        
        Notify("🚨 EMERGÊNCIA", 
            "Todas as punições PARADAS!\n" ..
            "Todos os jogadores restaurados.", 
            3
        )
        
        AntiScripter.IsPunishing = false
        AntiScripter.TargetPlayer = nil
    end
)

-- AUTO-ATUALIZAÇÃO da lista
local autoRefresh = true
ConfigSection:NewToggle(
    "Auto-atualizar Lista", 
    "Atualiza automaticamente a cada 5s", 
    function(state)
        autoRefresh = state
        Notify("Auto-Refresh", state and "ATIVADO" or "DESATIVADO", 2)
    end
)

-- INICIALIZAÇÃO DO SISTEMA
wait(1) -- Esperar carregamento

-- Atualizar lista inicial
UpdatePlayerList()

-- Sistema de auto-atualização
spawn(function()
    while true do
        if autoRefresh then
            UpdatePlayerList()
        end
        wait(5)
    end
end)

-- Eventos para jogadores entrando/saindo
Players.PlayerAdded:Connect(function(player)
    if autoRefresh then
        wait(1)
        UpdatePlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if autoRefresh then
        wait(1)
        UpdatePlayerList()
        
        -- Se o jogador punido saiu, parar punição
        if AntiScripter.SelectedPlayer == player.Name then
            StopVoidLoop()
            PunishButton:UpdateText(punishButtonText)
            AntiScripter.IsPunishing = false
            AntiScripter.TargetPlayer = nil
        end
    end
end)

-- FECHAR com DELETE
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        StopVoidLoop()
        Window:Destroy()
        print("[SISTEMA] Fechado pelo usuário")
    end
end)

-- MENSAGEM INICIAL
Notify("ANTI-SCRIPTER SYSTEM", 
    "✅ Sistema carregado com sucesso!\n\n" ..
    "👥 Jogadores: " .. (#Players:GetPlayers() - 1) .. "\n" ..
    "🎯 Selecione um jogador\n" ..
    "🚀 Clique para punir\n" ..
    "⛔ DELETE para fechar", 
    5
)

print([[
========================================
   ANTI-SCRIPTER VOID SYSTEM v3.0
========================================
✅ Sistema inicializado!
👥 Total de jogadores: ]] .. #Players:GetPlayers() .. [[

📋 INSTRUÇÕES:
1. Selecione um jogador no menu DROPDOWN
2. Clique no botão "🚀 PUNIR JOGADOR SELECIONADO"
3. O botão mudará para "⛔ PARAR PUNIÇÃO"
4. O jogador será enviado ao VOID em loop
5. Para parar, clique no botão novamente
6. Pressione DELETE para fechar o menu

⚠️  Use com responsabilidade!
========================================
]])
