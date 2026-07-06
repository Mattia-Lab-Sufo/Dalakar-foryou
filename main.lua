-- Caricamento della libreria Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Creazione della Finestra Principale
local Window = Rayfield:CreateWindow({
    Name = "Golf Combat & Utilities Hub",
    LoadingTitle = "Caricamento Interfaccia...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "CombatConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false
})

-- VARIABILI DI STATO
local State = {
    Aimbot = false,
    FOV = 150, -- Aumentato il FOV di base per facilitare i test iniziale
    AntiBan = true,
    AimbotMobile = false,
    Whitelist = {"player1", "player2"} 
}

-- FUNZIONE DI SERVIZIO: Rilevamento Mobile
local function isMobile()
    return game:GetService("UserInputService"):GetKeyboardInputEnabled() == false
end

-- CREAZIONE DELLE TAB
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Impostazioni", 4483362458)

CombatTab:CreateSection("Aimbot Centrale")

CombatTab:CreateToggle({
    Name = "Attiva Aimbot Generale",
    CurrentValue = State.Aimbot,
    Flag = "ToggleAimbot",
    Callback = function(Value)
        State.Aimbot = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Consenti su Mobile",
    CurrentValue = State.AimbotMobile,
    Flag = "ToggleMobile",
    Callback = function(Value)
        State.AimbotMobile = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Raggio del FOV",
    Min = 10,
    Max = 500,
    CurrentValue = State.FOV,
    Increment = 5,
    ValueName = "Pixel",
    Callback = function(Value)
        State.FOV = Value
    end,
})

SettingsTab:CreateSection("Sicurezza & Whitelist")

SettingsTab:CreateToggle({
    Name = "Simulazione Antiban",
    CurrentValue = State.AntiBan,
    Flag = "ToggleAntiban",
    Callback = function(Value)
        State.AntiBan = Value
    end,
})

SettingsTab:CreateInput({
    Name = "Aggiungi alla Whitelist",
    PlaceholderText = "Nome Giocatore",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        if Text and Text ~= "" then
            table.insert(State.Whitelist, Text:lower())
            Rayfield:Notify({
                Title = "Whitelist Aggiornata",
                Content = Text .. " aggiunto alla lista alleati.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- LOGICA REVISIONATA E FORZATA
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

local function getClosestPlayer()
    local target = nil
    local closestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            -- Controllo che il pezzo da mirare esista (usiamo Head per l'aimbot o HumanoidRootPart)
            local targetPart = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
            
            if targetPart and not table.find(State.Whitelist, v.Name:lower()) then
                -- Calcola posizione sullo schermo
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    -- Se è dentro il cerchio del FOV ed è il più vicino
                    if distance2D < State.FOV and distance2D < closestDistance then
                        closestDistance = distance2D
                        target = targetPart
                    end
                end
            end
        end
    end
    return target
end

-- LOOP DI COERCITIZIONE DELLA TELECAMERA (RenderStepped forza lo spostamento prima del disegno del frame)
game:GetService("RunService").RenderStepped:Connect(function()
    if State.Aimbot then
        if not isMobile() or (isMobile() and State.AimbotMobile) then
            local targetPart = getClosestPlayer()
            if targetPart then
                -- METODO FORZATO: Modifica l'asse di rotazione mantenendo la posizione attuale della camera
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end
end)

Rayfield:Notify({
    Title = "Script Caricato V2",
    Content = "Puntamenti forzati pronti alla massima precisione.",
    Duration = 5,
    Image = 4483362458,
})
