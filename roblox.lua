-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserService = game:GetService("UserService")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer.PlayerGui

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

-- [[ DEKLARASI GUI UTAMA - MODERN DARK EDITION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyCopyGuiV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 420) -- Diperlebar dan tinggi yang pas untuk kenyamanan mata
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 20) -- Rich Dark Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(35, 38, 47) -- Subtle Border, tidak terlalu terang agar elegan
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Main Layout Engine (Agar semua elemen otomatis menyusun ke bawah dengan rapi)
local MainLayout = Instance.new("UIListLayout")
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 12)
MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainLayout.Parent = MainFrame

local MainPadding = Instance.new("UIPadding")
MainPadding.PaddingTop = UDim.new(0, 14)
MainPadding.PaddingBottom = UDim.new(0, 14)
MainPadding.PaddingLeft = UDim.new(0, 14)
MainPadding.PaddingRight = UDim.new(0, 14)
MainPadding.Parent = MainFrame

-- [[ HEADER TITLE ]]
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "MAP COPIER V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left -- Align kiri terlihat lebih profesional
Title.LayoutOrder = 1
Title.Parent = MainFrame

local TitleGlow = Instance.new("TextLabel")
TitleGlow.Size = UDim2.new(1, 0, 0, 12)
TitleGlow.BackgroundTransparency = 1
TitleGlow.Text = "BY SPYZYY • PREMIUM"
TitleGlow.TextColor3 = Color3.fromRGB(0, 162, 255) -- Aksen Cyan Modern
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.TextSize = 9
TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
TitleGlow.LayoutOrder = 2
TitleGlow.Parent = MainFrame

-- [[ PANEL PROFILE USER ]]
local InfoPanel = Instance.new("Frame")
InfoPanel.Name = "InfoPanel"
InfoPanel.Size = UDim2.new(1, 0, 0, 90)
InfoPanel.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
InfoPanel.BorderSizePixel = 0
InfoPanel.LayoutOrder = 3
InfoPanel.Parent = MainFrame

local InfoPanelCorner = Instance.new("UICorner")
InfoPanelCorner.CornerRadius = UDim.new(0, 8)
InfoPanelCorner.Parent = InfoPanel

local InfoPanelPadding = Instance.new("UIPadding")
InfoPanelPadding.PaddingLeft = UDim.new(0, 10)
InfoPanelPadding.PaddingRight = UDim.new(0, 10)
InfoPanelPadding.PaddingTop = UDim.new(0, 8)
InfoPanelPadding.PaddingBottom = UDim.new(0, 8)
InfoPanelPadding.Parent = InfoPanel

local UserLayout = Instance.new("UIListLayout")
UserLayout.Padding = UDim.new(0, 4)
UserLayout.SortOrder = Enum.SortOrder.LayoutOrder
UserLayout.Parent = InfoPanel

local function CreateProfileLabel(text, color, order)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.LayoutOrder = order
    label.Parent = InfoPanel
    return label
end

local NameLabel = CreateProfileLabel("👤 Name: Loading...", Color3.fromRGB(255, 255, 255), 1)
local UsernameLabel = CreateProfileLabel("🆔 User: @" .. LocalPlayer.Name, Color3.fromRGB(150, 155, 170), 2)
local AgeLabel = CreateProfileLabel("📅 Age: Dihitung...", Color3.fromRGB(0, 162, 255), 3)
local BioLabel = CreateProfileLabel("📝 Bio: Loading...", Color3.fromRGB(130, 135, 145), 4)

task.spawn(function()
    pcall(function()
        NameLabel.Text = "👤 Name: " .. LocalPlayer.DisplayName
        local accountAge = LocalPlayer.AccountAge
        AgeLabel.Text = "📅 Age: " .. accountAge .. " Days"
        
        local playerInfo = UserService:GetUserInfosByUserIdsAsync({LocalPlayer.UserId})
        if playerInfo and playerInfo[1] and playerInfo[1].Description ~= "" then
            local bio = playerInfo[1].Description
            if #bio > 26 then bio = string.sub(bio, 1, 24) .. ".." end
            BioLabel.Text = "📝 Bio: " .. bio
        else
            BioLabel.Text = "📝 Bio: (Empty)"
        end
    end)
end)

-- [[ TOMBOL ACTION UTAMA ]]
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Size = UDim2.new(1, 0, 0, 38)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "START COPY MAP"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 12
CopyButton.LayoutOrder = 4
CopyButton.Parent = MainFrame

local CopyButtonCorner = Instance.new("UICorner")
CopyButtonCorner.CornerRadius = UDim.new(0, 8)
CopyButtonCorner.Parent = CopyButton

