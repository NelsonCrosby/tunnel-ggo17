local Scene = require 'scene'

local Game = new.class()

function Game:init()
    self.scene = {}
end

function Game:update(dt)
    self.scene.update(dt)
end

function Game:draw()
    self.scene.draw()
    love.graphics.print('Hello, love!', 368, 275)
end

return Game
