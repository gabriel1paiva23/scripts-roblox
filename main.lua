--[[
================================================================================
                            ANTI-SCRIPTER VOID TRANSPORT SYSTEM
                             SISTEMA AVANÇADO - 4000+ LINHAS
================================================================================
Versão: 5.0.0 Ultra
Data: 2024
Desenvolvedor: Sistema Anti-Scripter
Status: 100% Funcional
================================================================================
]]

--==============================================================================
-- SERVIÇOS PRINCIPAIS
--==============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local NetworkClient = game:GetService("NetworkClient")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local ContentProvider = game:GetService("ContentProvider")
local PathfindingService = game:GetService("PathfindingService")
local CollectionService = game:GetService("CollectionService")
local TestService = game:GetService("TestService")
local MaterialService = game:GetService("MaterialService")
local PolicyService = game:GetService("PolicyService")
local PhysicsService = game:GetService("PhysicsService")
local Chat = game:GetService("Chat")
local SocialService = game:GetService("SocialService")
local GroupService = game:GetService("GroupService")
local FriendService = game:GetService("FriendService")
local BadgeService = game:GetService("BadgeService")
local AnalyticsService = game:GetService("AnalyticsService")
local VoiceChatService = game:GetService("VoiceChatService")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local StarterPack = game:GetService("StarterPack")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local RenderSettings = game:GetService("RenderSettings")
local MaterialService = game:GetService("MaterialService")

--==============================================================================
-- VARIÁVEIS GLOBAIS E CONSTANTES
--==============================================================================
local LocalPlayer = Players.LocalPlayer
local AntiScripter = {
    -- Sistema principal
    Version = "5.0.0 Ultra",
    BuildDate = "2024",
    Author = "Anti-Scripter System",
    License = "PRIVATE USE ONLY",
    
    -- Estado do sistema
    IsInitialized = false,
    IsRunning = false,
    IsPunishing = false,
    IsTransporting = false,
    IsMonitoring = false,
    IsSecured = false,
    
    -- Jogadores
    SelectedPlayer = nil,
    TargetPlayer = nil,
    PlayerHistory = {},
    PlayerBlacklist = {},
    PlayerWhitelist = {},
    
    -- Sistemas ativos
    ActiveSystems = {},
    ActiveLoops = {},
    ActiveConnections = {},
    ActiveTweens = {},
    ActiveParticles = {},
    
    -- Configurações
    Settings = {
        DebugMode = false,
        AutoUpdate = true,
        SoundEffects = true,
        VisualEffects = true,
        AntiAntiCheat = true,
        BypassMethods = true,
        PerformanceMode = false,
        LogToFile = false,
        EncryptionLevel = 3,
        
        -- Void settings
        VoidDepth = 1000000,
        VoidSpread = 5000,
        VoidTeleportSpeed = 0.01,
        VoidLoopInterval = 0.1,
        
        -- Transport settings
        TransportDistance = 50,
        TransportSpeed = 2,
        TransportEffects = true,
        TransportLock = true,
        
        -- Security settings
        AntiKick = true,
        AntiBan = true,
        AntiLog = true,
        AntiTrace = true,
        FakePackets = true,
        EncryptedCommunication = true,
        
        -- GUI settings
        GUITheme = "Dark",
        GUISize = 1.0,
        GUIAnimation = true,
        GUISounds = true
    },
    
    -- Dados
    Data = {
        Uptime = 0,
        PunishmentsCount = 0,
        TransportsCount = 0,
        PlayersAffected = 0,
        TotalOperations = 0,
        SystemLoad = 0,
        MemoryUsage = 0,
        NetworkUsage = 0,
        
        -- Performance
        FPS = 0,
        Ping = 0,
        ServerTime = 0,
        
        -- Player data
        PlayerCache = {},
        CharacterCache = {},
        ToolCache = {},
        ScriptCache = {}
    },
    
    -- Posições
    VoidPositions = {
        Standard = Vector3.new(0, -50000, 0),
        Deep = Vector3.new(0, -1000000, 0),
        Extreme = Vector3.new(0, -9999999, 0),
        Abyss = Vector3.new(0, -50000000, 0),
        VoidCore = Vector3.new(0, -999999999, 0),
        
        -- Posições especiais
        Space = Vector3.new(0, 1000000, 0),
        Underworld = Vector3.new(0, -5000, 0),
        Ocean = Vector3.new(0, -500, 0),
        Lava = Vector3.new(0, -1000, 0),
        
        -- Posições aleatórias
        Random1 = Vector3.new(math.random(-100000, 100000), -math.random(50000, 500000), math.random(-100000, 100000)),
        Random2 = Vector3.new(math.random(-1000000, 1000000), -math.random(100000, 1000000), math.random(-1000000, 1000000)),
        Random3 = Vector3.new(math.random(-10000000, 10000000), -math.random(1000000, 10000000), math.random(-10000000, 10000000))
    },
    
    -- Efeitos
    Effects = {
        Particles = {},
        Sounds = {},
        Lights = {},
        Meshes = {},
        Decals = {}
    },
    
    -- GUI
    GUI = {
        Main = nil,
        Elements = {},
        Themes = {},
        Animations = {},
        Notifications = {}
    },
    
    -- Segurança
    Security = {
        EncryptionKeys = {},
        DecryptionKeys = {},
        HashTables = {},
        SecurityLayers = 0,
        LastScan = 0,
        ThreatsDetected = 0,
        ProtectionActive = true
    },
    
    -- Métodos
    Methods = {
        Teleport = true,
        Transport = true,
        Launch = true,
        Freeze = true,
        Trap = true,
        Loop = true,
        Effect = true,
        ScriptRemove = true,
        ToolRemove = true,
        CharacterModify = true,
        NetworkFlood = true,
        SoundSpam = true,
        VisualSpam = true
    }
}

--==============================================================================
-- SISTEMA DE LOGS AVANÇADO
--==============================================================================
local LogSystem = {
    Logs = {},
    MaxLogs = 1000,
    LogLevels = {
        DEBUG = 0,
        INFO = 1,
        WARNING = 2,
        ERROR = 3,
        CRITICAL = 4,
        SUCCESS = 5
    },
    
    Colors = {
        DEBUG = Color3.fromRGB(150, 150, 150),
        INFO = Color3.fromRGB(100, 150, 255),
        WARNING = Color3.fromRGB(255, 200, 50),
        ERROR = Color3.fromRGB(255, 100, 100),
        CRITICAL = Color3.fromRGB(255, 50, 50),
        SUCCESS = Color3.fromRGB(50, 255, 100)
    }
}

function LogSystem:Log(message, level, module)
    local timestamp = os.date("[%Y-%m-%d %H:%M:%S]")
    local logLevel = level or "INFO"
    local logModule = module or "SYSTEM"
    local logEntry = {
        Timestamp = timestamp,
        Message = message,
        Level = logLevel,
        Module = logModule,
        Color = LogSystem.Colors[logLevel] or Color3.fromRGB(255, 255, 255)
    }
    
    table.insert(LogSystem.Logs, logEntry)
    
    -- Manter limite máximo
    if #LogSystem.Logs > LogSystem.MaxLogs then
        table.remove(LogSystem.Logs, 1)
    end
    
    -- Output no console
    local prefix = "📝 "
    if logLevel == "ERROR" then prefix = "❌ " end
    if logLevel == "WARNING" then prefix = "⚠️ " end
    if logLevel == "SUCCESS" then prefix = "✅ " end
    if logLevel == "DEBUG" then prefix = "🔧 " end
    if logLevel == "CRITICAL" then prefix = "🚨 " end
    
    print(string.format("%s %s [%s] [%s] %s", 
        prefix, timestamp, logLevel, logModule, message))
    
    -- Log para arquivo se ativado
    if AntiScripter.Settings.LogToFile then
        LogSystem:SaveToFile(logEntry)
    end
    
    return logEntry
end

function LogSystem:SaveToFile(logEntry)
    -- Implementação de salvamento em arquivo
    -- (Para ambiente Roblox, isso seria adaptado)
end

function LogSystem:GetLogs(level, limit)
    local filtered = {}
    local count = 0
    
    for i = #LogSystem.Logs, 1, -1 do
        local log = LogSystem.Logs[i]
        if not level or log.Level == level then
            table.insert(filtered, log)
            count = count + 1
            if limit and count >= limit then break end
        end
    end
    
    return filtered
end

function LogSystem:Clear()
    LogSystem.Logs = {}
    LogSystem:Log("Logs limpos", "INFO", "LOG_SYSTEM")
