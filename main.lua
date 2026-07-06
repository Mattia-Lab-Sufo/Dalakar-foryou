-- Script Rayfield con Aimbot Mobile, FOV, Whitelist, e Antiban

local aimbot = false
local fov = 100
local whitelist = {"Player1", "Player2"} -- Aggiungi i nomi dei giocatori che non devono essere bersagliati
local antiban = true
local aimbot_mobile = false

local function isMobile()
    return game:GetService("UserInputService"):GetKeyboardInputEnabled() == false
end

local function aimbotMain()
    if aimbot and isMobile() and aimbot_mobile then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()

        local target = nil
        local closest = math.huge

        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Name:lower() ~= "localplayer" and not table.find(whitelist, v.Name:lower()) then
                local root = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local pos = root.Position
                    local distance = (pos - player.Character.HumanoidRootPart.Position).Magnitude
                    local angle = math.atan2(pos.Y - player.Character.HumanoidRootPart.Position.Y, pos.X - player.Character.HumanoidRootPart.Position.X)
                    local angle_deg = math.deg(angle)

                    if distance < closest then
                        closest = distance
                        target = v
                    end
                end
            end
        end

        if target then
            local root = target.Character.HumanoidRootPart
            local pos = root.Position
            local direction = (pos - player.Character.HumanoidRootPart.Position).Unit

            local x, y = math.cos(direction.X), math.sin(direction.Y)
            local aim = CFrame.new(player.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart.Position + Vector3.new(x * 100, y * 100, 0))

            local angle = math.atan2(direction.Y, direction.X)
            local angle_deg = math.deg(angle)

            if math.abs(angle_deg) < fov then
                mouse.MoveMouseTo(aim.p)
                mouse:Button1Down()
                wait(0.05)
                mouse:Button1Up()
            end
        end
    end
end

local function updateAimbot()
    if antiban then
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local mouse = player:GetMouse()

        local aimbotButton = Instance.new("TextButton")
        aimbotButton.Text = "Aimbot Mobile"
        aimbotButton.Size = UDim2.new(0.2, 0, 0.1, 0)
        aimbotButton.Position = UDim2.new(0.75, 0, 0.85, 0)
        aimbotButton.Parent = game:GetService("CoreGui").PlayerGui.ScreenGui

        aimbotButton.MouseButton1Click:Connect(function()
            aimbot_mobile = not aimbot_mobile
            aimbotButton.Text = aimbot_mobile and "Aimbot Mobile ON" or "Aimbot Mobile OFF"
        end)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    aimbotMain()
end)

updateAimbot()
