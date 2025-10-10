local private = select(2, ...)
local Utils = private:GetPrototype("Utils")

local Constants = private:GetPrototype("Constants")

function Utils.TableIncludesValue(table, value)
    local includesValue = false
    for _, v in pairs(table) do
        if v == value then
            includesValue = true
        end
    end
    return includesValue
end


function Utils.IsCdmParent(frame)
    local parent = frame:GetParent()
    local name = frame:GetName()
    while parent and not Utils.TableIncludesValue(Constants.CdmFramesEnum, name) do
        parent = parent:GetParent()
        if parent then name = parent:GetName() end
    end
    return Utils.TableIncludesValue(Constants.CdmFramesEnum, name)
end