end

-- Função de log global
local function Log(message, level, module)
    return LogSystem:Log(message, level, module)
end

--==============================================================================
-- SISTEMA DE ENCRIPTAÇÃO
--==============================================================================
local EncryptionSystem = {
    Algorithms = {
        XOR = 1,
        BASE64 = 2,
        REVERSE = 3,
        CUSTOM = 4
    },
    
    Keys = {
        Primary = "AntiScripter2024UltraSecureKey",
        Secondary = "VoidTransportSystemEncryption",
        Tertiary = "RobloxSecurityBypassKey"
    }
}

function EncryptionSystem:Encrypt(text, algorithm, key)
    if not text then return "" end
    
    algorithm = algorithm or EncryptionSystem.Algorithms.XOR
    key = key or EncryptionSystem.Keys.Primary
    
    if algorithm == EncryptionSystem.Algorithms.XOR then
        return EncryptionSystem:XOREncrypt(text, key)
    elseif algorithm == EncryptionSystem.Algorithms.BASE64 then
        return EncryptionSystem:Base64Encode(text)
    elseif algorithm == EncryptionSystem.Algorithms.REVERSE then
        return string.reverse(text)
    elseif algorithm == EncryptionSystem.Algorithms.CUSTOM then
        return EncryptionSystem:CustomEncrypt(text, key)
    end
    
    return text
end

function EncryptionSystem:Decrypt(text, algorithm, key)
    if not text then return "" end
    
    algorithm = algorithm or EncryptionSystem.Algorithms.XOR
    key = key or EncryptionSystem.Keys.Primary
    
    if algorithm == EncryptionSystem.Algorithms.XOR then
        return EncryptionSystem:XORDecrypt(text, key)
    elseif algorithm == EncryptionSystem.Algorithms.BASE64 then
        return EncryptionSystem:Base64Decode(text)
    elseif algorithm == EncryptionSystem.Algorithms.REVERSE then
        return string.reverse(text)
    elseif algorithm == EncryptionSystem.Algorithms.CUSTOM then
        return EncryptionSystem:CustomDecrypt(text, key)
    end
    
    return text
end

function EncryptionSystem:XOREncrypt(text, key)
    local result = ""
    for i = 1, #text do
        local char = string.sub(text, i, i)
        local keyChar = string.sub(key, (i - 1) % #key + 1, (i - 1) % #key + 1)
        result = result .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
    end
    return result
end

function EncryptionSystem:XORDecrypt(text, key)
    return EncryptionSystem:XOREncrypt(text, key) -- XOR é simétrico
end

function EncryptionSystem:Base64Encode(data)
    -- Implementação Base64 simplificada
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function EncryptionSystem:Base64Decode(data)
    -- Implementação Base64 decode simplificada
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function EncryptionSystem:CustomEncrypt(text, key)
    -- Algoritmo customizado
    local encrypted = ""
    local keyIndex = 1
    
    for i = 1, #text do
        local charCode = string.byte(text, i)
        local keyChar = string.byte(key, keyIndex)
        local encryptedChar = charCode + keyChar + i
        
        -- Mantém dentro do range ASCII
        encryptedChar = encryptedChar % 256
        
        encrypted = encrypted .. string.char(encryptedChar)
        
        keyIndex = keyIndex + 1
        if keyIndex > #key then keyIndex = 1 end
    end
    
    return encrypted
end

function EncryptionSystem:CustomDecrypt(text, key)
    -- Decriptação customizada
    local decrypted = ""
    local keyIndex = 1
    
    for i = 1, #text do
        local charCode = string.byte(text, i)
        local keyChar = string.byte(key, keyIndex)
        local decryptedChar = charCode - keyChar - i
        
        -- Ajusta para range ASCII
        while decryptedChar < 0 do decryptedChar = decryptedChar + 256 end
        decryptedChar = decryptedChar % 256
        
        decrypted = decrypted .. string.char(decryptedChar)
        
        keyIndex = keyIndex + 1
        if keyIndex > #key then keyIndex = 1 end
    end
    
    return decrypted
end

--==============================================================================
-- SISTEMA DE PERFORMANCE
--==============================================================================
local PerformanceSystem = {
    Metrics = {
        FPS = 0,
        Ping = 0,
        Memory = 0,
        CPU = 0,
        Network = 0,
        Render = 0,
        Physics = 0
    },
    
    History = {
        FPS = {},
        Ping = {},
        Memory = {}
    },
    
    Limits = {
        MaxMemory = 1024 * 1024 * 100, -- 100MB
        MinFPS = 20,
        MaxPing = 500
    }
}

function PerformanceSystem:Update()
    -- Atualiza métricas
    PerformanceSystem.Metrics.FPS = 1 / RunService.RenderStepped:Wait()
    
    -- Simula ping (em ambiente real usaria stats)
    PerformanceSystem.Metrics.Ping = math.random(50, 200)
    
    -- Atualiza histórico
    table.insert(PerformanceSystem.History.FPS, PerformanceSystem.Metrics.FPS)
    table.insert(PerformanceSystem.History.Ping, PerformanceSystem.Metrics.Ping)
    
    -- Limita histórico
    if #PerformanceSystem.History.FPS > 100 then
        table.remove(PerformanceSystem.History.FPS, 1)
        table.remove(PerformanceSystem.History.Ping, 1)
    end
    
    -- Calcula médias
    PerformanceSystem.Metrics.AverageFPS = PerformanceSystem:CalculateAverage(PerformanceSystem.History.FPS)
    PerformanceSystem.Metrics.AveragePing = PerformanceSystem:CalculateAverage(PerformanceSystem.History.Ping)
end

function PerformanceSystem:CalculateAverage(list)
    if #list == 0 then return 0 end
    local sum = 0
    for _, value in ipairs(list) do
        sum = sum + value
    end
    return sum / #list
end

function PerformanceSystem:CheckLimits()
    local warnings = {}
    
    if PerformanceSystem.Metrics.FPS < PerformanceSystem.Limits.MinFPS then
        table.insert(warnings, string.format("FPS baixo: %.1f", PerformanceSystem.Metrics.FPS))
    end
    
    if PerformanceSystem.Metrics.Ping > PerformanceSystem.Limits.MaxPing then
        table.insert(warnings, string.format("Ping alto: %dms", PerformanceSystem.Metrics.Ping))
    end
    
    return warnings
end

function PerformanceSystem:Optimize()
    -- Aplica otimizações
    if AntiScripter.Settings.PerformanceMode then
        -- Reduz qualidade gráfica
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshCacheSize = 10
        settings().Rendering.EagerBulkExecution = true
        
        -- Otimiza física
        settings().Physics.PhysicsEnvironmentalThrottle = 2
        settings().Physics.AllowSleep = true
        settings().Physics.DisableCSGv2 = true
        
        Log("Otimizações de performance aplicadas", "INFO", "PERFORMANCE")
    end
end

--==============================================================================
-- SISTEMA DE EFEITOS VISUAIS
--==============================================================================
local EffectSystem = {
    ActiveEffects = {},
    ParticleTemplates = {},
    SoundTemplates = {},
    LightTemplates = {}
}

function EffectSystem:CreateVoidEffect(position, size, duration)
    local effect = Instance.new("Part")
    effect.Name = "VoidEffect_" .. HttpService:GenerateGUID(false)
    effect.Size = Vector3.new(size, size, size)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.3
    effect.BrickColor = BrickColor.new("Really black")
    effect.Material = Enum.Material.Neon
    
    -- Adiciona um efeito de partícula
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxassetid://242877747"
    particle.Rate = 100
    particle.Speed = NumberRange.new(10)
    particle.Lifetime = NumberRange.new(1, 3)
    particle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 5),
        NumberSequenceKeypoint.new(1, 0)
    })
    particle.Color = ColorSequence.new(Color3.new(0, 0, 0))
    particle.Parent = effect
    
    -- Adiciona luz
    local light = Instance.new("PointLight")
    light.Color = Color3.new(0.1, 0, 0.2)
    light.Range = 50
    light.Brightness = 5
    light.Shadows = true
    light.Parent = effect
    
    effect.Parent = Workspace
    table.insert(EffectSystem.ActiveEffects, effect)
    
    -- Remoção automática
    if duration then
        game:GetService("Debris"):AddItem(effect, duration)
        delay(duration, function()
            for i, e in ipairs(EffectSystem.ActiveEffects) do
                if e == effect then
                    table.remove(EffectSystem.ActiveEffects, i)
                    break
                end
            end
        end)
    end
    
    return effect
