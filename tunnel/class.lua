-- Created as global
new = {}

-- Implements new(), which returns the constructor for cls
local function new_call(_, cls)
    return cls[new_call]
end

new.__call = new_call

-- Create a new class, using arguments as mixins
local function new_class(cls, parents)
    cls.__index = cls

    -- The default constructor
    cls[new_call] = function (...)
       local o = {}
       setmetatable(o, cls)
       if type(o.init) == 'function' then
           o:init(...)
       end
       return o
    end

    for i, parent in ipairs(parents) do
        for name, val in pairs(parent) do
           if cls[name] == nil then cls[name] = val end
        end
    end
    return cls
end

function new.class(...)
    return new_class({}, {...})
end

setmetatable(new, new)

if class_commons ~= false and common == nil then
    common = {}
    function common.class(name, cls, ...)
        return new_class(cls, {...})
    end
    function common.instance(cls, ...)
        return new(cls)(...)
    end
end

return new
