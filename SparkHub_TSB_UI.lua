-- Spark Hub-inspired TSB UI shell
-- For Roblox Studio projects you control.
-- This is a UI-only shell: it does NOT inject into, modify, or exploit the
-- original The Strongest Battlegrounds game. Feature switches below are local
-- UI settings/placeholders until connected to systems in your own experience.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SparkHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SparkHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 50
gui.Parent = playerGui

local COLORS = {
    background = Color3.fromRGB(16, 17, 25),
    panel = Color3.fromRGB(24, 25, 36),
    panel2 = Color3.fromRGB(32, 33, 47),
    panelHover = Color3.fromRGB(43, 39, 62),
    purple = Color3.fromRGB(157, 105, 255),
    purpleDark = Color3.fromRGB(104, 67, 181),
    text = Color3.fromRGB(245, 243, 250),
    muted = Color3.fromRGB(157, 156, 173),
    green = Color3.fromRGB(85, 196, 135),
    red = Color3.fromRGB(224, 104, 116),
}

local function corner(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = instance
    return c
end

local function stroke(instance, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.purple
    s.Transparency = transparency or 0.75
    s.Thickness = 1
    s.Parent = instance
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or COLORS.text
    l.TextSize = size or 14
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(680, 455)
main.Position = UDim2.new(0.5, -340, 0.5, -227)
main.BackgroundColor3 = COLORS.background
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 14)
stroke(main, COLORS.purple, 0.55)

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(310, 300)
sizeConstraint.MaxSize = Vector2.new(900, 650)
sizeConstraint.Parent = main

local scale = Instance.new("UIScale")
scale.Parent = main

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    scale.Scale = math.clamp(math.min(viewport.X / 720, viewport.Y / 490), 0.58, 1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = COLORS.panel
header.BorderSizePixel = 0
header.Parent = main
corner(header, 14)

local title = label(header, "⚡  SPARK HUB", 21, COLORS.purple, Enum.Font.GothamBold)
title.Position = UDim2.fromOffset(18, 0)
title.Size = UDim2.new(0.6, 0, 1, 0)

local subtitle = label(header, "THE STRONGEST BATTLEGROUNDS  •  UI EDITION", 9, COLORS.muted, Enum.Font.GothamMedium)
subtitle.Position = UDim2.new(0, 190, 0, 4)
subtitle.Size = UDim2.new(1, -245, 1, -8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -44, 0, 13)
close.BackgroundColor3 = COLORS.panel2
close.Text = "×"
close.TextColor3 = COLORS.text
close.TextSize = 23
close.Font = Enum.Font.Gotham
close.Parent = header
corner(close, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Dragging
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Sidebar
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Tabs"
sidebar.Position = UDim2.fromOffset(12, 70)
sidebar.Size = UDim2.new(0, 155, 1, -84)
sidebar.BackgroundColor3 = COLORS.panel
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 3
sidebar.ScrollBarImageColor3 = COLORS.purple
sidebar.CanvasSize = UDim2.new()
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.Parent = main
corner(sidebar, 10)

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 9)
sidePadding.PaddingLeft = UDim.new(0, 7)
sidePadding.PaddingRight = UDim.new(0, 7)
sidePadding.PaddingBottom = UDim.new(0, 9)
sidePadding.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local page = Instance.new("ScrollingFrame")
page.Name = "Page"
page.Position = UDim2.fromOffset(178, 70)
page.Size = UDim2.new(1, -190, 1, -84)
page.BackgroundColor3 = COLORS.panel
page.BorderSizePixel = 0
page.ScrollBarThickness = 4
page.ScrollBarImageColor3 = COLORS.purple
page.CanvasSize = UDim2.new()
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Parent = main
corner(page, 10)

local pagePadding = Instance.new("UIPadding")
pagePadding.PaddingTop = UDim.new(0, 14)
pagePadding.PaddingLeft = UDim.new(0, 14)
pagePadding.PaddingRight = UDim.new(0, 14)
pagePadding.PaddingBottom = UDim.new(0, 14)
pagePadding.Parent = page

local pageLayout = Instance.new("UIListLayout")
pageLayout.Padding = UDim.new(0, 9)
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.Parent = page

local tabs = {
    ["Auto Techs"] = {
        "Tech practice helper",
        "Dash timing trainer",
        "Combo practice notes",
        "Practice mode reminder",
    },
    ["Combat"] = {
        "Training dummy controls",
        "Damage display (own game)",
        "Hitbox visualizer (own game)",
        "Combat practice settings",
    },
    ["Auto Farm"] = {
        "Training reward tracker",
        "Practice session timer",
        "Session goal reminder",
    },
    ["Movesets"] = {
        "Moveset selector (own game)",
        "Save current loadout",
        "Load saved loadout",
    },
    ["Troll"] = {
        "Emote preview (own game)",
        "Funny effect preview",
    },
    ["Teleport"] = {
        "Teleport to training area (own game)",
        "Save current location",
        "Return to saved location",
    },
    ["Configs"] = {
        "Save UI preferences",
        "Load UI preferences",
        "Reset UI preferences",
    },
    ["Legit"] = {
        "Aim practice settings",
        "Dash practice settings",
        "Training hitbox display",
    },
    ["Visuals"] = {
        "Evasive timing display (own game)",
        "Training range markers",
        "Reduce visual effects",
    },
    ["Exploits"] = {
        "No exploit actions are included",
        "Use this page for developer test tools in your own game",
    },
}

local selectedTab
local tabButtons = {}
local localSettings = {}

local function clearPage()
    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 14)
    pad.Parent = page
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
end

local function addSection(text)
    local h = label(page, text, 18, COLORS.purple, Enum.Font.GothamBold)
    h.Size = UDim2.new(1, -4, 0, 28)
    return h
end

local function addDescription(text)
    local d = label(page, text, 11, COLORS.muted, Enum.Font.Gotham)
    d.Size = UDim2.new(1, -4, 0, 34)
    d.TextWrapped = true
    d.TextYAlignment = Enum.TextYAlignment.Top
    return d
end

local function addToggle(name)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 48)
    row.BackgroundColor3 = COLORS.panel2
    row.BorderSizePixel = 0
    row.Parent = page
    corner(row, 8)

    local text = label(row, name, 13, COLORS.text, Enum.Font.GothamMedium)
    text.Position = UDim2.fromOffset(12, 0)
    text.Size = UDim2.new(1, -100, 1, 0)

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(62, 27)
    button.Position = UDim2.new(1, -74, 0.5, -13)
    button.BackgroundColor3 = COLORS.panelHover
    button.Text = "OFF"
    button.TextColor3 = COLORS.muted
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.Parent = row
    corner(button, 14)

    local key = selectedTab .. "/" .. name
    localSettings[key] = localSettings[key] or false

    local function refresh()
        local on = localSettings[key]
        button.Text = on and "ON" or "OFF"
        button.BackgroundColor3 = on and COLORS.purpleDark or COLORS.panelHover
        button.TextColor3 = on and COLORS.text or COLORS.muted
    end
    refresh()

    button.MouseButton1Click:Connect(function()
        localSettings[key] = not localSettings[key]
        refresh()
    end)
