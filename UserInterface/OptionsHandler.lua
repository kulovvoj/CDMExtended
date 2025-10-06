local private = select(2, ...)
local OptionsHandler = private:GetPrototype("OptionsHandler")

local UserInterfaceUtils = private:GetPrototype("UserInterfaceUtils")
local Constants = private:GetPrototype("Constants")

function OptionsHandler:CreateOptions()
    if OptionsHandler.OptionWindow then
        if OptionsHandler.OptionWindow:IsShown() then
            OptionsHandler.OptionWindow:Hide()
        else
            OptionsHandler.OptionWindow:Show()
        end
    else
        -- Define the parent frame
        OptionsHandler.OptionWindow = UserInterfaceUtils:CreateWindow(500, 450)
        OptionsHandler.OptionWindow:SetTitle("CDM Extended")

        -- Add the settings
        OptionsHandler.SettingsFrame = OptionsHandler.OptionWindow:CreateSettingsFrame()
        OptionsHandler.SettingsFrame.settingValues = CdmxDB

        -- Populate settings
        for index, setup in ipairs(Constants.Settings) do
            if (setup.type == Constants.SettingTypesEnum.SLIDER) then
                OptionsHandler.SettingsFrame:AddSlider(setup.id, index, setup.label, setup.minValue, setup.maxValue, setup.steps, 225, setup.isPercent)
            end
            if (setup.type == Constants.SettingTypesEnum.DROPDOWN) then
                OptionsHandler.SettingsFrame:AddDropdown(setup.id, index, setup.label, setup.options, 225)

            end
            if (setup.type == Constants.SettingTypesEnum.CHECKBOX) then
                OptionsHandler.SettingsFrame:AddCheckbox(setup.id, index, setup.label)
            end
            if (setup.type == Constants.SettingTypesEnum.COLOR_PICKER) then
                OptionsHandler.SettingsFrame:AddColorPicker(setup.id, index, setup.label)
            end
        end
    end

    OptionsHandler.SettingsFrame:MarkDirty()
end