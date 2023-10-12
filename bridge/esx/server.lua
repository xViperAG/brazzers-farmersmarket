if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function getIdentifier(source)
    local Player = ESX.GetPlayerFromId(source)
    return Player.identifier
end

-- @param src - players source
-- @param msg - locale string
-- @param type - 'error' / 'success'
-- @param value - if the locale has a value, we push it through this param
function notification(src, msg, type, value)
    if value then return     TriggerClientEvent(GetCurrentResourceName()..":showNotification", src, value..' '..Config.Language[msg], type) end
    TriggerClientEvent(GetCurrentResourceName()..":showNotification", src, Config.Language[msg], type)
end

if Config.Debug then print("ESX STARTED") end