Dummy = GameObject:extend()

function Dummy:new(area, x, y, opts)
    Dummy.super.new(self, area, x, y, opts)
    self.X = x+250
    self.Y = y
    self.W, self.H = 76, 122
    self.hp = 0

    self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.collider:setCollisionClass("Enemy")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Dummy:update(dt)
    self.collider:setPosition(self.X, self.Y)

    if self.collider:enter('Friendly Bullet') then
        print("Hit")
        timer:after(0.0001, function() self.hp = self.hp + LastDmg end)
    end
end

function Dummy:draw()
    love.graphics.print(self.hp, self.X, self.Y-150)
end