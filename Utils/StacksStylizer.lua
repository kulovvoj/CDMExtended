local private = select(2, ...)
local StacksStylizer = private:GetPrototype("StacksStylizer")

local SafetyUtils = private:GetPrototype("SafetyUtils")

function StacksStylizer.UpdateFont(frame)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local stacks = frame.Applications or frame.ChargeCount
    if type(stacks) ~= "table" then return end
    local current = stacks.Applications or stacks.Current
    if type(current) ~= "table" then return end

    local _, _, fontFlags = current:GetFont()
    current:SetFont(CdmxDB.Font, CdmxDB.StacksFontSize, fontFlags)
    stacks:SetFrameLevel(math.max(stacks:GetFrameLevel() or 1, (frame:GetFrameLevel() or 1) + 1))
end

function StacksStylizer.UpdatePosition(frame)
    if type(frame) ~= "table" or SafetyUtils:IsForbidden(frame) then return end
    local stacks = frame.Applications or frame.ChargeCount
    if type(stacks) ~= "table" then return end
    local current = stacks.Applications or stacks.Current
    if type(current) ~= "table" then return end

    current:ClearAllPoints()
    current:SetPoint("CENTER", frame, CdmxDB.StacksAnchor, CdmxDB.StacksXOffset, CdmxDB.StacksYOffset)
end