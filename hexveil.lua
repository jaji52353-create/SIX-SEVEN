--[[
    HEXVEIL UI FRAMEWORK + ALL FEATURES
    Creator: Nazam
    Letakkan sebagai LocalScript di StarterGui
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============ CONFIG ============
local CONFIG = {
    AccentColor = Color3.fromRGB(255, 255, 255),
    ClickSoundId = "rbxassetid://6895079853",
    MusicId = "rbxassetid://125026658817868",
    CornerRadius = UDim.new(0, 12),
    TweenTime = 0.25,
}

-- ============ CLEANUP OLD GUI ============
local old = player.PlayerGui:FindFirstChild("HexveilGui")
if old then old:Destroy() end

-- ============ ROOT GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HexveilGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player.PlayerGui

-- ============ SOUND SETUP ============
local clickSound = Instance.new("Sound")
clickSound.SoundId = CONFIG.ClickSoundId
clickSound.Volume = 0.4
clickSound.Parent = ScreenGui

local bgMusic = Instance.new("Sound")
bgMusic.SoundId = CONFIG.MusicId
bgMusic.Volume = 0.25
bgMusic.Looped = true
bgMusic.Parent = ScreenGui

local musicPlaying = false

local function playClick()
    clickSound:Play()
end

-- ============ UTIL: Glow / Shadow Effect ============
local function addGlow(parent, color, transparency, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or Color3.fromRGB(255,255,255)
    glow.ImageTransparency = transparency or 0.6
    glow.Size = UDim2.new(1, size or 40, 1, size or 40)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or CONFIG.CornerRadius
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.7
    s.Parent = parent
    return s
end

-- ============ MAIN WINDOW ============
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 315)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -157)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui
corner(MainFrame, UDim.new(0, 14))
stroke(MainFrame, Color3.fromRGB(255,255,255), 1, 0.85)

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.4
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.ZIndex = 0
shadow.Parent = MainFrame

MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 560, 0, 0)
MainFrame.Visible = true
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 560, 0, 315),
    BackgroundTransparency = 0.15
})

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HEXVEIL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0.5, 0, 0, 14)
SubTitle.Position = UDim2.new(0, 19, 0, 24)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by Nazam"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextColor3 = Color3.fromRGB(170,170,170)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 46)
divider.BackgroundColor3 = Color3.fromRGB(255,255,255)
divider.BackgroundTransparency = 0.92
divider.BorderSizePixel = 0
divider.Parent = MainFrame

-- ============ TOP CONTROLS (minimize / music) ============
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 9)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.BackgroundTransparency = 0.9
MinimizeBtn.Text = "—"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header
corner(MinimizeBtn, UDim.new(1, 0))

local MusicBtn = Instance.new("TextButton")
MusicBtn.Name = "MusicBtn"
MusicBtn.Size = UDim2.new(0, 28, 0, 28)
MusicBtn.Position = UDim2.new(1, -76, 0, 9)
MusicBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
MusicBtn.BackgroundTransparency = 0.9
MusicBtn.Text = "M"
MusicBtn.Font = Enum.Font.GothamBold
MusicBtn.TextSize = 13
MusicBtn.TextColor3 = Color3.fromRGB(255,255,255)
MusicBtn.AutoButtonColor = false
MusicBtn.Parent = Header
corner(MusicBtn, UDim.new(1, 0))

MusicBtn.MouseButton1Click:Connect(function()
    playClick()
    musicPlaying = not musicPlaying
    if musicPlaying then
        bgMusic:Play()
        TweenService:Create(MusicBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    else
        bgMusic:Stop()
        TweenService:Create(MusicBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
    end
end)

for _, btn in ipairs({MinimizeBtn, MusicBtn}) do
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if not (btn == MusicBtn and musicPlaying) then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.9}):Play()
        end
    end)
end

-- ============ SIDEBAR (TABS) ============
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -58)
Sidebar.Position = UDim2.new(0, 12, 0, 54)
Sidebar.BackgroundColor3 = Color3.fromRGB(255,255,255)
Sidebar.BackgroundTransparency = 0.95
Sidebar.Parent = MainFrame
corner(Sidebar, UDim.new(0, 10))

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.Parent = Sidebar

-- ============ CONTENT AREA ============
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -160, 1, -58)
ContentArea.Position = UDim2.new(0, 154, 0, 54)
ContentArea.BackgroundColor3 = Color3.fromRGB(255,255,255)
ContentArea.BackgroundTransparency = 0.96
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame
corner(ContentArea, UDim.new(0, 10))

local pages = {}
local tabButtons = {}

local function selectTab(tabName)
    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        local active = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = active and 0.8 or 1
        }):Play()
        btn.TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,160)
    end
end

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Name = name.."Btn"
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(160,160,160)
    btn.Parent = Sidebar
    corner(btn, UDim.new(0, 8))

    local page = Instance.new("ScrollingFrame")
    page.Name = name.."Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = page

    btn.MouseEnter:Connect(function()
        if not page.Visible then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.92}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not page.Visible then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        playClick()
        selectTab(name)
    end)

    pages[name] = page
    tabButtons[name] = btn

    return page
end

-- ============ CREATE TABS ============
local tabNames = {"COMBAT", "MOVEMENT", "UTILITY", "MONITOR", "TOOLS"}
for _, name in ipairs(tabNames) do
    createTab(name)
end

selectTab(tabNames[1])

-- ============ MINIMIZE LOGIC ============
local MinimizedPill = Instance.new("TextButton")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Size = UDim2.new(0, 140, 0, 34)
MinimizedPill.Position = UDim2.new(0.5, -70, 0, 18)
MinimizedPill.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MinimizedPill.BackgroundTransparency = 0.1
MinimizedPill.Text = "HEXVEIL"
MinimizedPill.Font = Enum.Font.GothamBold
MinimizedPill.TextSize = 13
MinimizedPill.TextColor3 = Color3.fromRGB(255,255,255)
MinimizedPill.AutoButtonColor = false
MinimizedPill.Visible = false
MinimizedPill.Parent = ScreenGui
corner(MinimizedPill, UDim.new(1, 0))
stroke(MinimizedPill, Color3.fromRGB(255,255,255), 1, 0.85)

local isMinimized = false

local function setMinimized(state)
    isMinimized = state
    if state then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 560, 0, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
            MinimizedPill.Visible = true
        end)
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 560, 0, 0)
        MainFrame.BackgroundTransparency = 1
        MinimizedPill.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 560, 0, 315),
            BackgroundTransparency = 0.15
        }):Play()
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    playClick()
    setMinimized(true)
