local private = select(2, ...)
local UserInterfaceUtils = private:GetPrototype("UserInterfaceUtils")

local UserInterfaceMixins = private:GetPrototype("UserInterfaceMixins")

function UserInterfaceUtils:CreateWindow(width, height)
    local frame = CreateFrame("Frame", "MyUIFrame", UIParent, "BackdropTemplate")
    Mixin(frame, UserInterfaceMixins.OptionsMixin)

    frame:OnLoad()
    frame:SetSize(width, height)

    return frame
end

function UserInterfaceUtils.FormatPercentage(value)
    return FormatPercentage(value, true)
end

function UserInterfaceUtils.FormatNumber(value)
    return tostring(Round(value))
end
