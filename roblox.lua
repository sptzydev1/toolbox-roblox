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
local SelectedObjects = {}
local IsMultiSelecting = false
local HighlightStorage = {}

-- [[ CREATING GUI (Premium Curved UI V4.2 - Grid Photo & Texture Support) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpyzyyGridCopyGuiV4_2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.Parent = MainFrame

-- Judul GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "📸 SCAN MULTI-COPY V4.2 (TEXTUR) 📸"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame

-- Tombol Multi-Select Toggle
local MultiSelectButton = Instance.new("TextButton")
MultiSelectButton.Size = UDim2.new(0, 236, 0, 32)
MultiSelectButton.Position = UDim2.new(0, 12, 0, 40)
MultiSelectButton.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
MultiSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiSelectButton.Text = "🎯 SCAN MULTI-SELECT: OFF"
MultiSelectButton.Font = Enum.Font.SourceSansBold
MultiSelectButton.TextSize = 12
MultiSelectButton.Parent = MainFrame

local MultiCorner = Instance.new("UICorner")
MultiCorner.CornerRadius = UDim.new(0, 6)
MultiCorner.Parent = MultiSelectButton

-- Label Penanda Grid Preview
local GridLabel = Instance.new("TextLabel")
GridLabel.Size = UDim2.new(1, -24, 0, 20)
GridLabel.Position = UDim2.new(0, 12, 0, 78)
GridLabel.BackgroundTransparency = 1
GridLabel.Text = "Hasil Scan Objek (Decal & Textur Aktif):"
GridLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
GridLabel.TextXAlignment = Enum.TextXAlignment.Left
GridLabel.Font = Enum.Font.SourceSansGridBold
GridLabel.TextSize = 12
GridLabel.Parent = MainFrame

-- SCROLLING FRAME UNTUK FOTO (SUSUNAN GRID 1,2,3 / 4,5,6)
local ImageGridScroll = Instance.new("ScrollingFrame")
ImageGridScroll.Size = UDim2.new(0, 236, 0, 150)
ImageGridScroll.Position = UDim2.new(0, 12, 0, 100)
ImageGridScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
ImageGridScroll.BorderSizePixel = 0
ImageGridScroll.ScrollBarThickness = 4
ImageGridScroll.Parent = MainFrame

local GridScrollCorner = Instance.new("UICorner")
GridScrollCorner.CornerRadius = UDim.new(0, 6)
GridScrollCorner.Parent = ImageGridScroll

-- PENGATUR SUSUNAN OTOMATIS (UIGridLayout)
local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 72, 0, 72)
GridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GridLayout.Parent = ImageGridScroll

-- Tombol Save Selection
local SaveSelectButton = Instance.new("TextButton")
SaveSelectButton.Size = UDim2.new(0, 236, 0, 30)
SaveSelectButton.Position = UDim2.new(0, 12, 0, 260)
SaveSelectButton.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
SaveSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveSelectButton.Text = "💾 SAVE SCANNED OBJECTS (0)"
SaveSelectButton.Font = Enum.Font.SourceSansBold
SaveSelectButton.TextSize = 12
SaveSelectButton.Visible = false
SaveSelectButton.Parent = MainFrame

local SaveSelCorner = Instance.new("UICorner")
SaveSelCorner.CornerRadius = UDim.new(0, 6)
SaveSelCorner.Parent = SaveSelectButton

-- List File Manager (Bagian Bawah)
local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(0, 236, 0, 85)
ListScroll.Position = UDim2.new(0, 12, 0, 298)
ListScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 4
ListScroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ListScroll

-- Refresh Button
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 236, 0, 22)
RefreshButton.Position = UDim2.new(0, 12, 0, 390)
RefreshButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
RefreshButton.TextColor3 = Color3.fromRGB(180, 180, 180)
RefreshButton.Text = "🔄 Refresh File List"
RefreshButton.Font = Enum.Font.SourceSans
RefreshButton.TextSize = 11
RefreshButton.Parent = MainFrame

