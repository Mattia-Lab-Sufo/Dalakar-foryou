-- Caricamento della libreria Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Creazione della Finestra Principale
local Window = Rayfield:CreateWindow({
    Name = "Dalakar-cheat",
    LoadingTitle = "Inizializzazione Moduli...",
    LoadingSubtitle = "by Dalakar",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- VARIABILI DI STATO GLOBAL
local State = {
    Aimbot = false,
    FOV = 120,
    EspGiocatori = false,
    EspColore = Color3.fromRGB(255, 0, 0),
    Whitelist = {"player1", "player2"}
}

-- CREAZIONE DELLE SCHEDE (TAB)
local CombatTab = Window:CreateTab("⚔️ Combattimento", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visivi (ESP)", 4483362458)

-- ==========================================
-- SEZIONE COMBATTIMENTO (AIMBOT SPECIFICO)
-- ==========================================
CombatTab:CreateSection("Mirino Automatico")

CombatTab:CreateToggle({
    Name = "Attiva Aimbot Motorio",
    CurrentValue = State.Aimbot,
    Flag = "AimbotToggle",
    Callback = function(Value)
        State.Aimbot = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Raggio di Aggancio (FOV)",
    Min = 50,
    Max = 400,
    CurrentValue = State.FOV,
    Increment = 10,
    ValueName = "Pixel",
    Callback = function(Value)
        State.FOV = Value
    end,
})

-- ==========================================
-- SEZIONE VISIVI (ESP / WALLHACK)
-- ==========================================
VisualsTab:CreateSection("Wallhack Giocatori")

VisualsTab:CreateToggle({
    Name = "ESP Linee e Riquadri (Highlight)",
    CurrentValue = State.EspGiocatori,
    Flag = "EspToggle",
    Callback = function(Value)
        State.EspGiocatori = Value
    end,
})

-- LOGICA INTERNA SPECIFICA
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 1. FUNZIONE ESP (Crea l'effetto attraverso i muri usando gli Highlight)
local function GestisciESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local giaPresente = char:FindFirstChild("EH_ESP")
            
            if State.EspGiocatori then
                if not giaPresente and char:FindFirstChild("HumanoidRootPart") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "EH_ESP"
                    highlight.FillColor = State.EspColore
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = char
                    highlight.Parent = char
                end
            else
                if giaPresente then
                    giaPresente:Destroy()
                end
            end
        end
    end
end

-- 2. FUNZIONE SEARCH AIMBOT (Trova il bersaglio più vicino al mirino effettivo)
local function getClosestTarget()
    local target = nil
    local closestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if not table.find(State.Whitelist, v.Name:lower()) then
                local part = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance2D < State.FOV and distance2D < closestDistance then
                            closestDistance = distance2D
                            target = part
                        end
                    end
                end
            end
        end
    end
    return target
end

-- 3. LOOP UNIFICATO AD ALTA REATTIVITÀ (RenderStepped)
game:GetService("RunService").RenderStepped:Connect(function()
    -- Gestione Ciclica ESP
    GestisciESP()

    -- Gestione Ciclica Aimbot con sblocco angolare
    if State.Aimbot then
        local targetPart = getClosestTarget()
        if targetPart then
            -- Calcola il Delta di rotazione necessario invece di forzare il CFrame fisso
            local targetLook = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            -- Muove la telecamera tramite interpolazione matematica fluida per scavalcare l'anticheat
            Camera.CFrame = Camera.CFrame:Lerp(targetLook, 0.25) 
        end
    end
end)

-- Pulizia degli ESP se si cambia server o si chiude lo script
LocalPlayer.CharacterRemoving:Connect(function()
    task.wait(1)
    GestisciESP()
end)

Rayfield:Notify({
    Title = "Emergency Module Pronto",
    Content = "Dalakar",
    Duration = 5
})
