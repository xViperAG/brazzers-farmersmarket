QBCore = exports[Config.Core]:GetCoreObject()

local inFarmersMarket = false

-- Functions

exports('inFarmersMarket', function()
    return inFarmersMarket
end)

local function CreateDUI(market, url)
    Config.Market[market]['boothDUI']['dui'] = { obj = CreateDui(url, Config.Market[market]['boothDUI']['width'], Config.Market[market]['boothDUI']['height']) }
    Config.Market[market]['boothDUI']['dui'].dict = ("%s-dict"):format(market)
    Config.Market[market]['boothDUI']['dui'].texture = ("%s-txt"):format(market)
    local dictObject = CreateRuntimeTxd(Config.Market[market]['boothDUI']['dui'].dict)
    local duiHandle = GetDuiHandle(Config.Market[market]['boothDUI']['dui'].obj)
    CreateRuntimeTextureFromDuiHandle(dictObject, Config.Market[market]['boothDUI']['dui'].texture, duiHandle)
    AddReplaceTexture(Config.Market[market]['boothDUI']['ytd'], Config.Market[market]['boothDUI']['ytdname'], Config.Market[market]['boothDUI']['dui'].dict, Config.Market[market]['boothDUI']['dui'].texture)
end

local function removeDUI(market, removeAll)
    if not Config.Market[market]['boothDUI']['dui'] then return end
    SetDuiUrl(Config.Market[market]['boothDUI']['dui'].obj, Config.DefaultImage)
    if removeAll then
        DestroyDui(Config.Market[market]['boothDUI']['dui'].obj)
        RemoveReplaceTexture(Config.Market[market]['boothDUI']['ytd'], Config.Market[market]['boothDUI']['ytdname'])
    end
    Config.Market[market]['boothDUI']['dui'] = nil
end

local function setupDUI()
    QBCore.Functions.TriggerCallback('brazzers-market:server:getMarketDui',function(DUIs)
        Config.Market = DUIs
    end)

    local pierZone = CircleZone:Create(Config.PierPoly, Config.PierRadius, {
        name = "pier_market_zone",
        debugPoly = Config.Debug
    })

    pierZone:onPlayerInOut(function(isPointInside, _)
        if isPointInside then
            for k, _ in pairs(Config.Market) do
                CreateDUI(k, Config.Market[k]['boothDUI']['url'])
            end
            while isPointInside do
                ClearAreaOfPeds(Config.PierPoly.x, Config.PierPoly.y, Config.PierPoly.z, Config.PierRadius, false, false, false, false, false)
                Wait(100)
            end
        else
            for k, _ in pairs(Config.Market) do
                removeDUI(k, true)
            end
        end
    end)
end

local function claimBooth(k)
    if not isMarketOpen() then return notification("error.market_not_open", "error") end
    if Config.Market[k]['owner'] then return notification("error.already_claimed", "error") end

    if Config.Input == 'ox' then
        local input = lib.inputDialog(Lang:t('other.set_password'), {Lang:t('other.password')})
        if not input then return end

        local password = tonumber(input[1])
        if not password then return notification("error.password_not_number", "error") end

        TriggerServerEvent('brazzers-market:server:setOwner', k, password)
        return
    end

    local input = exports[Config.Input]:ShowInput({
        header = Lang:t('other.set_password'),
        submitText = Lang:t('other.submit'),
        inputs = {
            {
                text = Lang:t('other.password'),
                name = "password",
                type = "password",
                isRequired = true,
            },
        }
    })
    if not input then return end
    if not input.password then return end

    local password = input.password

    TriggerServerEvent('brazzers-market:server:setOwner', k, password)
end

local function leaveBooth(k)
    TriggerServerEvent('brazzers-market:server:leaveBooth', k)
end

