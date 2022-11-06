QBCore = exports[Config.Core]:GetCoreObject()

local function resetBooth(k)
    Config.Market[k]['owner'] = nil
    Config.Market[k]['groupMembers'] = {}
    Config.Market[k]['password'] = nil
    Config.Market[k]['image'] = Config.DefaultImage
    TriggerClientEvent('brazzers-market:client:resetMarkets', -1, k)
    CreateThread(function()
        MySQL.query('DELETE FROM stashitems WHERE stash = @stash', {['@stash'] = 'market_stash'..k}, function(result) end)
        MySQL.query('DELETE FROM stashitems WHERE stash = @stash', {['@stash'] = 'market_register'..k}, function(result) end)
    end)
end

RegisterNetEvent('brazzers-market:server:setOwner', function(market, password)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local citizenId = Player.PlayerData.citizenid
    local claimBooth = exports['5life-businesses']:canClaimBooth(citizenId)
    if not claimBooth then return TriggerClientEvent('DoLongHudText', src, 'You cannot claim this booth', 2) end

    if Config.Market[market]['owner'] then return TriggerClientEvent("DoLongHudText", src, 'This booth has already been claimed!', 2) end

    for _, v in pairs(Config.Market) do
        if v['owner'] == citizenId then
            TriggerClientEvent("DoLongHudText", src, 'You already have a claimed booth!', 2)
            return
        end
    end

    -- Set Owner
    Config.Market[market]['owner'] = citizenId
    TriggerClientEvent("brazzers-market:client:updateBooth", -1, market, 'owner', citizenId)
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    -- Set Password
    Config.Market[market]['password'] = password
    TriggerClientEvent("brazzers-market:client:setBoothPassword", -1, market, password)
    -- Notification
    TriggerClientEvent("DoLongHudText", src, 'You have claimed a booth!')
end)

RegisterNetEvent('brazzers-market:server:setGroupMembers', function(market)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market]['owner'])
    local citizenId = Player.PlayerData.citizenid

    if citizenId == Config.Market[market]['owner'] then return TriggerClientEvent("DoLongHudText", src, 'You\'re already part of this booth', 2) end    
    for marketType, _ in pairs(Config.Market) do
        for groupMember, _ in pairs(Config.Market[marketType]['groupMembers']) do
            if Config.Market[marketType]['groupMembers'][groupMember] == citizenId then
                TriggerClientEvent("DoLongHudText", src, 'You\'re already part of a booth!', 2)
                return
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market]['groupMembers'][#Config.Market[market]['groupMembers']+1] = citizenId
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', json.encode(Config.Market[market]['groupMembers']))
    TriggerClientEvent('brazzers-market:client:setVariable', src, true)
    --Notification
    TriggerClientEvent("DoLongHudText", src, 'You joined the booth!')
    TriggerClientEvent("DoLongHudText", Owner.PlayerData.source, Player.PlayerData.charinfo.firstname..' joined the booth!')
end)

RegisterNetEvent('brazzers-market:server:leaveBooth', function(market)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market]['owner'])
    local citizenId = Player.PlayerData.citizenid

    if Config.Market[market]['owner'] == citizenId then 
        TriggerClientEvent("DoLongHudText", src, 'Booth Disbanded!', 2)
        resetBooth(market)
        return 
    end
    if not next(Config.Market[market]['groupMembers']) then return TriggerClientEvent("DoLongHudText", src, 'You\'re not part of this booth!', 2) end
    for _, k in pairs(Config.Market[market]['groupMembers']) do
        if k ~= citizenId then
            TriggerClientEvent("DoLongHudText", src, 'You\'re not part of this booth!', 2)
            return
        end
    end

    -- Get Current Members & Remove The One Leaving
    local currentGroupMembers = {}
    if Config.Market[market]['groupMembers'] then
        for k, _ in pairs(Config.Market[market]['groupMembers']) do
            if Config.Market[market]['groupMembers'][k] ~= citizenId then
                currentGroupMembers[#currentGroupMembers+1] = Config.Market[market]['groupMembers'][k]
            end
        end
    end

    -- Update Group Members Table
    Config.Market[market]['groupMembers'] = currentGroupMembers
    TriggerClientEvent('brazzers-market:client:updateBooth', -1, market, 'groupMembers', json.encode(Config.Market[market]['groupMembers']))
    TriggerClientEvent('brazzers-market:client:setVariable', src, false)
    -- Notification
    TriggerClientEvent("DoLongHudText", src, 'You left the booth!')
    TriggerClientEvent("DoLongHudText", Owner.PlayerData.source, Player.PlayerData.charinfo.firstname..' left the booth!')
end)

RegisterNetEvent('brazzers-market:server:resetMarkets', function()
    local src = source
    if not src then return end

    for k, _ in pairs(Config.Market) do
        resetBooth(k)
        TriggerClientEvent('brazzers-market:client:setVariable', src, false)
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('brazzers-market:server:groupMembers', function(source, cb, market)
    local src = source
    if not src then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local Owner = QBCore.Functions.GetPlayerByCitizenId(Config.Market[market]['owner'])
    local citizenId = Player.PlayerData.citizenid

    local groupOwner = false
    local groupMember = false

    if Config.Market[market]['owner'] == citizenId then groupOwner = true end
    for _, k in pairs(Config.Market[market]['groupMembers']) do
        if k == citizenId then
            groupMember = true
        end
    end
    cb(groupOwner, groupMember)
end)