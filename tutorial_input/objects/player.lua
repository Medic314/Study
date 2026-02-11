Player = Object:extend()

function Player:init()
    self.X = 0
    self.Y = 0
    self.A = 300
end

function Player:update(dt)
    if input:down('up') then self.Y = self.Y - self.A*dt end
    if input:down('left') then self.X = self.X - self.A*dt end
    if input:down('down') then self.Y = self.Y + self.A*dt end
    if input:down('right') then self.X = self.X + self.A*dt end
end

function Player:draw()
    wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.X-38, self.Y-61, 0, 0.30, 0.30)
end