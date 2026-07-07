-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

local GameName = "Unknown_Game"
pcall(function()
    local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
    if productInfo and productInfo.Name then
        GameName = productInfo.Name:gsub("[%s%p]", "_")
    end
end)

local FILE_PREFIX = "GameCopy_"

-- Target scanning multi-service
local ScanTargets = {
    game:GetService("Workspace"),
    game:GetService("ReplicatedStorage"),
    game:GetService("StarterPlayer")
}
pcall(function()
    local ServerStorage = game:GetService("ServerStorage")
    if ServerStorage then table.insert(ScanTargets, ServerStorage) end
end)

-- Variabel kontrol seleksi mouse (Blacklist)
local BlacklistObjects = {}
local SelectionHighlightMode = false
local HighlightVisuals = {}

-- [[ CREATING GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV4"
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

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 200, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 SPYZYY MULTI-COPY V4 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13

local CopyButton = Instance.new("TextButton", MainFrame)
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 45)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 6)

local ListLabel = Instance.new("TextLabel", MainFrame)
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 90)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 12
ListLabel.TextXAlignment = Enum.TextXAlignment.Left

local ListScroll = Instance.new("ScrollingFrame", MainFrame)
ListScroll.Size = UDim2.new(0, 206, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 110)
ListScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 4
Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 6)

local ListLayout = Instance.new("UIListLayout", ListScroll)
ListLayout.Padding = UDim.new(0, 4)

local RefreshButton = Instance.new("TextButton", MainFrame)
RefreshButton.Size = UDim2.new(0, 206, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 235)
RefreshButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh List File"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
Instance.new("UICorner", RefreshButton).CornerRadius = UDim.new(0, 4)

-- Tombol Konfirmasi Selesai Pilih Objek (Disembunyikan di awal)
local ConfirmButton = Instance.new("TextButton", ScreenGui)
ConfirmButton.Size = UDim2.new(0, 250, 0, 40)
ConfirmButton.Position = UDim2.new(0.5, -125, 0.85, 0)
ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmButton.Text = "🟩 [ SELESAI & MULAI COPY ]"
ConfirmButton.Font = Enum.Font.SourceSansBold
ConfirmButton.TextSize = 14
ConfirmButton.Visible = false
Instance.new("UICorner", ConfirmButton).CornerRadius = UDim.new(0, 8)

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

-- [[ UTILITY FUNCTIONS ]]
local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= game do
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

local function getTopLevelTarget(obj)
    if not obj or obj == workspace or obj == game then return nil end
    local current = obj
    while current.Parent and current.Parent ~= workspace and (current.Parent:IsA("Model") or current.Parent:IsA("Folder")) do
        current = current.Parent
    end
    return current
end

-- [[ LOGIKA KLIK MOUSE UNTUK MENG-CLOSE (BLACKLIST) POHON ]]
Mouse.Button1Down:Connect(function()
    if not SelectionHighlightMode then return end
    local target = Mouse.Target
    if target and target:IsDescendantOf(workspace) then
        local topObj = getTopLevelTarget(target) or target
        if not isAPlayerCharacter(topObj) and not topObj:IsA("Terrain") and not topObj:IsA("Camera") then
            if not BlacklistObjects[topObj] then
                BlacklistObjects[topObj] = true
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
                highlight.Parent = topObj
                table.insert(HighlightVisuals, highlight)
            else
                BlacklistObjects[topObj] = nil
                for i, hl in ipairs(HighlightVisuals) do
                    if hl.Parent == topObj then
                        hl:Destroy()
                        table.remove(HighlightVisuals, i)
                        break
                    end
                end
            end
        end
    end
end)

-- TAHAP 1: AKTIFKAN SELEKSI POHON / BLACKLIST
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then CopyButton.Text = "Executor Tak Support!" return end
    if not SelectionHighlightMode then
        SelectionHighlightMode = true
        BlacklistObjects = {}
        HighlightVisuals = {}
        CopyButton.Text = "🔴 KLIK POHON DI MAP UTK CLOSE"
        CopyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ConfirmButton.Visible = true
    end
end)

