-- HEXVEIL | Creator: Nazam
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Cleanup old GUIs
for _, name in ipairs({"HEXVEIL_MAIN"}) do
    local old = game.CoreGui:FindFirstChild(name) or lp.PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- THEME
local T = {
    BG       = Color3.fromRGB(12, 12, 16),
    BG2      = Color3.fromRGB(18, 18, 24),
    BG3      = Color3.fromRGB(24, 24, 32),
    PANEL    = Color3.fromRGB(16, 16, 22),
    ACCENT   = Color3.fromRGB(160, 170, 200),
    GLOW     = Color3.fromRGB(200, 210, 255),
    DIM      = Color3.fromRGB(70, 75, 100),
    ON       = Color3.fromRGB(210, 215, 255),
    OFF      = Color3.fromRGB(55, 58, 80),
    KNOB_ON  = Color3.fromRGB(15, 15, 20),
    KNOB_OFF = Color3.fromRGB(130, 135, 160),
    RED      = Color3.fromRGB(220, 80, 80),
    GREEN    = Color3.fromRGB(80, 200, 130),
    TEXT     = Color3.fromRGB(200, 205, 230),
    SUBTEXT  = Color3.fromRGB(100, 105, 140),
    STROKE   = Color3.fromRGB(40, 42, 60),
    STROKE2  = Color3.fromRGB(60, 65, 95),
}

-- SOUND
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6026984224"
clickSound.Volume = 0.4
clickSound.Parent = SoundService

local toggleSound = Instance.new("Sound")
toggleSound.SoundId = "rbxassetid://6026984224"
toggleSound.Volume = 0.3
toggleSound.Parent = SoundService

local function playClick()
    clickSound:Play()
end

-- Background music
local bgMusic = Instance.new("Sound")
bgMusic.SoundId = "rbxassetid://125026658817868"
bgMusic.Volume = 0.2
bgMusic.Looped = true
bgMusic.Parent = SoundService

local musicEnabled = false
local function setMusic(on)
    musicEnabled = on
    if on then bgMusic:Play() else bgMusic:Stop() end
end

-- HELPERS
local function corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or T.STROKE
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    return s
end

local function tween(obj, props, t, style, dir)
    return TweenService:Create(obj,
        TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props)
end

local function makeDrag(frame, handle)
    local drag, ds, fp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; fp = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - ds
            frame.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X, fp.Y.Scale, fp.Y.Offset + d.Y)
        end
    end)
end

-- ROOT GUI
local sg = Instance.new("ScreenGui")
sg.Name = "HEXVEIL_MAIN"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = game.CoreGui

-- TOAST
local function toast(msg, color)
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 280, 0, 40)
    f.Position = UDim2.new(0.5, -140, 0, -50)
    f.BackgroundColor3 = T.BG2
    f.BorderSizePixel = 0
    f.ZIndex = 100
    corner(f, 10)
    stroke(f, color or T.GLOW, 1)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = msg
    lbl.TextColor3 = color or T.GLOW
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.ZIndex = 101
    tween(f, {Position = UDim2.new(0.5, -140, 0, 14)}, 0.2, Enum.EasingStyle.Quart):Play()
    task.delay(2.5, function()
        local tw = tween(f, {Position = UDim2.new(0.5, -140, 0, -50)}, 0.2, Enum.EasingStyle.Quart)
        tw:Play(); tw.Completed:Connect(function() f:Destroy() end)
    end)
end

-- MINIMIZE BAR (pill shape, top center)
local pillW, pillH = 220, 36
local pill = Instance.new("TextButton", sg)
pill.Size = UDim2.new(0, pillW, 0, pillH)
pill.Position = UDim2.new(0.5, -pillW/2, 0, 8)
pill.BackgroundColor3 = T.BG2
pill.BorderSizePixel = 0
pill.Text = ""
pill.ZIndex = 90
pill.AutoButtonColor = false
corner(pill, pillH/2)
stroke(pill, T.STROKE2, 1)

-- Pill inner shadow glow effect
local pillGlow = Instance.new("UIGradient", pill)
pillGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,32,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14,14,20)),
})
pillGlow.Rotation = 90

local pillDot = Instance.new("Frame", pill)
pillDot.Size = UDim2.new(0, 7, 0, 7)
pillDot.Position = UDim2.new(0, 14, 0.5, -3)
pillDot.BackgroundColor3 = T.GLOW
pillDot.BorderSizePixel = 0
corner(pillDot, 4)

local pillLabel = Instance.new("TextLabel", pill)
pillLabel.Size = UDim2.new(1, -30, 1, 0)
pillLabel.Position = UDim2.new(0, 26, 0, 0)
pillLabel.BackgroundTransparency = 1
pillLabel.Text = "HEXVEIL"
pillLabel.Font = Enum.Font.GothamBold
pillLabel.TextSize = 13
pillLabel.TextColor3 = T.TEXT
pillLabel.TextXAlignment = Enum.TextXAlignment.Left
pillLabel.LetterSpacing = 4

-- Pulse dot animation
task.spawn(function()
    while true do
        tween(pillDot, {BackgroundTransparency = 0}, 0.6):Play()
        task.wait(0.6)
        tween(pillDot, {BackgroundTransparency = 0.7}, 0.4):Play()
        task.wait(0.5)
    end
end)

-- MAIN WINDOW
local winW, winH = 460, 580
local win = Instance.new("Frame", sg)
win.Size = UDim2.new(0, winW, 0, winH)
win.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
win.BackgroundColor3 = T.BG
win.BorderSizePixel = 0
win.ZIndex = 10
win.ClipsDescendants = true
corner(win, 14)
stroke(win, T.STROKE2, 1)

-- Window gradient
local winGrad = Instance.new("UIGradient", win)
winGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,15)),
})
winGrad.Rotation = 135

-- HEADER
local hdr = Instance.new("Frame", win)
hdr.Size = UDim2.new(1, 0, 0, 52)
hdr.BackgroundColor3 = T.BG2
hdr.BorderSizePixel = 0
hdr.ZIndex = 11

local hdrDiv = Instance.new("Frame", hdr)
hdrDiv.Size = UDim2.new(1, 0, 0, 1)
hdrDiv.Position = UDim2.new(0, 0, 1, -1)
hdrDiv.BackgroundColor3 = T.STROKE2
hdrDiv.BorderSizePixel = 0
hdrDiv.ZIndex = 12

local hdrTitle = Instance.new("TextLabel", hdr)
hdrTitle.Size = UDim2.new(0, 200, 1, 0)
hdrTitle.Position = UDim2.new(0, 18, 0, 0)
hdrTitle.BackgroundTransparency = 1
hdrTitle.Text = "HEXVEIL"
hdrTitle.Font = Enum.Font.GothamBold
hdrTitle.TextSize = 16
hdrTitle.TextColor3 = T.TEXT
hdrTitle.TextXAlignment = Enum.TextXAlignment.Left
hdrTitle.LetterSpacing = 6
hdrTitle.ZIndex = 12

local hdrSub = Instance.new("TextLabel", hdr)
hdrSub.Size = UDim2.new(0, 180, 0, 14)
hdrSub.Position = UDim2.new(0, 19, 0, 30)
hdrSub.BackgroundTransparency = 1
hdrSub.Text = "by Nazam"
hdrSub.Font = Enum.Font.Gotham
hdrSub.TextSize = 10
hdrSub.TextColor3 = T.SUBTEXT
hdrSub.TextXAlignment = Enum.TextXAlignment.Left
hdrSub.ZIndex = 12

-- Music toggle in header
local musicBtn = Instance.new("TextButton", hdr)
musicBtn.Size = UDim2.new(0, 70, 0, 26)
musicBtn.Position = UDim2.new(1, -82, 0.5, -13)
musicBtn.BackgroundColor3 = T.OFF
musicBtn.BorderSizePixel = 0
musicBtn.Text = "MUSIC"
musicBtn.TextColor3 = T.SUBTEXT
musicBtn.Font = Enum.Font.GothamBold
musicBtn.TextSize = 10
musicBtn.AutoButtonColor = false
musicBtn.ZIndex = 12
corner(musicBtn, 6)

musicBtn.MouseButton1Click:Connect(function()
    playClick()
    musicEnabled = not musicEnabled
    setMusic(musicEnabled)
    if musicEnabled then
        tween(musicBtn, {BackgroundColor3 = T.ON, TextColor3 = T.KNOB_ON}):Play()
    else
        tween(musicBtn, {BackgroundColor3 = T.OFF, TextColor3 = T.SUBTEXT}):Play()
    end
end)

