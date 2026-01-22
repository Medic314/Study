Object = require("tutorial_circles.libraries.classic.classic")
Timer = require("libraries/hump/timer")

function love.load()
    timer = Timer()
    circle = {radius = 24}
    timer:every(3.5, function() timer:after(0.5,function()
        timer:tween(2, circle, {radius = 96}, 'in-bounce', function()
            timer:tween(1, circle, {radius = 24}, 'out-quart')
        end)
    end) end)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    love.graphics.circle('fill', 400, 300, circle.radius)
end