end)

MinimizedPill.MouseButton1Click:Connect(function()
    playClick()
    setMinimized(false)
end)

-- ============ DRAGGABLE ============
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame, Header)

openTween:Play()

-- ============================================================
-- ============ UI HELPER FUNCTIONS FOR FEATURES ============
-- ============================================================

-- Buat toggle switch dengan label
local function createToggle(parent, labelText, defaultState, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.7, -10, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -48, 0.5, -12)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    track.BorderSizePixel = 0
    corner(track, UDim.new(1, 0))

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    knob.BorderSizePixel = 0
    corner(knob, UDim.new(1, 0))

    local btn = Instance.new("TextButton", track)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local state = defaultState or false

    local function updateVisual()
        local t = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        if state then
            TweenService:Create(track, t, {BackgroundColor3 = Color3.fromRGB(70, 150, 255)}):Play()
            TweenService:Create(knob, t, {Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        else
            TweenService:Create(track, t, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(knob, t, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(160, 160, 180)}):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if onToggle then onToggle(state) end
    end)

    updateVisual()
    return { setState = function(s) state = s; updateVisual(); if onToggle then onToggle(state) end end, getState = function() return state end }
end

-- Buat slider dengan label dan value display
local function createSlider(parent, labelText, minVal, maxVal, step, defaultVal, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size = UDim2.new(0.3, 0, 0, 20)
    valLbl.Position = UDim2.new(0.7, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("Frame", row)
    slider.Size = UDim2.new(1, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 28)
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    slider.BorderSizePixel = 0
    corner(slider, UDim.new(0, 3))

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    fill.BorderSizePixel = 0
    corner(fill, UDim.new(0, 3))

    local dragBtn = Instance.new("TextButton", slider)
    dragBtn.Size = UDim2.new(0, 12, 0, 12)
    dragBtn.Position = UDim2.new(0, -6, 0.5, -6)
    dragBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dragBtn.BorderSizePixel = 0
    dragBtn.Text = ""
    corner(dragBtn, UDim.new(1, 0))

    local value = defaultVal or 0
    local function updateVisual()
        local percent = (value - minVal) / (maxVal - minVal)
        local size = math.clamp(percent, 0, 1)
        fill.Size = UDim2.new(size, 0, 1, 0)
        dragBtn.Position = UDim2.new(size, -6, 0.5, -6)
        valLbl.Text = tostring(math.floor(value))
    end

    local dragging = false
    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    dragBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function updateFromMouse(x)
        local absX = x - slider.AbsolutePosition.X
        local percent = math.clamp(absX / slider.AbsoluteSize.X, 0, 1)
        local newVal = minVal + (maxVal - minVal) * percent
        newVal = math.round(newVal / step) * step
        newVal = math.clamp(newVal, minVal, maxVal)
        if value ~= newVal then
            value = newVal
            updateVisual()
            if onChange then onChange(value) end
        end
    end

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromMouse(input.Position.X)
        end
    end)

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateFromMouse(input.Position.X)
        end
    end)

    updateVisual()
    return { setValue = function(v) value = math.clamp(v, minVal, maxVal); updateVisual(); if onChange then onChange(value) end end, getValue = function() return value end }
end

-- Buat tombol action
local function createButton(parent, labelText, color, onClick)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 100, 255)
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    corner(btn, UDim.new(0, 6))
    btn.MouseButton1Click:Connect(function()
        playClick()
        if onClick then onClick() end
    end)
    return btn
end

-- Buat label info
local function createLabel(parent, text, color)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(180, 180, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- Buat input box
local function createInput(parent, placeholder, onEnter)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1, 0, 0, 28)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.TextColor3 = Color3.fromRGB(220, 220, 255)
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    corner(box, UDim.new(0, 6))
    stroke(box, Color3.fromRGB(60, 60, 100), 1, 0.5)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed and onEnter then onEnter(box.Text) end
    end)
    return box
end

-- ============================================================
-- ============ FEATURE IMPLEMENTATIONS ============
-- ============================================================

-- ===================== COMBAT TAB =====================
local combatPage = pages["COMBAT"]

-- AIMBOT
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotSmoothness = 0.12
local aimbotConn = nil

local function getNearestPlayer()
    local nearest, minDist = nil, math.huge
    local myChar = player.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local cam = workspace.CurrentCamera
    local vpSize = cam.ViewportSize
    local cx, cy = vpSize.X/2, vpSize.Y/2
    for _, p in ipairs(Players:GetPlayers()) do
        if p == player then continue end
        local char = p.Character
        if not char then continue end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local screenPos, onScreen = cam:WorldToScreenPoint(head.Position)
        if not onScreen then continue end
        local dx = screenPos.X - cx
        local dy = screenPos.Y - cy
        local dist = math.sqrt(dx*dx + dy*dy)
        if dist < minDist then
            minDist = dist
            nearest = p
        end
    end
    return nearest
end

local function startAimbot()
    if aimbotConn then return end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local delta = UserInputService:GetMouseDelta()
        if delta.Magnitude > 1.5 then return end
        local target = getNearestPlayer()
        if not target then return end
        local char = target.Character
        if not char then return end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then return end
        local cam = workspace.CurrentCamera
        local camCF = cam.CFrame
        local camPos = camCF.Position
        local dir = (head.Position - camPos).Unit
        local goalCF = CFrame.lookAt(camPos, camPos + dir)
        cam.CFrame = camCF:Lerp(goalCF, aimbotSmoothness)
    end)
end

local function stopAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
end

createToggle(combatPage, "Aimbot Lock", false, function(state)
    aimbotEnabled = state
    if state then startAimbot() else stopAimbot() end
end)

createSlider(combatPage, "Smoothness", 0.02, 0.5, 0.02, 0.12, function(v)
    aimbotSmoothness = v
end)

-- ESP
local espEnabled = true
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Tags"
espFolder.Parent = CoreGui
local espData = {}