makeDrag(win, hdr)

-- TABS
local tabNames = {"COMBAT", "MOVEMENT", "UTILITY", "MONITOR", "TOOLS"}
local tabBtns = {}
local tabPages = {}
local activeTab = nil

local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1, 0, 0, 38)
tabBar.Position = UDim2.new(0, 0, 0, 52)
tabBar.BackgroundColor3 = T.BG2
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 11

local tabBarDiv = Instance.new("Frame", tabBar)
tabBarDiv.Size = UDim2.new(1, 0, 0, 1)
tabBarDiv.Position = UDim2.new(0, 0, 1, -1)
tabBarDiv.BackgroundColor3 = T.STROKE
tabBarDiv.BorderSizePixel = 0
tabBarDiv.ZIndex = 12

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 0)

-- Content area
local content = Instance.new("Frame", win)
content.Size = UDim2.new(1, 0, 1, -90)
content.Position = UDim2.new(0, 0, 0, 90)
content.BackgroundTransparency = 1
content.ZIndex = 10

local function makeTabPage()
    local p = Instance.new("ScrollingFrame", content)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = T.STROKE2
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false
    p.ZIndex = 10
    local layout = Instance.new("UIListLayout", p)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", p)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    return p
end

local function switchTab(name)
    for _, tname in ipairs(tabNames) do
        local btn = tabBtns[tname]
        local page = tabPages[tname]
        if tname == name then
            page.Visible = true
            tween(btn, {BackgroundColor3 = T.BG3, TextColor3 = T.TEXT}):Play()
            local ind = btn:FindFirstChild("_ind")
            if ind then tween(ind, {BackgroundTransparency = 0}):Play() end
        else
            page.Visible = false
            tween(btn, {BackgroundColor3 = T.BG2, TextColor3 = T.SUBTEXT}):Play()
            local ind = btn:FindFirstChild("_ind")
            if ind then tween(ind, {BackgroundTransparency = 1}):Play() end
        end
    end
    activeTab = name
end

local tabW = math.floor(winW / #tabNames)
for i, tname in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Name = tname
    btn.Size = UDim2.new(0, tabW, 1, 0)
    btn.BackgroundColor3 = T.BG2
    btn.BorderSizePixel = 0
    btn.Text = tname
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextColor3 = T.SUBTEXT
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 12

    local ind = Instance.new("Frame", btn)
    ind.Name = "_ind"
    ind.Size = UDim2.new(0.7, 0, 0, 2)
    ind.Position = UDim2.new(0.15, 0, 1, -2)
    ind.BackgroundColor3 = T.GLOW
    ind.BorderSizePixel = 0
    ind.BackgroundTransparency = 1
    ind.ZIndex = 13
    corner(ind, 1)

    tabBtns[tname] = btn
    tabPages[tname] = makeTabPage()

    btn.MouseButton1Click:Connect(function()
        playClick()
        switchTab(tname)
    end)
end

-- WIDGET BUILDERS
local function makeSection(page, title)
    local sec = Instance.new("Frame", page)
    sec.Size = UDim2.new(1, 0, 0, 28)
    sec.BackgroundTransparency = 1
    sec.ZIndex = 10
    local lbl = Instance.new("TextLabel", sec)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = T.SUBTEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.LetterSpacing = 3
    local div = Instance.new("Frame", sec)
    div.Size = UDim2.new(1, 0, 0, 1)
    div.Position = UDim2.new(0, 0, 1, -1)
    div.BackgroundColor3 = T.STROKE
    div.BorderSizePixel = 0
    div.ZIndex = 11
    return sec
end

local function makeToggleRow(page, labelText, onToggle, order)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = T.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    row.ZIndex = 10
    corner(row, 10)
    stroke(row, T.STROKE, 1)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -72, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = T.SUBTEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0, 46, 0, 24)
    track.Position = UDim2.new(1, -58, 0.5, -12)
    track.BackgroundColor3 = T.OFF
    track.BorderSizePixel = 0
    track.ZIndex = 11
    corner(track, 12)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = T.KNOB_OFF
    knob.BorderSizePixel = 0
    knob.ZIndex = 12
    corner(knob, 9)

    local clickBtn = Instance.new("TextButton", row)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 13
    clickBtn.AutoButtonColor = false

    local state = false
    local function setState(on)
        state = on
        if on then
            tween(track, {BackgroundColor3 = T.ON}):Play()
            tween(knob, {Position = UDim2.new(0, 25, 0.5, -9), BackgroundColor3 = T.KNOB_ON}):Play()
            tween(lbl, {TextColor3 = T.TEXT}):Play()
        else
            tween(track, {BackgroundColor3 = T.OFF}):Play()
            tween(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = T.KNOB_OFF}):Play()
            tween(lbl, {TextColor3 = T.SUBTEXT}):Play()
        end
    end

    clickBtn.MouseButton1Click:Connect(function()
        playClick()
        state = not state
        setState(state)
        if onToggle then onToggle(state) end
    end)

    return row, setState, function() return state end
end

local function makeSliderRow(page, labelText, minV, maxV, defV, step, onChange, order)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 60)
    row.BackgroundColor3 = T.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    row.ZIndex = 10
    corner(row, 10)
    stroke(row, T.STROKE, 1)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.Position = UDim2.new(0, 14, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = T.TEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size = UDim2.new(0.35, 0, 0, 20)
    valLbl.Position = UDim2.new(0.65, -14, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defV)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11
    valLbl.TextColor3 = T.GLOW
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 11

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -28, 0, 4)
    track.Position = UDim2.new(0, 14, 0, 36)
    track.BackgroundColor3 = T.STROKE2
    track.BorderSizePixel = 0
    track.ZIndex = 11
    corner(track, 2)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defV - minV)/(maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = T.GLOW
    fill.BorderSizePixel = 0
    fill.ZIndex = 12
    corner(fill, 2)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((defV - minV)/(maxV - minV), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    corner(knob, 7)

    local val = defV
    local sliding = false

    local function setVal(v)
        v = math.clamp(math.floor((v / step) + 0.5) * step, minV, maxV)
        val = v
        local pct = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valLbl.Text = tostring(v)
        if onChange then onChange(v) end
    end

    local hitbox = Instance.new("TextButton", row)
    hitbox.Size = UDim2.new(1, -28, 0, 20)
    hitbox.Position = UDim2.new(0, 14, 0, 28)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.ZIndex = 14
    hitbox.AutoButtonColor = false

    hitbox.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
        end
    end)
    hitbox.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local abs = track.AbsolutePosition
            local sz = track.AbsoluteSize
            local pct = math.clamp((i.Position.X - abs.X) / sz.X, 0, 1)
            setVal(minV + pct * (maxV - minV))
        end
    end)

    return row, setVal, function() return val end
end

local function makeButtonRow(page, btnText, onClick, order, color)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = T.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    row.ZIndex = 10
    corner(row, 10)
    stroke(row, T.STROKE, 1)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, -28, 0, 30)
    btn.Position = UDim2.new(0, 14, 0.5, -15)
    btn.BackgroundColor3 = color or T.BG3
    btn.BorderSizePixel = 0
    btn.Text = btnText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = T.TEXT
    btn.AutoButtonColor = false
    btn.ZIndex = 11
    corner(btn, 8)
    stroke(btn, T.STROKE2, 1)

    btn.MouseButton1Click:Connect(function()
        playClick()
        tween(btn, {BackgroundColor3 = T.BG3}, 0.05):Play()
        task.delay(0.1, function()
            tween(btn, {BackgroundColor3 = color or T.BG3}, 0.1):Play()
        end)
        if onClick then onClick() end
    end)
    return row, btn
end

