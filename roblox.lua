-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
local IsInvisible = false -- Status awal invisible

-- [[ CREATING GUI (Premium Curved UI V2) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 300) -- Ukuran Y dinaikkan menjadi 300 untuk menampung tombol baru
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Judul GUI Kustom: COPY MAP BY SPYZYY V2
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 COPY MAP BY SPYZYY V2 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

-- Tombol Copy
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 32)
CopyButton.Position = UDim2.new(0, 12, 0, 42)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

-- Tombol Invisible Toggle (On/Off)
local InvisibleButton = Instance.new("TextButton")
InvisibleButton.Size = UDim2.new(0, 206, 0, 26)
InvisibleButton.Position = UDim2.new(0, 12, 0, 78)
InvisibleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
InvisibleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
InvisibleButton.Text = "👻 Invisible: OFF"
InvisibleButton.Font = Enum.Font.SourceSansSemibold
InvisibleButton.TextSize = 12
InvisibleButton.Parent = MainFrame

local InvisibleCorner = Instance.new("UICorner")
InvisibleCorner.CornerRadius = UDim.new(0, 6)
InvisibleCorner.Parent = InvisibleButton

-- Label Penanda List
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 110) -- Disesuaikan posisinya turun ke bawah
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 12
ListLabel.Parent = MainFrame

-- Scrolling Frame
local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 206, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 132) -- Disesuaikan posisinya turun ke bawah
ListScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 4
ListScroll.Parent = MainFrame

local ListScrollCorner = Instance.new("UICorner")
ListScrollCorner.CornerRadius = UDim.new(0, 6)
ListScrollCorner.Parent = ListScroll

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

-- Tombol Refresh List
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 206, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 265) -- Disesuaikan posisinya turun ke bawah
RefreshButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh List File"
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
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
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


-- [[ LOGIKA INVISIBLE AVATAR LOCAL ]]
local function setAvatarVisibility(visible)
    local char = LocalPlayer.Character
    if not char then return end
    
    local transparencyValue = visible and 0 or 1
    
    -- Mengatur visibilitas bagian tubuh (Parts) dan Decal (Wajah, Tato, dsb)
    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            obj.Transparency = transparencyValue
        elseif obj:IsA("Decal") then
            obj.Transparency = transparencyValue
        end
    end
    
    -- Menyembunyikan nama di atas kepala (Nametag / HealthBar)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = visible and Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None
    end
end

-- Memicu fungsi invisible ulang ketika player mati & respawn kembali
LocalPlayer.CharacterAdded:Connect(function(char)
    if IsInvisible then
        task.wait(0.5) -- Menunggu karakter selesai load sempurna
        setAvatarVisibility(false)
    end
end)

InvisibleButton.MouseButton1Click:Connect(function()
    IsInvisible = not IsInvisible
    if IsInvisible then
        setAvatarVisibility(false)
        InvisibleButton.Text = "✨ Invisible: ON"
        InvisibleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        InvisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        setAvatarVisibility(true)
        InvisibleButton.Text = "👻 Invisible: OFF"
        InvisibleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        InvisibleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)


-- [[ LOGIKA CORE ANTI-LIMIT LAYER ]]

local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= workspace and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

-- Fungsi cek apakah objek adalah bagian dari karakter player manapun
local function isAPlayerCharacter(obj)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (obj == p.Character or obj:IsDescendantOf(p.Character)) then
            return true
        end
    end
    return false
end

-- 1. PROSES COPY DENGAN FIX PROTEKSI MESH & FILTER PLAYER
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
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") then
            -- FILTER DIPERKETAT: Memastikan objek bukan kamera, terrain, ataupun bagian tubuh player
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) then
                count = count + 1
                
                CopyButton.Text = "📸 [" .. count .. "] " .. string.sub(obj.Name, 1, 12)
                
                local relPath = getRelativePath(obj)
                local data = {
                    Name = obj.Name,
                    ClassName = obj.ClassName,
                    RelativePath = relPath,
                    Depth = #relPath
                }
                
                if obj:IsA("BasePart") then
                    data.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                    data.CFrame = {obj.CFrame:GetComponents()}
                    data.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                    data.Material = obj.Material.Name
                    data.Transparency = obj.Transparency
                    data.Anchored = obj.Anchored
                    data.CanCollide = obj.CanCollide
                    
                    -- FIX PROTEKSI: Menggunakan pcall agar jika properti MeshId/TextureId tidak ada, script tidak akan crash/stuck!
                    if obj:IsA("MeshPart") then
                        pcall(function() data.MeshId = obj.MeshId end)
                        pcall(function() data.TextureId = obj.TextureId end)
                    elseif obj:IsA("UnionOperation") then
                        pcall(function() data.AssetId = obj.AssetId end)
                    end
                end
                table.insert(SaveData, data)
                
                if count % 250 == 0 then task.wait() end
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 COPIED: " .. count .. " OBJS"
    task.wait(2)
    CopyButton.Text = "COPYY OM"
    _G.UpdatePasteList()
