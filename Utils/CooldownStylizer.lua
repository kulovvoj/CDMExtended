local private = select(2, ...)
local CooldownStylizer = private:GetPrototype("CooldownStylizer")

local CDMX = private:GetPrototype("CDMX")

function CooldownStylizer:UpdateMask(frame)
    local cooldown = frame.Cooldown
    if not cooldown then return end

    cooldown:ClearAllPoints()
    cooldown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    cooldown:SetSwipeTexture(CDMX.Styles[CDMX.Options.Style].MaskTexture)
end

function CooldownStylizer:UpdateCooldownFlash(frame)
    local cooldownFlash = frame.CooldownFlash
    local icon = frame.Icon
    if not cooldownFlash or not icon then return end

    cooldownFlash:ClearAllPoints()
    cooldownFlash:SetPoint("TOPLEFT", frame, "TOPLEFT", -CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetWidth(), CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetHeight())
    cooldownFlash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetWidth(), -CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetHeight())
end