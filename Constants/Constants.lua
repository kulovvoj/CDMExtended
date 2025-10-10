local private = select(2, ...)
local Constants = private:GetPrototype("Constants")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")
local SafetyUtils = private:GetPrototype("SafetyUtils")
local BuffLayoutStylizer = private:GetPrototype("BuffLayoutStylizer")

local SharedMedia = SafetyUtils:GetSharedMedia()

function Constants:Initialize()
    local sharedMediaFonts = SharedMedia:List("font")
    local fontsList = {}

    for _, fontName in ipairs(sharedMediaFonts) do
        local fontPath = SharedMedia:Fetch("font", fontName)
        table.insert(fontsList, { text = fontName, value = fontPath })
    end

    Constants.Settings = {
        {
            id = "GrowBuffs",
            label = "Grow Buffs",
            type = Constants.SettingTypesEnum.CHECKBOX,
            categories = { Constants.CdmFramesEnum.BUFF },
            stylizers = { BuffLayoutStylizer.UpdateGrow }
        },
        {
            id = "Font",
            label = "Font",
            type = Constants.SettingTypesEnum.DROPDOWN,
            options = fontsList,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { StacksStylizer.UpdateFont, CooldownStylizer.UpdateFont }
        },
        {
            id = "StacksAnchor",
            label = "Stacks Anchor",
            type = Constants.SettingTypesEnum.DROPDOWN,
            options = {
                { text = "Top Left", value = "TOPLEFT" },
                { text = "Top", value = "TOP" },
                { text = "Top Right", value = "TOPRIGHT" },
                { text = "Right", value = "RIGHT" },
                { text = "Bottom Right", value = "BOTTOMRIGHT" },
                { text = "Bottom", value = "BOTTOM" },
                { text = "Bottom Left", value = "BOTTOMLEFT" },
                { text = "Left", value = "LEFT" },
                { text = "Center", value = "CENTER" }
            },
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers = { StacksStylizer.UpdatePosition }
        },
        {
            id = "StacksXOffset",
            label = "Stacks X Offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { StacksStylizer.UpdatePosition }
        },
        {
            id = "StacksYOffset",
            label = "Stacks Y Offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { StacksStylizer.UpdatePosition }
        },
        {
            id = "StacksFontSize",
            label = "Stacks Font Size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { StacksStylizer.UpdateFont }
        },
        {
            id = "CooldownFontSize",
            label = "Cooldown Font Size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { CooldownStylizer.UpdateFont }
        },
        {
            id = "IconHeight",
            label = "Icon Height",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0.5,
            maxValue = 1,
            steps = 50,
            isPercent = true,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { IconStylizer.UpdateHeight }
        },
        {
            id = "IconXPadding",
            label = "Icon Padding X",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0,
            maxValue = 15,
            steps = 15,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF }
        },
        {
            id = "IconYPadding",
            label = "Icon Padding Y",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0,
            maxValue = 15,
            steps = 15,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF }
        },
        {
            id = "BorderSize",
            label = "Border Width",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 1,
            maxValue = 15,
            steps = 14,
            isPercent = false,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        },
        {
            id = "BorderColor",
            label = "Border Color",
            type = Constants.SettingTypesEnum.COLOR_PICKER,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        },
        {
            id = "BorderShown",
            label = "Show Border",
            type = Constants.SettingTypesEnum.CHECKBOX,
            categories = { Constants.CdmFramesEnum.ESSENTIAL, Constants.CdmFramesEnum.UTILITY, Constants.CdmFramesEnum.BUFF },
            stylizers  = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        }
    }
end

function Constants:GetCategorySettings(category)
    local filteredSettings = {}
    for _, setting in ipairs(Constants.Settings) do
        for _, settingCategory in ipairs(setting.categories) do
            if settingCategory == category then
                table.insert(filteredSettings, setting)
            end
        end
    end
    return filteredSettings
end

Constants.CdmFramesEnum = {
    ESSENTIAL = "EssentialCooldownViewer",
    BUFF = "BuffIconCooldownViewer",
    UTILITY = "UtilityCooldownViewer"
}

Constants.SettingTypesEnum = {
    DROPDOWN = "dropdown",
    SLIDER = "slider",
    CHECKBOX = "checkbox",
    COLOR_PICKER = "color_picker"
}

Constants.DefaultOptions = {
    [Constants.CdmFramesEnum.ESSENTIAL] = {
        Style = "Clean",
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksFontSize = 18,
        CooldownFontSize = 22,
        IconHeight = 1,
        IconXPadding = 3,
        IconYPadding = 3,
        BorderSize = 1,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        BorderShown = true
    },
    [Constants.CdmFramesEnum.UTILITY] = {
        Style = "Clean",
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksFontSize = 16,
        CooldownFontSize = 14,
        IconHeight = 1,
        IconXPadding = 3,
        IconYPadding = 3,
        BorderSize = 1,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        BorderShown = true
    },
    [Constants.CdmFramesEnum.BUFF] = {
        Style = "Clean",
        GrowBuffs = true,
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksFontSize = 18,
        CooldownFontSize = 22,
        IconHeight = 1,
        IconXPadding = 3,
        IconYPadding = 3,
        BorderSize = 1,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        BorderShown = true
    },
}

Constants.Styles = {
    Clean = {
        IconScale = .09,
        MaskTexture = "Interface\\AddOns\\CDMExtended\\Media\\SquareMask"
    }
}