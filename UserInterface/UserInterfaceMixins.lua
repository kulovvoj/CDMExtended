local private = select(2, ...)
local UserInterfaceUtils = private:GetPrototype("UserInterfaceUtils")

-- Addon options window

CdmxOptionsMixin = {}

function CdmxOptionsMixin:OnLoad()
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
end

function CdmxOptionsMixin:SetTitle(title)
    self.Title:SetText(title)
end

function CdmxOptionsMixin:GetSettingsFrame()
    return self.Settings
end

-- Categories frame

CdmxCategoriesFrameMixin = {}

function CdmxCategoriesFrameMixin:OnLoad()
    self:GetParent().Categories = self
    self.categoryCount = 0
    self.currentCategory = nil
end

function CdmxCategoriesFrameMixin:SetCurrentCategory(value)
    self.currentCategory = value
    for i = 1, select("#", self:GetChildren()) do
        local child = select(i, self:GetChildren())
        child:UpdateState()
    end
end

function CdmxCategoriesFrameMixin:GetCurrentCategory()
    return self.currentCategory
end

function CdmxCategoriesFrameMixin:AddCategory(id, label)
    self.categoryCount = self.categoryCount + 1
    if (self.categoryCount == 1) then
        self.currentCategory = id
    end

    local category = CreateFrame("Button", nil, self, "CdmxCategoryButtonTemplate")
    category:Init(id, self.categoryCount, label)

    return category
end

-- Category button

CdmxCategoryButtonMixin = {}

function CdmxCategoryButtonMixin:Init(id, layoutIndex, label)
    self.id = id
    self.Label:SetText(label)
    self.hovered = false
    self.layoutIndex = layoutIndex
    self:UpdateState()
end

function CdmxCategoryButtonMixin:OnClick()
    self:GetParent():SetCurrentCategory(self.id)
    self:UpdateState()
end

function CdmxCategoryButtonMixin:OnEnter()
    self.hovered = true
    self:UpdateState()
end

function CdmxCategoryButtonMixin:OnLeave()
    self.hovered = false
    self:UpdateState()
end

function CdmxCategoryButtonMixin:UpdateState()
    if self:GetParent():GetCurrentCategory() == self.id then
        self.Label:SetFontObject("GameFontHighlight")
        self.Texture:SetAtlas("Options_List_Active")
        self.Texture:Show()
    elseif self.hovered then
        self.Texture:SetAtlas("Options_List_Hover");
        self.Label:SetFontObject("GameFontNormal")
        self.Texture:Show();
    else
        self.Label:SetFontObject("GameFontNormal")
        self.Texture:Hide();
    end
end

-- Settings frame

CdmxSettingsFrameMixin = {}

function CdmxSettingsFrameMixin:OnLoad()
    self:GetParent().Settings = self
    self.settingValues = {}
end

function CdmxSettingsFrameMixin:SetSettingValue(id, value)
    self.settingValues[id] = value
    self:OnSettingsChanged(id, value, self.settingCategory)
end

function CdmxSettingsFrameMixin:GetSettingValue(id)
    return self.settingValues[id]
end

function CdmxSettingsFrameMixin:OnSettingsChanged(id, value, frame)
    EventRegistry:TriggerEvent("CDMX_SettingChanged", id, value, frame)
end

function CdmxSettingsFrameMixin:RefreshChildren()
    for i = 1, select("#", self:GetChildren()) do
        local child = select(i, self:GetChildren())
        if type(child) == "table" and child.id and child.Setting then
            local value = self:GetSettingValue(child.id)
            if child.Setting.SetValue then
                child.Setting:SetValue(value)
            elseif child.Setting.SignalUpdate then
                child.Setting:SignalUpdate()
            end
        end
    end
end

function CdmxSettingsFrameMixin:CreateSettingFrame(id, layoutIndex)
    local width = self:GetWidth()
    local height = 32

    local setting = CreateFrame("Frame", nil, self, "BackdropTemplate")
    Mixin(setting, CdmxSettingMixin)

    setting.id = id
    setting:SetSize(width, height)
    setting.expand = false
    setting.layoutIndex = layoutIndex
    setting.parent = self

    return setting
end

function CdmxSettingsFrameMixin:AddDropdown(id, layoutIndex, label, options, width)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    setting:CreateLabelFrame(label)
    setting:CreateDropdownFrame(id, options, width)
end

function CdmxSettingsFrameMixin:AddSlider(id, layoutIndex, label, minValue, maxValue, steps, width, isPercent)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    setting:CreateLabelFrame(label)
    setting:CreateSliderFrame(id, minValue, maxValue, steps, width, isPercent)
end

function CdmxSettingsFrameMixin:AddCheckbox(id, layoutIndex, label)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    local label = setting:CreateLabelFrame(label)
    local checkbox = setting:CreateCheckboxFrame(id)
    label:ClearAllPoints()
    label:SetPoint("LEFT", checkbox, "RIGHT", 10, 0)
