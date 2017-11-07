-- Created as global
new = {}

-- Implements new(), which returns the constructor for cls
local function __call(_, cls)
    return cls[__call]
end

-- Create a new class, using arguments as mixins
local function new_class(cls, parents)
    cls.__index = cls

    -- The default constructor
    cls[__call] = function (...)
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

setmetatable(new, {__call = __call})

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
