local private = select(2, ...)

local prototypes = {}

function private:GetPrototype(name)
    local prototype = prototypes[name] or {}
    prototypes[name] = prototype
    return prototype
end
