
local Game = new.class()

function Game:init()
end

function Game:update(dt)
end

function Game:draw()
    love.graphics.print('Hello, love!', 368, 275)
end

return Game
