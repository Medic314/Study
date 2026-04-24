Pausemenu = GameObject:extend()

function Pausemenu:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'menu'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
end

function Pausemenu:update(dt)
    if not paused then
        self.dead = true
    end
end

function Pausemenu:draw()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, gw, gh)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('OEHGHHH YOU PAUSED IT !!', self.x, self.y+gh/2-100 - 20, gw, 'center')
end
