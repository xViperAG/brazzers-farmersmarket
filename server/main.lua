QBCore = exports[Config.Core]:GetCoreObject()

local function resetBooth(k)
    Config.Market[k]['owner'] = nil
    Config.Market[k]['groupMembers'] = {}
    Config.Market[k]['password'] = nil
    Config.Market[k]['boothDUI']['url'] = Config.DefaultImage
    TriggerClientEvent('brazzers-market:client:resetMarkets', -1, k)
    CreateThread(function()
        if Config.WipeStashOnLeave then
            if Config.Inventory == 'ox' then
                exports.ox_inventory:ClearInventory('market_stash'..k, '')
                exports.ox_inventory:ClearInventory('market_pickup'..k, '')
                return
            end

            MySQL.query('DELETE FROM stashitems WHERE stash = ?', {'market_stash'..k}, function(_) end)
            MySQL.query('DELETE FROM stashitems WHERE stash = ?', {'market_register'..k}, function(_) end)
        end
    end)
end

RegisterNetEvent('brazzers-market:server:setOwner', function(market, password)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market or not password then return end

    local CID = Player.PlayerData.citizenid

    if Config.Market[market]['owner'] then return notification(src, "error.already_claimed", 'error') end

    if not Config.AllowMultipleClaims then
        for _, v in pairs(Config.Market) do
            if v['owner'] == CID then
                notification(src, "error.existing_booth", 'error')
                return
            end
        end
    end

    -- Set Owner
    Config.Market[market]['owner'] = CID
    TriggerClientEvent("brazzers-market:client:updateBooth", -1, market, 'owner', CID)
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    -- Set Password
    Config.Market[market]['password'] = password
    TriggerClientEvent("brazzers-market:client:setBoothPassword", -1, market, password)
    -- Notification
    notification(src, "primary.booth_claimed")
end)

RegisterNetEvent('brazzers-market:server:setGroupMembers', function(market)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market]['owner'])
    local CID = Player.PlayerData.citizenid
    local charName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname

    if CID == Config.Market[market]['owner'] then return notification(src, "error.already_part", 'error') end
    for marketType, _ in pairs(Config.Market) do
        for groupMember, _ in pairs(Config.Market[marketType]['groupMembers']) do
            if Config.Market[marketType]['groupMembers'][groupMember] == CID then
                notification(src, "error.already_part", 'error')
                return
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market]['groupMembers'][#Config.Market[market]['groupMembers']+1] = CID
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', json.encode(Config.Market[market]['groupMembers']))
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    --Notification
    notification(src, "primary.joined_booth")
    notification(Owner.PlayerData.source, "primary.global_joined_booth", 'primary', { value = charName})
end)

RegisterNetEvent('brazzers-market:server:leaveBooth', function(market)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market]['owner'])
    local CID = Player.PlayerData.citizenid
    local charName = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname

    if Config.Market[market]['owner'] == CID then
        notification(src, "primary.disband_group")
        resetBooth(market)
        return
    end
    if not next(Config.Market[market]['groupMembers']) then return notification(src, "error.not_part", 'error') end
    for _, k in pairs(Config.Market[market]['groupMembers']) do
        if k ~= CID then
            notification(src, "error.not_part", 'error')
            return
        end
    end

    -- Get Current Members & Remove The One Leaving
    local currentGroupMembers = {}
    if Config.Market[market]['groupMembers'] then
        for k, _ in pairs(Config.Market[market]['groupMembers']) do
            if Config.Market[market]['groupMembers'][k] ~= CID then
                currentGroupMembers[#currentGroupMembers+1] = Config.Market[market]['groupMembers'][k]
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market]['groupMembers'] = currentGroupMembers
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', json.encode(Config.Market[market]['groupMembers']))
    TriggerClientEvent('brazzers-market:client:setVariable', src, false)
    -- Notification
    notification(src, "primary.left_booth")
    notification(Owner.PlayerData.source, "primary.global_left_booth", 'primary', { value = charName})
end)

RegisterNetEvent('brazzers-market:server:setBannerImage', function(market, url)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not market or not url then return end

    Config.Market[market]['boothDUI']['url'] = url
    TriggerClientEvent('brazzers-market:client:setBannerImage', -1, market, url)
end)

-- Callbacks

QBCore.Functions.CreateCallback('brazzers-market:server:groupMembers', function(source, cb, market)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local CID = Player.PlayerData.citizenid
    local groupOwner = false
    local groupMember = false

    if Config.Market[market]['owner'] == CID then groupOwner = true end
    for _, k in pairs(Config.Market[market]['groupMembers']) do
        if k == CID then
            groupMember = true
        end
    end
    cb(groupOwner, groupMember)
end)

QBCore.Functions.CreateCallback('brazzers-market:server:getMarketDui', function(_, cb)
    cb(Config.Market)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local CID = Player.PlayerData.citizenid

    if Player then
        for k, _ in pairs(Config.Market) do
            if Config.Market[k]['owner'] == CID then
                resetBooth(k)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if Config.Inventory == 'ox' then
            for k, _ in pairs(Config.Market) do
                exports.ox_inventory:RegisterStash('market_stash'..k, 'Market Stash', Config.StashSlots, Config.StashWeight, false)
                exports.ox_inventory:RegisterStash('market_pickup'..k, 'Pickup', Config.PickupSlots, Config.PickupWeight, false)
            end
        end
    end
end)