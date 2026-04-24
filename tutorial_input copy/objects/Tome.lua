Tome = GameObject:extend()

function Tome:new(area, x, y, opts)
    Tome.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
    self.image = EquipedTome.image
    self.rsize = {r = 0}
    self.b = false
    self.path = 1
end

function Tome:update(dt)
    if input:pressed('activeitem') then
        activeitem.func()
    end
    if activeitemactive then
        if not self.b then
            self.b = true
            self.rsize.r = math.pi*2
            timer:tween(activeitem.cooldown/playerCooldown, self.rsize, {r=0}, 'linear')
            timer:after(activeitem.cooldown/playerCooldown, function() self.rsize.r = 0 end)
            timer:after(activeitem.cooldown/playerCooldown, function() self.b = false end)
        end
    end
end

function Tome:draw()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.arc('fill', self.x+60, self.y+gh-60, 55, 0, self.rsize.r)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x+10, self.y+gh-110, 0, 2, 2)
end
