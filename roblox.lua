-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserService = game:GetService("UserService")
local LocalPlayer = Players.LocalPlayer

-- Proteksi Instan PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer.PlayerGui

-- Mendapatkan Nama Game Secara Otomatis
local GameName = "Unknown_Game"
task.spawn(function()
    pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        if productInfo and productInfo.Name then
            GameName = productInfo.Name:gsub("[%s%p]", "_")
        end
    end)
end)

local FILE_PREFIX = "GameCopyV2_"
local TargetFolder = workspace

-- [[ DEKLARASI GUI UTAMA MAP COPY (MODERN DARK THEME) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 370)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -185)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 ULTRA MAP COPIER V2 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

-- [[ PANEL PROFILE USER ]]
local InfoPanel = Instance.new("Frame")
InfoPanel.Size = UDim2.new(0, 216, 0, 85)
InfoPanel.Position = UDim2.new(0, 12, 0, 40)
InfoPanel.BackgroundColor3 = Color3.fromRGB(22, 24, 33)
InfoPanel.BorderSizePixel = 0
InfoPanel.Parent = MainFrame

local InfoPanelCorner = Instance.new("UICorner")
InfoPanelCorner.CornerRadius = UDim.new(0, 8)
InfoPanelCorner.Parent = InfoPanel

local InfoPanelStroke = Instance.new("UIStroke")
InfoPanelStroke.Thickness = 1
InfoPanelStroke.Color = Color3.fromRGB(40, 44, 60)
InfoPanelStroke.Parent = InfoPanel

local UserLayout = Instance.new("UIListLayout")
UserLayout.Padding = UDim.new(0, 2)
UserLayout.SortOrder = Enum.SortOrder.LayoutOrder
UserLayout.Parent = InfoPanel

local function CreateProfileLabel(text, color, order)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.LayoutOrder = order
    label.Parent = InfoPanel
    return label
end

local NameLabel = CreateProfileLabel("👤 Name: Loading...", Color3.fromRGB(255, 255, 255), 1)
local UsernameLabel = CreateProfileLabel("🆔 User: @" .. LocalPlayer.Name, Color3.fromRGB(180, 180, 180), 2)
local AgeLabel = CreateProfileLabel("📅 Umur Akun: Dihitung...", Color3.fromRGB(0, 200, 255), 3)
local BioLabel = CreateProfileLabel("📝 Bio: Loading...", Color3.fromRGB(150, 150, 150), 4)

task.spawn(function()
    pcall(function()
        NameLabel.Text = "👤 Name: " .. LocalPlayer.DisplayName
        AgeLabel.Text = "📅 Umur Akun: " .. LocalPlayer.AccountAge .. " Hari"
        local playerInfo = UserService:GetUserInfosByUserIdsAsync({LocalPlayer.UserId})
        if playerInfo and playerInfo[1] and playerInfo[1].Description ~= "" then
            local bio = playerInfo[1].Description
            if #bio > 22 then bio = string.sub(bio, 1, 20) .. ".." end
            BioLabel.Text = "📝 Bio: " .. bio
        else
            BioLabel.Text = "📝 Bio: (Kosong)"
        end
    end)
end)

-- [[ ELEMENT KONTROL ]]
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 216, 0, 36)
CopyButton.Position = UDim2.new(0, 12, 0, 135)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "START SCAN & COPY MAP"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 178)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Daftar File Map Terdeteksi:"
ListLabel.TextColor3 = Color3.fromRGB(150, 153, 170)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 11
ListLabel.Parent = MainFrame

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 216, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 198)
ListScroll.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 3
ListScroll.Parent = MainFrame

local ListScrollCorner = Instance.new("UICorner")
ListScrollCorner.CornerRadius = UDim.new(0, 6)
ListScrollCorner.Parent = ListScroll

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 216, 0, 24)
RefreshButton.Position = UDim2.new(0, 12, 0, 325)
RefreshButton.BackgroundColor3 = Color3.fromRGB(28, 30, 43)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh Database File"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
RefreshButton.Parent = MainFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
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
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


-- [[ MODERN ENGINE: SUPPORT ALL MODES & PARTS ]]
local function getCleanRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= workspace and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

