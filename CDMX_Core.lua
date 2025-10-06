local private = select(2, ...)
local CDMX = private:GetPrototype("CDMX")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")
local Constants = private:GetPrototype("Constants")
local UserInterfaceMixins = private:GetPrototype("UserInterfaceMixins")
local FontInitializer = private:GetPrototype("FontInitializer")
local SafetyUtils = private:GetPrototype("SafetyUtils")

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
    while parent and not isStringInTable(name, Constants.CdmFramesEnum) do
        parent = parent:GetParent()
        if parent then name = parent:GetName() end
    end
    return isStringInTable(name, Constants.CdmFramesEnum)
end

-- Scales the glow to fit within the frame
hooksecurefunc(ActionButtonSpellAlertMixin, 'OnLoad', function(self)
    hooksecurefunc(self, 'SetSize', function(self)
        if not isCdmParent(self) then return end
        self:SetScale(0.95)
    end)
end)

hooksecurefunc(UserInterfaceMixins.SettingsFrameMixin, 'SetSettingValue', function(_, id)
    for _, setting in ipairs(Constants.Settings) do
        if setting.id == id and setting.stylizers then
            StylizeFrameCooldowns(Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER, setting.stylizers)
            StylizeFrameCooldowns(Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER, setting.stylizers)
            StylizeFrameCooldowns(Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER, setting.stylizers)
        end
    end
    AdjustFramePadding(Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER)
    AdjustFramePadding(Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER)
    AdjustFramePadding(Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER)
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
    local functions = {
        IconStylizer.RemoveOverlay,
        IconStylizer.UpdateMask,
        IconStylizer.ScaleIconTexture,
        CooldownStylizer.UpdateMask,
        CooldownStylizer.UpdateCooldownFlash,
        IconStylizer.RemoveBorder,
        IconStylizer.AddBorder,
        StacksStylizer.UpdatePosition,
        StacksStylizer.UpdateFont,
        CooldownStylizer.UpdateFont
    }
    StylizeFrameCooldowns(Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER, functions)
    StylizeFrameCooldowns(Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER, functions)
    StylizeFrameCooldowns(Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER, functions)
    AdjustFramePadding(Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER)
    AdjustFramePadding(Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER)
    AdjustFramePadding(Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER)
end

function StylizeCooldown(frame, functions)
    for _, func in ipairs(functions) do
        if type(func) == "function" then
            func(frame)
        end
    end
end

function StylizeFrameCooldowns(frameName, functions)
    local frame = rawget(_G, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end

    for _, child in ipairs({frame:GetChildren()}) do
        if type(child) == "table" and not SafetyUtils:IsForbidden(child) then
            StylizeCooldown(child, functions)
        end
    end
end

function AdjustFramePadding(frameName)
    local frame = rawget(_G, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end

    frame.childXPadding = CdmxDB.IconXPadding
    frame.childYPadding = CdmxDB.IconYPadding
    frame:Layout()
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