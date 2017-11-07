
local elements = {}

local Vec2 = new.class()
local new_Vec2 = new(Vec2)
elements.Vec2 = Vec2
elements.Point = Vec2

function Vec2.cast(x, y)
    if x.init == Vec2.init then
        return x
    else
        return new_Vec2(x, y)
    end
end

function Vec2:init(x, y)
    if y == nil then
        if x.x == nil then
            self.x = x[1]
            self.y = x[2]
        else
            self.x = x.x
            self.y = x.y
        end
    else
        self.x = x
        self.y = y
    end

    self.w = self.x
    self.h = self.y
    self[1] = self.x
    self[2] = self.y
end

function Vec2:__add(other)
    other = Vec2.cast(other)
    return new_Vec2(self.x + other.x, self.y + other.y)
end

function Vec2:__sub(other)
    other = Vec2.cast(other)
    return new_Vec2(self.x - other.x, self.y - other.y)
end

function Vec2:__mul(other)
    if type(other) == 'number' then
        return new_Vec2(self.x * other, self.y * other)
    else
        other = Vec2.cast(other)
        return new_Vec2(self.x * other.x, self.y * other.y)
    end
end

function Vec2:__div(other)
    if type(other) == 'number' then
        return new_Vec2(self.x / other, self.y / other)
    else
        other = Vec2.cast(other)
        return new_Vec2(self.x / other.x, self.y / other.y)
    end
end

function Vec2:__unm()
    return new_Vec2(-self.x, -self.y)
end

function Vec2:with(x, y)
    if x == nil then
        return new_Vec2(self.x, y)
    elseif y == nil and type(x) == 'number' then
        return new_Vec2(x, self.y)
    else
        return new_Vec2(self.x, self.y)
    end
end


local Box = new.class()
local new_Box = new(Box)
elements.Box = Box

function Box:init(x, y, w, h)
    local center = nil
    local size = nil
    if w == nil then
        center = Vec2.cast(x)
        size = Vec2.cast(y)
        x = center.x
        y = center.y
        w = size.w
        h = size.h
    else
        center = Vec2.cast(x, y)
        size = Vec2.cast(w, h)
    end

    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.center = center
    self.size = size

    halfw = w / 2
    halfh = h / 2
    self.x1 = x - halfw
    self.y1 = y - halfh
    self.x2 = x + halfw
    self.y2 = y + halfh

    self.tl = Vec2.cast(self.x1, self.y1)
    self.br = Vec2.cast(self.x2, self.y2)
end

function Box:move(x, y)
    local p = Vec2.cast(x, y)
    return self:moveto(self.x + p.x, self.y + p.y)
end

function Box:moveto(x, y)
    local p = Vec2.with(self, x, y)
    return new_Box(p.x, p.y, self.w, self.h)
end

function Box:scale(w, h)
    local s = Vec2.cast(w, h)
    return self:resize(self.w + s.w, self.h + s.h)
end

function Box:scaletl(w, h)
    local s = Vec2.cast(w, h)
    return self:resizetl(self.w + s.w, self.h + s.h)
end

function Box:scalebr(w, h)
    local s = Vec2.cast(w, h)
    return self:resizebr(self.w + s.w, self.h + s.h)
end

function Box:resize(w, h)
    local s = new_Vec2(self.w, self.h):with(w, h)
    return new_Box(self.x, self.y, s.w, s.h)
end

function Box:resizetl(w, h)
    local s1 = new_Vec2(self.w, self.h)
    local s2 = s1:with(w, h)
    local sd = (s2 - s1) / 2
    local c = new_Vec2(self.x + sd.x, self.y + sd.y)
    return new_Box(c, s2)
end

function Box:resizebr(w, h)
    local s1 = new_Vec2(self.w, self.h)
    local s2 = s1:with(w, h)
    local sd = (s2 - s1) / 2
    local c = new_Vec2(self.x - sd.x, self.y - sd.y)
    return new_Box(c, s2)
end

function Box:__add(other)
    return self:move(other)
end

function Box:__sub(other)
    return self:move(-Vec2.cast(other))
end

function Box:__mul(other)
    return self:scale(Vec2.cast(other))
end

function Box:__div(other)
    return self:scale(-Vec2.cast(other))
end


local Entity = new.class()
elements.Entity = Entity

function Entity:init(x, y)
    self.pos = Vec2.cast(x, y)
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:move(x, y)
    self.pos = self.pos + Post.cast(x, y)
    return self
end

function Entity:moveto(x, y)
    self.pos = self.pos:with(x, y)
    return self
end


local Bound = new.class()
elements.Bound = Bound

function Bound:init(x, y, w, h)
    if x == nil then
        x = self.pos
        if w ~= nil then
            y = x.y
            x = x.x
        end
    end

    self.box = new_Box(x, y, w, h)
end

function Bound:move(x, y)
    Entity.move(x, y)
    self.box = self.box:move(x, y)
    return self
end

function Bound:moveto(x, y)
    Entity.moveto(x, y)
    self.box = self.box:moveto(x, y)
    return self
end

function Bound:scale(w, h)
    self.box = self.box:scale(w, h)
    return self
end

function Bound:scalebr(w, h)
    self.box = self.box:scalebr(w, h)
    self.pos = new_Vec2(self.box.x, self.box.y)
    return self
end

function Bound:scaletl(w, h)
    self.box = self.box:scaletl(w, h)
    self.pos = new_Vec2(self.box.x, self.box.y)
    return self
end

function Bound:resize(w, h)
    self.box = self.box:resize(w, h)
    return self
end

function Bound:resizetl(w, h)
    self.box = self.box:resizetl(w, h)
    self.pos = new_Vec2(self.box.x, self.box.y)
    return self
end

function Bound:resizebr(w, h)
    self.box = self.box:resizebr(w, h)
    self.pos = new_Vec2(self.box.x, self.box.y)
    return self
end


return elements