local function makeDisplayRow(page, label, defVal, order)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = T.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 0
    row.ZIndex = 10
    corner(row, 10)
    stroke(row, T.STROKE, 1)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = T.SUBTEXT
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11

    local val = Instance.new("TextLabel", row)
    val.Size = UDim2.new(0.5, -14, 1, 0)
    val.Position = UDim2.new(0.5, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = defVal or "--"
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextColor3 = T.GLOW
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.ZIndex = 11

    return row, val
end

-- =============================================
-- TAB: COMBAT (Aimbot, ESP)
-- =============================================
local pgCombat = tabPages["COMBAT"]
makeSection(pgCombat, "COMBAT"):LayoutOrder = 0

-- AIMBOT
local aimbotEnabled = false
local lockConn
local aimbotSmooth = 0.12

local function getNearestPlayer()
    local nearest, minDist = nil, math.huge
    local myChar = lp.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local vpSize = cam.ViewportSize
    local cx, cy = vpSize.X/2, vpSize.Y/2
    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        local char = p.Character
        if not char then continue end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local sp, onScreen = cam:WorldToScreenPoint(head.Position)
        if not onScreen then continue end
        local dist = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
        if dist < minDist then minDist = dist; nearest = p end
    end
    return nearest
end

local function startAimbot()
    if lockConn then return end
    lockConn = RunService.RenderStepped:Connect(function()
        local delta = UserInputService:GetMouseDelta()
        if delta.Magnitude > 1.5 then return end
        local target = getNearestPlayer()
        if not target then return end
        local char = target.Character
        if not char then return end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then return end
        local camCF = cam.CFrame
        local dir = (head.Position - camCF.Position).Unit
        local goal = CFrame.lookAt(camCF.Position, camCF.Position + dir)
        cam.CFrame = camCF:Lerp(goal, aimbotSmooth)
    end)
end

local function stopAimbot()
    if lockConn then lockConn:Disconnect(); lockConn = nil end
end

local _, setAimbot = makeToggleRow(pgCombat, "Aimbot", function(on)
    aimbotEnabled = on
    if on then startAimbot() else stopAimbot() end
end, 1)

local _, setSmoothSlider = makeSliderRow(pgCombat, "Aimbot Smoothness", 1, 30, 12, 1, function(v)
    aimbotSmooth = v / 100
end, 2)

-- ESP
local espData = {}
local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "HEXVEIL_ESP"
espFolder.Parent = game.CoreGui

local function createESPTag(player)
    if player == lp then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 70, 0, 90)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Enabled = false
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
    corner(avatarFrame, 24)

    local avatarImg = Instance.new("ImageLabel", avatarFrame)
    avatarImg.Size = UDim2.new(1, -4, 1, -4)
    avatarImg.Position = UDim2.new(0, 2, 0, 2)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = ""
    corner(avatarImg, 22)

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and img then avatarImg.Image = img end
    end)

    local distLbl = Instance.new("TextLabel", frame)
    distLbl.Name = "DistLabel"
    distLbl.Size = UDim2.new(1, 0, 0, 20)
    distLbl.Position = UDim2.new(0, 0, 0, 52)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "-- studs"
    distLbl.TextColor3 = T.GLOW
    distLbl.TextStrokeTransparency = 0
    distLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    distLbl.TextSize = 11
    distLbl.Font = Enum.Font.GothamBold

    local nameLbl = Instance.new("TextLabel", frame)
    nameLbl.Size = UDim2.new(1, 0, 0, 16)
    nameLbl.Position = UDim2.new(0, 0, 0, 72)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = player.Name
    nameLbl.TextColor3 = T.TEXT
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLbl.TextSize = 10
    nameLbl.Font = Enum.Font.GothamBold

    espData[player] = billboard

    local function attach(char)
        local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        if root then billboard.Adornee = root end
    end

    if player.Character then attach(player.Character) end
    player.CharacterAdded:Connect(function(char)
        billboard.Adornee = nil
        attach(char)
    end)
end

local function removeESPTag(player)
    if espData[player] then espData[player]:Destroy(); espData[player] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do createESPTag(p) end
Players.PlayerAdded:Connect(createESPTag)
Players.PlayerRemoving:Connect(removeESPTag)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local localChar = lp.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    for player, bb in pairs(espData) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            bb.Enabled = true
            bb.Adornee = root
            if localRoot then
                local dist = math.floor((localRoot.Position - root.Position).Magnitude)
                local dl = bb:FindFirstChildOfClass("Frame") and bb:FindFirstChildOfClass("Frame"):FindFirstChild("DistLabel")
                if dl then dl.Text = dist .. " studs" end
            end
        else
            bb.Enabled = false
        end
    end
end)

local _, setESP = makeToggleRow(pgCombat, "ESP", function(on)
    espEnabled = on
    for _, bb in pairs(espData) do
        if not on then bb.Enabled = false end
    end
end, 3)

-- =============================================
-- TAB: MOVEMENT (Fly, Speed, InfJump, NoClip, AirWalk, Spin, Dash)
-- =============================================
local pgMove = tabPages["MOVEMENT"]
makeSection(pgMove, "MOVEMENT"):LayoutOrder = 0

-- FLY
local flyEnabled = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local function enableFly()
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    hum.PlatformStand = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Parent = root
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bodyGyro.D = 100
    bodyGyro.P = 1e4
    bodyGyro.Parent = root
end

local function disableFly()
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = false end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
end