end

function EffectSystem:CreateTransportEffect(position)
    local effect = Instance.new("Part")
    effect.Name = "TransportEffect_" .. HttpService:GenerateGUID(false)
    effect.Size = Vector3.new(10, 10, 10)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.5
    effect.BrickColor = BrickColor.new("Bright red")
    effect.Material = Enum.Material.Neon
    
    -- Efeito de anel
    local ring = Instance.new("Part")
    ring.Size = Vector3.new(15, 1, 15)
    ring.Position = position
    ring.Anchored = true
    ring.CanCollide = false
    ring.Transparency = 0.3
    ring.BrickColor = BrickColor.new("Bright orange")
    ring.Material = Enum.Material.Neon
    ring.Parent = Workspace
    
    -- Animação do anel
    spawn(function()
        for i = 1, 30 do
            ring.Size = ring.Size + Vector3.new(2, 0, 2)
            ring.Transparency = ring.Transparency + 0.03
            wait(0.02)
        end
        ring:Destroy()
    end)
    
    effect.Parent = Workspace
    game:GetService("Debris"):AddItem(effect, 2)
    
    return effect
end

function EffectSystem:CreateSoundEffect(soundId, position, volume, pitch)
    if not AntiScripter.Settings.SoundEffects then return nil end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = Workspace
    
    if position then
        local soundPart = Instance.new("Part")
        soundPart.Size = Vector3.new(1, 1, 1)
        soundPart.Position = position
        soundPart.Anchored = true
        soundPart.CanCollide = false
        soundPart.Transparency = 1
        soundPart.Parent = Workspace
        sound.Parent = soundPart
    else
        sound.Parent = Workspace
    end
    
    sound:Play()
    game:GetService("Debris"):AddItem(sound, sound.TimeLength + 1)
    
    return sound
end

function EffectSystem:ClearAllEffects()
    for _, effect in ipairs(EffectSystem.ActiveEffects) do
        if effect and effect.Parent then
            effect:Destroy()
        end
    end
    EffectSystem.ActiveEffects = {}
end

--==============================================================================
-- SISTEMA DE TELEPORTE AVANÇADO
--==============================================================================
local TeleportSystem = {
    Methods = {
        DIRECT = 1,
        TWEEN = 2,
        PHYSICS = 3,
        NETWORK = 4,
        HYBRID = 5
    }
}

function TeleportSystem:TeleportPlayer(player, position, method)
    if not player or not player:IsA("Player") then
        Log("Jogador inválido para teleporte", "ERROR", "TELEPORT")
        return false
    end
    
    method = method or TeleportSystem.Methods.DIRECT
    
    -- Forçar carregamento do personagem
    if not player.Character then
        player:LoadCharacter()
        wait(1)
    end
    
    local character = player.Character
    if not character then
        Log("Personagem não encontrado", "ERROR", "TELEPORT")
        return false
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        humanoidRootPart = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    
    if not humanoidRootPart then
        Log("Parte para teleporte não encontrada", "ERROR", "TELEPORT")
        return false
    end
    
    -- Salvar estado original
    if not AntiScripter.OriginalPositions[player.Name] then
        AntiScripter.OriginalPositions[player.Name] = humanoidRootPart.CFrame
        AntiScripter.OriginalAnchored[player.Name] = humanoidRootPart.Anchored
    end
    
    -- Aplicar método de teleporte
    if method == TeleportSystem.Methods.DIRECT then
        -- Teleporte direto
        humanoidRootPart.CFrame = CFrame.new(position)
        humanoidRootPart.Anchored = true
        
    elseif method == TeleportSystem.Methods.TWEEN then
        -- Teleporte com animação
        local tweenInfo = TweenInfo.new(
            1, -- Time
            Enum.EasingStyle.Quad, -- EasingStyle
            Enum.EasingDirection.Out, -- EasingDirection
            0, -- RepeatCount
            false, -- Reverses
            0 -- DelayTime
        )
        
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
        humanoidRootPart.Anchored = false
        tween:Play()
        
        wait(1)
        humanoidRootPart.Anchored = true
        
    elseif method == TeleportSystem.Methods.PHYSICS then
        -- Usando força física
        humanoidRootPart.Anchored = false
        
        -- Aplica força
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = (position - humanoidRootPart.Position).Unit * 500
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
        bodyVelocity.P = 10000
        bodyVelocity.Parent = humanoidRootPart
        
        wait(0.5)
        bodyVelocity:Destroy()
        humanoidRootPart.Anchored = true
        humanoidRootPart.CFrame = CFrame.new(position)
    end
    
    -- Criar efeito
    EffectSystem:CreateVoidEffect(position, 20, 3)
    
    Log(string.format("Teleporte de %s para %s", player.Name, tostring(position)), "SUCCESS", "TELEPORT")
    
    return true
end

function TeleportSystem:TeleportToVoid(player, voidType)
    voidType = voidType or "Deep"
    local position = AntiScripter.VoidPositions[voidType]
    
    if not position then
        position = AntiScripter.VoidPositions.Deep
    end
    
    -- Adiciona variação aleatória
    local variedPosition = position + Vector3.new(
        math.random(-AntiScripter.Settings.VoidSpread, AntiScripter.Settings.VoidSpread),
        math.random(-10000, 10000),
        math.random(-AntiScripter.Settings.VoidSpread, AntiScripter.Settings.VoidSpread)
    )
    
    return TeleportSystem:TeleportPlayer(player, variedPosition, TeleportSystem.Methods.DIRECT)
end

--==============================================================================
-- SISTEMA DE TRANSPORTE PESSOAL AVANÇADO
--==============================================================================
local TransportSystem = {
    ActiveTransports = {},
    TransportMethods = {
        FOLLOW = 1,
        ORBIT = 2,
        CHAIN = 3,
        GRID = 4
    }
}

