-- [[ MAIN.LUA - YOUR INTERFACE ]] --

-- 1. Load the library file
local success, Matcha = pcall(function()
    -- Ensure the filename matches exactly what you saved
    return loadfile("tirauilib.lua")() 
end)

-- 2. Safety Check: If the file is missing or has a syntax error, stop here.
if not success or type(Matcha) ~= "table" then
    warn("ERROR: Could not load tirauilib.lua!")
    warn("Reason: " .. tostring(Matcha))
    return
end

-- 3. Now we can safely call CreateWindow
local Window = Matcha:CreateWindow({
    Name = "My Custom Script",
    ConfigSaving = true,
    Keybind = Enum.KeyCode.RightControl
})

-- 4. Create your Tabs and Sections
local MainTab = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998"
})

local CombatSection = MainTab:CreateSection({
    Name = "Combat Settings"
})

print("Success! UI is now running without indexing errors.")
