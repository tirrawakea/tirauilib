local success, Matcha = pcall(function()
    return loadfile("tirauilib.lua")()
end)

if not success then warn("Failed to load Library!") return end

-- 1. Create Window
local Window = Matcha:CreateWindow({
    Name = "Tira Hub | v1.0"
})

-- 2. Create a Tab
local MainTab = Window:CreateTab("Main Features")

-- 3. Add a Header
MainTab:CreateHeader("Character Mods")

-- 4. Add a Slider
MainTab:CreateSlider("Walkspeed", 16, 100, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- 5. Add a Toggle
MainTab:CreateToggle("Infinite Jump", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

-- 6. Add a Button
MainTab:CreateButton("Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

print("UI loaded successfully!")