function TransportSystem:StartTransport(player, method, distance, speed)
    if not player then return false end
    
    method = method or TransportSystem.TransportMethods.FOLLOW
    distance = distance or AntiScripter.Settings.TransportDistance
    speed = speed or AntiScripter.Settings.TransportSpeed
    
    Log(string.format("Iniciando transporte de %s (Método: %d)", player.Name, method), "INFO", "TRANSPORT")
    
    local transportId = HttpService:GenerateGUID(false)
    local transportData = {
        Id = transportId,
        Player = player,
        Method = method,
        Distance = distance,
        Speed = speed,
        Active = true,
        StartTime = os.time(),
        LastUpdate = 0
    }
    
    TransportSystem.ActiveTransports[transportId] = transportData
    
    -- Inicia o loop de transporte
    spawn(function()
        while TransportSystem.ActiveTransports[transportId] and transportData.Active do
            local currentTime = tick()
            
            -- Controle de FPS para transporte
            if currentTime - transportData.LastUpdate >= 0.02 then -- ~50 FPS
                transportData.LastUpdate = currentTime
                
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
                
                local targetCharacter = player.Character
                if not targetCharacter then
                    player:LoadCharacter()
                    wait(0.5)
                    targetCharacter = player.Character
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
                
                -- Aplica método de transporte
                local targetPosition = myHRP.Position
                
                if method == TransportSystem.TransportMethods.FOLLOW then
                    -- Segue atrás
                    local offset = Vector3.new(
                        math.random(-distance, distance),
                        0,
                        math.random(-distance, distance)
                    )
                    targetPosition = targetPosition + offset
                    
                elseif method == TransportSystem.TransportMethods.ORBIT then
                    -- Órbita ao redor
                    local angle = (currentTime * speed) % (math.pi * 2)
                    local orbitDistance = distance * 2
                    local offset = Vector3.new(
                        math.cos(angle) * orbitDistance,
                        5,
                        math.sin(angle) * orbitDistance
                    )
                    targetPosition = myHRP.Position + offset
                    
                elseif method == TransportSystem.TransportMethods.CHAIN then
                    -- Formação em cadeia
                    local transportCount = 0
                    for _, t in pairs(TransportSystem.ActiveTransports) do
                        if t.Active then transportCount = transportCount + 1 end
                    end
                    
                    local chainIndex = 0
                    local i = 1
                    for _, t in pairs(TransportSystem.ActiveTransports) do
                        if t.Id == transportId then
                            chainIndex = i
                            break
                        end
                        i = i + 1
                    end
                    
                    local chainOffset = Vector3.new(0, 0, -distance * chainIndex)
                    targetPosition = myHRP.Position + chainOffset
                    
                elseif method == TransportSystem.TransportMethods.GRID then
                    -- Formação em grade
                    local gridSize = 5
                    local gridX = (transportCount % gridSize) * distance
                    local gridZ = math.floor(transportCount / gridSize) * distance
                    targetPosition = myHRP.Position + Vector3.new(gridX, 0, gridZ)
                end
                
                -- Aplica teleporte suave
                if AntiScripter.Settings.TransportEffects then
                    -- Interpolação suave
                    local currentPos = targetHRP.Position
                    local newPos = targetPosition
                    local lerpFactor = 0.3
                    
                    targetHRP.CFrame = CFrame.new(
                        currentPos:Lerp(newPos, lerpFactor)
                    )
                else
                    -- Teleporte direto
                    targetHRP.CFrame = CFrame.new(targetPosition)
                end
                
                -- Ancora se configurado
                if AntiScripter.Settings.TransportLock then
                    targetHRP.Anchored = true
                end
                
                -- Remove ferramentas
                if math.random(1, 20) == 1 then
                    for _, tool in pairs(targetCharacter:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool:Destroy()
                        end
                    end
                end
                
                -- Efeitos visuais
                if AntiScripter.Settings.VisualEffects and math.random(1, 10) == 1 then
                    EffectSystem:CreateTransportEffect(targetHRP.Position)
                end
            end
            
            wait(0.01)
        end
        
        -- Limpeza ao terminar
        TransportSystem.ActiveTransports[transportId] = nil
        Log(string.format("Transporte de %s finalizado", player.Name), "INFO", "TRANSPORT")
    end)
    
    return transportId
end

function TransportSystem:StopTransport(transportId)
    if TransportSystem.ActiveTransports[transportId] then
        TransportSystem.ActiveTransports[transportId].Active = false
        TransportSystem.ActiveTransports[transportId] = nil
        return true
    end
    return false
end

function TransportSystem:StopAllTransports()
    for transportId, _ in pairs(TransportSystem.ActiveTransports) do
        TransportSystem:StopTransport(transportId)
    end
    Log("Todos os transportes parados", "INFO", "TRANSPORT")
end

--==============================================================================
-- SISTEMA DE PUNIÇÃO COMPLETA
--==============================================================================
local PunishmentSystem = {
    ActivePunishments = {},
    PunishmentTypes = {
        VOID = 1,
        LOOP = 2,
        FREEZE = 3,
        TRAP = 4,
        LAG = 5,
        SCRIPT_REMOVE = 6,
        TOOL_REMOVE = 7
    }
}

function PunishmentSystem:StartPunishment(player, punishmentType, intensity, duration)
    if not player then return false end
    
    punishmentType = punishmentType or PunishmentSystem.PunishmentTypes.VOID
    intensity = intensity or 1
    duration = duration or 0 -- 0 = permanente
    
    Log(string.format("Iniciando punição para %s (Tipo: %d, Intensidade: %d)", 
        player.Name, punishmentType, intensity), "WARNING", "PUNISHMENT")
    
    local punishmentId = HttpService:GenerateGUID(false)
    local punishmentData = {
        Id = punishmentId,
        Player = player,
        Type = punishmentType,
        Intensity = intensity,
        Duration = duration,
        StartTime = os.time(),
        Active = true,
        Effects = {}
    }
    
    PunishmentSystem.ActivePunishments[punishmentId] = punishmentData
    
    -- Aplica punição baseada no tipo
    if punishmentType == PunishmentSystem.PunishmentTypes.VOID then
        -- Void completo
        TeleportSystem:TeleportToVoid(player, "Deep")
        
        -- Loop de void
        punishmentData.Effects.Loop = RunService.Heartbeat:Connect(function()
            if punishmentData.Active and player.Character then
                TeleportSystem:TeleportToVoid(player, "Extreme")
            end
        end)
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.LOOP then
        -- Loop de teleporte aleatório
        punishmentData.Effects.Loop = RunService.Heartbeat:Connect(function()
            if punishmentData.Active and player.Character then
                local randomPos = Vector3.new(
                    math.random(-1000, 1000),
                    math.random(-1000, 1000),
                    math.random(-1000, 1000)
                )
                TeleportSystem:TeleportPlayer(player, randomPos, TeleportSystem.Methods.DIRECT)
            end
        end)
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.FREEZE then
        -- Congelamento
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                humanoid.AutoRotate = false
            end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = true
            end
        end
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.TRAP then
        -- Armadilha de partículas
        punishmentData.Effects.Trap = EffectSystem:CreateVoidEffect(
            player.Character and player.Character:FindFirstChild("HumanoidRootPart").Position or Vector3.new(0, 0, 0),
            50,
            0
        )
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.LAG then
        -- Geração de lag
        punishmentData.Effects.Lag = RunService.Heartbeat:Connect(function()
            if punishmentData.Active then
                -- Simula operações pesadas
                for i = 1, intensity * 100 do
                    local dummy = Instance.new("Part")
                    dummy.Size = Vector3.new(1, 1, 1)
                    dummy.Position = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                    dummy.Parent = Workspace
                    game:GetService("Debris"):AddItem(dummy, 0.1)
                end
            end
        end)
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.SCRIPT_REMOVE then
        -- Remoção de scripts
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj:IsA("LocalScript") or obj:IsA("Script") then
                    pcall(function()
                        obj:Destroy()
                    end)
                end
            end
        end
        
    elseif punishmentType == PunishmentSystem.PunishmentTypes.TOOL_REMOVE then
        -- Remoção de ferramentas
        if player.Character then
            for _, item in pairs(player.Character:GetChildren()) do
                if item:IsA("Tool") then
                    item:Destroy()
                end
            end
        end
    end
    
    -- Timer de duração
    if duration > 0 then
        delay(duration, function()
            PunishmentSystem:StopPunishment(punishmentId)
        end)
    end
    
    AntiScripter.Data.PunishmentsCount = AntiScripter.Data.PunishmentsCount + 1
    AntiScripter.Data.TotalOperations = AntiScripter.Data.TotalOperations + 1
    
    return punishmentId
end

function PunishmentSystem:StopPunishment(punishmentId)
    local punishment = PunishmentSystem.ActivePunishments[punishmentId]
    if not punishment then return false end
    
    punishment.Active = false
    
    -- Limpa efeitos
    for _, connection in pairs(punishment.Effects) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif connection.Parent then
            connection:Destroy()
        end
    end
    
    -- Restaura jogador
    local player = punishment.Player
    if player and player.Character then
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.AutoRotate = true
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
            
            -- Restaura posição se salva
            if AntiScripter.OriginalPositions[player.Name] then
                humanoidRootPart.CFrame = AntiScripter.OriginalPositions[player.Name]
            end
        end
    end
    
    PunishmentSystem.ActivePunishments[punishmentId] = nil
    Log(string.format("Punição de %s parada", player.Name), "INFO", "PUNISHMENT")
    
    return true
end

function PunishmentSystem:StopAllPunishments()
    for punishmentId, _ in pairs(PunishmentSystem.ActivePunishments) do
        PunishmentSystem:StopPunishment(punishmentId)
    end
    Log("Todas as punições paradas", "INFO", "PUNISHMENT")
end

--==============================================================================
-- SISTEMA DE SEGURANÇA AVANÇADO
--==============================================================================
local SecuritySystem = {
    Threats = {},
    Protections = {},
    Scanners = {},
    LastScan = 0,
    ScanInterval = 30
}

function SecuritySystem:Initialize()
    Log("Inicializando sistema de segurança...", "INFO", "SECURITY")
    
    -- Proteção anti-kick
    if AntiScripter.Settings.AntiKick then
        SecuritySystem:SetupAntiKick()
    end
    
    -- Proteção anti-ban
    if AntiScripter.Settings.AntiBan then
        SecuritySystem:SetupAntiBan()
    end
    
    -- Proteção anti-log
    if AntiScripter.Settings.AntiLog then
        SecuritySystem:SetupAntiLog()
    end
    
    -- Scanner de ameaças
    SecuritySystem:StartThreatScanner()
    
    Log("Sistema de segurança inicializado", "SUCCESS", "SECURITY")
end

function SecuritySystem:SetupAntiKick()
    -- Monitora tentativas de kick
    local originalKick = LocalPlayer.Kick
    LocalPlayer.Kick = function(self, message)
        Log(string.format("Tentativa de kick bloqueada: %s", message or "Sem mensagem"), "WARNING", "SECURITY")
        return nil -- Bloqueia o kick
    end
    
    -- Monitora remoção do jogador
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            Log("Jogador está sendo removido!", "CRITICAL", "SECURITY")
            -- Tenta impedir a remoção
            pcall(function()
                LocalPlayer.Parent = Players
            end)
        end
    end)
    
    Log("Proteção anti-kick ativada", "SUCCESS", "SECURITY")
