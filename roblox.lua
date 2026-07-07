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

local FILE_PREFIX = "WorkspaceCopy_"
local TargetFolder = workspace -- Fokus penuh scan seluruh isi Workspace

-- [[ CREATING GUI (Perfect Curved UI V3) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyPerfectGuiV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 270)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 170, 0) -- Warna Gold/Orange penanda Perfect Version
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Judul GUI Kustom: COPY GAME BY SPYZYY V3
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ COPY GAME BY SPYZYY V3 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

-- Tombol Copy
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 45)
CopyButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "👑 PERFECT WORKSPACE COPY"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

-- Label Penanda List
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 90)
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
ListScroll.Position = UDim2.new(0, 12, 0, 110)
ListScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
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
RefreshButton.Position = UDim2.new(0, 12, 0, 235)
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


-- [[ LOGIKA UTAMA: PERFECT WORKSPACE SYSTEM (V3) ]]

local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= workspace and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

-- 1. PROSES COPY MENYELURUH (ALL BASEPARTS & LAYERS)
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, obj in pairs(TargetFolder:GetDescendants()) do
        -- Filter: Ambil Folder, Model, atau turunan fisik apapun (BasePart mencakup Mesh, Union, Seat, dll)
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") then
            -- Lewati kamera bawaan, karakter player, dan script agar tidak bug
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("LuaSourceContainer") then
                count = count + 1
                local relPath = getRelativePath(obj)
                
                local data = {
                    Name = obj.Name,
                    ClassName = obj.ClassName,
                    RelativePath = relPath,
                    Depth = #relPath
                }
                
                -- Jika objek memiliki bentuk fisik (BasePart)
                if obj:IsA("BasePart") then
                    data.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                    
                    -- Menggunakan format matriks CFrame agar posisi & derajat rotasi miring tersimpan sempurna
                    local components = {obj.CFrame:GetComponents()}
                    data.CFrame = components
                    
                    data.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                    data.Material = obj.Material.Name
                    data.Transparency = obj.Transparency
                    data.Anchored = obj.Anchored
                    data.CanCollide = obj.CanCollide
                    
                    -- Ambil ID khusus jika objek tersebut adalah MeshPart
                    if obj:IsA("MeshPart") then
                        data.MeshId = obj.MeshId
                        data.TextureId = obj.TextureId
                    end
                end
                
                table.insert(SaveData, data)
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "👑 DONE SAVED: " .. count .. " OBJS"
    task.wait(1.5)
    CopyButton.Text = "👑 PERFECT WORKSPACE COPY"
    _G.UpdatePasteList()
end)

-- 2. PROSES RECONSTRUCTION / PASTE PERFECT LAYER
_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    if not listfiles then return end
    local files = listfiles("")
    local anyFile = false
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            anyFile = true
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -6, 0, 26)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            FileSelectBtn.TextColor3 = Color3.fromRGB(255, 170, 0)
            FileSelectBtn.Text = " 📂 " .. cleanName
            FileSelectBtn.Font = Enum.Font.SourceSansSemibold
            FileSelectBtn.TextSize = 11
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            FileSelectBtn.Parent = ListScroll
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = FileSelectBtn
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.Text = " ⌛ BUILDING PERFECT MAP..."
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
                
                local success, err = pcall(function()
                    local fileContent = readfile(file)
                    local loadedData = HttpService:JSONDecode(fileContent)
                    
                    -- Sorting berdasarkan kedalaman (Bapak dibuat duluan sebelum Anak)
                    table.sort(loadedData, function(a, b)
                        return (a.Depth or 0) < (b.Depth or 0)
                    end)
                    
                    local MasterFolder = workspace:FindFirstChild("PerfectPaste_" .. cleanName)
                    if not MasterFolder then
                        MasterFolder = Instance.new("Folder")
                        MasterFolder.Name = "PerfectPaste_" .. cleanName
                        MasterFolder.Parent = workspace
                    end
                    
                    local function findOrCreateParent(relativePath)
                        local currentParent = MasterFolder
                        for _, pathInfo in ipairs(relativePath) do
                            local found = currentParent:FindFirstChild(pathInfo.Name)
                            if not found then
                                -- Proteksi fallback jika ClassName asal tidak dikenal di game tujuan
                                local successInst, resInst = pcall(function() return Instance.new(pathInfo.ClassName) end)
                                found = successInst and resInst or Instance.new("Folder")
                                found.Name = pathInfo.Name
                                found.Parent = currentParent
                            end
                            currentParent = found
                        end
                        return currentParent
                    end
                    
                    for _, data in pairs(loadedData) do
                        pcall(function()
                            local targetParent = findOrCreateParent(data.RelativePath)
                            
                            local existingObj = targetParent:FindFirstChild(data.Name)
                            if existingObj and (data.ClassName == "Folder" or data.ClassName == "Model") then
                                return
                            end
                            
                            -- Membuat instance berdasarkan class aslinya
                            local newObj = Instance.new(data.ClassName)
                            newObj.Name = data.Name
                            
                            if data.CFrame and newObj:IsA("BasePart") then
                                newObj.Size = Vector3.new(data.Size[1], data.Size[2], data.Size[3])
                                
                                -- Rekonstruksi koordinat posisi DAN sudut kemiringan rotasi secara sempurna
                                newObj.CFrame = CFrame.new(unpack(data.CFrame))
                                
                                newObj.Color = Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3])
                                newObj.Material = Enum.Material[data.Material]
                                newObj.Transparency = data.Transparency
                                newObj.Anchored = data.Anchored
                                newObj.CanCollide = data.CanCollide
                                
                                -- Masukkan kembali ID aset jika berupa MeshPart
                                if data.MeshId and newObj:IsA("MeshPart") then
                                    newObj.MeshId = data.MeshId
                                    newObj.TextureId = data.TextureId
                                end
                            end
                            newObj.Parent = targetParent
                        end)
                    end
                end)
                
                if success then
                    FileSelectBtn.Text = " ✅ PERFECTLY REBUILT!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                else
                    FileSelectBtn.Text = " ❌ BUILD ERROR!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    warn(err)
                end
                
                task.wait(2)
                FileSelectBtn.Text = " 📂 " .. cleanName
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
