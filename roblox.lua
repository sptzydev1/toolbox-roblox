-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

-- Proteksi Instan PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer.PlayerGui

-- URL GITHUB RAW WHITELIST ANDA
local GITHUB_RAW_URL = "https://raw.githubusercontent.com/sptzydev1/premium-script/refs/heads/main/akses.txt"

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

local FILE_PREFIX = "GameCopy_"
local TargetFolder = workspace

-- ==================================================
-- [[ BARU: ANIMASI LOADING DI TENGAH LAYAR ]]
-- ==================================================
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "SpyzyyLoader"
LoadGui.ResetOnSpawn = false
LoadGui.Parent = PlayerGui

local LoadFrame = Instance.new("Frame")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(0, 220, 0, 130)
LoadFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadFrame.BorderSizePixel = 0
LoadFrame.Parent = LoadGui

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 10)
LoadCorner.Parent = LoadFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Thickness = 1.5
LoadStroke.Color = Color3.fromRGB(0, 200, 255)
LoadStroke.Parent = LoadFrame

local LoadIcon = Instance.new("TextLabel")
LoadIcon.Size = UDim2.new(0, 40, 0, 40)
LoadIcon.Position = UDim2.new(0.5, -20, 0, 15)
LoadIcon.BackgroundTransparency = 1
LoadIcon.Text = "⏳"
LoadIcon.TextSize = 25
LoadIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadIcon.Parent = LoadFrame

local LoadText = Instance.new("TextLabel")
LoadText.Size = UDim2.new(1, 0, 0, 25)
LoadText.Position = UDim2.new(0, 0, 0, 60)
LoadText.BackgroundTransparency = 1
LoadText.Text = "Connecting to Server..."
LoadText.Font = Enum.Font.SourceSansSemibold
LoadText.TextSize = 13
LoadText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadText.Parent = LoadFrame

-- TOMBOL REFRESH WHITELIST
local RefreshWLButton = Instance.new("TextButton")
RefreshWLButton.Size = UDim2.new(0, 180, 0, 25)
RefreshWLButton.Position = UDim2.new(0.5, -90, 0, 95)
RefreshWLButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
RefreshWLButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshWLButton.Text = "🔄 Check Whitelist Again"
RefreshWLButton.Font = Enum.Font.SourceSansBold
RefreshWLButton.TextSize = 12
RefreshWLButton.Visible = false
RefreshWLButton.Parent = LoadFrame

local RefreshWLCorner = Instance.new("UICorner")
RefreshWLCorner.CornerRadius = UDim.new(0, 5)
RefreshWLCorner.Parent = RefreshWLButton

local RefreshWLStroke = Instance.new("UIStroke")
RefreshWLStroke.Thickness = 1
RefreshWLStroke.Color = Color3.fromRGB(80, 80, 90)
RefreshWLStroke.Parent = RefreshWLButton

-- Loop Animasi Putar Icon & Teks Berkedip
local animasiAktif = true
task.spawn(function()
    local rotasi = 0
    while true do
        if animasiAktif then
            rotasi = (rotasi + 10) % 360
            LoadIcon.Rotation = rotasi
            LoadText.TextTransparency = 0.3
            task.wait(0.15)
            LoadIcon.Rotation = rotasi
            LoadText.TextTransparency = 0
            task.wait(0.15)
        else
            LoadIcon.Rotation = 0
            task.wait(0.5)
        end
    end
end)


-- [[ DEKLARASI GUI UTAMA MAP COPY ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -160)
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
Title.Text = "🚀 COPY MAP BY SPYZYY V2 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.Parent = MainFrame

local InfoPanel = Instance.new("Frame")
InfoPanel.Size = UDim2.new(0, 206, 0, 45)
InfoPanel.Position = UDim2.new(0, 12, 0, 40)
InfoPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
InfoPanel.BorderSizePixel = 0
InfoPanel.Parent = MainFrame

local InfoPanelCorner = Instance.new("UICorner")
InfoPanelCorner.CornerRadius = UDim.new(0, 6)
InfoPanelCorner.Parent = InfoPanel

local InfoPanelStroke = Instance.new("UIStroke")
InfoPanelStroke.Thickness = 1
InfoPanelStroke.Color = Color3.fromRGB(50, 50, 60)
InfoPanelStroke.Parent = InfoPanel

local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(1, -10, 0, 22)
UserLabel.Position = UDim2.new(0, 8, 0, 2)
UserLabel.BackgroundTransparency = 1
UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
UserLabel.Font = Enum.Font.SourceSansSemibold
UserLabel.TextSize = 12
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.Parent = InfoPanel

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1, -10, 0, 22)
TimeLabel.Position = UDim2.new(0, 8, 0, 20)
TimeLabel.BackgroundTransparency = 1
TimeLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.TextSize = 12
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = InfoPanel

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 35)
CopyButton.Position = UDim2.new(0, 12, 0, 95)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 135)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 12
ListLabel.Parent = MainFrame

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 206, 0, 115)
ListScroll.Position = UDim2.new(0, 12, 0, 155)
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
RefreshButton.Position = UDim2.new(0, 12, 0, 280)
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


