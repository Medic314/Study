Gun = Object:extend()

function Gun:new(l)
    if l then self.CX = 325 end
    if not l then self.CX = 315 end
    self.CY = 225
end

function Gun:update(dt, x, y)
    self.X, self.Y = x, y
    self.MX, self.MY = love.mouse.getPosition()

    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end
end

function Gun:draw()
    wiz = love.graphics.newImage("gun.png")
    print(self.rot)
    love.graphics.draw(wiz, self.X, self.Y, self.rot, 0.01, 0.01)
end