local function createEspTag(p)
    if p == player then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. p.Name
    billboard.Size = UDim2.new(0, 70, 0, 90)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Enabled = espEnabled
    billboard.Parent = espFolder

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local avatarFrame = Instance.new("Frame", frame)
    avatarFrame.Size = UDim2.new(0, 48, 0, 48)
    avatarFrame.Position = UDim2.new(0.5, -24, 0, 0)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    avatarFrame.BackgroundTransparency = 0.4
    avatarFrame.BorderSizePixel = 0
    corner(avatarFrame, UDim.new(1,0))

    local avatarImg = Instance.new("ImageLabel", avatarFrame)
    avatarImg.Size = UDim2.new(1, -4, 1, -4)
    avatarImg.Position = UDim2.new(0, 2, 0, 2)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = ""
    corner(avatarImg, UDim.new(1,0))

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and img then avatarImg.Image = img end
    end)

    local distLabel = Instance.new("TextLabel", frame)
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 20)
    distLabel.Position = UDim2.new(0, 0, 0, 52)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "-- studs"
    distLabel.TextColor3 = Color3.fromRGB(255,220,80)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    distLabel.TextSize = 11
    distLabel.Font = Enum.Font.GothamBold

    espData[p] = billboard

    local function attachToChar(char)
        local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        if root then billboard.Adornee = root end
    end

    if p.Character then attachToChar(p.Character) end
    p.CharacterAdded:Connect(function(char)
        billboard.Adornee = nil
        attachToChar(char)
    end)
end

local function removeEspTag(p)
    if espData[p] then espData[p]:Destroy(); espData[p] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do createEspTag(p) end
Players.PlayerAdded:Connect(createEspTag)
Players.PlayerRemoving:Connect(removeEspTag)

createToggle(combatPage, "ESP Player", true, function(state)
    espEnabled = state
    for _, billboard in pairs(espData) do
        billboard.Enabled = state
    end
end)

-- Update distance loop
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local localChar = player.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    for p, billboard in pairs(espData) do
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            billboard.Enabled = true
            billboard.Adornee = root
            if localRoot then
                local dist = math.floor((localRoot.Position - root.Position).Magnitude)
                local lbl = billboard.Frame:FindFirstChild("DistLabel")
                if lbl then lbl.Text = dist .. " studs" end
            end
        else
            billboard.Enabled = false
        end
    end
end)

-- ===================== MOVEMENT TAB =====================
local movementPage = pages["MOVEMENT"]

-- AIR WALK
local airWalkEnabled = false
local airPlatform = nil
local airLockedY = nil
local airWasInAir = false

local function createAirPlatform()
    if airPlatform then airPlatform:Destroy() end
    airPlatform = Instance.new("Part")
    airPlatform.Size = Vector3.new(60, 0.2, 60)
    airPlatform.Anchored = true
    airPlatform.CanCollide = true
    airPlatform.Transparency = 1
    airPlatform.CastShadow = false
    airPlatform.Name = "AirPlatform"
    airPlatform.Parent = workspace
end

local function removeAirPlatform()
    if airPlatform then airPlatform:Destroy(); airPlatform = nil end
    airLockedY = nil
    airWasInAir = false
end

RunService.RenderStepped:Connect(function()
    if not airWalkEnabled then return end
    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    if not airPlatform then createAirPlatform() end
    local pos = rootPart.Position
    local velY = rootPart.AssemblyLinearVelocity.Y
    local feetY = pos.Y - 3.1
    local isJumping = velY > 0.5
    local isFalling = velY < -0.5
    local isInAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping
    if isJumping then
        airWasInAir = true
        airPlatform.CFrame = CFrame.new(pos.X, feetY - 50, pos.Z)
        airLockedY = nil
    elseif airWasInAir and isFalling then
        if airLockedY == nil then airLockedY = feetY end
        airPlatform.CFrame = CFrame.new(pos.X, airLockedY, pos.Z)
    elseif not isInAir and not isJumping then
        airWasInAir = false
        airLockedY = nil
        airPlatform.CFrame = CFrame.new(pos.X, feetY, pos.Z)
    else
        if airLockedY then
            airPlatform.CFrame = CFrame.new(pos.X, airLockedY, pos.Z)
        else
            airPlatform.CFrame = CFrame.new(pos.X, feetY, pos.Z)
        end
    end
end)

player.CharacterAdded:Connect(function()
    airLockedY = nil
    airWasInAir = false
    if airWalkEnabled then task.wait(1); createAirPlatform() end
end)

createToggle(movementPage, "Air Walk", false, function(state)
    airWalkEnabled = state
    if state then createAirPlatform() else removeAirPlatform() end
end)

-- FLY
local flyEnabled = false
local flySpeed = 50
local flyBodyVel = nil
local flyBodyGyro = nil
local flyMoveInput = Vector2.zero

local function enableFly()
    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    humanoid.PlatformStand = true
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBodyVel.Parent = rootPart
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    flyBodyGyro.D = 100
    flyBodyGyro.P = 1e4
    flyBodyGyro.Parent = rootPart
end

local function disableFly()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

RunService.RenderStepped:Connect(function()
    if not flyEnabled or not flyBodyVel or not flyBodyGyro then return end
    local cam = workspace.CurrentCamera
    local camCF = cam.CFrame
    local camY = math.atan2(-camCF.LookVector.X, -camCF.LookVector.Z)
    local camPitch = math.asin(math.clamp(camCF.LookVector.Y, -1, 1))
    local camRight = camCF.RightVector
    local camForward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
    if camForward.Magnitude > 0 then camForward = camForward.Unit end
    local rawInput = Vector2.zero
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then rawInput = rawInput + Vector2.new(0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then rawInput = rawInput + Vector2.new(0,-1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then rawInput = rawInput + Vector2.new(-1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then rawInput = rawInput + Vector2.new(1,0) end
        if rawInput.Magnitude > 1 then rawInput = rawInput.Unit end
    else
        local char = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            local md = humanoid.MoveDirection
            local dotForward = md:Dot(camForward)
            local dotRight = md:Dot(camRight)
            rawInput = Vector2.new(dotRight, dotForward)
        end
    end
    if rawInput.Magnitude < 0.1 then
        flyBodyVel.Velocity = Vector3.zero
    else
        local moveDir = (camForward * rawInput.Y + camRight * rawInput.X)
        local pitchComponent = camCF.LookVector.Y
        local finalDir = Vector3.new(moveDir.X, pitchComponent, moveDir.Z)
        if finalDir.Magnitude > 0 then finalDir = finalDir.Unit end
        flyBodyVel.Velocity = finalDir * flySpeed * rawInput.Magnitude
    end
    flyBodyGyro.CFrame = CFrame.new(Vector3.zero) * CFrame.Angles(0, camY, 0) * CFrame.Angles(camPitch, 0, 0)
end)

createToggle(movementPage, "Fly", false, function(state)
    flyEnabled = state
    if state then enableFly() else disableFly() end
end)
createSlider(movementPage, "Fly Speed", 10, 200, 5, 50, function(v) flySpeed = v end)

-- INFINITE JUMP
_G.InfiniteJumpEnabled = false
local jumpConnection = nil

local function setInfiniteJump(enabled)
    if enabled then
        if jumpConnection then return end
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    if _G.InfiniteJumpEnabled then
        _G.InfiniteJumpEnabled = false
        setInfiniteJump(false)
    end
end)

createToggle(movementPage, "Infinite Jump", false, function(state)
    _G.InfiniteJumpEnabled = state
    setInfiniteJump(state)
end)

-- NO CLIP
_G.NoClipEnabled = false
local noClipConnection = nil

local function setNoClip(enabled)
    if enabled then
        if noClipConnection then return end
        noClipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noClipConnection then noClipConnection:Disconnect(); noClipConnection = nil end
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    if _G.NoClipEnabled then
        _G.NoClipEnabled = false
        setNoClip(false)
    end
end)

createToggle(movementPage, "No Clip", false, function(state)
    _G.NoClipEnabled = state
    setNoClip(state)
end)

-- SPEED BOOSTER
_G.SpeedEnabled = false
_G.SpeedValue = 16
local defaultSpeed = 16

local function applySpeed()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = _G.SpeedEnabled and _G.SpeedValue or defaultSpeed
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.3)
    if _G.SpeedEnabled then
        _G.SpeedEnabled = false
        applySpeed()
    end
