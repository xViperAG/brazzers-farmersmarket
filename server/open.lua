QBCore = exports[Config.Core]:GetCoreObject()

-- @param src - players source
-- @param msg - locale string
-- @param type - 'error' / 'success'
-- @param value - if the locale has a value, we push it through this param
function notification(src, msg, type, value)
    if value then return TriggerClientEvent('QBCore:Notify', src, Lang:t(msg, value), type) end
    TriggerClientEvent('QBCore:Notify', src, Lang:t(msg), type)
end