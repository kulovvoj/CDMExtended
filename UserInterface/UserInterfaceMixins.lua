local private = select(2, ...)
local UserInterfaceMixins = private:GetPrototype("UserInterfaceMixins")

local UserInterfaceUtils = private:GetPrototype("UserInterfaceUtils")

-- Addon options window

UserInterfaceMixins.OptionsMixin = {}

function UserInterfaceMixins.OptionsMixin:OnLoad()
    self:SetPoint("CENTER")
    self:SetFrameStrata("DIALOG")

    -- Make the window draggable
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    -- Add the border
    self.Border = CreateFrame("Frame", nil, self, "DialogBorderTranslucentTemplate")

    -- Add the close button
    self.CloseButton = CreateFrame("Button", nil, self, "UIPanelCloseButton")
    self.CloseButton:SetPoint("TOPRIGHT", self, "TOPRIGHT")
    self.CloseButton:SetFrameStrata("DIALOG")
    self.CloseButton.OnClick = function (self)
        self:Hide()
    end
end

function UserInterfaceMixins.OptionsMixin:SetTitle(title)
    self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.Title:SetPoint("TOP", self, "TOP", 0, -15)
    self.Title:SetText(title)

    return self.Title
end

function UserInterfaceMixins.OptionsMixin:CreateSettingsFrame(spacing)
    self.Settings = CreateFrame("Frame", nil, self, "VerticalLayoutFrame")
    Mixin(self.Settings, UserInterfaceMixins.SettingsFrameMixin)

    self.Settings:OnLoad()
    self.Settings:SetPoint("TOP", self.Title, "BOTTOM", 0, -12)
    self.Settings.spacing = spacing or 2

    return self.Settings
end

function UserInterfaceMixins.OptionsMixin:GetSettingsFrame()
    return self.Settings
end

-- Single settings frame

UserInterfaceMixins.SettingsFrameMixin = {}

function UserInterfaceMixins.SettingsFrameMixin:OnLoad()
    self.expand = true
    self.respectChildScale = true
    self.parentWidth = self:GetWidth()
    self.parentHeight = self:GetHeight()
    self.settingValues = {}
end

function UserInterfaceMixins.SettingsFrameMixin:SetSettingValue(id, value)
    self.settingValues[id] = value
end

function UserInterfaceMixins.SettingsFrameMixin:GetSettingValue(id)
    return self.settingValues[id]
end

function UserInterfaceMixins.SettingsFrameMixin:CreateSettingFrame(id, layoutIndex)
    local parentWidth = self:GetParent():GetWidth()
    local width = parentWidth - 50
    local height = 32

    local setting = CreateFrame("Frame", nil, self, "BackdropTemplate")
    Mixin(setting, UserInterfaceMixins.SettingMixin)

    setting.id = id
    setting:SetSize(width, height)
    setting.expand = false
    setting.layoutIndex = layoutIndex
    setting.layoutIndex = layoutIndex
    setting.parent = self

    return setting
end

function UserInterfaceMixins.SettingsFrameMixin:AddDropdown(id, layoutIndex, label, options, width)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    setting:CreateLabelFrame(label)
    setting:CreateDropdownFrame(id, options, width)
end

function UserInterfaceMixins.SettingsFrameMixin:AddSlider(id, layoutIndex, label, minValue, maxValue, steps, width, isPercent)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    setting:CreateLabelFrame(label)
    setting:CreateSliderFrame(id, minValue, maxValue, steps, width, isPercent)
end

function UserInterfaceMixins.SettingsFrameMixin:AddCheckbox(id, layoutIndex, label)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    local label = setting:CreateLabelFrame(label)
    local checkbox = setting:CreateCheckboxFrame(id)
    label:ClearAllPoints()
    label:SetPoint("LEFT", checkbox, "RIGHT", 10, 0)
end

function UserInterfaceMixins.SettingsFrameMixin:AddColorPicker(id, layoutIndex, label)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    local label = setting:CreateLabelFrame(label)
    local colorPicker = setting:CreateColorPickerFrame(id)
    label:ClearAllPoints()
    label:SetPoint("LEFT", colorPicker, "RIGHT", 12, 0)
end

-- Single setting option

UserInterfaceMixins.SettingMixin = {}

function UserInterfaceMixins.SettingMixin:CreateLabelFrame(label)
    self.Label = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
    self.Label:SetPoint("LEFT", self, "LEFT")
    self.Label:SetText(label)

    return self.Label
end