-- [[ CORE ENGINE COPY/PASTE ]]
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

local AllowedSupportClasses = {
    ["Texture"] = true, ["Decal"] = true, ["SurfaceAppearance"] = true, 
    ["SpecialMesh"] = true, ["BlockMesh"] = true, ["CylinderMesh"] = true,
    ["ParticleEmitter"] = true, ["PointLight"] = true, ["SpotLight"] = true, ["SurfaceLight"] = true,
    ["Sky"] = true, ["Atmosphere"] = true, ["Clouds"] = true
}

CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end
    CopyButton.Text = "🔍 Scanning Map..."
    task.wait(0.1)

    local SaveData = {}
    local count = 0
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    local objectsToScan = TargetFolder:GetDescendants()
    
    for _, obj in pairs(objectsToScan) do
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") or AllowedSupportClasses[obj.ClassName] then
            if not obj:IsDescendantOf(Players) and not obj:IsA("Camera") and not obj:IsA("Terrain") and not isAPlayerCharacter(obj) then
                count = count + 1
                if count % 400 == 0 then 
                    CopyButton.Text = "📸 [" .. count .. "] Scanning..." 
                    task.wait() 
                end
                
                local relPath = getRelativePath(obj)
                local data = {
                    Name = obj.Name,
                    ClassName = obj.ClassName,
                    RelativePath = relPath,
                    Depth = #relPath,
                    Properties = {}
                }
                
                pcall(function()
                    if obj:IsA("BasePart") then
                        data.Properties.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                        data.Properties.CFrame = {obj.CFrame:GetComponents()}
                        data.Properties.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                        data.Properties.Material = obj.Material.Name
                        data.Properties.Transparency = obj.Transparency
                        data.Properties.Reflectance = obj.Reflectance
                        data.Properties.Anchored = obj.Anchored
                        data.Properties.CanCollide = obj.CanCollide
                        
                        if obj:IsA("MeshPart") then
                            data.Properties.MeshId = obj.MeshId
                            data.Properties.TextureId = obj.TextureId
                        elseif obj:IsA("UnionOperation") then
                            data.Properties.AssetId = obj.AssetId
                        end
                    elseif obj:IsA("Model") then
                        data.Properties.WorldPivot = {obj:GetPivot():GetComponents()}
                    elseif AllowedSupportClasses[obj.ClassName] then
                        pcall(function() data.Properties.Texture = obj.Texture end)
                        pcall(function() data.Properties.TextureId = obj.TextureId end)
                        pcall(function() data.Properties.MeshId = obj.MeshId end)
                        pcall(function() data.Properties.Color3 = {obj.Color3.r * 255, obj.Color3.g * 255, obj.Color3.b * 255} end)
                        pcall(function() data.Properties.Enabled = obj.Enabled end)
                    end
                    table.insert(SaveData, data)
                end)
            end
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 COPIED: " .. count .. " OBJS"
    task.wait(2)
    CopyButton.Text = "COPYY OM"
    _G.UpdatePasteList()
end)

