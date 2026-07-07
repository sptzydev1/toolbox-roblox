-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Nama file penyimpanan di PC kamu (akan ada di folder workspace executor-mu)
local FILE_NAME = "CrossGameClipboard.json" 

-- Target folder yang mau dicopy (Default: seluruh Workspace)
local TargetFolder = workspace

-- [[ CREATING GUI (Persegi Empat Kecil) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrossGameGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 140, 0, 30)
CopyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "👉 COPY ALL (FILE)"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 13
CopyButton.Parent = MainFrame

local PasteButton = Instance.new("TextButton")
PasteButton.Size = UDim2.new(0, 140, 0, 30)
PasteButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
PasteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteButton.Text = "📥 PASTE ALL (FILE)"
PasteButton.Font = Enum.Font.SourceSansBold
PasteButton.TextSize = 13
PasteButton.Parent = MainFrame

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


-- [[ LOGIKA CROSS-GAME BERBASIS FILE SYSTEM ]]

-- 1. Fungsi untuk Mengubah Objek menjadi Data Teks (JSON)
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    for _, obj in pairs(TargetFolder:GetChildren()) do
        -- Batasi hanya Part biasa untuk kestabilan data JSON
        if obj:IsA("Part") or obj:IsA("WedgePart") or obj:IsA("CornerWedgePart") then
            count = count + 1
            table.insert(SaveData, {
                Name = obj.Name,
                ClassName = obj.ClassName,
                Size = {obj.Size.X, obj.Size.Y, obj.Size.Z},
                Position = {obj.Position.X, obj.Position.Y, obj.Position.Z},
                Color = {obj.Color.r * 255, obj.Color.g * 255, obj.Color.b * 255},
                Material = obj.Material.Name,
                Transparency = obj.Transparency,
                Anchored = obj.Anchored
            })
        end
    end
    
    -- Mengubah tabel Lua menjadi string teks JSON
    local jsonString = HttpService:JSONEncode(SaveData)
    
    -- Menyimpan teks ke dalam file di PC kamu
    writefile(FILE_NAME, jsonString)
    
    CopyButton.Text = "SAVED " .. count .. " OBJEK TO PC"
    task.wait(1.5)
    CopyButton.Text = "👉 COPY ALL (FILE)"
end)

-- 2. Fungsi untuk Membaca File dan Memunculkan Objek di Game Lain
PasteButton.MouseButton1Click:Connect(function()
    if not readfile then 
        PasteButton.Text = "Executor Tak Support!"
        return 
    end
    
    -- Mengecek apakah file hasil copy dari game 1 ada
    if not isfile(FILE_NAME) then
        PasteButton.Text = "File Copy Kosong!"
        task.wait(1.5)
        PasteButton.Text = "📥 PASTE ALL (FILE)"
        return
    end
    
    -- Membaca data teks dari file PC
    local fileContent = readfile(FILE_NAME)
    local loadedData = HttpService:JSONDecode(fileContent)
    
    local PastedFolder = Instance.new("Folder")
    PastedFolder.Name = "Hasil_Paste_GameLain"
    PastedFolder.Parent = workspace
    
    -- Rekonstruksi/Membuat ulang objek di game baru
    for _, data in pairs(loadedData) do
        pcall(function()
            local newPart = Instance.new(data.ClassName)
            newPart.Name = data.Name
            newPart.Size = Vector3.new(data.Size[1], data.Size[2], data.Size[3])
            
            -- Memunculkan tepat di koordinat saat di-copy
            newPart.Position = Vector3.new(data.Position[1], data.Position[2], data.Position[3])
            newPart.Color = Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3])
            newPart.Material = Enum.Material[data.Material]
            newPart.Transparency = data.Transparency
            newPart.Anchored = data.Anchored
            
            newPart.Parent = PastedFolder
        end)
    end
    
    PasteButton.Text = "SUCCESS LOADED FROM PC!"
    task.wait(1.5)
    PasteButton.Text = "📥 PASTE ALL (FILE)"
end)
