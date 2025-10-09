local private = select(2, ...)
local OptionsHandler = private:GetPrototype("OptionsHandler")

local Constants = private:GetPrototype("Constants")
local CDMX = private:GetPrototype("CDMX")
local Utils = private:GetPrototype("Utils")

hooksecurefunc(CdmxCategoriesFrameMixin, 'SetCurrentCategory', function(_, id)
    OptionsHandler.OptionWindow.Settings.settingCategory = OptionsHandler.OptionWindow.Categories:GetCurrentCategory()
    OptionsHandler.OptionWindow.Settings.settingValues = CdmxDB[OptionsHandler.OptionWindow.Categories:GetCurrentCategory()]
    OptionsHandler.OptionWindow.Settings:UpdateChildrenData()
    OptionsHandler.OptionWindow.Settings:UpdateChildrenVisibility(OptionsHandler:GetCurrentSettingIds())
    OptionsHandler.OptionWindow.Settings:MarkDirty()
end)

function OptionsHandler:GetCurrentSettingIds()
    local settingIds = {}
    for _, setting in ipairs(Constants.Settings) do
        if Utils:TableIncludesValue(setting.categories, OptionsHandler.OptionWindow.Categories:GetCurrentCategory()) then
            table.insert(settingIds, setting.id)
        end
    end

    return settingIds
end

function OptionsHandler:InstantiateSettings()
    OptionsHandler.OptionWindow = _G["CDMXOptions"]
    OptionsHandler.OptionWindow:SetTitle("CDM Extended")

    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.ESSENTIAL, "Essentials")
    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.UTILITY, "Utilities")
    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.BUFF, "Buffs")
    OptionsHandler.OptionWindow.Categories:MarkDirty()

    OptionsHandler:InitSettings()
end

function OptionsHandler:InitSettings()
    OptionsHandler.OptionWindow.Settings.settingCategory = OptionsHandler.OptionWindow.Categories:GetCurrentCategory()
    OptionsHandler.OptionWindow.Settings.settingValues = CdmxDB[OptionsHandler.OptionWindow.Categories:GetCurrentCategory()]

    for layoutIndex, setting in ipairs(Constants.Settings) do
        if (setting.type == Constants.SettingTypesEnum.SLIDER) then
            OptionsHandler.OptionWindow.Settings:AddSlider(setting.id, layoutIndex, setting.label, setting.minValue, setting.maxValue, setting.steps, 225, setting.isPercent)
        elseif (setting.type == Constants.SettingTypesEnum.DROPDOWN) then
            OptionsHandler.OptionWindow.Settings:AddDropdown(setting.id, layoutIndex, setting.label, setting.options, 225)
        elseif (setting.type == Constants.SettingTypesEnum.CHECKBOX) then
            OptionsHandler.OptionWindow.Settings:AddCheckbox(setting.id, layoutIndex, setting.label)
        elseif (setting.type == Constants.SettingTypesEnum.COLOR_PICKER) then
            OptionsHandler.OptionWindow.Settings:AddColorPicker(setting.id, layoutIndex, setting.label)
        end
    end

    function OptionsHandler.OptionWindow.Settings:OnSettingsChanged(id, _, category)
        CDMX:RefreshSetting(id, category)
    end

    OptionsHandler.OptionWindow.Settings:UpdateChildrenVisibility(OptionsHandler:GetCurrentSettingIds())
    OptionsHandler.OptionWindow.Settings:MarkDirty()
end

function OptionsHandler:ToggleOptions()
    if OptionsHandler.OptionWindow:IsShown() then
        OptionsHandler.OptionWindow:Hide()
    else
        OptionsHandler.OptionWindow:Show()
    end
end