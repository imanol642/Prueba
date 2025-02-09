-- AutoFarm Level Script para Blox Fruits
-- Este script detecta el mejor NPC, optimiza ataques y evita detección por anti-cheat.

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuración del autofarm
local autofarmConfig = {
    targetNPC = nil,
    weapon = nil,
    safeDistance = 10
}

-- Detectar el mejor NPC según el nivel
local function detectBestNPC()
    local level = player.Data.Level.Value
    local bestNPC = nil
    for _, npc in pairs(workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local npcLevel = npc:FindFirstChild("Level") and npc.Level.Value or 0
            if npcLevel <= level and (not bestNPC or npcLevel > bestNPC.Level.Value) then
                bestNPC = npc
            end
        end
    end
    return bestNPC
end

-- Optimizar el ataque según el arma equipada
local function optimizeAttack()
    if player.Backpack:FindFirstChild("Combat") then
        autofarmConfig.weapon = "Combat"
    elseif player.Backpack:FindFirstChild("Sword") then
        autofarmConfig.weapon = "Sword"
    elseif player.Backpack:FindFirstChild("Fruit") then
        autofarmConfig.weapon = "Fruit"
    else
        autofarmConfig.weapon = nil
    end
end

-- Farmear al mejor NPC detectado
local function farmTarget()
    if autofarmConfig.targetNPC and autofarmConfig.weapon then
        while autofarmConfig.targetNPC.Humanoid.Health > 0 do
            character:SetPrimaryPartCFrame(autofarmConfig.targetNPC.HumanoidRootPart.CFrame * CFrame.new(0, autofarmConfig.safeDistance, 0))
            humanoid:MoveTo(autofarmConfig.targetNPC.HumanoidRootPart.Position)
            wait(0.1)
            if autofarmConfig.weapon == "Combat" then
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
            else
                local tool = player.Backpack:FindFirstChild(autofarmConfig.weapon)
                if tool then
                    tool.Parent = character
                    tool:Activate()
                end
            end
        end
    end
end

-- Evitar detección por anti-cheat
local function avoidAntiCheat()
    player.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(0, 0))
    end)
end

-- Activar Autofarm
local function activateAutoFarm()
    avoidAntiCheat()
    while true do
        autofarmConfig.targetNPC = detectBestNPC()
        optimizeAttack()
        if autofarmConfig.targetNPC then
            farmTarget()
        end
        wait(1)
    end
end

-- Ejecutar el autofarm
activateAutoFarm()
