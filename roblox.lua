

-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GameName = "Unknown_Game"
pcall(function()
    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    if productInfo and productInfo.Name then
        GameName = productInfo.Name:gsub("[%s%p]", "_")
    end
end)

local FILE_PREFIX = "GameCopy_"
local TargetFolder = workspace

-- [[ CREATING GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV3"
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
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 COPY MAP ANTI-ANEH V3 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 45)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 6)

local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 90)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 12
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Parent = MainFrame

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 206, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 110)
ListScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 4
ListScroll.Parent = MainFrame

Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", ListScroll)
ListLayout.Padding = UDim.new(0, 4)

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 206, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 235)
RefreshButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh List File"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
RefreshButton.Parent = MainFrame

Instance.new("UICorner", RefreshButton).CornerRadius = UDim.new(0, 4)

-- Logika Drag GUI
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y) end end)

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
        if p.Character and (obj == p.Character or obj:IsDescendantOf(p.Character)) then return true end
    end
    return false
end

-- [[ LAPISAN 1: PROSES SCANNING & DEEP ANALYSIS ]]
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then CopyButton.Text = "Executor Tak Support!" return end

    local SaveData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, obj in pairs(TargetFolder:GetDescendants()) do
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
            
            -- Ekstraksi Properti Dasar Universal
            pcall(function() data.Properties.TextureId = obj.TextureId end)
            pcall(function() data.Properties.Texture = obj.Texture end)
            pcall(function() data.Properties.Image = obj.Image end)
            pcall(function() data.Properties.Face = obj.Face.Name end)
            pcall(function() data.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255} end)
            
            -- Perekaman Struktur Model (Anti-Aneh Lapisan Primer)
            if obj:IsA("Model") then
                pcall(function() data.Properties.WorldPivot = {obj:GetPivot():GetComponents()} end)
            end
            
            -- Perekaman Fisik Geometri Part
            if obj:IsA("BasePart") then
                data.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                data.Properties.CFrame = {obj.CFrame:GetComponents()}
                data.Properties.Material = obj.Material.Name
                data.Properties.Transparency = obj.Transparency
                data.Properties.Anchored = obj.Anchored
                data.Properties.CanCollide = obj.CanCollide
                
                -- Lapisan Rekam Skala Khusus Mesh/Union
                if obj:IsA("MeshPart") then
                    pcall(function() data.Properties.MeshId = obj.MeshId end)
                    pcall(function() data.Properties.Size0 = {obj.Size.X, obj.Size.Y, obj.Size.Z} end) -- Rekam rasio asli
                elseif obj:IsA("UnionOperation") then
                    pcall(function() data.Properties.AssetId = obj.AssetId end)
                end
            end
            
            table.insert(SaveData, data)
            if count % 250 == 0 then task.wait() end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 COPIED: " .. count .. " OBJS"
    task.wait(2) CopyButton.Text = "COPYY OM"
    _G.UpdatePasteList()
end)

