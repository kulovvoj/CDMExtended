local private = select(2, ...)
local CooldownStylizer = private:GetPrototype("CooldownStylizer")

local CDMX = private:GetPrototype("CDMX")

function CooldownStylizer:UpdateMask(frame)
    local cooldown = frame.Cooldown
    if not cooldown then return end

    cooldown:ClearAllPoints()
    cooldown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    cooldown:SetSwipeTexture(CDMX.Borders[CDMX.Options.Border].MaskTexture)
end

function CooldownStylizer:UpdateCooldownFlash(frame)
    local cooldownFlash = frame.CooldownFlash
    local icon = frame.Icon
    if not cooldownFlash or not icon then return end

    cooldownFlash:ClearAllPoints()
    cooldownFlash:SetPoint("TOPLEFT", frame, "TOPLEFT", -CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetWidth(), CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetHeight())
    cooldownFlash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetWidth(), -CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetHeight())
end