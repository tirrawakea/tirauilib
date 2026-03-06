local Matcha = {}
Matcha.__index = Matcha

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Matcha:CreateWindow(options)
    local Window = { Name = options.Name or "Matcha UI", Tabs = {} }
    
    -- Create Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MatchaUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- Simple dragging
    MainFrame.Parent = ScreenGui

    -- Container for Tabs/Sections
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -40)
    Container.Position = UDim2.new(0, 10, 0, 35)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 2, 0)
    Container.ScrollBarThickness = 2
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 5)

    -- HEADER
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = Window.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = MainFrame

    -- FUNCTIONS FOR ELEMENTS
    function Window:CreateTab(name)
        local Tab = { Name = name }
        
        -- HEADER ELEMENT
        function Tab:CreateHeader(text)
            local Header = Instance.new("TextLabel")
            Header.Size = UDim2.new(1, 0, 0, 25)
            Header.Text = "--- " .. text .. " ---"
            Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Header.TextColor3 = Color3.fromRGB(150, 150, 150)
            Header.Font = Enum.Font.Gotham
            Header.TextSize = 12
            Header.Parent = Container
        end

        -- BUTTON ELEMENT
        function Tab:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 30)
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Button.Text = name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.Parent = Container
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        -- TOGGLE ELEMENT
        function Tab:CreateToggle(name, callback)
            local Toggled = false
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 0, 30)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleBtn.Text = name .. " [OFF]"
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
            ToggleBtn.Parent = Container
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                ToggleBtn.Text = name .. (Toggled and " [ON]" or " [OFF]")
                ToggleBtn.TextColor3 = Toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 0, 0)
                callback(Toggled)
            end)
        end

        -- SLIDER ELEMENT
        function Tab:CreateSlider(name, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 40)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Text = name .. ": " .. min
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1
            Label.Parent = SliderFrame

            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(0.9, 0, 0, 5)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            Bar.Text = ""
            Bar.Parent = SliderFrame

            Bar.MouseButton1Down:Connect(function()
                -- Simplified slider logic
                local mouse = game.Players.LocalPlayer:GetMouse()
                local val = math.floor(((mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X) * (max - min) + min)
                Label.Text = name .. ": " .. val
                callback(val)
            end)
        end

        return Tab
    end

    return Window
end

return Matcha