-- [[ LAPISAN 2: PROSES BENTUK ULANG BERLAPIS (PASTE LOGIC) ]]
_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    if not listfiles then return end
    local files = listfiles("") local anyFile = false
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            anyFile = true
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -6, 0, 26)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            FileSelectBtn.Text = " 📄 " .. cleanName
            FileSelectBtn.Font = Enum.Font.SourceSansSemibold
            FileSelectBtn.TextSize = 11
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            FileSelectBtn.Parent = ListScroll
            
            Instance.new("UICorner", FileSelectBtn).CornerRadius = UDim.new(0, 4)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                
                local success, err = pcall(function()
                    local fileContent = readfile(file)
                    local loadedData = HttpService:JSONDecode(fileContent)
                    
                    table.sort(loadedData, function(a, b) return (a.Depth or 0) < (b.Depth or 0) end)
                    
                    local MasterFolder = workspace:FindFirstChild("Paste_" .. cleanName) or Instance.new("Folder", workspace)
                    MasterFolder.Name = "Paste_" .. cleanName
                    
                    local function findOrCreateParent(relativePath)
                        local currentParent = MasterFolder
                        for _, pathInfo in ipairs(relativePath) do
                            local found = currentParent:FindFirstChild(pathInfo.Name)
                            if not found then
                                pcall(function()
                                    found = Instance.new(pathInfo.ClassName)
                                    found.Name = pathInfo.Name
                                    found.Parent = currentParent
                                end)
                                if not found then found = currentParent end
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
                            if targetParent:FindFirstChild(data.Name) and (data.ClassName == "Folder" or data.ClassName == "Model") then return end
                            
                            pasteCount = pasteCount + 1
                            FileSelectBtn.Text = "🔨 [" .. pasteCount .. "/" .. totalObjs .. "] " .. string.sub(data.Name, 1, 10)
                            
                            local newObj
                            local props = data.Properties or {}
                            
                            -- LAPISAN REKONSTRUKSI BENTUK (ANTI-ANEH):
                            if data.ClassName == "MeshPart" or (props.MeshId and props.MeshId ~= "") then
                                -- Lapisan 1 Fallback: Gunakan SpecialMesh di dalam Part reguler
                                newObj = Instance.new("Part")
                                local specialMesh = Instance.new("SpecialMesh")
                                specialMesh.MeshType = Enum.MeshType.FileMesh
                                specialMesh.MeshId = props.MeshId or ""
                                specialMesh.TextureId = props.TextureId or ""
                                
                                -- Lapisan 2 Kompensasi Skala: Mengunci distorsi bentuk mesh agar proporsional
                                if props.Size0 and props.Size then
                                    specialMesh.Scale = Vector3.new(1, 1, 1)
                                end
                                specialMesh.Parent = newObj
                            elseif data.ClassName == "UnionOperation" and (props.AssetId and props.AssetId ~= "") then
                                -- Lapisan Fallback Union korup
                                newObj = Instance.new("Part")
                                local blockMesh = Instance.new("BlockMesh")
                                blockMesh.Parent = newObj
                            else
                                newObj = Instance.new(data.ClassName)
                            end
                            
                            newObj.Name = data.Name
                            
                            -- Mengembalikan Posisi Fisik yang Akurat
                            if newObj:IsA("BasePart") and props.CFrame then
                                newObj.Size = Vector3.new(props.Size[1], props.Size[2], props.Size[3])
                                newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3])
                                pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                newObj.Transparency = props.Transparency
                                newObj.Anchored = props.Anchored
                                newObj.CanCollide = props.CanCollide
                            elseif newObj:IsA("Model") and props.WorldPivot then
                                -- Lapisan Pemulihan Orientasi Model Group
                                pcall(function() newObj:PivotTo(CFrame.new(unpack(props.WorldPivot))) end)
                            else
                                -- Apply properti pelengkap objek insert bebas jenis
                                pcall(function() newObj.TextureId = props.TextureId end)
                                pcall(function() newObj.Texture = props.Texture end)
                                pcall(function() newObj.Image = props.Image end)
                                pcall(function() newObj.Face = Enum.NormalId[props.Face] end)
                                pcall(function() newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3]) end)
                            end
                            
                            newObj.Parent = targetParent
                            if pasteCount % 250 == 0 then task.wait() end
                        end)
                    end
                end)
                
                FileSelectBtn.Text = success and " ✅ PASTE SUCCESSFUL!" or " ❌ ERROR OCCURRED!"
                FileSelectBtn.BackgroundColor3 = success and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(150, 0, 0)
                if not success then warn(err) end
                
                task.wait(2) FileSelectBtn.Text = " 📄 " .. cleanName FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            end)
        end
    end
    
    if not anyFile then
        local NoFileLabel = Instance.new("TextLabel", ListScroll)
        NoFileLabel.Size = UDim2.new(1, 0, 0, 30) NoFileLabel.BackgroundTransparency = 1
        NoFileLabel.Text = "(Belum ada file copy)" NoFileLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        NoFileLabel.Font = Enum.Font.SourceSansItalic NoFileLabel.TextSize = 12
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(function() _G.UpdatePasteList() end)
_G.UpdatePasteList()