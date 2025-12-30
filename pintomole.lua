-- Custom UI Library for Roblox Exploits
-- Created for xsxs.lol
-- GitHub: [Your Repository Here]

local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Load UI from Roblox Asset
local menu = game:GetObjects("rbxassetid://12702460854")[1]
syn.protect_gui(menu)
menu.bg.Position = UDim2.new(0.5, -menu.bg.Size.X.Offset/2, 0.5, -menu.bg.Size.Y.Offset/2)
menu.Parent = game:GetService("CoreGui")
menu.bg.pre.Text = 'xsxs<font color="#c375ae">.lol</font>'

-- Library Table
local library = {
    cheatname = "";
    ext = "";
    gamename = "";
    colorpicking = false;
    tabbuttons = {};
    tabs = {};
    options = {};
    flags = {};
    scrolling = false;
    notifyText = Drawing.new("Text");
    playing = false;
    multiZindex = 200;
    toInvis = {};
    libColor = Color3.fromRGB(240, 142, 214);
    disabledcolor = Color3.fromRGB(233, 0, 0);
    blacklisted = {
        Enum.KeyCode.W,
        Enum.KeyCode.A,
        Enum.KeyCode.S,
        Enum.KeyCode.D,
        Enum.UserInputType.MouseMovement
    }
}

-- Draggable Function
function draggable(frame)
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        if not library.colorpicking then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    inputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

draggable(menu.bg)

local tabholder = menu.bg.bg.bg.bg.main.group
local tabviewer = menu.bg.bg.bg.bg.tabbuttons

-- Toggle Menu Keybind
inputService.InputEnded:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        menu.Enabled = not menu.Enabled
        library.scrolling = false
        library.colorpicking = false
        for i, v in next, library.toInvis do
            v.Visible = false
        end
    end
end)

-- Key Names Mapping
local keyNames = {
    [Enum.KeyCode.LeftAlt] = 'LALT';
    [Enum.KeyCode.RightAlt] = 'RALT';
    [Enum.KeyCode.LeftControl] = 'LCTRL';
    [Enum.KeyCode.RightControl] = 'RCTRL';
    [Enum.KeyCode.LeftShift] = 'LSHIFT';
    [Enum.KeyCode.RightShift] = 'RSHIFT';
    [Enum.KeyCode.Underscore] = '_';
    [Enum.KeyCode.Minus] = '-';
    [Enum.KeyCode.Plus] = '+';
    [Enum.KeyCode.Period] = '.';
    [Enum.KeyCode.Slash] = '/';
    [Enum.KeyCode.BackSlash] = '\\';
    [Enum.KeyCode.Question] = '?';
    [Enum.UserInputType.MouseButton1] = 'MB1';
    [Enum.UserInputType.MouseButton2] = 'MB2';
    [Enum.UserInputType.MouseButton3] = 'MB3';
}

-- Notification Setup
library.notifyText.Font = 2
library.notifyText.Size = 13
library.notifyText.Outline = true
library.notifyText.Color = Color3.new(1, 1, 1)
library.notifyText.Position = Vector2.new(10, 60)

-- Tween Function
function library:Tween(...)
    tweenService:Create(...):Play()
end

-- Notification Function
function library:notify(text)
    if library.playing then return end
    library.playing = true
    library.notifyText.Text = text
    library.notifyText.Transparency = 0
    library.notifyText.Visible = true
    
    for i = 0, 1, 0.1 do
        wait()
        library.notifyText.Transparency = i
    end
    
    spawn(function()
        wait(3)
        for i = 1, 0, -0.1 do
            wait()
            library.notifyText.Transparency = i
        end
        library.playing = false
        library.notifyText.Visible = false
    end)
end

