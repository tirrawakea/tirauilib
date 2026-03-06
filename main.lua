-- [[ GLOBAL CONFIGS ]] --
_G.Aimbot = false
_G.FOV = 100
_G.Esp = true

-- Fetch Library
local libraryUrl = "https://raw.githubusercontent.com/YourUser/YourRepo/main/MatchaLib.lua"
local MatchaLib = loadstring(game:HttpGet(libraryUrl))()

-- Create UI
local Window = MatchaLib:CreateWindow("MATCHA PRIVATE")
local Combat = Window:CreateTab("Combat")
local Visuals = Window:CreateTab("Visuals")

-- Populate Combat
Window:AddToggle(Combat, "Master Aimbot", _G.Aimbot, function(v) _G.Aimbot = v end)
Window:AddSlider(Combat, "Aimbot FOV", 0, 800, _G.FOV, function(v) _G.FOV = v end)

-- Populate Visuals
Window:AddToggle(Visuals, "Enable ESP", _G.Esp, function(v) _G.Esp = v end)

notify("Cloud Script Initialized", "Matcha", 3)