end)

createToggle(movementPage, "Speed Booster", false, function(state)
    _G.SpeedEnabled = state
    applySpeed()
end)

local speedSlider = createSlider(movementPage, "Speed Value", 1, 500, 5, 16, function(v)
    _G.SpeedValue = v
    if _G.SpeedEnabled then applySpeed() end
end)

-- SPIN KARAKTER
local spinEnabled = false
local spinSpeed = 550
local spinConn = nil

local function startSpin()
    if spinConn then return end
    spinConn = RunService.Heartbeat:Connect(function()
        if not spinEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end)
end

local function stopSpin()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
end

player.CharacterAdded:Connect(function()
    if spinEnabled then
        stopSpin()
        task.wait(1)
        startSpin()
    end
end)

createToggle(movementPage, "Spin Karakter", false, function(state)
    spinEnabled = state
    if state then startSpin() else stopSpin() end
end)

-- DASH TELEPORT
local dashEnabled = false
local dashDistance = 30
local floatLocked = false
local floatSize = 60
local floatBtn = nil
local floatDragging = false
local floatMoved = false
local floatDragStart, floatStartPos

-- Buat float button (akan muncul di ScreenGui)
local function createFloatButton()
    if floatBtn then return end
    floatBtn = Instance.new("TextButton")
    floatBtn.Name = "DashFloat"
    floatBtn.Size = UDim2.new(0, floatSize, 0, floatSize)
    floatBtn.Position = UDim2.new(0.5, -floatSize/2, 0.8, 0)
    floatBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
    floatBtn.Text = "⚡"
    floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
    floatBtn.Font = Enum.Font.GothamBold
    floatBtn.TextSize = 24
    floatBtn.BorderSizePixel = 0
    floatBtn.Visible = false
    floatBtn.ZIndex = 10
    floatBtn.Parent = ScreenGui
    corner(floatBtn, UDim.new(1,0))
    stroke(floatBtn, Color3.fromRGB(140,200,255), 2.5, 0.5)

    floatBtn.InputBegan:Connect(function(input)
        if floatLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = true
            floatMoved = false
            floatDragStart = input.Position
            floatStartPos = floatBtn.Position
        end
    end)
    floatBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if floatDragging and not floatLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - floatDragStart
            if d.Magnitude > 4 then
                floatMoved = true
                floatBtn.Position = UDim2.new(
                    floatStartPos.X.Scale, floatStartPos.X.Offset + d.X,
                    floatStartPos.Y.Scale, floatStartPos.Y.Offset + d.Y
                )
            end
        end
    end)

    floatBtn.MouseButton1Click:Connect(function()
        if not dashEnabled then return end
        if floatMoved then floatMoved = false return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local cam = workspace.CurrentCamera
        local lookVec = cam.CFrame.LookVector
        local flatDir = Vector3.new(lookVec.X, 0, lookVec.Z)
        if flatDir.Magnitude < 0.01 then
            flatDir = hrp.CFrame.LookVector * Vector3.new(1,0,1)
        end
        flatDir = flatDir.Unit
        local origin = hrp.Position
        local target = origin + flatDir * dashDistance
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(target + Vector3.new(0,20,0), Vector3.new(0,-50,0), rp)
        if hit then target = hit.Position + Vector3.new(0,3,0) end
        floatBtn.BackgroundColor3 = Color3.fromRGB(255,230,60)
        task.delay(0.12, function()
            if floatBtn and floatBtn.Parent then
                TweenService:Create(floatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,100,255)}):Play()
            end
        end)
        hrp.CFrame = CFrame.new(target, target + flatDir)
    end)
end
createFloatButton()

createToggle(movementPage, "Dash Teleport", false, function(state)
    dashEnabled = state
    if floatBtn then floatBtn.Visible = state end
end)
createSlider(movementPage, "Jarak Dash", 5, 500, 5, 30, function(v) dashDistance = v end)
createToggle(movementPage, "Lock Float Button", false, function(state) floatLocked = state end)
createSlider(movementPage, "Ukuran Float", 30, 200, 10, 60, function(v)
    floatSize = v
    if floatBtn then
        floatBtn.Size = UDim2.new(0, floatSize, 0, floatSize)
        floatBtn.TextSize = math.clamp(math.floor(floatSize * 0.38), 14, 48)
    end
end)

-- ===================== UTILITY TAB =====================
local utilityPage = pages["UTILITY"]

-- CHECK ID (Asset Checker)
local soundHistory = {}
local imageHistory = {}
local currentSound = nil

local function parseID(input)
    local raw = input:match("^%s*(.-)%s*$")
    return raw:match("rbxassetid://(%d+)") or raw:match("^(%d+)$")
end

local function addHistoryRow(scroll, list, order, id, status, isWork)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundColor3 = isWork and Color3.fromRGB(10,30,15) or Color3.fromRGB(30,10,10)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = scroll
    corner(row, UDim.new(0,4))

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.RichText = true
    lbl.Text = string.format('<font color="#888888">[%s]</font> <font color="#aaaaff">%s</font>  <font color="%s"><b>%s</b></font>',
        os.date("%H:%M:%S"), id, isWork and "#44ff88" or "#ff5555", status)
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, math.huge) end)
end

-- Sound Checker
local soundInput = createInput(utilityPage, "Paste Sound ID", function(text) end)
local soundStatus = createLabel(utilityPage, "Status: Ready", Color3.fromRGB(180,180,200))