end)

-- 2. PROSES REFRESH DAN PASTE BERURUTAN
_G.UpdatePasteList = function()
    -- Membersihkan semua item di dalam list (baik TextButton maupun Frame kontainer baru)
    for _, child in pairs(ListScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
    end
    
    if not listfiles then return end
    local files = listfiles("")
    local anyFile = false
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            anyFile = true
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            -- Frame Kontainer Utama per Baris List
            local ItemFrame = Instance.new("Frame")
            ItemFrame.Size = UDim2.new(1, -6, 0, 26)
            ItemFrame.BackgroundTransparency = 1
            ItemFrame.Parent = ListScroll
            
            -- Tombol Pilih File / Paste (Ukuran dikurangi di kanan untuk tempat tombol delete)
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -28, 1, 0)
            FileSelectBtn.Position = UDim2.new(0, 0, 0, 0)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            FileSelectBtn.Text = " 📄 " .. cleanName
            FileSelectBtn.Font = Enum.Font.SourceSansSemibold
            FileSelectBtn.TextSize = 11
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            FileSelectBtn.Parent = ItemFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = FileSelectBtn
            
            -- Tombol Delete ❌ di Sudut Kanan Berdampingan
            local DeleteBtn = Instance.new("TextButton")
            DeleteBtn.Size = UDim2.new(0, 24, 1, 0)
            DeleteBtn.Position = UDim2.new(1, -24, 0, 0)
            DeleteBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            DeleteBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
            DeleteBtn.Text = "❌"
            DeleteBtn.Font = Enum.Font.SourceSansBold
            DeleteBtn.TextSize = 11
            DeleteBtn.Parent = ItemFrame
            
            local DelCorner = Instance.new("UICorner")
            DelCorner.CornerRadius = UDim.new(0, 4)
            DelCorner.Parent = DeleteBtn
            
            -- Fitur Aksi Hapus File
            DeleteBtn.MouseButton1Click:Connect(function()
                if delfile then
                    pcall(function()
                        delfile(file)
                    end)
                    _G.UpdatePasteList()
                else
                    DeleteBtn.Text = "⚠️"
                    task.wait(1)
                    DeleteBtn.Text = "❌"
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
                            if data.ClassName == "MeshPart" or (data.MeshId and data.MeshId ~= "") then
                                newObj = Instance.new("Part")
                                local specialMesh = Instance.new("SpecialMesh")
                                specialMesh.MeshType = Enum.MeshType.FileMesh
                                specialMesh.MeshId = data.MeshId or ""
                                specialMesh.TextureId = data.TextureId or ""
                                specialMesh.Parent = newObj
                            elseif data.ClassName == "Folder" or data.ClassName == "Model" or data.ClassName == "Part" or data.ClassName == "WedgePart" or data.ClassName == "CornerWedgePart" or data.ClassName == "TrussPart" then
                                newObj = Instance.new(data.ClassName)
                            else
                                newObj = Instance.new("Part")
                            end
                            
                            newObj.Name = data.Name
                            
                            if data.CFrame and newObj:IsA("BasePart") then
                                newObj.Size = Vector3.new(data.Size[1], data.Size[2], data.Size[3])
                                newObj.CFrame = CFrame.new(unpack(data.CFrame))
                                newObj.Color = Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3])
                                pcall(function() newObj.Material = Enum.Material[data.Material] end)
                                newObj.Transparency = data.Transparency
                                newObj.Anchored = data.Anchored
                                newObj.CanCollide = data.CanCollide
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
