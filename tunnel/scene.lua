
local Scene = new.class()

function Scene:init()
    self.entities = {}
end

function Scene:update(dt)
    for i, e in ipairs(self.entities) do
        e:update(dt)
    end
end

function Scene:draw()
    for i, e in ipairs(self.entities) do
        e:draw()
    end
end

return Scene
