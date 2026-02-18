Player = Object:extend()

function Player:init()
    self.X = gw/2
    self.Y = gh/2
    self.A = 450
    self.DX, self.DY = 0, 0
end

function Player:update(dt)
    bullets = {}

    if input:pressed('one') then resize(1) end
    if input:pressed('two') then resize(2) end
    if input:pressed('three') then resize(3) end

    if input:down('left_click', 0.125) then 
        bullet = Bullet()
        bullet:new(self.x, self.y, 0)
        table.insert(bullets, bullet)
    end
    if input:down('right_click', 0.125) then print('rmb') end

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

    for i=1, #bullets do
            bullets[i]:update(dt)
    end

end

function Player:draw()
    for i=1, #bullets do
            bullets[i]:draw()
    end
    local wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.X-38, self.Y-61, 0, 0.30, 0.30)
end