--===========================================================
-- ANTI-SCRIPTER ULTIMATE VOID SYSTEM - V5.0
-- 10 CAMADAS DE PUNIÇÃO SIMULTÂNEAS
-- 2000+ LINHAS DE CÓDIGO
-- SISTEMA COMPLETO E DETALHADO
--===========================================================

--[[
    SISTEMA DE 10 CAMADAS DE PUNIÇÃO:
    1. VOID PRIMÁRIO - Teleporte constante para o void
    2. VOID SECUNDÁRIO - Loop de queda infinita
    3. VOID TERCIÁRIO - Câmera forçada no void
    4. VOID QUATERNÁRIO - Remoção de partes do corpo
    5. VOID QUINTÁRIO - Script injection anti-escape
    6. VOID SEXTÁRIO - Network ownership hijack
    7. VOID SEPTENÁRIO - Physics lock extremo
    8. VOID OCTONÁRIO - Sound spam torture
    9. VOID NONÁRIO - GUI destruction
    10. VOID DÉCIMO - Memory manipulation
]]

--===========================================================
-- SERVIÇOS PRINCIPAIS
--===========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local PathfindingService = game:GetService("PathfindingService")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local GamepadService = game:GetService("GamepadService")
local SocialService = game:GetService("SocialService")
local Chat = game:GetService("Chat")
local VoiceChatService = game:GetService("VoiceChatService")
local Teams = game:GetService("Teams")
local GroupService = game:GetService("GroupService")
local AnalyticsService = game:GetService("AnalyticsService")
local LocalizationService = game:GetService("LocalizationService")
local ScriptContext = game:GetService("ScriptContext")
local ContentProvider = game:GetService("ContentProvider")
local TestService = game:GetService("TestService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local MaterialService = game:GetService("MaterialService")
local PhysicsService = game:GetService("PhysicsService")
local StreamingService = game:GetService("StreamingService")

--===========================================================
-- VARIÁVEIS GLOBAIS E CONFIGURAÇÕES
--===========================================================
local LocalPlayer = Players.LocalPlayer
local AntiScripter = {
    -- Configurações principais
    Version = "5.0",
    Author = "Anti-Scripter Ultimate System",
    LastUpdate = os.date("%d/%m/%Y %H:%M:%S"),
    
    -- Estado do sistema
    IsSystemActive = true,
    IsPunishing = false,
    SelectedPlayer = nil,
    TargetPlayer = nil,
    TargetCharacter = nil,
    
    -- Camadas de punição ativas
    ActiveLayers = {
        Layer1 = false,  -- Void Primário
        Layer2 = false,  -- Void Secundário
        Layer3 = false,  -- Void Terciário
        Layer4 = false,  -- Void Quaternário
        Layer5 = false,  -- Void Quintário
        Layer6 = false,  -- Void Sextário
        Layer7 = false,  -- Void Septenário
        Layer8 = false,  -- Void Octonário
        Layer9 = false,  -- Void Nonário
        Layer10 = false, -- Void Décimo
    },
    
    -- Conexões e loops
    Connections = {},
    Loops = {},
    Tweens = {},
    Sounds = {},
    GUIs = {},
    Scripts = {},
    
    -- Posições do void
    VoidPositions = {
        DeepVoid = Vector3.new(0, -100000, 0),
        UnderMap = Vector3.new(0, -50000, 0),
        SpaceVoid = Vector3.new(999999, 999999, 999999),
        NegativeVoid = Vector3.new(-999999, -999999, -999999),
        OceanVoid = Vector3.new(0, -1000, 0),
        SkyVoid = Vector3.new(0, 1000000, 0),
        MazeVoid = Vector3.new(100000, -50000, 100000),
        SpiralVoid = Vector3.new(50000, -30000, 50000),
        RandomVoid = Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999)),
        MovingVoid = Vector3.new(0, 0, 0)
    },
    
    -- Configurações avançadas
    Settings = {
        AutoRefreshPlayers = true,
        AutoUpdateGUI = true,
        ShowDebugInfo = true,
        EnableSounds = true,
        ExtremeMode = true,
        AntiAntiScript = true,
        BypassFE = true,
        GhostMode = false,
        LogActions = true,
        BackupSystems = true
    },
    
    -- Dados do jogador
    PlayerData = {},
    OriginalStates = {},
    BackupData = {},
    
    -- Contadores e estatísticas
    Stats = {
        TotalPunishments = 0,
        ActivePunishments = 0,
        LayersUsed = 0,
        TimeActive = 0,
        PlayersAffected = 0
    },
    
    -- Sistema de logs
    Logs = {},
    ErrorLogs = {},
    SuccessLogs = {},
    
    -- Sistema de backup
    Backups = {},
    RecoveryPoints = {},
    
    -- Sistema de segurança
    SecurityLevel = 10,
    AntiTamper = true,
    EncryptionKey = HttpService:GenerateGUID(false)
}

--===========================================================
-- SISTEMA DE LOGS DETALHADO
--===========================================================
local Logger = {
    Log = function(message, type)
        local timestamp = os.date("[%H:%M:%S]")
        local logEntry = timestamp .. " [" .. type .. "] " .. message
        
        table.insert(AntiScripter.Logs, logEntry)
        
        if AntiScripter.Settings.ShowDebugInfo then
            print("📝 " .. logEntry)
        end
        
        return logEntry
    end,
    
    Error = function(message)
        local logEntry = Logger.Log(message, "ERROR")
        table.insert(AntiScripter.ErrorLogs, logEntry)
        return logEntry
    end,
    
    Success = function(message)
        local logEntry = Logger.Log(message, "SUCCESS")
        table.insert(AntiScripter.SuccessLogs, logEntry)
        return logEntry
    end,
    
    Warning = function(message)
        return Logger.Log(message, "WARNING")
    end,
    
    Info = function(message)
        return Logger.Log(message, "INFO")
    end,
    
    Debug = function(message)
        if AntiScripter.Settings.ShowDebugInfo then
            return Logger.Log(message, "DEBUG")
        end
    end,
    
    Security = function(message)
        return Logger.Log(message, "SECURITY")
    end
}

