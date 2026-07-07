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

-- [[ DAFTAR SERVICE YANG BISA DICOPY CLIENT (ALA DEX) ]]
local TargetServices = {
    game:GetService("Workspace"),
    game:GetService("ReplicatedStorage"),
    game:GetService("Lighting"),
    game:GetService("StarterGui"),
    game:GetService("StarterPlayer"),
    game:GetService("MaterialService")
}

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 DEX MULTI-COPY V2 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 45)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPY ALL SERVICES"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

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

-- [[ LOGIKA CORE ANTI-LIMIT / LOGIKA ALUR DEX ]]

local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    -- Mengubah limit pencarian root agar melacak sampai ke level Game Service (Dex Style)
    while current and current ~= game then
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
    ["Sky"] = true, ["Atmosphere"] = true, ["Clouds"] = true,
    ["Script"] = true, ["LocalScript"] = true, ["ModuleScript"] = true,
    ["ScreenGui"] = true, ["Frame"] = true, ["TextLabel"] = true, ["TextButton"] = true, ["ImageLabel"] = true, ["ImageButton"] = true, ["TextBox"] = true, ["UIListLayout"] = true, ["UICorner"] = true, ["UIGridLayout"] = true, ["UIStroke"] = true
}

local function getScriptSourceSafe(scriptObj)
    if decompile then
        local success, res = pcall(function() return decompile(scriptObj) end)
        if success and res and res ~= "" then return res end
    end
    if getscriptsource then
        local success, res = pcall(function() return getscriptsource(scriptObj) end)
        if success and res and res ~= "" then return res end
    end
    local success, res = pcall(function() return scriptObj.Source end)
    if success and res and res ~= "" then return res end
    return "-- [Gagal Mendekompresi Kode Script]"
end

-- 1. PROSES COPY MULTI-SERVICE
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    -- Memindai seluruh target service yang didaftarkan (Dex Explorer Logic)
    for _, service in ipairs(TargetServices) do
        local objectsToScan = service:GetDescendants()
        
        -- Daftarkan service induk itu sendiri agar jalurnya valid
        count = count + 1
        table.insert(SaveData, {
            Name = service.Name,
            ClassName = service.ClassName,
            RelativePath = {},
            Depth = 0,
            Properties = {}
        })

        for _, obj in pairs(objectsToScan) do
            if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") or AllowedSupportClasses[obj.ClassName] then
                -- Menghindari GUI buatan kita sendiri agar tidak ikut tercopy
                if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) and obj.Name ~= "SpyzyyCopyGuiV2" then
                    count = count + 1
                    CopyButton.Text = "🔍 [" .. count .. "] " .. string.sub(obj.Name, 1, 10)
                    
                    local relPath = getRelativePath(obj)
                    local data = {
                        Name = obj.Name,
                        ClassName = obj.ClassName,
                        RelativePath = relPath,
                        Depth = #relPath,
                        Properties = {}
                    }
                    
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
                        
                        if obj:IsA("MeshPart") then
                            pcall(function() data.Properties.MeshId = obj.MeshId end)
                            pcall(function() data.Properties.TextureId = obj.TextureId end)
                        elseif obj:IsA("UnionOperation") then
                            pcall(function() data.Properties.AssetId = obj.AssetId end)
                        end
                    
                    elseif obj:IsA("Model") then
                        pcall(function() data.Properties.WorldPivot = {obj:GetPivot():GetComponents()} end)
                        
                    elseif obj:IsA("GuiObject") or obj:IsA("LayerCollector") then
                        -- Menyimpan data UI dasar jika ada di StarterGui
                        pcall(function() data.Properties.Size = {obj.Size.X.Scale, obj.Size.X.Offset, obj.Size.Y.Scale, obj.Size.Y.Offset} end)
                        pcall(function() data.Properties.Position = {obj.Position.X.Scale, obj.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset} end)
                        pcall(function() data.Properties.BackgroundColor3 = {obj.BackgroundColor3.r * 255, obj.BackgroundColor3.g * 255, obj.BackgroundColor3.b * 255} end)
                        pcall(function() data.Properties.Visible = obj.Visible end)
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                            pcall(function() data.Properties.Text = obj.Text end)
                            pcall(function() data.Properties.TextSize = obj.TextSize end)
                        end
                    end
                    
                    table.insert(SaveData, data)
                    if count % 300 == 0 then task.wait() end
                end
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 SAVED: " .. count .. " OBJS"
    task.wait(2)
    CopyButton.Text = "COPY ALL SERVICES"
    _G.UpdatePasteList()