function UserInterfaceMixins.SettingMixin:CreateDropdownFrame(id, options, width)
    self.Dropdown = CreateFrame("DropdownButton", nil, self, "WowStyle1DropdownTemplate")
    self.Dropdown:SetPoint("RIGHT", self, "RIGHT")
    self.Dropdown:SetSize(width, 26)

    local function IsSelected(value)
        return self.parent:GetSettingValue(id) == value
    end

    local function SetSelected(value)
        if self.parent:GetSettingValue(id) == value then return end
        self.parent:SetSettingValue(id, value)
    end

    self.Dropdown:SetupMenu(function(_, rootDescription)
        for _, option in ipairs(options) do
            rootDescription:CreateRadio(option.text, IsSelected, SetSelected, option.value);
        end
    end)

    return self.Dropdown
end

function UserInterfaceMixins.SettingMixin:CreateSliderFrame(id, minValue, maxValue, steps, width, isPercent)
    self.Slider = CreateFrame("Slider", nil, self, "MinimalSliderWithSteppersTemplate")
    self.Slider:SetPoint("RIGHT", self, "RIGHT", -35, 0)
    self.Slider:SetSize(width - 35, 20)

    -- Configure slider values
    if isPercent then
        self.Slider:Init(self.parent:GetSettingValue(id), minValue, maxValue, steps, {[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(MinimalSliderWithSteppersMixin.Label.Right, UserInterfaceUtils.FormatPercentage)})
        self.Slider:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, function(_, value)
            local roundedValue = Round(value * 100) / 100
            if self.parent:GetSettingValue(id) == roundedValue then return end
            self.parent:SetSettingValue(id, roundedValue)
        end, slider)
    else
        self.Slider:Init(self.parent:GetSettingValue(id), minValue, maxValue, steps, {[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(MinimalSliderWithSteppersMixin.Label.Right, UserInterfaceUtils.FormatNumber)})
        self.Slider:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, function(_, value)
            local roundedValue = Round(value)
            if self.parent:GetSettingValue(id) == roundedValue then return end
            self.parent:SetSettingValue(id, roundedValue)
        end, slider)
    end

    return self.Dropdown
end

function UserInterfaceMixins.SettingMixin:CreateCheckboxFrame(id)
    self.Checkbox = CreateFrame("CheckButton", nil, self, "SettingsCheckboxTemplate")
    self.Checkbox:SetPoint("LEFT", self, "LEFT")
    self.Checkbox:Init(self.parent:GetSettingValue(id))

    self.Checkbox:RegisterCallback("OnValueChanged", function(_, value)
        if self.parent:GetSettingValue(id) == value then return end
        self.parent:SetSettingValue(id, value)
    end)
    self.Checkbox:SetScript("OnEnter", function() end)
    self.Checkbox:SetScript("OnLeave", function() end)
    return self.Checkbox
end

local function OpenColorPicker(color, colorChangedCallback, cancelCallback)
    local options = {
        swatchFunc = colorChangedCallback,
        opacityFunc = colorChangedCallback,
        cancelFunc = cancelCallback,
        hasOpacity = true,
        opacity = color.a,
        r = color.r,
        g = color.g,
        b = color.b,
    }

    ColorPickerFrame:SetupColorPickerAndShow(options)
end

function UserInterfaceMixins.SettingMixin:CreateColorPickerFrame(id)
    local currentColor = self.parent:GetSettingValue(id)
    self.ColorPicker = CreateFrame("Button", nil, self, "BackdropTemplate")
    self.ColorPicker:SetSize(26, 26)
    self.ColorPicker:SetPoint("LEFT", self, "LEFT", 2, 0)

    self.ColorPicker:SetBackdrop({
        bgFile = "Interface\\AddOns\\CDMExtended\\Media\\ColorPickerBackdrop", -- solid background
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- clean thin border
        tile = false, edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })


    self.ColorPicker:SetBackdropColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)

    local function OnColorChanged()
        local newR, newG, newB = ColorPickerFrame:GetColorRGB()
        local newA = ColorPickerFrame:GetColorAlpha()
        local color = { r = newR, g = newG, b = newB, a = newA }

        local oldColor = self.parent:GetSettingValue(id)
        if oldColor.r == color.r and oldColor.g == color.g and oldColor.b == color.b and oldColor.a == color.a then
            return
        end
        self.parent:SetSettingValue(id, color)
        self.ColorPicker:SetBackdropColor(color.r, color.g, color.b, color.a)
    end

    local function OnCanceled()
        local newR, newG, newB, newA = ColorPickerFrame:GetPreviousValues()
        local color = { r = newR, g = newG, b = newB, a = newA }

        self.parent:SetSettingValue(id, color)
        self.ColorPicker:SetBackdropColor(color.r, color.g, color.b, color.a)
    end

    self.ColorPicker:SetScript("OnClick", function()
        OpenColorPicker(self.parent:GetSettingValue(id), OnColorChanged, OnCanceled)
    end)

    return self.ColorPicker
end
