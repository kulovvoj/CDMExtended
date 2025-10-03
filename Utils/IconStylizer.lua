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

function IconStylizer:UpdateMask(frame)
    local icon = frame.Icon
    if not icon then return end

    local mask = frame:CreateMaskTexture()
    mask:SetTexture(CDMX.Borders[CDMX.Options.Border].MaskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    icon:AddMaskTexture(mask)
end

function IconStylizer:AddBorder(frame)
    local icon = frame.Icon
    if not icon then return end

    icon.Border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    icon.Border:SetPoint("TOPLEFT", frame, -1, 1)
    icon.Border:SetPoint("BOTTOMRIGHT", frame, 1, -1)

    icon.Border:SetBackdrop({
        edgeFile = CDMX.Borders[CDMX.Options.Border].MaskTexture, -- or your own border texture
        edgeSize = 1,
    })
    icon.Border:SetBackdropBorderColor(0, 0, 0, 1)
end

function IconStylizer:ScaleIconTexture(frame)
    local icon = frame.Icon
    if not icon then return end

    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetWidth(), CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetHeight())
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetWidth(), -CDMX.Borders[CDMX.Options.Border].IconScale * frame:GetHeight())
end