RunService.RenderStepped:Connect(function()
    if not flyEnabled or not bodyVelocity or not bodyGyro then return end
    local camCF = cam.CFrame
    local camY = math.atan2(-camCF.LookVector.X, -camCF.LookVector.Z)
    local camPitch = math.asin(math.clamp(camCF.LookVector.Y, -1, 1))
    local camRight = camCF.RightVector
    local camFwd = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
    if camFwd.Magnitude > 0 then camFwd = camFwd.Unit end
    local raw = Vector2.zero
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then raw += Vector2.new(0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then raw += Vector2.new(0,-1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then raw += Vector2.new(-1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then raw += Vector2.new(1,0) end
        if raw.Magnitude > 1 then raw = raw.Unit end
    else
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            local md = hum.MoveDirection
            raw = Vector2.new(md:Dot(camRight), md:Dot(camFwd))
        end
    end
    if raw.Magnitude < 0.1 then
        bodyVelocity.Velocity = Vector3.zero
    else
        local dir = camFwd * raw.Y + camRight * raw.X
        local pitch = camCF.LookVector.Y
        local final = Vector3.new(dir.X, pitch, dir.Z)
        if final.Magnitude > 0 then final = final.Unit end
        bodyVelocity.Velocity = final * flySpeed * raw.Magnitude
    end
    bodyGyro.CFrame = CFrame.Angles(0, camY, 0) * CFrame.Angles(camPitch, 0, 0)
end)

local _, setFlyToggle = makeToggleRow(pgMove, "Fly", function(on)
    flyEnabled = on
    if on then enableFly() else disableFly() end
end, 1)

makeSliderRow(pgMove, "Fly Speed", 10, 300, 50, 5, function(v) flySpeed = v end, 2)

-- SPEED
local _G_SpeedEnabled = false
local _G_SpeedValue = 16
local function applySpeed()
    if lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = _G_SpeedEnabled and _G_SpeedValue or 16 end
    end
end

local _, setSpeedToggle = makeToggleRow(pgMove, "Speed Booster", function(on)
    _G_SpeedEnabled = on
    applySpeed()
end, 3)

local _, setSpeedSlider, getSpeedVal = makeSliderRow(pgMove, "Walk Speed", 16, 300, 16, 5, function(v)
    _G_SpeedValue = v
    if _G_SpeedEnabled then applySpeed() end
end, 4)

-- INFINITE JUMP
local jumpConn
local function setInfiniteJump(on)
    if on then
        if jumpConn then return end
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if lp.Character then
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        if jumpConn then jumpConn:Disconnect(); jumpConn = nil end
    end
end

local _, setInfJump = makeToggleRow(pgMove, "Infinite Jump", function(on)
    setInfiniteJump(on)
end, 5)

-- NO CLIP
local _G_NoClipEnabled = false
local noClipConn
local function setNoClip(on)
    if on then
        if noClipConn then return end
        noClipConn = RunService.Stepped:Connect(function()
            if lp.Character then
                for _, p in pairs(lp.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
        if lp.Character then
            for _, p in pairs(lp.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

local _, setNoClipToggle = makeToggleRow(pgMove, "No Clip", function(on)
    _G_NoClipEnabled = on
    setNoClip(on)
end, 6)

-- AIR WALK
local airWalkEnabled = false
local airPlatform = nil
local lockedY = nil
local wasInAir = false

local function createPlatform()
    if airPlatform then airPlatform:Destroy() end
    airPlatform = Instance.new("Part")
    airPlatform.Size = Vector3.new(60, 0.2, 60)
    airPlatform.Anchored = true
    airPlatform.CanCollide = true
    airPlatform.Transparency = 1
    airPlatform.CastShadow = false
    airPlatform.Name = "HexveilAirPlatform"
    airPlatform.Parent = workspace
end

local function removePlatform()
    if airPlatform then airPlatform:Destroy(); airPlatform = nil end
    lockedY = nil; wasInAir = false
end

RunService.RenderStepped:Connect(function()
    if not airWalkEnabled then return end
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    if not airPlatform then createPlatform() end
    local pos = root.Position
    local velY = root.AssemblyLinearVelocity.Y
    local feetY = pos.Y - 3.1
    local isJumping = velY > 0.5
    local isFalling = velY < -0.5
    local isInAir = hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Jumping
    if isJumping then
        wasInAir = true
        airPlatform.CFrame = CFrame.new(pos.X, feetY - 50, pos.Z)
        lockedY = nil
    elseif wasInAir and isFalling then
        if lockedY == nil then lockedY = feetY end
        airPlatform.CFrame = CFrame.new(pos.X, lockedY, pos.Z)
    elseif not isInAir and not isJumping then
        wasInAir = false; lockedY = nil
        airPlatform.CFrame = CFrame.new(pos.X, feetY, pos.Z)
    else
        if lockedY then airPlatform.CFrame = CFrame.new(pos.X, lockedY, pos.Z)
        else airPlatform.CFrame = CFrame.new(pos.X, feetY, pos.Z) end
    end
end)

local _, setAirWalk = makeToggleRow(pgMove, "Air Walk", function(on)
    airWalkEnabled = on
    if on then createPlatform() else removePlatform() end
end, 7)

-- SPIN
local spinEnabled = false
local spinSpeed = 550
local spinConn

local function startSpin()
    if spinConn then return end
    spinConn = RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed * RunService.Heartbeat:Wait()), 0)
    end)
end

local function stopSpin()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
end

-- Fix spin using heartbeat dt properly
local spinConn2
local function startSpin2()
    if spinConn2 then return end
    spinConn2 = RunService.Heartbeat:Connect(function(dt)
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed * dt * 10), 0)
    end)
end

local function stopSpin2()
    if spinConn2 then spinConn2:Disconnect(); spinConn2 = nil end
end

local _, setSpinToggle = makeToggleRow(pgMove, "Spin Karakter", function(on)
    spinEnabled = on
    if on then startSpin2() else stopSpin2() end
end, 8)

makeSliderRow(pgMove, "Spin Speed", 50, 2000, 550, 50, function(v) spinSpeed = v end, 9)

lp.CharacterAdded:Connect(function()
    if spinEnabled then stopSpin2(); task.wait(1); startSpin2() end
    if _G_NoClipEnabled then _G_NoClipEnabled = false; setNoClip(false) end
    if _G_SpeedEnabled then _G_SpeedEnabled = false end
    if flyEnabled then disableFly() end
    if airWalkEnabled then removePlatform() end
end)

-- =============================================
-- TAB: UTILITY (Player Teleport, Dash, Teleport Location, Coord Copy)
-- =============================================
local pgUtil = tabPages["UTILITY"]
makeSection(pgUtil, "PLAYER TELEPORT"):LayoutOrder = 0

-- Player list for teleport
local selectedTPPlayer = nil
local hasTPed = false
local followConn2

local function stopFollow2()
    if followConn2 then followConn2:Disconnect(); followConn2 = nil end
end

local function doTeleport2()
    if not selectedTPPlayer then toast("Pilih player dulu!"); return end
    local tChar = selectedTPPlayer.Character
    if not tChar then toast("Player tidak ada karakter"); return end
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local behindCF = tRoot.CFrame * CFrame.new(0, 0, 4)
    local myChar = lp.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    myRoot.CFrame = behindCF
    hasTPed = true
    stopFollow2()
    followConn2 = RunService.Heartbeat:Connect(function()
        local mc = lp.Character; local tc = selectedTPPlayer.Character
        if not mc or not tc then return end
        local mr = mc:FindFirstChild("HumanoidRootPart")
        local tr = tc:FindFirstChild("HumanoidRootPart")
        if mr and tr then mr.CFrame = tr.CFrame * CFrame.new(0, 0, 4) end
    end)
    toast("Teleport ke " .. selectedTPPlayer.Name)
end

-- Selected player display
local selRow = Instance.new("Frame", pgUtil)
selRow.Size = UDim2.new(1, 0, 0, 54)
selRow.BackgroundColor3 = T.BG2
selRow.BorderSizePixel = 0
selRow.LayoutOrder = 1
selRow.ZIndex = 10
corner(selRow, 10)
stroke(selRow, T.STROKE, 1)

local selAvatar = Instance.new("ImageLabel", selRow)
selAvatar.Size = UDim2.new(0, 38, 0, 38)
selAvatar.Position = UDim2.new(0, 8, 0.5, -19)
selAvatar.BackgroundColor3 = T.BG3
selAvatar.BorderSizePixel = 0
selAvatar.Image = ""
corner(selAvatar, 8)

local selName = Instance.new("TextLabel", selRow)
selName.Size = UDim2.new(1, -60, 0, 20)
selName.Position = UDim2.new(0, 54, 0, 8)
selName.BackgroundTransparency = 1
selName.Text = "Pilih player..."
selName.Font = Enum.Font.GothamBold
selName.TextSize = 12
selName.TextColor3 = T.TEXT
selName.TextXAlignment = Enum.TextXAlignment.Left
selName.ZIndex = 11

local selDisplay = Instance.new("TextLabel", selRow)
selDisplay.Size = UDim2.new(1, -60, 0, 16)
selDisplay.Position = UDim2.new(0, 54, 0, 30)
selDisplay.BackgroundTransparency = 1
selDisplay.Text = ""
selDisplay.Font = Enum.Font.Gotham
selDisplay.TextSize = 10
selDisplay.TextColor3 = T.SUBTEXT
selDisplay.TextXAlignment = Enum.TextXAlignment.Left
selDisplay.ZIndex = 11

-- Player scroll list
local plScroll = Instance.new("ScrollingFrame", pgUtil)
plScroll.Size = UDim2.new(1, 0, 0, 160)
plScroll.BackgroundColor3 = T.BG2
plScroll.BorderSizePixel = 0
plScroll.ScrollBarThickness = 3
plScroll.ScrollBarImageColor3 = T.STROKE2
plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.LayoutOrder = 2
plScroll.ZIndex = 10
corner(plScroll, 10)
stroke(plScroll, T.STROKE, 1)

local plLayout = Instance.new("UIListLayout", plScroll)
plLayout.Padding = UDim.new(0, 4)
plLayout.SortOrder = Enum.SortOrder.Name
local plPad = Instance.new("UIPadding", plScroll)
plPad.PaddingLeft = UDim.new(0, 6)
plPad.PaddingRight = UDim.new(0, 6)
plPad.PaddingTop = UDim.new(0, 6)
plPad.PaddingBottom = UDim.new(0, 6)

local plCards = {}

local function updateSelDisplay(p)
    if not p then
        selName.Text = "Pilih player..."
        selDisplay.Text = ""
        selAvatar.Image = ""
        return
    end
    selName.Text = "@" .. p.Name
    selDisplay.Text = p.DisplayName
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then selAvatar.Image = img end
    end)
end

local function buildPlCard(p)
    if p == lp then return end
    local card = Instance.new("TextButton", plScroll)
    card.Size = UDim2.new(1, 0, 0, 44)
    card.BackgroundColor3 = T.BG3
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    card.ZIndex = 11
    corner(card, 8)

    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(0, 30, 0, 30)
    img.Position = UDim2.new(0, 6, 0.5, -15)
    img.BackgroundColor3 = T.BG2
    img.BorderSizePixel = 0
    img.Image = ""
    corner(img, 6)
    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok then img.Image = thumb end
    end)

    local uname = Instance.new("TextLabel", card)
    uname.Size = UDim2.new(1, -46, 0, 16)
    uname.Position = UDim2.new(0, 42, 0, 7)
    uname.BackgroundTransparency = 1
    uname.Text = "@" .. p.Name
    uname.Font = Enum.Font.GothamBold
    uname.TextSize = 11
    uname.TextColor3 = T.TEXT
    uname.TextXAlignment = Enum.TextXAlignment.Left
    uname.ZIndex = 12

    local dname = Instance.new("TextLabel", card)
    dname.Size = UDim2.new(1, -46, 0, 14)
    dname.Position = UDim2.new(0, 42, 0, 24)
    dname.BackgroundTransparency = 1
    dname.Text = p.DisplayName
    dname.Font = Enum.Font.Gotham
    dname.TextSize = 10
    dname.TextColor3 = T.SUBTEXT
    dname.TextXAlignment = Enum.TextXAlignment.Left
    dname.ZIndex = 12

    card.MouseButton1Click:Connect(function()
        playClick()
        for _, c in pairs(plCards) do tween(c, {BackgroundColor3 = T.BG3}):Play() end
        tween(card, {BackgroundColor3 = T.BG2}):Play()
        selectedTPPlayer = p
        hasTPed = false; stopFollow2()
        updateSelDisplay(p)
    end)

    plCards[p] = card
    plLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        plScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 12)
    end)
