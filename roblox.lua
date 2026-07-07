-- [[ CONFIGURASI & VARIABLE UTAMA ]]
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local FILE_NAME = "CrossGameAdvancedClipboard.json" 
local TargetFolder = workspace -- Meng-scan seluruh Workspace

-- [[ CREATING GUI (Persegi Empat Kecil) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrossGameAdvancedGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 150)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 140, 0, 30)
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 45, 55)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "📦 COPY ALL + STRUCT"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local PasteButton = Instance.new("TextButton")
PasteButton.Size = UDim2.new(0, 140, 0, 30)
PasteButton.BackgroundColor3 = Color3.fromRGB(50, 45, 55)
PasteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteButton.Text = "📥 PASTE ALL + STRUCT"
PasteButton.Font = Enum.Font.SourceSansBold
PasteButton.TextSize = 12
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


-- [[ LOGIKA REKURSIF COPY & PASTE (FOLDER & MODEL SUPPORT) ]]

-- Fungsi untuk mendapatkan "Path" atau Alamat Parent agar strukturnya tidak hancur saat di-paste
local function getRelativePath(obj)
    local path = {}
    local current = obj.Parent
    while current and current ~= workspace and current ~= game do
        table.insert(path, 1, {Name = current.Name, ClassName = current.ClassName})
        current = current.Parent
    end
    return path
end

-- 1. TOMBOL COPY (Mendukung Folder, Model, dan Part di dalamnya)
CopyButton.MouseButton1Click:Connect(function()
    if not writefile then 
        CopyButton.Text = "Executor Tak Support!"
        return 
    end

    local SaveData = {}
    local count = 0
    
    -- Menggunakan GetDescendants() agar folder dan model di dalam folder lain ikut ter-scan
    for _, obj in pairs(TargetFolder:GetDescendants()) do
        -- Kita hanya menyimpan Folder, Model, dan objek fisik (Part)
        if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") then
            count = count + 1
            
            local data = {
                Name = obj.Name,
                ClassName = obj.ClassName,
                RelativePath = getRelativePath(obj) -- Menyimpan struktur silsilah keluarga objek
            }
            
            -- Jika objek adalah Part fisik, simpan properti transformasinya
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
    
    writefile(FILE_NAME, HttpService:JSONEncode(SaveData))
    CopyButton.Text = "SAVED " .. count .. " ASSETS TO PC"
    task.wait(1.5)
    CopyButton.Text = "📦 COPY ALL + STRUCT"
end)

-- 2. TOMBOL PASTE (Membangun ulang Folder/Model sesuai struktur asli)
PasteButton.MouseButton1Click:Connect(function()
    if not readfile or not isfile(FILE_NAME) then 
        PasteButton.Text = "File Kosong / Tak Support!"; 
        task.wait(1.5); 
        PasteButton.Text = "📥 PASTE ALL + STRUCT"; 
        return 
    end
    
    local loadedData = HttpService:JSONDecode(readfile(FILE_NAME))
    
    -- Root folder utama untuk menampung hasil paste di game baru
    local MasterFolder = workspace:FindFirstChild("Hasil_Paste_Struktur")
    if not MasterFolder then
        MasterFolder = Instance.new("Folder")
        MasterFolder.Name = "Hasil_Paste_Struktur"
        MasterFolder.Parent = workspace
    end
    
    -- Fungsi pembantu untuk mencari atau membuat Parent (Folder/Model) secara otomatis saat rekonstruksi
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
    
    -- Mulai melakukan pemPembuatan ulang objek
    for _, data in pairs(loadedData) do
        pcall(function()
            -- Cari tahu objek ini harus ditaruh di folder/model mana
            local targetParent = findOrCreateParent(data.RelativePath)
            
            -- Cek apakah objek (terutama Folder/Model pembungkus) sudah dibuat oleh fungsi di atas
            local existingObj = targetParent:FindFirstChild(data.Name)
            if existingObj and (data.ClassName == "Folder" or data.ClassName == "Model") then
                -- Jika sudah ada pembungkusnya, tidak perlu dibuat double
                return
            end
            
            -- Buat objek baru
            local newObj = Instance.new(data.ClassName)
            newObj.Name = data.Name
            
            -- Jika berupa Part, isi semua data fisiknya
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
    
    PasteButton.Text = "STRUCTURE REBUILT!"
    task.wait(1.5)
    PasteButton.Text = "📥 PASTE ALL + STRUCT"
end)
