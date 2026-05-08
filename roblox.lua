-- Memastikan GUI lama dihapus jika dijalankan ulang
local oldGui = game.CoreGui:FindFirstChild("SptzyyCopyGui")
if oldGui then oldGui:Destroy() end

local HttpService = game:GetService("HttpService")
local fileName = "sptzyy_game_data.json"

-- --- UI CONSTRUCTION ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyCopyGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- Fitur geser GUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "sptzyy copyy game"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Style Tombol (Fungsi Helper)
local function createButton(name, pos, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0, 260, 0, 50)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local CopyBtn = createButton("CopyBtn", UDim2.new(0, 20, 0, 80), "COPY MAP (No Terrain)", Color3.fromRGB(60, 60, 60))
local PasteBtn = createButton("PasteBtn", UDim2.new(0, 20, 0, 150), "PASTE TO NEW MAP", Color3.fromRGB(60, 60, 60))
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 220)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12

-- --- LOGIKA FITUR ---

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CopyBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Status: Copying... (Wait)"
    task.wait(0.1)
    
    local mapData = {}
    local count = 0
    
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        -- Filter: Hanya BasePart, Bukan Terrain, Bukan Karakter Pemain
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            local isCharacter = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
            if not isCharacter then
                table.insert(mapData, {
                    ClassName = obj.ClassName,
                    Name = obj.Name,
                    Size = {obj.Size.X, obj.Size.Y, obj.Size.Z},
                    CFrame = {obj.CFrame:GetComponents()},
                    Color = {obj.Color.r, obj.Color.g, obj.Color.b},
                    Material = tostring(obj.Material.Name),
                    Transparency = obj.Transparency,
                    CanCollide = obj.CanCollide,
                    Anchored = obj.Anchored
                })
                count = count + 1
            end
        end
    end
    
    local success, encoded = pcall(function() return HttpService:JSONEncode(mapData) end)
    if success then
        writefile(fileName, encoded)
        StatusLabel.Text = "Status: Saved " .. count .. " parts!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StatusLabel.Text = "Status: Error Encoding!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

PasteBtn.MouseButton1Click:Connect(function()
    if not isfile(fileName) then
        StatusLabel.Text = "Status: No save file found!"
        return
    end

    StatusLabel.Text = "Status: Pasting..."
    local dataRaw = readfile(fileName)
    local mapData = HttpService:JSONDecode(dataRaw)
    
    local folder = Instance.new("Folder")
    folder.Name = "sptzyy_ImportedMap"
    folder.Parent = game.Workspace

    for _, data in pairs(mapData) do
        pcall(function()
            local p = Instance.new(data.ClassName)
            p.Name = data.Name
            p.Size = Vector3.new(unpack(data.Size))
            p.CFrame = CFrame.new(unpack(data.CFrame))
            p.Color = Color3.new(unpack(data.Color))
            p.Material = Enum.Material[data.Material] or Enum.Material.Plastic
            p.Transparency = data.Transparency
            p.CanCollide = data.CanCollide
            p.Anchored = data.Anchored
            p.Parent = folder
        end)
    end
    
    StatusLabel.Text = "Status: Paste Complete!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
end)