end

local function rebuildPlList()
    for _, c in pairs(plCards) do c:Destroy() end
    plCards = {}
    for _, p in ipairs(Players:GetPlayers()) do buildPlCard(p) end
end

Players.PlayerAdded:Connect(function(p) buildPlCard(p) end)
Players.PlayerRemoving:Connect(function(p)
    if selectedTPPlayer == p then selectedTPPlayer = nil; updateSelDisplay(nil); stopFollow2() end
    if plCards[p] then plCards[p]:Destroy(); plCards[p] = nil end
end)

rebuildPlList()

local _, tpBtn2 = makeButtonRow(pgUtil, "Teleport ke Player", function()
    doTeleport2()
end, 3, T.BG3)

local _, turunBtn2 = makeButtonRow(pgUtil, "Turun / Berhenti Follow", function()
    stopFollow2(); hasTPed = false
    toast("Follow berhenti")
end, 4, T.BG3)

-- DASH TELEPORT
makeSection(pgUtil, "DASH TELEPORT"):LayoutOrder = 5

local dashEnabled = false
local dashDist = 30

local _, setDashToggle = makeToggleRow(pgUtil, "Dash Teleport", function(on)
    dashEnabled = on
end, 6)

makeSliderRow(pgUtil, "Dash Jarak (studs)", 5, 200, 30, 5, function(v) dashDist = v end, 7)

local _, dashBtn = makeButtonRow(pgUtil, "DASH (klik untuk dash)", function()
    if not dashEnabled then toast("Aktifkan Dash dulu!"); return end
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lookVec = cam.CFrame.LookVector
    local flatDir = Vector3.new(lookVec.X, 0, lookVec.Z)
    if flatDir.Magnitude < 0.01 then flatDir = hrp.CFrame.LookVector * Vector3.new(1,0,1) end
    flatDir = flatDir.Unit
    local target = hrp.Position + flatDir * dashDist
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(target + Vector3.new(0,20,0), Vector3.new(0,-50,0), rp)
    if hit then target = hit.Position + Vector3.new(0,3,0) end
    hrp.CFrame = CFrame.new(target, target + flatDir)
    toast("Dash!")
end, 8, T.BG3)

-- TELEPORT LOCATION
makeSection(pgUtil, "TELEPORT LOCATION"):LayoutOrder = 9

local savedLocs = {}

local function commitSaves()
    local ok, container = pcall(function() return lp.PlayerGui:FindFirstChild("__HEXVTS") end)
    if not (ok and container) then
        container = Instance.new("StringValue")
        container.Name = "__HEXVTS"
        container.Parent = lp.PlayerGui
    end
    pcall(function() container.Value = HttpService:JSONEncode(savedLocs) end)
end

local function loadSaves()
    local ok, container = pcall(function() return lp.PlayerGui:FindFirstChild("__HEXVTS") end)
    if ok and container and container:IsA("StringValue") then
        pcall(function() savedLocs = HttpService:JSONDecode(container.Value) end)
    end
end

loadSaves()

local locsScroll = Instance.new("ScrollingFrame", pgUtil)
locsScroll.Size = UDim2.new(1, 0, 0, 140)
locsScroll.BackgroundColor3 = T.BG2
locsScroll.BorderSizePixel = 0
locsScroll.ScrollBarThickness = 3
locsScroll.ScrollBarImageColor3 = T.STROKE2
locsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
locsScroll.LayoutOrder = 10
locsScroll.ZIndex = 10
corner(locsScroll, 10)
stroke(locsScroll, T.STROKE, 1)

local locsLayout = Instance.new("UIListLayout", locsScroll)
locsLayout.Padding = UDim.new(0, 4)
locsLayout.SortOrder = Enum.SortOrder.LayoutOrder
local locsPad = Instance.new("UIPadding", locsScroll)
locsPad.PaddingLeft = UDim.new(0, 6)
locsPad.PaddingRight = UDim.new(0, 6)
locsPad.PaddingTop = UDim.new(0, 6)
locsPad.PaddingBottom = UDim.new(0, 6)

local function teleportToLoc(pos)
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y + 500, pos.Z))
    task.wait()
    hrp.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y, pos.Z))
end