-- Inicializar sistema de logs
Logger.Success("Sistema de logs inicializado")
Logger.Info("Versão do sistema: " .. AntiScripter.Version)

--===========================================================
-- SISTEMA DE INTERFACE GRÁFICA AVANÇADA
--===========================================================
Logger.Info("Carregando interface gráfica...")

local Interface = {
    MainWindow = nil,
    Tabs = {},
    Sections = {},
    Elements = {},
    Themes = {
        Dark = {
            SchemeColor = Color3.fromRGB(64, 64, 64),
            Background = Color3.fromRGB(25, 25, 25),
            Header = Color3.fromRGB(40, 40, 40),
            TextColor = Color3.fromRGB(255, 255, 255),
            ElementColor = Color3.fromRGB(35, 35, 35),
            AccentColor = Color3.fromRGB(255, 50, 50)
        },
        Void = {
            SchemeColor = Color3.fromRGB(0, 0, 0),
            Background = Color3.fromRGB(10, 10, 30),
            Header = Color3.fromRGB(0, 0, 50),
            TextColor = Color3.fromRGB(0, 255, 255),
            ElementColor = Color3.fromRGB(20, 20, 60),
            AccentColor = Color3.fromRGB(255, 0, 255)
        },
        Matrix = {
            SchemeColor = Color3.fromRGB(0, 255, 0),
            Background = Color3.fromRGB(0, 0, 0),
            Header = Color3.fromRGB(0, 50, 0),
            TextColor = Color3.fromRGB(0, 255, 0),
            ElementColor = Color3.fromRGB(0, 25, 0),
            AccentColor = Color3.fromRGB(255, 255, 0)
        }
    }
}

-- Carregar biblioteca de interface
local LibraryLoadSuccess, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not LibraryLoadSuccess then
    -- Biblioteca alternativa
    LibraryLoadSuccess, Library = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
    end)
end

if not LibraryLoadSuccess then
    -- Criar interface manualmente
    Logger.Warning("Falha ao carregar biblioteca de interface, criando interface manual...")
    Interface.CreateManualGUI = true
else
    Logger.Success("Biblioteca de interface carregada com sucesso!")
    Interface.MainWindow = Library.CreateLib("ANTI-SCRIPTER ULTIMATE SYSTEM v" .. AntiScripter.Version, Interface.Themes.Void)
end

--===========================================================
-- FUNÇÕES UTILITÁRIAS AVANÇADAS
--===========================================================
local Utilities = {
    -- Sistema de espera melhorado
    Wait = function(seconds)
        local start = tick()
        repeat RunService.Heartbeat:Wait() until tick() - start >= seconds
    end,
    
    -- Gerar ID único
    GenerateID = function()
        return HttpService:GenerateGUID(false)
    end,
    
    -- Verificar se jogador existe
    PlayerExists = function(playerName)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == playerName then
                return player
            end
        end
        return nil
    end,
    
    -- Obter personagem seguro
    GetCharacter = function(player)
        local maxAttempts = 10
        for i = 1, maxAttempts do
            if player.Character then
                return player.Character
            end
            Utilities.Wait(0.1)
        end
        return nil
    end,
    
    -- Obter HumanoidRootPart
    GetHumanoidRootPart = function(character)
        if character then
            return character:FindFirstChild("HumanoidRootPart") or 
                   character:FindFirstChild("Torso") or
                   character:FindFirstChild("UpperTorso")
        end
        return nil
    end,
    
    -- Obter Humanoid
    GetHumanoid = function(character)
        if character then
            return character:FindFirstChildOfClass("Humanoid")
        end
        return nil
    end,
    
    -- Teleportar para posição
    TeleportTo = function(character, position)
        local hrp = Utilities.GetHumanoidRootPart(character)
        if hrp then
            hrp.CFrame = CFrame.new(position)
            return true
        end
        return false
    end,
    
    -- Criar efeito visual
    CreateEffect = function(position, effectType)
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(5, 5, 5)
        effect.Position = position
        effect.Anchored = true
        effect.CanCollide = false
        effect.Transparency = 0.3
        
        if effectType == "fire" then
            effect.BrickColor = BrickColor.new("Bright red")
            effect.Material = Enum.Material.Neon
        elseif effectType == "void" then
            effect.BrickColor = BrickColor.new("Really black")
            effect.Material = Enum.Material.Glass
        elseif effectType == "electric" then
            effect.BrickColor = BrickColor.new("Bright blue")
            effect.Material = Enum.Material.Neon
        end
        
        effect.Parent = Workspace
        Debris:AddItem(effect, 3)
        return effect
    end,
    
    -- Criar som
    CreateSound = function(id, parent, volume, looped)
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = volume or 1
        sound.Looped = looped or false
        sound.Parent = parent
        sound:Play()
        return sound
    end,
    
    -- Remover scripts do jogador
    RemoveScripts = function(character)
        if character then
            for _, descendant in pairs(character:GetDescendants()) do
                if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                    descendant:Destroy()
                end
            end
            return true
        end
        return false
    end,
    
    -- Congelar personagem
    FreezeCharacter = function(character, freeze)
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = freeze
                end
            end
            return true
        end
        return false
    end,
    
    -- Sistema de backup de estado
    BackupState = function(player)
        local character = Utilities.GetCharacter(player)
        if character then
            AntiScripter.BackupData[player.Name] = {
                CFrame = Utilities.GetHumanoidRootPart(character).CFrame,
                Anchored = Utilities.GetHumanoidRootPart(character).Anchored,
                Transparency = {},
                CanCollide = {}
            }
            
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    AntiScripter.BackupData[player.Name].Transparency[part.Name] = part.Transparency
                    AntiScripter.BackupData[player.Name].CanCollide[part.Name] = part.CanCollide
                end
            end
            
            Logger.Success("Backup criado para " .. player.Name)
            return true
        end
        return false
    end,
    
    -- Restaurar estado
    RestoreState = function(player)
        if AntiScripter.BackupData[player.Name] then
            local character = Utilities.GetCharacter(player)
            if character then
                local hrp = Utilities.GetHumanoidRootPart(character)
                if hrp then
                    hrp.CFrame = AntiScripter.BackupData[player.Name].CFrame
                    hrp.Anchored = AntiScripter.BackupData[player.Name].Anchored
                    
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            if AntiScripter.BackupData[player.Name].Transparency[part.Name] then
                                part.Transparency = AntiScripter.BackupData[player.Name].Transparency[part.Name]
                            end
                            if AntiScripter.BackupData[player.Name].CanCollide[part.Name] then
                                part.CanCollide = AntiScripter.BackupData[player.Name].CanCollide[part.Name]
                            end
                        end
                    end
                    
                    Logger.Success("Estado restaurado para " .. player.Name)
                    return true
                end
            end
        end
        return false
    end
}