end

local function addSlider(name, minValue, maxValue, initial)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, -4, 0, 68)
    wrap.BackgroundColor3 = COLORS.panel2
    wrap.BorderSizePixel = 0
    wrap.Parent = page
    corner(wrap, 8)

    local txt = label(wrap, name, 12, COLORS.text, Enum.Font.GothamMedium)
    txt.Position = UDim2.fromOffset(12, 5)
    txt.Size = UDim2.new(1, -70, 0, 24)

    local valueLabel = label(wrap, tostring(initial), 12, COLORS.purple, Enum.Font.GothamBold)
    valueLabel.Position = UDim2.new(1, -55, 0, 5)
    valueLabel.Size = UDim2.fromOffset(42, 24)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("TextButton")
    slider.Position = UDim2.fromOffset(12, 40)
    slider.Size = UDim2.new(1, -24, 0, 8)
    slider.BackgroundColor3 = COLORS.panelHover
    slider.Text = ""
    slider.AutoButtonColor = false
    slider.Parent = wrap
    corner(slider, 6)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.purple
    fill.BorderSizePixel = 0
    fill.Parent = slider
    corner(fill, 6)

    local value = initial
    local function setFromX(x)
        local alpha = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(minValue + alpha * (maxValue - minValue) + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        valueLabel.Text = tostring(value)
    end
    slider.MouseButton1Down:Connect(function(x) setFromX(x) end)
    slider.MouseMoved:Connect(function(x)
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            setFromX(x)
        end
    end)
end

local function addAction(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 42)
    button.BackgroundColor3 = COLORS.panel2
    button.Text = name
    button.TextColor3 = COLORS.text
    button.TextSize = 12
    button.Font = Enum.Font.GothamMedium
    button.Parent = page
    corner(button, 8)
    button.MouseButton1Click:Connect(function()
        button.Text = name .. "  •  UI demo"
        task.delay(1.2, function()
            if button.Parent then button.Text = name end
        end)
    end)
end

local function openTab(tabName)
    selectedTab = tabName
    clearPage()
    addSection(tabName)
    addDescription("Spark Hub-inspired controls. These are local UI settings or demo controls, not actions against the original TSB game.")

    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = (name == tabName) and COLORS.purpleDark or COLORS.panel2
        button.TextColor3 = COLORS.text
    end

    for _, item in ipairs(tabs[tabName]) do
        if tabName == "Visuals" and string.find(item, "Reduce") then
            addToggle(item)
        elseif tabName == "Legit" and string.find(item, "settings") then
            addSlider(item .. " strength", 0, 100, 50)
        elseif tabName == "Combat" and string.find(item, "visualizer") then
            addToggle(item)
        elseif tabName == "Configs" or tabName == "Teleport" or tabName == "Movesets" or tabName == "Troll" then
            addAction(item)
        else
            addToggle(item)
        end
    end
end

local order = {
    "Auto Techs", "Combat", "Auto Farm", "Movesets", "Troll",
    "Teleport", "Configs", "Legit", "Visuals", "Exploits"
}

for index, tabName in ipairs(order) do
    local button = Instance.new("TextButton")
    button.Name = tabName
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = COLORS.panel2
    button.Text = "  " .. tabName
    button.TextColor3 = COLORS.muted
    button.TextSize = 12
    button.Font = Enum.Font.GothamMedium
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = index
    button.Parent = sidebar
    corner(button, 7)
    tabButtons[tabName] = button
    button.MouseButton1Click:Connect(function() openTab(tabName) end)
end

openTab("Auto Techs")

-- Optional hotkey: RightShift hides/shows the UI.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

print("[Spark Hub] UI loaded. RightShift toggles visibility.")
