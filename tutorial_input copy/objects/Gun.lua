Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)
    self.area = area
    self.X = x
    self.Y = y
    self.opts = opts
    if self.opts.l then self.D = -20 end
    if not self.opts.l then self.D = 20 end
end

function Gun:update(dt)
    self.X, self.Y = PlayerX + self.D , PlayerY
    self.CX, self.CY = camera:toCameraCoords(self.X, self.Y)
    self.CX = (self.CX + self.D)*sx
    self.CY = self.CY*sx
    self.MX, self.MY = love.mouse.getPosition()
    self.MX, self.MY = self.MX, self.MY

    camera:toCameraCoords(self.X, self.Y)
    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end

    if self.l then
        if input:down('left_click', 0.25) then 
            --bullet = Bullet()
            --bullet_instance = bullet:new(self.X, self.Y, self.rot, true)
            --table.insert(bullets, bullet)
            print('lmb')
        end
    else
        if input:down('right_click', 0.5) then 
            --bullet = Bullet()
            --bullet_instance = bullet:new(self.X, self.Y, self.rot, false)
            --table.insert(bullets, bullet)
            print('rmb')
        end
    end

end

function Gun:draw()
    wiz = love.graphics.newImage("R.png")
    love.graphics.draw(wiz, self.X, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
end