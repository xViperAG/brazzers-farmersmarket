if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function getIdentifier(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.citizenid
end

-- @param src - players source
-- @param msg - locale string
-- @param type - 'error' / 'success'
-- @param value - if the locale has a value, we push it through this param
function notification(src, msg, type, value)
    if value then return TriggerClientEvent('QBCore:Notify', src, value..' '..Config.Language[msg], type) end
    TriggerClientEvent('QBCore:Notify', src, Config.Language[msg], type)
end

if Config.Debug then print("QBCORE STARTED") end