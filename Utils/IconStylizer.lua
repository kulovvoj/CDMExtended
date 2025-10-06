local private = select(2, ...)
local IconStylizer = private:GetPrototype("IconStylizer")

local Constants = private:GetPrototype("Constants")


function IconStylizer:RemoveOverlay(frame)
    local icon = frame.Icon
    if not icon then return end

    local regions = {frame:GetRegions()}
    for _, region in pairs(regions) do
        if region:IsObjectType("MaskTexture") then
            icon:RemoveMaskTexture(region)
        end
        if region:IsObjectType("Texture") and region:GetDrawLayer() == "OVERLAY" then
            region:Hide()
            -- Optional: prevent re-showing
            -- region.Show = function() end
        end
    end
end

function IconStylizer:RemoveBorder(frame)
    local icon = frame.Icon
    if not icon then return end

    if icon.Border then
        icon.Border:ClearAllPoints()
        icon.Border:SetParent(nil)
        icon.Border:SetBackdrop(nil)
        icon.Border:Hide()
        icon.Border = nil
    end
end

function IconStylizer:AddBorder(frame)
    local icon = frame.Icon
    if not icon then return end

    local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    border:SetPoint("TOPLEFT", frame, -CdmxDB.BorderSize, CdmxDB.BorderSize)
    border:SetPoint("BOTTOMRIGHT", frame, CdmxDB.BorderSize, -CdmxDB.BorderSize)

    border:SetBackdrop({
        edgeFile = Constants.Styles[CdmxDB.Style].MaskTexture, -- or your own border texture
        edgeSize = CdmxDB.BorderSize,
    })
    border:SetBackdropBorderColor(CdmxDB.BorderColor.r, CdmxDB.BorderColor.g, CdmxDB.BorderColor.b, CdmxDB.BorderColor.a)

    local parentStrata = frame:GetFrameStrata() or "LOW"
    local parentLevel = frame:GetFrameLevel() or 1
    border:SetFrameStrata(parentStrata)
    border:SetFrameLevel(math.max(0, parentLevel - 1))

    icon.Border = border
end

function IconStylizer:UpdateMask(frame)
    local icon = frame.Icon
    if not icon then return end

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(Constants.Styles[CdmxDB.Style].MaskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    icon:AddMaskTexture(mask)
end

function IconStylizer:ScaleIconTexture(frame)
    local icon = frame.Icon
    if not icon then return end

    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -Constants.Styles[CdmxDB.Style].IconScale * frame:GetWidth(), Constants.Styles[CdmxDB.Style].IconScale * frame:GetHeight())
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", Constants.Styles[CdmxDB.Style].IconScale * frame:GetWidth(), -Constants.Styles[CdmxDB.Style].IconScale * frame:GetHeight())
end


