require 'class'
local Game = require 'game'

local game = nil

function love.load()
    game = new(Game)()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
