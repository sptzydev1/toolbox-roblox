local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "sptzyy copyy game",
   LoadingTitle = "Map Copier (No Terrain)",
   LoadingSubtitle = "by sptzyy",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main Features", 4483362458)
local HttpService = game:GetService("HttpService")
local fileName = "sptzyy_map_data.json"

-- Fungsi Copy: Hanya Part, Bukan Terrain
MainTab:CreateButton({
   Name = "Copy Map (Exclude Terrain)",
   Callback = function()
      local mapData = {}
      local count = 0
      
      for _, obj in pairs(game.Workspace:GetDescendants()) do
         -- Filter: Harus BasePart, Bukan Terrain, dan Bukan bagian dari Character pemain
         if obj:IsA("BasePart") and not obj:IsA("Terrain") and not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
            table.insert(mapData, {
               ClassName = obj.ClassName,
               Name = obj.Name,
               Size = {obj.Size.X, obj.Size.Y, obj.Size.Z},
               CFrame = {obj.CFrame:GetComponents()},
               Color = {obj.Color.r, obj.Color.g, obj.Color.b},
               Material = tostring(obj.Material.Name),
               Transparency = obj.Transparency,
               CanCollide = obj.CanCollide,
               Anchored = obj.Anchored
            })
            count = count + 1
         end
      end
      
      local success, encoded = pcall(function() return HttpService:JSONEncode(mapData) end)
      if success then
         writefile(fileName, encoded)
         Rayfield:Notify({Title = "Success!", Content = "Berhasil salin " .. count .. " part (Tanpa Terrain).", Duration = 5})
      end
   end,
})

-- Fungsi Tempel
MainTab:CreateButton({
   Name = "Paste Map ke Map Lain",
   Callback = function()
      if not isfile(fileName) then
         Rayfield:Notify({Title = "Error", Content = "Data copy tidak ditemukan!", Duration = 5})
         return
      end

      local dataRaw = readfile(fileName)
      local mapData = HttpService:JSONDecode(dataRaw)
      
      local folder = Instance.new("Folder")
      folder.Name = "sptzyy_PastedMap"
      folder.Parent = game.Workspace

      for _, data in pairs(mapData) do
         local success, newPart = pcall(function()
            local p = Instance.new(data.ClassName)
            p.Name = data.Name
            p.Size = Vector3.new(unpack(data.Size))
            p.CFrame = CFrame.new(unpack(data.CFrame))
            p.Color = Color3.new(unpack(data.Color))
            p.Material = Enum.Material[data.Material] or Enum.Material.Plastic
            p.Transparency = data.Transparency
            p.CanCollide = data.CanCollide
            p.Anchored = data.Anchored
            p.Parent = folder
            return p
         end)
      end

      Rayfield:Notify({Title = "Done", Content = "Map berhasil ditempel!", Duration = 5})
   end,
})

MainTab:CreateButton({
   Name = "Close GUI",
   Callback = function() Rayfield:Destroy() end,
})
