Circle = Object:extend()

function Circle:new(x, y, radius)
    self.x = x or 400
    self.y = y or 300
    self.radius = radius or 50
    self.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end