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
local TargetFolder = workspace

-- [[ CREATING GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV3_Updated"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 290)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -145)
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

-- [[ PANELS MANAGEMENT (PAGES) ]]
local SelectionPage = Instance.new("Frame", MainFrame)
SelectionPage.Size = UDim2.new(1, 0, 1, -40)
SelectionPage.Position = UDim2.new(0, 0, 0, 40)
SelectionPage.BackgroundTransparency = 1

local ActionPage = Instance.new("Frame", MainFrame)
ActionPage.Size = UDim2.new(1, 0, 1, -40)
ActionPage.Position = UDim2.new(0, 0, 0, 40)
ActionPage.BackgroundTransparency = 1
ActionPage.Visible = false

local function showPage(page)
    SelectionPage.Visible = (page == SelectionPage)
    ActionPage.Visible = (page == ActionPage)
end

-- [[ PAGE 1: MENU UTAMA / PILIH JENIS COPY ]]
local Opt1Button = Instance.new("TextButton", SelectionPage)
Opt1Button.Size = UDim2.new(0, 210, 0, 45)
Opt1Button.Position = UDim2.new(0, 15, 0, 20)
Opt1Button.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
Opt1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Opt1Button.Text = "🌐 COPY SATU MAP (Workspace)"
Opt1Button.Font = Enum.Font.SourceSansBold
Opt1Button.TextSize = 13
Instance.new("UICorner", Opt1Button).CornerRadius = UDim.new(0, 6)

local Opt2Button = Instance.new("TextButton", SelectionPage)
Opt2Button.Size = UDim2.new(0, 210, 0, 45)
Opt2Button.Position = UDim2.new(0, 15, 0, 80)
Opt2Button.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
Opt2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Opt2Button.Text = "🖱️ COPY PILIH PAKAI MOUSE"
Opt2Button.Font = Enum.Font.SourceSansBold
Opt2Button.TextSize = 13
Instance.new("UICorner", Opt2Button).CornerRadius = UDim.new(0, 6)

-- [[ PAGE 2: KONTROL UTAMA & LIST FILE ]]
local BackButton = Instance.new("TextButton", ActionPage)
BackButton.Size = UDim2.new(0, 40, 0, 20)
BackButton.Position = UDim2.new(0, 12, 0, 0)
BackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BackButton.Text = "◀ KEMBALI"
BackButton.Font = Enum.Font.SourceSansBold
BackButton.TextSize = 10
Instance.new("UICorner", BackButton).CornerRadius = UDim.new(0, 4)

local CopyButton = Instance.new("TextButton", ActionPage)
CopyButton.Size = UDim2.new(0, 216, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 25)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "START PROCESS"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 6)

local ListLabel = Instance.new("TextLabel", ActionPage)
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 65)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 12
ListLabel.TextXAlignment = Enum.TextXAlignment.Left

local ListScroll = Instance.new("ScrollingFrame", ActionPage)
ListScroll.Size = UDim2.new(0, 216, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 85)
ListScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 4
Instance.new("UICorner", ListScroll).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", ListScroll)
ListLayout.Padding = UDim.new(0, 4)

local RefreshButton = Instance.new("TextButton", ActionPage)
RefreshButton.Size = UDim2.new(0, 216, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 210)
RefreshButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh List File"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
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

-- [[ FUNGSI UTAMA EKSTRAKSI & PACKING DATA ]]
local selectedMode = 1 -- 1: Full Workspace, 2: Mouse Click Object

BackButton.MouseButton1Click:Connect(function()
    showPage(SelectionPage)
end)

Opt1Button.MouseButton1Click:Connect(function()
    selectedMode = 1
    CopyButton.Text = "💥 COPY SEMUA WORKSPACE 💥"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
    showPage(ActionPage)
end)

Opt2Button.MouseButton1Click:Connect(function()
    selectedMode = 2
    CopyButton.Text = "🎯 KLIK UTK AKTIFKAN MOUSE SELECT"
    CopyButton.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
    showPage(ActionPage)
end)

local function getRelativePath(obj, baseFolder)
    local path = {}
    local current = obj.Parent
    local limit = baseFolder or workspace
    while current and current ~= limit and current ~= game do
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

