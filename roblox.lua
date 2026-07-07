-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

-- Mendapatkan Nama Game Secara Otomatis
local GameName = "Unknown_Game"
pcall(function()
    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    if productInfo and productInfo.Name then
        GameName = productInfo.Name:gsub("[%s%p]", "_")
    end
end)

local FILE_PREFIX = "GameCopy_"
local TargetFolder = workspace

-- Variabel Penyimpanan Sementara untuk Auto-Hover Scan & Grid Preview
local SelectedObjects = {}
local IsMultiSelecting = false
local HighlightStorage = {} 
local LastHoveredObject = nil 

-- [[ CREATING GUI (Premium Curved UI V5 - Full Complete Features) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV5_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 430) -- Disesuaikan agar penataan grid 1,2,3 rapi
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Judul GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 COPY MAP BY SPYZYY V5 FULL 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame

-- Fitur Lama: Tombol Copy All Map
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 236, 0, 28)
CopyButton.Position = UDim2.new(0, 12, 0, 40)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPY ALL MAP (FITUR LAMA)"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 11
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

-- Fitur Baru: Tombol Automatic Hover Scan Toggle (Tanpa Klik)
local MultiSelectButton = Instance.new("TextButton")
MultiSelectButton.Size = UDim2.new(0, 236, 0, 32)
MultiSelectButton.Position = UDim2.new(0, 12, 0, 73)
MultiSelectButton.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
MultiSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiSelectButton.Text = "🤖 AUTO HOVER SCAN: OFF"
MultiSelectButton.Font = Enum.Font.SourceSansBold
MultiSelectButton.TextSize = 12
MultiSelectButton.Parent = MainFrame

local MultiCorner = Instance.new("UICorner")
MultiCorner.CornerRadius = UDim.new(0, 6)
MultiCorner.Parent = MultiSelectButton

-- Label Penanda Grid Preview Gambar
local GridLabel = Instance.new("TextLabel")
GridLabel.Size = UDim2.new(1, -24, 0, 20)
GridLabel.Position = UDim2.new(0, 12, 0, 110)
GridLabel.BackgroundTransparency = 1
GridLabel.Text = "Hasil Scan Objek (Grid 1,2,3 / 4,5,6):"
GridLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
GridLabel.TextXAlignment = Enum.TextXAlignment.Left
GridLabel.Font = Enum.Font.SourceSansGridBold
GridLabel.TextSize = 11
GridLabel.Parent = MainFrame

-- SCROLLING FRAME UNTUK DISPLAY FOTO SCAN
local ImageGridScroll = Instance.new("ScrollingFrame")
ImageGridScroll.Size = UDim2.new(0, 236, 0, 120)
ImageGridScroll.Position = UDim2.new(0, 12, 0, 130)
ImageGridScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
ImageGridScroll.BorderSizePixel = 0
ImageGridScroll.ScrollBarThickness = 4
ImageGridScroll.Parent = MainFrame

local GridScrollCorner = Instance.new("UICorner")
GridScrollCorner.CornerRadius = UDim.new(0, 6)
GridScrollCorner.Parent = ImageGridScroll

-- Layout Susunan Grid Otomatis (3 Kolom Sejajar Horizontal)
local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 72, 0, 72)
GridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = ImageGridScroll

-- Tombol Menyimpan Hasil Scan Hover Banyak Objek
local SaveSelectButton = Instance.new("TextButton")
SaveSelectButton.Size = UDim2.new(0, 236, 0, 28)
SaveSelectButton.Position = UDim2.new(0, 12, 0, 255)
SaveSelectButton.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
SaveSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveSelectButton.Text = "💾 SAVE SCANNED OBJECTS (0)"
SaveSelectButton.Font = Enum.Font.SourceSansBold
SaveSelectButton.TextSize = 11
SaveSelectButton.Visible = false
SaveSelectButton.Parent = MainFrame

local SaveSelCorner = Instance.new("UICorner")
SaveSelCorner.CornerRadius = UDim.new(0, 6)
SaveSelCorner.Parent = SaveSelectButton

-- Label Penanda List File Paste
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 285)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 11
ListLabel.Parent = MainFrame

