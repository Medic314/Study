Player = Object:extend()

function Player:init()
    self.X = 100
    self.Y = 100
    self.DX = 0
    self.DY = 0

end

function Player:update(dt)

    if input:down('up') then self.DY = self.DY - 0.3 if self.DY < -3 then self.DY = -3 end self.Y = self.Y + self.DY end
    if input:down('left') then self.DX = self.DX - 0.3 if self.DX < -3 then self.DX = -3 end self.X = self.X + self.DX end
    if input:down('down') then self.DY = self.DY + 0.3 if self.DY > 3 then self.DY = 3 end self.Y = self.Y + self.DY end
    if input:down('right') then self.DX = self.DX + 0.3 if self.DX > 3 then self.DX = 3 end self.X = self.X + self.DX end

    if input:pressed('up') then self.DY = -0.6 end
    if input:pressed('left') then self.DX = -0.6 end
    if input:pressed('down') then self.DY = 0.6 end
    if input:pressed('right') then self.DX = 0.6 end
    

    if self.DX < 0 then self.DX = self.DX + 0.1 self.X = self.X + self.DX end
    if self.DX > 0 then self.DX = self.DX - 0.1 self.X = self.X + self.DX end
    if self.DY < 0 then self.DY = self.DY + 0.1 self.Y = self.Y + self.DY end
    if self.DY > 0 then self.DY = self.DY - 0.1 self.Y = self.Y + self.DY end
    if self.DX > -0.1 and self.DX < 0.1 then self.DX = 0 end
    if self.DY > -0.1 and self.DY < 0.1 then self.DY = 0 end
end

function Player:draw()
    wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.X, self.Y)
end