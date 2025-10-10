local private = select(2, ...)
local CDMX = private:GetPrototype("CDMX")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")
local BuffLayoutStylizer = private:GetPrototype("BuffLayoutStylizer")
local Constants = private:GetPrototype("Constants")
local FontInitializer = private:GetPrototype("FontInitializer")
local SafetyUtils = private:GetPrototype("SafetyUtils")
local OptionsHandler = private:GetPrototype("OptionsHandler")

CDMX.EventListener, CDMX.Events = CreateFrame("FRAME", "CDMX_EventListener"), {}

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

local function StylizeCooldown(frame, functions, category)
    for _, func in ipairs(functions) do
        if type(func) == "function" then
            func(frame, category)
        end
    end
end

local function StylizeFrameCooldowns(category, functions)
    local frame = rawget(_G, category)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end

    for _, child in ipairs({frame:GetChildren()}) do
        if type(child) == "table" and not SafetyUtils:IsForbidden(child) then
            StylizeCooldown(child, functions, category)
        end
    end
end

local function AdjustFramePadding(frameName)
    local frame = rawget(_G, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end

    frame.childXPadding = CdmxDB[frameName].IconXPadding
    frame.childYPadding = CdmxDB[frameName].IconYPadding
    frame:Layout()
end

function CDMX:RefreshSetting(id, category)
    for _, setting in ipairs(Constants:GetCategorySettings(category)) do
        if setting.id == id and setting.stylizers then
            StylizeFrameCooldowns(category, setting.stylizers)
        end
    end
    AdjustFramePadding(category)
end

local function HookViewerRefresh()
    local functions = {
        IconStylizer.RemoveOverlay,
        IconStylizer.UpdateMask,
        IconStylizer.ScaleIconTexture,
        CooldownStylizer.UpdateMask,
        CooldownStylizer.UpdateCooldownFlash,
        IconStylizer.RemoveBorder,
        IconStylizer.AddBorder,
        IconStylizer.UpdateHeight,
        StacksStylizer.UpdatePosition,
        StacksStylizer.UpdateFont,
        CooldownStylizer.UpdateFont
    }

    for _, frameName in pairs(Constants.CdmFramesEnum) do
        local frame = _G[frameName]
        hooksecurefunc(frame, "RefreshLayout", function (self)
            StylizeFrameCooldowns(frameName, functions)
            AdjustFramePadding(frameName)
            if (frameName == Constants.CdmFramesEnum.BUFF) then
                StylizeFrameCooldowns(Constants.CdmFramesEnum.BUFF, { BuffLayoutStylizer.UpdateGrow })
            end
        end)
    end
end

local function OnPlayerLogin()
    if CdmxDB == nil then
        CdmxDB = {};
    end
    Constants:Initialize()
    CopyDefaultsToDB(Constants.DefaultOptions, CdmxDB)
    FontInitializer:Initialize()
    OptionsHandler:InstantiateSettings()
    local functions = {
        IconStylizer.RemoveOverlay,
        IconStylizer.UpdateMask,
        IconStylizer.ScaleIconTexture,
        CooldownStylizer.UpdateMask,
        CooldownStylizer.UpdateCooldownFlash,
        IconStylizer.RemoveBorder,
        IconStylizer.AddBorder,
        IconStylizer.UpdateHeight,
        StacksStylizer.UpdatePosition,
        StacksStylizer.UpdateFont,
        CooldownStylizer.UpdateFont
    }

    for _, frameName in pairs(Constants.CdmFramesEnum) do
        StylizeFrameCooldowns(frameName, functions)
        AdjustFramePadding(frameName)
    end
    StylizeFrameCooldowns(Constants.CdmFramesEnum.BUFF, { BuffLayoutStylizer.UpdateGrow })

    HookViewerRefresh()
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
