local Config = require 'shared.shared'

local inFarmersMarket = false
local inZone = false

-- Functions

exports('inFarmersMarket', function() return inFarmersMarket end)

local function CreateDUI(market, url)
    Config.Market[market].boothDUI.dui = {
        obj = CreateDui(url, Config.Market[market].boothDUI.width, Config.Market[market].boothDUI.height),
    }

    Config.Market[market].boothDUI.dui.dict = ("%s-dict"):format(market)
    Config.Market[market].boothDUI.dui.texture = ("%s-txt"):format(market)
    local dictObject = CreateRuntimeTxd(Config.Market[market].boothDUI.dui.dict)
    local duiHandle = GetDuiHandle(Config.Market[market].boothDUI.dui.obj)
    CreateRuntimeTextureFromDuiHandle(dictObject, Config.Market[market].boothDUI.dui.texture, duiHandle)
    AddReplaceTexture(Config.Market[market].boothDUI.ytd, Config.Market[market].boothDUI.ytdname, Config.Market[market].boothDUI.dui.dict, Config.Market[market].boothDUI.dui.texture)
end

local function removeDUI(market, removeAll)
    if not Config.Market[market].boothDUI.dui then return end
    SetDuiUrl(Config.Market[market].boothDUI.dui.obj, Config.DefaultImage)
    if removeAll then
        DestroyDui(Config.Market[market].boothDUI.dui.obj)
        RemoveReplaceTexture(Config.Market[market].boothDUI.ytd, Config.Market[market].boothDUI.ytdname)
    end
    Config.Market[market].boothDUI.dui = nil
end

local function partOfBooth(booth)
    local retval, cid = false, exports['Renewed-Lib']:getCharId()

    if Config.Market[booth].owner.cid == cid then
        retval = true
    end

    for _, v in pairs(Config.Market[booth].groupMembers) do
        if v == cid then
            retval = true
        end
    end

    return retval
end

local function initLoad()
    local coords = Config.PierPoly

    local function onEnter()
        inZone = true
        for k, _ in pairs(Config.Market) do
            CreateDUI(k, Config.Market[k].boothDUI.url)
        end
    end

    local function onExit()
        inZone = false
        for k, _ in pairs(Config.Market) do
            removeDUI(k, true)
        end
    end

    local zone = lib.zones.sphere({
        coords = vec3(coords.x, coords.y, coords.z),
        radius = Config.PierRadius,
        debug = Config.Debug,
        onEnter = onEnter,
        onExit = onExit,
    })
end

local function claimBooth(k)
    if not isMarketOpen() then return notification("market_not_open", "error") end
    if Config.Market[k].owner.cid then return notification("already_claimed", "error") end

    local input = lib.inputDialog(locale('input_password'), {locale('set_password')})
    if not input then return end

    local password = tonumber(input[1])
    if not password then return notification("password_not_number", "error") end

    TriggerServerEvent('brazzers-market:server:setOwner', k, password)
end

local function leaveBooth(k)
    TriggerServerEvent('brazzers-market:server:leaveBooth', k)
end

local function joinBooth(k)
    if not isMarketOpen() then return notification("market_not_open", "error") end
    if not Config.Market[k].owner.cid then return notification("not_claimed", "error") end

    local input = lib.inputDialog(locale('input_password'), {locale('password')})
    if not input then return end

    local password = tonumber(input[1])
    if not password then return notification("password_not_number", "error") end

    if password ~= Config.Market[k]['password'] then return notification("incorrect_password", "error") end
    TriggerServerEvent('brazzers-market:server:setGroupMembers', k)
end

local function changeBanner(k)
    if not isMarketOpen() then return notification("market_not_open", "error") end

    local result = partOfBooth(k)
    if not result then return TriggerEvent('DoLongHudText', 'Not part of booth', 2) end

    local input = lib.inputDialog(locale('change_banner'), {locale('banner_url')})
    if not input then return end

    local banner = input[1]
    if not banner then return end
    TriggerServerEvent('brazzers-market:server:setBannerImage', k, banner)
end

