if GetResourceState('qbx_core') ~= 'started' then return end

---@param msg string - locale string
---@param type string - 'error' / 'success'
function notification(msg, type)
    exports.qbx_core:Notify(locale(msg), type)
end