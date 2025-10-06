local private = select(2, ...)
local SafetyUtils = private:GetPrototype("SafetyUtils")

local Constants = private:GetPrototype("Constants")
local CdmxDB = private:GetPrototype("CdmxDB.Style")


function SafetyUtils:IsForbidden(o)
    return type(o) == "table" and o.IsForbidden and o:IsForbidden()
end

function SafetyUtils:SafeCall(obj, method, ...)
    if type(obj) ~= "table" or SafetyUtils:IsForbidden(obj) then return nil end
    local fn = obj[method]
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e, f, g = pcall(fn, obj, ...)
    if ok then return a, b, c, d, e, f, g end
    return nil
end

function SafetyUtils:ToTable(...)
    local t, n = {}, select("#", ...)
    for i = 1, n do t[i] = select(i, ...) end
    return t
end

function SafetyUtils:IsIconEmbossAtlas(a)
    return type(a) == "string" and a == "UI-HUD-CoolDownManager-IconOverlay"
end

function SafetyUtils:EnsureMask(parent, key)
    local mask = parent[key]
    if not mask or mask:IsForbidden() then
        mask = parent:CreateMaskTexture()
        parent[key] = mask
        mask:SetTexture(Constants.Styles[CdmxDB.Style].MaskTexture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
        mask:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
    end
    return mask
end