end

function CdmxSettingsFrameMixin:AddColorPicker(id, layoutIndex, label)
    local setting = self:CreateSettingFrame(id, layoutIndex)
    local label = setting:CreateLabelFrame(label)
    local colorPicker = setting:CreateColorPickerFrame(id)
    label:ClearAllPoints()
    label:SetPoint("LEFT", colorPicker, "RIGHT", 12, 0)
end

-- Single setting option

CdmxSettingMixin = {}

function CdmxSettingMixin:CreateLabelFrame(label)
    self.Label = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
    self.Label:SetPoint("LEFT", self, "LEFT")
    self.Label:SetText(label)

    return self.Label
end

function CdmxSettingMixin:CreateDropdownFrame(id, options, width)
    self.Setting = CreateFrame("DropdownButton", nil, self, "WowStyle1DropdownTemplate")
    self.Setting:SetPoint("RIGHT", self, "RIGHT")
    self.Setting:SetSize(width, 26)

    local function IsSelected(value)
        return self.parent:GetSettingValue(id) == value
    end

    local function SetSelected(value)
        if self.parent:GetSettingValue(id) == value then return end
        self.parent:SetSettingValue(id, value)
    end

    self.Setting:SetupMenu(function(_, rootDescription)
        for _, option in ipairs(options) do
            rootDescription:CreateRadio(option.text, IsSelected, SetSelected, option.value);
        end
    end)

    return self.Setting
end

function CdmxSettingMixin:CreateSliderFrame(id, minValue, maxValue, steps, width, isPercent)
    local function RoundPercent(value)
        return Round(value * 100) / 100
    end

    local FormatValue
    local RoundValue

    if isPercent then
        FormatValue = UserInterfaceUtils.FormatPercentage
        RoundValue = RoundPercent
    else
        FormatValue = UserInterfaceUtils.FormatNumber
        RoundValue = Round
    end

    self.Setting = CreateFrame("Slider", nil, self, "MinimalSliderWithSteppersTemplate")
    self.Setting:SetPoint("RIGHT", self, "RIGHT", -35, 0)
    self.Setting:SetSize(width - 35, 20)

    self.Setting:Init(self.parent:GetSettingValue(id), minValue, maxValue, steps, {[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatValue)})
    self.Setting:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, function(_, value)
        local roundedValue = RoundValue(value)
        if self.parent:GetSettingValue(id) == roundedValue then return end
        self.parent:SetSettingValue(id, roundedValue)
    end, slider)

    return self.Setting
end

function CdmxSettingMixin:CreateCheckboxFrame(id)
    self.Setting = CreateFrame("CheckButton", nil, self, "SettingsCheckboxTemplate")
    self.Setting:SetPoint("LEFT", self, "LEFT")
    self.Setting:Init(self.parent:GetSettingValue(id))

    self.Setting:RegisterCallback("OnValueChanged", function(_, value)
        if self.parent:GetSettingValue(id) == value then return end
        self.parent:SetSettingValue(id, value)
    end)
    self.Setting:SetScript("OnEnter", function() end)
    self.Setting:SetScript("OnLeave", function() end)
    return self.Setting
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

function CdmxSettingMixin:CreateColorPickerFrame(id)
    local currentColor = self.parent:GetSettingValue(id)
    self.Setting = CreateFrame("Button", nil, self, "BackdropTemplate")
    self.Setting:SetSize(26, 26)
    self.Setting:SetPoint("LEFT", self, "LEFT", 2, 0)

    self.Setting:SetBackdrop({
        bgFile = "Interface\\AddOns\\CDMExtended\\Media\\ColorPickerBackdrop", -- solid background
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- clean thin border
        tile = false, edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })


    self.Setting:SetBackdropColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)

    local function OnColorChanged()
        local newR, newG, newB = ColorPickerFrame:GetColorRGB()
        local newA = ColorPickerFrame:GetColorAlpha()
        local color = { r = newR, g = newG, b = newB, a = newA }

        local oldColor = self.parent:GetSettingValue(id)
        if oldColor.r == color.r and oldColor.g == color.g and oldColor.b == color.b and oldColor.a == color.a then
            return
        end
        self.parent:SetSettingValue(id, color)
        self.Setting:SetBackdropColor(color.r, color.g, color.b, color.a)
    end

    local function OnCanceled()
        local newR, newG, newB, newA = ColorPickerFrame:GetPreviousValues()
        local color = { r = newR, g = newG, b = newB, a = newA }

        self.parent:SetSettingValue(id, color)
        self.Setting:SetBackdropColor(color.r, color.g, color.b, color.a)
    end

    self.Setting:SetScript("OnClick", function()
        OpenColorPicker(self.parent:GetSettingValue(id), OnColorChanged, OnCanceled)
    end)

    function self.Setting:SetValue(color)
        self:SetBackdropColor(color.r, color.g, color.b, color.a)
    end

    return self.Setting
end