-- [[ DRAGGABLE UI LOGIC ]]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [[ UPDATE VISUAL GRID MINI-PHOTO DENGAN DECAL & TEXTURE ]]
local function updateImageGrid()
    for _, child in pairs(ImageGridScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for idx, obj in ipairs(SelectedObjects) do
        local ItemBox = Instance.new("Frame")
        ItemBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        ItemBox.Parent = ImageGridScroll
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = ItemBox
        
        -- VIEWPORT FRAME
        local Viewport = Instance.new("ViewportFrame")
        Viewport.Size = UDim2.new(1, -4, 1, -4)
        Viewport.Position = UDim2.new(0, 2, 0, 2)
        Viewport.BackgroundTransparency = 1
        -- Mengaktifkan pencahayaan ambient cerah agar tekstur/decal kelihatan jelas
        Viewport.Ambient = Color3.fromRGB(200, 200, 200)
        Viewport.LightColor = Color3.fromRGB(255, 255, 255)
        Viewport.LightDirection = Vector3.new(-1, -1, -1)
        Viewport.Parent = ItemBox
        
        -- Kloning objek (Anak cucu seperti Decal/Texture otomatis ikut ter-clone)
        local clonedObj = obj:Clone()
        if clonedObj:IsA("BasePart") then
            clonedObj.Position = Vector3.new(0, 0, 0)
            clonedObj.Parent = Viewport
        elseif clonedObj:IsA("Model") then
            clonedObj:PivotTo(CFrame.new(0, 0, 0))
            clonedObj.Parent = Viewport
        end
        
        -- Setup Kamera Otomatis
        local cam = Instance.new("Camera")
        cam.FieldOfView = 45
        Viewport.CurrentCamera = cam
        cam.Parent = Viewport
        
        if obj:IsA("Model") then
            local s, c = obj:GetBoundingBox()
            cam.CFrame = CFrame.new(Vector3.new(s.X, s.Y + (s.Y*0.5) + 2, s.Z + s.Magnitude + 2), Vector3.new(0,0,0))
        else
            -- Menyesuaikan posisi kamera agar pas melihat permukaan part yang ditempeli tekstur
            local maxDim = math.max(obj.Size.X, obj.Size.Y, obj.Size.Z)
            cam.CFrame = CFrame.new(Vector3.new(maxDim, maxDim + 1, maxDim + 3), Vector3.new(0, 0, 0))
        end
        
        -- Label Angka Urutan Grid (1, 2, 3...)
        local NumLabel = Instance.new("TextLabel")
        NumLabel.Size = UDim2.new(0, 16, 0, 16)
        NumLabel.Position = UDim2.new(0, 2, 0, 2)
        NumLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        NumLabel.TextColor3 = Color3.fromRGB(0,0,0)
        NumLabel.Text = tostring(idx)
        NumLabel.Font = Enum.Font.SourceSansBold
        NumLabel.TextSize = 10
        NumLabel.Parent = ItemBox
        
        local NumCorner = Instance.new("UICorner")
        NumCorner.CornerRadius = UDim.new(1, 0)
        NumCorner.Parent = NumLabel
    end
    
    ImageGridScroll.CanvasSize = UDim2.new(0, 0, 0, GridLayout.AbsoluteContentSize.Y)
end

-- [[ LOGIKA MODEL BERLAPIS ANTI-TERLEWAT ]]
local function getTopLevelModelOrPart(target)
    if not target or target == workspace then return nil end
    local current = target
    while current.Parent and current.Parent ~= workspace and current.Parent ~= game do
        local pName = current.Parent.Name:lower()
        if pName:match("map") or pName:match("world") or pName:match("stage") then break end
        if current.Parent:IsA("Model") or current.Parent:IsA("Folder") then
            current = current.Parent
        else
            break
        end
    end
    return current
end

local function highlightObject(obj, status)
    if status then
        if not HighlightStorage[obj] then
            local box = Instance.new("SelectionBox")
            box.Color3 = Color3.fromRGB(0, 200, 255)
            box.LineThickness = 0.04
            box.Adornee = obj
            box.Parent = ScreenGui
            HighlightStorage[obj] = box
        end
    else
        if HighlightStorage[obj] then HighlightStorage[obj]:Destroy() HighlightStorage[obj] = nil end
    end
end

-- Detektor Klik untuk Scan Multi-Select
UIS.InputBegan:Connect(function(input, gp)
    if not IsMultiSelecting then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = Mouse.Target
        if target and not target:IsDescendantOf(ScreenGui) then
            local finalTarget = getTopLevelModelOrPart(target) or target
            
            if not table.find(SelectedObjects, finalTarget) then
                table.insert(SelectedObjects, finalTarget)
                highlightObject(finalTarget, true)
            else
                for idx, v in ipairs(SelectedObjects) do
                    if v == finalTarget then
                        table.remove(SelectedObjects, idx)
                        highlightObject(finalTarget, false)
                        break
                    end
                end
            end
            SaveSelectButton.Text = "💾 SAVE SCANNED OBJECTS (" .. #SelectedObjects .. ")"
            updateImageGrid()
        end
    end
end)

-- Toggle Multi-Select
MultiSelectButton.MouseButton1Click:Connect(function()
    IsMultiSelecting = not IsMultiSelecting
    if IsMultiSelecting then
        MultiSelectButton.Text = "🟢 SCAN MULTI-SELECT: ON"
        MultiSelectButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        SaveSelectButton.Visible = true
    else
        MultiSelectButton.Text = "🎯 SCAN MULTI-SELECT: OFF"
        MultiSelectButton.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
        SaveSelectButton.Visible = false
        for obj, _ in pairs(HighlightStorage) do highlightObject(obj, false) end
        SelectedObjects = {}
        HighlightStorage = {}
        updateImageGrid()
    end
end)
