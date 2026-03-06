-- [[ TIRAUILIB - THE UI ENGINE ]] --
local Matcha = {}
Matcha.__index = Matcha

-- Internal settings
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function Matcha:CreateWindow(options)
    local Window = {
        Name = options.Name or "Matcha UI",
        ConfigSaving = options.ConfigSaving or false,
        Keybind = options.Keybind or Enum.KeyCode.RightControl,
        Tabs = {}
    }
    
    -- Basic console log to confirm it's working
    print("Matcha: Window '" .. Window.Name .. "' created successfully.")
    
    -- In a real library, this is where the ScreenGui creation code goes
    -- For now, we return a functional table so main.lua doesn't crash
    
    function Window:CreateTab(tabOptions)
        local Tab = { Name = tabOptions.Name or "Tab" }
        print("Matcha: Tab '" .. Tab.Name .. "' added.")
        
        function Tab:CreateSection(secOptions)
            return { Name = secOptions.Name or "Section" }
        end
        
        return Tab
    end
    
    return Window
end

-- CRITICAL: This is what was likely missing!
-- Without this line, main.lua sees this whole file as 'nil'
return Matcha
