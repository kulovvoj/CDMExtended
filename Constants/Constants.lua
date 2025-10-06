local private = select(2, ...)
local Constants = private:GetPrototype("Constants")

local SharedMedia = LibStub("LibSharedMedia-3.0")


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
            label = "Stacks anchor",
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
            }
        },
        {
            id = "Font",
            label = "Font",
            type = Constants.SettingTypesEnum.DROPDOWN,
            options = fontsList
        },
        {
            id = "StacksXOffset",
            label = "Stacks X offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false
        },
        {
            id = "StacksYOffset",
            label = "Stacks Y offset",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = -30,
            maxValue = 30,
            steps = 60,
            isPercent = false
        },
        {
            id = "StacksFontSize",
            label = "Stacks font size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false
        },
        {
            id = "CooldownFontSize",
            label = "Cooldown font size",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 10,
            maxValue = 30,
            steps = 20,
            isPercent = false
        },
        {
            id = "Padding",
            label = "Padding",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 0,
            maxValue = 15,
            steps = 15,
            isPercent = false
        },
        {
            id = "BorderSize",
            label = "Border width",
            type = Constants.SettingTypesEnum.SLIDER,
            minValue = 1,
            maxValue = 15,
            steps = 14,
            isPercent = false
        },
        {
            id = "BorderColor",
            label = "Border color",
            type = Constants.SettingTypesEnum.COLOR_PICKER,
        },
        {
            id = "BorderShown",
            label = "Show border",
            type = Constants.SettingTypesEnum.CHECKBOX,
        }
    }
end


Constants.SettingTypesEnum = {
    DROPDOWN = "dropdown",
    SLIDER = "slider",
    CHECKBOX = "checkbox",
    COLOR_PICKER = "color_picker"
}

Constants.DefaultOptions = {
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
    Padding = 1
}


Constants.CdmFrames = {"EssentialCooldownViewer", "BuffIconCooldownViewer", "UtilityCooldownViewer"}

Constants.Styles = {
    Clean = {
        IconScale = .09,
        MaskTexture = "Interface\\AddOns\\CDMExtended\\Media\\SquareMask"
    }
}