-- Efek Hover Sederhana untuk Tombol Copy
CopyButton.MouseEnter:Connect(function() CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) end)
CopyButton.MouseLeave:Connect(function() CopyButton.BackgroundColor3 = Color3.fromRGB(0, 132, 255) end)

-- Sub-title untuk list file
local ListLabel = Instance.new("TextLabel")
ListLabel.Name = "ListLabel"
ListLabel.Size = UDim2.new(1, 0, 0, 14)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "SAVED FILES TO PASTE:"
ListLabel.TextColor3 = Color3.fromRGB(100, 105, 120)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.GothamBold
ListLabel.TextSize = 10
ListLabel.LayoutOrder = 5
ListLabel.Parent = MainFrame

-- [[ SCROLLING LIST ]]
local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Name = "ListScroll"
ListScroll.Size = UDim2.new(1, 0, 0, 120)
ListScroll.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 2 -- Lebih tipis agar terlihat clean
ListScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 55, 70)
ListScroll.LayoutOrder = 6
ListScroll.Parent = MainFrame

local ListScrollCorner = Instance.new("UICorner")
ListScrollCorner.CornerRadius = UDim.new(0, 8)
ListScrollCorner.Parent = ListScroll

local ListScrollPadding = Instance.new("UIPadding")
ListScrollPadding.PaddingLeft = UDim.new(0, 6)
ListScrollPadding.PaddingRight = UDim.new(0, 6)
ListScrollPadding.PaddingTop = UDim.new(0, 6)
ListScrollPadding.PaddingBottom = UDim.new(0, 6)
ListScrollPadding.Parent = ListScroll

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ListScroll

-- [[ REFRESH BUTTON ]]
local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "RefreshButton"
RefreshButton.Size = UDim2.new(1, 0, 0, 28)
RefreshButton.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
RefreshButton.TextColor3 = Color3.fromRGB(180, 185, 200)
RefreshButton.Text = "🔄 Refresh File List"
RefreshButton.Font = Enum.Font.GothamSemibold
RefreshButton.TextSize = 11
RefreshButton.LayoutOrder = 7
RefreshButton.Parent = MainFrame

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
RefreshCorner.Parent = RefreshButton

RefreshButton.MouseEnter:Connect(function() RefreshButton.BackgroundColor3 = Color3.fromRGB(28, 31, 38) end)
RefreshButton.MouseLeave:Connect(function() RefreshButton.BackgroundColor3 = Color3.fromRGB(22, 24, 30) end)


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
        CopyButton.Text = "EXECUTOR NOT SUPPORTED"
        return 
    end
    CopyButton.Text = "SCANNING MAP..."
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
                    CopyButton.Text = "SCANNING [" .. count .. "]" 
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
    CopyButton.Text = "START COPY MAP"
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
            ItemFrame.Size = UDim2.new(1, 0, 0, 30)
            ItemFrame.BackgroundTransparency = 1
            ItemFrame.Parent = ListScroll
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -32, 1, 0)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
            FileSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            FileSelectBtn.Text = "  📄 " .. cleanName
            FileSelectBtn.Font = Enum.Font.GothamSemibold
            FileSelectBtn.TextSize = 10
            FileSelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            FileSelectBtn.Parent = ItemFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = FileSelectBtn
            
            local DeleteBtn = Instance.new("TextButton")
            DeleteBtn.Size = UDim2.new(0, 26, 1, 0)
            DeleteBtn.Position = UDim2.new(1, -26, 0, 0)
            DeleteBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
            DeleteBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            DeleteBtn.Text = "✕"
            DeleteBtn.Font = Enum.Font.GothamBold
            DeleteBtn.TextSize = 11
            DeleteBtn.Parent = ItemFrame
            
            local DelCorner = Instance.new("UICorner")
            DelCorner.CornerRadius = UDim.new(0, 6)
            DelCorner.Parent = DeleteBtn

            DeleteBtn.MouseButton1Click:Connect(function()
                if delfile then
                    pcall(delfile, file)
                    ItemFrame:Destroy()
                    _G.UpdatePasteList()
                end
            end)
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
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
                                    FileSelectBtn.Text = "🔨 [" .. pasteCount .. "/" .. totalObjs .. "]"
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
                        FileSelectBtn.Text = "✅ PASTE SUCCESS"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                    else
                        FileSelectBtn.Text = "❌ PASTE ERROR"
                        FileSelectBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
                    end
                    task.wait(1.5)
                    FileSelectBtn.Text = "  📄 " .. cleanName
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
                end)
            end)
        end
    end
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(_G.UpdatePasteList)
_G.UpdatePasteList()