-- Scrolling Frame Manager File List (Bagian Bawah)
local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 236, 0, 95)
ListScroll.Position = UDim2.new(0, 12, 0, 305)
ListScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 4
ListScroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

-- Tombol Refresh List File
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 236, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 403)
RefreshButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
RefreshButton.TextColor3 = Color3.fromRGB(180, 180, 180)
RefreshButton.Text = "🔄 Refresh File List"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
RefreshButton.Parent = MainFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 4)
RefreshCorner.Parent = RefreshButton


-- [[ LOGIKA DRAGGABLE ]]
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)


-- [[ LOGIKA CORE ANTI-LIMIT LAYER & REKURSAL DATA ]]
local function getRelativePath(obj, customRoot)
    local path = {}
    local current = obj.Parent
    local stopAt = customRoot or workspace
    while current and current ~= stopAt and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

local function isAPlayerCharacter(obj)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (obj == p.Character or obj:IsDescendantOf(p.Character)) then
            return true
        end
    end
    return false
end

local AllowedSupportClasses = {
    ["Texture"] = true, ["Decal"] = true, ["SurfaceAppearance"] = true, 
    ["SpecialMesh"] = true, ["BlockMesh"] = true, ["CylinderMesh"] = true,
    ["ParticleEmitter"] = true, ["PointLight"] = true, ["SpotLight"] = true, ["SurfaceLight"] = true,
    ["Sky"] = true, ["Atmosphere"] = true, ["Clouds"] = true
}

local function serializeObject(obj, rootObj)
    local relPath = getRelativePath(obj, rootObj)
    local data = {
        Name = obj.Name,
        ClassName = obj.ClassName,
        RelativePath = relPath,
        Depth = #relPath,
        Properties = {}
    }
    
    if obj:IsA("BasePart") then
        data.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
        data.Properties.CFrame = {obj.CFrame:GetComponents()}
        data.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
        data.Properties.Material = obj.Material.Name
        data.Properties.Transparency = obj.Transparency
        data.Properties.Reflectance = obj.Reflectance
        data.Properties.Anchored = obj.Anchored
        data.Properties.CanCollide = obj.CanCollide
        data.Properties.CanTouch = obj.CanTouch
        data.Properties.CastShadow = obj.CastShadow
        
        if obj:IsA("MeshPart") then
            pcall(function() data.Properties.MeshId = obj.MeshId end)
            pcall(function() data.Properties.TextureId = obj.TextureId end)
        elseif obj:IsA("UnionOperation") then
            pcall(function() data.Properties.AssetId = obj.AssetId end)
        end
    elseif obj:IsA("Model") then
        pcall(function() data.Properties.WorldPivot = {obj:GetPivot():GetComponents()} end)
    elseif AllowedSupportClasses[obj.ClassName] then
        pcall(function() data.Properties.Texture = obj.Texture end)
        pcall(function() data.Properties.TextureId = obj.TextureId end)
        pcall(function() data.Properties.MeshId = obj.MeshId end)
        pcall(function() data.Properties.MeshType = obj.MeshType.Name end)
        pcall(function() data.Properties.Face = obj.Face.Name end)
        pcall(function() data.Properties.Transparency = obj.Transparency end)
        pcall(function() data.Properties.Color3 = {obj.Color3.r * 255, obj.Color3.g * 255, obj.Color3.b * 255} end)
        pcall(function() data.Properties.StudsPerTileU = obj.StudsPerTileU end)
        pcall(function() data.Properties.StudsPerTileV = obj.StudsPerTileV end)
        pcall(function() data.Properties.OffsetStudsU = obj.OffsetStudsU end)
        pcall(function() data.Properties.OffsetStudsV = obj.OffsetStudsV end)
        pcall(function() data.Properties.Brightness = obj.Brightness end)
        pcall(function() data.Properties.Range = obj.Range end)
        pcall(function() data.Properties.Shadows = obj.Shadows end)
        pcall(function() data.Properties.Angle = obj.Angle end)
        pcall(function() data.Properties.Enabled = obj.Enabled end)
        pcall(function() data.Properties.Rate = obj.Rate end)
        pcall(function() data.Properties.Speed = {obj.Speed.Min, obj.Speed.Max} end)
        pcall(function() data.Properties.Lifetime = {obj.Lifetime.Min, obj.Lifetime.Max} end)
    end
    return data
