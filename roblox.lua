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

-- [[ CREATING GUI (Premium Curved UI V2) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 270)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -135)
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
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 45)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
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

local function isAPlayerCharacter(obj)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (obj == p.Character or obj:IsDescendantOf(p.Character)) then
            return true
        end
    end
    
    if obj:IsA("Model") or obj:IsA("BasePart") then
        local rootPart = obj:IsA("Model") and obj.PrimaryPart or (obj:IsA("BasePart") and obj or nil)
        if rootPart then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pRoot = p.Character.HumanoidRootPart
                    local distance = (rootPart.Position - pRoot.Position).Magnitude
                    if distance < 6 and rootPart.Anchored == false then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Memastikan Class Script terdaftar
local AllowedSupportClasses = {
    ["Texture"] = true, ["Decal"] = true, ["SurfaceAppearance"] = true, 
    ["SpecialMesh"] = true, ["BlockMesh"] = true, ["CylinderMesh"] = true,
    ["ParticleEmitter"] = true, ["PointLight"] = true, ["SpotLight"] = true, ["SurfaceLight"] = true,
    ["Sky"] = true, ["Atmosphere"] = true, ["Clouds"] = true,
    ["Script"] = true, ["LocalScript"] = true, ["ModuleScript"] = true
}

-- Fungsi Ekstra untuk Mendapatkan Source Code secara Aman (Mendukung Decompiler Executor)
local function getScriptSourceSafe(scriptObj)
    local source = ""
    
    -- 1. Coba metode decompile bawaan executor (Paling Ampuh untuk game orang lain)
    if decompile then
        local success, res = pcall(function() return decompile(scriptObj) end)
        if success and res and res ~= "" then return res end
    end
    
    -- 2. Coba fungsi alternatif executor (getscriptsource)
    if getscriptsource then
        local success, res = pcall(function() return getscriptsource(scriptObj) end)
        if success and res and res ~= "" then return res end
    end

    -- 3. Coba baca properti langsung (Hanya bekerja jika itu game milikmu sendiri di Studio)
    local success, res = pcall(function() return scriptObj.Source end)
    if success and res and res ~= "" then return res end
    
    return "-- [Gagal membaca kode: Executor tidak mendukung Decompile/Source read pada game ini]"
end

-- 1. PROSES COPY DENGAN PROPERTI PENUH & POSISI ASLI
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    -- Memperluas area scan tidak hanya di Workspace, tapi juga di tempat penyimpanan lain agar script ketemu
    local objectsToScan = {}
    for _, service in pairs({workspace, game:GetService("ReplicatedStorage"), game:GetService("Lighting")}) do
        for _, child in pairs(service:GetDescendants()) do
            table.insert(objectsToScan, child)
        end
    end
    
    for _, obj in pairs(objectsToScan) do
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") or AllowedSupportClasses[obj.ClassName] then
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) then
                count = count + 1
                
                CopyButton.Text = "📸 [" .. count .. "] " .. string.sub(obj.Name, 1, 12)
                
                local relPath = getRelativePath(obj)
                local data = {
                    Name = obj.Name,
                    ClassName = obj.ClassName,
                    RelativePath = relPath,
                    Depth = #relPath,
                    Properties = {}
                }
                
                -- Memanggil Fungsi Pembaca Kode yang Diperbarui
                if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                    data.Properties.Source = getScriptSourceSafe(obj)
                
                elseif obj:IsA("BasePart") then
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

                elseif AllowedSupportClasses[obj.ClassName] and not (obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript")) then
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
            FileSelectBtn.Text = " 📄 " .. cleanName
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
                else
                    DeleteBtn.Text = "No!"
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
                            
                            -- Membuat Kembali Objek Script Beserta Isi Kodenya saat Paste
                            if data.ClassName == "Script" or data.ClassName == "LocalScript" or data.ClassName == "ModuleScript" then
                                newObj = Instance.new(data.ClassName)
                                pcall(function()
                                    if props.Source then newObj.Source = props.Source end
                                end)
                            
                            elseif AllowedSupportClasses[data.ClassName] then
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
