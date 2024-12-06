if GetResourceState('qbx_core') ~= 'started' then return end

local Config = require 'shared.shared'

function getIdentifier(source)
    local Player = exports.qbx_core:GetPlayer(source)
    return Player.PlayerData.citizenid
end

-- @param src - players source
-- @param msg - locale string
-- @param type - 'error' / 'success'
-- @param value - if the locale has a value, we push it through this param
function notification(src, msg, type, value)
    if value then return exports.qbx_core:Notify(src, value..' '..locale(msg), type) end
    exports.qbx_core:Notify(src, locale(msg), type)
end

if Config.Debug then print("QBOX STARTED") end