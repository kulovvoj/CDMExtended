local private = select(2, ...)
local OptionsHandler = private:GetPrototype("OptionsHandler")

local UserInterfaceUtils = private:GetPrototype("UserInterfaceUtils")
local Constants = private:GetPrototype("Constants")

function OptionsHandler:CreateOptions()
    -- Define the parent frame
    local frame = UserInterfaceUtils:CreateWindow(500, 400)
    frame:SetTitle("CDM Extended")

    -- Add the settings
    local settingsFrame = frame:CreateSettingsFrame()
    settingsFrame.settingValues = CdmxDB

    -- Populate settings
    for index, setup in ipairs(Constants.Settings) do
        if (setup.type == Constants.SettingTypesEnum.SLIDER) then
            settingsFrame:AddSlider(setup.id, index, setup.label, setup.minValue, setup.maxValue, setup.steps, 225, setup.isPercent)
        end
        if (setup.type == Constants.SettingTypesEnum.DROPDOWN) then
            settingsFrame:AddDropdown(setup.id, index, setup.label, setup.options, 225)

        end
        if (setup.type == Constants.SettingTypesEnum.CHECKBOX) then
            settingsFrame:AddCheckbox(setup.id, index, setup.label)
        end
        if (setup.type == Constants.SettingTypesEnum.COLOR_PICKER) then
            settingsFrame:AddColorPicker(setup.id, index, setup.label)
        end
    end

    settingsFrame:MarkDirty()
end