local function checkPlayerChar(obj)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (obj == p.Character or obj:IsDescendantOf(p.Character)) then return true end
    end
    return false
end

CopyButton.MouseButton1Click:Connect(function()
    if not writefile then CopyButton.Text = "Executor Tidak Mendukung File System!"; return end
    CopyButton.Text = "🔍 Memindai Semua Objek..."; task.wait(0.2)

    local RawData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, obj in pairs(TargetFolder:GetDescendants()) do
        if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not checkPlayerChar(obj) then
            count = count + 1
            if count % 500 == 0 then 
                CopyButton.Text = "📸 Terproses: [" .. count .. "] Objek..." 
                task.wait() 
            end
            
            local relPath = getCleanRelativePath(obj)
            local itemData = {
                Name = obj.Name,
                ClassName = obj.ClassName,
                RelativePath = relPath,
                Depth = #relPath,
                Properties = {}
            }
            
            pcall(function()
                -- Ekstraksi Properti Universal untuk Semua Jenis BasePart (Part, MeshPart, Truss, Union, dll)
                if obj:IsA("BasePart") then
                    itemData.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                    itemData.Properties.CFrame = {obj.CFrame:GetComponents()}
                    itemData.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                    itemData.Properties.Material = obj.Material.Name
                    itemData.Properties.Transparency = obj.Transparency
                    itemData.Properties.Reflectance = obj.Reflectance
                    itemData.Properties.Anchored = obj.Anchored
                    itemData.Properties.CanCollide = obj.CanCollide
                    itemData.Properties.CastShadow = obj.CastShadow
                    
                    if obj:IsA("MeshPart") then
                        itemData.Properties.MeshId = obj.MeshId
                        itemData.Properties.TextureId = obj.TextureId
                    elseif obj:IsA("UnionOperation") then
                        itemData.Properties.AssetId = obj.AssetId
                    end
                -- Properti Tambahan untuk Visual & Efek Pencahayaan
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    itemData.Properties.Texture = obj.Texture
                    itemData.Properties.Transparency = obj.Transparency
                    itemData.Properties.Face = obj.Face.Name
                localColor = obj:IsA("Light") and pcall(function()
                    itemData.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                    itemData.Properties.Brightness = obj.Brightness
                    itemData.Properties.Range = obj.Range
                    itemData.Properties.Enabled = obj.Enabled
                end)
                elseif obj:IsA("SpecialMesh") or obj:IsA("BlockMesh") or obj:IsA("CylinderMesh") then
                    pcall(function() itemData.Properties.MeshId = obj.MeshId end)
                    pcall(function() itemData.Properties.TextureId = obj.TextureId end)
                    itemData.Properties.Scale = {obj.Scale.X, obj.Scale.Y, obj.Scale.Z}
                end
            end)
            table.insert(RawData, itemData)
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(RawData))
    CopyButton.Text = "💾 SELESAI: " .. count .. " OBJEK"
    task.wait(2)
    CopyButton.Text = "START SCAN & COPY MAP"
    _G.UpdatePasteList()
end)

