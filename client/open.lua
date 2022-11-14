QBCore = exports[Config.Core]:GetCoreObject()

function isMarketOpen()
    return true
end

function notification(msg, type)
    QBCore.Functions.Notify(Lang:t(msg), type)
end