local function marketStash(k)
    if not isMarketOpen() then return notification("market_not_open", "error") end

    local result = partOfBooth(k)
    if not result then return TriggerEvent('DoLongHudText', 'Not part of booth', 2) end

    if not exports.ox_inventory:openInventory('stash', 'market_stash'..k) then
        local success = lib.callback.await('brazzers-farmersmarket:server:registerStashes', false, k)
        if not success then return end
        exports.ox_inventory:openInventory('stash', 'market_stash'..k)
    end
end

local function marketPickup(k)
    if not exports.ox_inventory:openInventory('stash', 'market_pickup'..k) then
        local success = lib.callback.await('brazzers-farmersmarket:server:registerStashes', false, k)
        if not success then return end
        exports.ox_inventory:openInventory('stash', 'market_pickup'..k)
    end
end

-- Global

CreateThread(function()
    local data = lib.callback.await('brazzers-market:server:getMarkets')
    Config.Market = data
    initLoad()
end)

-- Events

RegisterNetEvent('brazzers-market:client:updateBooth', function(market, type, citizenid)
    Config.Market[market][type] = citizenid
end)

RegisterNetEvent('brazzers-market:client:setBoothPassword', function(market, password)
    Config.Market[market].password = password
end)

RegisterNetEvent('brazzers-market:client:resetMarkets', function(market)
    Config.Market[market].owner = {}
    Config.Market[market].groupMembers = {}
    Config.Market[market].password = nil
    Config.Market[market].boothDUI.url = Config.DefaultImage
    removeDUI(market, false)
end)

RegisterNetEvent('brazzers-market:client:setVariable', function(variable)
    inFarmersMarket = variable
end)

RegisterNetEvent('brazzers-market:client:setBannerImage', function(market, url)
    Config.Market[market]['boothDUI']['url'] = url

    if Config.Market[market].boothDUI.dui then
        SetDuiUrl(Config.Market[market].boothDUI.dui.obj, Config.Market[market].boothDUI.url)
    else
        CreateDUI(market, url)
    end
end)

-- Threads

CreateThread(function()
    if Config.ClearPeds then
        while inZone do
            ClearAreaOfPeds(Config.PierPoly.x, Config.PierPoly.y, Config.PierPoly.z, Config.PierRadius, false, false, false, false, false)
            Wait(100)
        end
    end
end)

CreateThread(function()
    for k, v in pairs(Config.Market) do
        exports.ox_target:addBoxZone({
            coords = v.booth.coords.xyz,
            size = vec3(1.0, 3.0, 1.0),
            rotation = 135,
            debug = Config.Debug,
            options = {
                {
                    name = "market_booth_"..k,
                    icon = 'fas fa-flag',
                    label = 'Claim Booth',
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
                    label = 'Leave Booth',
                    onSelect = function()
                        leaveBooth(k)
                    end,
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k].owner.cid then return end
                        return true
                    end,
                },
                {
                    name = "market_booth_"..k,
                    icon = 'fas fa-circle',
                    label = 'Join Booth',
                    onSelect = function()
                        joinBooth(k)
                    end,
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k].owner.cid then return end
                        return true
                    end,
                },
                {
                    name = "market_booth_"..k,
                    icon = 'fas fa-recycle',
                    label = 'Change Banner',
                    onSelect = function()
                        changeBanner(k)
                    end,
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k].owner.cid then return end
                        return true
                    end,
                },
            }
        })

        exports.ox_target:addBoxZone({
            coords = v.register.coords.xyz,
            size = vec3(1.5, 1.0, 1.0),
            rotation = 135,
            debug = Config.Debug,
            options = {
                {
                    name = "market_register_"..k,
                    icon = 'fas fa-box',
                    label = 'Inventory',
                    onSelect = function()
                        marketStash(k)
                    end,
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k].owner.cid then return end
                        return true
                    end,
                },
                {
                    name = "market_register_"..k,
                    icon = 'fas fa-hand-holding',
                    label = 'Pick Up',
                    onSelect = function()
                        marketPickup(k)
                    end,
                    canInteract = function()
                        if not isMarketOpen() then return end
                        if not Config.Market[k].owner.cid then return end
                        return true
                    end,
                },
            }
        })
    end
end)