local soundScroll = Instance.new("ScrollingFrame", utilityPage)
soundScroll.Size = UDim2.new(1, 0, 0, 80)
soundScroll.BackgroundColor3 = Color3.fromRGB(15,15,22)
soundScroll.BorderSizePixel = 0
soundScroll.ScrollBarThickness = 3
soundScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,120)
soundScroll.CanvasSize = UDim2.new(0,0,0,0)
soundScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(soundScroll, UDim.new(0,6))
local sLayout = Instance.new("UIListLayout", soundScroll)
sLayout.Padding = UDim.new(0,2)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder

local soundHistoryCount = 0

local soundCheckBtn = createButton(utilityPage, "Check Sound", Color3.fromRGB(50,100,255), function()
    local id = parseID(soundInput.Text)
    if not id then soundStatus.Text = "⚠ ID tidak valid"; return end
    soundStatus.Text = "⏳ Checking..."
    task.spawn(function()
        local assetId = "rbxassetid://" .. id
        local tempSound = Instance.new("Sound")
        tempSound.SoundId = assetId
        tempSound.Volume = 0
        tempSound.Parent = workspace
        local ok = pcall(function() ContentProvider:PreloadAsync({tempSound}) end)
        task.wait(0.5)
        local timeLen = tempSound.TimeLength
        tempSound:Destroy()
        soundHistoryCount = soundHistoryCount + 1
        if ok and timeLen and timeLen > 0 then
            soundStatus.Text = "✔ WORK  | Durasi: " .. string.format("%.2f", timeLen) .. " detik"
            addHistoryRow(soundScroll, sLayout, soundHistoryCount, id, "WORK", true)
        else
            soundStatus.Text = "✘ TIDAK WORK"
            addHistoryRow(soundScroll, sLayout, soundHistoryCount, id, "TIDAK WORK", false)
        end
    end)
end)

local soundPlayBtn = createButton(utilityPage, "Play Sound", Color3.fromRGB(30,160,80), function()
    local id = parseID(soundInput.Text)
    if not id then soundStatus.Text = "⚠ ID tidak valid"; return end
    if currentSound then currentSound:Stop(); currentSound:Destroy() end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = 1
    s.Parent = workspace
    s:Play()
    currentSound = s
    soundStatus.Text = "▶ Playing " .. id
    s.Ended:Connect(function() soundStatus.Text = "■ Selesai"; currentSound = nil end)
end)

local soundStopBtn = createButton(utilityPage, "Stop Sound", Color3.fromRGB(200,50,50), function()
    if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil end
    soundStatus.Text = "■ Stopped"
end)

local soundClearBtn = createButton(utilityPage, "Clear History", Color3.fromRGB(80,40,120), function()
    for _, v in ipairs(soundScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    soundHistoryCount = 0
    soundStatus.Text = "History cleared"
end)

-- Image Checker
local imageInput = createInput(utilityPage, "Paste Image ID", function(text) end)
local imageStatus = createLabel(utilityPage, "Status: Ready", Color3.fromRGB(180,180,200))

local imageScroll = Instance.new("ScrollingFrame", utilityPage)
imageScroll.Size = UDim2.new(1, 0, 0, 80)
imageScroll.BackgroundColor3 = Color3.fromRGB(15,15,22)
imageScroll.BorderSizePixel = 0
imageScroll.ScrollBarThickness = 3
imageScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,120)
imageScroll.CanvasSize = UDim2.new(0,0,0,0)
imageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(imageScroll, UDim.new(0,6))
local iLayout = Instance.new("UIListLayout", imageScroll)
iLayout.Padding = UDim.new(0,2)
iLayout.SortOrder = Enum.SortOrder.LayoutOrder

local imageHistoryCount = 0

local imageCheckBtn = createButton(utilityPage, "Check Image", Color3.fromRGB(50,100,255), function()
    local id = parseID(imageInput.Text)
    if not id then imageStatus.Text = "⚠ ID tidak valid"; return end
    imageStatus.Text = "⏳ Checking..."
    task.spawn(function()
        local assetId = "rbxassetid://" .. id
        local tempImg = Instance.new("ImageLabel")
        tempImg.Image = assetId
        tempImg.Size = UDim2.new(0,1,0,1)
        tempImg.BackgroundTransparency = 1
        tempImg.Parent = CoreGui
        local ok = pcall(function() ContentProvider:PreloadAsync({tempImg}) end)
        task.wait(0.3)
        local finalImg = tempImg.Image
        tempImg:Destroy()
        imageHistoryCount = imageHistoryCount + 1
        if ok and finalImg == assetId then
            imageStatus.Text = "✔ WORK"
            addHistoryRow(imageScroll, iLayout, imageHistoryCount, id, "WORK", true)
        else
            imageStatus.Text = "✘ TIDAK WORK"
            addHistoryRow(imageScroll, iLayout, imageHistoryCount, id, "TIDAK WORK", false)
        end
    end)
end)