local function renderLocs()
    for _, c in ipairs(locsScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for i, loc in ipairs(savedLocs) do
        local slot = Instance.new("Frame", locsScroll)
        slot.Size = UDim2.new(1, 0, 0, 44)
        slot.BackgroundColor3 = T.BG3
        slot.BorderSizePixel = 0
        slot.LayoutOrder = i
        slot.ZIndex = 11
        corner(slot, 8)

        local nl = Instance.new("TextLabel", slot)
        nl.Size = UDim2.new(1, -90, 0, 20)
        nl.Position = UDim2.new(0, 8, 0, 4)
        nl.BackgroundTransparency = 1
        nl.Text = loc.name
        nl.Font = Enum.Font.GothamBold
        nl.TextSize = 11
        nl.TextColor3 = T.TEXT
        nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.ZIndex = 12

        local cl = Instance.new("TextLabel", slot)
        cl.Size = UDim2.new(1, -90, 0, 14)
        cl.Position = UDim2.new(0, 8, 0, 24)
        cl.BackgroundTransparency = 1
        cl.Text = string.format("%.0f, %.0f, %.0f", loc.x, loc.y, loc.z)
        cl.Font = Enum.Font.Gotham
        cl.TextSize = 9
        cl.TextColor3 = T.SUBTEXT
        cl.TextXAlignment = Enum.TextXAlignment.Left
        cl.ZIndex = 12

        local tpb = Instance.new("TextButton", slot)
        tpb.Size = UDim2.new(0, 36, 0, 28)
        tpb.Position = UDim2.new(1, -80, 0.5, -14)
        tpb.BackgroundColor3 = Color3.fromRGB(40,120,80)
        tpb.Text = "TP"
        tpb.TextColor3 = T.TEXT
        tpb.Font = Enum.Font.GothamBold
        tpb.TextSize = 10
        tpb.BorderSizePixel = 0
        tpb.ZIndex = 12
        corner(tpb, 6)

        local db = Instance.new("TextButton", slot)
        db.Size = UDim2.new(0, 30, 0, 28)
        db.Position = UDim2.new(1, -40, 0.5, -14)
        db.BackgroundColor3 = Color3.fromRGB(140,40,40)
        db.Text = "X"
        db.TextColor3 = T.TEXT
        db.Font = Enum.Font.GothamBold
        db.TextSize = 10
        db.BorderSizePixel = 0
        db.ZIndex = 12
        corner(db, 6)

        local capturedLoc = loc
        local capturedIdx = i
        tpb.MouseButton1Click:Connect(function()
            playClick()
            teleportToLoc(Vector3.new(capturedLoc.x, capturedLoc.y, capturedLoc.z))
            toast("Teleport ke " .. capturedLoc.name)
        end)
        db.MouseButton1Click:Connect(function()
            playClick()
            table.remove(savedLocs, capturedIdx)
            commitSaves(); renderLocs()
            toast("Lokasi dihapus")
        end)
    end
    locsScroll.CanvasSize = UDim2.new(0, 0, 0, #savedLocs * 50)
end

renderLocs()

local _, savLocBtn = makeButtonRow(pgUtil, "Simpan Lokasi Sekarang", function()
    if #savedLocs >= 10 then toast("Sudah 10 lokasi!"); return end
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position
    table.insert(savedLocs, {name = "Lokasi " .. (#savedLocs+1), x = pos.X, y = pos.Y, z = pos.Z})
    commitSaves(); renderLocs()
    toast("Lokasi disimpan!")
end, 11, T.BG3)

-- KOORDINAT COPY
makeSection(pgUtil, "KOORDINAT"):LayoutOrder = 12

local coordRow, coordVal = makeDisplayRow(pgUtil, "Posisi", "X: - Y: - Z: -", 13)

RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local p = hrp.Position
    coordVal.Text = string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)
end)

local _, copyCoordBtn = makeButtonRow(pgUtil, "Salin Koordinat", function()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position
    local text = string.format("X: %.2f  Y: %.2f  Z: %.2f", pos.X, pos.Y, pos.Z)
    local ok = pcall(function() setclipboard(text) end)
    if ok then toast("Koordinat disalin: " .. text, T.GREEN)
    else toast("setclipboard tidak support di executor ini", T.RED) end
end, 14, T.BG3)

-- =============================================
-- TAB: MONITOR (Activity Monitor)
-- =============================================
local pgMonitor = tabPages["MONITOR"]
makeSection(pgMonitor, "ACTIVITY MONITOR"):LayoutOrder = 0

local MAX_LOGS = 200
local logs = {}
local logCount = 0

local monHeader = Instance.new("Frame", pgMonitor)
monHeader.Size = UDim2.new(1, 0, 0, 36)
monHeader.BackgroundColor3 = T.BG2
monHeader.BorderSizePixel = 0
monHeader.LayoutOrder = 1
monHeader.ZIndex = 10
corner(monHeader, 10)
stroke(monHeader, T.STROKE, 1)

local monCountLbl = Instance.new("TextLabel", monHeader)
monCountLbl.Size = UDim2.new(0.5, 0, 1, 0)
monCountLbl.Position = UDim2.new(0, 10, 0, 0)
monCountLbl.BackgroundTransparency = 1
monCountLbl.Text = "0 log"
monCountLbl.Font = Enum.Font.GothamBold
monCountLbl.TextSize = 11
monCountLbl.TextColor3 = T.SUBTEXT
monCountLbl.TextXAlignment = Enum.TextXAlignment.Left
monCountLbl.ZIndex = 11

local monClearBtn = Instance.new("TextButton", monHeader)
monClearBtn.Size = UDim2.new(0, 60, 0, 24)
monClearBtn.Position = UDim2.new(1, -68, 0.5, -12)
monClearBtn.BackgroundColor3 = T.BG3
monClearBtn.Text = "CLEAR"
monClearBtn.TextColor3 = T.SUBTEXT
monClearBtn.Font = Enum.Font.GothamBold
monClearBtn.TextSize = 10
monClearBtn.BorderSizePixel = 0
monClearBtn.AutoButtonColor = false
monClearBtn.ZIndex = 11
corner(monClearBtn, 6)

local monScroll = Instance.new("ScrollingFrame", pgMonitor)
monScroll.Size = UDim2.new(1, 0, 0, 280)
monScroll.BackgroundColor3 = T.BG2
monScroll.BorderSizePixel = 0
monScroll.ScrollBarThickness = 3
monScroll.ScrollBarImageColor3 = T.STROKE2
monScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
monScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
monScroll.LayoutOrder = 2
monScroll.ZIndex = 10
corner(monScroll, 10)
stroke(monScroll, T.STROKE, 1)

local monLayout = Instance.new("UIListLayout", monScroll)
monLayout.SortOrder = Enum.SortOrder.LayoutOrder
monLayout.Padding = UDim.new(0, 1)
local monPad = Instance.new("UIPadding", monScroll)
monPad.PaddingLeft = UDim.new(0, 6)
monPad.PaddingRight = UDim.new(0, 6)
monPad.PaddingTop = UDim.new(0, 4)
monPad.PaddingBottom = UDim.new(0, 4)

local function getTimeMon()
    local t = os.date("*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

local function addLog(playerName, activity, logType)
    logCount += 1
    local textColor
    if logType == "damage" then textColor = "ff6666"
    elseif logType == "death" then textColor = "ff4444"
    elseif logType == "tool" then textColor = "aaaaff"
    elseif logType == "system" then textColor = "ffcc66"
    else textColor = "88ddaa" end

    local row = Instance.new("Frame", monScroll)
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = logCount % 2 == 0 and Color3.fromRGB(18,18,28) or T.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = logCount
    row.ZIndex = 11
    corner(row, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -14, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.RichText = true
    lbl.TextWrapped = true
    lbl.Text = string.format(
        '<font color="#888888">[%s]</font> <font color="#aaaaff"><b>%s</b></font>  <font color="#%s">%s</font>',
        getTimeMon(), playerName, textColor, activity
    )
    lbl.TextColor3 = T.TEXT
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12

    table.insert(logs, row)
    if #logs > MAX_LOGS then
        local old = table.remove(logs, 1)
        if old and old.Parent then old:Destroy() end
    end

    monCountLbl.Text = #logs .. " log"
    task.defer(function()
        monScroll.CanvasPosition = Vector2.new(0, math.huge)
    end)
end

monClearBtn.MouseButton1Click:Connect(function()
    playClick()
    for _, v in ipairs(logs) do if v and v.Parent then v:Destroy() end end
    logs = {}; logCount = 0
    monCountLbl.Text = "0 log"
    addLog("Sistem", "History dihapus", "system")
end)

-- Monitor logic
local monConn = {}

local function getPlayerFromPart(part)
    if not part then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and part:IsDescendantOf(p.Character) then return p end
    end
    return nil
end

local function trackPlayer(p)
    if p == lp then return end
    local function onChar(c)
        local c1 = c.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then addLog(p.Name, "Equip tool: " .. child.Name, "tool") end
        end)
        local c2 = c.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then addLog(p.Name, "Unequip tool: " .. child.Name, "tool") end
        end)
        table.insert(monConn, c1); table.insert(monConn, c2)
    end
    if p.Character then onChar(p.Character) end
    local conn = p.CharacterAdded:Connect(onChar)
    table.insert(monConn, conn)
end

for _, p in ipairs(Players:GetPlayers()) do trackPlayer(p) end
Players.PlayerAdded:Connect(function(p) trackPlayer(p); addLog(p.Name, "Bergabung ke game", "system") end)
Players.PlayerRemoving:Connect(function(p) addLog(p.Name, "Keluar dari game", "system") end)

local lastDamageSource = nil
local lastDamageTime = 0

local function initMonChar(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end
    local lastHp = hum.Health

    local function bindTouched(part)
        if not part:IsA("BasePart") then return end
        local c = part.Touched:Connect(function(hit)
            local att = getPlayerFromPart(hit)
            if att then lastDamageSource = att.Name; lastDamageTime = tick() end
        end)
        table.insert(monConn, c)
    end

    for _, part in ipairs(char:GetDescendants()) do bindTouched(part) end
    local dc = char.DescendantAdded:Connect(function(d) bindTouched(d) end)
    table.insert(monConn, dc)

    local hc = hum.HealthChanged:Connect(function(newHp)
        local delta = newHp - lastHp
        if math.abs(delta) < 0.5 then lastHp = newHp; return end
        local source = (lastDamageSource and (tick() - lastDamageTime) < 1.5) and lastDamageSource or "Sistem"
        if delta < 0 then
            addLog(source, string.format("Damage %d HP", math.abs(math.floor(delta))), source == "Sistem" and "system" or "damage")
            lastDamageSource = nil
        end
        lastHp = newHp
    end)
    table.insert(monConn, hc)

    local died = hum.Died:Connect(function()
        local source = (lastDamageSource and (tick() - lastDamageTime) < 3) and lastDamageSource or "Sistem"
        addLog(source, "Karakter mati" .. (source ~= "Sistem" and " (oleh " .. source .. ")" or ""), "death")
        lastDamageSource = nil
    end)
    table.insert(monConn, died)

    local state = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Seated then addLog("Sistem", "Karakter duduk/naik kendaraan", "system")
        elseif new == Enum.HumanoidStateType.Swimming then addLog("Sistem", "Karakter masuk air", "system") end
    end)
    table.insert(monConn, state)

    local ta = char.ChildAdded:Connect(function(c) if c:IsA("Tool") then addLog("Kamu", "Equip: " .. c.Name, "tool") end end)
    local tr = char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then addLog("Kamu", "Unequip: " .. c.Name, "tool") end end)
    table.insert(monConn, ta); table.insert(monConn, tr)
end

lp.CharacterAdded:Connect(function(char)
    addLog("Sistem", "Karakter respawn", "system")
    initMonChar(char)
end)
if lp.Character then initMonChar(lp.Character) end
addLog("Sistem", "HEXVEIL Activity Monitor aktif", "system")

-- =============================================
-- TAB: TOOLS (Check ID)
-- =============================================
local pgTools = tabPages["TOOLS"]
makeSection(pgTools, "ASSET CHECKER"):LayoutOrder = 0

-- Sound tab sub-header
local assetTabRow = Instance.new("Frame", pgTools)
assetTabRow.Size = UDim2.new(1, 0, 0, 36)
assetTabRow.BackgroundColor3 = T.BG2
assetTabRow.BorderSizePixel = 0
assetTabRow.LayoutOrder = 1
assetTabRow.ZIndex = 10
corner(assetTabRow, 10)
stroke(assetTabRow, T.STROKE, 1)

local assetTabLayout = Instance.new("UIListLayout", assetTabRow)
assetTabLayout.FillDirection = Enum.FillDirection.Horizontal
assetTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
assetTabLayout.Padding = UDim.new(0, 4)
local assetTabPad = Instance.new("UIPadding", assetTabRow)
assetTabPad.PaddingLeft = UDim.new(0, 6)
assetTabPad.PaddingRight = UDim.new(0, 6)
assetTabPad.PaddingTop = UDim.new(0, 5)
assetTabPad.PaddingBottom = UDim.new(0, 5)

local assetSoundBtn = Instance.new("TextButton", assetTabRow)
assetSoundBtn.Size = UDim2.new(0.5, -4, 1, 0)
assetSoundBtn.BackgroundColor3 = T.BG3
assetSoundBtn.Text = "SOUND ID"
assetSoundBtn.TextColor3 = T.TEXT
assetSoundBtn.Font = Enum.Font.GothamBold
assetSoundBtn.TextSize = 10
assetSoundBtn.BorderSizePixel = 0
assetSoundBtn.AutoButtonColor = false
assetSoundBtn.LayoutOrder = 1
assetSoundBtn.ZIndex = 11
corner(assetSoundBtn, 6)

local assetImageBtn = Instance.new("TextButton", assetTabRow)
assetImageBtn.Size = UDim2.new(0.5, -4, 1, 0)
assetImageBtn.BackgroundColor3 = T.BG2
assetImageBtn.Text = "IMAGE ID"
assetImageBtn.TextColor3 = T.SUBTEXT
assetImageBtn.Font = Enum.Font.GothamBold
assetImageBtn.TextSize = 10
assetImageBtn.BorderSizePixel = 0
assetImageBtn.AutoButtonColor = false
assetImageBtn.LayoutOrder = 2
assetImageBtn.ZIndex = 11
corner(assetImageBtn, 6)

-- Sound input
local soundInputFrame = Instance.new("Frame", pgTools)
soundInputFrame.Size = UDim2.new(1, 0, 0, 38)
soundInputFrame.BackgroundColor3 = T.BG2
soundInputFrame.BorderSizePixel = 0
soundInputFrame.LayoutOrder = 2
soundInputFrame.ZIndex = 10
corner(soundInputFrame, 10)
stroke(soundInputFrame, T.STROKE, 1)

local soundInput = Instance.new("TextBox", soundInputFrame)
soundInput.Size = UDim2.new(1, -16, 1, 0)
soundInput.Position = UDim2.new(0, 8, 0, 0)
soundInput.BackgroundTransparency = 1
soundInput.PlaceholderText = "Paste Sound ID..."
soundInput.PlaceholderColor3 = T.SUBTEXT
soundInput.Text = ""
soundInput.TextColor3 = T.TEXT
soundInput.TextSize = 12
soundInput.Font = Enum.Font.Code
soundInput.TextXAlignment = Enum.TextXAlignment.Left
soundInput.ClearTextOnFocus = false
soundInput.ZIndex = 11

local soundStatusRow, soundStatusVal = makeDisplayRow(pgTools, "Status", "--", 3)

local soundBtnsRow = Instance.new("Frame", pgTools)
soundBtnsRow.Size = UDim2.new(1, 0, 0, 38)
soundBtnsRow.BackgroundTransparency = 1
soundBtnsRow.LayoutOrder = 4
soundBtnsRow.ZIndex = 10
local soundBtnsLayout = Instance.new("UIListLayout", soundBtnsRow)
soundBtnsLayout.FillDirection = Enum.FillDirection.Horizontal
soundBtnsLayout.Padding = UDim.new(0, 6)

local function makeSmallBtn(parent, txt, color, order)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.25, -5, 1, 0)
    b.BackgroundColor3 = color or T.BG3
    b.Text = txt
    b.TextColor3 = T.TEXT
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.ZIndex = 11
    corner(b, 8)
    return b
end

local sCheckBtn = makeSmallBtn(soundBtnsRow, "CHECK", T.BG3, 1)
local sPlayBtn = makeSmallBtn(soundBtnsRow, "PLAY", Color3.fromRGB(20,100,50), 2)
local sStopBtn = makeSmallBtn(soundBtnsRow, "STOP", Color3.fromRGB(120,30,30), 3)
local sClearBtn = makeSmallBtn(soundBtnsRow, "CLEAR", T.BG3, 4)

-- Sound history
local sHistScroll = Instance.new("ScrollingFrame", pgTools)
sHistScroll.Size = UDim2.new(1, 0, 0, 100)
sHistScroll.BackgroundColor3 = T.BG2
sHistScroll.BorderSizePixel = 0
sHistScroll.ScrollBarThickness = 3
sHistScroll.ScrollBarImageColor3 = T.STROKE2
sHistScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
sHistScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
sHistScroll.LayoutOrder = 5
sHistScroll.ZIndex = 10
corner(sHistScroll, 10)
stroke(sHistScroll, T.STROKE, 1)
local sHistLayout = Instance.new("UIListLayout", sHistScroll)
sHistLayout.SortOrder = Enum.SortOrder.LayoutOrder
sHistLayout.Padding = UDim.new(0, 2)
local sHistPad = Instance.new("UIPadding", sHistScroll)
sHistPad.PaddingLeft = UDim.new(0, 6); sHistPad.PaddingRight = UDim.new(0, 6)
sHistPad.PaddingTop = UDim.new(0, 4); sHistPad.PaddingBottom = UDim.new(0, 4)

-- Image input
local imageInputFrame = Instance.new("Frame", pgTools)
imageInputFrame.Size = UDim2.new(1, 0, 0, 38)
imageInputFrame.BackgroundColor3 = T.BG2
imageInputFrame.BorderSizePixel = 0
imageInputFrame.LayoutOrder = 2
imageInputFrame.Visible = false
imageInputFrame.ZIndex = 10
corner(imageInputFrame, 10)
stroke(imageInputFrame, T.STROKE, 1)

local imageInput = Instance.new("TextBox", imageInputFrame)
imageInput.Size = UDim2.new(1, -16, 1, 0)
imageInput.Position = UDim2.new(0, 8, 0, 0)
imageInput.BackgroundTransparency = 1
imageInput.PlaceholderText = "Paste Image ID..."
imageInput.PlaceholderColor3 = T.SUBTEXT
imageInput.Text = ""
imageInput.TextColor3 = T.TEXT
imageInput.TextSize = 12
imageInput.Font = Enum.Font.Code
imageInput.TextXAlignment = Enum.TextXAlignment.Left
imageInput.ClearTextOnFocus = false
imageInput.ZIndex = 11

local imageStatusRow, imageStatusVal = makeDisplayRow(pgTools, "Status", "--", 3)
imageStatusRow.Visible = false

local imgBtnsRow = Instance.new("Frame", pgTools)
imgBtnsRow.Size = UDim2.new(1, 0, 0, 38)
imgBtnsRow.BackgroundTransparency = 1
imgBtnsRow.LayoutOrder = 4
imgBtnsRow.Visible = false
imgBtnsRow.ZIndex = 10
local imgBtnsLayout = Instance.new("UIListLayout", imgBtnsRow)
imgBtnsLayout.FillDirection = Enum.FillDirection.Horizontal
imgBtnsLayout.Padding = UDim.new(0, 6)

local iCheckBtn = makeSmallBtn(imgBtnsRow, "CHECK", T.BG3, 1)
local iClearBtn = makeSmallBtn(imgBtnsRow, "CLEAR", T.BG3, 2)

local imgPreviewRow = Instance.new("Frame", pgTools)
imgPreviewRow.Size = UDim2.new(1, 0, 0, 90)
imgPreviewRow.BackgroundColor3 = T.BG2
imgPreviewRow.BorderSizePixel = 0
imgPreviewRow.LayoutOrder = 5
imgPreviewRow.Visible = false
imgPreviewRow.ZIndex = 10
corner(imgPreviewRow, 10)
stroke(imgPreviewRow, T.STROKE, 1)

local imgPreview = Instance.new("ImageLabel", imgPreviewRow)
imgPreview.Size = UDim2.new(0, 78, 0, 78)
imgPreview.Position = UDim2.new(0, 6, 0.5, -39)
imgPreview.BackgroundColor3 = T.BG3
imgPreview.Image = ""
imgPreview.ZIndex = 11
corner(imgPreview, 8)

local imgPreviewNone = Instance.new("TextLabel", imgPreview)
imgPreviewNone.Size = UDim2.new(1, 0, 1, 0)
imgPreviewNone.BackgroundTransparency = 1
imgPreviewNone.Text = "NO\nPREVIEW"
imgPreviewNone.TextColor3 = T.SUBTEXT
imgPreviewNone.Font = Enum.Font.Code
imgPreviewNone.TextSize = 9
imgPreviewNone.ZIndex = 12

local iHistScroll = Instance.new("ScrollingFrame", pgTools)
iHistScroll.Size = UDim2.new(1, 0, 0, 100)
iHistScroll.BackgroundColor3 = T.BG2
iHistScroll.BorderSizePixel = 0
iHistScroll.ScrollBarThickness = 3
iHistScroll.ScrollBarImageColor3 = T.STROKE2
iHistScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
iHistScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
iHistScroll.LayoutOrder = 6
iHistScroll.Visible = false
iHistScroll.ZIndex = 10
corner(iHistScroll, 10)
stroke(iHistScroll, T.STROKE, 1)
local iHistLayout = Instance.new("UIListLayout", iHistScroll)
iHistLayout.SortOrder = Enum.SortOrder.LayoutOrder
iHistLayout.Padding = UDim.new(0, 2)
local iHistPad = Instance.new("UIPadding", iHistScroll)
iHistPad.PaddingLeft = UDim.new(0, 6); iHistPad.PaddingRight = UDim.new(0, 6)
iHistPad.PaddingTop = UDim.new(0, 4); iHistPad.PaddingBottom = UDim.new(0, 4)

-- Asset tab switching
local assetMode = "sound"
local function switchAsset(mode)
    assetMode = mode
    local isSound = mode == "sound"
    soundInputFrame.Visible = isSound
    soundStatusRow.Visible = isSound
    soundBtnsRow.Visible = isSound
    sHistScroll.Visible = isSound
    imageInputFrame.Visible = not isSound
    imageStatusRow.Visible = not isSound
    imgBtnsRow.Visible = not isSound
    imgPreviewRow.Visible = not isSound
    iHistScroll.Visible = not isSound
    tween(assetSoundBtn, {BackgroundColor3 = isSound and T.BG3 or T.BG2, TextColor3 = isSound and T.TEXT or T.SUBTEXT}):Play()
    tween(assetImageBtn, {BackgroundColor3 = not isSound and T.BG3 or T.BG2, TextColor3 = not isSound and T.TEXT or T.SUBTEXT}):Play()
end

assetSoundBtn.MouseButton1Click:Connect(function() playClick(); switchAsset("sound") end)
assetImageBtn.MouseButton1Click:Connect(function() playClick(); switchAsset("image") end)
switchAsset("sound")

local function parseID(input)
    local raw = input:match("^%s*(.-)%s*$")
    return raw:match("rbxassetid://(%d+)") or raw:match("^(%d+)$")
end

local function addHistRow(scroll, id, status, isWork, order)
    local row = Instance.new("Frame", scroll)
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundColor3 = isWork and Color3.fromRGB(10,30,15) or Color3.fromRGB(30,10,10)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 11
    corner(row, 4)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.RichText = true
    lbl.Text = string.format('<font color="#888888">[%s]</font> <font color="#aaaaff">%s</font>  <font color="%s"><b>%s</b></font>',
        getTimeMon(), id, isWork and "#44ff88" or "#ff5555", status)
    lbl.TextColor3 = T.TEXT
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, math.huge) end)
end

