local private = select(2, ...)
local OptionsHandler = private:GetPrototype("OptionsHandler")

SLASH_CDMX1 = "/cdmx"

SlashCmdList["CDMX"] = function(msg, editBox)
    OptionsHandler:CreateOptions()
end