local imageClearBtn = createButton(utilityPage, "Clear History", Color3.fromRGB(80,40,120), function()
    for _, v in ipairs(imageScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    imageHistoryCount = 0
    imageStatus.Text = "History cleared"
end)

-- KORDINAT COPY
local coordX = createLabel(utilityPage, "X: 0.00", Color3.fromRGB(255,100,100))
local coordY = createLabel(utilityPage, "Y: 0.00", Color3.fromRGB(100,220,100))
local coordZ = createLabel(utilityPage, "Z: 0.00", Color3.fromRGB(100,160,255))

local function updateCoords()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position
    coordX.Text = string.format("X: %.2f", pos.X)
    coordY.Text = string.format("Y: %.2f", pos.Y)
    coordZ.Text = string.format("Z: %.2f", pos.Z)
end

RunService.Heartbeat:Connect(updateCoords)

local copyBtn = createButton(utilityPage, "Salin Koordinat", Color3.fromRGB(50,110,255), function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position
    local text = string.format("X: %.2f  Y: %.2f  Z: %.2f", pos.X, pos.Y, pos.Z)
    local ok = pcall(function() setclipboard(text) end)
    if ok then
        copyBtn.Text = "✅ Tersalin!"
        copyBtn.BackgroundColor3 = Color3.fromRGB(30,160,80)
        task.delay(2, function()
            if copyBtn and copyBtn.Parent then
                copyBtn.Text = "Salin Koordinat"
                copyBtn.BackgroundColor3 = Color3.fromRGB(50,110,255)
            end
        end)
    else
        copyBtn.Text = "⚠ Gagal"
        task.delay(1.5, function()
            if copyBtn and copyBtn.Parent then
                copyBtn.Text = "Salin Koordinat"
                copyBtn.BackgroundColor3 = Color3.fromRGB(50,110,255)
            end
        end)
    end
end)

-- ===================== MONITOR TAB =====================
local monitorPage = pages["MONITOR"]

-- MONITOR ACTIVITY
local MAX_LOGS = 300
local activityLogs = {}
local activityCount = 0
local activityScroll = Instance.new("ScrollingFrame", monitorPage)
activityScroll.Size = UDim2.new(1, 0, 1, -60)
activityScroll.BackgroundColor3 = Color3.fromRGB(10,13,18)
activityScroll.BorderSizePixel = 0
activityScroll.ScrollBarThickness = 3
activityScroll.ScrollBarImageColor3 = Color3.fromRGB(0,180,80)
activityScroll.CanvasSize = UDim2.new(0,0,0,0)
activityScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(activityScroll, UDim.new(0,6))

local actLayout = Instance.new("UIListLayout", activityScroll)
actLayout.Padding = UDim.new(0,2)
actLayout.SortOrder = Enum.SortOrder.LayoutOrder

local actPad = Instance.new("UIPadding", activityScroll)
actPad.PaddingLeft = UDim.new(0,5)
actPad.PaddingRight = UDim.new(0,5)
actPad.PaddingTop = UDim.new(0,4)
actPad.PaddingBottom = UDim.new(0,4)

local activityCountLabel = createLabel(monitorPage, "Logs: 0", Color3.fromRGB(0,180,80))

local function addActivityLog(playerName, activity, logType)
    activityCount = activityCount + 1
    local playerColor, actColor
    if logType == "damage" then
        playerColor = "ff5555"; actColor = "ff8888"
    elseif logType == "death" then
        playerColor = "ff4444"; actColor = "ff6666"
    elseif logType == "system" then
        playerColor = "ffcc44"; actColor = "ffdd88"
    elseif logType == "tool" then
        playerColor = "cc88ff"; actColor = "ddaaff"
    else
        playerColor = "00e664"; actColor = "aaffcc"
    end

    local row = Instance.new("Frame", activityScroll)
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundColor3 = activityCount % 2 == 0 and Color3.fromRGB(13,18,13) or Color3.fromRGB(10,14,10)
    row.BorderSizePixel = 0
    row.LayoutOrder = activityCount
    corner(row, UDim.new(0,4))

    local pad = Instance.new("UIPadding", row)
    pad.PaddingLeft = UDim.new(0,8)
    pad.PaddingRight = UDim.new(0,8)
    pad.PaddingTop = UDim.new(0,5)
    pad.PaddingBottom = UDim.new(0,5)

    local rl = Instance.new("UIListLayout", row)
    rl.SortOrder = Enum.SortOrder.LayoutOrder
    rl.Padding = UDim.new(0,1)

    local function makeLine(order, label, value, valColor)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,0,0,0)
        lbl.AutomaticSize = Enum.AutomaticSize.Y
        lbl.BackgroundTransparency = 1
        lbl.RichText = true
        lbl.Text = string.format('<font color="#4d9966"><b>%s</b></font><font color="#2a5c3a"> : </font><font color="#%s">%s</font>',
            label, valColor, value)
        lbl.TextColor3 = Color3.fromRGB(200,230,200)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order
        lbl.Parent = row
    end

    makeLine(1, "Player  ", playerName, playerColor)
    makeLine(2, "Waktu   ", os.date("%H:%M:%S"), "888888")
    makeLine(3, "Aktivitas", activity, actColor)

    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1,0,0,1)
    div.BackgroundColor3 = Color3.fromRGB(0,60,30)
    div.BorderSizePixel = 0
    div.LayoutOrder = 4

    table.insert(activityLogs, row)
    if #activityLogs > MAX_LOGS then
        local old = table.remove(activityLogs, 1)
        if old then old:Destroy() end
    end
    activityCountLabel.Text = "Logs: " .. #activityLogs
    task.defer(function() activityScroll.CanvasPosition = Vector2.new(0, math.huge) end)
end

local clearActBtn = createButton(monitorPage, "Clear Logs", Color3.fromRGB(60,30,80), function()
    for _, v in ipairs(activityLogs) do if v then v:Destroy() end end
    activityLogs = {}
    activityCount = 0
    activityCountLabel.Text = "Logs: 0"
    addActivityLog("Sistem", "Logs dihapus", "system")
end)

-- Activity detection
local activeConnections = {}

local function getPlayerFromPart(part)
    if not part then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and part:IsDescendantOf(p.Character) then
            return p
        end
    end
    return nil
end

local function clearConnections()
    for _, c in ipairs(activeConnections) do pcall(function() c:Disconnect() end) end
    activeConnections = {}
end

local function trackOtherPlayer(p)
    if p == player then return end
    local function onChar(c)
        local c1 = c.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                addActivityLog(p.Name, "Mengequip: " .. child.Name, "tool")
            end
        end)
        local c2 = c.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                addActivityLog(p.Name, "Unequip: " .. child.Name, "tool")
            end
        end)
        table.insert(activeConnections, c1)
        table.insert(activeConnections, c2)
    end
    if p.Character then onChar(p.Character) end
    local conn = p.CharacterAdded:Connect(onChar)
    table.insert(activeConnections, conn)
end

for _, p in ipairs(Players:GetPlayers()) do trackOtherPlayer(p) end
Players.PlayerAdded:Connect(trackOtherPlayer)

