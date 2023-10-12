if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function notification(msg, type)
    ESX.ShowNotification(Config.Language[msg], type)
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text, type)
    notification(text, type)
end)