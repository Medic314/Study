Gun = Object:extend()

function Gun:new(l)
    self.l = l
    if l then self.D = -20 end
    if not l then self.D = 20 end
end

function Gun:update(dt, x, y)
    self.CX, self.CY = camera:toCameraCoords(x, y)
    self.CX = (self.CX + self.D)*sx
    self.CY = self.CY*sx
    self.X, self.Y = x, y
    self.MX, self.MY = love.mouse.getPosition()
    self.MX, self.MY = self.MX, self.MY

    camera:toCameraCoords(x, y)
    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end

    if self.l then
        if input:down('left_click', 0.25) then 
            bullet = Bullet()
            bullet_instance = bullet:new(self.x, self.y, self.rot, true)
            table.insert(bullets, bullet)
        end
    else
        if input:down('right_click', 0.5) then 
            bullet = Bullet()
            bullet_instance = bullet:new(self.x, self.y, self.rot, false)
            table.insert(bullets, bullet)
        end
    end

end

function Gun:draw()
    wiz = love.graphics.newImage("R.png")
    love.graphics.draw(wiz, self.X+self.D, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
end