-- Logika Perekaman Objek Khusus Berlapis + Script / LocalScript
local function serializeObject(obj, baseFolder)
    local relPath = getRelativePath(obj, baseFolder)
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
    
    -- Perekaman Source Code khusus Script/LocalScript/ModuleScript
    if obj:IsA("LuaSourceContainer") then
        pcall(function() data.Properties.Source = obj.Source end)
    end

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
    return data
end

-- Eksekusi Utama Copy Script
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then CopyButton.Text = "Executor Tak Support!" return end
    
    local SaveData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    
    if selectedMode == 1 then
        -- MODE 1: COPY FULL MAP
        local fileName = FILE_PREFIX .. GameName .. "_Full_" .. uniqueID .. ".json"
        for _, obj in pairs(TargetFolder:GetDescendants()) do
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) then
                count = count + 1
                CopyButton.Text = "📸 [" .. count .. "] " .. string.sub(obj.Name, 1, 12)
                table.insert(SaveData, serializeObject(obj, workspace))
                if count % 250 == 0 then task.wait() end
            end
        end
        writefile(fileName, HttpService:JSONEncode(SaveData))
        CopyButton.Text = "💾 COPIED: " .. count .. " OBJS"
        task.wait(2) CopyButton.Text = "💥 COPY SEMUA WORKSPACE 💥"
        _G.UpdatePasteList()
        
    elseif selectedMode == 2 then
        -- MODE 2: MOUSE CLICK SELECTION WITH DEEP LAYERS & SCRIPT SUPPORT
        CopyButton.Text = "🎯 Silahkan Klik Objek Di Map..."
        local connection
        connection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
                local target = Mouse.Target
                if target then
                    -- Cari root model atau tools paling atas sebelum player character
                    local targetRoot = target
                    while targetRoot.Parent and targetRoot.Parent ~= workspace and not isAPlayerCharacter(targetRoot) do
                        targetRoot = targetRoot.Parent
                    end
                    
                    if isAPlayerCharacter(targetRoot) then
                        CopyButton.Text = "❌ Gak bisa copy Player!"
                        task.wait(1.5) CopyButton.Text = "🎯 KLIK UTK AKTIFKAN MOUSE SELECT"
                        return
                    end
                    
                    local fileName = FILE_PREFIX .. GameName .. "_Target_" .. targetRoot.Name .. "_" .. uniqueID .. ".json"
                    
                    -- Simpan root utamanya dulu
                    count = count + 1
                    table.insert(SaveData, serializeObject(targetRoot, targetRoot.Parent))
                    
                    -- Masuk ke struktur berlapis paling dalam (Semua Anak, Script, LocalScript, Tools)
                    for _, obj in pairs(targetRoot:GetDescendants()) do
                        count = count + 1
                        CopyButton.Text = "🚀 [" .. count .. "] " .. string.sub(obj.Name, 1, 12)
                        table.insert(SaveData, serializeObject(obj, targetRoot.Parent))
                        if count % 100 == 0 then task.wait() end
                    end
                    
                    writefile(fileName, HttpService:JSONEncode(SaveData))
                    CopyButton.Text = "💾 SAVED TARGET: " .. count .. " OBJS"
                    task.wait(2) CopyButton.Text = "🎯 KLIK UTK AKTIFKAN MOUSE SELECT"
                    _G.UpdatePasteList()
                else
                    CopyButton.Text = "❌ Target Kosong!"
                    task.wait(1.5) CopyButton.Text = "🎯 KLIK UTK AKTIFKAN MOUSE SELECT"
                end
            end
        end)
    end
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
                            
                            -- REKONSTRUKSI MESH / UNION / SCRIPT / REGULER
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
                                local blockMesh = Instance.new("BlockMesh")
                                blockMesh.Parent = newObj
                            else
                                -- Support dynamic instance creation termasuk Script/LocalScript
                                newObj = Instance.new(data.ClassName)
                            end
                            
                            newObj.Name = data.Name
                            
                            -- Restore Source Code jika tipenya script
                            if newObj:IsA("LuaSourceContainer") and props.Source then
                                pcall(function() newObj.Source = props.Source end)
                            end
                            
                            -- Restore Properti Fisik
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
