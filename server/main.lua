local function resetBooth(k)
    Config.Market[k].owner = {}
    Config.Market[k].groupMembers = {}
    Config.Market[k].password = nil
    Config.Market[k].boothDUI.url = nil
    TriggerClientEvent('brazzers-market:client:resetMarkets', -1, k)
    CreateThread(function()
        if Config.WipeStashOnLeave then
            exports.ox_inventory:ClearInventory('market_stash'..k, '')
            exports.ox_inventory:ClearInventory('market_pickup'..k, '')
        end
    end)
end

RegisterNetEvent('brazzers-market:server:setOwner', function(market, password)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market or not password then return end

    local CID = getIdentifier(src)

    if next(Config.Market[market].owner) then return notification(src, "already_claimed", 'error') end

    if not Config.AllowMultipleClaims then
        for _, v in pairs(Config.Market) do
            if v.owner.cid == CID then
                notification(src, "existing_booth", 'error')
                return
            end
        end
    end
    -- Set Owner
    local info = {cid = CID, source = src }
    Config.Market[market].owner = info
    TriggerClientEvent("brazzers-market:client:updateBooth", -1, market, 'owner', info)
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    -- Set Password
    Config.Market[market].password = password
    TriggerClientEvent("brazzers-market:client:setBoothPassword", -1, market, password)
    -- Notification
    notification(src, "booth_claimed")
end)

RegisterNetEvent('brazzers-market:server:setGroupMembers', function(market)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market].owner.cid)
    local CID = getIdentifier(src)
    local charName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname

    if CID == Config.Market[market].owner.cid then return notification(src, "already_part", 'error') end
    for marketType, _ in pairs(Config.Market) do
        for groupMember, _ in pairs(Config.Market[marketType].groupMembers) do
            if Config.Market[marketType].groupMembers[groupMember] == CID then
                notification(src, "already_part", 'error')
                return
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market].groupMembers[#Config.Market[market].groupMembers+1] = CID
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', Config.Market[market].groupMembers)
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    --Notification
    notification(src, "joined_booth")
    notification(Owner.PlayerData.source, "global_joined_booth", 'primary', { value = charName })
end)

RegisterNetEvent('brazzers-market:server:leaveBooth', function(market)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market].owner.cid)
    local CID = getIdentifier(src)
    local charName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname

    if Config.Market[market].owner.cid == CID then
        notification(src, "disband_group")
        resetBooth(market)
        return
    end
    if not next(Config.Market[market].groupMembers) then return notification(src, "not_part", 'error') end
    for _, k in pairs(Config.Market[market].groupMembers) do
        if k ~= CID then
            notification(src, "not_part", 'error')
            return
        end
    end

    -- Get Current Members & Remove The One Leaving
    local currentGroupMembers = {}
    if Config.Market[market].groupMembers then
        for k, _ in pairs(Config.Market[market].groupMembers) do
            if Config.Market[market].groupMembers[k] ~= CID then
                currentGroupMembers[#currentGroupMembers+1] = Config.Market[market].groupMembers[k]
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market].groupMembers = currentGroupMembers
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', json.encode(Config.Market[market].groupMembers))
    TriggerClientEvent('brazzers-market:client:setVariable', src, false)
    -- Notification
    notification(src, "left_booth")
    notification(Owner.PlayerData.source, "global_left_booth", 'primary', { value = charName})
end)

RegisterNetEvent('brazzers-market:server:setBannerImage', function(market, url)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market or not url then return end

    Config.Market[market].boothDUI.url = url
    TriggerClientEvent('brazzers-market:client:setBannerImage', -1, market, url)
end)

-- Global

AddEventHandler('playerDropped', function(reason)
    for k, _ in pairs(Config.Market) do
        if Config.Market[k].owner.source == source then
            resetBooth(k)
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, _ in pairs(Config.Market) do
            exports.ox_inventory:RegisterStash('market_stash'..k, 'Market Stash', Config.StashSlots, Config.StashWeight, false)
            exports.ox_inventory:RegisterStash('market_pickup'..k, 'Pickup', Config.PickupSlots, Config.PickupWeight, false)
        end
    end
end)

-- Callbacks

lib.callback.register('brazzers-market:server:getMarkets', function(source)
    return Config.Market
end)

lib.callback.register('brazzers-farmersmarket:server:registerStashes', function(source, stash)
    exports.ox_inventory:RegisterStash('market_stash'..stash, 'Market Stash', Config.StashSlots, Config.StashWeight, false)
    exports.ox_inventory:RegisterStash('market_pickup'..stash, 'Pickup', Config.PickupSlots, Config.PickupWeight, false)
    return true
end)