-- Script para Natural Disaster Survival
-- Proteção contra scripters disruptivos

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- Interface gráfica
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Anti-Scripter System", "Sentinel")

-- Tabela principal
local AntiScripter = {
    SelectedPlayer = nil,
    IsPunishing = false,
    VoidLoop = nil,
    VoidPosition = Vector3.new(0, -1000, 0) -- Posição do void
}

-- Página principal
local MainTab = Window:NewTab("Controle")
local MainSection = MainTab:NewSection("Seleção de Jogador")

-- Dropdown para selecionar jogadores
local PlayerDropdown
local PlayerDropdownCallback = function(selected)
    AntiScripter.SelectedPlayer = selected
    print("Jogador selecionado: " .. selected)
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

-- Botão de punição
local PunishButton = MainSection:NewButton(
    "Punir Jogador Selecionado", 
    "Envia o scripter para o void em loop", 
    function()
        if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador encontrado" then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                AntiScripter.IsPunishing = not AntiScripter.IsPunishing
                
                if AntiScripter.IsPunishing then
                    PunishButton:UpdateText("Parar Punição")
                    StartVoidLoop(targetPlayer)
                    Library:CreateNotification("Sucesso", "Punindo " .. targetPlayer.Name, "OK")
                else
                    PunishButton:UpdateText("Punir Jogador Selecionado")
                    StopVoidLoop()
                    Library:CreateNotification("Aviso", "Punição interrompida", "OK")
                end
            else
                Library:CreateNotification("Erro", "Jogador não encontrado ou sem personagem", "OK")
            end
        else
            Library:CreateNotification("Aviso", "Selecione um jogador primeiro", "OK")
        end
    end
)

-- Página de monitoramento
local MonitorTab = Window:NewTab("Monitor")
local MonitorSection = MonitorTab:NewSection("Status do Sistema")

-- Labels de status
local StatusLabel = MonitorSection:NewLabel("Status: Inativo")
local TargetLabel = MonitorSection:NewLabel("Alvo: Nenhum")

-- Função para enviar jogador ao void
local function SendToVoid(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Teleportar para o void
            humanoidRootPart.CFrame = CFrame.new(AntiScripter.VoidPosition)
            
            -- Impedir movimento
            humanoidRootPart.Anchored = true
            
            -- Remover ferramentas/armas
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") or tool:IsA("HopperBin") then
                    tool:Destroy()
                end
            end
            
            -- Tentar remover scripts locais
            local scriptsToRemove = {
                "LocalScript", "Script", "ModuleScript"
            }
            
            for _, scriptType in ipairs(scriptsToRemove) do
                for _, script in ipairs(character:GetDescendants()) do
                    if script:IsA(scriptType) then
                        script:Destroy()
                    end
                end
            end
        end
    end
end

-- Loop do void
function StartVoidLoop(targetPlayer)
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
    end
    
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if targetPlayer and targetPlayer.Character then
            SendToVoid(targetPlayer)
            StatusLabel:UpdateLabel("Status: Punindo " .. targetPlayer.Name)
            TargetLabel:UpdateLabel("Alvo: " .. targetPlayer.Name)
        end
    end)
end

function StopVoidLoop()
    if AntiScripter.VoidLoop then
        AntiScripter.VoidLoop:Disconnect()
        AntiScripter.VoidLoop = nil
    end
    AntiScripter.IsPunishing = false
    StatusLabel:UpdateLabel("Status: Inativo")
    TargetLabel:UpdateLabel("Alvo: Nenhum")
    
    -- Reativar movimento do jogador se ainda estiver na partida
    if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador encontrado" then
        local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
        if targetPlayer and targetPlayer.Character then
            local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
            end
        end
    end
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
            Library:CreateNotification("Sucesso", "Lista atualizada: " .. #players .. " jogadores", "OK")
        else
            Library:CreateNotification("Info", "Nenhum outro jogador na partida", "OK")
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
        Library:CreateNotification("Configuração", "Auto-atualização: " .. (state and "LIGADA" or "DESLIGADA"), "OK")
    end
):Set(AutoRefresh)

-- Adicionar botão para ver jogadores atuais
SettingsSection:NewButton(
    "Ver Jogadores Atuais", 
    "Mostra todos os jogadores na partida", 
    function()
        local playerList = ""
        for _, player in pairs(Players:GetPlayers()) do
            playerList = playerList .. player.Name .. "\n"
        end
        Library:CreateNotification("Jogadores na Partida", playerList, "OK")
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
        task.wait(1)
        UpdatePlayerList()
        Library:CreateNotification("Novo Jogador", player.Name .. " entrou na partida", "OK")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if AutoRefresh then
        task.wait(1)
        UpdatePlayerList()
        if AntiScripter.SelectedPlayer == player.Name then
            AntiScripter.SelectedPlayer = nil
            StopVoidLoop()
            PunishButton:UpdateText("Punir Jogador Selecionado")
        end
    end
end)

-- Inicialização
task.wait(1) -- Aguardar um pouco para garantir que todos os jogadores carregaram
UpdatePlayerList()
Library:CreateNotification("Sistema Anti-Scripter", 
    "Sistema carregado com sucesso!\n" ..
    "Jogadores na partida: " .. #Players:GetPlayers() .. "\n" ..
    "Selecione um jogador para punir.", 
    "OK"
)

-- Limpeza ao fechar
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        StopVoidLoop()
        Window:Destroy()
        Library:DestroyNotification()
        print("Sistema Anti-Scripter fechado!")
    end
end)

print("=== Anti-Scripter System ===")
print("Carregado com sucesso!")
print("Jogadores na partida: " .. #Players:GetPlayers())
print("Pressione Delete para fechar o menu")
print("=============================")
