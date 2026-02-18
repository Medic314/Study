Bullet = Object:extend()

function Bullet:new(x, y, rot)
    self.x = x or player.X
    self.y = y
    self.rot = rot
    timer:after(3, function() print("fb") end)
end

function Bullet:update(dt)
        self.x = self.x + 5
        self.y = self.y + 5
end

function Bullet:draw()
        local wiz = love.graphics.newImage("evil_wizard.png")
        love.graphics.draw(wiz, self.x, self.y, self.rot, 0.1, 0.1)
end