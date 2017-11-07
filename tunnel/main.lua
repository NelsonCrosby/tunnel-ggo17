
local game = nil

function love.load()
    game = {
        update = function() end,
        draw = function() end
    }
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
