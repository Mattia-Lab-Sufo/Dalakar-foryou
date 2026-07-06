-- Caricamento della libreria Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Emergency Hamburg....",
    LoadingTitle = "Iniezione Moduli Avanzati...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- VARIABILI DI STATO GLOBALI
local Config = {
    -- Combat & Aim
    SilentAim = false,
    AimbotPC = false,
    AimbotMobile = false,
    FOV = 150,
    Smoothness = 0.15,
    TargetPart = "Head",
    -- Visuals (ESP)
    EspPlayers = false,
    EspColor = Color3.fromRGB(255, 0, 0),
    -- Utilities & Anti-Game
    AntiAFK = false,
    AntiKick = false,
    InfStamina = false,
    -- Weapons & Vehicles
    NoRecoil = false,
    VehicleCrosshair = false,
    -- Skybox
    SelectedSky = "Default"
}

-- SCHEDE DELL'INTERFACCIA (TAB)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals (ESP)", 4483362458)
local UtilsTab = Window:CreateTab("🛡️ Anti-Game & Utils", 4483362458)
local WeaponTab = Window:CreateTab("🔫 Weapons & Cars", 4483362458)
local WorldTab = Window:CreateTab("🌌 World & Sky", 4483362458)

-- ====================================================================
-- 1. SEZIONE COMBAT (SILENT AIM & AIMBOT PC/MOBILE)
-- ====================================================================
CombatTab:CreateSection("Silent Aim (Metamethod Hook)")
CombatTab:CreateToggle({
    Name = "Attiva Silent Aim",
    CurrentValue = Config.SilentAim,
    Flag = "ToggleSilent",
    Callback = function(Value) Config.SilentAim = Value end,
})

CombatTab:CreateSection("Aimbot Selettivo Hardware")
CombatTab:CreateToggle({
    Name = "Attiva Aimbot PC (Mouse Hold)",
    CurrentValue = Config.AimbotPC,
    Flag = "TogglePC",
    Callback = function(Value) Config.AimbotPC = Value end,
})

CombatTab:CreateToggle({
    Name = "Attiva Aimbot Mobile (Auto-Lock)",
    CurrentValue = Config.AimbotMobile,
    Flag = "ToggleMobile",
    Callback = function(Value) Config.AimbotMobile = Value end,
})

CombatTab:CreateSection("Configurazioni Mira")
CombatTab:CreateSlider({
    Name = "Raggio FOV (Pixel)",
    Min = 50,
    Max = 500,
    CurrentValue = Config.FOV,
    Increment = 10,
    ValueName = "px",
    Callback = function(Value) Config.FOV = Value end,
})

CombatTab:CreateDropdown({
    Name = "Punto di Puntamento",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = {Config.TargetPart},
    Flag = "DropTarget",
    Callback = function(Option) Config.TargetPart = Option[1] end,
})

-- ====================================================================
-- 2. SEZIONE VISUALS (ESP)
-- ====================================================================
VisualsTab:CreateSection("Wallhack & Tracciatori")
VisualsTab:CreateToggle({
    Name = "Chamber ESP Giocatori (Highlight)",
    CurrentValue = Config.EspPlayers,
    Flag = "ToggleEsp",
    Callback = function(Value) Config.EspPlayers = Value end,
})

VisualsTab:CreateColorPicker({
    Name = "Colore Contorno ESP",
    Color = Config.EspColor,
    Callback = function(Value) Config.EspColor = Value end
})

-- ====================================================================
-- 3. SEZIONE UTILITIES & ANTI-GAME
-- ====================================================================
UtilsTab:CreateSection("Bypass di Gioco")
UtilsTab:CreateToggle({
    Name = "Attiva Anti-AFK (Bypass Disconnessione)",
    CurrentValue = Config.AntiAFK,
    Flag = "ToggleAFK",
    Callback = function(Value) Config.AntiAFK = Value end,
})

UtilsTab:CreateToggle({
    Name = "Protezione Anti-Kick Remoto",
    CurrentValue = Config.AntiKick,
    Flag = "ToggleKick",
    Callback = function(Value) Config.AntiKick = Value end,
})

UtilsTab:CreateToggle({
    Name = "Stamina Infinita (Inf Stamina)",
    CurrentValue = Config.InfStamina,
    Flag = "ToggleStam",
    Callback = function(Value) Config.InfStamina = Value end,
})

-- ====================================================================
-- 4. SEZIONE WEAPONS & VEHICLES (MOD ARMI E MIRINI AUTO)
-- ====================================================================
WeaponTab:CreateSection("Modifiche Armi")
WeaponTab:CreateToggle({
    Name = "Rimuovi Rinculo (No Recoil / Spread)",
    CurrentValue = Config.NoRecoil,
    Flag = "ToggleRecoil",
    Callback = function(Value) Config.NoRecoil = Value end,
})

