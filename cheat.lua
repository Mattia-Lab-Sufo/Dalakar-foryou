-- Caricamento della libreria Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "DarkHub Premium Reborn | Emergency Hamburg",
    LoadingTitle = "Iniezione Moduli DarkHub...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- CONFIGURAZIONI IN STILE DARKHUB
local DarkConfig = {
    SilentAim = false,
    FOV = 150,
    ShowCircle = true,
    TargetPart = "Head", -- Head o HumanoidRootPart
    BoxEsp = false,
    Tracers = false,
    HealthBar = false,
    TeamCheck = false
}

-- SCHEDE (TAB)
local CombatTab = Window:CreateTab("⚔️ Silent Aim", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals ESP", 4483362458)

-- ==========================================
-- SEZIONE SILENT AIM (METODO DARKHUB)
-- ==========================================
CombatTab:CreateSection("Aimbot Silenzioso (Mouse Hook)")

CombatTab:CreateToggle({
    Name = "Attiva Silent Aim",
    CurrentValue = DarkConfig.SilentAim,
    Flag = "SilentToggle",
    Callback = function(Value) DarkConfig.SilentAim = Value end,
})

CombatTab:CreateDropdown({
    Name = "Parte del Corpo",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = {DarkConfig.TargetPart},
    Flag = "PartDropdown",
    Callback = function(Option) DarkConfig.TargetPart = Option[1] end,
})

CombatTab:CreateSlider({
    Name = "Raggio FOV",
    Min = 30,
    Max = 500,
    CurrentValue = DarkConfig.FOV,
    Increment = 10,
    ValueName = "px",
    Callback = function(Value) DarkConfig.FOV = Value end,
})

CombatTab:CreateToggle({
    Name = "Mostra Cerchio FOV",
    CurrentValue = DarkConfig.ShowCircle,
    Flag = "CircleToggle",
    Callback = function(Value) DarkConfig.ShowCircle = Value end,
})

-- ==========================================
-- SEZIONE VISUALS (ESP PROFESSIONALE 2D)
-- ==========================================
VisualsTab:CreateSection("Contorni & Tracciatori")

VisualsTab:CreateToggle({
    Name = "Riquadro 2D (Box ESP)",
    CurrentValue = DarkConfig.BoxEsp,
    Flag = "BoxToggle",
    Callback = function(Value) DarkConfig.BoxEsp = Value end,
})

VisualsTab:CreateToggle({
    Name = "Linee di Puntamento (Tracers)",
    CurrentValue = DarkConfig.Tracers,
    Flag = "TracerToggle",
    Callback = function(Value) DarkConfig.Tracers = Value end,
})

VisualsTab:CreateToggle({
    Name = "Barra della Vita (Health)",
    CurrentValue = DarkConfig.HealthBar,
    Flag = "HealthToggle",
    Callback = function(Value) DarkConfig.HealthBar = Value end,
})

-- ==========================================
-- LOGICA DEL SILENT AIM & DRAWING API (DARKHUB CORE)
-- ==========================================
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")

-- Cerchio FOV grafico
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7

-- Trova il bersaglio legittimo per il Silent Aim
local function getClosestClosest()
    local target = nil
    local closestDistance = math.huge
    local mousePos = uis:GetMouseLocation()

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pPart = v.Character:FindFirstChild(DarkConfig.TargetPart)
            if pPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(pPart.Position)
                if onScreen then
                    local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance2D < DarkConfig.FOV and distance2D < closestDistance then
                        closestDistance = distance2D
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- HOOKING DEI METODI DEL MOUSE (Questo reindirizza i proiettili come DarkHub)
local gmt = getrawmetatable(game)
local oldIndex = gmt.__index
setreadonly(gmt, false)

gmt.__index = newcclosure(function(self, idx)
    if DarkConfig.SilentAim and checkcaller() == false then
        if self == LocalPlayer:GetMouse() then
            if idx == "Hit" or idx == "Target" then
                local victim = getClosestClosest()
                if victim and victim.Character and victim.Character:FindFirstChild(DarkConfig.TargetPart) then
                    local hitPart = victim.Character[DarkConfig.TargetPart]
                    if idx == "Hit" then
                        return hitPart.CFrame
                    elseif idx == "Target" then
                        return hitPart
                    end
                end
            end
        end
    end
    return oldIndex(self, idx)
end)
setreadonly(gmt, true)

-- ==========================================
-- MOTORE ESP 2D IN TEMPO REALE
-- ==========================================
local function CreateESP(ply)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 255, 255)
    Tracer.Thickness = 1

    local Health = Drawing.new("Line")
    Health.Visible = false
    Health.Color = Color3.fromRGB(0, 255, 0)
    Health.Thickness = 2

    local cConnect
    cConnect = game:GetService("RunService").RenderStepped:Connect(function()
        if ply and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character:FindFirstChild("Humanoid") and ply.Character.Humanoid.Health > 0 then
            local hrp = ply.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                -- Calcolo dimensioni Box in base alla distanza
                local sizeX = 1000 / screenPos.Z
                local sizeY = 1400 / screenPos.Z
                local posX = screenPos.X - sizeX / 2
                local posY = screenPos.Y - sizeY / 2

                -- Box ESP
                if DarkConfig.BoxEsp then
                    Box.Size = Vector2.new(sizeX, sizeY)
                    Box.Position = Vector2.new(posX, posY)
                    Box.Visible = true
                else Box.Visible = false end

                -- Tracers (Linee dal basso dello schermo)
                if DarkConfig.Tracers then
                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    Tracer.Visible = true
                else Tracer.Visible = false end

                -- Barra della vita
                if DarkConfig.HealthBar then
                    local healthPct = ply.Character.Humanoid.Health / ply.Character.Humanoid.MaxHealth
                    Health.From = Vector2.new(posX - 5, posY + sizeY)
                    Health.To = Vector2.new(posX - 5, posY + (sizeY * (1 - healthPct)))
                    Health.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                    Health.Visible = true
                else Health.Visible = false end
            else
                Box.Visible = false; Tracer.Visible = false; Health.Visible = false
            end
        else
            Box.Visible = false; Tracer.Visible = false; Health.Visible = false
            if not ply or not game.Players:FindFirstChild(ply.Name) then
                Box:Remove(); Tracer:Remove(); Health:Remove()
                cConnect:Disconnect()
            end
        end
    end)
end

-- Assegna ESP ai giocatori attuali e futuri
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
game.Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then CreateESP(p) end
end)

-- Loop di aggiornamento del Cerchio FOV
game:GetService("RunService").RenderStepped:Connect(function()
    if DarkConfig.ShowCircle and DarkConfig.SilentAim then
        FOVCircle.Position = uis:GetMouseLocation()
        FOVCircle.Radius = DarkConfig.FOV
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

Rayfield:Notify({
    Title = "DarkHub Moduli Iniettati",
    Content = "Silent Aim (Metamethod Hook) e Vector ESP pronti.",
    Duration = 5
})
