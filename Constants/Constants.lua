local private = select(2, ...)
local Constants = private:GetPrototype("Constants")

local IconStylizer = private:GetPrototype("IconStylizer")
local CooldownStylizer = private:GetPrototype("CooldownStylizer")
local StacksStylizer = private:GetPrototype("StacksStylizer")
local SafetyUtils = private:GetPrototype("SafetyUtils")

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
            stylizers = { StacksStylizer.UpdatePosition }
        },
        {
            id = "Font",
            label = "Font",
            type = Constants.SettingTypesEnum.DROPDOWN,
            options = fontsList,
            stylizers = { StacksStylizer.UpdateFont, CooldownStylizer.UpdateFont }
        },
        {
            id = "StacksXOffset",
            label = "Stacks X Offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false,
            stylizers = { StacksStylizer.UpdatePosition }
        },
        {
            id = "StacksYOffset",
            label = "Stacks Y Offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false,
            stylizers = { StacksStylizer.UpdatePosition }
        },
        {
            id = "StacksFontSize",
            label = "Stacks Font Size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false,
            stylizers = { StacksStylizer.UpdateFont }
        },
        {
            id = "CooldownFontSize",
            label = "Cooldown Font Size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false,
            stylizers = { CooldownStylizer.UpdateFont }
        },
        {
            id = "IconXPadding",
            label = "Icon Padding X",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0,
            maxValue = 15,
            steps = 15,
            isPercent = false
        },
        {
            id = "IconYPadding",
            label = "Icon Padding Y",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0,
            maxValue = 15,
            steps = 15,
            isPercent = false
        },
        {
            id = "BorderSize",
            label = "Border Width",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 1,
            maxValue = 15,
            steps = 14,
            isPercent = false,
            stylizers = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        },
        {
            id = "BorderColor",
            label = "Border Color",
            type = Constants.SettingTypesEnum.COLOR_PICKER,
            stylizers = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        },
        {
            id = "BorderShown",
            label = "Show Border",
            type = Constants.SettingTypesEnum.CHECKBOX,
            stylizers = { IconStylizer.RemoveBorder, IconStylizer.AddBorder }
        }
    }
end

Constants.CdmFramesEnum = {
    ESSENTIAL_COOLDOWN_VIEWER = "EssentialCooldownViewer",
    BUFF_ICON_COOLDOWN_VIEWER = "BuffIconCooldownViewer",
    UTILITY_COOLDOWN_VIEWER = "UtilityCooldownViewer"
}

Constants.SettingTypesEnum = {
    DROPDOWN = "dropdown",
    SLIDER = "slider",
    CHECKBOX = "checkbox",
    COLOR_PICKER = "color_picker"
}

Constants.DefaultOptions = {
    [Constants.CdmFramesEnum.ESSENTIAL_COOLDOWN_VIEWER] = {
        Style = "Clean",
        BorderSize = 1,
        BorderShown = true,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksAnchor = "TOP",
        StacksFontSize = 18,
        CooldownFontSize = 20,
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        IconXPadding = 1,
        IconYPadding = 1
    },
    [Constants.CdmFramesEnum.UTILITY_COOLDOWN_VIEWER] = {
        Style = "Clean",
        BorderSize = 1,
        BorderShown = true,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksAnchor = "TOP",
        StacksFontSize = 18,
        CooldownFontSize = 20,
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        IconXPadding = 1,
        IconYPadding = 1
    },
    [Constants.CdmFramesEnum.BUFF_ICON_COOLDOWN_VIEWER] = {
        Style = "Clean",
        BorderSize = 1,
        BorderShown = true,
        BorderColor = {
            r = 0,
            g = 0,
            b = 0,
            a = 1
        },
        StacksAnchor = "TOP",
        StacksXOffset = 0,
        StacksYOffset = 0,
        StacksAnchor = "TOP",
        StacksFontSize = 18,
        CooldownFontSize = 20,
        Font = SharedMedia:Fetch("font", "Friz Quadrata TT"),
        IconXPadding = 1,
        IconYPadding = 1
    },
}

Constants.Styles = {
    Clean = {
        IconScale = .09,
        MaskTexture = "Interface\\AddOns\\CDMExtended\\Media\\SquareMask"
    }
}