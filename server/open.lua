QBCore = exports[Config.Core]:GetCoreObject()

function notification(src, msg, type, param)
    if param then return TriggerClientEvent('QBCore:Notify', src, Lang:t(msg, param), type) end
    TriggerClientEvent('QBCore:Notify', src, Lang:t(msg), type)
end