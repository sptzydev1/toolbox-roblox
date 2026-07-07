-- Delta Executor Optimized & Fixed UI Display Version
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local fileName = "sptzyy_game_data.json"

-- Deteksi Parent GUI yang aman untuk Delta
local TargetParent = nil
if gethui then
    TargetParent = gethui()
elseif LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
    TargetParent = LocalPlayer.PlayerGui
else
    TargetParent = game:GetService("CoreGui")
end

-- Hapus GUI lama agar tidak menumpuk
local oldGui = TargetParent:FindFirstChild("SptzyyCopyGui")
if oldGui then oldGui:Destroy() end

-- --- UI CONSTRUCTION ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyCopyGui"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
-- Diposisikan tepat di tengah layar agar langsung terlihat
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -130)
MainFrame.Size = UDim2.new(0, 260, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true -- Fallback otomatis untuk beberapa versi executor

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Logika Geser Manual (Sangat lancar di Mobile/Touch)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Sptzyy Copy Game"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

local function createButton(name, pos, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0, 220, 0, 45)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local CopyBtn = createButton("CopyBtn", UDim2.new(0, 20, 0, 60), "COPY ALL PARTS", Color3.fromRGB(56, 142, 60))
local PasteBtn = createButton("PasteBtn", UDim2.new(0, 20, 0, 120), "PASTE TO WORKSPACE", Color3.fromRGB(21, 101, 192))

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Ready to Copy"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

-- --- LOGIKA UTAMA ---

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

CopyBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Scanning Workspace..."
    task.wait(0.1)
    
    local mapData = {}
    local descendants = game.Workspace:GetDescendants()
    local total = #descendants
    local character = LocalPlayer.Character
    
    for i, obj in ipairs(descendants) do
        if i % 400 == 0 then
            StatusLabel.Text = "Scanning: " .. math.floor((i / total) * 100) .. "%"
            task.wait()
        end
        
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            if not character or not obj:IsDescendantOf(character) then
                local cfComponents = {obj.CFrame:GetComponents()}
                table.insert(mapData, {
                    CN = obj.ClassName,
                    NM = obj.Name,
                    SZ = {obj.Size.X, obj.Size.Y, obj.Size.Z},
                    CF = cfComponents,
                    CL = {obj.Color.r, obj.Color.g, obj.Color.b},
                    MT = obj.Material.Name,
                    TR = obj.Transparency,
                    CC = obj.CanCollide,
                    AN = obj.Anchored
                })
            end
        end
    end
    
    StatusLabel.Text = "Saving file..."
    task.wait(0.1)
    
    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(mapData))
    end)
    
    if success then
        StatusLabel.Text = "Saved: " .. #mapData .. " Parts!"
    else
        StatusLabel.Text = "Save Failed!"
        warn("Error saving file: ", err)
    end
end)

PasteBtn.MouseButton1Click:Connect(function()
    if not isfile or not isfile(fileName) then 
        StatusLabel.Text = "No Save Found!" 
        return 
    end
    
    StatusLabel.Text = "Reading Data..."
    task.wait(0.1)
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(fileName))
    end)
    
    if not success or not data then
        StatusLabel.Text = "Failed to load data!"
        return
    end
    
    StatusLabel.Text = "Pasting... Please Wait"
    task.wait(0.1)
    
    local folder = Instance.new("Folder", game.Workspace)
    folder.Name = "sptzyy_Imported_" .. math.floor(tick())
    
    local totalParts = #data
    for i, d in ipairs(data) do
        if i % 200 == 0 then
            StatusLabel.Text = "Pasting: " .. math.floor((i / totalParts) * 100) .. "%"
            task.wait()
        end
        
        pcall(function()
            local p = Instance.new(d.CN)
            p.Name = d.NM
            p.Size = Vector3.new(d.SZ[1], d.SZ[2], d.SZ[3])
            p.CFrame = CFrame.new(table.unpack(d.CF))
            p.Color = Color3.new(d.CL[1], d.CL[2], d.CL[3])
            p.Material = Enum.Material[d.MT] or Enum.Material.Plastic
            p.Transparency = d.TR
            p.CanCollide = d.CC
            p.Anchored = d.AN
            p.Parent = folder
        end)
    end
    
    StatusLabel.Text = "Successfully Pasted!"
end)
