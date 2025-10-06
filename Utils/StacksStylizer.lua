local private = select(2, ...)
local StacksStylizer = private:GetPrototype("StacksStylizer")

function StacksStylizer:UpdateFont(frame)
    local stacks = frame.Applications or frame.ChargeCount
    if not stacks then return end
    local current = stacks.Applications or stacks.Current
    if not current then return end

    local _, _, fontFlags = current:GetFont()
    local success = current:SetFont(CdmxDB.Font, CdmxDB.StacksFontSize, fontFlags)
    if not success then
        C_Timer.After(0.5, function()
            StacksStylizer:UpdateFont(frame)
        end)
    end
end

function StacksStylizer:UpdatePosition(frame)
    local stacks = frame.Applications or frame.ChargeCount
    if not stacks then return end
    local current = stacks.Applications or stacks.Current
    if not current then return end

    current:ClearAllPoints()
    current:SetPoint("CENTER", frame, CdmxDB.StacksAnchor, CdmxDB.StacksXOffset, CdmxDB.StacksYOffset)
end