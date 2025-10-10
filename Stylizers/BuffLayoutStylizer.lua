local private = select(2, ...)
local BuffLayoutStylizer = private:GetPrototype("BuffLayoutStylizer")

local Constants = private:GetPrototype("Constants")
local Utils = private:GetPrototype("Utils")

local GrowingLayout = {}

function GrowingLayout:Layout()
    local children = self:GetLayoutChildren()

    local function layoutChildrenHorizontal()
        local leftOffset, rightOffset, frameTopPadding, frameBottomPadding = 0, 0, 0, 0
        local spacing = self.childXPadding
        local childrenWidth, childrenHeight = 0, 0;

        for i, child in ipairs(children) do
            if (child:IsShown()) then
                local childWidth, childHeight = child:GetSize();

                childrenHeight = math.max(childrenHeight, childHeight);
                childrenWidth = childrenWidth + childWidth;
                if (i > 1) then
                    childrenWidth = childrenWidth + spacing;
                end

                -- Set child position
                child:ClearAllPoints();

                if self.childLayoutDirection == 0 then
                    if (self.align == "bottom") then
                        child:SetPoint("BOTTOMRIGHT", -rightOffset, frameBottomPadding);
                    elseif (self.align == "center") then
                        local topOffset = (frameTopPadding - frameBottomPadding) / 2;
                        child:SetPoint("RIGHT", -rightOffset, -topOffset);
                    else
                        child:SetPoint("TOPRIGHT", -rightOffset, -frameTopPadding);
                    end
                    rightOffset = rightOffset + childWidth + spacing;
                else
                    if (self.align == "bottom") then
                        child:SetPoint("BOTTOMLEFT", leftOffset, frameBottomPadding);
                    elseif (self.align == "center") then
                        local topOffset = (frameTopPadding - frameBottomPadding) / 2;
                        child:SetPoint("LEFT", leftOffset, -topOffset);
                    else
                        child:SetPoint("TOPLEFT", leftOffset, -frameTopPadding);
                    end
                    leftOffset = leftOffset + childWidth + spacing;
                end
            end
        end

        return childrenWidth, childrenHeight
    end

    local function layoutChildrenVertical()
        local frameLeftPadding, frameRightPadding, topOffset, bottomOffset = 0, 0, 0, 0;
        local spacing = self.childYPadding
        local childrenWidth, childrenHeight = 0, 0;

        for i, child in ipairs(children) do
            if (child:IsShown()) then
                local childWidth, childHeight = self:GetChildSize(child);

                childrenWidth = math.max(childrenWidth, childWidth);
                childrenHeight = childrenHeight + childHeight;
                if (i > 1) then
                    childrenHeight = childrenHeight + spacing;
                end

                -- Set child position
                child:ClearAllPoints();

                if self.childLayoutDirection == 0 then
                    if (self.align == "right") then
                        child:SetPoint("BOTTOMRIGHT", -frameRightPadding, bottomOffset);
                    elseif (self.align == "center") then
                        local leftOffset = (frameLeftPadding - frameRightPadding) / 2;
                        child:SetPoint("BOTTOM", leftOffset, bottomOffset);
                    else
                        child:SetPoint("BOTTOMLEFT", frameLeftPadding, bottomOffset);
                    end
                    bottomOffset = bottomOffset + childHeight + spacing;
                else
                    if (self.align == "right") then
                        child:SetPoint("TOPRIGHT", -frameRightPadding, -topOffset);
                    elseif (self.align == "center") then
                        local leftOffset = (frameLeftPadding - frameRightPadding) / 2;
                        child:SetPoint("TOP", leftOffset, -topOffset);
                    else
                        child:SetPoint("TOPLEFT", frameLeftPadding, -topOffset);
                    end
                    topOffset = topOffset + childHeight + spacing;
                end
            end
        end

        return childrenWidth, childrenHeight
    end

    local childrenWidth, childrenHeight
    if self.isHorizontal then
        childrenWidth, childrenHeight = layoutChildrenHorizontal()
    else
        childrenWidth, childrenHeight = layoutChildrenVertical()
    end

    self:SetSize(childrenWidth, childrenHeight);
    self:MarkClean();
end

function BuffLayoutStylizer.UpdateGrow(_, category)
    local BuffIconCooldownViewer = _G[Constants.CdmFramesEnum.BUFF]

    if (CdmxDB[category].GrowBuffs) then
        BuffIconCooldownViewer.Layout = GrowingLayout.Layout
    else
        BuffIconCooldownViewer.Layout = GridLayoutFrameMixin.Layout
    end
end

function BuffLayoutStylizer.AnimateOnShow(frame, duration, startScale)
    frame.CooldownFlash = CreateFrame("Frame", nil, frame, "BuffCooldownFlashTemplate")

    frame.CooldownFlash:Show();

    local isHidden = true
    local lockout = true

    frame:HookScript("OnShow", function()
        lockout = true
        if (isHidden) then
            isHidden = false
            frame.CooldownFlash.FlashAnim:Stop();
            frame.CooldownFlash.FlashAnim:Play();
        end
    end)
    frame:HookScript("OnHide", function()
        lockout = false
        C_Timer.After(0.1, function()
            if not lockout then
                isHidden = true
            end
        end)
    end)
end

BuffLayoutStylizer.framePool = {}

function BuffLayoutStylizer:HookItemFrames()
    local BuffIconCooldownViewer = _G["BuffIconCooldownViewer"]
    for _, itemFrame in pairs(BuffIconCooldownViewer:GetItemFrames()) do
        local isInPool = Utils.TableIncludesValue(BuffLayoutStylizer.framePool, itemFrame:GetDebugName())
        if not isInPool then
            table.insert(BuffLayoutStylizer.framePool, itemFrame:GetDebugName())
            hooksecurefunc(itemFrame, "SetShown", function(self, event)
                BuffIconCooldownViewer:MarkDirty()
            end)

            BuffLayoutStylizer.AnimateOnShow(itemFrame, 1, 0.5)
        end
    end
end

hooksecurefunc(BuffIconCooldownViewer, "RefreshLayout", function ()
    BuffLayoutStylizer:HookItemFrames()
end)