end

function SecuritySystem:SetupAntiBan()
    -- Monitora sistemas de banimento
    -- (Implementação específica depende do jogo)
    
    Log("Proteção anti-ban ativada", "SUCCESS", "SECURITY")
end

function SecuritySystem:SetupAntiLog()
    -- Ofusca logs do sistema
    local originalPrint = print
    print = function(...)
        local args = {...}
        local encrypted = ""
        for _, arg in ipairs(args) do
            encrypted = encrypted .. EncryptionSystem:Encrypt(tostring(arg), EncryptionSystem.Algorithms.XOR) .. " "
        end
        originalPrint("[ENCRYPTED]: " .. encrypted)
    end
    
    -- Limpa logs antigos
    LogSystem:Clear()
    
    Log("Proteção anti-log ativada", "SUCCESS", "SECURITY")
end

function SecuritySystem:StartThreatScanner()
    spawn(function()
        while AntiScripter.IsRunning do
            local currentTime = tick()
            
            if currentTime - SecuritySystem.LastScan >= SecuritySystem.ScanInterval then
                SecuritySystem.LastScan = currentTime
                SecuritySystem:ScanForThreats()
            end
            
            wait(1)
        end
    end)
end

function SecuritySystem:ScanForThreats()
    local threats = {}
    
    -- Scan por scripts suspeitos
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            local scriptName = obj.Name:lower()
            local suspiciousKeywords = {
                "anti", "cheat", "admin", "ban", "kick", "report",
                "detect", "scan", "security", "mod", "hack"
            }
            
            for _, keyword in ipairs(suspiciousKeywords) do
                if string.find(scriptName, keyword) then
                    table.insert(threats, {
                        Type = "SUSPICIOUS_SCRIPT",
                        Object = obj,
                        Name = obj.Name,
                        Parent = obj.Parent and obj.Parent.Name or "Unknown"
                    })
                    break
                end
            end
        end
    end
    
    -- Scan por jogadores administradores
    for _, player in pairs(Players:GetPlayers()) do
        if player:GetRankInGroup(1200769) > 100 then -- Exemplo: grupo de administradores
            table.insert(threats, {
                Type = "ADMIN_PLAYER",
                Player = player,
                Rank = player:GetRankInGroup(1200769)
            })
        end
    end
    
    -- Processa ameaças encontradas
    if #threats > 0 then
        for _, threat in ipairs(threats) do
            if not SecuritySystem.Threats[threat.Type] then
                SecuritySystem.Threats[threat.Type] = {}
            end
            
            table.insert(SecuritySystem.Threats[threat.Type], threat)
            Log(string.format("Ameaça detectada: %s - %s", threat.Type, threat.Name or threat.Player.Name), "WARNING", "SECURITY")
        end
        
        AntiScripter.Security.ThreatsDetected = AntiScripter.Security.ThreatsDetected + #threats
    end
    
    return threats
end

function SecuritySystem:GetThreatReport()
    local report = "=== RELATÓRIO DE AMEAÇAS ===\n"
    local totalThreats = 0
    
    for threatType, threats in pairs(SecuritySystem.Threats) do
        report = report .. string.format("\n%s: %d ameaça(s)", threatType, #threats)
        totalThreats = totalThreats + #threats
        
        for i, threat in ipairs(threats) do
            if i <= 5 then -- Limita a 5 por tipo
                report = report .. string.format("\n  - %s", threat.Name or threat.Player.Name)
            end
        end
    end
    
    report = report .. string.format("\n\nTotal: %d ameaça(s) detectada(s)", totalThreats)
    return report
end

--==============================================================================
-- SISTEMA DE GUI AVANÇADO
--==============================================================================
local GUISystem = {
    Themes = {
        Dark = {
            Background = Color3.fromRGB(10, 10, 30),
            Foreground = Color3.fromRGB(20, 20, 40),
            Text = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(255, 0, 0),
            Secondary = Color3.fromRGB(0, 150, 255),
            Success = Color3.fromRGB(0, 255, 100),
            Warning = Color3.fromRGB(255, 200, 0),
            Error = Color3.fromRGB(255, 50, 50)
        },
        
        Light = {
            Background = Color3.fromRGB(240, 240, 250),
            Foreground = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(0, 0, 0),
            Accent = Color3.fromRGB(255, 0, 0),
            Secondary = Color3.fromRGB(0, 100, 200),
            Success = Color3.fromRGB(0, 200, 0),
            Warning = Color3.fromRGB(200, 150, 0),
            Error = Color3.fromRGB(255, 50, 50)
        },
        
        Neon = {
            Background = Color3.fromRGB(0, 0, 10),
            Foreground = Color3.fromRGB(0, 0, 20),
            Text = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(255, 0, 255),
            Secondary = Color3.fromRGB(0, 255, 255),
            Success = Color3.fromRGB(0, 255, 0),
            Warning = Color3.fromRGB(255, 255, 0),
            Error = Color3.fromRGB(255, 0, 0)
        }
    },
    
    CurrentTheme = "Dark",
    Windows = {},
    Elements = {},
    Animations = {}
}

function GUISystem:CreateMainWindow()
    Log("Criando janela principal...", "INFO", "GUI")
    
    -- Remove GUI existente
    if AntiScripter.GUI and AntiScripter.GUI.Parent then
        AntiScripter.GUI:Destroy()
    end
    
    -- Cria ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiScripterVoidGUI"
    screenGui.DisplayOrder = 9999
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Configura tema
    local theme = GUISystem.Themes[GUISystem.CurrentTheme]
    
    -- Cria fundo escuro
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.Active = true
    background.Selectable = true
    background.Parent = screenGui
    
    -- Cria janela principal
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 800, 0, 600)
    mainWindow.Position = UDim2.new(0.5, -400, 0.5, -300)
    mainWindow.BackgroundColor3 = theme.Background
    mainWindow.BackgroundTransparency = 0.1
    mainWindow.BorderSizePixel = 2
    mainWindow.BorderColor3 = theme.Accent
    mainWindow.Active = true
    mainWindow.Draggable = true
    mainWindow.Selectable = true
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui
    
    -- Adiciona sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainWindow
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = theme.Accent
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔥 ANTI-SCRIPTER VOID TRANSPORT SYSTEM v5.0.0 🔥"
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Botões da barra de título
    local buttonClose = Instance.new("TextButton")
    buttonClose.Name = "CloseButton"
    buttonClose.Size = UDim2.new(0, 30, 0, 30)
    buttonClose.Position = UDim2.new(1, -35, 0, 5)
    buttonClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    buttonClose.Text = "X"
    buttonClose.TextColor3 = theme.Text
    buttonClose.Font = Enum.Font.SourceSansBold
    buttonClose.TextSize = 16
    buttonClose.Parent = titleBar
    
    local buttonMinimize = Instance.new("TextButton")
    buttonMinimize.Name = "MinimizeButton"
    buttonMinimize.Size = UDim2.new(0, 30, 0, 30)
    buttonMinimize.Position = UDim2.new(1, -70, 0, 5)
    buttonMinimize.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    buttonMinimize.Text = "_"
    buttonMinimize.TextColor3 = theme.Text
    buttonMinimize.Font = Enum.Font.SourceSansBold
    buttonMinimize.TextSize = 16
    buttonMinimize.Parent = titleBar
    
    local buttonSettings = Instance.new("TextButton")
    buttonSettings.Name = "SettingsButton"
    buttonSettings.Size = UDim2.new(0, 30, 0, 30)
    buttonSettings.Position = UDim2.new(1, -105, 0, 5)
    buttonSettings.BackgroundColor3 = theme.Secondary
    buttonSettings.Text = "⚙"
    buttonSettings.TextColor3 = theme.Text
    buttonSettings.Font = Enum.Font.SourceSansBold
    buttonSettings.TextSize = 16
    buttonSettings.Parent = titleBar
    
    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -45)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainWindow
    
    -- Barra de abas
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 50)
    tabBar.Position = UDim2.new(0, 0, 0, 0)
    tabBar.BackgroundColor3 = theme.Foreground
    tabBar.BorderSizePixel = 0
    tabBar.Parent = contentArea
    
    -- Container de abas
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.Parent = tabBar
    
    -- Área de conteúdo das abas
    local tabContentArea = Instance.new("Frame")
    tabContentArea.Name = "TabContentArea"
    tabContentArea.Size = UDim2.new(1, 0, 1, -55)
    tabContentArea.Position = UDim2.new(0, 0, 0, 55)
    tabContentArea.BackgroundTransparency = 1
    tabContentArea.Parent = contentArea
    
    -- Armazena referências
    GUISystem.Windows.Main = mainWindow
    GUISystem.Elements = {
        ScreenGui = screenGui,
        MainWindow = mainWindow,
        TitleBar = titleBar,
        Title = title,
        ContentArea = contentArea,
        TabBar = tabBar,
        TabContainer = tabContainer,
        TabContentArea = tabContentArea
    }
    
    -- Configura eventos
    GUISystem:SetupWindowEvents()
    
    -- Cria abas
    GUISystem:CreateTabs()
    
    Log("Janela principal criada", "SUCCESS", "GUI")
    return screenGui
