local private = select(2, ...)
local OptionsHandler = private:GetPrototype("OptionsHandler")

local Constants = private:GetPrototype("Constants")
local CDMX = private:GetPrototype("CDMX")

hooksecurefunc(CdmxCategoriesFrameMixin, 'SetCurrentCategory', function(_, id)
    OptionsHandler.OptionWindow.Settings.settingCategory = OptionsHandler.OptionWindow.Categories:GetCurrentCategory()
    OptionsHandler.OptionWindow.Settings.settingValues = CdmxDB[OptionsHandler.OptionWindow.Categories:GetCurrentCategory()]
    OptionsHandler.OptionWindow.Settings:RefreshChildren()
end)

function OptionsHandler:InstantiateSettings()
    OptionsHandler.OptionWindow = _G["CDMXOptions"]
    OptionsHandler.OptionWindow:SetTitle("CDM Extended")

    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER, "Essentials")
    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER, "Utilities")
    OptionsHandler.OptionWindow.Categories:AddCategory(Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER, "Buffs")
    OptionsHandler.OptionWindow.Categories:MarkDirty()

    function OptionsHandler.OptionWindow.Settings:OnSettingsChanged(id, _, category)
        CDMX:RefreshSetting(id, category)
    end

    OptionsHandler:InitSettings()
end

function OptionsHandler:InitSettings()
    OptionsHandler.OptionWindow.Settings.settingCategory = OptionsHandler.OptionWindow.Categories:GetCurrentCategory()
    OptionsHandler.OptionWindow.Settings.settingValues = CdmxDB[OptionsHandler.OptionWindow.Categories:GetCurrentCategory()]
    for index, setup in ipairs(Constants.Settings) do
        if (setup.type == Constants.SettingTypesEnum.SLIDER) then
            OptionsHandler.OptionWindow.Settings:AddSlider(setup.id, index, setup.label, setup.minValue, setup.maxValue, setup.steps, 225, setup.isPercent)
        elseif (setup.type == Constants.SettingTypesEnum.DROPDOWN) then
            OptionsHandler.OptionWindow.Settings:AddDropdown(setup.id, index, setup.label, setup.options, 225)
        elseif (setup.type == Constants.SettingTypesEnum.CHECKBOX) then
            OptionsHandler.OptionWindow.Settings:AddCheckbox(setup.id, index, setup.label)
        elseif (setup.type == Constants.SettingTypesEnum.COLOR_PICKER) then
            OptionsHandler.OptionWindow.Settings:AddColorPicker(setup.id, index, setup.label)
        end
    end

    function OptionsHandler.OptionWindow.Settings:OnSettingsChanged(id, _, category)
        CDMX:RefreshSetting(id, category)
    end

    OptionsHandler.OptionWindow.Settings:MarkDirty()
end

function OptionsHandler:ToggleOptions()
    if OptionsHandler.OptionWindow:IsShown() then
        OptionsHandler.OptionWindow:Hide()
    else
        OptionsHandler.OptionWindow:Show()
    end
end