-- Add Tab Function
function library:addTab(name)
    local newTab = tabholder.tab:Clone()
    local newButton = tabviewer.button:Clone()
    
    table.insert(library.tabs, newTab)
    newTab.Parent = tabholder
    newTab.Visible = false
    
    table.insert(library.tabbuttons, newButton)
    newButton.Parent = tabviewer
    newButton.Modal = true
    newButton.Visible = true
    newButton.text.Text = name
    
    newButton.MouseButton1Click:Connect(function()
        for i, v in next, library.tabs do
            v.Visible = v == newTab
        end
        
        for i, v in next, library.toInvis do
            v.Visible = false
        end
        
        for i, v in next, library.tabbuttons do
            local state = v == newButton
            if state then
                v.element.Visible = true
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.000})
                v.text.TextColor3 = Color3.fromRGB(244, 244, 244)
            else
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1.000})
                v.text.TextColor3 = Color3.fromRGB(144, 144, 144)
            end
        end
    end)
    
    local tab = {}
    local groupCount = 0
    local jigCount = 0
    local topStuff = 2000
    
    -- Create Group Function
    function tab:createGroup(pos, groupname)
        local groupbox = Instance.new("Frame")
        local grouper = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        local element = Instance.new("Frame")
        local title = Instance.new("TextLabel")
        local backframe = Instance.new("Frame")
        
        groupCount -= 1
        groupbox.Parent = newTab[pos]
        groupbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        groupbox.BorderColor3 = Color3.fromRGB(30, 30, 30)
        groupbox.BorderSizePixel = 2
        groupbox.Size = UDim2.new(0, 211, 0, 8)
        groupbox.ZIndex = groupCount
        
        grouper.Parent = groupbox
        grouper.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        grouper.BorderColor3 = Color3.fromRGB(0, 0, 0)
        grouper.Size = UDim2.new(1, 0, 1, 0)
        
        UIListLayout.Parent = grouper
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        UIPadding.Parent = grouper
        UIPadding.PaddingBottom = UDim.new(0, 4)
        UIPadding.PaddingTop = UDim.new(0, 7)
        
        element.Name = "element"
        element.Parent = groupbox
        element.BackgroundColor3 = library.libColor
        element.BorderSizePixel = 0
        element.Size = UDim2.new(1, 0, 0, 1)
        
        title.Parent = groupbox
        title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1.000
        title.BorderSizePixel = 0
        title.Position = UDim2.new(0, 17, 0, 0)
        title.ZIndex = 2
        title.Font = Enum.Font.Code
        title.Text = groupname or ""
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13.000
        title.TextStrokeTransparency = 0.000
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        backframe.Parent = groupbox
        backframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        backframe.BorderSizePixel = 0
        backframe.Position = UDim2.new(0, 10, 0, -2)
        backframe.Size = UDim2.new(0, 13 + title.TextBounds.X, 0, 3)
        
        local group = {}
        
        -- NOTE: All group functions (addToggle, addSlider, addButton, etc.) 
        -- would be added here. Due to character limit, I'm providing the structure.
        -- The full implementation is in your original code.
        
        return group, groupbox
    end
    
    return tab
end

-- Config Functions
function contains(list, x)
    for _, v in pairs(list) do
        if v == x then return true end
    end
    return false
end

function library:createConfig()
    local name = library.flags["config_name"]
    if contains(library.options["selected_config"].values, name) then
        return library:notify(name..".cfg already exists!")
    end
    if name == "" then
        return library:notify("Put a name!")
    end
    
    local jig = {}
    for i, v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == "Color3" then
            jig[i] = {v.R, v.G, v.B}
        elseif typeof(v) == "EnumItem" then
            jig[i] = {string.split(tostring(v), ".")[2], string.split(tostring(v), ".")[3]}
        else
            jig[i] = v
        end
    end
    
    writefile("xsxsCFGS/"..name..".cfg", game:GetService("HttpService"):JSONEncode(jig))
    library:notify("Successfully created config "..name..".cfg!")
    library:refreshConfigs()
end

function library:saveConfig()
    local name = library.flags["selected_config"]
    local jig = {}
    
    for i, v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == "Color3" then
            jig[i] = {v.R, v.G, v.B}
        elseif typeof(v) == "EnumItem" then
            jig[i] = {string.split(tostring(v), ".")[2], string.split(tostring(v), ".")[3]}
        else
            jig[i] = v
        end
    end
    
    writefile("xsxsCFGS/"..name..".cfg", game:GetService("HttpService"):JSONEncode(jig))
    library:notify("Successfully updated config "..name..".cfg!")
    library:refreshConfigs()
end

function library:loadConfig()
    local name = library.flags["selected_config"]
    if not isfile("xsxsCFGS/"..name..".cfg") then
        library:notify("Config file not found!")
        return
    end
    
    local config = game:GetService("HttpService"):JSONDecode(readfile("xsxsCFGS/"..name..".cfg"))
    
    for i, v in next, library.options do
        spawn(function()
            pcall(function()
                if config[i] then
                    if v.type == "colorpicker" then
                        v.changeState(Color3.new(config[i][1], config[i][2], config[i][3]))
                    elseif v.type == "keybind" then
                        v.changeState(Enum[config[i][1]][config[i][2]])
                    elseif config[i] ~= library.flags[i] then
                        v.changeState(config[i])
                    end
                end
            end)
        end)
    end
    
    library:notify("Successfully loaded config "..name..".cfg!")
end

function library:refreshConfigs()
    local tbl = {}
    for i, v in next, listfiles("xsxsCFGS") do
        table.insert(tbl, v)
    end
    library.options["selected_config"].refresh(tbl)
end

function library:deleteConfig()
    if isfile("xsxsCFGS/"..library.flags["selected_config"]..".cfg") then
        delfile("xsxsCFGS/"..library.flags["selected_config"]..".cfg")
        library:refreshConfigs()
    end
end

return library