local function initActivity(char)
    clearConnections()
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    local lastHealth = humanoid.Health
    local lastDamageSource = nil
    local lastDamageTime = 0

    for _, p in ipairs(Players:GetPlayers()) do trackOtherPlayer(p) end

    local function bindTouched(part)
        if not part:IsA("BasePart") then return end
        local c = part.Touched:Connect(function(hit)
            local attacker = getPlayerFromPart(hit)
            if attacker then
                lastDamageSource = attacker.Name
                lastDamageTime = tick()
            end
        end)
        table.insert(activeConnections, c)
    end

    for _, part in ipairs(char:GetDescendants()) do bindTouched(part) end
    local descConn = char.DescendantAdded:Connect(function(d) bindTouched(d) end)
    table.insert(activeConnections, descConn)

    local healthConn = humanoid.HealthChanged:Connect(function(newHp)
        local delta = newHp - lastHealth
        if math.abs(delta) < 0.5 then lastHealth = newHp return end
        local source = (lastDamageSource and (tick() - lastDamageTime) < 1.5) and lastDamageSource or "Sistem"
        local isSystem = (source == "Sistem")
        if delta < 0 then
            local dmg = math.abs(math.floor(delta))
            addActivityLog(source, string.format("Damage %d HP", dmg), isSystem and "system" or "damage")
            lastDamageSource = nil
        end
        lastHealth = newHp
    end)
    table.insert(activeConnections, healthConn)

    local diedConn = humanoid.Died:Connect(function()
        local source = (lastDamageSource and (tick() - lastDamageTime) < 3) and lastDamageSource or "Sistem"
        addActivityLog(source, "Mati" .. (source ~= "Sistem" and " (dibunuh)" or ""), "death")
        lastDamageSource = nil
    end)
    table.insert(activeConnections, diedConn)

    local stateConn = humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Seated then
            addActivityLog("Sistem", "Duduk/naik kendaraan", "system")
        elseif new == Enum.HumanoidStateType.Swimming then
            addActivityLog("Sistem", "Masuk air", "system")
        end
    end)
    table.insert(activeConnections, stateConn)

    local ta = char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            addActivityLog("Sistem", "Kamu equip: " .. child.Name, "tool")
        end
    end)
    local tr = char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            addActivityLog("Sistem", "Kamu unequip: " .. child.Name, "tool")
        end
    end)
    table.insert(activeConnections, ta)
    table.insert(activeConnections, tr)
end

player.CharacterAdded:Connect(function(char)
    addActivityLog("Sistem", "Respawn", "system")
    initActivity(char)
end)

if player.Character then initActivity(player.Character) end
addActivityLog("Sistem", "Activity Monitor aktif", "system")

-- ===================== TOOLS TAB =====================
local toolsPage = pages["TOOLS"]

-- PLAYER TELEPORT
local selectedPlayer = nil
local hasTPed = false
local followConnection = nil

local function getCharacterBehind(targetChar)
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    return root.CFrame * CFrame.new(0, 0, 4)
end

local function stopFollow()
    if followConnection then followConnection:Disconnect(); followConnection = nil end
end

local function startFollow(targetPlayer)
    stopFollow()
    followConnection = RunService.Heartbeat:Connect(function()
        local myChar = player.Character
        local targetChar = targetPlayer.Character
        if not myChar or not targetChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local behindCF = getCharacterBehind(targetChar)
        if behindCF then myRoot.CFrame = behindCF end
    end)
end

local function doTeleport()
    if not selectedPlayer then return end
    local targetChar = selectedPlayer.Character
    if not targetChar then return end
    local behindCF = getCharacterBehind(targetChar)
    if not behindCF then return end
    local myChar = player.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    myRoot.CFrame = behindCF
    hasTPed = true
    startFollow(selectedPlayer)
end

local function doTurun()
    if not hasTPed then return end
    stopFollow()
    local myChar = player.Character
    if not myChar then return end
    local humanoid = myChar:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
    hasTPed = false
end

-- Player list scroll
local playerListScroll = Instance.new("ScrollingFrame", toolsPage)
playerListScroll.Size = UDim2.new(1, 0, 0, 120)
playerListScroll.BackgroundColor3 = Color3.fromRGB(18,18,24)
playerListScroll.BorderSizePixel = 0
playerListScroll.ScrollBarThickness = 3
playerListScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,120)
playerListScroll.CanvasSize = UDim2.new(0,0,0,0)
playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(playerListScroll, UDim.new(0,6))

local plLayout = Instance.new("UIListLayout", playerListScroll)
plLayout.Padding = UDim.new(0,4)
plLayout.SortOrder = Enum.SortOrder.Name

local plPad = Instance.new("UIPadding", playerListScroll)
plPad.PaddingTop = UDim.new(0,6)
plPad.PaddingLeft = UDim.new(0,6)
plPad.PaddingRight = UDim.new(0,6)

local selectedLabel = createLabel(toolsPage, "Selected: None", Color3.fromRGB(200,200,220))
local playerCards = {}

local function updateSelectedDisplay(p)
    if p then
        selectedLabel.Text = "Selected: @" .. p.Name .. " (" .. p.DisplayName .. ")"
    else
        selectedLabel.Text = "Selected: None"
    end
end

local function clearPlayerList()
    for _, card in pairs(playerCards) do card:Destroy() end
    playerCards = {}
end

local function buildPlayerCard(p)
    if p == player then return end
    local card = Instance.new("TextButton", playerListScroll)
    card.Size = UDim2.new(1, 0, 0, 28)
    card.BackgroundColor3 = Color3.fromRGB(25,25,35)
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    corner(card, UDim.new(0,8))

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "@" .. p.Name
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(220,220,240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    card.MouseButton1Click:Connect(function()
        for _, c in pairs(playerCards) do c.BackgroundColor3 = Color3.fromRGB(25,25,35) end
        card.BackgroundColor3 = Color3.fromRGB(40,50,100)
        selectedPlayer = p
        hasTPed = false
        stopFollow()
        updateSelectedDisplay(p)
    end)

    table.insert(playerCards, card)
end

local function rebuildPlayerList()
    clearPlayerList()
    for _, p in ipairs(Players:GetPlayers()) do buildPlayerCard(p) end
end

for _, p in ipairs(Players:GetPlayers()) do buildPlayerCard(p) end
Players.PlayerAdded:Connect(buildPlayerCard)
Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then selectedPlayer = nil; hasTPed = false; stopFollow(); updateSelectedDisplay(nil) end
    rebuildPlayerList()
end)

local tpBtn = createButton(toolsPage, "Teleport ke Player", Color3.fromRGB(70,100,255), function()
    if not selectedPlayer then return end
    doTeleport()
end)

local turunBtn = createButton(toolsPage, "Turun (Stop Follow)", Color3.fromRGB(35,35,50), function()
    if not hasTPed then return end
    doTurun()
end)

-- TELEPORT LOCATION
local savedLocations = {}
local locScroll = Instance.new("ScrollingFrame", toolsPage)
locScroll.Size = UDim2.new(1, 0, 0, 120)
locScroll.BackgroundColor3 = Color3.fromRGB(18,18,24)
locScroll.BorderSizePixel = 0
locScroll.ScrollBarThickness = 3
locScroll.ScrollBarImageColor3 = Color3.fromRGB(80,120,255)
locScroll.CanvasSize = UDim2.new(0,0,0,0)
locScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(locScroll, UDim.new(0,6))

local locLayout = Instance.new("UIListLayout", locScroll)
locLayout.Padding = UDim.new(0,6)
locLayout.SortOrder = Enum.SortOrder.LayoutOrder

