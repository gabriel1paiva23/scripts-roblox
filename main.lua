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
local PlayerDropdown = MainSection:NewDropdown(
    "Selecionar Jogador", 
    "Escolha o scripter problemático", 
    {}, 
    function(selected)
        AntiScripter.SelectedPlayer = selected
    end
)

-- Atualizar lista de jogadores
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:Refresh(playerNames, true)
end

-- Botão de punição
local PunishButton = MainSection:NewButton(
    "Punir Jogador Selecionado", 
    "Envia o scripter para o void em loop", 
    function()
        if AntiScripter.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(AntiScripter.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                AntiScripter.IsPunishing = not AntiScripter.IsPunishing
                
                if AntiScripter.IsPunishing then
                    PunishButton:UpdateText("Parar Punição")
                    StartVoidLoop(targetPlayer)
                else
                    PunishButton:UpdateText("Punir Jogador Selecionado")
                    StopVoidLoop()
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
local TargetLabel = MonitorSection:NewSection("Alvo: Nenhum")

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
        end
    end
end

-- Loop do void
function StartVoidLoop(targetPlayer)
    AntiScripter.VoidLoop = RunService.Heartbeat:Connect(function()
        if targetPlayer and targetPlayer.Character then
            SendToVoid(targetPlayer)
            StatusLabel:UpdateLabel("Status: Punindo " .. targetPlayer.Name)
            TargetLabel:UpdateSection("Alvo: " .. targetPlayer.Name)
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
    TargetLabel:UpdateSection("Alvo: Nenhum")
end

-- Página de configurações
local SettingsTab = Window:NewTab("Configurações")
local SettingsSection = SettingsTab:NewSection("Opções do Sistema")

-- Botão para atualizar lista
SettingsSection:NewButton(
    "Atualizar Lista de Jogadores", 
    "Recarrega a lista de jogadores online", 
    function()
        UpdatePlayerList()
        Library:CreateNotification("Sucesso", "Lista de jogadores atualizada", "OK")
    end
)

-- Toggle para auto-atualização
local AutoRefresh = true
SettingsSection:NewToggle(
    "Auto-atualizar Lista", 
    "Atualiza automaticamente a lista de jogadores", 
    function(state)
        AutoRefresh = state
    end
)

-- Atualização automática da lista de jogadores
spawn(function()
    while true do
        if AutoRefresh then
            UpdatePlayerList()
        end
        wait(5)
    end
end)

-- Eventos para novos jogadores
Players.PlayerAdded:Connect(function()
    if AutoRefresh then
        wait(1)
        UpdatePlayerList()
    end
end)

Players.PlayerRemoving:Connect(function()
    if AutoRefresh then
        wait(1)
        UpdatePlayerList()
    end
end)

-- Inicialização
UpdatePlayerList()
Library:CreateNotification("Sistema Anti-Scripter", "Sistema carregado com sucesso!\nSelecione um jogador para punir.", "OK")

-- Limpeza ao fechar
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        StopVoidLoop()
        Library:Destroy()
    end
end)

print("Anti-Scripter System carregado! Pressione Delete para fechar.")
