QBCore = exports[Config.Core]:GetCoreObject()

-- You can use this function if you want to add ClockHours to determine if the market is open or not
-- or any other shit you want to add inside this function
function isMarketOpen()
    return true
end

-- @param msg - locale string
-- @param type - 'error' / 'success'
function notification(msg, type)
    QBCore.Functions.Notify(Lang:t(msg), type)
end