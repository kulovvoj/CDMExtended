local private = select(2, ...)
local CDMX = private:GetPrototype("CDMX")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")

CDMX.DefaultOptions = {
    Border = "Clean",
    Stacks = {
        Anchor = "TOP",
        XOffset = 0,
        YOffset = 9,
        Font = "Fonts\\FRIZQT__.TTF",
        FontSize = 18
    }
}
CDMX.CdmFrames = {"EssentialCooldownViewer", "BuffIconCooldownViewer", "UtilityCooldownViewer"}
CDMX.Borders = {
    Clean = {
        IconScale = .09,
        MaskTexture = "Interface\\AddOns\\CDMExtended\\Media\\SquareMask"
    }
}
CDMX.Options = CDMX.DefaultOptions
CDMX.EventListener, CDMX.Events = CreateFrame("FRAME", "CDMX_EventListener"), {}

function isStringInTable(str, tbl)
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
    while parent and not isStringInTable(name, CDMX.CdmFrames) do
        parent = parent:GetParent()
        if parent then name = parent:GetName() end
    end
    return isStringInTable(name, CDMX.CdmFrames)
end

-- Scales the glow to fit within the frame
hooksecurefunc(ActionButtonSpellAlertMixin, 'OnLoad', function(self)
    hooksecurefunc(self, 'SetSize', function(self)
        if not isCdmParent(self) then return end
        if isStringInTable(name, CDMX.CdmFrames) then
            self:SetScale(0.95)
        end
    end)
end)

function OnPlayerLogin()
    StylizeAllCDMIcons()
end

function StylizeCDMIcon(frame)
    IconStylizer:RemoveOverlay(frame)
    IconStylizer:RemoveBorder(frame)
    IconStylizer:UpdateMask(frame)
    IconStylizer:AddBorder(frame)
    IconStylizer:ScaleIconTexture(frame)
    CooldownStylizer:UpdateMask(frame)
    CooldownStylizer:UpdateCooldownFlash(frame)
    StacksStylizer:UpdateFont(frame)
    StacksStylizer:UpdatePosition(frame)
end

function StylizeAllCDMIcons()
    for _, frameName in pairs(CDMX.CdmFrames) do
        local frame = _G[frameName]
        if frame then
            if frame.RefreshLayout then
                frame.iconPadding = 1
                frame.iconScale = 1
                frame.iconDirection = 2
            end

            for _, child in ipairs({frame:GetChildren()}) do
                StylizeCDMIcon(child)
            end
            frame:RefreshLayout()
        end
    end
end

-- Define event handlers here
function CDMX.Events:PLAYER_LOGIN()
    OnPlayerLogin()
end

-- Handles all events for which handlers have been defined
CDMX.EventListener:SetScript("OnEvent", function(self, event, ...)
    CDMX.Events[event](self, ...); -- call one of the functions above
end);

-- Register all events for which handlers have been defined
for event in pairs(CDMX.Events) do
    CDMX.EventListener:RegisterEvent(event);
end