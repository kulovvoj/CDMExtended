local private = select(2, ...)
local StacksStylizer = private:GetPrototype("StacksStylizer")

local CDMX = private:GetPrototype("CDMX")

function StacksStylizer:UpdateFont(frame)
    local stacks = frame.Applications or frame.ChargeCount
    if not stacks then return end
    local current = stacks.Applications or stacks.Current
    if not current then return end

    local _, _, fontFlags = current:GetFont()
    current:SetFont(CDMX.Options.Stacks.Font, CDMX.Options.Stacks.FontSize, fontFlags)
end

function StacksStylizer:UpdatePosition(frame)
    local stacks = frame.Applications or frame.ChargeCount
    if not stacks then return end
    local current = stacks.Applications or stacks.Current
    if not current then return end

    current:ClearAllPoints()
    current:SetPoint(CDMX.Options.Stacks.Anchor, frame, CDMX.Options.Stacks.Anchor, CDMX.Options.Stacks.XOffset, CDMX.Options.Stacks.YOffset)
end