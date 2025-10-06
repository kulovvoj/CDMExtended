local private = select(2, ...)
local FontInitializer = private:GetPrototype("FontInitializer")

local SafetyUtils = private:GetPrototype("SafetyUtils")

local SharedMedia = SafetyUtils:GetSharedMedia()

function FontInitializer:Initialize()
    local sharedMediaFonts = SharedMedia:List("font")
    for i, fontName in ipairs(sharedMediaFonts) do
        local frame = CreateFrame("Frame", nil, UIParent)
        frame:SetSize(1, 1)
        frame:SetPoint("CENTER", UIParent, "CENTER", 5000, 10 * (i - 1))

        -- 2. Create a FontString (text) inside it
        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER")
        text:SetText("Hello, World!")

        -- 3. Set font explicitly (using a Blizzard font)
        local fontPath = SharedMedia:Fetch("font", fontName)
        text:SetFont(fontPath, 10, "OUTLINE")
        frame:Show()
    end
end