_G.UpdatePasteList = function()
    for _, child in pairs(ListScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
    if not listfiles then return end
    
    local files = pcall(listfiles, "") and listfiles("") or {}
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
                    pcall(delfile, file)
                    ItemFrame:Destroy()
                    _G.UpdatePasteList()
                end
            end)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                task.spawn(function()
                    local success, err = pcall(function()
                        local fileContent = readfile(file)
                        local loadedData = HttpService:JSONDecode(fileContent)
                        table.sort(loadedData, function(a, b) return (a.Depth or 0) < (b.Depth or 0) end)
                        
                        local MasterFolder = workspace:FindFirstChild("Paste_" .. cleanName) or Instance.new("Folder")
                        MasterFolder.Name = "Paste_" .. cleanName
                        MasterFolder.Parent = workspace
                        
                        local function findOrCreateParent(relativePath)
                            local currentParent = MasterFolder
                            for _, pathInfo in ipairs(relativePath) do
                                local found = currentParent:FindFirstChild(pathInfo.Name)
                                if not found then
                                    if pathInfo.ClassName == "Folder" or pathInfo.ClassName == "Model" then
                                        found = Instance.new(pathInfo.ClassName)
                                    else
                                        found = Instance.new("Folder")
                                    end
                                    found.Name = pathInfo.Name
                                    found.Parent = currentParent
                                end
                                currentParent = found
                            end
                            return currentParent
                        end
                        
                        local pasteCount = 0
                        local totalObjs = #loadedData
                        
                        for _, data in ipairs(loadedData) do
                            pcall(function()
                                local targetParent = findOrCreateParent(data.RelativePath)
                                if targetParent:FindFirstChild(data.Name) and (data.ClassName == "Folder" or data.ClassName == "Model") then return end
                                
                                pasteCount = pasteCount + 1
                                if pasteCount % 350 == 0 then
                                    FileSelectBtn.Text = "🔨 [" .. pasteCount .. "/" .. totalObjs .. "] Pasting..."
                                    task.wait()
                                end
                                
                                local newObj
                                local props = data.Properties or {}
                                if AllowedSupportClasses[data.ClassName] then
                                    newObj = Instance.new(data.ClassName)
                                    pcall(function() if props.Texture then newObj.Texture = props.Texture end end)
                                    pcall(function() if props.TextureId then newObj.TextureId = props.TextureId end end)
                                    pcall(function() if props.Enabled ~= nil then newObj.Enabled = props.Enabled end end)
                                elseif data.ClassName == "Folder" or data.ClassName == "Model" or data.ClassName == "Part" then
                                    newObj = Instance.new(data.ClassName)
                                else
                                    newObj = Instance.new("Part")
                                end
                                
                                newObj.Name = data.Name
                                if newObj:IsA("BasePart") and props.CFrame then
                                    newObj.Size = Vector3.new(unpack(props.Size))
                                    newObj.CFrame = CFrame.new(unpack(props.CFrame))
                                    newObj.Color = Color3.fromRGB(unpack(props.Color))
                                    pcall(function() newObj.Material = Enum.Material[props.Material] end)
                                    newObj.Transparency = props.Transparency
                                    newObj.Anchored = props.Anchored
                                    newObj.CanCollide = props.CanCollide
                                end
                                newObj.Parent = targetParent
                            end)
                        end
                    end)
                    
                    if success then
                        FileSelectBtn.Text = " ✅ PASTE SUCCESSFUL!"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                    else
                        FileSelectBtn.Text = " ❌ ERROR OCCURRED!"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    end
                    task.wait(1.5)
                    FileSelectBtn.Text = " 📄 " .. cleanName
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                end)
            end)
        end
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(_G.UpdatePasteList)

-- ====================================================================
-- [[ BARU: SISTEM VERIFIKASI PREMIUM BERBASIS JAM REAL-TIME GLOBAL ]]
-- ====================================================================
local function parsingTanggalKeTimestamp(strTanggal)
    -- Format yang diterima: DD-MM-YYYY_HH:MM:SS
    local hari, bulan, tahun, jam, menit, detik = string.match(strTanggal, "(%d+)-(%d+)-(%d+)_(%d+):(%d+):(%d+)")
    if hari and bulan and tahun and jam and menit and detik then
        return os.time({
            day = tonumber(hari),
            month = tonumber(bulan),
            year = tonumber(tahun),
            hour = tonumber(jam),
            min = tonumber(menit),
            sec = tonumber(detik)
        })
    end
    return nil
end

local function formatWaktu(totalDetik)
    if totalDetik <= 0 then return "EXPIRED" end
    local hari = math.floor(totalDetik / 86400)
    local sisa = totalDetik % 86400
    local jam = math.floor(sisa / 3600)
    sisa = sisa % 3600
    local menit = math.floor(sisa / 60)
    local detik = sisa % 60
    if hari > 0 then
        return string.format("%dd %02dh %02dm %02ds", hari, jam, menit, detik)
    else
        return string.format("%02dh %02dm %02ds", jam, menit, detik)
    end