local function joinBooth(k)
    if not isMarketOpen() then return notification("error.market_not_open", "error") end
    if not Config.Market[k]['owner'] then return notification("error.not_claimed", "error") end

    if Config.Input == 'ox' then
        local input = lib.inputDialog(Lang:t('other.input_password'), {Lang:t('other.password')})
        if not input then return end
    
        local password = tonumber(input[1])
        if not password then return notification("error.password_not_number", "error") end
    
        if password ~= Config.Market[k]['password'] then return notification("error.incorrect_password", "error") end
        TriggerServerEvent('brazzers-market:server:setGroupMembers', k)
        return
    end

    local input = exports[Config.Input]:ShowInput({
        header = Lang:t('other.input_password'),
        submitText = Lang:t('other.submit'),
        inputs = {
            {
                text = Lang:t('other.password'),
                name = "password",
                type = "password",
                isRequired = true,
            },
        }
    })

    if not input then return end
    if not input.password then return end

    local password = input.password
    if password ~= Config.Market[k]['password'] then return notification("error.incorrect_password", "error") end
    TriggerServerEvent('brazzers-market:server:setGroupMembers', k)
end

local function changeBanner(k)
    if not isMarketOpen() then return notification("error.market_not_open", "error") end
    QBCore.Functions.TriggerCallback('brazzers-market:server:groupMembers', function(IsOwner, IsInGroup)
        if IsOwner or IsInGroup then
            if Config.Input == 'ox' then
                local input = lib.inputDialog(Lang:t('other.change_banner'), {Lang:t('other.banner_url')})
                if not input then return end
    
                local banner = input[1]
                if not banner then return end
                TriggerServerEvent('brazzers-market:server:setBannerImage', k, banner)
                return
            end

            local input = exports[Config.Input]:ShowInput({
                header = Lang:t('other.change_banner'),
                submitText = Lang:t('other.submit'),
                inputs = {
                    {
                        text = Lang:t('other.banner_url'),
                        name = "banner",
                        type = "text",
                        isRequired = true,
                    },
                }
            })

            if not input then return end
            if not input.banner then return end

            local banner = input.banner
            TriggerServerEvent('brazzers-market:server:setBannerImage', k, banner)
        end
    end, k)
end

local function marketStash(k)
    if not isMarketOpen() then return notification("error.market_not_open", "error") end
    QBCore.Functions.TriggerCallback('brazzers-market:server:groupMembers', function(IsOwner, IsInGroup)
        if IsOwner or IsInGroup then
            if Config.Inventory == 'ox' then
                exports.ox_inventory:openInventory('stash', {id='market_stash'..k, owner=false})
                return
            end

            TriggerServerEvent("inventory:server:OpenInventory", "stash", "market_stash"..k, {
                maxweight = Config.StashWeight,
                slots = Config.StashSlots,
            })
            TriggerEvent("inventory:client:SetCurrentStash", "market_stash"..k)
        end
    end, k)
end

local function marketPickup(k)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', {id='market_pickup'..k, owner=false})
        return
    end

    TriggerServerEvent("inventory:server:OpenInventory", "stash", "market_register"..k, {
        maxweight = Config.PickupWeight,
        slots = Config.PickupSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "market_register"..k)
end

-- Net Events

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('brazzers-market:server:getMarkets', function(result)
		Config.Market = result
        setupDUI()
    end)
end)

RegisterNetEvent('brazzers-market:client:updateBooth', function(market, type, citizenid)
    Config.Market[market][type] = citizenid
end)

RegisterNetEvent('brazzers-market:client:setBoothPassword', function(market, password)
    Config.Market[market]['password'] = password
end)

RegisterNetEvent('brazzers-market:client:resetMarkets', function(market)
    Config.Market[market]['owner'] = nil
    Config.Market[market]['groupMembers'] = {}
    Config.Market[market]['password'] = nil
    Config.Market[market]['boothDUI']['url'] = Config.DefaultImage
    removeDUI(market, false)
end)

RegisterNetEvent('brazzers-market:client:setVariable', function(variable)
    inFarmersMarket = variable
end)

RegisterNetEvent('brazzers-market:client:setBannerImage', function(market, url)
    Config.Market[market]['boothDUI']['url'] = url

    if Config.Market[market]['boothDUI']['dui'] then
        SetDuiUrl(Config.Market[market]['boothDUI']['dui'].obj, Config.Market[market]['boothDUI']['url'])
    else
        CreateDUI(market, url)
    end
end)

-- Threads

CreateThread(function()
    QBCore.Functions.TriggerCallback('brazzers-market:server:getMarkets', function(result)
		Config.Market = result
        setupDUI()
    end)
end)