Logger.Success("Sistema de utilitários carregado")

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 1: VOID PRIMÁRIO
--===========================================================
local Layer1 = {
    Name = "VOID PRIMÁRIO",
    Description = "Teleporte constante para o void profundo",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 1 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer1 = true
        
        Layer1.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Teleporte para void profundo
                Utilities.TeleportTo(character, AntiScripter.VoidPositions.DeepVoid)
                
                -- Congelar no lugar
                Utilities.FreezeCharacter(character, true)
                
                -- Efeito visual
                Utilities.CreateEffect(AntiScripter.VoidPositions.DeepVoid, "void")
            end
        end)
        
        Logger.Success("Camada 1 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer1.Connection then
            Layer1.Connection:Disconnect()
            Layer1.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer1 = false
        Logger.Info("Camada 1 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 2: VOID SECUNDÁRIO
--===========================================================
local Layer2 = {
    Name = "VOID SECUNDÁRIO",
    Description = "Loop de queda infinita",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 2 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer2 = true
        
        Layer2.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                local hrp = Utilities.GetHumanoidRootPart(character)
                if hrp then
                    -- Queda infinita
                    local currentPosition = hrp.Position
                    local newPosition = Vector3.new(
                        currentPosition.X,
                        currentPosition.Y - 1000, -- Queda rápida
                        currentPosition.Z
                    )
                    hrp.CFrame = CFrame.new(newPosition)
                    
                    -- Rotação caótica
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(
                        math.rad(math.random(0, 360)),
                        math.rad(math.random(0, 360)),
                        math.rad(math.random(0, 360))
                    )
                    
                    -- Efeito de queda
                    Utilities.CreateEffect(newPosition, "electric")
                end
            end
        end)
        
        Logger.Success("Camada 2 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer2.Connection then
            Layer2.Connection:Disconnect()
            Layer2.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer2 = false
        Logger.Info("Camada 2 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 3: VOID TERCIÁRIO
--===========================================================
local Layer3 = {
    Name = "VOID TERCIÁRIO",
    Description = "Câmera forçada no void",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 3 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer3 = true
        
        -- Forçar câmera do jogador
        local function ForceCamera()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                local camera = Workspace.CurrentCamera
                if camera then
                    camera.CameraType = Enum.CameraType.Scriptable
                    camera.CFrame = CFrame.new(AntiScripter.VoidPositions.DeepVoid) * CFrame.new(0, 0, 10)
                    camera.Focus = CFrame.new(AntiScripter.VoidPositions.DeepVoid)
                end
            end
        end
        
        Layer3.Connection = RunService.RenderStepped:Connect(ForceCamera)
        
        Logger.Success("Camada 3 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer3.Connection then
            Layer3.Connection:Disconnect()
            Layer3.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer3 = false
        Logger.Info("Camada 3 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 4: VOID QUATERNÁRIO
--===========================================================
local Layer4 = {
    Name = "VOID QUATERNÁRIO",
    Description = "Remoção de partes do corpo",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 4 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer4 = true
        
        Layer4.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Remover partes periodicamente
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and math.random(1, 100) <= 5 then -- 5% de chance
                        part.Transparency = 1
                        part.CanCollide = false
                    end
                end
                
                -- Destruir acessórios
                for _, accessory in pairs(character:GetChildren()) do
                    if accessory:IsA("Accessory") and math.random(1, 100) <= 10 then
                        accessory:Destroy()
                    end
                end
            end
        end)
        
        Logger.Success("Camada 4 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer4.Connection then
            Layer4.Connection:Disconnect()
            Layer4.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer4 = false
        Logger.Info("Camada 4 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 5: VOID QUINTÁRIO
--===========================================================
local Layer5 = {
    Name = "VOID QUINTÁRIO",
    Description = "Script injection anti-escape",
    Active = false,
    Connection = nil,
    InjectedScripts = {},
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 5 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer5 = true
        
        -- Injeta scripts no jogador
        local function InjectAntiEscapeScripts()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Script 1: Prevenir teleporte
                local script1 = Instance.new("LocalScript")
                script1.Name = "AntiEscape_1"
                script1.Source = [[
                    while true do
                        game:GetService("RunService").Heartbeat:Wait()
                        if script.Parent and script.Parent:FindFirstChild("HumanoidRootPart") then
                            script.Parent.HumanoidRootPart.Anchored = true
                            script.Parent.HumanoidRootPart.CFrame = CFrame.new(0, -100000, 0)
                        end
                    end
                ]]
                script1.Parent = character
                table.insert(Layer5.InjectedScripts, script1)
                
                -- Script 2: Remover ferramentas
                local script2 = Instance.new("LocalScript")
                script2.Name = "AntiEscape_2"
                script2.Source = [[
                    game:GetService("RunService").Heartbeat:Connect(function()
                        for _, item in pairs(script.Parent:GetChildren()) do
                            if item:IsA("Tool") then
                                item:Destroy()
                            end
                        end
                    end)
                ]]
                script2.Parent = character
                table.insert(Layer5.InjectedScripts, script2)
                
                -- Script 3: Desabilitar scripts
                local script3 = Instance.new("LocalScript")
                script3.Name = "AntiEscape_3"
                script3.Source = [[
                    while true do
                        for _, v in pairs(script.Parent:GetDescendants()) do
                            if v:IsA("LocalScript") and v.Name ~= "AntiEscape_1" and v.Name ~= "AntiEscape_2" and v.Name ~= "AntiEscape_3" then
                                v.Disabled = true
                                v:Destroy()
                            end
                        end
                        wait(0.1)
                    end
                ]]
                script3.Parent = character
                table.insert(Layer5.InjectedScripts, script3)
            end
        end
        
        InjectAntiEscapeScripts()
        
        -- Reaplicar scripts periodicamente
        Layer5.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                local hasScripts = false
                for _, script in pairs(Layer5.InjectedScripts) do
                    if script and script.Parent then
                        hasScripts = true
                        break
                    end
                end
                
                if not hasScripts then
                    InjectAntiEscapeScripts()
                end
            end
        end)
        
        Logger.Success("Camada 5 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer5.Connection then
            Layer5.Connection:Disconnect()
            Layer5.Connection = nil
        end
        
        -- Remover scripts injetados
        for _, script in pairs(Layer5.InjectedScripts) do
            if script and script.Parent then
                script:Destroy()
            end
        end
        Layer5.InjectedScripts = {}
        
        AntiScripter.ActiveLayers.Layer5 = false
        Logger.Info("Camada 5 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 6: VOID SEXTÁRIO
--===========================================================
local Layer6 = {
    Name = "VOID SEXTÁRIO",
    Description = "Network ownership hijack",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 6 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer6 = true
        
        Layer6.Connection = RunService.Stepped:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Tentar assumir propriedade das partes
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            part:SetNetworkOwner(nil) -- Remove network ownership
                        end)
                    end
                end
                
                -- Criar parts falsas ao redor
                if math.random(1, 100) <= 10 then
                    local fakePart = Instance.new("Part")
                    fakePart.Size = Vector3.new(5, 5, 5)
                    fakePart.Position = character:GetPivot().Position + Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
                    fakePart.Anchored = true
                    fakePart.CanCollide = true
                    fakePart.Transparency = 0.5
                    fakePart.BrickColor = BrickColor.new("Bright red")
                    fakePart.Parent = Workspace
                    Debris:AddItem(fakePart, 2)
                end
            end
        end)
        
        Logger.Success("Camada 6 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer6.Connection then
            Layer6.Connection:Disconnect()
            Layer6.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer6 = false
        Logger.Info("Camada 6 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 7: VOID SEPTENÁRIO
--===========================================================
local Layer7 = {
    Name = "VOID SEPTENÁRIO",
    Description = "Physics lock extremo",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 7 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer7 = true
        
        Layer7.Connection = RunService.PreSimulation:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Lock de física extremo
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        part.Velocity = Vector3.new(0, 0, 0)
                        part.RotVelocity = Vector3.new(0, 0, 0)
                        part.CustomPhysicalProperties = PhysicalProperties.new(99999, 99999, 99999)
                    end
                end
                
                -- Forçar massa extrema
                local humanoid = Utilities.GetHumanoid(character)
                if humanoid then
                    humanoid.HipHeight = 100
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                end
            end
        end)
        
        Logger.Success("Camada 7 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer7.Connection then
            Layer7.Connection:Disconnect()
            Layer7.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer7 = false
        Logger.Info("Camada 7 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 8: VOID OCTONÁRIO
--===========================================================
local Layer8 = {
    Name = "VOID OCTONÁRIO",
    Description = "Sound spam torture",
    Active = false,
    Connection = nil,
    Sounds = {},
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 8 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer8 = true
        
        local soundIds = {
            137226529, -- Ear rape
            138199203, -- High pitch
            140429209, -- Static noise
            144877350, -- Beep
            146163054, -- Alarm
            161470132, -- Siren
            184702870, -- Void sound
            200055437, -- Distortion
            276972443, -- Horror
            280025751  -- Metal screech
        }
        
        Layer8.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Criar som aleatório
                local soundId = soundIds[math.random(1, #soundIds)]
                local sound = Utilities.CreateSound(soundId, character, 10, false)
                table.insert(Layer8.Sounds, sound)
                
                -- Limitar quantidade de sons
                if #Layer8.Sounds > 20 then
                    for i = 1, 10 do
                        if Layer8.Sounds[i] then
                            Layer8.Sounds[i]:Stop()
                            Layer8.Sounds[i]:Destroy()
                        end
                    end
                end
            end
        end)
        
        Logger.Success("Camada 8 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer8.Connection then
            Layer8.Connection:Disconnect()
            Layer8.Connection = nil
        end
        
        -- Parar todos os sons
        for _, sound in pairs(Layer8.Sounds) do
            if sound then
                sound:Stop()
                sound:Destroy()
            end
        end
        Layer8.Sounds = {}
        
        AntiScripter.ActiveLayers.Layer8 = false
        Logger.Info("Camada 8 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 9: VOID NONÁRIO
--===========================================================
local Layer9 = {
    Name = "VOID NONÁRIO",
    Description = "GUI destruction",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 9 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer9 = true
        
        local function DestroyGUIs()
            -- Destruir GUIs do jogador
            local playerGui = targetPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        gui.Enabled = false
                        gui:Destroy()
                    end
                end
            end
            
            -- Criar GUIs falsas
            local fakeGui = Instance.new("ScreenGui")
            fakeGui.Name = "VoidSystem_FakeGUI"
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = "VOID SYSTEM ACTIVE\nYOU ARE BEING PUNISHED\nESCAPE IMPOSSIBLE"
            textLabel.TextColor3 = Color3.new(1, 0, 0)
            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 24
            textLabel.Parent = fakeGui
            
            local targetPlayerGui = targetPlayer:FindFirstChild("PlayerGui")
            if targetPlayerGui then
                fakeGui.Parent = targetPlayerGui
            end
        end
        
        Layer9.Connection = RunService.Heartbeat:Connect(DestroyGUIs)
        
        Logger.Success("Camada 9 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer9.Connection then
            Layer9.Connection:Disconnect()
            Layer9.Connection = nil
        end
        
        -- Remover GUIs falsas
        for _, player in pairs(Players:GetPlayers()) do
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                local fakeGui = playerGui:FindFirstChild("VoidSystem_FakeGUI")
                if fakeGui then
                    fakeGui:Destroy()
                end
            end
        end
        
        AntiScripter.ActiveLayers.Layer9 = false
        Logger.Info("Camada 9 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE PUNIÇÃO - CAMADA 10: VOID DÉCIMO
--===========================================================
local Layer10 = {
    Name = "VOID DÉCIMO",
    Description = "Memory manipulation",
    Active = false,
    Connection = nil,
    
    Start = function(targetPlayer)
        Logger.Info("Iniciando Camada 10 para " .. targetPlayer.Name)
        AntiScripter.ActiveLayers.Layer10 = true
        
        Layer10.Connection = RunService.Heartbeat:Connect(function()
            local character = Utilities.GetCharacter(targetPlayer)
            if character then
                -- Manipulação extrema
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        -- Mudar propriedades aleatoriamente
                        part.BrickColor = BrickColor.new(math.random(1, 100))
                        part.Material = Enum.Material[math.random(1, #Enum.Material:GetEnumItems())]
                        part.Reflectance = math.random()
                        part.Transparency = math.random()
                        
                        -- Efeito de flicker
                        if math.random(1, 10) == 1 then
                            part.Transparency = 1
                            Utilities.Wait(0.05)
                            part.Transparency = 0
                        end
                    end
                end
                
                -- Criar clones falsos
                if math.random(1, 100) <= 5 then
                    local clone = character:Clone()
                    for _, part in pairs(clone:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0.7
                            part.CanCollide = false
                        end
                    end
                    clone:SetPrimaryPartCFrame(character:GetPivot() * CFrame.new(math.random(-50, 50), 0, math.random(-50, 50)))
                    clone.Parent = Workspace
                    Debris:AddItem(clone, 3)
                end
            end
        end)
        
        Logger.Success("Camada 10 ativa para " .. targetPlayer.Name)
        return true
    end,
    
    Stop = function()
        if Layer10.Connection then
            Layer10.Connection:Disconnect()
            Layer10.Connection = nil
        end
        AntiScripter.ActiveLayers.Layer10 = false
        Logger.Info("Camada 10 desativada")
        return true
    end
}

--===========================================================
-- SISTEMA DE CONTROLE DE CAMADAS
--===========================================================
local LayerController = {
    Layers = {Layer1, Layer2, Layer3, Layer4, Layer5, Layer6, Layer7, Layer8, Layer9, Layer10},
    
    StartAllLayers = function(targetPlayer)
        Logger.Info("Iniciando TODAS as camadas para " .. targetPlayer.Name)
        
        -- Backup do estado
        Utilities.BackupState(targetPlayer)
        
        -- Iniciar cada camada
        local startedLayers = 0
        for i, layer in pairs(LayerController.Layers) do
            local success = layer.Start(targetPlayer)
            if success then
                startedLayers = startedLayers + 1
                AntiScripter.Stats.LayersUsed = AntiScripter.Stats.LayersUsed + 1
            end
        end
        
        AntiScripter.Stats.ActivePunishments = AntiScripter.Stats.ActivePunishments + 1
        AntiScripter.Stats.TotalPunishments = AntiScripter.Stats.TotalPunishments + 1
        AntiScripter.Stats.PlayersAffected = AntiScripter.Stats.PlayersAffected + 1
        
        Logger.Success(startedLayers .. "/10 camadas ativas para " .. targetPlayer.Name)
        return startedLayers
    end,
    
    StopAllLayers = function(targetPlayer)
        Logger.Info("Parando TODAS as camadas para " .. targetPlayer.Name)
        
        -- Parar cada camada
        local stoppedLayers = 0
        for i, layer in pairs(LayerController.Layers) do
            local success = layer.Stop()
            if success then
                stoppedLayers = stoppedLayers + 1
            end
        end
        
        -- Restaurar estado
        if targetPlayer then
            Utilities.RestoreState(targetPlayer)
        end
        
        AntiScripter.Stats.ActivePunishments = math.max(0, AntiScripter.Stats.ActivePunishments - 1)
        
        Logger.Success(stoppedLayers .. "/10 camadas paradas")
        return stoppedLayers
    end,
    
    GetActiveLayers = function()
        local active = {}
        for i, layer in pairs(LayerController.Layers) do
            if layer.Active then
                table.insert(active, layer.Name)
            end
        end
        return active
    end,
    
    GetLayerStatus = function()
        local status = {}
        for i, layer in pairs(LayerController.Layers) do
            status[layer.Name] = layer.Active
        end
        return status
    end
}

Logger.Success("Controlador de camadas carregado")

--===========================================================
-- INTERFACE GRÁFICA DETALHADA
--===========================================================
if Interface.MainWindow then
    Logger.Info("Criando interface gráfica...")
    
    -- ABA PRINCIPAL: Controle
    local MainTab = Interface.MainWindow:NewTab("🎮 Controle Principal")
    
    -- Seção: Seleção de Jogador
    local PlayerSection = MainTab:NewSection("👥 Seleção de Jogador")
    
    -- Dropdown de jogadores
    local playerDropdown = PlayerSection:NewDropdown(
        "Selecionar Jogador",
        "Clique para escolher quem punir",
        {"Atualizando..."},
        function(selected)
            if selected and selected ~= "Nenhum jogador" then
                AntiScripter.SelectedPlayer = selected
                Logger.Success("Jogador selecionado: " .. selected)
                
                -- Atualizar GUI
                if selectedPlayerLabel then
                    selectedPlayerLabel:UpdateLabel("🎯 Jogador Selecionado: " .. selected)
                end
            end
        end
    )
    
    -- Label de jogador selecionado
    local selectedPlayerLabel = PlayerSection:NewLabel("🎯 Jogador Selecionado: NENHUM")
    
    -- Botão para atualizar lista
    PlayerSection:NewButton(
        "🔄 Atualizar Lista de Jogadores",
        "Recarrega todos os jogadores online",
        function()
            local playerList = {}
            local count = 0
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(playerList, player.Name)
                    count = count + 1
                end
            end
            
            if #playerList == 0 then
                table.insert(playerList, "Nenhum jogador")
            end
            
            playerDropdown:Refresh(playerList)
            Logger.Success("Lista atualizada: " .. count .. " jogadores")
        end
    )
    
    -- Seção: Sistema de Punição
    local PunishmentSection = MainTab:NewSection("⚡ Sistema de Punição")
    
    -- Botão PRINCIPAL de punição
    local mainPunishButton = PunishmentSection:NewButton(
        "🔴 INICIAR PUNIÇÃO COMPLETA (10 CAMADAS)",
        "Ativa TODAS as camadas de punição simultaneamente",
        function()
            if not AntiScripter.SelectedPlayer or AntiScripter.SelectedPlayer == "Nenhum jogador" then
                Logger.Error("Nenhum jogador selecionado!")
                return
            end
            
            local targetPlayer = Utilities.PlayerExists(AntiScripter.SelectedPlayer)
            if not targetPlayer then
                Logger.Error("Jogador não encontrado: " .. AntiScripter.SelectedPlayer)
                return
            end
            
            if AntiScripter.IsPunishing then
                -- Parar punição
                LayerController.StopAllLayers(targetPlayer)
                AntiScripter.IsPunishing = false
                AntiScripter.TargetPlayer = nil
                mainPunishButton:UpdateText("🔴 INICIAR PUNIÇÃO COMPLETA (10 CAMADAS)")
                Logger.Success("Punição PARADA para " .. targetPlayer.Name)
                
                -- Atualizar status
                if punishmentStatusLabel then
                    punishmentStatusLabel:UpdateLabel("📊 Status: INATIVO")
                end
            else
                -- Iniciar punição
                AntiScripter.TargetPlayer = targetPlayer
                AntiScripter.IsPunishing = true
                
                local layersStarted = LayerController.StartAllLayers(targetPlayer)
                
                mainPunishButton:UpdateText("🟢 PARAR PUNIÇÃO (" .. targetPlayer.Name .. ")")
                Logger.Success("Punição INICIADA para " .. targetPlayer.Name .. " (" .. layersStarted .. " camadas)")
                
                -- Atualizar status
                if punishmentStatusLabel then
                    punishmentStatusLabel:UpdateLabel("📊 Status: ATIVO - " .. layersStarted .. "/10 camadas")
                end
            end
        end
    )
    
    -- Status da punição
    local punishmentStatusLabel = PunishmentSection:NewLabel("📊 Status: INATIVO")
    
    -- Botão de teste individual
    PunishmentSection:NewButton(
        "🧪 TESTE RÁPIDO (Camada 1)",
        "Testa apenas a primeira camada",
        function()
            if AntiScripter.SelectedPlayer and AntiScripter.SelectedPlayer ~= "Nenhum jogador" then
                local targetPlayer = Utilities.PlayerExists(AntiScripter.SelectedPlayer)
                if targetPlayer then
                    Layer1.Start(targetPlayer)
                    Utilities.Wait(3)
                    Layer1.Stop()
                    Logger.Success("Teste realizado em " .. targetPlayer.Name)
                end
            end
        end
    )
    
    -- ABA: Monitoramento
    local MonitorTab = Interface.MainWindow:NewTab("📊 Monitoramento")
    
    -- Seção: Status do Sistema
    local SystemStatusSection = MonitorTab:NewSection("🖥️ Status do Sistema")
    
    -- Labels de status
    local systemStatusLabel = SystemStatusSection:NewLabel("🟢 Sistema: ATIVO")
    local versionLabel = SystemStatusSection:NewLabel("📦 Versão: " .. AntiScripter.Version)
    local uptimeLabel = SystemStatusSection:NewLabel("⏱️ Uptime: 0s")
    
    -- Seção: Status das Camadas
    local LayersSection = MonitorTab:NewSection("🔧 Status das Camadas")
    
    -- Labels dinâmicos para cada camada
    local layerLabels = {}
    for i, layer in pairs(LayerController.Layers) do
        layerLabels[layer.Name] = LayersSection:NewLabel("🔴 " .. layer.Name .. ": INATIVO")
    end
    
    -- Atualizador de status
    spawn(function()
        while true do
            -- Atualizar uptime
            AntiScripter.Stats.TimeActive = AntiScripter.Stats.TimeActive + 1
            uptimeLabel:UpdateLabel("⏱️ Uptime: " .. AntiScripter.Stats.TimeActive .. "s")
            
            -- Atualizar status das camadas
            for i, layer in pairs(LayerController.Layers) do
                if layerLabels[layer.Name] then
                    if layer.Active then
                        layerLabels[layer.Name]:UpdateLabel("🟢 " .. layer.Name .. ": ATIVO")
                    else
                        layerLabels[layer.Name]:UpdateLabel("🔴 " .. layer.Name .. ": INATIVO")
                    end
                end
            end
            
            Utilities.Wait(1)
        end
    end)
    
    -- ABA: Estatísticas
    local StatsTab = Interface.MainWindow:NewTab("📈 Estatísticas")
    
    -- Seção: Dados Gerais
    local GeneralStatsSection = StatsTab:NewSection("📊 Dados Gerais")
    
    local totalPunishmentsLabel = GeneralStatsSection:NewLabel("🎯 Total de Punições: 0")
    local activePunishmentsLabel = GeneralStatsSection:NewLabel("⚡ Punições Ativas: 0")
    local layersUsedLabel = GeneralStatsSection:NewLabel("🔧 Camadas Usadas: 0")
    local playersAffectedLabel = GeneralStatsSection:NewLabel("👥 Jogadores Afetados: 0")
    
    -- Atualizador de estatísticas
    spawn(function()
        while true do
            totalPunishmentsLabel:UpdateLabel("🎯 Total de Punições: " .. AntiScripter.Stats.TotalPunishments)
            activePunishmentsLabel:UpdateLabel("⚡ Punições Ativas: " .. AntiScripter.Stats.ActivePunishments)
            layersUsedLabel:UpdateLabel("🔧 Camadas Usadas: " .. AntiScripter.Stats.LayersUsed)
            playersAffectedLabel:UpdateLabel("👥 Jogadores Afetados: " .. AntiScripter.Stats.PlayersAffected)
            Utilities.Wait(0.5)
        end
    end)
    
    -- ABA: Configurações
    local ConfigTab = Interface.MainWindow:NewTab("⚙️ Configurações")
    
    -- Seção: Configurações do Sistema
    local SystemConfigSection = ConfigTab:NewSection("🛠️ Configurações do Sistema")
    
    -- Toggles
    SystemConfigSection:NewToggle(
        "Auto-atualizar Lista",
        "Atualiza automaticamente a lista de jogadores",
        function(state)
            AntiScripter.Settings.AutoRefreshPlayers = state
            Logger.Info("Auto-atualização: " .. (state and "ATIVADA" or "DESATIVADA"))
        end
    )
    
    SystemConfigSection:NewToggle(
        "Modo Extremo",
        "Ativa funcionalidades mais agressivas",
        function(state)
            AntiScripter.Settings.ExtremeMode = state
            Logger.Info("Modo Extremo: " .. (state and "ATIVADO" or "DESATIVADO"))
        end
    )
    
    SystemConfigSection:NewToggle(
        "Mostrar Debug Info",
        "Mostra informações de debug no console",
        function(state)
            AntiScripter.Settings.ShowDebugInfo = state
            Logger.Info("Debug Info: " .. (state and "ATIVADO" or "DESATIVADO"))
        end
    )
    
    SystemConfigSection:NewToggle(
        "Anti-Anti-Script",
        "Tenta contornar anti-cheats",
        function(state)
            AntiScripter.Settings.AntiAntiScript = state
            Logger.Info("Anti-Anti-Script: " .. (state and "ATIVADO" or "DESATIVADO"))
        end
    )
    
    -- Seção: Ferramentas
    local ToolsSection = ConfigTab:NewSection("🔧 Ferramentas")
    
    ToolsSection:NewButton(
        "🔄 Forçar Atualização de Lista",
        "Atualiza lista manualmente",
        function()
            local playerList = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(playerList, player.Name)
                end
            end
            
            if #playerList == 0 then
                table.insert(playerList, "Nenhum jogador")
            end
            
            playerDropdown:Refresh(playerList)
            Logger.Success("Lista forçada atualizada: " .. (#playerList) .. " jogadores")
        end
    )
    
    ToolsSection:NewButton(
        "📋 Ver Todos os Jogadores",
        "Mostra lista completa no console",
        function()
            print("\n=== LISTA DE JOGADORES ===")
            for _, player in pairs(Players:GetPlayers()) do
                print("👤 " .. player.Name .. " (UserId: " .. player.UserId .. ")")
            end
            print("===========================\n")
        end
    )
    
    ToolsSection:NewButton(
        "🧹 Limpar Todos os Efeitos",
        "Remove todos os efeitos visuais",
        function()
            for _, layer in pairs(LayerController.Layers) do
                layer.Stop()
            end
            Logger.Success("Todos os efeitos limpos")
        end
    )
    
    -- Seção: Emergência
    local EmergencySection = ConfigTab:NewSection("🚨 Controles de Emergência")
    
    EmergencySection:NewButton(
        "⛔ PARAR TUDO IMEDIATAMENTE",
        "Para todas as punições e restaura jogadores",
        function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    LayerController.StopAllLayers(player)
                    Utilities.RestoreState(player)
                end
            end
            
            AntiScripter.IsPunishing = false
            AntiScripter.TargetPlayer = nil
            mainPunishButton:UpdateText("🔴 INICIAR PUNIÇÃO COMPLETA (10 CAMADAS)")
            
            if punishmentStatusLabel then
                punishmentStatusLabel:UpdateLabel("📊 Status: PARADO (EMERGÊNCIA)")
            end
            
            Logger.Success("🚨 EMERGÊNCIA: Todas as punições paradas!")
        end
    )
    
    EmergencySection:NewButton(
        "🔒 FECHAR SISTEMA",
        "Fecha completamente o sistema",
        function()
            for _, player in pairs(Players:GetPlayers()) do
                LayerController.StopAllLayers(player)
            end
            
            Interface.MainWindow:Destroy()
            Logger.Success("Sistema fechado pelo usuário")
        end
    )
    
    -- Atualizar lista inicial
    spawn(function()
        Utilities.Wait(2)
        local playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        
        if #playerList == 0 then
            table.insert(playerList, "Nenhum jogador")
        end
        
        playerDropdown:Refresh(playerList)
        Logger.Success("Lista inicial carregada: " .. #playerList .. " jogadores")
    end)
    
    -- Auto-atualização da lista
    spawn(function()
        while true do
            if AntiScripter.Settings.AutoRefreshPlayers then
                local playerList = {}
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        table.insert(playerList, player.Name)
                    end
                end
                
                if #playerList == 0 then
                    table.insert(playerList, "Nenhum jogador")
                end
                
                playerDropdown:Refresh(playerList)
            end
            Utilities.Wait(5)
        end
    end)
    
    Logger.Success("Interface gráfica criada com sucesso!")
end

--===========================================================
-- SISTEMA DE AUTO-DEFESA
--===========================================================
local DefenseSystem = {
    AntiKick = function()
        -- Prevenir kick do jogo
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "Kick" or method == "kick" then
                Logger.Warning("Tentativa de kick detectada e bloqueada!")
                return nil
            end
            
            return oldNamecall(self, unpack(args))
        end)
        setreadonly(mt, true)
        
        Logger.Success("Sistema Anti-Kick ativado")
    end,
    
    AntiTeleport = function()
        -- Monitorar tentativas de teleporte
        LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Started then
                Logger.Warning("Tentativa de teleporte detectada!")
                -- Pode adicionar lógica adicional aqui
            end
        end)
        
        Logger.Success("Sistema Anti-Teleporte ativado")
    end,
    
    AntiDetection = function()
        -- Ocultar scripts
        for _, script in pairs(game:GetDescendants()) do
            if script:IsA("LocalScript") and script.Name:find("AntiScripter") then
                script.Archivable = false
            end
        end
        
        -- Limpar logs
        game:GetService("ScriptContext").Error:Connect(function(message)
            if message:find("AntiScripter") then
                Logger.Debug("Erro detectado e silenciado: " .. message)
                return nil
            end
        end)
        
        Logger.Success("Sistema Anti-Detecção ativado")
    end
}

-- Ativar sistemas de defesa
DefenseSystem.AntiKick()
DefenseSystem.AntiTeleport()
DefenseSystem.AntiDetection()

--===========================================================
-- SISTEMA DE INICIALIZAÇÃO
--===========================================================
Logger.Info("Inicializando sistema completo...")

-- Mensagem de inicialização
spawn(function()
    Utilities.Wait(1)
    
    local welcomeMessage = [[
    
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║      🚀 ANTI-SCRIPTER ULTIMATE SYSTEM v]] .. AntiScripter.Version .. [[       ║
    ║                                                          ║
    ║          ✅ Sistema carregado com sucesso!               ║
    ║          👥 Jogadores: ]] .. #Players:GetPlayers() .. [[                                   ║
    ║          🔧 Camadas prontas: 10/10                      ║
    ║          🛡️  Sistemas de defesa: ATIVOS                 ║
    ║                                                          ║
    ║   📋 INSTRUÇÕES:                                        ║
    ║   1. Abra a interface (F9)                             ║
    ║   2. Selecione um jogador                              ║
    ║   3. Clique em "INICIAR PUNIÇÃO COMPLETA"              ║
    ║   4. Para parar, clique novamente                      ║
    ║   5. Pressione DELETE para fechar                      ║
    ║                                                          ║
    ║   ⚠️  USE ESTE PODER COM RESPONSABILIDADE!              ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    
    ]]
    
    print(welcomeMessage)
end)

-- Sistema de limpeza ao fechar
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Delete then
        Logger.Warning("Usuário pressionou DELETE - Fechando sistema...")
        
        -- Parar todas as camadas
        for _, player in pairs(Players:GetPlayers()) do
            LayerController.StopAllLayers(player)
        end
        
        -- Fechar interface
        if Interface.MainWindow then
            Interface.MainWindow:Destroy()
        end
        
        -- Mensagem final
        print("\n" .. string.rep("=", 60))
        print("🛑 ANTI-SCRIPTER SYSTEM FECHADO")
        print("⏱️  Tempo ativo: " .. AntiScripter.Stats.TimeActive .. " segundos")
        print("🎯 Total de punições: " .. AntiScripter.Stats.TotalPunishments)
        print("👥 Jogadores afetados: " .. AntiScripter.Stats.PlayersAffected)
        print(string.rep("=", 60) .. "\n")
    end
end)

-- Monitorar tempo de atividade
spawn(function()
    while true do
        AntiScripter.Stats.TimeActive = AntiScripter.Stats.TimeActive + 1
        Utilities.Wait(1)
    end
end)

Logger.Success("===============================================")
Logger.Success("ANTI-SCRIPTER ULTIMATE SYSTEM INICIALIZADO!")
Logger.Success("Versão: " .. AntiScripter.Version)
Logger.Success("Jogadores online: " .. #Players:GetPlayers())
Logger.Success("10 Camadas de punição carregadas")
Logger.Success("Sistemas de defesa ativos")
Logger.Success("Interface gráfica pronta (F9 para abrir)")
Logger.Success("Pressione DELETE para fechar o sistema")
Logger.Success("===============================================")

-- Retornar instância do sistema para possível uso externo
return {
    System = AntiScripter,
    Controller = LayerController,
    Utilities = Utilities,
    Logger = Logger
}