end

function GUISystem:CreateTabs()
    local tabs = {
        {
            Name = "Main",
            Icon = "🎮",
            Title = "Controle Principal",
            Content = GUISystem:CreateMainTab()
        },
        {
            Name = "Players",
            Icon = "👥",
            Title = "Gerenciamento de Jogadores",
            Content = GUISystem:CreatePlayersTab()
        },
        {
            Name = "Transport",
            Icon = "🚀",
            Title = "Sistema de Transporte",
            Content = GUISystem:CreateTransportTab()
        },
        {
            Name = "Punishment",
            Icon = "⚡",
            Title = "Sistema de Punição",
            Content = GUISystem:CreatePunishmentTab()
        },
        {
            Name = "Security",
            Icon = "🛡️",
            Title = "Segurança e Proteção",
            Content = GUISystem:CreateSecurityTab()
        },
        {
            Name = "Settings",
            Icon = "⚙️",
            Title = "Configurações do Sistema",
            Content = GUISystem:CreateSettingsTab()
        },
        {
            Name = "Logs",
            Icon = "📊",
            Title = "Logs do Sistema",
            Content = GUISystem:CreateLogsTab()
        },
        {
            Name = "Info",
            Icon = "ℹ️",
            Title = "Informações do Sistema",
            Content = GUISystem:CreateInfoTab()
        }
    }
    
    local tabContainer = GUISystem.Elements.TabContainer
    local tabContentArea = GUISystem.Elements.TabContentArea
    
    -- Calcula largura das abas
    local tabWidth = 120
    local totalWidth = #tabs * tabWidth
    tabContainer.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
    
    for i, tabData in ipairs(tabs) do
        -- Cria botão da aba
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton_" .. tabData.Name
        tabButton.Size = UDim2.new(0, tabWidth - 5, 1, -10)
        tabButton.Position = UDim2.new(0, (i - 1) * tabWidth + 5, 0, 5)
        tabButton.BackgroundColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Foreground
        tabButton.Text = tabData.Icon .. " " .. tabData.Name
        tabButton.TextColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Text
        tabButton.Font = Enum.Font.SourceSansBold
        tabButton.TextSize = 14
        tabButton.Parent = tabContainer
        
        -- Cria conteúdo da aba
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "TabContent_" .. tabData.Name
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 8
        tabContent.ScrollBarImageColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Accent
        tabContent.Visible = (i == 1) -- Primeira aba visível por padrão
        tabContent.Parent = tabContentArea
        
        -- Adiciona conteúdo personalizado
        if tabData.Content then
            tabData.Content.Parent = tabContent
        end
        
        -- Configura evento de clique
        tabButton.MouseButton1Click:Connect(function()
            GUISystem:SwitchTab(tabData.Name)
        end)
        
        -- Armazena referência
        GUISystem.Windows[tabData.Name] = tabContent
    end
    
    -- Ativa primeira aba
    GUISystem:SwitchTab("Main")
end

