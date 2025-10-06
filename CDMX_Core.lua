local private = select(2, ...)
local CDMX = private:GetPrototype("CDMX")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")
local Constants = private:GetPrototype("Constants")
local UserInterfaceMixins = private:GetPrototype("UserInterfaceMixins")
local FontInitializer = private:GetPrototype("FontInitializer")

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
    while parent and not isStringInTable(name, Constants.CdmFrames) do
        parent = parent:GetParent()
        if parent then name = parent:GetName() end
    end
    return isStringInTable(name, Constants.CdmFrames)
end

-- Scales the glow to fit within the frame
hooksecurefunc(ActionButtonSpellAlertMixin, 'OnLoad', function(self)
    hooksecurefunc(self, 'SetSize', function(self)
        if not isCdmParent(self) then return end
        if isStringInTable(name, Constants.CdmFrames) then
            self:SetScale(0.95)
        end
    end)
end)

hooksecurefunc(UserInterfaceMixins.SettingsFrameMixin, 'SetSettingValue', function(self, id)
    StylizeAllCDMIcons()
end)

local function CopyDefaultsToDB(src, dest)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            CopyDefaultsToDB(v, dest[k])
        else
            if dest[k] == nil then
                dest[k] = v
            end
        end
    end
end

function OnPlayerLogin()
    if CdmxDB == nil then
        CdmxDB = {};
    end
    Constants:Initialize()
    CopyDefaultsToDB(Constants.DefaultOptions, CdmxDB)
    FontInitializer:Initialize()
    StylizeAllCDMIcons(true)
end

function StylizeCDMIcon(frame, isInit)
    if isInit then
        IconStylizer:RemoveOverlay(frame)
        IconStylizer:UpdateMask(frame)
        IconStylizer:ScaleIconTexture(frame)
        CooldownStylizer:UpdateMask(frame)
        CooldownStylizer:UpdateCooldownFlash(frame)
    end
    IconStylizer:RemoveBorder(frame)
    if CdmxDB.BorderShown then
        IconStylizer:AddBorder(frame)
    end
    StacksStylizer:UpdatePosition(frame)
    StacksStylizer:UpdateFont(frame)
    CooldownStylizer:UpdateFont(frame)
end

function StylizeAllCDMIcons(isInit)
    for _, frameName in pairs(Constants.CdmFrames) do
        local frame = _G[frameName]
        if frame then
            if frame.RefreshLayout then
                frame.iconPadding = CdmxDB.Padding
            end

            for _, child in ipairs({frame:GetChildren()}) do
                StylizeCDMIcon(child, isInit)
            end
            frame:RefreshLayout()
        end
    end
end

-- Define event handlers here
function CDMX.Events:PLAYER_ENTERING_WORLD()
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