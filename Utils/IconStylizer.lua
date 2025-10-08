local private = select(2, ...)
local IconStylizer = private:GetPrototype("IconStylizer")

local Constants = private:GetPrototype("Constants")
local SafetyUtils = private:GetPrototype("SafetyUtils")

function IconStylizer.RemoveOverlay(frame)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local icon = frame.Icon
    if type(icon) ~= "table" then return end

    local regions = {frame:GetRegions()}
    for _, region in pairs(regions) do
        if type(region) == "table" and not SafetyUtils:IsForbidden(region) then
            if region.IsObjectType and region:IsObjectType("MaskTexture") then
                icon:RemoveMaskTexture(region)
            elseif region.IsObjectType and region.GetDrawLayer and region:IsObjectType("Texture") and region:GetDrawLayer() == "OVERLAY" then
                local a = SafetyUtils:SafeCall(region, "GetAtlas")
                if SafetyUtils:IsIconEmbossAtlas(a) then
                    region:Hide()
                end
            end
        end
    end
end

function IconStylizer.RemoveBorder(frame)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local icon = frame.Icon
    if type(icon) ~= "table" then return end

    if icon.Border then
        icon.Border:ClearAllPoints()
        icon.Border:SetParent(nil)
        icon.Border:SetBackdrop(nil)
        icon.Border:Hide()
        icon.Border = nil
    end
end

function IconStylizer.AddBorder(frame, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) or not CdmxDB[frameName].BorderShown then return end
    local icon = frame.Icon
    if type(icon) ~= "table" then return end

    local border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    border:EnableMouse(false)
    border:SetBackdrop({
        edgeFile = Constants.Styles[CdmxDB[frameName].Style].MaskTexture, -- or your own border texture
        edgeSize = CdmxDB[frameName].BorderSize,
    })
    border:SetBackdropBorderColor(CdmxDB[frameName].BorderColor.r, CdmxDB[frameName].BorderColor.g, CdmxDB[frameName].BorderColor.b, CdmxDB[frameName].BorderColor.a)

    local parentStrata = frame:GetFrameStrata() or "LOW"
    local parentLevel = frame:GetFrameLevel() or 1
    border:SetFrameStrata(parentStrata)
    border:SetFrameLevel(math.max(0, parentLevel - 1))

    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", frame, -CdmxDB[frameName].BorderSize, CdmxDB[frameName].BorderSize)
    border:SetPoint("BOTTOMRIGHT", frame, CdmxDB[frameName].BorderSize, -CdmxDB[frameName].BorderSize)

    icon.Border = border
end

function IconStylizer.UpdateMask(frame, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local icon = frame.Icon
    if type(icon) ~= "table" then return end

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(Constants.Styles[CdmxDB[frameName].Style].MaskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    if icon.AddMaskTexture then
        icon:AddMaskTexture(mask)
    end
end

function IconStylizer.ScaleIconTexture(frame, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local icon = frame.Icon
    if type(icon) ~= "table" then return end

    local width = SafetyUtils:SafeCall(frame, "GetWidth") or 0
    local height = SafetyUtils:SafeCall(frame, "GetHeight") or 0
    local xOffset, yOffset = Constants.Styles[CdmxDB[frameName].Style].IconScale * width, Constants.Styles[CdmxDB[frameName].Style].IconScale * height

    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT",     frame, "TOPLEFT",     -xOffset,  yOffset)
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",  xOffset, -yOffset)
end