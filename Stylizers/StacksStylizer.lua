local private = select(2, ...)
local StacksStylizer = private:GetPrototype("StacksStylizer")

local SafetyUtils = private:GetPrototype("SafetyUtils")

function StacksStylizer.UpdateFont(frame, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local stacks = frame.Applications or frame.ChargeCount
    if type(stacks) ~= "table" then return end
    local current = stacks.Applications or stacks.Current
    if type(current) ~= "table" then return end

    local _, _, fontFlags = current:GetFont()
    current:SetFont(CdmxDB[frameName].Font, CdmxDB[frameName].StacksFontSize, fontFlags)
    stacks:SetFrameLevel(math.max(stacks:GetFrameLevel() or 1, (frame:GetFrameLevel() or 1) + 1))
end

function StacksStylizer.UpdatePosition(frame, frameName)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local stacks = frame.Applications or frame.ChargeCount
    if type(stacks) ~= "table" then return end
    local current = stacks.Applications or stacks.Current
    if type(current) ~= "table" then return end

    local parentLevel = frame:GetFrameLevel() or 1
    stacks:SetFrameLevel(math.max(0, parentLevel + 3))

    current:ClearAllPoints()
    current:SetPoint("CENTER", frame, CdmxDB[frameName].StacksAnchor, CdmxDB[frameName].StacksXOffset, CdmxDB[frameName].StacksYOffset)
end