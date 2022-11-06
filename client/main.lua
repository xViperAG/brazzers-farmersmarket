QBCore = exports[Config.Core]:GetCoreObject()

local inFarmersMarket = false

-- Functions
exports('inFarmersMarket', function()
    return inFarmersMarket
end)

local function isMarketOpen(market)
    return true
end

local function claimBooth(k, v)
    if isMarketOpen(v['type']) then
        if not v['owner'] then
            local dialog = exports[Config.Input]:ShowInput({
                header = "Set Booth Password",
                submitText = "Submit",
                inputs = {
                    {
                        text = "Password", 
                        name = "password", 
                        type = "password", 
                        isRequired = true, 
                    },
                }
            })
            if dialog then
                for _, password in pairs(dialog) do
                    TriggerServerEvent('brazzers-market:server:setOwner', k, password)
                end
            end
        else
            TriggerEvent("DoLongHudText", 'This booth has already been claimed!', 2)
        end
    else
        TriggerEvent("DoLongHudText", 'Market is closed!', 2)
    end
end

local function leaveBooth(k)
    TriggerServerEvent('brazzers-market:server:leaveBooth', k)
end

local function joinBooth(k, v)
    if isMarketOpen(v['type']) then
        if v['owner'] then
            local dialog = exports[Config.Input]:ShowInput({
                header = "Password",
                submitText = "Submit",
                inputs = {
                    {
                        text = "Password", 
                        name = "password", 
                        type = "password", 
                        isRequired = true, 
                    },
                }
            })
            if dialog then
                for _, password in pairs(dialog) do
                    if password == Config.Market[k]['password'] then
                        TriggerServerEvent('brazzers-market:server:setGroupMembers', k)
                    else
                        TriggerEvent("DoLongHudText", 'Password is incorrect!', 2)
                    end
                end
            end
        else
            TriggerEvent("DoLongHudText", 'This booth has not been claimed!', 2)
        end
    else
        TriggerEvent("DoLongHudText", 'Market is closed!', 2)
    end
end

local function marketStash(k, v)
    if isMarketOpen(v['type']) then
        QBCore.Functions.TriggerCallback('brazzers-market:server:groupMembers', function(IsOwner, IsInGroup)
            if IsOwner or IsInGroup then
                TriggerServerEvent("inventory:server:OpenInventory", "stash", "market_stash"..k, {
                    maxweight = 500000,
                    slots = 30,
                })
                TriggerEvent("inventory:client:SetCurrentStash", "market_stash"..k)
            end
        end, k)
    else
        TriggerEvent("DoLongHudText", 'Market is closed!', 2)
    end
end

local function marketPickup(k)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "market_register"..k, {
        maxweight = 200000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "market_register"..k)
end

-- Net Events

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
    Config.Market[market]['image'] = Config.DefaultImage
end)

RegisterNetEvent('brazzers-market:client:setVariable', function(variable)
    inFarmersMarket = variable
end)

-- Threads

CreateThread(function()
    for k, v in pairs(Config.Market) do
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
                        claimBooth(k, v)
                    end,
                    icon = 'fas fa-flag',
                    label = 'Claim Booth',
                    canInteract = function()
                        if isMarketOpen(v['type']) then
                            return true
                        end
                    end,
                },
                {
                    action = function()
                        leaveBooth(k)
                    end,
                    icon = 'fas fa-flag',
                    label = 'Leave Booth',
                    canInteract = function()
                        if isMarketOpen(v['type']) then
                            return true
                        end
                    end,
                },
                {
                    action = function()
                        joinBooth(k, v)
                    end,
                    icon = 'fas fa-circle',
                    label = 'Join Booth',
                    canInteract = function()
                        if isMarketOpen(v['type']) then
                            return true
                        end
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
                        marketStash(k, v)
                    end,
                    icon = 'fas fa-box',
                    label = 'Inventory',
                    canInteract = function()
                        if isMarketOpen(v['type']) then
                            return true
                        end
                    end,
                },
                {
                    action = function()
                        marketPickup(k)
                    end,
                    icon = 'fas fa-hand-holding',
                    label = 'Pick Up',
                    canInteract = function()
                        if isMarketOpen(v['type']) then
                            return true
                        end
                    end,
                },
            },
            distance = 1.0,
        })
    end
end)