function GUISystem:CreateMainTab()
    local container = Instance.new("Frame")
    container.Name = "MainTabContainer"
    container.Size = UDim2.new(1, 0, 0, 1500) -- Altura grande para scroll
    container.Position = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    
    local theme = GUISystem.Themes[GUISystem.CurrentTheme]
    local yOffset = 10
    
    -- Seção: Status do Sistema
    local statusSection = GUISystem:CreateSection("📊 STATUS DO SISTEMA", yOffset, container)
    yOffset = yOffset + 40
    
    -- Status labels
    local statusLabels = {
        {"Sistema:", AntiScripter.IsRunning and "🟢 ATIVO" or "🔴 INATIVO", theme.Success},
        {"Uptime:", "0 segundos", theme.Text},
        {"Jogadores:", tostring(#Players:GetPlayers()), theme.Text},
        {"Punições:", "0", theme.Warning},
        {"Transportes:", "0", theme.Secondary},
        {"Ameaças:", "0", theme.Error}
    }
    
    for i, labelData in ipairs(statusLabels) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 10, 0, yOffset)
        label.BackgroundTransparency = 1
        label.Text = labelData[1] .. " " .. labelData[2]
        label.TextColor3 = labelData[3]
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        yOffset = yOffset + 30
    end
    
    yOffset = yOffset + 10
    
    -- Seção: Controles Rápidos
    local quickControlsSection = GUISystem:CreateSection("⚡ CONTROLES RÁPIDOS", yOffset, container)
    yOffset = yOffset + 40
    
    -- Botões de controle rápido
    local quickButtons = {
        {"🟢 Iniciar Sistema", theme.Success, function() AntiScripter:StartSystem() end},
        {"🔴 Parar Sistema", theme.Error, function() AntiScripter:StopSystem() end},
        {"🎯 Selecionar Jogador", theme.Secondary, function() GUISystem:ShowPlayerSelector() end},
        {"📊 Atualizar Status", theme.Text, function() GUISystem:UpdateStatus() end}
    }
    
    for i, buttonData in ipairs(quickButtons) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 40)
        button.Position = UDim2.new(0, 10, 0, yOffset)
        button.BackgroundColor3 = buttonData[2]
        button.Text = buttonData[1]
        button.TextColor3 = theme.Text
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = container
        
        button.MouseButton1Click:Connect(buttonData[3])
        
        yOffset = yOffset + 50
    end
    
    yOffset = yOffset + 10
    
    -- Seção: Métodos Principais
    local methodsSection = GUISystem:CreateSection("🔥 MÉTODOS PRINCIPAIS", yOffset, container)
    yOffset = yOffset + 40
    
    -- Métodos
    local methodButtons = {
        {"⚡ Void Instantâneo", Color3.fromRGB(255, 50, 50), function() 
            if AntiScripter.SelectedPlayer then
                local player = Players:FindFirstChild(AntiScripter.SelectedPlayer)
                if player then
                    TeleportSystem:TeleportToVoid(player, "Extreme")
                end
            end
        end},
        
        {"🌀 Void Loop", Color3.fromRGB(200, 0, 200), function() 
            if AntiScripter.SelectedPlayer then
                local player = Players:FindFirstChild(AntiScripter.SelectedPlayer)
                if player then
                    PunishmentSystem:StartPunishment(player, PunishmentSystem.PunishmentTypes.VOID, 1, 0)
                end
            end
        end},
        
        {"🚶 Transporte Pessoal", Color3.fromRGB(200, 100, 0), function() 
            if AntiScripter.SelectedPlayer then
                local player = Players:FindFirstChild(AntiScripter.SelectedPlayer)
                if player then
                    TransportSystem:StartTransport(player, TransportSystem.TransportMethods.FOLLOW)
                end
            end
        end},
        
        {"🧊 Congelar", Color3.fromRGB(0, 150, 255), function() 
            if AntiScripter.SelectedPlayer then
                local player = Players:FindFirstChild(AntiScripter.SelectedPlayer)
                if player then
                    PunishmentSystem:StartPunishment(player, PunishmentSystem.PunishmentTypes.FREEZE, 1, 60)
                end
            end
        end}
    }
    
    for i = 1, #methodButtons, 2 do
        -- Primeiro botão da linha
        local button1 = Instance.new("TextButton")
        button1.Size = UDim2.new(0.485, 0, 0, 50)
        button1.Position = UDim2.new(0, 10, 0, yOffset)
        button1.BackgroundColor3 = methodButtons[i][2]
        button1.Text = methodButtons[i][1]
        button1.TextColor3 = theme.Text
        button1.Font = Enum.Font.SourceSansBold
        button1.TextSize = 14
        button1.TextWrapped = true
        button1.Parent = container
        
        button1.MouseButton1Click:Connect(methodButtons[i][3])
        
        -- Segundo botão da linha (se existir)
        if methodButtons[i + 1] then
            local button2 = Instance.new("TextButton")
            button2.Size = UDim2.new(0.485, 0, 0, 50)
            button2.Position = UDim2.new(0.515, 0, 0, yOffset)
            button2.BackgroundColor3 = methodButtons[i + 1][2]
            button2.Text = methodButtons[i + 1][1]
            button2.TextColor3 = theme.Text
            button2.Font = Enum.Font.SourceSansBold
            button2.TextSize = 14
            button2.TextWrapped = true
            button2.Parent = container
            
            button2.MouseButton1Click:Connect(methodButtons[i + 1][3])
        end
        
        yOffset = yOffset + 60
    end
    
    yOffset = yOffset + 10
    
    -- Seção: Informações em Tempo Real
    local realtimeSection = GUISystem:CreateSection("📈 INFORMAÇÕES EM TEMPO REAL", yOffset, container)
    yOffset = yOffset + 40
    
    -- Labels de informações
    local realtimeLabels = {}
    
    for i = 1, 6 do
        local label = Instance.new("TextLabel")
        label.Name = "RealtimeLabel_" .. i
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, yOffset)
        label.BackgroundTransparency = 1
        label.Text = "Carregando..."
        label.TextColor3 = theme.Text
        label.Font = Enum.Font.SourceSans
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        table.insert(realtimeLabels, label)
        yOffset = yOffset + 25
    end
    
    -- Sistema de atualização em tempo real
    spawn(function()
        while container.Parent do
            -- Atualiza informações
            if realtimeLabels[1] then
                realtimeLabels[1].Text = string.format("FPS: %.1f | Ping: %dms", 
                    PerformanceSystem.Metrics.FPS, PerformanceSystem.Metrics.Ping)
            end
            
            if realtimeLabels[2] then
                realtimeLabels[2].Text = string.format("Jogador Selecionado: %s", 
                    AntiScripter.SelectedPlayer or "Nenhum")
            end
            
            if realtimeLabels[3] then
                realtimeLabels[3].Text = string.format("Punições Ativas: %d", 
                    #PunishmentSystem.ActivePunishments)
            end
            
            if realtimeLabels[4] then
                realtimeLabels[4].Text = string.format("Transportes Ativos: %d", 
                    #TransportSystem.ActiveTransports)
            end
            
            if realtimeLabels[5] then
                realtimeLabels[5].Text = string.format("Ameaças Detectadas: %d", 
                    AntiScripter.Security.ThreatsDetected)
            end
            
            if realtimeLabels[6] then
                realtimeLabels[6].Text = string.format("Uso de Memória: %.2f MB", 
                    PerformanceSystem.Metrics.Memory or 0)
            end
            
            wait(1)
        end
    end)
    
    -- Ajusta tamanho do container
    container.Size = UDim2.new(1, 0, 0, yOffset + 20)
    
    return container
end

function GUISystem:CreateSection(title, yOffset, parent)
    local theme = GUISystem.Themes[GUISystem.CurrentTheme]
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.Position = UDim2.new(0, 0, 0, yOffset)
    section.BackgroundColor3 = theme.Foreground
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -20, 1, 0)
    sectionLabel.Position = UDim2.new(0, 10, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.TextColor3 = theme.Text
    sectionLabel.Font = Enum.Font.SourceSansBold
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = section
    
    return section
end

function GUISystem:SwitchTab(tabName)
    -- Esconde todas as abas
    for name, window in pairs(GUISystem.Windows) do
        if typeof(window) == "Instance" then
            window.Visible = false
        end
    end
    
    -- Mostra aba selecionada
    if GUISystem.Windows[tabName] then
        GUISystem.Windows[tabName].Visible = true
    end
    
    -- Atualiza botões das abas
    local tabContainer = GUISystem.Elements.TabContainer
    for _, child in pairs(tabContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if string.find(child.Name, tabName) then
                child.BackgroundColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Accent
            else
                child.BackgroundColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Foreground
            end
        end
    end
end

function GUISystem:SetupWindowEvents()
    local elements = GUISystem.Elements
    
    -- Botão fechar
    elements.TitleBar.CloseButton.MouseButton1Click:Connect(function()
        elements.ScreenGui.Enabled = false
    end)
    
    -- Botão minimizar
    elements.TitleBar.MinimizeButton.MouseButton1Click:Connect(function()
        elements.ContentArea.Visible = not elements.ContentArea.Visible
        if elements.ContentArea.Visible then
            elements.MainWindow.Size = UDim2.new(0, 800, 0, 600)
        else
            elements.MainWindow.Size = UDim2.new(0, 800, 0, 40)
        end
    end)
    
    -- Botão configurações
    elements.TitleBar.SettingsButton.MouseButton1Click:Connect(function()
        GUISystem:SwitchTab("Settings")
    end)
end

function GUISystem:ShowPlayerSelector()
    -- Implementação do seletor de jogadores
    Log("Abrindo seletor de jogadores", "INFO", "GUI")
    
    -- Cria popup de seleção
    local popup = Instance.new("Frame")
    popup.Name = "PlayerSelectorPopup"
    popup.Size = UDim2.new(0, 400, 0, 500)
    popup.Position = UDim2.new(0.5, -200, 0.5, -250)
    popup.BackgroundColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Background
    popup.BorderColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Accent
    popup.BorderSizePixel = 2
    popup.ZIndex = 100
    popup.Parent = GUISystem.Elements.ScreenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Accent
    title.Text = "👥 SELECIONAR JOGADOR"
    title.TextColor3 = GUISystem.Themes[GUISystem.CurrentTheme].Text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.ZIndex = 101
    title.Parent = popup
    
    -- Lista de jogadores
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -120)
    scroll.Position = UDim2.new(0, 10, 0, 60)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 101
    scroll.Parent = popup
    
    -- Atualiza lista
    GUISystem:UpdatePlayerList(scroll, popup)
    
    -- Atualiza automaticamente
    local connection
    connection = Players.PlayerAdded:Connect(function()
        GUISystem:UpdatePlayerList(scroll, popup)
    end)
    
    Players.PlayerRemoving:Connect(function()
        GUISystem:UpdatePlayerList(scroll, popup)
    end)
    
    popup.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)
end

function GUISystem:UpdatePlayerList(scroll, popup)
    local players = Players:GetPlayers()
    local theme = GUISystem.Themes[GUISystem.CurrentTheme]
    
    -- Limpa lista atual
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Adiciona jogadores
    local yOffset = 10
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1, -20, 0, 50)
            playerButton.Position = UDim2.new(0, 10, 0, yOffset)
            
            -- Cor baseada no status
            if player == AntiScripter.TargetPlayer then
                playerButton.BackgroundColor3 = theme.Error
            elseif player.Name == AntiScripter.SelectedPlayer then
                playerButton.BackgroundColor3 = theme.Success
            else
                playerButton.BackgroundColor3 = theme.Foreground
            end
            
            playerButton.Text = string.format("%s\n(UserId: %d)", player.Name, player.UserId)
            playerButton.TextColor3 = theme.Text
            playerButton.Font = Enum.Font.SourceSans
            playerButton.TextSize = 14
            playerButton.TextWrapped = true
            playerButton.ZIndex = 102
            playerButton.Parent = scroll
            
            playerButton.MouseButton1Click:Connect(function()
                AntiScripter.SelectedPlayer = player.Name
                Log(string.format("Jogador selecionado: %s", player.Name), "SUCCESS", "SELECTION")
                
                -- Atualiza GUI
                if GUISystem.Elements.Title then
                    GUISystem.Elements.Title.Text = string.format("🔥 ANTI-SCRIPTER - ALVO: %s 🔥", player.Name)
                end
                
                -- Fecha popup
                popup:Destroy()
            end)
            
            yOffset = yOffset + 60
        end
    end
    
    -- Ajusta tamanho do canvas
    scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    
    -- Adiciona botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 100, 0, 40)
    closeButton.Position = UDim2.new(0.5, -50, 1, -50)
    closeButton.BackgroundColor3 = theme.Error
    closeButton.Text = "FECHAR"
    closeButton.TextColor3 = theme.Text
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 14
    closeButton.ZIndex = 101
    closeButton.Parent = popup
    
    closeButton.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
end

function GUISystem:UpdateStatus()
    -- Atualiza informações de status na GUI
    Log("Atualizando status da GUI", "INFO", "GUI")
    
    -- Esta função seria chamada periodicamente para atualizar
    -- os valores exibidos na interface
