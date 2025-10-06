local private = select(2, ...)
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local Constants = private:GetPrototype("Constants")

function CooldownStylizer:UpdateMask(frame)
    local cooldown = frame.Cooldown
    if not cooldown then return end

    cooldown:ClearAllPoints()
    cooldown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    cooldown:SetSwipeTexture(Constants.Styles[CdmxDB.Style].MaskTexture)
end

function CooldownStylizer:UpdateFont(frame)
    local cooldown = frame.Cooldown
    if not cooldown then return end
    local regions = cooldown:GetRegions()

    for _, region in pairs({ regions }) do
        if region.GetFont and region.SetFont then
            local _, _, fontFlags = region:GetFont()
            region:SetFont(CdmxDB.Font, CdmxDB.CooldownFontSize, fontFlags)
        end
    end
end

function CooldownStylizer:UpdateCooldownFlash(frame)
    local cooldownFlash = frame.CooldownFlash
    local icon = frame.Icon
    if not cooldownFlash or not icon then return end

    cooldownFlash:ClearAllPoints()
    cooldownFlash:SetPoint("TOPLEFT", frame, "TOPLEFT", -Constants.Styles[CdmxDB.Style].IconScale * frame:GetWidth(), Constants.Styles[CdmxDB.Style].IconScale * frame:GetHeight())
    cooldownFlash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", Constants.Styles[CdmxDB.Style].IconScale * frame:GetWidth(), -Constants.Styles[CdmxDB.Style].IconScale * frame:GetHeight())
end