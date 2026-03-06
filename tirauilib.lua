-- [[ MATCHA SHADOW PLUM LIBRARY v4.0 - GITHUB EDITION ]] --
local MatchaLib = {
    Tabs = {},
    Elements = {},
    CurrentTab = nil,
    UI_POS = Vector2.new(350, 350),
    UI_SIZE = Vector2.new(500, 380),
    IsMinimized = false,
    Dragging = false,
    DragOffset = Vector2.new(0, 0),
    Initialized = false
}

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Safe Length Helper (No # operator)
local function getLen(t)
    local c = 0
    for _ in pairs(t) do c = c + 1 end
    return c
end

function MatchaLib:CreateWindow(title)
    if self.Initialized then return end
    
    self.MainFrame = Drawing.new("Square")
    self.MainFrame.Size = self.UI_SIZE
    self.MainFrame.Color = Color3.fromRGB(12, 11, 15)
    self.MainFrame.Filled = true
    self.MainFrame.Visible = true

    self.SideBar = Drawing.new("Square")
    self.SideBar.Color = Color3.fromRGB(18, 16, 22)
    self.SideBar.Filled = true
    self.SideBar.Visible = true

    self.TitleLabel = Drawing.new("Text")
    self.TitleLabel.Text = title
    self.TitleLabel.Size = 18
    self.TitleLabel.Color = Color3.new(1, 1, 1)
    self.TitleLabel.Font = Drawing.Fonts.UI
    self.TitleLabel.Visible = true

    self.MinBtn = Drawing.new("Square")
    self.MinBtn.Size = Vector2.new(20, 20)
    self.MinBtn.Color = Color3.fromRGB(35, 30, 45)
    self.MinBtn.Filled = true
    self.MinBtn.Visible = true

    self.MinBtnTxt = Drawing.new("Text")
    self.MinBtnTxt.Size = 18
    self.MinBtnTxt.Color = Color3.new(1, 1, 1)
    self.MinBtnTxt.Center = true
    self.MinBtnTxt.Font = Drawing.Fonts.UI
    self.MinBtnTxt.Visible = true

    self.Initialized = true
    self:StartLoop()
    return self
end

function MatchaLib:CreateTab(name)
    local index = getLen(self.Tabs)
    local yOffset = 50 + (index * 35)

    local btn = Drawing.new("Square")
    btn.Size = Vector2.new(110, 30); btn.Color = Color3.fromRGB(18, 16, 22); btn.Filled = true; btn.Visible = true

    local txt = Drawing.new("Text")
    txt.Text = name; txt.Size = 15; txt.Center = true; txt.Color = Color3.new(0.5, 0.5, 0.5); txt.Font = Drawing.Fonts.UI; txt.Visible = true

    local tabObj = {Name = name, ElementCount = 0, Offset = Vector2.new(5, yOffset), Button = btn, Text = txt}
    self.Tabs[name] = tabObj
    if self.CurrentTab == nil then self.CurrentTab = name end
    return tabObj
end

function MatchaLib:AddToggle(tabObj, text, default, callback)
    local yOffset = 50 + (tabObj.ElementCount * 40)
    tabObj.ElementCount = tabObj.ElementCount + 1

    local bg = Drawing.new("Square")
    bg.Size = Vector2.new(360, 34); bg.Filled = true; bg.Visible = false

    local label = Drawing.new("Text")
    label.Text = text; label.Size = 14; label.Color = Color3.new(1, 1, 1); label.Font = Drawing.Fonts.UI; label.Visible = false

    self.Elements[text] = {Type = "Toggle", Tab = tabObj.Name, State = default, Callback = callback, Visual = bg, Label = label, Offset = Vector2.new(130, yOffset)}
end

function MatchaLib:AddSlider(tabObj, text, min, max, default, callback)
    local yOffset = 50 + (tabObj.ElementCount * 40)
    tabObj.ElementCount = tabObj.ElementCount + 1

    local bg = Drawing.new("Square")
    bg.Size = Vector2.new(360, 34); bg.Color = Color3.fromRGB(35, 30, 45); bg.Filled = true; bg.Visible = false

    local fill = Drawing.new("Square")
    fill.Size = Vector2.new(0, 34); fill.Color = Color3.fromRGB(140, 90, 255); fill.Transparency = 0.4; fill.Filled = true; fill.Visible = false

    local label = Drawing.new("Text")
    label.Size = 14; label.Color = Color3.new(1, 1, 1); label.Font = Drawing.Fonts.UI; label.Visible = false

    self.Elements[text] = {Type = "Slider", Tab = tabObj.Name, Val = default, Min = min, Max = max, Callback = callback, Visual = bg, Fill = fill, Label = label, Offset = Vector2.new(130, yOffset)}
end

function MatchaLib:Update()
    if not self.Initialized then return end
    local targetY = self.IsMinimized and 32 or self.UI_SIZE.Y
    
    self.MainFrame.Position = self.UI_POS; self.MainFrame.Size = Vector2.new(self.UI_SIZE.X, targetY)
    self.SideBar.Position = self.UI_POS; self.SideBar.Size = Vector2.new(120, targetY)
    self.TitleLabel.Position = self.UI_POS + Vector2.new(15, 7)
    self.MinBtn.Position = self.UI_POS + Vector2.new(self.UI_SIZE.X - 25, 6)
    self.MinBtnTxt.Position = self.MinBtn.Position + Vector2.new(10, 1)
    self.MinBtnTxt.Text = self.IsMinimized and "+" or "-"

    local visible = not self.IsMinimized
    for name, tab in pairs(self.Tabs) do
        tab.Button.Visible = visible; tab.Text.Visible = visible
        tab.Button.Position = self.UI_POS + tab.Offset
        tab.Text.Position = tab.Button.Position + Vector2.new(55, 7)
        tab.Text.Color = (self.CurrentTab == name) and Color3.new(1, 1, 1) or Color3.new(0.4, 0.4, 0.4)
    end

    for name, d in pairs(self.Elements) do
        if d.Tab == self.CurrentTab and visible then
            d.Visual.Visible = true; d.Label.Visible = true
            d.Visual.Position = self.UI_POS + d.Offset; d.Label.Position = d.Visual.Position + Vector2.new(15, 8)
            if d.Type == "Toggle" then
                d.Visual.Color = d.State and Color3.fromRGB(110, 60, 190) or Color3.fromRGB(35, 30, 45)
            elseif d.Type == "Slider" then
                d.Fill.Visible = true; d.Fill.Position = d.Visual.Position
                local perc = (d.Val - d.Min) / (d.Max - d.Min)
                d.Fill.Size = Vector2.new(360 * perc, 34); d.Label.Text = name .. ": " .. tostring(d.Val)
            end
        else
            d.Visual.Visible = false; d.Label.Visible = false
            if d.Type == "Slider" then d.Fill.Visible = false end
            d.Visual.Position = Vector2.new(-1000, -1000)
        end
    end
end

function MatchaLib:StartLoop()
    task.spawn(function()
        local lastClick = 0
        while true do
            local mX, mY = Mouse.X, Mouse.Y; local clicking = ismouse1pressed()
            if isrbxactive() then
                if clicking then
                    if not self.Dragging and (mY >= self.UI_POS.Y and mY <= self.UI_POS.Y + 32) then
                        self.Dragging = true; self.DragOffset = self.UI_POS - Vector2.new(mX, mY)
                    end
                    if self.Dragging then self.UI_POS = Vector2.new(mX, mY) + self.DragOffset end
                else self.Dragging = false end

                if clicking and (tick() - lastClick > 0.2) then
                    local p = self.MinBtn.Position
                    if (mX >= p.X and mX <= p.X + 20) and (mY >= p.Y and mY <= p.Y + 20) then
                        self.IsMinimized = not self.IsMinimized; lastClick = tick()
                    end
                    if not self.IsMinimized then
                        for name, tab in pairs(self.Tabs) do
                            local tp, ts = tab.Button.Position, tab.Button.Size
                            if (mX >= tp.X and mX <= tp.X + ts.X) and (mY >= tp.Y and mY <= tp.Y + ts.Y) then self.CurrentTab = name; lastClick = tick() end
                        end
                        for name, d in pairs(self.Elements) do
                            if d.Tab == self.CurrentTab then
                                local ep, es = d.Visual.Position, d.Visual.Size
                                if (mX >= ep.X and mX <= ep.X + es.X) and (mY >= ep.Y and mY <= ep.Y + es.Y) then
                                    if d.Type == "Toggle" then d.State = not d.State; d.Callback(d.State); lastClick = tick()
                                    elseif d.Type == "Slider" then
                                        local perc = math.clamp((mX - d.Visual.Position.X) / d.Visual.Size.X, 0, 1)
                                        d.Val = math.floor(d.Min + (d.Max - d.Min) * perc); d.Callback(d.Val)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            self:Update(); task.wait()
        end
    end)
end

return MatchaLib -- This is what allows loadstring()() to work.
