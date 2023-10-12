if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

-- @param msg - locale string
-- @param type - 'error' / 'success'
function notification(msg, type)
    QBCore.Functions.Notify(Config.Language[msg], type)
end