-- TAHAP 2: PROSES EXPORT DATA KE JSON SETELAH KLIK SELESAI
ConfirmButton.MouseButton1Click:Connect(function()
    SelectionHighlightMode = false
    ConfirmButton.Visible = false
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
    
    for _, hl in pairs(HighlightVisuals) do pcall(function() hl:Destroy() end) end
    
    local SaveData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, service in pairs(ScanTargets) do
        local objectsToScan = {}
        pcall(function() objectsToScan = service:GetDescendants() end)
        
        for _, obj in pairs(objectsToScan) do
            -- Filter cek apakah objek ini masuk daftar pohon/folder yang di-blacklist oleh klik kursor mouse
            local isBlacklisted = false
            local currentCheck = obj
            while currentCheck and currentCheck ~= game do
                if BlacklistObjects[currentCheck] then
                    isBlacklisted = true
                    break
                end
                currentCheck = currentCheck.Parent
            end
            
            if not isBlacklisted and not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) and not obj:IsDescendantOf(PlayerGui) then
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
                
                -- Ekstraksi Properti Universal Dinamis (Bebas Jenis / All Inserts)
                pcall(function() data.Properties.TextureId = obj.TextureId end)
                pcall(function() data.Properties.Texture = obj.Texture end)
                pcall(function() data.Properties.Image = obj.Image end)
                pcall(function() data.Properties.Face = obj.Face.Name end)
                pcall(function() data.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255} end)
                pcall(function() data.Properties.Value = obj.Value end)
                pcall(function() data.Properties.AnimationId = obj.AnimationId end) -- Support Animasi
                
                if obj:IsA("Model") then
                    pcall(function() data.Properties.WorldPivot = {obj:GetPivot():GetComponents()} end)
                end
                
                if obj:IsA("BasePart") then
                    data.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                    data.Properties.CFrame = {obj.CFrame:GetComponents()}
                    data.Properties.Material = obj.Material.Name
                    data.Properties.Transparency = obj.Transparency
                    data.Properties.Anchored = obj.Anchored
                    data.Properties.CanCollide = obj.CanCollide
                    
                    if obj:IsA("MeshPart") then
                        pcall(function() data.Properties.MeshId = obj.MeshId end)
                        pcall(function() data.Properties.Size0 = {obj.Size.X, obj.Size.Y, obj.Size.Z} end)
                    elseif obj:IsA("UnionOperation") then
                        pcall(function() data.Properties.AssetId = obj.AssetId end)
                    end
                end
                
                table.insert(SaveData, data)
                if count % 300 == 0 then task.wait() end
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 COPIED: " .. count .. " OBJS"
    task.wait(2) CopyButton.Text = "COPYY OM"
    _G.UpdatePasteList()
end)

-- [[ TAHAP 3: PROSES RECONSTRUCTION / PASTE ]]
_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    if not listfiles then return end
    local files = listfiles("") local anyFile = false
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
            anyFile = true
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local FileSelectBtn = Instance.new("TextButton", ListScroll)
            FileSelectBtn.Size = UDim2.new(1, -6, 0, 26)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            FileSelectBtn.Text = " 📄 " .. cleanName
            FileSelectBtn.Font = Enum.Font.SourceSansSemibold
            FileSelectBtn.TextSize = 11
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", FileSelectBtn).CornerRadius = UDim.new(0, 4)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                
                local success, err = pcall(function()
                    local fileContent = readfile(file)
                    local loadedData = HttpService:JSONDecode(fileContent)
                    
                    -- Urutkan hirarki kedalaman struktur
                    table.sort(loadedData, function(a, b) return (a.Depth or 0) < (b.Depth or 0) end)
                    
                    local MasterFolder = workspace:FindFirstChild("Paste_" .. cleanName) or Instance.new("Folder", workspace)
                    MasterFolder.Name = "Paste_" .. cleanName
                    
                    local function findOrCreateParent(relativePath)
                        local currentParent = MasterFolder
                        for _, pathInfo in ipairs(relativePath) do
                            local found = currentParent:FindFirstChild(pathInfo.Name)
                            if not found then
                                pcall(function()
                                    found = Instance.new(pathInfo.ClassName == "DataModel" and "Folder" or pathInfo.ClassName)
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
                            
                            -- Logika Berlapis Rekonstruksi Geometri
                            if data.ClassName == "MeshPart" or (props.MeshId and props.MeshId ~= "") then
                                newObj = Instance.new("Part")
                                local specialMesh = Instance.new("SpecialMesh")
                                specialMesh.MeshType = Enum.MeshType.FileMesh
                                specialMesh.MeshId = props.MeshId or ""
                                specialMesh.TextureId = props.TextureId or ""
                                if props.Size0 and props.Size then specialMesh.Scale = Vector3.new(1, 1, 1) end
                                specialMesh.Parent = newObj
                            elseif data.ClassName == "UnionOperation" and (props.AssetId and props.AssetId ~= "") then
                                newObj = Instance.new("Part")
                                Instance.new("BlockMesh", newObj)
                            else
                                local creationSuccess, createdInstance = pcall(function() return Instance.new(data.ClassName) end)
                                newObj = creationSuccess and createdInstance or Instance.new("Folder")
                            end
                            
                            newObj.Name = data.Name
                            
                            -- Penempatan properti fisik & data non-part
                            if newObj:IsA("BasePart") and props.CFrame then
                                newObj.Size = Vector3.new(props.Size[1], props.Size[2], props.Size[3])
                                newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3])
                                pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                newObj.Transparency = props.Transparency
                                newObj.Anchored = props.Anchored
                                newObj.CanCollide = props.CanCollide
                            elseif newObj:IsA("Model") and props.WorldPivot then
                                pcall(function() newObj:PivotTo(CFrame.new(unpack(props.WorldPivot))) end)
                            else
                                pcall(function() newObj.TextureId = props.TextureId end)
                                pcall(function() newObj.Texture = props.Texture end)
                                pcall(function() newObj.Image = props.Image end)
                                pcall(function() newObj.Face = Enum.NormalId[props.Face] end)
                                pcall(function() newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3]) end)
                                pcall(function() newObj.Value = props.Value end)
                                pcall(function() newObj.AnimationId = props.AnimationId end)
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