local currentSound2 = nil
local sHistCount = 0

local function checkSoundAsset(id)
    local assetId = "rbxassetid://" .. id
    local temp = Instance.new("Sound")
    temp.SoundId = assetId; temp.Volume = 0; temp.Parent = workspace
    pcall(function() ContentProvider:PreloadAsync({temp}) end)
    task.wait(0.5)
    local tl = temp.TimeLength
    temp:Destroy()
    if tl and tl > 0 then
        return true, string.format("WORK | %.2fs", tl)
    else
        return false, "TIDAK WORK"
    end
end

sCheckBtn.MouseButton1Click:Connect(function()
    playClick()
    local id = parseID(soundInput.Text)
    if not id then soundStatusVal.Text = "ID tidak valid"; return end
    soundStatusVal.Text = "Mengecek..."
    sCheckBtn.Active = false
    task.spawn(function()
        local ok, msg = checkSoundAsset(id)
        sHistCount += 1
        soundStatusVal.Text = msg
        soundStatusVal.TextColor3 = ok and T.GREEN or T.RED
        addHistRow(sHistScroll, id, ok and "WORK" or "TIDAK WORK", ok, sHistCount)
        sCheckBtn.Active = true
    end)
end)

sPlayBtn.MouseButton1Click:Connect(function()
    playClick()
    local id = parseID(soundInput.Text)
    if not id then return end
    if currentSound2 then pcall(function() currentSound2:Stop(); currentSound2:Destroy() end) end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = 1; s.Parent = workspace; s:Play()
    currentSound2 = s
    soundStatusVal.Text = "Playing " .. id
    s.Ended:Connect(function() soundStatusVal.Text = "Selesai"; currentSound2 = nil end)
end)

