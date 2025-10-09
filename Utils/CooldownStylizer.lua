local private = select(2, ...)
local CooldownStylizer = private:GetPrototype("CooldownStylizer")

local Constants = private:GetPrototype("Constants")
local SafetyUtils = private:GetPrototype("SafetyUtils")

function CooldownStylizer.UpdateMask(frame, category)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local cooldown = frame.Cooldown
    if type(cooldown) ~= "table" then return end

    cooldown:ClearAllPoints()
    cooldown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    if cooldown.SetSwipeTexture then
        cooldown:SetSwipeTexture(Constants.Styles[CdmxDB[category].Style].MaskTexture)
    end
end

function CooldownStylizer.UpdateFont(frame, category)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local cooldown = frame.Cooldown
    if type(cooldown) ~= "table" then return end

    local regions = cooldown:GetRegions()
    for _, region in pairs({ regions }) do
        if type(region) == "table" and not SafetyUtils:IsForbidden(frame) and region.GetFont and region.SetFont then
            local _, _, fontFlags = region:GetFont()
            region:SetFont(CdmxDB[category].Font, CdmxDB[category].CooldownFontSize, fontFlags)
        end
    end
end

function CooldownStylizer.UpdateCooldownFlash(frame, category)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local cooldownFlash = frame.CooldownFlash
    local icon = frame.Icon
    if type(cooldownFlash) ~= "table" or type(icon) ~= "table" then return end

    local width = SafetyUtils:SafeCall(frame, "GetWidth") or 0
    local height = SafetyUtils:SafeCall(frame, "GetHeight") or 0
    local xOffset, yOffset = Constants.Styles[CdmxDB[category].Style].IconScale * width, Constants.Styles[CdmxDB[category].Style].IconScale * height

    cooldownFlash:ClearAllPoints()
    cooldownFlash:SetPoint("TOPLEFT",     frame, "TOPLEFT",     -xOffset,  yOffset)
    cooldownFlash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",  xOffset, -yOffset)
end