WeaponTab:CreateSection("Modifiche Veicoli")
WeaponTab:CreateToggle({
    Name = "Abilita Mirino per le Auto (Crosshair in Guida)",
    CurrentValue = Config.VehicleCrosshair,
    Flag = "ToggleCross",
    Callback = function(Value) Config.VehicleCrosshair = Value end,
})

-- ====================================================================
-- 5. SEZIONE WORLD (CIELI MODIFICATI)
-- ====================================================================
WorldTab:CreateSection("Skybox Changer")
WorldTab:CreateDropdown({
    Name = "Seleziona Cielo",
    Options = {"Default", "Spazio Profondo", "Notte Viola", "Tramonto Anime"},
    CurrentOption = {Config.SelectedSky},
    Flag = "DropSky",
    Callback = function(Option)
        Config.SelectedSky = Option[1]
        local Lighting = game:GetService("Lighting")
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        
        if Config.SelectedSky == "Spazio Profondo" then
            sky.SkyboxBk = "rbxassetid://6008860447" sky.SkyboxDn = "rbxassetid://6008860555"
            sky.SkyboxFt = "rbxassetid://6008860641" sky.SkyboxLf = "rbxassetid://6008860734"
            sky.SkyboxRt = "rbxassetid://6008860841" sky.SkyboxUp = "rbxassetid://6008860931"
        elseif Config.SelectedSky == "Notte Viola" then
            sky.SkyboxBk = "rbxassetid://1313364491" sky.SkyboxDn = "rbxassetid://1313364654"
            sky.SkyboxFt = "rbxassetid://1313364741" sky.SkyboxLf = "rbxassetid://1313364843"
            sky.SkyboxRt = "rbxassetid://1313365022" sky.SkyboxUp = "rbxassetid://1313365147"
        elseif Config.SelectedSky == "Tramonto Anime" then
            sky.SkyboxBk = "rbxassetid://264907339" sky.SkyboxDn = "rbxassetid://264907963"
            sky.SkyboxFt = "rbxassetid://264908151" sky.SkyboxLf = "rbxassetid://264908323"
            sky.SkyboxRt = "rbxassetid://264908479" sky.SkyboxUp = "rbxassetid://264908643"
        end
    end,
})

-- ====================================================================
-- MOTORI DI LOGICA IN BACKGROUND & HOOKING DI PROTEZIONE
-- ====================================================================
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Interfaccia Mirino per le Auto (Crosshair GUI)
local CrosshairGui = Instance.new("ScreenGui")
local CrossDot = Instance.new("Frame")
CrosshairGui.Name = "VehicleCrossGui"
CrossDot.Size = UDim2.new(0, 6, 0, 6)
CrossDot.Position = UDim2.new(0.5, -3, 0.5, -3)
CrossDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CrossDot.AnchorPoint = Vector2.new(0.5, 0.5)
CrossDot.Parent = CrosshairGui

-- Trova il bersaglio valido più vicino
local function getClosestTarget()
    local target = nil
    local shortestDistance = math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild(Config.TargetPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < Config.FOV and distance < shortestDistance then
                        shortestDistance = distance
                        target = part
                    end
                end
            end
        end
    end
    return target
end

-- HOOKING PER SILENT AIM (Metodo DarkHub integrato)
local gmt = getrawmetatable(game)
local oldIndex = gmt.__index
setreadonly(gmt, false)
gmt.__index = newcclosure(function(self, idx)
    if Config.SilentAim and checkcaller() == false and self == LocalPlayer:GetMouse() then
        if idx == "Hit" or idx == "Target" then
            local target = getClosestTarget()
            if target then
                return idx == "Hit" and target.CFrame or target
            end
        end
    end
    return oldIndex(self, idx)
end)
setreadonly(gmt, true)

-- BYPASS ANTI-KICK & PROTEZIONE PAUSA
if hookfunction then
    local oldKick
    oldKick = hookfunction(LocalPlayer.Kick, function(self, ...)
        if Config.AntiKick then
            Rayfield:Notify({Title = "Bypass", Content = "Tentativo di Kick Server Bloccato!", Duration = 3})
            return nil
        end
        return oldKick(self, ...)
    end)
end

-- ANTI-AFK AUTOMATICO
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- LOOP DI RENDERING GENERALE (RenderStepped per massima reattività)
RunService.RenderStepped:Connect(function()
    -- Gestione ESP
    for _, p in pairs(game.
