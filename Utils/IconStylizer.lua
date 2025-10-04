local private = select(2, ...)
local IconStylizer = private:GetPrototype("IconStylizer")

local CDMX = private:GetPrototype("CDMX")


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
    border:SetPoint("TOPLEFT", frame, -CDMX.Options.Border.Size, CDMX.Options.Border.Size)
    border:SetPoint("BOTTOMRIGHT", frame, CDMX.Options.Border.Size, -CDMX.Options.Border.Size)

    border:SetBackdrop({
        edgeFile = CDMX.Styles[CDMX.Options.Style].MaskTexture, -- or your own border texture
        edgeSize = CDMX.Options.Border.Size,
    })
    border:SetBackdropBorderColor(CDMX.Options.Border.ColorR, CDMX.Options.Border.ColorG, CDMX.Options.Border.ColorB, CDMX.Options.Border.ColorA)

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
    mask:SetTexture(CDMX.Styles[CDMX.Options.Style].MaskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    icon:AddMaskTexture(mask)
end

function IconStylizer:ScaleIconTexture(frame)
    local icon = frame.Icon
    if not icon then return end

    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetWidth(), CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetHeight())
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetWidth(), -CDMX.Styles[CDMX.Options.Style].IconScale * frame:GetHeight())
end