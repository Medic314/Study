Player = Object:extend()

function Player:init()
    self.X = gw/2
    self.Y = gh/2
    self.A = 300
    self.DX, self.DY = 0, 0
end

function Player:update(dt)

    if input:pressed('one') then resize(1) end
    if input:pressed('two') then resize(2) end
    if input:pressed('three') then resize(3) end

    if Input:mousepressed(1) then print('lmb') end

    if input:down('up') then self.Y = self.Y - self.A*dt end
    if input:down('left') then self.X = self.X - self.A*dt end
    if input:down('down') then self.Y = self.Y + self.A*dt end
    if input:down('right') then self.X = self.X + self.A*dt end

    if not input:down('directional_input') then
        self.DX = self.DX - (self.DX/50)
        self.DY = self.DY - (self.DY/50)

        if math.abs(self.DX) < 0.5 then self.DX = 0 end
        if math.abs(self.DY) < 0.5 then self.DY = 0 end
    end

    self.X = self.X + self.DX
    self.Y = self.Y + self.DY

end

function Player:draw()
    local wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.X-38, self.Y-61, 0, 0.30, 0.30)
end