-- [[ GLOBAL CONFIGS ]] --
_G.Aimbot = false
_G.FOV = 100
_G.Esp = true
_G.AimSmoothing = 5

-- 1. Fetch Library (Updated to your actual Repo)
local libraryUrl = "https://raw.githubusercontent.com/tirrawakea/tirauilib/main/tirauilib.lua"
local MatchaLib = loadstring(game:HttpGet(libraryUrl))()

-- 2. Create UI
local Window = MatchaLib:CreateWindow("TIRA PRIVATE")
local Combat = Window:CreateTab("Combat")
local Visuals = Window:CreateTab("Visuals")

-- 3. UI Elements & Callbacks
Window:AddToggle(Combat, "Master Aimbot", _G.Aimbot, function(v) _G.Aimbot = v end)
Window:AddSlider(Combat, "Aimbot FOV", 0, 800, _G.FOV, function(v) _G.FOV = v end)
Window:AddSlider(Combat, "Smoothing", 1, 20, _G.AimSmoothing, function(v) _G.AimSmoothing = v end)

Window:AddToggle(Visuals, "Enable ESP", _G.Esp, function(v) _G.Esp = v end)

-- 4. CORE LOGIC (Aimbot & ESP)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(140, 90, 255)
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Aim Helper (No CFrame)
local function getClosest()
    local target, dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mag < dist then
                    target = v.Character.Head
                    dist = mag
                end
            end
        end
    end
    return target
end

-- Logic Loop
task.spawn(function()
    while true do
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        FOVCircle.Radius = _G.FOV
        
        if _G.Aimbot and ismouse2pressed() and isrbxactive() then
            local target = getClosest()
            if target then
                local screenPos = Camera:WorldToViewportPoint(target.Position)
                local move = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)) / _G.AimSmoothing
                mousemoverel(move.X, move.Y)
            end
        end
        task.wait()
    end
end)

notify("TiraUI Cloud Initialized", "Matcha", 3)