_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    if not listfiles then return end
    
    local files = pcall(listfiles, "") and listfiles("") or {}
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local ItemFrame = Instance.new("Frame")
            ItemFrame.Size = UDim2.new(1, -6, 0, 26)
            ItemFrame.BackgroundTransparency = 1
            ItemFrame.Parent = ListScroll
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -26, 1, 0)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
            FileSelectBtn.Text = " 📁 " .. cleanName
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
            DeleteBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
            DeleteBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
            DeleteBtn.Text = "✕"
            DeleteBtn.Font = Enum.Font.SourceSansBold
            DeleteBtn.TextSize = 11
            DeleteBtn.Parent = ItemFrame
            
            local DelCorner = Instance.new("UICorner")
            DelCorner.CornerRadius = UDim.new(0, 4)
            DelCorner.Parent = DeleteBtn

            DeleteBtn.MouseButton1Click:Connect(function()
                if delfile then pcall(delfile, file); ItemFrame:Destroy(); _G.UpdatePasteList() end
            end)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                task.spawn(function()
                    local success, err = pcall(function()
                        local fileContent = readfile(file)
                        local loadedData = HttpService:JSONDecode(fileContent)
                        
                        -- STRATEGI PENTING: Urutkan kedalaman (Depth) agar Parent selalu dibuat duluan sebelum Child!
                        table.sort(loadedData, function(a, b) return (a.Depth or 0) < (b.Depth or 0) end)
                        
                        local MasterFolder = workspace:FindFirstChild("Paste_" .. cleanName) or Instance.new("Folder")
                        MasterFolder.Name = "Paste_" .. cleanName
                        MasterFolder.Parent = workspace
                        
                        local function buildStructure(relativePath)
                            local lastParent = MasterFolder
                            for _, pathInfo in ipairs(relativePath) do
                                local found = lastParent:FindFirstChild(pathInfo.Name)
                                if not found then
                                    local newStructure = pcall(function() return Instance.new(pathInfo.ClassName) end) and Instance.new(pathInfo.ClassName) or Instance.new("Folder")
                                    newStructure.Name = pathInfo.Name
                                    newStructure.Parent = lastParent
                                    lastParent = newStructure
                                else
                                    lastParent = found
                                end
                            end
                            return lastParent
                        end
                        
                        local total = #loadedData
                        for index, data in ipairs(loadedData) do
                            pcall(function()
                                local targetParent = buildStructure(data.RelativePath)
                                
                                -- Jika folder/model struktur sudah ada, tidak perlu di-instantiate ulang agar rapi
                                if targetParent:FindFirstChild(data.Name) and (data.ClassName == "Folder" or data.ClassName == "Model") then return end
                                
                                if index % 300 == 0 then
                                    FileSelectBtn.Text = "🔨 Memasang: [" .. index .. "/" .. total .. "]"
                                    task.wait()
                                end
                                
                                local newObj = Instance.new(data.ClassName)
                                newObj.Name = data.Name
                                local props = data.Properties or {}
                                
                                -- Rekonstruksi Properti Fisik Akurat
                                if newObj:IsA("BasePart") and props.CFrame then
                                    newObj.Size = Vector3.new(unpack(props.Size))
                                    newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                    newObj.Color = Color3.fromRGB(unpack(props.Color))
                                    pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                    newObj.Transparency = props.Transparency
                                    newObj.Reflectance = props.Reflectance
                                    newObj.Anchored = props.Anchored
                                    newObj.CanCollide = props.CanCollide
                                    if props.CastShadow ~= nil then newObj.CastShadow = props.CastShadow end
                                    
                                    if newObj:IsA("MeshPart") and props.MeshId then
                                        newObj.MeshId = props.MeshId
                                        newObj.TextureId = props.TextureId
                                    elseif newObj:IsA("UnionOperation") and props.AssetId then
                                        newObj.AssetId = props.AssetId
                                    end
                                elseif newObj:IsA("Decal") or newObj:IsA("Texture") then
                                    newObj.Texture = props.Texture
                                    newObj.Transparency = props.Transparency
                                    pcall(function() newObj.Face = Enum.NormalId[props.Face] end)
                                elseif newObj:IsA("Light") then
                                    newObj.Color = Color3.fromRGB(unpack(props.Color))
                                    newObj.Brightness = props.Brightness
                                    newObj.Range = props.Range
                                    newObj.Enabled = props.Enabled
                                elseif newObj:IsA("SpecialMesh") and props.MeshId then
                                    newObj.MeshId = props.MeshId
                                    if props.TextureId then newObj.TextureId = props.TextureId end
                                    newObj.Scale = Vector3.new(unpack(props.Scale))
                                end
                                
                                newObj.Parent = targetParent
                            end)
                        end
                    end)
                    
                    if success then
                        FileSelectBtn.Text = " 🎉 TEMPEL SUKSES RAPIPURNA!"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(5, 150, 105)
                    else
                        FileSelectBtn.Text = " ✕ TERJADI EROR SISTEM!"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
                    end
                    task.wait(2)
                    FileSelectBtn.Text = " 📁 " .. cleanName
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
                end)
            end)
        end
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(_G.UpdatePasteList)
_G.UpdatePasteList()
