local cdmFrames = {"EssentialCooldownViewer", "BuffIconCooldownViewer", "UtilityCooldownViewer"}
local iconScale = .09
local cooldownScale = .1
local listenerFrame, events = CreateFrame("FRAME", "ListenerFrame"), {}

function stringInTable(str, tbl)
    for _, v in ipairs(tbl) do
        if v == str then
            return true
        end
    end
    return false
end

function isCdmParent(frame)
    local parent = frame:GetParent()
    local name = frame:GetName()
    while parent and not stringInTable(name, cdmFrames) do
        parent = parent:GetParent()
        if parent then name = parent:GetName() end
    end
    return stringInTable(name, cdmFrames)
end

function updateIcon(frame)
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
            region.Show = function() end
        end
    end

    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\AddOns\\CDMExtended\\Media\\SquareMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    -- Apply the mask
    icon:AddMaskTexture(mask)

    if icon.Border then
        icon.Border:ClearAllPoints()
        icon.Border:SetParent(nil)
        icon.Border:SetBackdrop(nil)
        icon.Border:Hide()
        icon.Border = nil
    end

    icon.Border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    icon.Border:SetPoint("TOPLEFT", frame, -1, 1)
    icon.Border:SetPoint("BOTTOMRIGHT", frame, 1, -1)

    icon.Border:SetBackdrop({
        edgeFile = "Interface\\AddOns\\CDMExtended\\Media\\SquareMask", -- or your own border texture
        edgeSize = 1,
    })
    icon.Border:SetBackdropBorderColor(0, 0, 0, 1)

    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -iconScale * frame:GetWidth(), iconScale * frame:GetHeight())
    icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", iconScale * frame:GetWidth(), -iconScale * frame:GetHeight())
end

function updateCooldown(frame)
    local cooldown = frame.Cooldown
    if not cooldown then return end

    local mask = frame:CreateMaskTexture()
    mask:SetTexture("Interface\\AddOns\\CDMExtended\\Media\\SquareMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    mask:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    -- Apply the mask
    cooldown:ClearAllPoints()
    cooldown:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    cooldown:SetSwipeTexture("Interface\\AddOns\\CDMExtended\\Media\\SquareMask")
end

function updateCooldownFlash(frame)
    local cooldownFlash = frame.CooldownFlash
    local icon = frame.Icon
    if not cooldownFlash or not icon then return end

    cooldownFlash:ClearAllPoints()
    cooldownFlash:SetPoint("TOPLEFT", frame, "TOPLEFT", -iconScale * frame:GetWidth(), iconScale * frame:GetHeight())
    cooldownFlash:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", iconScale * frame:GetWidth(), -iconScale * frame:GetHeight())
end

function updateChargeCount(frame)
    local chargeCount = frame.ChargeCount
    if not chargeCount then return end
    local current = chargeCount.Current
    if not current then return end

    local _, _, fontFlags = current:GetFont()
    current:SetFont("Fonts\\FRIZQT__.TTF", 18, fontFlags)

    current:ClearAllPoints()
    current:SetPoint("TOP", frame, "TOP", 0, 9)
end

function updateApplications(frame)
    local applications = frame.Applications
    if not applications then return end
    local current = applications.Applications
    if not current then return end

    local _, _, fontFlags = current:GetFont()
    current:SetFont("Fonts\\FRIZQT__.TTF", 18, fontFlags)

    current:ClearAllPoints()
    current:SetPoint("TOP", frame, "TOP", 0, 9)
end

-- Scales the glow to fit within the frame
hooksecurefunc(ActionButtonSpellAlertMixin, 'OnLoad', function(self)
    hooksecurefunc(self, 'SetSize', function(self)
        if not isCdmParent(self) then return end
        if stringInTable(name, cdmFrames) then
            self:SetScale(0.95)
        end
    end)
end)

function OnPlayerLogin()
    StylizeAllCDMIcons()
end

function StylizeCDMIcon(frame)
    updateIcon(frame)
    updateCooldown(frame)
    updateCooldownFlash(frame)
    updateChargeCount(frame)
    updateApplications(frame)
end

function StylizeAllCDMIcons()
    for _, frameName in pairs(cdmFrames) do
        local frame = _G[frameName]
        if frame then
            if frame.RefreshLayout then
                frame.iconPadding = 1
                frame.iconScale = 1
                frame.iconDirection = 2
            end

            for _, frame in ipairs({frame:GetChildren()}) do
                StylizeCDMIcon(frame)
            end
            frame:RefreshLayout()
        end
    end
end

function events:PLAYER_LOGIN()
    OnPlayerLogin()
end

listenerFrame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
    listenerFrame:RegisterEvent(k); -- Register all events for which handlers have been defined
end