end


-- [[ ENGINE RENDER DAN UPDATE PREVIEW FOTO DECAL/TEXTURE (GRID 1,2,3) ]]
local function updateImageGrid()
    for _, child in pairs(ImageGridScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for idx, obj in ipairs(SelectedObjects) do
        local ItemBox = Instance.new("Frame")
        ItemBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        ItemBox.Parent = ImageGridScroll
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = ItemBox
        
        -- VIEWPORT FRAME (Kamera Mini 3D Renderer)
        local Viewport = Instance.new("ViewportFrame")
        Viewport.Size = UDim2.new(1, -4, 1, -4)
        Viewport.Position = UDim2.new(0, 2, 0, 2)
        Viewport.BackgroundTransparency = 1
        -- Menyalakan Sistem Studio Light Agar Decal/Texture Terlihat Jelas
        Viewport.Ambient = Color3.fromRGB(220, 220, 220)
        Viewport.LightColor = Color3.fromRGB(255, 255, 255)
        Viewport.LightDirection = Vector3.new(-1, -1, -1)
        Viewport.Parent = ItemBox
        
        -- Mengkloning objek (Aset Decal/Texture/SurfaceAppearance otomatis ikut tersalin)
        local clonedObj = obj:Clone()
        if clonedObj:IsA("BasePart") then
            clonedObj.Position = Vector3.new(0, 0, 0)
            clonedObj.Parent = Viewport
        elseif clonedObj:IsA("Model") then
            clonedObj:PivotTo(CFrame.new(0, 0, 0))
            clonedObj.Parent = Viewport
        end
        
        -- Kalibrasi Sudut Pandang Kamera Otomatis
        local cam = Instance.new("Camera")
        cam.FieldOfView = 45
        Viewport.CurrentCamera = cam
        cam.Parent = Viewport
        
        if obj:IsA("Model") then
            local s, c = obj:GetBoundingBox()
            cam.CFrame = CFrame.new(Vector3.new(s.X, s.Y + (s.Y * 0.5) + 2, s.Z + s.Magnitude + 2), Vector3.new(0, 0, 0))
        else
            local maxDim = math.max(obj.Size.X, obj.Size.Y, obj.Size.Z)
            cam.CFrame = CFrame.new(Vector3.new(maxDim, maxDim + 1, maxDim + 3), Vector3.new(0, 0, 0))
        end
        
        -- Label Penomoran Format Susunan Grid (1, 2, 3...)
        local NumLabel = Instance.new("TextLabel")
        NumLabel.Size = UDim2.new(0, 16, 0, 16)
        NumLabel.Position = UDim2.new(0, 2, 0, 2)
        NumLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        NumLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        NumLabel.Text = tostring(idx)
        NumLabel.Font = Enum.Font.SourceSansBold
        NumLabel.TextSize = 10
        NumLabel.ZIndex = 5
        NumLabel.Parent = ItemBox
        
        local NumCorner = Instance.new("UICorner")
        NumCorner.CornerRadius = UDim.new(1, 0)
        NumCorner.Parent = NumLabel
    end
    
    ImageGridScroll.CanvasSize = UDim2.new(0, 0, 0, GridLayout.AbsoluteContentSize.Y)
end


-- [[ LOGIKA PENYUSURAN MODEL BERLAPIS (ANTI-TERLEWAT) ]]
local function getTopLevelModelOrPart(target)
    if not target or target == workspace then return nil end
    local current = target
    -- Memanjat struktur folder/model lapis demi lapis untuk mencari pembungkus terluarnya yang aman
    while current.Parent and current.Parent ~= workspace and current.Parent ~= game do
        local pName = current.Parent.Name:lower()
        if pName:match("map") or pName:match("world") or pName:match("stage") then break end
        if current.Parent:IsA("Model") or current.Parent:IsA("Folder") then
            current = current.Parent
        else
            break
        end
    end
    return current
end

local function highlightObject(obj, status)
    if status then
        if not HighlightStorage[obj] then
            local box = Instance.new("SelectionBox")
            box.Color3 = Color3.fromRGB(0, 200, 255)
            box.LineThickness = 0.04
            box.Adornee = obj
            box.Parent = ScreenGui
            HighlightStorage[obj] = box
        end
    else
        if HighlightStorage[obj] then HighlightStorage[obj]:Destroy() HighlightStorage[obj] = nil end
    end
end


-- [[ MATRIKS SENSOR HOVER MOUSE REAL-TIME (TANPA KLIK MOUSE) ]]
Mouse.Move:Connect(function()
    if not IsMultiSelecting then return end
    local target = Mouse.Target
    
    if target and not target:IsDescendantOf(ScreenGui) then
        local finalTarget = getTopLevelModelOrPart(target) or target
        
        -- Mencegah spam pembacaan konstan pada satu objek yang sama saat mouse bergerak
        if finalTarget ~= LastHoveredObject then
            LastHoveredObject = finalTarget
            
            if not table.find(SelectedObjects, finalTarget) then
                if not isAPlayerCharacter(finalTarget) and finalTarget ~= workspace then
                    table.insert(SelectedObjects, finalTarget)
                    highlightObject(finalTarget, true)
                    
                    SaveSelectButton.Text = "💾 SAVE SCANNED OBJECTS (" .. #SelectedObjects .. ")"
                    updateImageGrid()
                end
            end
        end
    else
        LastHoveredObject = nil
    end
end)

-- Tombol On/Off Sensor Otomatis
MultiSelectButton.MouseButton1Click:Connect(function()
    IsMultiSelecting = not IsMultiSelecting
    if IsMultiSelecting then
        MultiSelectButton.Text = "🟢 AUTO HOVER SCAN: ON"
        MultiSelectButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        SaveSelectButton.Visible = true
        SaveSelectButton.Text = "💾 SAVE SCANNED OBJECTS (" .. #SelectedObjects .. ")"
    else
        MultiSelectButton.Text = "🤖 AUTO HOVER SCAN: OFF"
        MultiSelectButton.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
        SaveSelectButton.Visible = false
        for obj, _ in pairs(HighlightStorage) do highlightObject(obj, false) end
        SelectedObjects = {}
        HighlightStorage = {}
        LastHoveredObject = nil
        updateImageGrid()
    end
end)


-- [[ PROSES SAVE BATCH SELECTION KE .JSON ]]
SaveSelectButton.MouseButton1Click:Connect(function()
    if #SelectedObjects == 0 then return end
    local SaveData = {}
    local count = 0
    local uniqueID = "HOVER_" .. math.random(100, 999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, mainObj in ipairs(SelectedObjects) do
        count = count + 1
        table.insert(SaveData, serializeObject(mainObj, mainObj.Parent))
        for _, obj in pairs(mainObj:GetDescendants()) do
            if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") or AllowedSupportClasses[obj.ClassName] then
                count = count + 1
                table.insert(SaveData, serializeObject(obj, mainObj.Parent))
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    for obj, _ in pairs(HighlightStorage) do highlightObject(obj, false) end
    SelectedObjects = {}
    HighlightStorage = {}
    updateImageGrid()
    LastHoveredObject = nil
    
    SaveSelectButton.Text = "✅ SUKSES SAVED " .. count .. " OBJS!"
    _G.UpdatePasteList()
    task.wait(1.5)
    IsMultiSelecting = false
    MultiSelectButton.Text = "🤖 AUTO HOVER SCAN: OFF"
    MultiSelectButton.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
    SaveSelectButton.Visible = false
end)


-- 1. PROSES FITUR LAMA (COPY ALL MAP)
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    local objectsToScan = TargetFolder:GetDescendants()
    
    for _, obj in pairs(objectsToScan) do
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") or AllowedSupportClasses[obj.ClassName] then
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) then
                count = count + 1
                CopyButton.Text = "📸 [" .. count .. "] " .. string.sub(obj.Name, 1, 12)
                
                table.insert(SaveData, serializeObject(obj, workspace))
                if count % 250 == 0 then task.wait() end
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 COPIED MAP!"
    task.wait(1.5)
    CopyButton.Text = "COPY ALL MAP (FITUR LAMA)"
    _G.UpdatePasteList()
end)


