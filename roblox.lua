-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserService = game:GetService("UserService")
local TweenService = game:GetService("TweenService") 
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

local FILE_PREFIX = "GameCopy_"
local TargetFolder = workspace
local SaveMode = "JSON" -- "JSON" untuk Mobile, "RBXM" untuk PC

-- [[ DEKLARASI GUI UTAMA MAP COPY ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = PlayerGui

-- MAIN FRAME (Fitur Utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 400)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false -- Disembunyikan dulu sampai intro selesai
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
Title.Text = "🚀 COPY MAP BY SPYZYY V5 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame


-- [[ 🎬 SEGMEN ANIMASI INTRO MODERN 🎬 ]]
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0, 230, 0, 400)
IntroFrame.Position = UDim2.new(0.5, -115, 0.5, -200)
IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = ScreenGui

local IntroCorner = Instance.new("UICorner")
IntroCorner.CornerRadius = UDim.new(0, 12)
IntroCorner.Parent = IntroFrame

local IntroStroke = Instance.new("UIStroke")
IntroStroke.Thickness = 2
IntroStroke.Color = Color3.fromRGB(0, 200, 255)
IntroStroke.Parent = IntroFrame

local IntroLogo = Instance.new("ImageLabel")
IntroLogo.Name = "IntroLogo"
IntroLogo.Size = UDim2.new(0, 70, 0, 70)
IntroLogo.Position = UDim2.new(0.5, -35, 0.4, -35)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Image = "rbxassetid://3570695787" 
IntroLogo.ImageColor3 = Color3.fromRGB(0, 200, 255)
IntroLogo.ImageTransparency = 1 
IntroLogo.Parent = IntroFrame

local IntroText = Instance.new("TextLabel")
IntroText.Name = "IntroText"
IntroText.Size = UDim2.new(1, 0, 0, 30)
IntroText.Position = UDim2.new(0, 0, 0.4, 45)
IntroText.BackgroundTransparency = 1
IntroText.Text = "SPYZYY SYSTEM"
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.Font = Enum.Font.GothamBold
IntroText.TextSize = 16
IntroText.TextTransparency = 1 
IntroText.Parent = IntroFrame


-- [[ PANEL PROFILE USER ]]
local InfoPanel = Instance.new("Frame")
InfoPanel.Size = UDim2.new(0, 206, 0, 85)
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
        local accountAge = LocalPlayer.AccountAge
        AgeLabel.Text = "📅 Umur Akun: " .. accountAge .. " Hari"
        
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

-- [[ ELEMENT PASTE LIST ]]
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -24, 0, 20)
ListLabel.Position = UDim2.new(0, 12, 0, 200)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "File MOBILE Terdeteksi:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSansSemibold
ListLabel.TextSize = 11
ListLabel.Parent = MainFrame

-- [[ TOMBOL PILIH JENIS (MOBILE / PC) ]]
local FormatButton = Instance.new("TextButton")
FormatButton.Size = UDim2.new(0, 206, 0, 25)
FormatButton.Position = UDim2.new(0, 12, 0, 132)
FormatButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FormatButton.TextColor3 = Color3.fromRGB(255, 200, 0)
FormatButton.Text = "📱 JENIS: MOBILE"
FormatButton.Font = Enum.Font.SourceSansBold
FormatButton.TextSize = 12
FormatButton.Parent = MainFrame

local FormatCorner = Instance.new("UICorner")
FormatCorner.CornerRadius = UDim.new(0, 6)
FormatCorner.Parent = FormatButton

FormatButton.MouseButton1Click:Connect(function()
    if SaveMode == "JSON" then
        SaveMode = "RBXM"
        FormatButton.Text = "💻 JENIS: PC"
        FormatButton.TextColor3 = Color3.fromRGB(0, 200, 255)
        ListLabel.Text = "File PC Tidak Bisa Di-paste di Sini!"
    else
        SaveMode = "JSON"
        FormatButton.Text = "📱 JENIS: MOBILE"
        FormatButton.TextColor3 = Color3.fromRGB(255, 200, 0)
        ListLabel.Text = "File MOBILE Terdeteksi:"
    end
end)

-- [[ TOMBOL UTAMA COPY MAP ]]
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 206, 0, 32)
CopyButton.Position = UDim2.new(0, 12, 0, 163)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "COPYY OM"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 13
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 6)
CopyButtonCorner.Parent = CopyButton

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 206, 0, 135)
ListScroll.Position = UDim2.new(0, 12, 0, 220)
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
RefreshButton.Position = UDim2.new(0, 12, 0, 363)
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

-- [[ JALANKAN PROSES ANIMASI INTRO ]]
task.spawn(function()
    local fadeInInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(IntroLogo, fadeInInfo, {ImageTransparency = 0}):Play()
    TweenService:Create(IntroText, fadeInInfo, {TextTransparency = 0}):Play()
    
    local rotateInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local logoRotation = TweenService:Create(IntroLogo, rotateInfo, {Rotation = 360})
    logoRotation:Play()
    
    task.wait(2.5) 
    
    local fadeOutInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(IntroLogo, fadeOutInfo, {ImageTransparency = 1}):Play()
    TweenService:Create(IntroText, fadeOutInfo, {TextTransparency = 1}):Play()
    local frameFade = TweenService:Create(IntroFrame, fadeOutInfo, {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)})
    TweenService:Create(IntroStroke, fadeOutInfo, {Transparency = 1}):Play()
    
    frameFade:Play()
    frameFade.Completed:Connect(function()
        logoRotation:Cancel() 
        IntroFrame:Destroy()   
        
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 230, 0, 400),
            Position = UDim2.new(0.5, -115, 0.5, -200)
        }):Play()
    end)
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
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    
    if SaveMode == "RBXM" then
        if not saveinstance then
            CopyButton.Text = "Executor Tak Support PC Mode!"
            return
        end
        CopyButton.Text = "📦 Saving PC File (.rbxm)..."
        task.wait(0.1)
        
        local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".rbxm"
        local success, err = pcall(function()
            saveinstance({object = workspace, mode = "optimized", noscripts = true, filepath = fileName})
        end)
        
        if success then
            CopyButton.Text = "✅ PC FILE SAVED!"
        else
            local backupSuccess = pcall(function() saveinstance(workspace) end)
            if backupSuccess then
                CopyButton.Text = "✅ Check Folder Workspace"
            else
                CopyButton.Text = "❌ PC Mode Gagal!"
            end
        end
        task.wait(2)
        CopyButton.Text = "COPYY OM"
        return
    end

    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end
    CopyButton.Text = "🔍 Scanning Map..."
    task.wait(0.1)

    local SaveData = {}
    local count = 0
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
    
    for _, file in pairs(files) do
        if file:match(FILE_PREFIX) and file:match("%.json$") then
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
_G.UpdatePasteList()
