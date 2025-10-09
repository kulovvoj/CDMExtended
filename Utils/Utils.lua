local private = select(2, ...)
local Utils = private:GetPrototype("Utils")

function Utils:TableIncludesValue(table, value)
    local includesValue = false
        for _, v in pairs(table) do
            if v == value then
                includesValue = true
            end
        end
    return includesValue
end
