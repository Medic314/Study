Player = Object:extend()

function Player:init()
    self.X = 100
    self.Y = 100
    self.DX = 0
    self.DY = 0
    self.outer_radius = {outer_radius = 20}
    self.radius = {radius = 10}
    self.graphic = HyperCircle(self.X, self.Y, self.radius.radius, 5, self.outer_radius.outer_radius)
    self.big = 0 
end

function Player:update(dt)
    if input:pressed('big') then if self.big == 0 then self.big = 1 else self.big = 0 end end
    if input:pressed('big') then if self.big == 1 then timer:tween(1, self.outer_radius, {outer_radius = 35}, 'in-bounce') end end
    if input:pressed('big') then if self.big == 0 then timer:tween(1, self.outer_radius, {outer_radius = 20}, 'in-bounce') end end
    if input:pressed('big') then if self.big == 1 then timer:tween(1.5, self.radius, {radius = 25}, 'in-bounce') end end
    if input:pressed('big') then if self.big == 0 then timer:tween(1.5, self.radius, {radius = 10}, 'in-bounce') end end

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
    self.graphic.x, self.graphic.y = self.X, self.Y
    self.graphic.outer_radius = self.outer_radius.outer_radius
    self.graphic.radius = self.radius.radius
    self.graphic:draw()
end