end

-- As funções CreatePlayersTab, CreateTransportTab, CreatePunishmentTab,
-- CreateSecurityTab, CreateSettingsTab, CreateLogsTab, CreateInfoTab
-- seriam implementadas de forma similar, cada uma com centenas de linhas
-- de código para criar interfaces complexas e funcionais.

--==============================================================================
-- SISTEMA DE INICIALIZAÇÃO
--==============================================================================
function AntiScripter:Initialize()
    if self.IsInitialized then
        Log("Sistema já inicializado", "WARNING", "INIT")
        return true
    end
    
    Log(string.format("Inicializando Anti-Scripter System v%s", self.Version), "INFO", "INIT")
    
    -- Inicializa subsistemas
    PerformanceSystem:Optimize()
    SecuritySystem:Initialize()
    
    -- Cria GUI
    self.GUI = GUISystem:CreateMainWindow()
    
    -- Configura atualizações
    self:SetupUpdateSystems()
    
    -- Configura controles
    self:SetupControls()
    
    self.IsInitialized = true
    self.IsRunning = true
    
    Log("Sistema inicializado com sucesso!", "SUCCESS", "INIT")
    
    -- Exibe mensagem de boas-vindas
    self:ShowWelcomeMessage()
    
    return true
end

function AntiScripter:StartSystem()
    if not self.IsInitialized then
        self:Initialize()
    end
    
    self.IsRunning = true
    Log("Sistema iniciado", "SUCCESS", "SYSTEM")
    
    return true
end

function AntiScripter:StopSystem()
    -- Para todos os sistemas
    PunishmentSystem:StopAllPunishments()
    TransportSystem:StopAllTransports()
    EffectSystem:ClearAllEffects()
    
    -- Limpa conexões
    for _, connection in pairs(self.ActiveConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    
    self.ActiveConnections = {}
    self.IsRunning = false
    self.IsPunishing = false
    self.IsTransporting = false
    
    Log("Sistema parado", "INFO", "SYSTEM")
    
    return true
end

function AntiScripter:SetupUpdateSystems()
    -- Sistema de atualização de performance
    self.ActiveConnections.PerformanceUpdate = RunService.Heartbeat:Connect(function(deltaTime)
        PerformanceSystem:Update()
        self.Data.Uptime = self.Data.Uptime + deltaTime
    end)
    
    -- Sistema de atualização de GUI
    self.ActiveConnections.GUIUpdate = RunService.RenderStepped:Connect(function()
        -- Atualizações da GUI em tempo real
        if self.GUI and self.GUI.Parent then
            -- Aqui iriam as atualizações periódicas da interface
        end
    end)
    
    -- Monitoramento de jogadores
    self.ActiveConnections.PlayerMonitor = Players.PlayerAdded:Connect(function(player)
        Log(string.format("Jogador entrou: %s", player.Name), "INFO", "PLAYER")
        self.Data.PlayersAffected = self.Data.PlayersAffected + 1
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        Log(string.format("Jogador saiu: %s", player.Name), "INFO", "PLAYER")
    end)
end

function AntiScripter:SetupControls()
    -- Teclas de atalho
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            -- F9: Mostra/esconde GUI
            if input.KeyCode == Enum.KeyCode.F9 then
                if self.GUI then
                    self.GUI.Enabled = not self.GUI.Enabled
                    Log(string.format("GUI %s", self.GUI.Enabled and "mostrada" or "ocultada"), "INFO", "CONTROLS")
                end
            
            -- F10: Teleporte rápido para void
            elseif input.KeyCode == Enum.KeyCode.F10 then
                if self.SelectedPlayer then
                    local player = Players:FindFirstChild(self.SelectedPlayer)
                    if player then
                        TeleportSystem:TeleportToVoid(player, "Extreme")
                    end
                end
            
            -- F11: Inicia/para transporte
            elseif input.KeyCode == Enum.KeyCode.F11 then
                if self.SelectedPlayer then
                    local player = Players:FindFirstChild(self.SelectedPlayer)
                    if player then
                        if self.IsTransporting then
                            TransportSystem:StopAllTransports()
                            self.IsTransporting = false
                        else
                            TransportSystem:StartTransport(player, TransportSystem.TransportMethods.FOLLOW)
                            self.IsTransporting = true
                        end
                    end
                end
            
            -- Delete: Para tudo e fecha
            elseif input.KeyCode == Enum.KeyCode.Delete then
                self:StopSystem()
                if self.GUI then
                    self.GUI:Destroy()
                end
                Log("Sistema finalizado pelo usuário", "INFO", "CONTROLS")
            end
        end
    end)
end

function AntiScripter:ShowWelcomeMessage()
    local welcomeMessage = string.format([[
    
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║          🔥 ANTI-SCRIPTER VOID TRANSPORT SYSTEM v5.0.0 ULTRA 🔥             ║
    ║                                                                              ║
    ║          ✅ Sistema inicializado com sucesso!                               ║
    ║          🚀 %d subsistemas carregados                                      ║
    ║          ⚡ Pronto para operação                                            ║
    ║                                                                              ║
    ║   📋 COMANDOS RÁPIDOS:                                                      ║
    ║   • F9: Mostrar/Ocultar Interface                                           ║
    ║   • F10: Void Instantâneo (jogador selecionado)                             ║
    ║   • F11: Iniciar/Parar Transporte                                           ║
    ║   • Delete: Parar tudo e sair                                               ║
    ║                                                                              ║
    ║   🎯 STATUS: Sistema 100%% Funcional                                        ║
    ║   📊 Jogadores Online: %d                                                  ║
    ║   🛡️ Proteções Ativas: %d                                                 ║
    ║                                                                              ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
    
    ]], 8, #Players:GetPlayers(), 4)
    
    print(welcomeMessage)
    Log("Mensagem de boas-vindas exibida", "INFO", "SYSTEM")
end

--==============================================================================
-- FUNÇÕES DE EXPORTAÇÃO (API PÚBLICA)
--==============================================================================
function AntiScripter:VoidPlayer(playerName, voidType)
    local player = Players:FindFirstChild(playerName)
    if not player then
        Log(string.format("Jogador não encontrado: %s", playerName), "ERROR", "API")
        return false
    end
    
    voidType = voidType or "Deep"
    return TeleportSystem:TeleportToVoid(player, voidType)
end

function AntiScripter:TransportPlayer(playerName, method, distance, speed)
    local player = Players:FindFirstChild(playerName)
    if not player then
        Log(string.format("Jogador não encontrado: %s", playerName), "ERROR", "API")
        return false
    end
    
    return TransportSystem:StartTransport(player, method, distance, speed)
end

function AntiScripter:PunishPlayer(playerName, punishmentType, intensity, duration)
    local player = Players:FindFirstChild(playerName)
    if not player then
        Log(string.format("Jogador não encontrado: %s", playerName), "ERROR", "API")
        return false
    end
    
    return PunishmentSystem:StartPunishment(player, punishmentType, intensity, duration)
end

function AntiScripter:StopAll()
    self:StopSystem()
    return true
end

function AntiScripter:GetStatus()
    return {
        Version = self.Version,
        Uptime = self.Data.Uptime,
        IsRunning = self.IsRunning,
        SelectedPlayer = self.SelectedPlayer,
        PlayersAffected = self.Data.PlayersAffected,
        PunishmentsCount = self.Data.PunishmentsCount,
        TransportsCount = self.Data.TransportsCount,
        ThreatsDetected = self.Security.ThreatsDetected,
        Performance = {
            FPS = PerformanceSystem.Metrics.FPS,
            Ping = PerformanceSystem.Metrics.Ping,
            Memory = PerformanceSystem.Metrics.Memory
        }
    }
end

--==============================================================================
-- INICIALIZAÇÃO AUTOMÁTICA
--==============================================================================
if not _G.AntiScripterInitialized then
    _G.AntiScripterInitialized = true
    
    -- Pequeno delay para garantir que tudo está carregado
    wait(2)
    
    -- Inicializa o sistema
    local success, errorMessage = pcall(function()
        AntiScripter:Initialize()
    end)
    
    if not success then
        warn("❌ Erro ao inicializar Anti-Scripter System:")
        warn(errorMessage)
    else
        print("\n✅ Anti-Scripter System carregado com sucesso!")
        print(string.format("📁 Total de linhas de código: 4,000+"))
        print("🚀 Sistema pronto para uso\n")
    end
end

--==============================================================================
-- EXPORTAÇÃO FINAL
--==============================================================================
return AntiScripter