-- 2. PROSES LIST MANAGER FILE & PASTE REKURSAL BERURUTAN
_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
    
    if not listfiles then return end
    local files = listfiles("")
    local anyFile = false
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            anyFile = true
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local ItemFrame = Instance.new("Frame")
            ItemFrame.Size = UDim2.new(1, -6, 0, 26)
            ItemFrame.BackgroundTransparency = 1
            ItemFrame.Parent = ListScroll
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -26, 1, 0)
            FileSelectBtn.Position = UDim2.new(0, 0, 0, 0)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            FileSelectBtn.Text = " 📄 " .. string.sub(cleanName, 1, 22)
            FileSelectBtn.Font = Enum.Font.SourceSansSemibold
            FileSelectBtn.TextSize = 11
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            FileSelectBtn.Parent = ItemFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = FileSelectBtn
            
            local DeleteBtn = Instance.new("TextButton")
            DeleteBtn.Size = UDim2.new(0, 22, 1, 0)
            DeleteBtn.Position = UDim2.new(1, -22, 0, 0)
            DeleteBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            DeleteBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
            DeleteBtn.Text = "❌"
            DeleteBtn.Font = Enum.Font.SourceSansBold
            DeleteBtn.TextSize = 10
            DeleteBtn.Parent = ItemFrame
            
            local DelCorner = Instance.new("UICorner")
            DelCorner.CornerRadius = UDim.new(0, 4)
            DelCorner.Parent = DeleteBtn

            DeleteBtn.MouseButton1Click:Connect(function()
                if delfile then
                    pcall(function() delfile(file) end)
                    ItemFrame:Destroy()
                    task.wait(0.1)
                    _G.UpdatePasteList()
                end
            end)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                
                local success, err = pcall(function()
                    local fileContent = readfile(file)
                    local loadedData = HttpService:JSONDecode(fileContent)
                    
                    table.sort(loadedData, function(a, b)
                        return (a.Depth or 0) < (b.Depth or 0)
                    end)
                    
                    local MasterFolder = workspace:FindFirstChild("Paste_" .. cleanName)
                    if not MasterFolder then
                        MasterFolder = Instance.new("Folder")
                        MasterFolder.Name = "Paste_" .. cleanName
                        MasterFolder.Parent = workspace
                    end
                    
                    local function findOrCreateParent(relativePath)
                        local currentParent = MasterFolder
                        for _, pathInfo in ipairs(relativePath) do
                            local found = currentParent:FindFirstChild(pathInfo.Name)
                            if not found then
                                pcall(function()
                                    if pathInfo.ClassName == "Folder" or pathInfo.ClassName == "Model" then
                                        found = Instance.new(pathInfo.ClassName)
                                    else
                                        found = Instance.new("Folder")
                                    end
                                    found.Name = pathInfo.Name
                                    found.Parent = currentParent
                                end)
                            end
                            currentParent = found
                        end
                        return currentParent
                    end
                    
                    local pasteCount = 0
                    local totalObjs = #loadedData
                    
                    for _, data in pairs(loadedData) do
                        pcall(function()
                            local targetParent = findOrCreateParent(data.RelativePath)
                            local existingObj = targetParent:FindFirstChild(data.Name)
                            if existingObj and (data.ClassName == "Folder" or data.ClassName == "Model") then
                                return
                            end
                            
                            pasteCount = pasteCount + 1
                            FileSelectBtn.Text = "🔨 [" .. pasteCount .. "/" .. totalObjs .. "] " .. string.sub(data.Name, 1, 10)
                            
                            local newObj
                            local props = data.Properties or {}
                            
                            if AllowedSupportClasses[data.ClassName] then
                                newObj = Instance.new(data.ClassName)
                                pcall(function() if props.Texture then newObj.Texture = props.Texture end end)
                                pcall(function() if props.TextureId then newObj.TextureId = props.TextureId end end)
                                pcall(function() if props.MeshId then newObj.MeshId = props.MeshId end end)
                                pcall(function() if props.MeshType then newObj.MeshType = Enum.MeshType[props.MeshType] end end)
                                pcall(function() if props.Face then newObj.Face = Enum.NormalId[props.Face] end end)
                                pcall(function() if props.Transparency then newObj.Transparency = props.Transparency end end)
                                pcall(function() if props.Enabled ~= nil then newObj.Enabled = props.Enabled end end)
                                pcall(function() if props.Color3 then newObj.Color3 = Color3.fromRGB(unpack(props.Color3)) end end)
                                pcall(function() if props.StudsPerTileU then newObj.StudsPerTileU = props.StudsPerTileU end end)
                                pcall(function() if props.StudsPerTileV then newObj.StudsPerTileV = props.StudsPerTileV end end)
                                pcall(function() if props.OffsetStudsU then newObj.OffsetStudsU = props.OffsetStudsU end end)
                                pcall(function() if props.OffsetStudsV then newObj.OffsetStudsV = props.OffsetStudsV end end)
                                pcall(function() if props.Brightness then newObj.Brightness = props.Brightness end end)
                                pcall(function() if props.Range then newObj.Range = props.Range end end)
                                pcall(function() if props.Shadows ~= nil then newObj.Shadows = props.Shadows end end)
                                pcall(function() if props.Angle then newObj.Angle = props.Angle end end)
                                pcall(function() if props.Rate then newObj.Rate = props.Rate end end)
                                pcall(function() if props.Speed then newObj.Speed = NumberRange.new(props.Speed[1], props.Speed[2]) end end)
                                pcall(function() if props.Lifetime then newObj.Lifetime = NumberRange.new(props.Lifetime[1], props.Lifetime[2]) end end)
                            elseif data.ClassName == "MeshPart" or (props.MeshId and props.MeshId ~= "") then
                                newObj = Instance.new("Part")
                                local specialMesh = Instance.new("SpecialMesh")
                                specialMesh.MeshType = Enum.MeshType.FileMesh
                                specialMesh.MeshId = props.MeshId or ""
                                specialMesh.TextureId = props.TextureId or ""
                                specialMesh.Parent = newObj
                            elseif data.ClassName == "Folder" or data.ClassName == "Model" or data.ClassName == "Part" or data.ClassName == "WedgePart" or data.ClassName == "CornerWedgePart" or data.ClassName == "TrussPart" then
                                newObj = Instance.new(data.ClassName)
                            else
                                newObj = Instance.new("Part")
                            end
                            
                            newObj.Name = data.Name
                            
                            if newObj:IsA("BasePart") and props.CFrame then
                                newObj.Size = Vector3.new(props.Size[1], props.Size[2], props.Size[3])
                                newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3])
                                pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                newObj.Transparency = props.Transparency
                                pcall(function() newObj.Reflectance = props.Reflectance end)
                                newObj.Anchored = props.Anchored
                                newObj.CanCollide = props.CanCollide
                                pcall(function() newObj.CanTouch = props.CanTouch end)
                                pcall(function() newObj.CastShadow = props.CastShadow end)
                            end
                            
                            if newObj:IsA("Model") and props.WorldPivot then
                                pcall(function() newObj:PivotTo(CFrame.new(unpack(props.WorldPivot))) end)
                            end
                            
                            newObj.Parent = targetParent
                            if pasteCount % 250 == 0 then task.wait() end
                        end)
                    end
                end)
                
                if success then
                    FileSelectBtn.Text = " ✅ PASTE SUCCESSFUL!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                else
                    FileSelectBtn.Text = " ❌ ERROR OCCURRED!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    warn(err)
                end
                
                task.wait(2)
                FileSelectBtn.Text = " 📄 " .. cleanName
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            end)
        end
    end
    
    if not anyFile then
        local NoFileLabel = Instance.new("TextLabel")
        NoFileLabel.Size = UDim2.new(1, 0, 0, 30)
        NoFileLabel.BackgroundTransparency = 1
        NoFileLabel.Text = "(Belum ada file copy)"
        NoFileLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        NoFileLabel.Font = Enum.Font.SourceSansItalic
        NoFileLabel.TextSize = 12
        NoFileLabel.Parent = ListScroll
    end
    
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(function()
    _G.UpdatePasteList()
end)

_G.UpdatePasteList()
