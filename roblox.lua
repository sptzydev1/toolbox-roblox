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
        GameName = productInfo.Name:gsub("[%s%p]", "_") -- Bersihkan simbol/spasi
    end
end)

local FILE_PREFIX = "GameCopy_"
local TargetFolder = workspace -- Meng-scan seluruh Workspace

-- [[ CREATING GUI (Persegi Empat dengan List Menu) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiGameListGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "🎮 MULTI-COPY CHANGER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 160, 0, 30)
CopyButton.Position = UDim2.new(0, 10, 0, 30)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "📦 NEW COPY (RANDOM)"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -20, 0, 20)
ListLabel.Position = UDim2.new(0, 10, 0, 65)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "Pilih Data File Untuk Di-paste:"
ListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.Font = Enum.Font.SourceSans
ListLabel.TextSize = 11
ListLabel.Parent = MainFrame

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 160, 0, 110)
ListScroll.Position = UDim2.new(0, 10, 0, 85)
ListScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
ListScroll.BorderSizePixel = 0
ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ListScroll.ScrollBarThickness = 4
ListScroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = ListScroll

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 160, 0, 15)
RefreshButton.Position = UDim2.new(0, 10, 0, 200)
RefreshButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
RefreshButton.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshButton.Text = "🔄 Refresh List"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 10
RefreshButton.Parent = MainFrame

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

-- [[ LOGIKA CORE: MULTI-FILENAME & LIST SELECTION ]]

local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= workspace and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

-- 1. LOGIKA COPY DENGAN GENERATE NAMA RANDOM/TIMESTAMPS
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    -- LOGIKA UTAMA: Membuat kode acak 4 digit + Waktu saat ini (Timestamp) agar nama file selalu beda
    local uniqueID = math.random(1000, 9999) .. "_" .. os.date("%H%M%S")
    local fileName = FILE_PREFIX .. GameName .. "_" .. uniqueID .. ".json"
    
    for _, obj in pairs(TargetFolder:GetDescendants()) do
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") then
            count = count + 1
            local data = {
                Name = obj.Name,
                ClassName = obj.ClassName,
                RelativePath = getRelativePath(obj)
            }
            if obj:IsA("BasePart") then
                data.Size = {obj.Size.X, obj.Size.Y, obj.Size.Z}
                data.Position = {obj.Position.X, obj.Position.Y, obj.Position.Z}
                data.Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255}
                data.Material = obj.Material.Name
                data.Transparency = obj.Transparency
                data.Anchored = obj.Anchored
            end
            table.insert(SaveData, data)
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "💾 FILE GENERATED!"
    task.wait(1.5)
    CopyButton.Text = "📦 NEW COPY (RANDOM)"
    _G.UpdatePasteList() -- Refresh list otomatis
end)

-- 2. LOGIKA MENAMPILKAN SELURUH LIST FILE HASIL COPY DI PC
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
            -- Bersihkan nama path luar agar UI tetap bersih dan rapi
            local cleanName = file:gsub(FILE_PREFIX, ""):gsub("%.json", ""):gsub(".*/", "")
            
            local FileSelectBtn = Instance.new("TextButton")
            FileSelectBtn.Size = UDim2.new(1, -5, 0, 24)
            FileSelectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            FileSelectBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            FileSelectBtn.Text = "📄 " .. cleanName
            FileSelectBtn.Font = Enum.Font.SourceSans
            FileSelectBtn.TextSize = 11
            FileSelectBtn.Parent = ListScroll
            
            FileSelectBtn.MouseButton1Click:Connect(function()
                FileSelectBtn.Text = "⌛ PASTING..."
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
                
                local success, err = pcall(function()
                    local fileContent = readfile(file)
                    local loadedData = HttpService:JSONDecode(fileContent)
                    
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
                                found = Instance.new(pathInfo.ClassName)
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
                            
                            local newObj = Instance.new(data.ClassName)
                            newObj.Name = data.Name
                            
                            if data.Size and newObj:IsA("BasePart") then
                                newObj.Size = Vector3.new(data.Size[1], data.Size[2], data.Size[3])
                                newObj.Position = Vector3.new(data.Position[1], data.Position[2], data.Position[3])
                                newObj.Color = Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3])
                                newObj.Material = Enum.Material[data.Material]
                                newObj.Transparency = data.Transparency
                                newObj.Anchored = data.Anchored
                            end
                            newObj.Parent = targetParent
                        end)
                    end
                end)
                
                if success then
                    FileSelectBtn.Text = "✅ DONE!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                else
                    FileSelectBtn.Text = "❌ ERROR!"
                    FileSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                end
                
                task.wait(1.5)
                FileSelectBtn.Text = "📄 " .. cleanName
                FileSelectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
            end)
        end
    end
    
    if not anyFile then
        local NoFileLabel = Instance.new("TextLabel")
        NoFileLabel.Size = UDim2.new(1, 0, 0, 20)
        NoFileLabel.BackgroundTransparency = 1
        NoFileLabel.Text = "(Belum ada file copy)"
        NoFileLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        NoFileLabel.Font = Enum.Font.SourceSansItalic
        NoFileLabel.TextSize = 11
        NoFileLabel.Parent = ListScroll
    end
    
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshButton.MouseButton1Click:Connect(function()
    _G.UpdatePasteList()
end)

_G.UpdatePasteList()