end)

-- 2. PROSES REFRESH DAN PASTE BERURUTAN (MENATA KE MASING-MASING SERVICE UTAMA)
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
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
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
            DeleteBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            DeleteBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
            DeleteBtn.Text = "❌"
            DeleteBtn.Font = Enum.Font.SourceSansBold
            DeleteBtn.TextSize = 10
            DeleteBtn.Parent = ItemFrame

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
                    
                    -- Kontainer utama di Workspace agar folder berstruktur rapi saat diekspor kembali ke Studio
                    local MasterFolder = workspace:FindFirstChild("DexPaste_" .. cleanName)
                    if not MasterFolder then
                        MasterFolder = Instance.new("Folder")
                        MasterFolder.Name = "DexPaste_" .. cleanName
                        MasterFolder.Parent = workspace
                    end
                    
                    -- Rekonstruksi struktur jalur data (Dex Logic Alur)
                    local function findOrCreateParent(relativePath)
                        local currentParent = MasterFolder
                        for _, pathInfo in ipairs(relativePath) do
                            local found = currentParent:FindFirstChild(pathInfo.Name)
                            if not found then
                                pcall(function()
                                    found = Instance.new("Folder")
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
                            if data.Depth == 0 then return end -- Abaikan pembuat root service asli data
                            
                            local targetParent = findOrCreateParent(data.RelativePath)
                            pasteCount = pasteCount + 1
                            FileSelectBtn.Text = "🔨 [" .. pasteCount .. "/" .. totalObjs .. "] " .. string.sub(data.Name, 1, 10)
                            
                            local newObj
                            local props = data.Properties or {}
                            
                            if data.ClassName == "Script" or data.ClassName == "LocalScript" or data.ClassName == "ModuleScript" then
                                newObj = Instance.new(data.ClassName)
                                pcall(function() if props.Source then newObj.Source = props.Source end end)
                            elseif AllowedSupportClasses[data.ClassName] then
                                newObj = Instance.new(data.ClassName)
                                -- Penataan UI khusus jika merupakan GUI item
                                pcall(function()
                                    if props.Size and newObj:IsA("GuiObject") then newObj.Size = UDim2.new(unpack(props.Size)) end
                                    if props.Position and newObj:IsA("GuiObject") then newObj.Position = UDim2.new(unpack(props.Position)) end
                                    if props.Text then newObj.Text = props.Text end
                                end)
                            elseif data.ClassName == "MeshPart" or (props.MeshId and props.MeshId ~= "") then
                                newObj = Instance.new("Part")
                                local specialMesh = Instance.new("SpecialMesh")
                                specialMesh.MeshType = Enum.MeshType.FileMesh
                                specialMesh.MeshId = props.MeshId or ""
                                specialMesh.TextureId = props.TextureId or ""
                                specialMesh.Parent = newObj
                            else
                                newObj = Instance.new(data.ClassName)
                            end
                            
                            newObj.Name = data.Name
                            
                            if newObj:IsA("BasePart") and props.CFrame then
                                newObj.Size = Vector3.new(props.Size[1], props.Size[2], props.Size[3])
                                newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                newObj.Color = Color3.fromRGB(props.Color[1], props.Color[2], props.Color[3])
                                pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                newObj.Transparency = props.Transparency
                                newObj.Anchored = props.Anchored
                                newObj.CanCollide = props.CanCollide
                            end
                            
                            newObj.Parent = targetParent
                            if pasteCount % 250 == 0 then task.wait() end
                        end)
                    end
                end)
                
                if success then
                    FileSelectBtn.Text = " ✅ SUCCESS!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                else
                    FileSelectBtn.Text = " ❌ ERROR!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                end
                task.wait(2)
                FileSelectBtn.Text = " 📁 " .. cleanName
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            end)
        end
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(function() _G.UpdatePasteList() end)
_G.UpdatePasteList()
