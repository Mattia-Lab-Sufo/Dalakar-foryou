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
    FOV = 100,
    AntiBan = true,
    AimbotMobile = false,
    Whitelist = {"player1", "player2"} -- Nomi inseriti in minuscolo per controlli precisi
}

-- FUNZIONE DI SERVIZIO: Rilevamento Mobile
local function isMobile()
    return game:GetService("UserInputService"):GetKeyboardInputEnabled() == false
end

-- CREAZIONE DELLE TAB (SCHEDE)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Impostazioni", 4483362458)

-- ELEMENTI NELLA SCHEDA COMBAT
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
    Max = 300,
    CurrentValue = State.FOV,
    Increment = 5,
    ValueName = "Gradi/Distanza",
    Callback = function(Value)
        State.FOV = Value
    end,
})

-- ELEMENTI NELLA SCHEDA IMPOSTAZIONI
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

-- LOGICA DELL'AIMBOT OTTIMIZZATA PER ROBLOX (LATO TELECAMERA)
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

local function getClosestPlayer()
    local target = nil
    local closestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Controllo Whitelist
            if not table.find(State.Whitelist, v.Name:lower()) then
                local rootPart = v.Character.HumanoidRootPart
                
                -- Converte la posizione 3D del bersaglio nello schermo 2D
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Calcola la distanza dal centro dello schermo (puntamento reale)
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    -- Verifica se il bersaglio rientra nel FOV grafico impostato
                    if distance2D < State.FOV and distance2D < closestDistance then
                        closestDistance = distance2D
                        target = rootPart
                    end
                end
            end
        end
    end
    return target
end

-- LOOP DI RENDERING (Heartbeat per massima reattività senza lag)
game:GetService("RunService").Heartbeat:Connect(function()
    -- Se l'aimbot è attivo, e passa i controlli mobile impostati dall'utente
    if State.Aimbot then
        if not isMobile() or (isMobile() and State.AimbotMobile) then
            local targetPart = getClosestPlayer()
            if targetPart then
                -- Sposta fluidamente la visuale (Camera) verso l'HumanoidRootPart del bersaglio
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end
end)

-- Notifica finale di caricamento completato
Rayfield:Notify({
    Title = "Script Caricato",
    Content = "L'interfaccia Rayfield è pronta all'uso.",
    Duration = 5,
    Image = 4483362458,
})