end

local function PeriksaWhitelist()
    animasiAktif = true
    RefreshWLButton.Visible = false
    LoadIcon.Text = "⏳"
    LoadText.Text = "Checking Global License..."
    LoadStroke.Color = Color3.fromRGB(0, 200, 255)
    LoadText.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    local usernameSekarang = string.lower(LocalPlayer.Name)
    local sukses, isiFile = false, nil
    local bypassUrl = GITHUB_RAW_URL .. "?nocache=" .. math.random(1, 999999)
    
    for i = 1, 4 do
        sukses, isiFile = pcall(function() return game:HttpGet(bypassUrl) end)
        if sukses and isiFile and #isiFile > 3 then break end
        task.wait(0.5)
    end
    
    if not sukses or not isiFile or #isiFile < 3 then
        animasiAktif = false
        LoadIcon.Text = "❌"
        LoadStroke.Color = Color3.fromRGB(255, 50, 50)
        LoadText.TextColor3 = Color3.fromRGB(255, 100, 100)
        LoadText.Text = "Connection Failed!"
        RefreshWLButton.Visible = true
        return
    end
    
    local terdaftar = false
    local targetTimestamp = nil
    
    for baris in string.gmatch(isiFile, "[^\r\n]+") do
        local dataBersih = baris:gsub(",", " ")
        local user, formatWaktuStr = string.match(dataBersih, "%s*(%S+)%s+(%S+)%s*")
        
        if user and formatWaktuStr then
            if string.lower(user) == usernameSekarang then
                terdaftar = true
                targetTimestamp = parsingTanggalKeTimestamp(formatWaktuStr)
                break
            end
        end
    end
    
    if not terdaftar then
        animasiAktif = false
        LoadIcon.Text = "⛔"
        LoadStroke.Color = Color3.fromRGB(255, 50, 50)
        LoadText.TextColor3 = Color3.fromRGB(255, 100, 100)
        LoadText.Text = "Not Whitelisted! Contact: @sptzyy"
        RefreshWLButton.Visible = true
        return
    elseif not targetTimestamp then
        animasiAktif = false
        LoadIcon.Text = "⚙️"
        LoadStroke.Color = Color3.fromRGB(255, 150, 0)
        LoadText.Text = "GitHub Time Format Error!"
        RefreshWLButton.Visible = true
        return
    end

    -- Hitung sisa waktu berdasarkan Waktu Real-Time Saat Ini
    local waktuSekarang = os.time()
    local sisaDurasi = targetTimestamp - waktuSekarang
    
    if sisaDurasi <= 0 then
        animasiAktif = false
        LoadIcon.Text = "⏰"
        LoadStroke.Color = Color3.fromRGB(255, 50, 50)
        LoadText.TextColor3 = Color3.fromRGB(255, 100, 100)
        LoadText.Text = "License Expired! (Real-Time Block)"
        RefreshWLButton.Visible = true -- Tombol ini ditekan pun akan tetap ke-block karena jam dunia nyata terus berjalan
        return
    end

    -- Jika Lolos Verifikasi
    animasiAktif = false
    LoadIcon.Text = "✅"
    LoadStroke.Color = Color3.fromRGB(0, 255, 150)
    LoadText.TextColor3 = Color3.fromRGB(0, 255, 150)
    LoadText.Text = "Access Granted!"
    task.wait(0.8)
    
    LoadGui:Destroy()
    UserLabel.Text = "👤 User: " .. LocalPlayer.Name
    ScreenGui.Enabled = true
    _G.UpdatePasteList()
    
    -- Hitung mundur live sisa waktu bermain
    task.spawn(function()
        while true do
            local liveWaktuSekarang = os.time()
            local liveSisa = targetTimestamp - liveWaktuSekarang
            
            if liveSisa <= 0 then break end
            
            TimeLabel.Text = "⏳ Sisa Waktu: " .. formatWaktu(liveSisa)
            task.wait(1)
        end
        
        -- KETIKA JAM DUNIA NYATA MELEWATI TARGET EXPIRATION
        ScreenGui.Enabled = false
        TimeLabel.Text = "⏳ Sisa Waktu: EXPIRED"
        LocalPlayer:Kick("Masa lisensi premium Anda telah berakhir!")
    end)
end

RefreshWLButton.MouseButton1Click:Connect(PeriksaWhitelist)
task.spawn(PeriksaWhitelist)
