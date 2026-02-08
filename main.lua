-- Código SUPER SIMPLES que funcionaa
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Remove UI antiga
if CoreGui:FindFirstChild("TestMenu") then
    CoreGui.TestMenu:Destroy()
end

-- Cria UI simples
local screen = Instance.new("ScreenGui")
screen.Name = "TestMenu"
screen.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
frame.Visible = false
frame.Parent = screen

local label = Instance.new("TextLabel")
label.Text = "MENU DE TESTE\n\nDigite ;menu no chat\nou pressione M"
label.Size = UDim2.new(1, 0, 1, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.BackgroundTransparency = 1
label.Parent = frame

-- Sistema de chat
Player.Chatted:Connect(function(msg)
    print("Chat: " .. msg)
    if string.lower(string.gsub(msg, "%s+", "")) == ";menu" then
        frame.Visible = not frame.Visible
        print("Menu: " .. (frame.Visible and "ABERTO" or "FECHADO"))
    end
end)

-- Tecla M
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)

print("✅ TESTE CONFIGURADO!")
print("📝 Digite ;menu no chat")
print("🎮 Ou pressione M")