sStopBtn.MouseButton1Click:Connect(function()
    playClick()
    if currentSound2 then pcall(function() currentSound2:Stop(); currentSound2:Destroy() end); currentSound2 = nil end
    soundStatusVal.Text = "Stopped"
end)

sClearBtn.MouseButton1Click:Connect(function()
    playClick()
    for _, v in ipairs(sHistScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    sHistCount = 0; soundStatusVal.Text = "History dihapus"
end)

local iHistCount = 0

local function checkImageAsset(id)
    local assetId = "rbxassetid://" .. id
    local temp = Instance.new("ImageLabel")
    temp.Image = assetId; temp.Size = UDim2.new(0,1,0,1)
    temp.BackgroundTransparency = 1; temp.Parent = game.CoreGui
    pcall(function() ContentProvider:PreloadAsync({temp}) end)
    task.wait(0.3)
    local img = temp.Image; temp:Destroy()
    if img == assetId then return true, "WORK | Image valid"
    else return false, "TIDAK WORK" end
end

iCheckBtn.MouseButton1Click:Connect(function()
    playClick()
    local id = parseID(imageInput.Text)
    if not id then imageStatusVal.Text = "ID tidak valid"; return end
    imageStatusVal.Text = "Mengecek..."
    imgPreview.Image = ""; imgPreviewNone.Visible = true
    iCheckBtn.Active = false
    task.spawn(function()
        local ok, msg = checkImageAsset(id)
        iHistCount += 1
        imageStatusVal.Text = msg
        imageStatusVal.TextColor3 = ok and T.GREEN or T.RED
        if ok then imgPreview.Image = "rbxassetid://" .. id; imgPreviewNone.Visible = false end
        addHistRow(iHistScroll, id, ok and "WORK" or "TIDAK WORK", ok, iHistCount)
        iCheckBtn.Active = true
    end)
end)

iClearBtn.MouseButton1Click:Connect(function()
    playClick()
    for _, v in ipairs(iHistScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    iHistCount = 0; imageStatusVal.Text = "History dihapus"
    imgPreview.Image = ""; imgPreviewNone.Visible = true
end)

-- =============================================
-- PILL TOGGLE (minimize/maximize)
-- =============================================
local winVisible = true
pill.MouseButton1Click:Connect(function()
    playClick()
    winVisible = not winVisible
    if winVisible then
        win.Visible = true
        win.BackgroundTransparency = 1
        tween(win, {BackgroundTransparency = 0}, 0.2):Play()
        pillLabel.Text = "HEXVEIL"
    else
        local tw = tween(win, {BackgroundTransparency = 1}, 0.15)
        tw:Play()
        tw.Completed:Connect(function() if not winVisible then win.Visible = false end end)
        pillLabel.Text = "HEXVEIL  [tersembunyi]"
    end
end)

-- INIT
switchTab("COMBAT")

-- Respawn listeners
lp.CharacterAdded:Connect(function()
    if flyEnabled then task.wait(0.5); enableFly() end
end)

toast("HEXVEIL dimuat! by Nazam", T.GLOW)