CreateThread(function()
    for k, v in pairs(Config.Market) do
        if Config.Target == 'ox' then
            exports.ox_target:addBoxZone({
                coords = v['booth']['coords'].xyz,
                size = vec3(1.0, 3.0, 1.0),
                rotation = 135,
                debug = Config.Debug,
                options = {
                    {   
                        name = "market_booth_"..k,
                        icon = 'fas fa-flag',
                        label = Lang:t('target.claim_booth'),
                        onSelect = function()
                            claimBooth(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            return true
                        end,
                    },
                    {   
                        name = "market_booth_"..k,
                        icon = 'fas fa-flag',
                        label = Lang:t('target.leave_booth'),
                        onSelect = function()
                            leaveBooth(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            if not Config.Market[k]['owner'] then return end
                            return true
                        end,
                    },
                    {   
                        name = "market_booth_"..k,
                        icon = 'fas fa-circle',
                        label = Lang:t('target.join_booth'),
                        onSelect = function()
                            joinBooth(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            if not Config.Market[k]['owner'] then return end
                            return true
                        end,
                    },
                    {   
                        name = "market_booth_"..k,
                        icon = 'fas fa-recycle',
                        label = Lang:t('target.banner_change'),
                        onSelect = function()
                            changeBanner(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            if not Config.Market[k]['owner'] then return end
                            return true
                        end,
                    },
                }
            })

            exports.ox_target:addBoxZone({
                coords = v['register']['coords'].xyz,
                size = vec3(1.5, 1.0, 1.0),
                rotation = 135,
                debug = Config.Debug,
                options = {
                    {   
                        name = "market_register_"..k,
                        icon = 'fas fa-box',
                        label = Lang:t('target.register_inventory'),
                        onSelect = function()
                            marketStash(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            if not Config.Market[k]['owner'] then return end
                            return true
                        end,
                    },
                    {   
                        name = "market_register_"..k,
                        icon = 'fas fa-hand-holding',
                        label = Lang:t('target.register_pickup'),
                        onSelect = function()
                            marketPickup(k)
                        end,
                        canInteract = function()
                            if not isMarketOpen() then return end
                            if not Config.Market[k]['owner'] then return end
                            return true
                        end,
                    },
                }
            })
            return
        end


        exports[Config.Target]:AddBoxZone("market_booth_"..k, v['booth']['coords'].xyz, 1.0, 3.0, {
            name = "market_booth_"..k,
            heading = v['booth']['heading'],
            debugPoly = Config.Debug,
            minZ = v['booth']['coords'].z,
            maxZ = v['booth']['coords'].z + 1.5,
            }, {
                options = {
                {
                    action = function()
                        claimBooth(k)
                    end,
                    icon = 'fas fa-flag',
                    label = Lang:t('target.claim_booth'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        return true
                    end,
                },
                {
                    action = function()
                        leaveBooth(k)
                    end,
                    icon = 'fas fa-flag',
                    label = Lang:t('target.leave_booth'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k]['owner'] then return end
                        return true
                    end,
                },
                {
                    action = function()
                        joinBooth(k)
                    end,
                    icon = 'fas fa-circle',
                    label = Lang:t('target.join_booth'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k]['owner'] then return end
                        return true
                    end,
                },
                {
                    action = function()
                        changeBanner(k)
                    end,
                    icon = 'fas fa-recycle',
                    label = Lang:t('target.banner_change'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k]['owner'] then return end
                        return true
                    end,
                },
            },
            distance = 1.0,
        })

        exports[Config.Target]:AddBoxZone("market_register_"..k, v['register']['coords'].xyz, 1.5, 1.0, {
            name = "market_register_"..k,
            heading = v['register']['heading'],
            debugPoly = Config.Debug,
            minZ = v['register']['coords'].z - 1.0,
            maxZ = v['register']['coords'].z + 1.0,
            }, {
                options = {
                {
                    action = function()
                        marketStash(k)
                    end,
                    icon = 'fas fa-box',
                    label = Lang:t('target.register_inventory'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k]['owner'] then return end
                        return true
                    end,
                },
                {
                    action = function()
                        marketPickup(k)
                    end,
                    icon = 'fas fa-hand-holding',
                    label = Lang:t('target.register_pickup'),
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k]['owner'] then return end
                        return true
                    end,
                },
            },
            distance = 1.0,
        })
    end
end)