local locPad = Instance.new("UIPadding", locScroll)
locPad.PaddingLeft = UDim.new(0,6)
locPad.PaddingRight = UDim.new(0,6)
locPad.PaddingTop = UDim.new(0,6)
locPad.PaddingBottom = UDim.new(0,6)

local function LoadSaves()
    local data = player.PlayerGui:FindFirstChild("__TSData")
    if data and data:IsA("StringValue") then
        pcall(function() savedLocations = HttpService:JSONDecode(data.Value) end)
    end
end

local function CommitSaves()
    local container = player.PlayerGui:FindFirstChild("__TSData")
    if not container then
        container = Instance.new("StringValue")
        container.Name = "__TSData"
        container.Parent = player.PlayerGui
    end
    container.Value = HttpService:JSONEncode(savedLocations)
end

LoadSaves()

local function TeleportTo(pos)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y + 500, pos.Z))
    task.wait()
    hrp.CFrame = CFrame.new(pos)
end

local function RenderLocations()
    for _, child in ipairs(locScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for i, loc in ipairs(savedLocations) do
        local slot = Instance.new("Frame", locScroll)
        slot.Size = UDim2.new(1, 0, 0, 36)
        slot.BackgroundColor3 = Color3.fromRGB(28,28,42)
        slot.BorderSizePixel = 0
        slot.LayoutOrder = i
        corner(slot, UDim.new(0,6))
        stroke(slot, Color3.fromRGB(60,80,160), 1, 0.5)

        local nameLbl = Instance.new("TextLabel", slot)
        nameLbl.Size = UDim2.new(1, -80, 0.5, 0)
        nameLbl.Position = UDim2.new(0, 8, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "📌 " .. loc.name
        nameLbl.TextColor3 = Color3.fromRGB(200,220,255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local coordLbl = Instance.new("TextLabel", slot)
        coordLbl.Size = UDim2.new(1, -80, 0.5, 0)
        coordLbl.Position = UDim2.new(0, 8, 0.5, 0)
        coordLbl.BackgroundTransparency = 1
        coordLbl.Text = string.format("X:%.0f Y:%.0f Z:%.0f", loc.x, loc.y, loc.z)
        coordLbl.TextColor3 = Color3.fromRGB(120,130,160)
        coordLbl.Font = Enum.Font.Gotham
        coordLbl.TextSize = 10
        coordLbl.TextXAlignment = Enum.TextXAlignment.Left

        local tpLocBtn = Instance.new("TextButton", slot)
        tpLocBtn.Size = UDim2.new(0, 36, 0, 26)
        tpLocBtn.Position = UDim2.new(1, -42, 0.5, -13)
        tpLocBtn.BackgroundColor3 = Color3.fromRGB(40,160,100)
        tpLocBtn.Text = "TP"
        tpLocBtn.TextColor3 = Color3.fromRGB(255,255,255)
        tpLocBtn.Font = Enum.Font.GothamBold
        tpLocBtn.TextSize = 11
        tpLocBtn.BorderSizePixel = 0
        corner(tpLocBtn, UDim.new(0,4))

        local delLocBtn = Instance.new("TextButton", slot)
        delLocBtn.Size = UDim2.new(0, 28, 0, 26)
        delLocBtn.Position = UDim2.new(1, -72, 0.5, -13)
        delLocBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
        delLocBtn.Text = "×"
        delLocBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delLocBtn.Font = Enum.Font.GothamBold
        delLocBtn.TextSize = 13
        delLocBtn.BorderSizePixel = 0
        corner(delLocBtn, UDim.new(0,4))

        local capturedLoc = loc
        local capturedIndex = i

        tpLocBtn.MouseButton1Click:Connect(function()
            TeleportTo(Vector3.new(capturedLoc.x, capturedLoc.y, capturedLoc.z))
        end)

        delLocBtn.MouseButton1Click:Connect(function()
            table.remove(savedLocations, capturedIndex)
            CommitSaves()
            RenderLocations()
        end)
    end
end

local function ShowNameInput(callback)
    -- Sederhana: langsung pake input box di UI
    local nameInput = createInput(toolsPage, "Nama lokasi...", function(text)
        if text and text ~= "" then callback(text) end
    end)
    -- Hapus setelah enter? biarkan saja
end

local saveCurrentBtn = createButton(toolsPage, "Simpan Lokasi Sekarang", Color3.fromRGB(60,100,255), function()
    if #savedLocations >= 10 then
        createLabel(toolsPage, "⚠ Maks 10 lokasi!", Color3.fromRGB(255,80,80))
        return
    end
    -- Kita akan buat popup sederhana dengan input
    local nameInput = createInput(toolsPage, "Nama lokasi...", function(text)
        if text and text ~= "" then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local pos = hrp.Position
            table.insert(savedLocations, {name = text, x = pos.X, y = pos.Y, z = pos.Z})
            CommitSaves()
            RenderLocations()
            nameInput:Destroy()
        end
    end)
end)

local manualCoordBtn = createButton(toolsPage, "Input Koordinat Manual", Color3.fromRGB(40,130,130), function()
    if #savedLocations >= 10 then
        createLabel(toolsPage, "⚠ Maks 10 lokasi!", Color3.fromRGB(255,80,80))
        return
    end
    -- Buat input X, Y, Z, Nama
    local xInput = createInput(toolsPage, "X", function() end)
    local yInput = createInput(toolsPage, "Y", function() end)
    local zInput = createInput(toolsPage, "Z", function() end)
    local nInput = createInput(toolsPage, "Nama", function() end)

    local submitBtn = createButton(toolsPage, "Simpan", Color3.fromRGB(40,160,160), function()
        local nx = tonumber(xInput.Text)
        local ny = tonumber(yInput.Text)
        local nz = tonumber(zInput.Text)
        local name = nInput.Text:match("^%s*(.-)%s*$")
        if not nx or not ny or not nz or name == "" then
            createLabel(toolsPage, "⚠ Data tidak valid", Color3.fromRGB(255,80,80))
            return
        end
        table.insert(savedLocations, {name = name, x = nx, y = ny, z = nz})
        CommitSaves()
        RenderLocations()
        -- Hapus input fields
        xInput:Destroy(); yInput:Destroy(); zInput:Destroy(); nInput:Destroy(); submitBtn:Destroy()
    end)
end)

RenderLocations()

-- ============================================================
-- FINAL TOUCH: Pastikan semua page auto size berfungsi
-- ============================================================
for _, page in pairs(pages) do
    if page:IsA("ScrollingFrame") then
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    end
end

print("HEXVEIL UI + ALL FEATURES LOADED SUCCESSFULLY!")
